# To Install Heroku CLI and PostgreSQL:

## Linux/WSL:

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

# To Create the Database in Heroku:

``` Bash
heroku login -i

heroku create

heroku apps # OPTIONAL: to get the application name

heroku config -a your-app-name # OPTIONAL: to get the database url

heroku addons:create heroku-postgresql:hobby-dev

heroku pg:psql -a your-app-name

DATABASE=> \i create.sql

DATABASE=> \i insert.sql

DATABASE=> \i queries.sql
```
