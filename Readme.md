# Admidio Vereinsverwaltung im Docker


## Was ist Admidio

*Admidio ist eine kostenlose Online-Mitgliederverwaltung, die für Vereine, Gruppen und Organisationen optimiert ist. 
Sie besteht neben der klassischen Mitgliederverwaltung aus einer Vielzahl an Modulen, die in eine neue oder bestehende 
Homepage eingebaut und angepasst werden können.*

*Registrierte Benutzer eurer Homepage haben durch Admidio u.a. Zugriff auf vordefinierte und frei konfigurierbare Mitgliederlisten, 
Personenprofile und eine Terminübersicht. Außerdem können Mitglieder in Gruppen zusammengelegt, Eigenschaften zugeordnet 
und nach diesen gesucht werden. [(c) Admidio.org 2017](https://www.admidio.org/dokuwiki/doku.php?id=de:2.0:index)*

Kurz gesagt, es ist ein Wahnsinns Online Tool für Vereine aller größen.

## Warum Docker

Da ich selber mehrere Server mit Docker verbunden habe, wollte ich jetzt für unseren Verein nicht wieder einen extra Webserver 
einrichten.

Natürlich würde vielleicht ein Webhoster auch gehen, da wir aber Bilder oben haben und es nicht weniger wird, ist ein günstiger 
Webhoster mit ca. 50GB Webspace eher schwer zu finden.

Und es gibt auch immer mehr Cloud Anbieter die mit Container Technik arbeiten z.b.: [Google Container Engine GCE](https://cloud.google.com/container-engine/), 
[Amazon EC2 Container Service](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html),... 

Darum habe ich mir gedacht, warum nicht das in einem [Docker Container](https://hub.docker.com) einbauen.

## Container über Dockerhub Downloaden

Den Fertigen Container kann man einfach per [docker pull guenterbailey/admidio:latest](https://hub.docker.com/r/guenterbailey/admidio/) downloaden.

## Container erstellen

Um den Container selber Lokal zu erstellen, das Repositority downloaden oder Clonen.

Danach in den Ordner gehen und entweder direkt mit 
```bash
docker build -t admidio_test .
```
oder mit dem Skript den Container erstellen.
```bash
sh docker_build.sh
```

Im Kompillierungsprozess werden die Dateien *admidio_apache.conf* und *admidio-3.2.8.zip* automatisch in den Kontainer kopiert und eingerichtet.

### Container starten

Nach dem Erstellungsprozess kann man den Container mit folgendem Befehl starten (Provisionieren).

```bash
docker run -it --restart always --name admidio_test -p 8080:80 -v /var/admidio:/var/www/admidio/adm_my_files admidio:3.2.8
```
Danach über den Browser die Seite *http://localhost:8080/* aufrufen und das Admidio Setup durchgehen.

Falls man einen Docker basierte Datenbank hat, kann man die Datenbank mit dem Container verlinken und braucht nicht die IP-Addresse eingeben.

```bash
docker run -it --restart always --name admidio_test -p 8080:80 -v /var/admidio:/var/www/admidio/adm_my_files --link dockermysql:mysql admidio:3.2.8
```
Jetzt haben wir den Befehl *--link dockermysql:mysql* zum start hinzugegeben.

Dabei kann jetzt im Admidio Setup bei der Datenbank statt die IP-Addresse der Containername *dockermysql* eingeben werden und als Datenbank *mysql*.

