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

Todo
====

* add a logging argument
* add a status at the end of the build
* add a timeout to kill the pod in case the build takes too much time
* add an argument to specify the amount of resources you want to allocate to the build
