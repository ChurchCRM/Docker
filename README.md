## Docker ChurchCRM

This is the Docker Installation of ChurchCRM. This will build the latest release of ChurchCRM for Docker. It is made with Apache/PHP7/ChurchCRM and MariaDB in 2 separate containers and a third container (nginx working as a reverse proxy) that work together.

### How To Use

It is necessary to have Docker installed on your system for this to work. See https://www.docker.com/community-edition#/download...

* Clone this repository.
* Change your desired **database info** and **passwords** in the crm_secrets.json file. **PLEASE CHANGE**
* Change your desired SSL setup in the ssl.json file, if use letsencrypt dns mode, need setup dns_api.json.
* From the command line, navigate to the root folder of your local repository and use docker-compose to build and run ChurchCRM. Run the following commands.
    - `docker-compose build`
    - `docker-compose up`
* You can view your installation of ChurchCRM on Docker by going to https://localhost (or your server's IP address) in a browser.
* Enter the default login information:
    - Username: `admin`
    - Password: `changeme`
- Once in, you will be prompted to change your password to something more secure.

### SSL

ChurchCRM for Docker is set to run by default using SSL encryption. There are 3 build options in regards to SSL.

* `letsencrypt`: Support acme.sh to set letsencrypt, default is webroot mode, use port 80 to check the domain permission.Support dns mode, use API update dns server to check domain ownship, use this mode can let internal net have letsencrypt support. Use dns mode need set the dns_api.json, first issue SSL certificates need wait dns server 120 seconds. See https://github.com/Neilpang/acme.sh/tree/master/dnsapi. "extra_parameter" can add --test for test certificates, add --forece to force update certrificates, when ssl folder no fullchain.cer file, will issue a new SSL certificates.
* `build`: This option will create an SSL certificate for you. Please fill out your information in the docker_compose.yml file under the nginx: args section.
* `own`: With this option, you will need to provide your own SSL certificates. Please put your own "fullchain.cer" and "domain.key" files in the ssl folder. SSL will not work if chooseing this option and not adding the correctly named certificates there.
* `none`: This will run an installation of ChurchCRM without SSL. You will be able to access your installation at http://localhost (as opposed to https://localhost)

**NOTE** While using SSL on localhost, browsers will prompt with an error/warning that they don't recognize the Certificate Authority *(which is yourself in this case)*. When this occurs, allow the exception and continue to the site.

### Using a Domain Name instead of https://localhost

In order to access ChurchCRM via a domain name other than localhost, set an entry in your local computer's `/etc/hosts` file.

* See https://www.siteground.com/kb/how_to_use_the_hosts_file/ to see where your hosts file is located and how to update.
* Add an entry in your `hosts` file such as `127.0.0.1     local.churchcrm.io`
* Once saved you can access your installation by going to `https://local.churchcrm.io` or any domainname that you specified in the hosts file.

### Accessing ChurchCRM from another device

While on the same local network, you can access ChurchCRM by visiting the IP address of the computer running Docker. For example, if your machine's local ip is 192.168.1.3, visiting that address (https://192.168.1.3) from another device will allow you to access ChurchCRM.

### DATA STORAGE

Running the `docker-compose up` command will create 2 separate Docker data-volumes to store the database and ChurchCRM uploaded photos. When the database and ChurchCRM images and containers are destroyed, rebuilt or updated, the data-volumes will persist unless you remove those volumes.
