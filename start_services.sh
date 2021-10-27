#!/bin/bash
su postgres -c "/etc/init.d/postgresql start"
su odoo_ubuntu -c "python3 odoo-bin --addons-path=addons -d mydb"