#!/bin/bash
docker build . -t tform
docker run -it \
    --mount type=bind,src=$(pwd),target=/infrastructure \
    tform:latest \
    /bin/bash
