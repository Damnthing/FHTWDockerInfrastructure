CREATE VIEW "rptUebungen"
AS
WITH
LastUebung AS (SELECT
			   max("Timestamp") AS "Timestamp",
			   "Fach",
			   "Uebung",
			   "User"
			   FROM public."UnitTestResults"
			   GROUP BY "Fach", "Uebung", "User"
			  ),
GroupWorks AS (SELECT
			   c."Name" AS "Fach",
			   m."UID" AS "User",
			   g."OwnerUID" AS "Owner",
			   'Uebung' AS "Type"
			   FROM
			   public."GroupWorks" g
			   INNER JOIN public."GroupWorkMembers" m ON g."ID" = m."GroupWork_ID"
			   INNER JOIN public."Courses" c ON g."Course_ID" = c."ID"
			   WHERE "DeletedOn" IS NULL
			  )
SELECT 
	r."Timestamp",
	r."Fach",
	r."Uebung",
	COALESCE(g."Owner", '') AS "GroupOwner",
	COALESCE(g."User", r."User") AS "User",
	r."Tests",
	r."Succeeded",
	r."Errors",
	r."Failed",
	r."Skipped",
	r."Repository",
	CASE r."Tests"
		WHEN 0 THEN 0
		ELSE CAST((CEILING((CAST((100 * r."Succeeded") AS FLOAT)) / (CAST((r."Tests") AS FLOAT)))) AS INTEGER)
	END AS "Credits",
	r."UnitTestFile",
	COALESCE(r."cmLinesOfCode", 0) AS "cmLinesOfCode",
	COALESCE(r."cmCyclomaticComplexity", 0) AS "cmCyclomaticComplexity",
	COALESCE(r."qmMemErrors", 0) AS "qmMemErrors",
	COALESCE(r."ProgrammingLanguage", '') AS "ProgrammingLanguage",
	COALESCE(r."Custom1", '') AS "Custom1",
	COALESCE(r."Custom2", '') AS "Custom2",
	COALESCE(r."Custom3", '') AS "Custom3",
	COALESCE(r."Custom4", '') AS "Custom4",
	COALESCE(r."Custom5", '') AS "Custom5"
  FROM public."UnitTestResults" r
  INNER JOIN LastUebung m ON m."Fach" = r."Fach" AND m."User" = r."User" AND m."Timestamp" = r."Timestamp" AND m."Uebung" = r."Uebung"
  LEFT JOIN GroupWorks g on g."Fach" = r."Fach" and g."Owner" = r."User" AND r."Uebung" NOT LIKE 'Exam-%'
  WHERE (g."Owner" IS NULL AND NOT EXISTS (SELECT * FROM GroupWorks g2 WHERE g2."Fach" = r."Fach" AND g2."User" = r."User")) -- not in a group and never a member
										 OR g."Owner" IS NOT NULL -- in a group
										 OR r."Uebung" LIKE 'Exam-%' -- exam