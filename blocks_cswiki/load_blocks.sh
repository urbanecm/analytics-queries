#!/bin/bash

TMPDIR=/tmp/$$

mkdir $TMPDIR
echo $TMPDIR

analytics-mysql cswiki < get_school_blocks.sql | sed 1d | bash normalize_tsv.sh > $TMPDIR/school_blocks.tsv
analytics-mysql cswiki < get_nonschool_blocks.sql | sed 1d | bash normalize_tsv.sh > $TMPDIR/nonschool_blocks.tsv

hive -e "
use urbanecm;

-- Recreate table
DROP TABLE cswiki_blocks_20210401;
CREATE TABLE IF NOT EXISTS cswiki_blocks_20210401(
	cb_log_id int,
	cb_log_timestamp timestamp,
	cb_target string,
	cb_ipb_by_username string,
	cb_is_ipv4 boolean,
	cb_is_ipv6 boolean,
	cb_is_ip boolean,
	cb_school_ip_block boolean
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY \"\t\"
STORED AS TEXTFILE
LOCATION '/user/urbanecm/data/cswiki_blocks_20210401';

-- Load data
LOAD DATA LOCAL INPATH '$TMPDIR/school_blocks.tsv' INTO TABLE cswiki_blocks_20210401;
LOAD DATA LOCAL INPATH '$TMPDIR/nonschool_blocks.tsv' INTO TABLE cswiki_blocks_20210401;"

#rm -rf $TMPDIR
