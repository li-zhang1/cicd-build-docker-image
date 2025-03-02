# AWS CodeBuild: Build and Push Docker Image to Docker Hub

## Overview

This project uses AWS CodeBuild to automate the process of building a Docker image and pushing it to Docker Hub. CodeBuild pulls the source code, builds the Docker image, and then pushes it to the specified Docker Hub repository.

## Prerequisites

- An AWS account with CodeBuild configured.
- A Docker Hub account.
- An AWS IAM role with permissions for CodeBuild and access to Amazon ECR (if used as an alternative to Docker Hub).
- A Git repository containing your Dockerfile and application source code.

## Setup

### 1. Create an AWS CodeBuild Project

1. Navigate to the AWS CodeBuild console.
2. Click **Create build project**.
3. Provide a **Project name**.
4. Select **Source** as the repository where your Dockerfile is stored.
5. Choose the **Environment**:
   - Select **Managed image**
   - Choose **Ubuntu** as the operating system
   - Select **Standard** runtime
   - Choose the latest image
   - Select **Linux** for Environment type
   - Check **Enable Privileged Mode** to allow Docker operations
6. Under **Buildspec**, choose "Insert build commands" and use a `buildspec.yml` file (see below).
7. Under **Artifacts**, select "No artifacts" unless needed.
8. Under **Service role**, create or select an IAM role with the necessary permissions.
9. Click **Create build project**.

### 2. Create a `buildspec.yml` File

Place the following `buildspec.yml` file in the root directory of your source repository:

```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.x

  pre_build:
    commands:
      - chmod +x build-image.sh
      - chmod +x push-image.sh
      - ./build-image.sh

  build:
    commands:
      - ./push-image.sh
```

### 3. Set Up Environment Variables

- Go to your CodeBuild project settings.
- Under "Environment variables," add:
  - `DOCKER_HUB_USERNAME` (Your Docker Hub username)
  - `DOCKER_HUB_PASSWORD` (Your Docker Hub password, stored securely)
  - `DOCKER_HUB_REPO_NAME` (Your Docker Hub repo name)
  - `IMAGE_TAG` (Your Docker image name)

### 4. Start a Build

- Navigate to your CodeBuild project.
- Click **Start build**.
- Monitor logs in the "Build details" section.
- If successful, verify that the Docker image is pushed to Docker Hub.

## Troubleshooting

### Error: `toomanyrequests: You have reached your unauthenticated pull rate limit.`

If you encounter this error, it means you've exceeded Docker Hub's unauthenticated pull rate limit.

**Solution:**

1. **Authenticate with Docker Hub** (Recommended): If you have a Docker Hub account (or can create one), log in to Docker to increase the rate limit.

   Ensure you have set up Docker Hub authentication in your `buildspec.yml` using the following commands:

   ```bash
        #!/bin/bash

        # fail on any error
        set -eu 

        # login to your docker hub account
        docker login --username $DOCKER_HUB_USERNAME --password $DOCKER_HUB_PASSWORD

        # build the docker image
        docker build -f $IMAGE_TAG/Dockerfile -t $IMAGE_TAG .

   ```

2. **Verify Credentials**: Confirm your `DOCKER_HUB_USERNAME` and `DOCKER_HUB_PASSWORD` environment variables are set correctly in your AWS CodeBuild project.

More details: [Increase Docker Hub Rate Limit](https://www.docker.com/increase-rate-limit)


## Conclusion

This setup enables automatic Docker image builds and pushes using AWS CodeBuild. You can integrate this with CI/CD workflows to streamline deployments.




