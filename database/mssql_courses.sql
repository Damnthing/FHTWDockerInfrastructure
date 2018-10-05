USE [Abgabe]
GO

ALTER TABLE [dbo].[Courses] DROP CONSTRAINT [DF__Courses__Submiss__656C112C]
GO

ALTER TABLE [dbo].[Courses] DROP CONSTRAINT [DF__Courses__IsActiv__6477ECF3]
GO

/****** Object:  Table [dbo].[Courses]    Script Date: 04.10.2018 21:16:14 ******/
DROP TABLE [dbo].[Courses]
GO

/****** Object:  Table [dbo].[Courses]    Script Date: 04.10.2018 21:16:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Courses](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[SubmissionType] [int] NOT NULL,
	[UserUIDs] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Courses] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[Courses] ADD  DEFAULT ((0)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Courses] ADD  DEFAULT ((0)) FOR [SubmissionType]
GO


