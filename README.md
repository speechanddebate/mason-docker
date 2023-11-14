# mason-docker

This repo contains the image definition files to create a Tabroom docker image
runner. 

The docker image only contains the apache/perl stack needed to run Tabroom. It
does not include the Tabroom code itself, just the packages required to run it.
That way a new code checkin to Tabroom's own code (which happens frequently)
does not kick off a (slow, expensive) build of the Docker image each time.

Specific configuration files that change depending on the run location,
General.pm configuration file and Apache configuration files, are not included
in this image and instead run from ansible. 


