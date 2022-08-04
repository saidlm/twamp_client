# TWAMP Client
TWAMP Client is a part of IP probe solution based on perfSONAR project. Whole probe is modular microservice solution based on docker containers. Client part is designed as stanalone solution with no requiremet for any external input connection. The configuration of the client which includes global configuration and list of IP addresses is periodicaly downloded from central side.

## Prerequisits
Installation of Docker with docker compose plugin is necessary on host machine.

## Operation tests
The whole solution has been tested on ARMv7 (RPi) and AMD64 architecture (Desktop PC).

## Building
Almost everything is automated via docker compose. You just need to download the project and run docker compose build.
```
git clone https://github.com/saidlm/twamp_client
cd twamp_client
docker compose build
```

## Configuration

The input for docker compose is split into two files - docker-mpose.yml and docker-compose.override.yml. It is done due to provisioning automation. Common container configuration is stored in docker-compose.yml but everything which is site specific is a part of docker-compose.override.yml file. Site specific configuration can be easily generated during provisioning of the probe base on database data by ansible or any other automated solution. Everything else is same for all network sites. 

### Container configuration
* Create volume
* Change storage path in docker-compose.yml
* Change hostname of client container (if necessary) in docker-compose.yml. The hostname is used as data source identification for metrics.
* Basic configuration will be automaticaly populated during the first run; three new directovy will be created on your volume - bin/ cron.d/ and data/
* Change URL and credentioal of config site in data/global_config.json in "ConfigSource" section. 
* Change crontabs according your needs if necessary

#### Directory structure
| Directory | Description
| :--- | :---
| **bin** | Executable scripts
| **cron.d** | Crontabs
| **data** | Dynamic configs downloaded from central site

#### Configuration files
| File Name | Description 
| :--- | :---
| **cron.d/probe** | Crontab defining probe time cycle
| **cron.d/config_downloader** | Crontab for config downloader
| **data.d/global_config.json** | Basic global configuration; it will be overwrited after the first start by newly downloaded configuration file.

### Twamp client configuration
* Only update of the configuration files is possible in current version of the client container. The plan is to have possibility to update almost whole container functionality from central site in defined time interval in the end of the day.
* There must be at least two files stored on URL configured in the section "ConfigSource" of global_config file - global_config.json and targets.json
* The examples of configuration files are in config_example directory of the project.

#### global_config.json
There are two section for current version of client container:

| Section | Description 
| :--- | :---
| **ConfigSource** | Define URL and credentials for configuration downloader
| **Destination** | Define URL and passphrase for message colector (telegraf)

ConfigURL section parameters are:

| Parameter | Description
| :--- | :---
| **ConfigURL** | URL where configuration files are stored
| **ConfigUser** | User <ptional>
| **ConfigPassword** | Password <optional>

Destination section parameters are:

| Parameter | Description
| :--- | :---
| **DestinationURL** | URL of telegraf collector
| **DestinationPassword** | Passphrase for telegraf collector in MD5 hash form

#### targets.json
There is currently only one section - **Targets**. It includes array of targets' (twamp responders') parameters. 

| Parameter | Description
| :--- | :---
| **IP** | IP address or DNS name of the twamp responder
| **DSCP** | DSCP mark for the test packet header

## Running
Create new container and start it:
```
docker compose up -d
```

### Network ports
There is no ports exposed outside of container.
