# OMAR NIFI

## Purpose

OMAR-nifi is an application for creating step-by-step data workflows through a interactive visual UI.

## Installation in Openshift

**Assumption:** The omar-nifi docker image is pushed into the OpenShift server's internal docker registry and available to the project.

### Persistent Volumes

NIFI requires shared access to OSSIM imagery data. This data is assumed to be accessible from the local filesystem of the pod. Therefore, a volume mount must be mapped into the container. A PersistentVolumeClaim should be mounted to a configured location (see environment variables) in the service, but is typically */data*

### Environment variables

|Variable|Value|
|------|------|
|NIFI_WEB_HTTP_HOST|IP address for the host that NIFI is running on (*e.g. 0.0.0.0*)|
