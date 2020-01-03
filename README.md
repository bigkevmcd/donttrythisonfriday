# Deploying the Taxi app

This is a repository for deploying the demo Tekton GitHub integration app.

## Requirements

 * A Quay.io account that you can generate read/write credentials for.
 * A pull-secret for the Docker image repository, if your repository is public, you may not need this, and may need to edit the files, see [Quay pull secrets](#quay-pull-secrets) below for how to do this for Quay.io.
 * A Docker configuration to access your image host, if you're using Quay.io, see [Quay docker config](#quay-docker-config) for instructions.
 * A running OpenShift cluster that can be exposed to the internet - and you must be logged in at the command-line.
 * Two GitHub repositories, a main repo e.g. `bigkevmcd/taxi` and a configuration repo `bigkevmcd/taxi-stage-config`, the `stage-config` name is derived automatically from the main repo.
 * A Personal GitHub auth token, placed into a file called `$HOME/Downloads/token" see https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line

## Updating the configuration

 ```shell
 $ ./setup.sh <QUAYIO_USERNAME> <main github repository>
 ```

## Bootstrapping the configuration

 ```shell
 $ cd pipelines && ./bootstrap.sh
 ```

At this point, a lot of YAML files and things will scroll down the screen, and
it will take some time for new containers to be spawned.

## ArgoCD support

If you want ArgoCD support, then you'll need to do further configuration.

 ```shell
 $ cd pipelines && ./argo_setup.sh
 ```

## Public Image Repositories

TODO

## Quay Pull Secrets

Visit the settings page for your Quay.io account `"https://quay.io/user/<USERNAME>?tab=settings"`

You'll be prompted to authenticate, and then you'll get a screen that allows you download credential, pick the "Kubernetes Secret" on the left hand of the
screen.

On this screen, there is a link below "Step 1", to download your secret "Download <USERNAME>-secret.yml", download this file and leave it in $HOME/Downloads.

## Quay Docker Config

Visit the settings page for your Quay.io account `"https://quay.io/user/<USERNAME>?tab=settings"`

You'll be prompted to authenticate, and then you'll get a screen that allows you download credential, pick the "Docker Configuraiton" on the left hand of the screen.

On this screen, there is a link below "Step 1", to download your secret "Download <USERNAME>-auth.json", download this file and leave it in $HOME/Downloads.
