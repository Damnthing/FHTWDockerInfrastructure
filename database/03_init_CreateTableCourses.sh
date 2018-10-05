#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

	CREATE TABLE public."Courses"
	(
		"ID" integer NOT NULL,
		"Name" character varying(50) COLLATE pg_catalog."default" NOT NULL,
		"Notes" character varying COLLATE pg_catalog."default" NOT NULL,
		"IsActive" bit(1) NOT NULL DEFAULT (0)::bit(1),
		"SubmissionType" integer NOT NULL DEFAULT 0,
		"UserUIDs" character varying COLLATE pg_catalog."default",
		CONSTRAINT "Courses_pkey" PRIMARY KEY ("ID")
	)
	WITH (
		OIDS = FALSE
	)
	TABLESPACE pg_default;

	ALTER TABLE public."Courses"
		OWNER to postgres;
		
EOSQL