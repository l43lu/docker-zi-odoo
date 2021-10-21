FROM ubuntu:18.04

RUN apt update
RUN apt install postgresql -y
RUN apt install software-properties-common -y


#RUN wget -O - https://nightly.odoo.com/odoo.key | apt-key add -
#RUN echo "deb http://nightly.odoo.com/13.0/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list
#RUN apt-get update && apt-get install odoo


RUN apt install python3.8 -y
RUN apt install python3-pip -y

RUN pip3 install xlwt
RUN pip3 install num2words


RUN apt-get install -y git

RUN mkdir /home/odoo/
WORKDIR /home/odoo

RUN git clone https://github.com/odoo/odoo.git



RUN postgres createuser -s $USER
RUN createdb $USER



RUN apt install -y python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev

WORKDIR /home/odoo/odoo/

RUN pip3 install setuptools wheel
RUN pip3 install -r requirements.txt

RUN python3 odoo-bin --addons-path=addons -d mydb

EXPOSE 8069

