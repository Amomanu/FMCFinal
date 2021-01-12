# Migration Plan for AKS Cluster Upgrade


Although its possible to upgrade an AKS cluster in place, in practice it breaks things and makes the terraform unusable because the cluster state becomes out of sync with the terraform state files. For this reason, we've decided that the best course of action is to stand up a brand new cluster then migrate the data to it, and finally switch over the DNS entries.

We make sure that the DNS cutover is the last step because we want to have a chance to test the system before making it available to customers.
For this reason, we will run the terraform as if we're deploying to a different domain. We've registered a test domain: pestpressure.com. We can deploy to that. We'll need to edit the ingress as the last step to point it to the correct domain (*.arc.fmc.com) .

For testing purposes, we can edit our /etc/host file to simulate the DNS cutover before its actually executed.

## Items to migrate

1. Stop the SFTP server

    Before you take the database dump, you should stop the SFTP server. This will cause any new trap submission to be held and queued in FastField.
    This way, no new data will be sent from scouts to the old server. Once we switch over, we'll go to FastField and reprocess any failed form submissions.
    
    For fastfield make sure the ARC_API_TOKEN and the SFTP_PASSWORD remain the same for production

2. Postgresql data

    Before we can do the database migration, we need to enable access to the VM hosting postgres. By Default, it has no network security group, so you need to add one:
    
    1. Search for the "Network Interface" associated with the VM. 
    2. Add a security group to the network interface.
    3. Add a rule the the security group allowing your IP address to connect on port 5432 for postgres
    
    When this is complete you can copy the data from production to the new postgres server. 

    The [data loader utilty](https://github.com/fmcapollo/dataloader) can be used to migrate the Postgres data.
    The new database will not have the user role "read_only_user" so it should be created.
    
    ```
    
    # scale down the fmc-backend-app to replicas:0
    
    pg_dump --file "${S_DB}-${S_SCHEMA}.sql.tar" \
        --format=t \
        --host ${S_HOST} \
        --port ${S_PORT} \
        --username ${S_USERNAME} \
        "${S_DB}"

    pg_restore "${S_DB}-${S_SCHEMA}.sql.tar" \
        --host ${D_HOST} \
        --port ${D_PORT} \
        --username ${D_USERNAME} \
        --dbname "${D_DB}" \
        --clean
    
    #scale up the fmc-backend-app to replicas:2
    
    ```
    
    We also want to [copy the users and roles](https://www.postgresonline.com/journal/archives/81-Backing-up-Login-Roles-aka-Users-and-Group-Roles.html):
    
    ```
    pg_dumpall -h localhost -p 5432 -U postgres -v --globals-only > /path/to/useraccts.sql
    ```
    
3. BLOB Storage

    The [azcopy utility](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10) will be used.
    Its currently baked in to the Docker image in this repo. You will need to create SAS (Shared Access Signature) tokens for the blob containers.

    Summary:

      - generate a [read-only SAS token](https://stackoverflow.com/questions/52997859/powershell-connect-to-azure-blob-using-sas-instead-of-key) for the source BLOB container
      - generate a read-write SAS token for the destination container
      - make sure your open file descriptors limit is set sufficiently high: 
          `sudo sysctl -w kern.maxfiles=20480`
      - invoke azcopy
          ```
          azcopy login --tenant-id=9917dcc8-bdaf-4e03-928b-1e67b0d806c5
          azcopy copy \
        'https://arcprodfmc.blob.core.windows.net/media/*?sv=2019-12-12&ss=bfqt&srt=sco&sp=rl&se=2020-10-08T01:10:22Z&st=2020-10-07T17:10:22Z&spr=https&sig=Pz3Gxax2jvk8yqilZgFa%2BtT4qFp2vZLewobkQi%2FIjPQ%3D' \
        'https://arcqafmc.blob.core.windows.net/media/?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-10-08T01:09:07Z&st=2020-10-07T17:09:07Z&spr=https&sig=K%2BFuYVQeUQbY4HFL%2FcE2WtnKS2EfJu1fS%2Fi7chndo7I%3D' \
        --recursive
          ```    
          
4. Update Django tenant records

    - make sure the public.django_site table reflects the DNS name from which this is being served
    - make sure the IP address of the site is correctly recorded in the public.customer_domain table
    
5. SSL Certificates

    For the official production deployment to *.arc.fmc.com, the underlying secret however is from rapidsslcerts and nothing should need to be done to get a correct cert. (Its valid until 2021) However, if we're not deploying to *.arc.fmc.com we need to perform this step. If using pestpressure.com for testing purposes, we can use certbot to issue new correct certs from letsencrypt.com :
    
    
        ```
        certbot -d *.pestpressure.com --agree-tos --register-unsafely-without-email --manual --preferred-challenges dns  certonly

        #add TXT dns entry for challenge

        #go to /etc/letsencrypt/live/pestpressure.com

        #create the new secret
        kubectl --kubeconfig=/Users/jsnavely/.kube/config create secret tls pestpressure-cert --cert=fullchain.pem --key privkey.pem
        
        #edit the default ingress to use the new secret instead of the old. 
        ```

6. Fastfield

    The fastfield forms need to point to the correct SFTP server, using the right credentials
    This is currently deployed in ACI. FF points to the hostname sftp.arc.fmc.com
    When we deploy the new sftp server in the new cluster, we can point the DNS to the new server

7. User accounts
    - make sure database user accounts are recreated in the new database
    - firewalls must be opened for the new database
    - new passwords must be placed on the analytics machines, pointing to the new database
    - user roles (read_only_user) tested.
    - send out the new connection information to everyone who can access the app database
    
8. Edit the ingres controller in the default namespace to change the hostname from *.pestpressure.com to *.arc.fmc.com 

9. DNS

    Initially, we will deploy to a placeholder DNS entry - "pestpressure.com". Once we test, we will manually cutover the DNS to the *.arc.fmc.com DNS zone into the production subscription. We need to manually switch the IP addresses for the following hostnames:

    | Subdomain name          |
    | ----------------------- |
    | admin-arcprod           |
    | app (brazil)            |
    | app-admin               |
    | arcprod                 |
    | argentina               |
    | celerytasks-app         |
    | celerytasks-arcprod     |
    | elastic-arcprod         |
    | france                  |
    | global                  |
    | grafana-arcprod         |
    | greece                  |
    | italy                   |
    | kibana-arcprod          |
    | russia                  |
    | spain                   |
    | turkey                  |
    | usa                     |
    | *sftp*                  |
    

10. Testing

    - login
    - make sure that new trap data submissions work
    - make sure the mobile app can connect and view data.

11. Reprocess any failed FastField submissions. 

    Once testing confirms that everything is operating correctly, we can login to FastField and find any submissions in the Failed queue. When you hit the "reprocess" button, they should get submitted and picked up.
    
12. Take a backup of anything we need from the production cluster, then shut it down. We might want to leave it in place for a week just to make sure we haven't forgotten anything. When we're sure, delete the old cluster.


# Checklist
- [ ] Send email notification about the start of migration 
- [ ] Stop old SFTP
- [ ] Stop old backend
- [ ] Stop old celery
- [ ] Copy Postgres data
- [ ] Copy BLOB data
- [ ] Switch DNS
- [ ] Test
- [ ] Check backend logs
- [ ] Check for failed FastField submissions
- [ ] Send a test FastField submission
- [ ] Check sftp logs
- [ ] Send Email notification of completed migration

