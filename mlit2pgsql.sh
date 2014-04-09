#!/bin/sh

S3_BUCKET=s.kitazaki.name
S3_PATH=datasets/mlit

for f in N03-*.zip
do
    unzip -uo -d ${f%.zip} $f
done

for f in N03-*/*.shp
do
    t=`basename $f`
    sql=${t%.shp}.sql
    shp2pgsql -W "Shift_JIS" $f > $sql
    aws s3 cp $sql s3://$S3_BUCKET/$S3_PATH/$sql
done

for f in N03-*.sql
do
    psql -U postgres -d geo -f $f
done

psql -U postgres -d geo -f patch.sql

psql -U postgres -d geo -f address_boundary.sql

for i in {01..47}
do
    psql -U postgres -d geo -f transform.sql -v table="n03-13_${i}_130401" -v code=${i}
done

echo "SELECT count(*) FROM address_boundary;" | psql -U postgres -d geo

pg_dump -F c -x -U postgres -d geo -t address_boundary -f address_boundary.backup

fname=address_boundary.backup
aws s3 cp $fname s3://$S3_BUCKET/$S3_PATH/$fname
