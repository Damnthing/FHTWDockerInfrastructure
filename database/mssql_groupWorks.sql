USE [Abgabe]
GO

ALTER TABLE [dbo].[GroupWorks] DROP CONSTRAINT [FK_dbo.GroupWorks_dbo.Courses_Course_ID]
GO

/****** Object:  Table [dbo].[GroupWorks]    Script Date: 04.10.2018 21:16:34 ******/
DROP TABLE [dbo].[GroupWorks]
GO

/****** Object:  Table [dbo].[GroupWorks]    Script Date: 04.10.2018 21:16:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GroupWorks](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OwnerUID] [nvarchar](50) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ChangedOn] [datetime] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Notes] [nvarchar](max) NULL,
	[Course_ID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.GroupWorks] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[GroupWorks]  WITH CHECK ADD  CONSTRAINT [FK_dbo.GroupWorks_dbo.Courses_Course_ID] FOREIGN KEY([Course_ID])
REFERENCES [dbo].[Courses] ([ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[GroupWorks] CHECK CONSTRAINT [FK_dbo.GroupWorks_dbo.Courses_Course_ID]
GO


