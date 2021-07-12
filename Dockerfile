FROM ubuntu:20.04

RUN apt update && apt -y install ca-certificates apt-transport-https software-properties-common && add-apt-repository ppa:ondrej/php && apt -y install jq curl php8.0 libapache2-mod-php8.0

COPY ./index.php /var/www/html/index.php

COPY ./api.sh /root/api.sh

RUN chmod +x /root/api.sh && rm -f /var/www/html/index.html

ARG URL=${URL}

ARG AUTH=${AUTH}

ARG SECRET=${SECRET}

# call Medstack API and creates a secret
RUN /root/api.sh $URL $AUTH $SECRET

# set the secret on env on the build
ENV THESECRET=${SECRET}

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
