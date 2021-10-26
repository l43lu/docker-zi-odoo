/etc/init.d/postgresql start
su postgres
psql
create user odoo_ubuntu;
alter user odoo_ubuntu createdb;

quit
exit
su odoo_ubuntu
bash
python3 odoo-bin --addons-path=addons -d mydb