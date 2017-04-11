FROM debian:stretch
MAINTAINER Guenter Bailey

# since docker v1.9, we can use --build-arg variable
# https://docs.docker.com/engine/reference/builder/#arg
ARG branch
ENV ADM_BRANCH=${branch:-master}

# install required packages
RUN apt-get update
RUN apt-get install -y apache2 libapache2-mod-php php php-common php-mcrypt php-mysql php-cli php-gd zip unzip gzip php-pgsql git

# set enviroments
ENV GITURL="https://github.com/Admidio/admidio.git"
ENV APACHECONF="/etc/apache2/sites-available"
ENV WWW="/var/www"
ENV ADM="admidio"
ENV PROV="provision"

COPY admidio_apache.conf $APACHECONF/"admidio.conf"
COPY entrypoint.sh /"entrypoint.sh"

WORKDIR $WWW
RUN a2dissite 000-default.conf && a2ensite admidio.conf

#Admidio Git
RUN echo "Clone Admidio from GiT with Branch $ADM_BRANCH" && \
git clone --depth 1 --single-branch --branch $ADM_BRANCH https://github.com/Admidio/admidio.git $ADM && \
chown -R www-data:www-data $ADM && \
chmod -R 777 $ADM/adm_my_files && \
apt-get autoremove -y && \
apt-get autoclean -y && \
apt-get clean

#create prov folder
RUN mkdir -p $PROV && \
cp -a $ADM/adm_my_files $ADM/adm_plugins $ADM/adm_themes $PROV/

RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/g" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 40M/g" /etc/php/7.0/apache2/php.ini

VOLUME ["$WWW/$ADM/adm_my_files", "$WWW/$ADM/adm_themes", "$WWW/$ADM/adm_plugins" ,"$APACHECONF"]

# Port to expose
EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
