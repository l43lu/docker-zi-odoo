:set fileformat=unix


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









1. nach der installation => docker-compose up =>  docker cp e0c2f5d6ef8f:/home/odoo_ubuntu/odoo odoo_copy\
2. docker stop container
3. add new volume in docker-container with odoo_copy as local path and /home/odoo_ubuntu/odoo as container path

