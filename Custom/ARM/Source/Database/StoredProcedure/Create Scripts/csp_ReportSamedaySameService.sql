/****** Object:  StoredProcedure [dbo].[csp_ReportSamedaySameService]    Script Date: 06/19/2013 17:43:18 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[csp_ReportSamedaySameService]' 
                  ) 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].csp_ReportSamedaySameService

go 

/****** Object:  StoredProcedure [dbo].[csp_ReportSamedaySameService]    Script Date: 06/19/2013 17:43:18 ******/ 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ReportSamedaySameService] 
(@StartDate DateTime
,@EndDate DateTime=NULL
,@ProgramId INT,
@Client_Id INT
)
AS 
    /********************************************************************************************************   
    Report Request:   
     Details ...ACE Task :#20 :ARM frequently has Clients who are seen for the same service in the same day, 
							   but by different providers and at different times.ARM must bill for both 
							   services on the same day,but not necessarily on the DOS.If both services are not 
							   billed at the same time, they could lose money. For example, if the first service 
							   was filed on 6/6/2013, but the second service was not filed until 6/10/2013, 
							   the second service can be denied.

							   ARM would like to customize a report to run against clients who have had the 
							   same service provided in the same day. I've attached a mock up of what I think 
							   would be the report parameters and filters. 

   
    Purpose: Report - Same day, Same Service
           
	Parameters:@StartDate , @EndDate, @ProgramId ,@Client_Id      
               
    Modified By  Modified Date Reason       
    ----------------------------------------------------------------       
    Gautam       06/19/2013  created      
    
	Exec csp_ReportSamedaySameService '06/18/2013',null,null,null
    ************************************************************************************************************/ 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	DECLARE @Title VARCHAR(MAX)
	DECLARE @SubTitle VARCHAR(MAX)
	DECLARE @Comment VARCHAR(MAX)

    SET @Title = 'Report - Same Day, Same Service' 
    SET @SubTitle = 'Start Date: ' +   convert(varchar(10), @StartDate, 101) + '                  ' + 'End Date: ' + convert(varchar(10), @EndDate, 101)
    --SET @Comment = 'High level report logic notes as of 6/19/2013' +char(10) +char(13)
    --            + '1.a.Finds clients for the same service in the same day but by different providers and at different times during date range ,'+char(10) +char(13)
    --            + '2.ARM must bill for both services on the same day,but not necessarily on the DOS during date range,'+char(10) +char(13)
    --            + '2.a.If both services are not billed at the same time, they could lose money,'+char(10) +char(13)
    --            + '3.A report to run against clients who have had the same service provided in the same day'+char(10) +char(13)
              
		
    --Set Report Parts   
    DECLARE @StoredProcedure varchar(300) 

    SET @StoredProcedure = OBJECT_NAME(@@procid) 
    
   	IF @StoredProcedure IS NOT NULL
	AND NOT EXISTS (SELECT 1 FROM CustomReportParts 
					WHERE StoredProcedure = @StoredProcedure
					)
		BEGIN
			INSERT INTO CustomReportParts (StoredProcedure, ReportName, Title, SubTitle, Comment)
			SELECT @StoredProcedure, @Title, @Title, @SubTitle, @Comment
		END
	ELSE
		BEGIN
			UPDATE CustomReportParts
			SET ReportName = @Title
				, Title = @Title
				, SubTitle = @SubTitle
				, Comment = @Comment
			WHERE StoredProcedure = @StoredProcedure
		END
	Create table #RepeatClient
	(
	ClientId int
   ,DOS Date
   ,ProcedureCodeId int 
	)
  Insert into #RepeatClient
	Select S.ClientId ,cast(S.DateOfService as DATE) as 'DOS'
	  ,PC.ProcedureCodeId as 'ProcedureCode'
	From Services S  Inner Join Clients CL on S.ClientId=CL.ClientId
		and isnull(S.RecordDeleted, 'N') = 'N' and isnull(CL.RecordDeleted, 'N') = 'N'
		Inner Join ProcedureCodes PC on S.ProcedureCodeId= PC.ProcedureCodeId
		and isnull(PC.RecordDeleted, 'N') = 'N'
	Where 
			convert(varchar(10),S.DateOfService,101) >= @StartDate and convert(varchar(10),S.EndDateOfService,101) <= ISNULL(@EndDate,@StartDate) and
			S.Status in (71,75)  -- 71 (Show), 75 (Complete)
		and isnull(pc.NotBillable,'N')<>'Y'
		and (@ProgramId is null or S.ProgramId=@ProgramId)
		and (@Client_Id is null or S.ClientId=@Client_Id)
		group by S.ClientId ,cast(S.DateOfService as DATE) ,PC.ProcedureCodeId
	  having COUNT(PC.ProcedureCodeId)>1
  
   Create Table #Report
(
	Name Varchar(120)
   ,ClientId int
   ,DOS DateTime
   ,ServiceStatus Varchar(250)
   ,ServiceId int
   ,ChargeId int
   ,ProcedureCode Varchar(20)
   ,Clinician Varchar(50)
   ,StartTime varchar(8)
   ,EndTime varchar(8)
)
Insert Into #Report   
Select CL.LastName + ', ' + CL.FirstName as 'Name'
	  ,CL.ClientId
	  ,S.DateOfService as 'DOS'
	  ,GC.CodeName as 'ServiceStatus'
	  ,S.ServiceId
	  ,CH.ChargeId
	  ,PC.DisplayAs as 'ProcedureCode'
	  ,ST.LastName + ', ' + ST.FirstName as 'Clinician'
	  ,right(convert(char(20),S.DateOfService,0),7) as 'StartTime'
	  ,right(convert(char(20),S.EndDateOfService,0),7) as 'EndTime'
From Services S  Inner Join Clients CL on S.ClientId=CL.ClientId
   and isnull(S.RecordDeleted, 'N') = 'N' and isnull(CL.RecordDeleted, 'N') = 'N'
   Inner Join ProcedureCodes PC on S.ProcedureCodeId= PC.ProcedureCodeId
     and isnull(PC.RecordDeleted, 'N') = 'N'
  Inner join Staff ST on ST.StaffId=S.ClinicianId
     and isnull(ST.RecordDeleted, 'N') = 'N'
  Inner join GlobalCodes GC on GC.GlobalCodeId=S.Status
  Left outer join Charges CH on CH.ServiceId=S.ServiceId
  inner join #RepeatClient RC on S.ClientId=RC.ClientId and cast(s.DateOfService as DATE)=RC.DOS
					and RC.ProcedureCodeId=PC.ProcedureCodeId

	 --Force columns to show even if empty results being returned
 SELECT r.*, @StoredProcedure AS StoredProcedure
 FROM #Report r
  RIGHT JOIN (SELECT 1 AS forcecolumns) AS a ON a.forcecolumns=a.forcecolumns    
 --ORDER BY ...

 DROP TABLE #Report
drop table #RepeatClient

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED	