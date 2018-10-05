USE [Abgabe]
GO

ALTER TABLE [dbo].[Assignment] DROP CONSTRAINT [FK_dbo.Assignment_dbo.Courses_Course_ID]
GO

ALTER TABLE [dbo].[Assignment] DROP CONSTRAINT [DF__Assignmen__Notif__01142BA1]
GO

/****** Object:  Table [dbo].[Assignment]    Script Date: 04.10.2018 21:15:48 ******/
DROP TABLE [dbo].[Assignment]
GO

/****** Object:  Table [dbo].[Assignment]    Script Date: 04.10.2018 21:15:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Assignment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[OpenFrom] [datetime] NULL,
	[DueDate] [datetime] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[Course_ID] [int] NOT NULL,
	[NotifyCIServer] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Assignment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[Assignment] ADD  DEFAULT ((1)) FOR [NotifyCIServer]
GO

ALTER TABLE [dbo].[Assignment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Assignment_dbo.Courses_Course_ID] FOREIGN KEY([Course_ID])
REFERENCES [dbo].[Courses] ([ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Assignment] CHECK CONSTRAINT [FK_dbo.Assignment_dbo.Courses_Course_ID]
GO


