FROM debian:jessie
MAINTAINER Guenter Bailey

# install required packages
RUN apt-get update
RUN apt-get install -y apache2 libapache2-mod-php5 php5 php5-common php5-mcrypt php5-mysql php5-cli php5-gd zip unzip gzip php5-pgsql

# set enviroments
ENV APACHECONF="/etc/apache2/sites-available"
ENV WWW="/var/www"
ENV ADMINST="admidio-3.2.8"
ENV ADM="admidio"

COPY admidio_apache.conf $APACHECONF/"admidio.conf"
COPY $ADMINST.zip $WWW/

WORKDIR $WWW
#RUN rm "index.nginx-debian.html"
RUN a2dissite 000-default.conf && a2ensite admidio.conf
RUN unzip $ADMINST.zip && mv $ADMINST $ADM && chown -R www-data:www-data $ADM
RUN chmod -R 777 $ADM/adm_my_files
RUN rm $WWW/$ADMINST.zip
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/g" /etc/php5/apache2/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 40M/g" /etc/php5/apache2/php.ini

VOLUME ["$WWW/$ADM/", "$APACHECONF"]

# Port to expose
EXPOSE 80

CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["apachectl"]
