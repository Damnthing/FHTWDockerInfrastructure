USE [Abgabe]
GO

ALTER TABLE [dbo].[GroupWorkMembers] DROP CONSTRAINT [FK_dbo.GroupWorkMembers_dbo.GroupWorks_GroupWork_ID]
GO

/****** Object:  Table [dbo].[GroupWorkMembers]    Script Date: 04.10.2018 21:16:26 ******/
DROP TABLE [dbo].[GroupWorkMembers]
GO

/****** Object:  Table [dbo].[GroupWorkMembers]    Script Date: 04.10.2018 21:16:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GroupWorkMembers](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [nvarchar](50) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[DeletedOn] [datetime] NULL,
	[GroupWork_ID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.GroupWorkMembers] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[GroupWorkMembers]  WITH CHECK ADD  CONSTRAINT [FK_dbo.GroupWorkMembers_dbo.GroupWorks_GroupWork_ID] FOREIGN KEY([GroupWork_ID])
REFERENCES [dbo].[GroupWorks] ([ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[GroupWorkMembers] CHECK CONSTRAINT [FK_dbo.GroupWorkMembers_dbo.GroupWorks_GroupWork_ID]
GO


