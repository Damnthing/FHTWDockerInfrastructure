CREATE VIEW "rptExam"
AS
SELECT 
	MAX("Timestamp") AS "Timestamp", 
	"Fach", 
	'Exam' "Uebung", 
	"User", 
	SUM("Tests") AS "Tests", 
	SUM("Succeeded") AS "Succeeded", 
	SUM("Errors") AS "Errors", 
	SUM("Failed") AS "Failed", 
	CASE SUM("Tests") 
		WHEN 0 THEN 0 
		ELSE CAST((CEILING((CAST((100 * SUM("Succeeded")) AS FLOAT)) / (CAST(SUM("Tests") AS FLOAT)))) AS INTEGER) 
	END AS "Credits" 
FROM 
	"rptUebungen"
WHERE 
	"Uebung" LIKE 'Exam-%' 
GROUP BY "Fach", "User"