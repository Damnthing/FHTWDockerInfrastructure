USE [Abgabe]
GO

/****** Object:  Table [dbo].[UnitTestResults]    Script Date: 04.10.2018 21:16:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UnitTestResults](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[User] [nvarchar](50) NOT NULL,
	[Repository] [nvarchar](50) NOT NULL,
	[Tests] [int] NOT NULL,
	[Succeeded] [int] NOT NULL,
	[Failed] [int] NOT NULL,
	[Skipped] [int] NOT NULL,
	[Fach] [nvarchar](50) NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[Errors] [int] NOT NULL,
	[Uebung] [nvarchar](50) NOT NULL,
	[UnitTestFile] [nvarchar](100) NOT NULL,
	[cmLinesOfCode] [int] NULL,
	[cmCyclomaticComplexity] [int] NULL,
	[qmMemErrors] [int] NULL,
	[ProgrammingLanguage] [nvarchar](20) NULL,
	[Custom1] [nvarchar](50) NULL,
	[Custom2] [nvarchar](50) NULL,
	[Custom3] [nvarchar](50) NULL,
	[Custom4] [nvarchar](50) NULL,
	[Custom5] [nvarchar](50) NULL,
 CONSTRAINT [PK_UnitTestResults] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UnitTestResults] ADD  CONSTRAINT [DF_UnitTestResults_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO

ALTER TABLE [dbo].[UnitTestResults] ADD  DEFAULT ('') FOR [UnitTestFile]
GO


