# mason-docker

This repo contains the image definition files to create a Tabroom docker image
runner. 

The docker image only contains the apache/perl stack needed to run Tabroom. It
does not include the Tabroom code itself, just the packages required to run it.
That way a new code checkin to Tabroom's own code (which happens frequently)
does not kick off a (slow, expensive) build of the Docker image each time.

General.pm configuration file and production Apache configuration files are not included
in this image and instead run from ansible for production.

PREREQUISITES TO RUN A STAGING INSTANCE:

1.  A copy of the Tabroom.com web code downloaded to /www/tabroom (or another
    location as long as you set the appropriate .env variables used in
    docker-compose.yml). Unless you change the .env variables, you also need to create
    ./web/tmp and ./web/mason directories in your local copy of the repo and chmod
    them to 777

2.  Build the local sources.js by installing JavaScript::Minifier:
    `sudo apt install libjavascript-minifier-perl`
    Then run the build.pl script in the tabroom repo at
    /www/tabroom/web/lib/javascript/build.pl

3.  If necessary, change default versions of conf files in the conf/ directory
    of this repo.   By default, they will enable a smaller footprint apache configuration
    suitable for local use, and will enable NYT Devel performance profiling that will 
    appear in /www/profiles. 

4.  A General.pm configuration file in /etc/tabroom or at the location specified in a
    .env file.  The default skeleton of this file is in
    /www/tabroom/web/lib/Tab/General.pm.default.
    You will need at minimum to supply a hostname that resolves on your laptop, the
    location of a MariaDB/MySQL database and credentials with the Tabroom
    schema, and set the data_dir to the location of the mason cache.

5.  You can set environment variables in a .env file in the root of the repo to override
    variables specified in the docker-compose file.

6.  (Optional) The staging container will log to your local machine using
    syslog on port 514 TCP, so you should set it to receive those logs if you
    want to be able to see them. Otherwise you may need to disable the syslog stanzas in General.pm
