#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

	CREATE TABLE public."GroupWorkMembers"
	(
		"ID" integer NOT NULL,
		"UID" character varying(50) COLLATE pg_catalog."default" NOT NULL,
		"AddedOn" timestamp without time zone NOT NULL,
		"DeletedOn" timestamp without time zone,
		"GroupWork_ID" integer,
		CONSTRAINT "GroupWorkMembers_pkey" PRIMARY KEY ("ID"),
		CONSTRAINT "GroupWorkMembers_GroupWorks_GroupWork_ID" FOREIGN KEY ("GroupWork_ID")
			REFERENCES public."GroupWorks" ("ID") MATCH SIMPLE
			ON UPDATE NO ACTION
			ON DELETE CASCADE
	)
	WITH (
		OIDS = FALSE
	)
	TABLESPACE pg_default;

EOSQL