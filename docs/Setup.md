# Setup Document
This document will guide you through the process of installing surrounding tooling used to contribute to this project. This guide assumes that your are running some flavor of Linux or WSL.

## Pre-Commit

### Overview
Pre-commit is a framework for managing and maintaining multi-language pre-commit hooks. Pre-commit hooks are scripts that run automatically before each commit to check for any errors or issues, such as syntax errors, unresolved references, and more. They help in maintaining the quality of the code.

### Installation

There are numerous ways to install pre-commit following the [official documentation](https://pre-commit.com/#install). 

### Post Install

Once installed to setup hooks locally for this project simply run the command `pre-commit install` at the root of the projects.

## Docker

### Overview

Docker is an open-source platform that automates the deployment, scaling, and management of applications. It uses containerization technology to package an application and its dependencies into a standardized unit for software development. Docker containers are lightweight and can run directly on the host machine's OS or on virtual machines, sharing the OS kernel, binaries, and libraries, thus requiring less resources than traditional hardware virtualization approaches.


### Installation 

To install Docker, you can follow the [official Docker documentation]( https://docs.docker.com/engine/install/).

## AWS CLI 

### Overview
The AWS Command Line Interface (AWS CLI) is a unified tool that allows you to manage and interact with AWS services from your terminal. One of its uses is to generate tokens for local authentication. This is particularly useful when you are developing applications that interact with AWS services. By generating tokens locally, you can authenticate your requests to AWS services without having to hardcode your AWS credentials in your application.

The AWS CLI uses the Secure Token Service (STS) to generate temporary security credentials. These credentials consist of an access key ID, a secret access key, and a security token which you can use to authenticate your requests.

### Installation 

To install the AWS CLI you can follow the [official AWS Documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)


## Terraform

### Overview
Terraform is an open-source Infrastructure as Code (IaC) tool. It's used for us to define and manage AWS data center infrastructure using a declarative configuration language, simplifying the creation, management, and updating of large scale distributed systems.

### Installation 
To install Terraform, follow the [official HashiCorp Documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

