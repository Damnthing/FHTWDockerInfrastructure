-- Table: public."GroupWorks"

-- DROP TABLE public."GroupWorks";

CREATE TABLE public."GroupWorks"
(
    "ID" integer NOT NULL,
    "OwnerUID" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "CreatedOn" timestamp without time zone NOT NULL,
    "ChangedOn" timestamp without time zone NOT NULL,
    "Name" character varying(50) COLLATE pg_catalog."default",
    "Notes" character varying COLLATE pg_catalog."default",
    "Course_ID" integer NOT NULL,
    CONSTRAINT "GroupWorks_pkey" PRIMARY KEY ("ID"),
    CONSTRAINT "Courses_Course_ID" FOREIGN KEY ("Course_ID")
        REFERENCES public."Courses" ("ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."GroupWorks"
    OWNER to postgres;