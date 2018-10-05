#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

	CREATE FUNCTION store_unittest_result (
		Fach character varying(50),
		Benutzer character varying(50),
		Uebung character varying(50),
		Repository character varying(50),
		Tests integer,
		Succeeded integer,
		Failed integer,
		Errors integer,
		Skipped integer,
		UnitTestFile character varying(100),
		cmLinesOfCode integer = null,
		cmCyclomaticComplexity integer = null,
		qmMemErrors integer = null,
		ProgrammingLanguage character varying(20) = null,
		Custom1 character varying(50) = null,
		Custom2 character varying(50) = null,
		Custom3 character varying(50) = null,
		Custom4 character varying(50) = null,
		Custom5 character varying(50) = null
	)
	RETURNS void
	AS $$
		INSERT INTO public."UnitTestResults" (
				"Fach",
				"User",
				"Uebung",
				"Repository",
				"Tests",
				"Succeeded",
				"Failed",
				"Errors",
				"Skipped",
				"UnitTestFile",
				"cmLinesOfCode",
				"cmCyclomaticComplexity",
				"qmMemErrors",
				"ProgrammingLanguage",
				"Custom1",
				"Custom2",
				"Custom3",
				"Custom4",
				"Custom5"
			   )
		 VALUES (
				Fach,
				Benutzer,
				Uebung,
				Repository,
				Tests,
				Succeeded,
				Failed,
				Errors,
				Skipped,
				UnitTestFile,
				cmLinesOfCode,
				cmCyclomaticComplexity,
				qmMemErrors,
				ProgrammingLanguage,
				Custom1,
				Custom2,
				Custom3,
				Custom4,
				Custom5
				)
	$$ LANGUAGE SQL
	
EOSQL