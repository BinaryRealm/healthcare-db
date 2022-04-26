# To Install Heroku CLI and PostgreSQL:

## Linux:

``` Bash
sudo curl https://cli-assets.heroku.com/install.sh | sh # install Heroku

sudo apt install postgresql

sudo service postgresql start

sudo -u postgres psql  # to test
```

## Mac:

``` Bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"  # install Homebrew

brew tap heroku/brew && brew install heroku  # install Heroku CLI

brew install postgresql

brew services start postgresql

psql -h localhost # to test

```

# To create the database in Heroku:

``` Bash
heroku create

heroku addons:create heroku-postgresql:hobby-dev

heroku pg:psql -a your-app-name

DATABASE=> \i create.sql

DATABASE=> \i insert.sql

DATABASE=> \i queries.sql
```
