FROM ubuntu:22.04

RUN /usr/bin/apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC /usr/bin/apt -y -q install tzdata
RUN DEBIAN_FRONTEND=noninteractive /usr/bin/apt -y -q install apache2 \
	apache2-utils \
	bzip2 \
	curl \
	rsync \
	cpanminus \
	libapreq2-3 \
	libapache2-mod-apreq2 \
	libapache2-mod-perl2 \
	libapache2-mod-perl2-dev \
	libapache2-mod-perl2-doc \
	libapache2-request-perl \
	libhtml-restrict-perl \
	libclass-accessor-perl \
	libclass-container-perl \
	libclass-data-inheritable-perl \
	libclass-dbi-abstractsearch-perl \
	libclass-dbi-mysql-perl \
	libclass-dbi-perl \
	libcompress-raw-zlib-perl \
	libcrypt-passwdmd5-perl \
	libcryptx-perl \
	libdatetime-format-mysql-perl \
	libdatetime-perl \
	libdatetime-set-perl \
	libdatetime-timezone-perl \
	libdbd-mysql-perl \
	libdbi-perl \
	libdevel-nytprof-perl \
	libemail-stuffer-perl \
	libhtml-fromtext-perl \
	libhtml-mason-perl \
	libio-socket-ssl-perl \
	libmime-lite-perl \
	libuniversal-can-perl \
	liburi-perl \
	libtext-unidecode-perl \
	liblingua-en-numbers-ordinate-perl \
	libhtml-strip-perl \
	libmath-round-perl \
	libhtml-scrubber-perl \
	libswitch-perl \
	libjavascript-minifier-perl \
	libcss-minifier-perl \
	librest-application-perl \
	libtext-csv-perl \
	libwww-perl \
	libgeoip2-perl \
	libmaxmind-db-reader-perl \
	make \
	mariadb-client \
	mariadb-common \
	perl \
	perl-base \
	perl-doc \
	perl-modules \
	perlmagick \
	psmisc \
	ssl-cert \
	texlive \
	texlive-latex-extra \
	s3cmd \
	pv \
	geoip-database \
	geoipupdate \
	libgeoip1

RUN cpanm REST::Client
RUN cpanm Text::Undiacritic
RUN cpanm HTTP::UA::Parser
RUN cpanm JSON@4.02
RUN cpanm JSON::WebToken
RUN cpanm Crypt::JWT

# The Class DBI shipped in Ubuntu has a bug and obviously that's never getting
# fixed so I patch it here.
COPY ./lib/Class-DBI.pm.fixed /usr/share/perl5/Class/DBI.pm

COPY ./tex/electrum /usr/share/texlive/texmf-dist/tex/latex/
COPY ./tex/bera /usr/share/texlive/texmf-dist/tex/latex/

RUN mkdir -p /usr/share/texlive/texmf-dist/fonts/tfm/public/bera/
COPY ./tex/bera/tfm/ /usr/share/texlive/texmf-dist/fonts/tfm/public/bera

RUN mkdir -p /usr/share/texlive/texmf-dist/fonts/vf/public/bera/
COPY ./tex/bera/vf/ /usr/share/texlive/texmf-dist/fonts/vf/public/bera

RUN mkdir -p /usr/share/texlive/texmf-dist/fonts/type1/public/bera
COPY ./tex/bera/type1/ /usr/share/texlive/texmf-dist/fonts/type1/public/bera

RUN mkdir -p /usr/share/texlive/texmf-dist/fonts/map/dvips/bera
COPY ./tex/bera/bera.map /usr/share/texlive/texmf-dist/fonts/map/dvips/bera

RUN mktexlsr
RUN texhash
RUN updmap-sys --force --enable Map=bera.map

#RUN mkdir -p /var/lib/GeoIP/
#RUN /usr/bin/geoipupdate
#RUN systemctl enable geoipupdate.timer

RUN /usr/sbin/a2enmod apreq2
RUN /usr/sbin/a2enmod proxy
RUN /usr/sbin/a2enmod proxy_http
RUN /usr/sbin/a2enmod remoteip
RUN /usr/sbin/a2enmod lbmethod_byrequests
RUN /usr/sbin/a2enmod status

COPY ./conf/staging.tabroom.com.conf /etc/apache2/sites-available/tabroom.com.conf
RUN a2dissite 000-default
RUN a2ensite tabroom.com

COPY ./conf/envvars /etc/apache2/envvars
COPY ./conf/apache2.conf /etc/apache2/apache2.conf
COPY ./conf/perl.conf /etc/apache2/mods-enabled/perl.conf
COPY ./conf/status.conf /etc/apache2/mods-enabled/status.conf

RUN /usr/sbin/a2dismod perl
RUN /usr/sbin/a2enmod perl

COPY ./conf/mpm_prefork.conf /etc/apache2/mods-available
RUN /usr/sbin/a2dismod mpm_event
RUN /usr/sbin/a2dismod mpm_prefork
RUN /usr/sbin/a2enmod mpm_prefork

EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
