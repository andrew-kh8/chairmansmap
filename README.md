# README

## Stack

Rails + Geoserver(PostGIS) + Leaflet(leaflet-geoserver-request)\
also Jquery, Tailwind, PostgreSQL, Java 11

# Start

```bash
./bin/dev
```
visit http://127.0.0.1:3000

# Setup

```bash
shp2pgsql -i -D -s 4326 vector_map.shp plots > bd/plots.sql
```

check docs folder

<!-- sudo apt-get install libproj-dev proj-bin -->
# Testing

chrome for testing link: https://googlechromelabs.github.io/chrome-for-testing/#stable
Install Chromedriver Ubuntu 20.04 link: https://skolo.online/documents/webscrapping/
chrome webdriver 131.0.6778.139 link: https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.139/linux64/chromedriver-linux64.zip

you can use `bin/install_chromedriver`

To prepare test plots run `bin/prepare_test_plots`

* Configuration

copy and fill the .env file


* ...
