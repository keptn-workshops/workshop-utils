# Overview

This repo contains the source code and instructions for building and publishing a Docker image that can be used in trying or workshops for [Keptn](https://keptn.sh). This image contains utilities like the Keptn CLI and cloud provider CLI tools in
addition to to custom unix scripts.

# Travis-CI

## Setup

* Travis is configured with CI to run the pipeline on commits.
* The travis pipeline is be configured with the REGISTRY_USER and REGISTRY_PASSWORD variables.  
Goto pipeline ```more options``` for adding these as ```environment variables```

## Image versions

* The root folder has a ```version``` file witnh a value in the format of  ```Major.Minor.Patch``` that Travis-CI 
```.travis.yml``` file uses to build the tag.  The image tag is intended to map to the Keptn release such as 0.5.0

## Local development

To reduce the image files, a base Dockerfile has the common scripts and an each platform using this
base and add platform specific files.  The file naming is as follows:

```
Dockerfile_base  <-- base image

Dockerfile_aks   <-- Azure
Dockerfile_eks   <-- Amazon
Dockerfile_gke   <-- Google
Dockerfile_ocp   <-- Open Shift
Dockerfile_pks   <-- Pivotal
```

To build image, follow these steps:

1. Update the ```version``` file as required to match the keptn version.  This value used in Travis image tagging.

1. Make changes and lint the Dockerfile using this [linting tool](https://www.fromlatest.io/#/)

1. Build base image, in this example tag with 0.5.0

    ```
    docker build -t keptnworkshops/workshop-utils-base:0.5.0 -f Dockerfile_base .
    ```

1. Build google image

    ```
    docker build -t keptnworkshops/workshop-utils-gke:0.5.0 -f Dockerfile_gke .
    ```

## Testing

To test this image and scripts with no cluster setup, follow these steps.

1. Run and shell into container, in this example tag with 0.5.0 for Google

    ```
    docker run -it keptnworkshops/workshop-utils-gke:0.5.0 /bin/bash
    ```

1. Provision Cluster.  Adjust command for your target. 

    ```
    cd provision-cluster
    ./enterProvisionClusterInputs.sh
    ./provisionCluster.sh
    ```

1. Install Keptn.  Adjust command for your target.

    ```
    keptn install --platform=gke
    ```

1. Install Dynatrace OneAgent Operator

    ```
    cd install-dynatrace-operator
    ./enterDynatraceInputs.sh
    ./installDynatrace.sh
    ```

1. Expose Bridge

    ```
    cd expose-bridge
    ./exposeBridge.sh
    ```
