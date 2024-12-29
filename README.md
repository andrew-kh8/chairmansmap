# README

## Stack

Rails + Geoserver(PostGIS) + Leaflet(leaflet-geoserver-request)\
also Jquery, Tailwind, PostgreSQL, Java 11

# Start

```bash
sh /usr/share/geoserver/bin/startup.sh
./bin/dev
```
visit http://127.0.0.1:3000

# Setup

```bash
shp2pgsql -i -D -s 4326 vector_map.shp plots > bd/plots.sql
```

# Testing

chrome for testing link: https://googlechromelabs.github.io/chrome-for-testing/#stable
Install Chromedriver Ubuntu 20.04 link: https://skolo.online/documents/webscrapping/
chrome webdriver 131.0.6778.139 link: https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.139/linux64/chromedriver-linux64.zip


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
