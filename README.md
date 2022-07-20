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
* Create volume
* Change storage path in docker-compose.yml
* Basic configuration will be automaticaly populated during the first run; tree new directovy will be created on your volume - bin/ cron.d/ and data/
* Cahnge crontabs according your needs if necessary

| Directory | Description
| :-- | :--
| **bin** | Executable scripts
| **cron.d** | Crontabs
| **data** | Dynamic configs downloaded from central site

| File Name | Description 
| :-- | :--
| **cron.d/probe** | Crontab defining probe time cycle
| **cron.d/config_downloader** | Crontab for config downloader


## Running
Create new container and start:
```
docker compose up -d
```

### Network ports
There is no ports exposed outside of container.
