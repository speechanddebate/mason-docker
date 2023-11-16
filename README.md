# mason-docker

This repo contains the image definition files to create a Tabroom docker image
runner. 

The docker image only contains the apache/perl stack needed to run Tabroom. It
does not include the Tabroom code itself, just the packages required to run it.
That way a new code checkin to Tabroom's own code (which happens frequently)
does not kick off a (slow, expensive) build of the Docker image each time.

Specific configuration files that change depending on the run location,
General.pm configuration file and Apache configuration files, are not included
in this image and instead run from ansible for production.

PREREQUISITES TO RUN A STAGING INSTANCE:

1.  A copy of the Tabroom.com web code downloaded to /www/tabroom (or another
    location as long as you change where docker looks for it in
    docker-compose.yml).

2.  Configurations for the docker apache in /etc/tabroom.  Default versions of
    files you need are in the conf/ directory of this repo.   They will enable
    a smaller footprint apache configuration suitable for local use, and will
    enable NYT Devel performance profiling that will appear in /www/profiles. 

3.  A General.pm configuration file in /etc/tabroom.  The default skeleton of
    this file is in /www/tabroom/web/lib/Tab/General.pm.default.  You will need
    at minimum to supply a hostname that resolves on your laptop and the
    location of a MariaDB/MySQL database and credentials with the Tabroom
    schema. 

4.  (Optional) The staging container will log to your local machine using
    syslog on port 514 TCP, so you should set it to receive those logs if you
    want to be able to see them.



