# existdb-webstart
eXist-db java client bundled in a XAR file

## Introduction

The goal of this project is to make the build of eXist-db simpler and more 
robust by taking out the JAR signing step from the build scripts. The jar
files are solely used by the eXist-db webstart-download feature, this feature which allows to run the
eXist-db Java client via Java Webstart. Webstart requires JAR files to
be electronically signed.

At this moment the JAR files are checked-in into the GIT repostory. When JAR files
get signed this means that the files are actually modified. As a result GIT will indicate
changed files and the developer needs to be very careful  not commiting the updated
files. In addition: signing JAR files costs quite some time.

## Solution

The XAR file that is produced by this project replaces the existing eXist-db webstart 
functionality. The main improvements:

- The set of JAR files is smaller, only essential JAR files are included
- The JAR files are compressed with PACK200 technology and GZIP, making the download almost 75% smaller.

The webstart execution process works as follows:
- User clicks on java webstart (aka JNLP) link in browser
- Browser downloads the JNLP (XML) file.
- User clicks on JNLP file, the javaws(.exe) application is started
- javaws read the JNLP file: reads the location of the JNLP file from.... the JNLP document
- javaws loads the JNLP file from the previous location (yes!)
- javaws steps: download JAR files, decompress JAR files, verify signature of JAR files
- javaws starts application


## Prerequisites

- eXist-db:
  - Version 3.6 or newer (older versions might and will work, but is not tested)
  - Location is referenced as 'EXIST_HOME'
- Optional: 
  - Apache Ant (version 1.10.1)
  - Java keystore file containing commercial certificates to sign JAR files

## Build

- Edit `build.properties`, configure `exist.home`
- Run `ant` in the toplevel directory 
    - or use `$EXIST_HOME/build.sh`
- The XAR file is generated in the `build` directory


Ant actions:
- generate `webstart.keystore` when not existemt
- copy JAR files from `$EXIST_HOME`
- processes JAR files (repack)
- sign JAR files
- compress JAR files with PACK200 and GZIP

## Install

- Use the exist-db package manager to install the XAR file (see ...)

## Run

- Open the eXist-db dashboard in a web browser and select the "eXist-db Java Client" application (note that this is a different name than the Dashboard plugin included in eXist, "Java Admin Client"; both this app and that plugin have the same Java logo). Direct link (assuming a default installation; you may need to update the hostname and port number): <http://localhost:8080/exist/apps/webstart/exist.jnlp>.
or
- Paste the following command into your terminal (assuming a default installation; you may need to update the hostname and port number): `javaws http://localhost:8080/exist/apps/webstart/exist.jnlp`

## Notes

In the past Java Applets and Java Webstart applications have been used to exploit vulnerabilities. To increase
security, Sun Microsystems (Oracle) have implemented several protection steps. Unfortunately these steps
reduced the usability a bit.

Todo: add Wiki examples and FAQs
