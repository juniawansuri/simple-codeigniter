FROM ubuntu/apache2:latest

LABEL author="Dede Juniawan Suri"
LABEL website="https://profile-juniawan.vercel.app/"

# Update package
RUN apt-get update -y

# Install PHP
RUN apt-get install -y php
RUN apt-get install -y php-common php-cli php-zip php-curl php-gd php-xml php-mbstring php-mysqli 
RUN php -v

# Apache Config
# Allow .htaccess with RewriteEngine.
RUN a2enmod rewrite

# Authorise .htaccess files.
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Install composer
RUN apt-get install unzip
RUN apt-get install -y wget
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN HASH="$(wget -q -O - https://composer.github.io/installer.sig)" && php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer