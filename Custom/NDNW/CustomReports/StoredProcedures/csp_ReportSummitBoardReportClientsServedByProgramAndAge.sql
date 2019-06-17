-- Drop Table If Exist
If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.csp_ReportSummitBoardReportClientsServedByProgramAndAge') 
                  And Type In ( N'P', N'PC' )) 
	Drop Procedure dbo.csp_ReportSummitBoardReportClientsServedByProgramAndAge
Go

/****** Object:  StoredProcedure [dbo].[csp_ReportSummitBoardReportClientsServedByProgramAndAge]    Script Date: 11/2/2015 9:44:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*************************************
* 7/18/14 Tryan - Created. Gathers service information within date and age ranges for 
*				  Clients Served by Program and Age.rdl
*************************************/

CREATE Procedure [dbo].[csp_ReportSummitBoardReportClientsServedByProgramAndAge]
@Start_Date		datetime,
@End_Date		datetime,
@Youngest_Age	Int,
@Oldest_Age		Int,
@ProgramId		INT
AS

--TestVars
--declare @Start_Date		datetime,
--@End_Date		datetime,
--@Youngest_Age int,
--@Oldest_Age int
--set @Start_Date = '10/1/2012'
--set @End_Date = '09/30/2013'
--set @Youngest_Age = 65
--set @Oldest_Age = NULL

declare @ClientDetails table
(Program_Name varchar(100), ClientId int, LastName VarChar(30), FirstName VarChar(25))
insert into @ClientDetails

Select distinct p.ProgramName, c.ClientId, c.LastName, c.FirstName
from Clients c
Join Services s on c.ClientId = s.ClientId
Join Programs p on s.ProgramId = p.ProgramId
where s.DateOfService >= @Start_Date and s.DateOfService <= @End_Date
	and s.Status in (71, 75)
	AND ((@Youngest_Age is null or dbo.GetAge(c.DOB, s.DateOfService) >= @Youngest_Age) 
		OR (dbo.GetAge(c.DOB, s.DateOfService) BETWEEN @Youngest_Age AND @Oldest_Age))
	AND ((@Oldest_Age is null or dbo.GetAge(c.DOB, s.DateOfService) <= @Oldest_Age)
		OR (dbo.GetAge(c.DOB, s.DateOfService) BETWEEN @Youngest_Age AND @Oldest_Age))
	AND (@ProgramId = s.programid OR @ProgramId IS NULL)

declare @SummaryTable table
(Program_Name varchar(100), ClientsServed int )

insert into @SummaryTable
Select Program_Name, count(distinct ClientId) as ClientsServed
from @ClientDetails cd
group by Program_Name
order by Program_Name


Select cd.Program_Name, cd.ClientId, LTrim(RTrim(cd.LastName)) As LastName, LTrim(RTrim(cd.FirstName)) As FirstName, s.ClientsServed
from @ClientDetails cd
join @SummaryTable s on s.Program_Name = cd.Program_Name
order by cd.Program_Name

GO


