-- Table: public."UnitTestResults"

-- DROP TABLE public."UnitTestResults";

CREATE TABLE public."UnitTestResults"
(
    "ID" integer NOT NULL,
    "User" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "Repository" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "Tests" integer NOT NULL,
    "Succeeded" integer NOT NULL,
    "Failed" integer NOT NULL,
    "Skipped" integer NOT NULL,
    "Fach" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "Timestamp" timestamp without time zone NOT NULL DEFAULT CURRENT_DATE,
    "Errors" integer NOT NULL,
    "Uebung" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "UnitTestFile" character varying(100) COLLATE pg_catalog."default" NOT NULL,
    "cmLinesOfCode" integer,
    "cmCyclomaticComplexity" integer,
    "qmMemErrors" integer,
    "ProgrammingLanguage" character varying(20) COLLATE pg_catalog."default",
    "Custom1" character varying(50) COLLATE pg_catalog."default",
    "Custom2" character varying(50) COLLATE pg_catalog."default",
    "Custom3" character varying(50) COLLATE pg_catalog."default",
    "Custom4" character varying(50) COLLATE pg_catalog."default",
    "Custom5" character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT "UnitTestResults_pkey" PRIMARY KEY ("ID")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."UnitTestResults"
    OWNER to postgres;