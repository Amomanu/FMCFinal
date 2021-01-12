FROM ubuntu:18.04
USER root
ENV TZ=US/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y build-essential curl lsb-core software-properties-common \
    ca-certificates apt-transport-https lsb-release gnupg git jq
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN curl https://get.helm.sh/helm-v3.3.3-linux-amd64.tar.gz --output /tmp/helm.tar.gz
RUN curl "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" --output /tmp/kubectl
RUN chmod a+x /tmp/kubectl
RUN mv /tmp/kubectl /usr/local/bin
RUN tar xvfz /tmp/helm.tar.gz -C /usr/local/bin
ENV PATH="/usr/local/bin/linux-amd64:${PATH}"
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/azure-cli.list
WORKDIR /infrastructure
RUN apt-get update && apt-get install -y python3 python3-pip terraform azure-cli wget vim
RUN wget https://aka.ms/downloadazcopy-v10-linux -O /tmp/azcopy.tar.gz
RUN tar xvfz /tmp/azcopy.tar.gz -C /tmp
RUN cp /tmp/azcopy_linux_amd64_10.8.0/azcopy /usr/local/bin/
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt
