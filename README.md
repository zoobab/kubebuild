Build Docker containers inside Kubernetes cluster
=================================================

This is WIP...

Requirements
============

1. The GIT repo you are cloning should have a /Dockerfile
2. You should be able to launch privileged containers inside your Kubernetes cluster
3. You should have `kubectl, sed, bash` available in your $PATH.

Usage
=====

```
$ ./kubebuild.sh http://github.com/zoobab/versaloon.git
```

Example
=======

```
$ ./kubebuild.sh https://github.com/zoobab/versaloon.git
[1/4] Templating (with repo named 'versaloon')...OK
[2/4] Launching in kubernetes...
pod "kubebuild" created
[3/4] Waiting for pod, current status ContainerCreating
[3/4] Waiting for pod, current status ContainerCreating
[3/4] Waiting for pod, current status ContainerCreating
[4/4] Tail the log...
Launching docker...OK
REPONAME is defined as versaloon, trying to build it...
Sending build context to Docker daemon  23.44MB
Step 1/16 : FROM ubuntu:14.04
14.04: Pulling from library/ubuntu
c954d15f947c: Pulling fs layer
c3688624ef2b: Pulling fs layer
848fe4263b3b: Pulling fs layer
23b4459d3b04: Pulling fs layer
36ab3b56c8f1: Pulling fs layer
23b4459d3b04: Waiting
36ab3b56c8f1: Waiting
848fe4263b3b: Verifying Checksum
848fe4263b3b: Download complete
c3688624ef2b: Verifying Checksum
c3688624ef2b: Download complete
23b4459d3b04: Verifying Checksum
23b4459d3b04: Download complete
36ab3b56c8f1: Verifying Checksum
36ab3b56c8f1: Download complete
c954d15f947c: Verifying Checksum
c954d15f947c: Download complete
c954d15f947c: Pull complete
c3688624ef2b: Pull complete
848fe4263b3b: Pull complete
23b4459d3b04: Pull complete
36ab3b56c8f1: Pull complete
Digest: sha256:e1c8bff470c771c6e86d3166607e2c74e6986b05bf339784a9cab70e0e03c7c3
Status: Downloaded newer image for ubuntu:14.04
 ---> dc4491992653
Step 2/16 : MAINTAINER Benjamin Henrion <zoobab@gmail.com>
[...]
```

Add more logs here...

Todo
====

* add a logging argument
* add a status at the end of the build
* add a timeout to kill the pod in case the build takes too much time
* add an argument to specify the amount of resources you want to allocate to the build
* specify a registry to push to (as argument or a config file)
* specify which commithash or branch to build
* check if kubectl is working (cluster-info might be enough)
* problem: gitRepo in kubernetes seems to hang forever if the repo is not existing
* problem: wait for the pod to be up and in a running state with a timeout
* run the final image on the cluster
* document how to run it in OpenShift cluster, which disables non-root containers by default
* git clone locally and push the repo with some transport (kubectl equivalent for scp) to the cluster
* use a job instead of a pod

Openshift
=========

Openshift disables non-root containers by default:

```
$ ./kubebuild.sh https://github.com/zoobab/versaloon.git
[1/4] Templating (with repo named 'versaloon')...OK
[2/4] Launching pod 'kubebuild-7588' in kubernetes...
Error from server (Forbidden): error when creating "/tmp/kubebuild.yaml": pods "kubebuild-7588" is forbidden: unable to validate against any security context constraint: [spec.volumes[0]: Invalid value: "gitRepo": gitRepo volumes are not allowed to be used spec.containers[0].securityContext.privileged: Invalid value: true: Privileged containers are not allowed]
```

Links
=====

* Kaniko: build images inside Kubernetes without privileged mode https://cloudplatform.googleblog.com/2018/04/introducing-kaniko-Build-container-images-in-Kubernetes-and-Google-Container-Builder-even-without-root-access.html
* Kubernetes issue #1806: Figure out how to support docker build on Kubernetes: https://github.com/kubernetes/kubernetes/issues/1806
* similar project: https://github.com/dminkovsky/kube-cloud-build
* CloudBees Docker Build and Publish plugin: https://wiki.jenkins.io/display/JENKINS/CloudBees+Docker+Build+and+Publish+plugin
