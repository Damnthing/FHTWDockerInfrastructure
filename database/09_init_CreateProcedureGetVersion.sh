#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

	CREATE FUNCTION get_version()
	RETURNS INTEGER
	LANGUAGE SQL
	AS \$BODY\$

		SELECT 1;
	\$BODY\$
	 
EOSQL
