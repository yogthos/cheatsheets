
### Install and configure basic stuff

Update and upgrade all the software:

    sudo apt-get update && sudo apt-get upgrade

Install nginx (we'll use it to serve our droplet on the right port):

    sudo apt-get install nginx

Now let's add docker to the sudo group, that will allow us to run all the docker commands without sudo:

    sudo usermod -aG docker $USER
    sudo service docker restart

### Clone and configure Mastodon

Clone the repo and cd into it:

    git clone https://github.com/tootsuite/mastodon.git
    cd mastodon

Now let's configure some settings. First, rename the file .env.production.sample into .env.production and open it.

Set the database username/password settings:

    DB_USER=your_username
    DB_NAME=your_databasename
    DB_PASS=your_password

Set your domain name:

    LOCAL_DOMAIN=hackertribe.io

And enable https:

    LOCAL_HTTPS=true

Run `docker-compose run --rm web rake secret` to generate `PAPERCLIP_SECRET`, `SECRET_KEY_BASE`, and `OTP_SECRET`.

Configure the email server

Create a SendGrid account, go to Settings > API Keys, and generate an API key.

Then set up the config like this:

    SMTP_SERVER=smtp.sendgrid.net
    SMTP_PORT=587
    SMTP_LOGIN=apikey
    SMTP_PASSWORD=<your-api-key>
    SMTP_FROM_ADDRESS=youremail@gmail.com
    
(for SMTP_LOGIN literally just use "apikey")

Configure the site info

Open the file `/mastodon/config/settings.yml`, and enter the information about your instance(title, description, etc).

Build the containers

Before we can build the containers, we need to add a swap file, without it my $10/month droplet was running out of memory during the build process. To add swap, execute these commands:

    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile

(you can read more in depth about it here)

Now let's finally build our containers! (It will take a few minutes)

    docker-compose build
    docker-compose up -d

(the `-d` flag means that we want to run it in the background mode. You can try running it without this flag, and you will see the log of everything that's going on on the screen)

Create the DB and migrate

Now we need to run several commands in the db container to create the database.

SSH into the container:

    docker exec -i -t mastodon_db_1  /bin/bash

Switch to the postgres user:

    su - postgres

Create a user for your db(use the username and password you've just set in the `.env.production`)

    createuser -P your_username
    
Create a database, giving the ownership rights to the user:

    createdb your_databasename -O your_username

Now you can get back to your own user, and run the migrations:

    docker-compose run --rm web rails db:migrate

Precompile assets

Now you can precompile the assets:

    docker-compose run --rm web rails assets:precompile

After this has finished, restart the containers:

    docker stop $(docker ps -a -q) && docker-compose up -d

And now your mastodon instance will run on `yourdomain.com:3000`

Setting up nginx and SSL

First, follow this guide to generate SSL keys and set up the basic nginx configuration.

Then, because the docker containers are serving the application on the port `3000`, we will need to use nginx to proxy all the requests to them.

Create the file `/etc/nginx/sites-available/mastodon`, and copy the settings from [here](https://github.com/yogthos/cheatsheets/blob/master/mastodon_nginx_config).

Activate the site:

    ln -s /etc/nginx/sites-available/mastodon /etc/nginx/sites-enabled/mastodon

Now, after you restart nginx:

    sudo /etc/init.d/nginx restart

It will serve your Mastodon instance!
