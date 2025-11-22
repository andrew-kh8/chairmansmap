# Chairman's map

[![CodeFactor](https://www.codefactor.io/repository/github/andrew-kh8/chairmansmap/badge)](https://www.codefactor.io/repository/github/andrew-kh8/chairmansmap)

## Stack

Rails + Geoserver(PostGIS) + Leaflet(leaflet-geoserver-request)\
also Jquery, Tailwind, PostgreSQL, Java 11

# Start

```bash
./bin/dev
```
visit http://127.0.0.1:3000

# Setup

install GEOS [rgeo doc](https://github.com/rgeo/rgeo/blob/main/doc/Installing-GEOS.md)
```bash
sudo apt update
sudo apt install libgeos-dev libgeos++-dev

# check geos
apt list | grep geos

# reinstall rgeo gem
gem uninstall rgeo
bundle install
```


```bash
shp2pgsql -i -D -s 4326 vector_map.shp plots > bd/plots.sql
```

check docs folder

```bash
bundle exec rails generate strong_migrations:install
```

<!-- sudo apt-get install libproj-dev proj-bin -->
# Testing

chrome for testing link: https://googlechromelabs.github.io/chrome-for-testing/#stable
Install Chromedriver Ubuntu 20.04 link: https://skolo.online/documents/webscrapping/
chrome webdriver 131.0.6778.139 link: https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.139/linux64/chromedriver-linux64.zip

you can use `bin/install_chromedriver`

To prepare test plots run `bin/prepare_test_plots`

* Configuration

copy .env.sample to .env and fill the file

copy .env.sample to .env.test and rewrite some variables if you wanna use other values in test environment


* ...
