SELECT
	CONCAT(YEAR(cb_log_timestamp), "-", LPAD(MONTH(cb_log_timestamp), 2, "0")) AS month,
	COUNT(*) AS totalBlocks,
	SUM(IF(cb_school_ip_block=true, 1, 0)) AS schoolBlocks,
	SUM(IF(cb_is_ip=true, 1, 0)) AS ipBlocks,
	SUM(IF(cb_is_ip=false, 1, 0)) AS accountBlocks
FROM urbanecm.cswiki_blocks_20210401
WHERE
	cb_log_timestamp BETWEEN "2019-01-01" AND "2021-03-31"
GROUP BY CONCAT(YEAR(cb_log_timestamp), "-", LPAD(MONTH(cb_log_timestamp), 2, "0"));
