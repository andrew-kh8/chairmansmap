# Chairman's map

[![CodeFactor](https://www.codefactor.io/repository/github/andrew-kh8/chairmansmap/badge)](https://www.codefactor.io/repository/github/andrew-kh8/chairmansmap)


![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/tailwindcss-%2338B2AC.svg?style=for-the-badge&logo=tailwind-css&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)


# Stack

Rails + PostGIS (PostgreSQL) + Leaflet\
Hotwire Turbo & Stimulus, Tailwind


# Start

```bash
./bin/dev
```


# Setup
## install GEOS
[rgeo doc](https://github.com/rgeo/rgeo/blob/main/doc/Installing-GEOS.md)
```bash
sudo apt update
sudo apt install libgeos-dev libgeos++-dev

# check geos
apt list | grep geos

# reinstall rgeo gem
gem uninstall rgeo
bundle install
```

## install PROJ
need for projection gem [rgeo-proj4](https://github.com/rgeo/rgeo-proj4)
```bash
sudo apt install libproj-dev proj-bin
```

check [docs](./docs/postgis_hints.md#transform-unproject-coordinates) folder to read about projection

## install strong migrations
```bash
bundle exec rails generate strong_migrations:install
```


# Configuration

copy `.env.sample` to `.env` and fill the file

if you wanna use other values in test environment copy `.env.sample` to `.env.test` and rewrite some variables

# Testing

Rspec + Capybara

you can check [docs](./docs/test.md#chromedriver) for more

you can use `bin/install_chromedriver` to install chromedriver manually


# Linters

Use GitHub actions for CI
* brakeman
* bundler-audit
* erb_lint
* fasterer
* rails_best_practices
* reek
* standardrb