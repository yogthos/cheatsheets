### Howto Backup PostgreSQL Databases Server With pg_dump command

#### Step # 1: Login as a pgsql user

Type the following command:

    $ su - pgsql

Get list of database(s) to backup:

    $ psql -l

#### Step # 2: Make a backup using pg_dump

Backup database using `pg_dump` command, a utility for backing up a PostgreSQL database. It dumps only one database at a time. General syntax:

    pg_dump databasename > outputfile

Task: dump a payroll database

Type the following command

    $ pg_dump payroll > payroll.dump.out

To restore a payroll database:

    $ psql -d payroll -f payroll.dump.out

OR

    $ createdb payroll
    $ psql payroll
    
However, in real life you need to compress database:

    $ pg_dump payroll | gzip -c > payroll.dump.out.gz

To restore database use the following command:

    $ gunzip payroll.dump.out.gz
    $ psql -d payroll -f payroll.dump.out
    
Here is a shell script for same task:

```bash
#!/bin/bash
DIR=/backup/psql
[ ! $DIR ] && mkdir -p $DIR || :
LIST=$(psql -l | awk '{ print $1}' | grep -vE '^-|^List|^Name|template[0|1]')
for d in $LIST
do
  pg_dump $d | gzip -c >  $DIR/$d.out.gz
done
```

Another option is use to pg_dumpall command. As a name suggest it dumps (backs up) each database, and preserves cluster-wide data such as users and groups. You can use it as follows:

    $ pg_dumpall > all.dbs.out

OR

    $ pg_dumpall | gzip -c > all.dbs.out.gz

To restore backup use the following command:

    $ psql -f all.dbs.out postgres
