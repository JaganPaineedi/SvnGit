/****** Object:  Schema [CQMSolution]    Script Date: 01-02-2018 17:27:40 ******/
--DROP SCHEMA IF EXISTS [CQMSolution]
GO
/****** Object:  Schema [CQMSolution]    Script Date: 01-02-2018 17:27:40 ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'CQMSolution')
EXEC sys.sp_executesql N'CREATE SCHEMA [CQMSolution]'
GO
