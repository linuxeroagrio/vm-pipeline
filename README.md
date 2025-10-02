# Playing with bootc and ci/cd: Delivering Linux Virtual Desktops

Welcome to Playing with bootc and ci/cd: Delivering Linux Virtual Desktops source code repo. This project is designed to demonstrate how to create a simple pipeline to create, configure, run and deliver Linux Virtual Desktops for end users; by initializate an empty Bare Metal OpenShift cluster with a recommended set of operators and components.

This repo is intented to provide a core set of OpenShift features that would commonly be used for running virtual machines and design ci/cd flows for serving that types of workloads in a Bare Metal Cluster. When starting out we recommend making a copy or a fork of this project on your Git based instance, since it utilizes the process of automating IT infrastructure using infrastructure as code and software development best practices such as Git, code review, and CI/CD - known as GitOps.

Once the initial components are deployed, several ArgoCD Application objects are created which are then used to install and manage the install of the operators and components on the cluster.

## Dependencies

* Running and empty OpenShift Cluster 4.19+ on Bare Metal
* [OpenShift Client (oc)](https://developers.redhat.com/learning/learn:openshift:download-and-install-red-hat-openshift-cli/resource/resources:download-and-install-oc)
* [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)
* `yq` package
* [Tekton CLI](https://tekton.dev/docs/cli/)