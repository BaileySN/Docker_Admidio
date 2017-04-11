# Admidio Vereinsverwaltung im Docker


## Was ist Admidio

*Admidio ist eine kostenlose Online-Mitgliederverwaltung, die für Vereine, Gruppen und Organisationen optimiert ist. 
Sie besteht neben der klassischen Mitgliederverwaltung aus einer Vielzahl an Modulen, die in eine neue oder bestehende 
Homepage eingebaut und angepasst werden können.*

*Registrierte Benutzer eurer Homepage haben durch Admidio u.a. Zugriff auf vordefinierte und frei konfigurierbare Mitgliederlisten, 
Personenprofile und eine Terminübersicht. Außerdem können Mitglieder in Gruppen zusammengelegt, Eigenschaften zugeordnet 
und nach diesen gesucht werden. [(c) Admidio.org 2017](https://www.admidio.org/dokuwiki/doku.php?id=de:2.0:index)*

Kurz gesagt, es ist ein Wahnsinns Online Tool für Vereine aller größen.

## Inhalt

[**Warum Docker**](#warum-docker)

---

[**Container über Dockerhub Downloaden**](#container-%C3%BCber-dockerhub-downloaden)
[**Container erstellen**](#container-erstellen)
[**Container mit Docker Befehl erstellen**](#container-mit-docker-befehl-erstellen)
[**Container starten**](#container-starten)

---

[**Erklärung zu dem Start Befehl**](#erkl%C3%A4rung-zu-dem-start-befehl)
[**Container updaten**](#container-updaten)
[**Container über Git updaten*](#container-%C3%BCber-git-updaten)

---

[**Admidio Wiki**](#wiki-zu-admidio)

---

[**MySQL Benutzer und Datenbank in der Mysql-Shell erstellen**](#mysql-benutzer-und-datenbank-in-der-mysql-shell-erstellen)

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

Um den Container selber Lokal zu erstellen, muss man das Git Repositority [Docker_Admidio](https://github.com/BaileySN/Docker_Admidio.git) downloaden oder Clonen.

Danach in den Ordner wechseln und mit dem *docker_build.sh* Skript den Container erstellen.
```bash
sh docker_build.sh
```
Dabei wird der Container jetzt mit dem Branch *master* erstellt.

Falls man einen Speziellen Branch braucht, muss man noch den Befehl um die Branch bezeichnung erweitern.
```bash
sh docker_build.sh v3.2
```

### Container mit Docker Befehl erstellen

Der Container wird mit diesem Befehl automatisch mit dem Branch *master* erstellt.

```bash
docker build -t admidio_test .
```

Für einen Speziellen Branch, gibt man noch *--build-arg branch=Branch-Bezeichnung* an.

```bash
docker build -t admidio_test --build-arg branch=v3.2 .
```

Im Kompillierungsprozess wird die Datei *admidio_apache.conf* automatisch in den Container kopiert und eingerichtet.

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

### Erklärung zu dem Start Befehl

Bei diesem Beispiel

```bash
docker run -it --restart always --name admidio_test -p 8080:80 -v /var/admidio:/var/www/admidio/adm_my_files --link dockermysql:mysql admidio:3.2.8
```
* *--restart always* => auch nach einem Server Neustart den Container starten
* *--name* => gib dem Container einen Namen (sonst wird einer Automatisch generiert)
* *-p 8080:80* => Einen Port angeben, über dem man danach zugreifen kann (**lokal am Server**:**apache2 Port im Container**).
Dadurch könnte man z.B.: den Container auch über Port *8081* erreichen indem man es so angibt *-p 8081:80*.
* *-v /var/admidio:/var/www/admidio/adm_my_files* => Uploads und config von Admidio Lokal in einen Ordner speichern.
Der Vorteil dabei ist, das man einfacher ein Backup erstellen kann. Dabei wird zuerst der Lokale Ordnerpfad angeben, danach den 
Pfad im Container.

Folgende Pfade gibt es:
```bash
:/var/www/admidio/adm_my_files
:/var/www/admidio/adm_plugins
:/var/www/admidio/adm_themes
```

* *--link dockermysql:mysql* => Docker Datenbank Server [MySQL](https://hub.docker.com/r/mysql/mysql-server/) oder [PostgreSQL](https://hub.docker.com/_/postgres/) mit dem Container Admidio verbinden. *dockermysql* = Name vom Docker Container, *mysql* = Name der Datenbank.
* *admidio:3.2.8* => Image Name mit Versions Tag.

## Container updaten

Falls man es mit dem Docker Hub Repo verwendet, kann man folgende schritte durchführen.

* Download aktuelles Repo vom Docker Hub
```bash
docker pull guenterbailey/admidio:latest
```
* Den aktuellen *Admidio_test* Container anhalten
```bash
docker stop admidio_test
```
* Container entfernen (Docker löscht dabei die Daten im *adm_my_files* nicht)
```bash
docker rm admidio_test
```
* Mit folgendem Befehl den neuen Container Provisionieren und Starten (dabei kann der alte Befehl verwendet werden).
```bash
docker run -it --restart always --name admidio_test -p 8080:80 -v /var/admidio:/var/www/admidio/adm_my_files --link dockermysql:mysql guenterbailey/admidio:latest
```
* Über einen Browser auf die Admidio Seite gehen und falls nötig die Migration durchführen.
* Fertig!

### Container über Git updaten

Mit *Git pull* im aktuellen Ordner, das Git Repo updaten und den Container neu Bauen.
```bash
git pull
```

```bash
docker build -t admidio_test .
```
Das Container update selber ist wieder das gleiche, wie oben Beschrieben ohne dem Docker Hub Teil.

# Wiki zu Admidio

[Admidio Wiki](https://www.admidio.org/dokuwiki/doku.php?id=de:2.0:index)

# Zum Abschluss

Falls es Anregungen gibt, bitte über Github oder Dockerhub eine Anfrage erstellen. (Hört sich etwas Komisch an, ist aber gut gemeint).


# MySQL Benutzer und Datenbank in der MySQL Shell erstellen

```mysql
CREATE USER 'admidio'@'%' IDENTIFIED BY 'geheim';
CREATE DATABASE IF NOT EXISTS admidio;
GRANT ALL ON admidio.* TO 'admidio'@'%';
FLUSH PRIVILEGES;
quit;
```

