USE [Abgabe]
GO

EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPaneCount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'rptUebungen'

GO

EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'rptUebungen'

GO

/****** Object:  View [dbo].[rptUebungen]    Script Date: 04.10.2018 21:17:46 ******/
DROP VIEW [dbo].[rptUebungen]
GO

/****** Object:  View [dbo].[rptUebungen]    Script Date: 04.10.2018 21:17:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[rptUebungen]
AS
with 
LastUebung as (select 
       max([Timestamp]) [Timestamp]
      ,[Fach]
      ,[Uebung]
      ,[User]
	  from [dbo].[UnitTestResults]
	  group by [Fach], [Uebung], [User]),
GroupWorks as (select c.[Name] [Fach], m.[UID] [User], g.OwnerUID [Owner], 'Uebung' [Type] from 
	[dbo].[GroupWorks] g 
	inner join [dbo].[GroupWorkMembers] m on g.ID = m.GroupWork_ID 
	inner join [dbo].[Courses] c on g.Course_ID = c.ID
	where DeletedOn is null)
SELECT 
       r.[Timestamp]
      ,r.[Fach]
      ,r.[Uebung]
	  ,coalesce(g.[Owner], '') [GroupOwner]
      ,coalesce(g.[User], r.[User]) [User]
      ,r.[Tests]
      ,r.[Succeeded]
      ,r.[Errors]
      ,r.[Failed]
      ,r.[Skipped]
      ,r.[Repository]
	  ,case r.[Tests] when 0 then 0 else convert(int, ceiling((convert(float, 100 * r.[Succeeded]) / convert(float, r.[Tests])))) end Credits
	  ,r.[UnitTestFile]
	  ,coalesce(r.[cmLinesOfCode], 0) cmLinesOfCode
	  ,coalesce(r.[cmCyclomaticComplexity], 0) cmCyclomaticComplexity
	  ,coalesce(r.[qmMemErrors], 0) qmMemErrors
	  ,coalesce(r.[ProgrammingLanguage], '') ProgrammingLanguage
	  ,coalesce(r.[Custom1], '') Custom1
	  ,coalesce(r.[Custom2], '') Custom2
	  ,coalesce(r.[Custom3], '') Custom3
	  ,coalesce(r.[Custom4], '') Custom4
	  ,coalesce(r.[Custom5], '') Custom5
  FROM [dbo].[UnitTestResults] r
  inner join LastUebung m on m.Fach = r.Fach and m.[User] = r.[User] and m.[Timestamp] = r.[Timestamp] and m.[Uebung] = r.[Uebung]
  left join GroupWorks g on g.Fach = r.Fach and g.[Owner] = r.[User] and r.[Uebung] not like 'Exam-%'
  where 
	(g.[Owner] is null and not exists (select * from GroupWorks g2 where g2.Fach = r.Fach and g2.[User] = r.[User])) -- not in a group an never member
	or g.[Owner] is not null -- in a group
	or r.[Uebung] like 'Exam-%' -- exam


GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "UnitTestResults"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'rptUebungen'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'rptUebungen'
GO


