/etc/init.d/postgresql start
su postgres -c "psql -c 'create user odoo_ubuntu;'"
su postgres -c "psql -c 'alter user odoo_ubuntu createdb;'"