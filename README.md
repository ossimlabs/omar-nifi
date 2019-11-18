# omar-nifi

O2 uses a Nifi cluster for managing data pipelines, e.g. imagery ingest.

Originally, we built and ran a tailored nifi image for openshift O2 deployments, now we use the upstream apache/nifi image with mount and entrypoint customization. O2 deployments now operate without any need for this repository, they only use the openshift template for nifi in O2-pushbutton which performs the customization in the kubernetes environment.

This repository enables you to build images that support Nifi standalone and clusters for the docker environment.

