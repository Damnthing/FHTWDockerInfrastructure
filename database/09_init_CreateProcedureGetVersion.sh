#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

	CREATE FUNCTION get_version()
	RETURNS INTEGER
	AS $$
		SELECT 1;
	$$ LANGUAGE SQL
	 
EOSQL