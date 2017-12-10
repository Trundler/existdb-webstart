# Build

## Prerequisites

- eXist-db:
  - Version 3.6 or newer (older versions might and will work, but is not tested)
  - Location is referenced as 'EXIST_HOME'
- Optional: 
  - Apache Ant (version 1.10.1)
  - Java keystore file containing commercial certificates to sign JAR files

## Steps

- Edit `build.properties`, configure `exist.home`
- Run `ant` in the toplevel directory 
    - or use `$EXIST_HOME/build.sh`
- The XAR file is generated in the `build` directory

## In detail: the Ant actions:

- generate `webstart.keystore` when not existemt
- copy JAR files from `$EXIST_HOME`
- processes JAR files (repack)
- sign JAR files
- compress JAR files with PACK200 and GZIP
