USE [Abgabe]
GO

/****** Object:  StoredProcedure [dbo].[store_unittest_result]    Script Date: 04.10.2018 21:18:35 ******/
DROP PROCEDURE [dbo].[store_unittest_result]
GO

/****** Object:  StoredProcedure [dbo].[store_unittest_result]    Script Date: 04.10.2018 21:18:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[store_unittest_result] (
    @Fach nvarchar(50),
	@User nvarchar(50),
	@Uebung nvarchar(50),
    @Repository nvarchar(50),
    @Tests int,
    @Succeeded int,
    @Failed int,
    @Errors int,
    @Skipped int,
	@UnitTestFile nvarchar(100),
	@cmLinesOfCode int = null,
	@cmCyclomaticComplexity int = null,
	@qmMemErrors int = null,
    @ProgrammingLanguage nvarchar(20) = null,
	@Custom1 nvarchar(50) = null,
	@Custom2 nvarchar(50) = null,
	@Custom3 nvarchar(50) = null,
	@Custom4 nvarchar(50) = null,
	@Custom5 nvarchar(50) = null
) AS
BEGIN
	INSERT INTO [dbo].[UnitTestResults] (
			[Fach]
		   ,[User]
		   ,[Uebung]
           ,[Repository]
           ,[Tests]
           ,[Succeeded]
           ,[Failed]
           ,[Errors]
           ,[Skipped]
		   ,[UnitTestFile]
		   ,[cmLinesOfCode]
		   ,[cmCyclomaticComplexity]
		   ,[qmMemErrors]
		   ,[ProgrammingLanguage]
	       ,[Custom1]
	       ,[Custom2]
	       ,[Custom3]
	       ,[Custom4]
	       ,[Custom5]
           )
     VALUES (
			@Fach,
			@User,
			@Uebung,
			@Repository,
			@Tests,
			@Succeeded,
			@Failed,
			@Errors,
			@Skipped,
			@UnitTestFile,
			@cmLinesOfCode,
			@cmCyclomaticComplexity,
			@qmMemErrors,
		    @ProgrammingLanguage,
	        @Custom1,
	        @Custom2,
	        @Custom3,
	        @Custom4,
	        @Custom5
			)

END


GO


