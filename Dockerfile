FROM ubuntu:21.04

RUN apt update
RUN useradd -m odoo_ubuntu
RUN echo "odoo_ubuntu:cleartext_password" | chpasswd

RUN usermod -a -G odoo_ubuntu odoo_ubuntu
#Assign group ownership in /etc/init.d to odoo_ubuntu group
RUN chgrp -R odoo_ubuntu /etc/init.d
# Assign group write access
RUN chmod -R g+rwX /etc/init.d
# all new files created in that directory will be owned by the odoo_ubuntu group by default:
RUN chmod g+s /etc/init.d


# Install some tools
RUN apt install -y software-properties-common
RUN apt install -y wget
RUN apt install -y lsb-release && apt-get clean all
RUN apt install -y nano
RUN apt install -y mlocate
RUN apt install -y less



RUN apt install -y libturbojpeg

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dirmngr \
        fonts-noto-cjk \
        gnupg \
        # TO REEMOVE WHEN PACKAGED
        gsfonts \
        libssl-dev \
        node-less \
        npm \
        python3-num2words \
        python3-pdfminer \
        python3-pip \
        python3-phonenumbers \
        python3-pyldap \
        # TO REMOVE WHEN PACKAGED
        python3-openssl \
        python3-qrcode \
        python3-renderpm \
        python3-setuptools \
        python3-slugify \
        python3-vobject \
        python3-watchdog \
        python3-xlrd \
        python3-xlwt \
        xz-utils

# Install wkhtmltopdf

RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
RUN apt install -y ./wkhtmltox_0.12.6-1.focal_amd64.deb


# Install DB
RUN apt install -y postgresql postgresql-client
RUN PATH="/usr/bin/psql"
SHELL ["/bin/bash", "-c", "source /etc/environment && export PATH"]
#RUN 
SHELL ["/bin/sh", "-c"]


USER postgres
SHELL ["/bin/sh", "-c", "/etc/init.d/postgresql start"]
RUN psql -c "create user odoo_db_user"
RUN psql -c "alter user odoo_db_user with password 'StrongAdminP@ssw0rd'"
RUN psql -c "create database odoo_db owner odoo_db_user"
#RUN postgres createuser -s odoo_db
#RUN createdb odoo_db


#
#
##RUN wget -O - https://nightly.odoo.com/odoo.key | apt-key add -
##RUN echo "deb http://nightly.odoo.com/13.0/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list
##RUN apt-get update && apt-get install odoo
#
RUN apt-get install -y git

#RUN mkdir /home/odoo/
WORKDIR /home/odoo_ubuntu

RUN git clone https://github.com/odoo/odoo.git
WORKDIR /home/odoo_ubuntu/odoo/


RUN apt-get install -y python3-dev \ 
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libtiff5-dev \
    libjpeg8-dev \
    libopenjp2-7-dev \
    zlib1g-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libwebp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libxcb1-dev \
    libpq-dev


RUN apt upgrade gcc -y


# Install required packages from odoo
RUN pip3 install setuptools wheel
COPY requirements.txt ./
RUN pip3 install -r requirements.txt
RUN pip3 install psycopg2




# Right to left interface support
RUN apt-get install nodejs npm -y
RUN npm install -g rtlcss

#USER odoo_ubuntu
RUN python3 odoo-bin --addons-path=addons -d mydb

EXPOSE 8069

