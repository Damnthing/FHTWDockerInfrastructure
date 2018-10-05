USE [Abgabe]
GO

/****** Object:  View [dbo].[rptExam]    Script Date: 04.10.2018 21:17:21 ******/
DROP VIEW [dbo].[rptExam]
GO

/****** Object:  View [dbo].[rptExam]    Script Date: 04.10.2018 21:17:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[rptExam]
AS
select 
	max([Timestamp]) [Timestamp], 
	[Fach], 
	'Exam' [Uebung], 
	[User], 
	sum([Tests]) [Tests], 
	sum([Succeeded]) [Succeeded], 
	sum([Errors]) [Errors], 
	sum([Failed]) [Failed], 
	case sum(Tests) 
		when 0 then 0 
		else convert(int, ceiling((convert(float, 100 * sum([Succeeded])) / convert(float, sum([Tests]))))) 
	end Credits 
from 
	[dbo].[rptUebungen] 
where 
	[Uebung] like 'Exam-%' 
group by [Fach], [User]

GO


