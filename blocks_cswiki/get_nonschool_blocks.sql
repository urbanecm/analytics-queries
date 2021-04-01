SELECT
	log_id,
	TIMESTAMP(log_timestamp),
	REPLACE(log_title, "_", " ") AS target,
	actor_name,
	IS_IPV4(log_title) AS is_ipv4,
	IS_IPV6(log_title) AS is_ipv6,
	IS_IPV4(log_title) OR IS_IPV6(log_title) AS is_ip,
	"0" AS is_school_ip_block
FROM logging
JOIN actor ON actor_id=log_actor
WHERE
	log_type='block' AND
	log_action='block' AND
	log_title NOT IN (
		SELECT page_title
		FROM templatelinks
		JOIN page ON page_id=tl_from
		WHERE tl_title='Sdílená_IP_škola' AND
		page_title NOT LIKE "%:%" AND
		tl_from_namespace=3
	)
ORDER BY log_id DESC;
