FROM ubuntu:21.04

RUN apt update

RUN apt install software-properties-common -y
RUN apt install -y wget


#RUN apt install python3 -y
#RUN apt install python3-pip -y

RUN apt-get install -y lsb-release && apt-get clean all


RUN apt-get install -y libturbojpeg

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
    #&& curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
    #&& echo 'ea8277df4297afc507c61122f3c349af142f31e5 wkhtmltox.deb' | sha1sum -c - \
    #&& apt-get install -y --no-install-recommends ./wkhtmltox.deb \
    #&& rm -rf /var/lib/apt/lists/* wkhtmltox.deb

RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
RUN apt install -y ./wkhtmltox_0.12.6-1.focal_amd64.deb


#
#
#RUN apt install postgresql -y
#RUN apt install software-properties-common -y
#
#
##RUN wget -O - https://nightly.odoo.com/odoo.key | apt-key add -
##RUN echo "deb http://nightly.odoo.com/13.0/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list
##RUN apt-get update && apt-get install odoo
#
RUN apt-get install -y git

RUN mkdir /home/odoo/
WORKDIR /home/odoo

RUN git clone https://github.com/odoo/odoo.git



#RUN postgres createuser -s $USER
#RUN createdb $USER
#
#
#
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

WORKDIR /home/odoo/odoo/

RUN apt upgrade gcc -y

RUN apt install nano -y

RUN pip3 install setuptools wheel
COPY requirements.txt ./
RUN pip3 install -r requirements.txt
RUN pip3 install psycopg2


RUN python3 odoo-bin --addons-path=addons -d mydb

EXPOSE 8069

