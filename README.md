## !! Security Warning !!
This repo not only runs a reverse proxy as a privileged user, but it also mounts the docker daemon into the container as well.

This is terrible security practice, and I will be updating shortly with with a more secure configuration.

I highly recommend placing the server behind a VPN.

### Quickstart:

Clone `https://github.com/jonathanmeier5/traefik-nginx-webdav` and checkout `master`. 

Configure the `traefik` config files with appropriate permissions. From the project root:
```
sudo chown root:root traefik.toml
```
Next, create an `acme.json` file somewhere outside your project that you can mount into the `traefik` container to store your domain's cert. Personally, I prefer the following:
```
mkdir -p ~/opt/traefik
touch ~/opt/traefik/acme.json
sudo chown root:root -R ~/opt
sudo chmod 600 ~/opt/traefik/acme.json
```

Make sure you have python 3.6 or greater installed along with [pip](https://pip.pypa.io/en/stable/installing/).
```
pip3 install pipenv
```

From project root:
```
pipenv shell --python=python3
```
If your python distribution has a different alias, use that instead.

Now we can enter into our python virtual envrionment with:
```
pipenv shell
```

From here we first need to install the packages specified in the Pipfile locally:
```
pipenv install
```

Now we can add appropriate environment variables to our `compose-flow` environments to get things up and running:
```
compose-flow -e local env edit -f
```
You should initially just see three default variable values as follows:
```
CF_ENV=local
CF_ENV_NAME=traefik-nginx-webdav
CF_PROJECT=traefik-nginx-webdav
```

Beneath them, add the following:
```
CERT_OWNER_EMAIL=<YOUR_EMAIL_ADDRESS>
DOCKER_IMAGE=
NGINX_CONF=/etc/nginx/conf.d/app.conf
PROJECT_DIR=<PROJECT_DIR_FULL_PATH>
TRAEFIK_CONFIG_DIR=<PATH_TO_DIR_WITH_ACME.JSON>
WEBDAV_DIRECTORY=/home/meierj/var/www/journal
WEBDAV_DOMAIN=<DOMAIN: ex webdav.mysite.com>
WEBDAV_PASSWORD=<DESIRED_BASIC_AUTH_PASSWORD>
WEBDAV_USERNAME=<DESIRED_BASIC_AUTH_USER>
compose-flow -e local env -f
```

Now create a directory for the webdav server to write to. Again, I prefer:
```
mkdir -p ~/var/www/journal
echo 'hello, world' >> ~/var/www/journal/home.html 
sudo chown www-data:www-data -R ~/var/www/journal
```

With that, you should be able to start up your webdav server and its `traefik` proxy with:
```
compose-flow -e local compose up -d
```

On startup `traefik` will check to see if any certificates exist in `

### Debugging
Both processes are quite easy to debug. `webdav-nginx` stores its logs in `/var/log/nginx/error.log` and `traefik` sends logs directly to `stdout`.

