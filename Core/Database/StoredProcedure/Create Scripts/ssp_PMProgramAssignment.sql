IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_PMProgramAssignment]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_PMProgramAssignment]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE ssp_PMProgramAssignment

@SessionId				VARCHAR(30),                                                  
@InstanceId				INT,                                                  
@PageNumber				INT,                                                      
@PageSize				INT,                                                      
@SortExpression			VARCHAR(100),                  
@ProgramsFilter			INT,                                                  
@ProgramStatusFilter	INT, 
@ProgramManager			INT,
@ProgramView			INT,			
@Clinician				INT,                               
@OtherFilter			INT,
@FromDate				DATETIME,
@ToDate					DATETIME,
@StaffId				INT,  
@ProgramType			INT,
@CurrentPageScreenId    INT=NULL  
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMProgramAssignment
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Query to return data for the program assignment list page.
--
-- Author:  Sudeep Kumar Ray
-- Date:    03 Mar 2011
--
-- *****History****
-- 15/11/2011		MSuma		Modified the Listpage table name to ListPagePMProgramAssignments
-- 23/03/2012  Amit Kumar Srivastava  Added a parameter @ProgramType
-- 26/03/2012       PSelvan     For Threshold Ace bugs #671 
-- 10/05/2012  Amit Kumar Srivastava ORDER BY ClientName Removed, Due to #936, Teams - Client name filter does not work, 	Thresholds - Bugs/Features (Offshore)
-- 10/05/2012  Amit Kumar Srivastava SET @PageNumber = 1 Removed,changed Rank to row_number , Due to #946, Teams - Teams:Pagination is not working, 	Thresholds - Bugs/Features (Offshore)
-- 16/05/2012  Amit Kumar Srivastava Added ORDER BY RowNumber Removed,changed Rank to row_number , Due to #946, Teams - Teams:Pagination is not working, 	Thresholds - Bugs/Features (Offshore), KGULAU - Reviewer - 5/15/2012 9:14:31 AM Filter still does not work.
-- 22.05.2012 PSelvan		Returning new value GlobalSubCodeId in the final resultset and merged the changes as in 3x Merged.
-- 06/19/2015   Hemant       Added Prerequisite,WaitListPriorityComment,PriorityNumber,MustBeEnrolledByDate,PriorityPopulation and Waitlist priority sort functionality.    
                            in ClientPrograms Why:network180 #616    
--01/july/2015 Basudev Sahu Modified  the ProgramStatusFilter value to filter GlobalCodeId instead of GlobalSubCodeId For Core Bug  Task #1810    
--11/26/2015 Munish Sood  Changed the value from 505 to 5 as per the Interact - Support 431    
    
-- 19 Oct 2015 Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.        
--										why:task #609, Network180 Customization

-- 08/06/2016  Pabitra      What:TRR Tracks should not be shown on Program List Page (Client Tab/ Program Tab) Added parameter @CurrentPageScreenId
                               Why:Task #4  Camino - Support Go Live 
-- 11/20/2017 Aravinda     What: Modified the logic to keep only date for the columns "RequestedDate", "EnrolledDate", and "DischargeDate" 
                            Why:New Directions - Support Go Live: #697 
                            
-- 12/04/2017 Mrunali       What: Changed temporary table name from  #CustomFilters to #CustomFilters_PMProgramAssignment 
                            Why : Network180 Support Go Live#114                           
-- 24-July-2018	Deej				Added Logic to  bind the records only for the staff has access to Units and Programs. Bradford - Enhancements #400.2
*****************************************************************************************************************************************************/
                                                     
                                         
AS     
BEGIN                                                              
	BEGIN TRY    
--Added by Deej
    DECLARE @ListDataBasedOnStaffsAccessToProgramsAndUnits varchar(3)  
    --SET @ListDataBasedOnStaffsAccessToProgramsAndUnits= CASE WHEN ssf_GetSystemConfigurationKeyValue( 'EnableStaffsAssociatedUnitAndProgramsFilteringInData') = 'Yes' THEN 'Y'
    SELECT @ListDataBasedOnStaffsAccessToProgramsAndUnits = CASE WHEN [Value]='Yes' THEN 'Y' ELSE 'N' END 
    FROM SystemConfigurationKeys WHERE [Key]= 'FilterDataBasedOnStaffAssociatedToProgramsAndUnits'   
  CREATE TABLE #CustomFilters_PMProgramAssignment    
                (    
                  ClientProgramId INT NOT NULL     
                )   
                
                
      CREATE TABLE #ResultSet
                (	ClientId  INT NULL,    
					ClientName VARCHAR(250) NULL,                               
					ClientProgramId  INT NULL,                                              
					ProgramName  VARCHAR(250),      
					ProgramId INT NULL,                        
					[Status] VARCHAR(250) NULL,    
					GlobalCodeId INT NULL,    
					RequestedDate DATETIME NULL,                       
					EnrolledDate DATETIME NULL,                         
					DischargedDate DATETIME NULL,                        
					ClinicianName VARCHAR(250) NULL,                        
					PrimaryAssignment CHAR(10) NULL,     
					Prerequisite INT NULL,    
					WaitListPriorityComment varchar(max) NULL,    
					PriorityNumber int NULL,    
					MustBeEnrolledByDate DATETIME,    
					PriorityPopulationDescription VARCHAR(100) NULL,    
					color varchar(10) NULL,     
					PriorityPopulation VARCHAR(MAX) NULL 
					)
    
    
					
                                                                
                                                                                                         
  DECLARE @ApplyFilterClicked  CHAR(1)    
  DECLARE @CustomFiltersApplied CHAR(1) 
  
  --Pabitra 06/08/2016
------Begin---

CREATE TABLE #ExcludePrograms(ProgramsType VARCHAR(500) NULL)
CREATE TABLE #tempExcludeProgramTYPE(ProgramsTypeList VARCHAR(500) NULL)

DECLARE @ExcludePrograms CHAR(500)    
SELECT @ExcludePrograms = ScreenParamters FROM Screens WHERE ScreenId=@CurrentPageScreenId 
INSERT INTO  #tempExcludeProgramTYPE(ProgramsTypeList)
SELECT item  FROM [dbo].fnSplit(@ExcludePrograms, '^')


DECLARE @ExcludeProgramTYPE CHAR(500) =  (SELECT  TOP 1 Substring(ProgramsTypeList, Charindex('=', ProgramsTypeList)+1, LEN(ProgramsTypeList)) from #tempExcludeProgramTYPE where ProgramsTypeList like 'EXCLUDEPROGRAMTYPE=%' )
INSERT INTO  #ExcludePrograms(ProgramsType)
select item  from [dbo].fnSplit(@ExcludeProgramTYPE, ',') 
-------End--- 
      
 if(@SortExpression = 'PriorityNumber DESC')    
 BEGIN    
 SET @SortExpression ='PriorityNumber'    
 END    
     
 DECLARE @color1 varchar(10), @color2 varchar(10),@MustEnrollWithin INT,@MustEnrollBetween1 INT,@MustEnrollBetween2 INT;    
     
 SET @color1 =(Select RuleFirstColor from ProgramAssignmentWaitlistPriorityColorConfigurations)     
 SET @color2 =(Select RuleSecondColor from ProgramAssignmentWaitlistPriorityColorConfigurations)    
     
 SET @MustEnrollWithin =(Select MustEnrollWithinDays from ProgramAssignmentWaitlistPriorityColorConfigurations)     
 SET @MustEnrollBetween1 =(Select MustEnrollFromDays from ProgramAssignmentWaitlistPriorityColorConfigurations)    
 SET @MustEnrollBetween2 =(Select MustEnrollToDays from ProgramAssignmentWaitlistPriorityColorConfigurations)    
      
  SET @SortExpression = RTRIM(LTRIM(@SortExpression))    
  IF ISNULL(@SortExpression, '') = ''    
   SET @SortExpression= 'ClientName'    
       
  IF( @FromDate = CONVERT(DATETIME, N'') )    
  BEGIN    
   SET @FromDate = NULL    
  END    
      
  IF( @ToDate = CONVERT(DATETIME, N'') )    
  BEGIN    
   SET @ToDate = NULL    
  END    
      
      
  --     
  -- New retrieve - the request came by clicking on the Apply Filter button                       
  --    
  SET @ApplyFilterClicked = 'Y'     
  SET @CustomFiltersApplied = 'N'                                                     
  --SET @PageNumber = 1    
      
  IF @ProgramStatusFilter > 10000 OR @OtherFilter > 10000                                        
  BEGIN    
   SET @CustomFiltersApplied = 'Y'    
       
   INSERT INTO #CustomFilters_PMProgramAssignment (ClientProgramId)     
   EXEC scsp_PMProgramAssignment     
    @ProgramsFilter   =@ProgramsFilter,                                                      
    @ProgramStatusFilter =@ProgramStatusFilter,    
    @ProgramManager   =@ProgramManager,    
    @ProgramView   =@ProgramView,     
    @Clinician    =@Clinician,    
    @OtherFilter   =@OtherFilter,    
    @FromDate    =@FromDate,    
    @ToDate     =@ToDate,    
    @StaffId    =@StaffId,    
    @ProgramType   =@ProgramType    
  END     
      
  ALTER TABLE #CustomFilters_PMProgramAssignment ADD  CONSTRAINT [CustomerFilters_PMProgramAssignment_PK] PRIMARY KEY CLUSTERED     
            (    
            [ClientProgramId] ASC    
            ) ;    
                
  
  insert into #ResultSet(   
				ClientId  ,    
				ClientName ,                               
				ClientProgramId  ,                                              
				ProgramName ,      
				ProgramId ,                        
				[Status] ,    
				GlobalCodeId ,    
				RequestedDate ,                       
				EnrolledDate ,                         
				DischargedDate ,                        
				ClinicianName ,                        
				PrimaryAssignment ,     
				Prerequisite ,    
				WaitListPriorityComment ,    
				PriorityNumber ,    
				MustBeEnrolledByDate,    
				PriorityPopulationDescription ,    
				color ,     
				PriorityPopulation  
				)
				SELECT  c.ClientId,   
  case when ISNULL(C.ClientType,'I')='I' then  
  c.LastName + ',' + + ' ' + c.FirstName   
  else C.OrganizationName end AS ClientName  
  , cp.ClientProgramId,    
    p.ProgramName, p.ProgramId, gc.CodeName as [Status],gc.GlobalCodeId, cp.RequestedDate, cp.EnrolledDate,    
    cp.DischargedDate, s.LastName + ',' + + ' ' + s.FirstName AS ClinicianName,     
    CASE cp.PrimaryAssignment WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' END AS PrimaryAssignment,cp.Prerequisite,cp.WaitListPriorityComment,cp.PriorityNumber,cp.MustBeEnrolledByDate,    
     
  cp.PriorityPopulation as 'PriorityPopulationDescription',    
  CASE WHEN dateDiff(dd,GETDATE(),cp.MustBeEnrolledByDate)=@MustEnrollWithin    
  THEN @color1    
  WHEN @MustEnrollBetween1 <= dateDiff(dd,GETDATE(),cp.MustBeEnrolledByDate) and dateDiff(dd,GETDATE(),cp.MustBeEnrolledByDate) <= @MustEnrollBetween2    
  THEN @color2    
  END AS 'color',    
  '' AS 'PriorityPopulation'    
      
  FROM Clients AS c     
   INNER JOIN ClientPrograms AS cp ON cp.ClientId = c.ClientId     
   INNER JOIN Programs AS p ON p.ProgramId = cp.ProgramId     
   INNER JOIN StaffClients sc ON sc.StaffId = @StaffId AND sc.ClientId = c.ClientId    
   INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = cp.Status     
    AND ISNULL(gc.RecordDeleted, 'N') = 'N'     
    AND gc.Active = 'Y'     
   LEFT OUTER JOIN Staff AS s ON s.StaffId = c.PrimaryClinicianId                         
  WHERE     
  --Added by Deej 7/24/2018
    (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
    (EXISTS(SELECT 1 FROM StaffPrograms SP WHERE SP.StaffId=@StaffId AND SP.ProgramId=P.ProgramId AND ISNULL(SP.RecordDeleted,'N')='N'  ) ))) AND
  (     
   ISNULL(cp.RecordDeleted,'N') = 'N'                         
   AND ISNULL(c.RecordDeleted,'N') = 'N'                           
   AND ISNULL(p.RecordDeleted,'N') = 'N'     
 --AND (p.ProgramType =@ProgramType or ISNULL(@ProgramType,-1) = -1)
  AND (p.ProgramType =@ProgramType or (ISNULL(@ProgramType,-1) = -1 AND (not exists(select 1 from  #ExcludePrograms where ProgramsType=p.ProgramType))) )  
   AND ((@CustomFiltersApplied = 'Y' AND EXISTS(SELECT * FROM #CustomFilters_PMProgramAssignment cf WHERE cf.ClientProgramId = cp.ClientProgramId)) OR    
       (@CustomFiltersApplied = 'N'    
     AND (p.ProgramId = @ProgramsFilter OR ISNULL(@ProgramsFilter,-1) = -1)    
     -- Status Check    
     --AND (@ProgramStatusFilter = 501 OR         -- All Statuses      
     --  (@ProgramStatusFilter = 502 AND cp.[Status] = 1) OR         -- Requested                   
     --  (@ProgramStatusFilter = 503 AND cp.[Status] = 3) OR         -- Scheduled                   
     --  (@ProgramStatusFilter = 504 AND cp.[Status] = 4) OR   -- Enrolled     
     --  (@ProgramStatusFilter = 505 AND cp.[Status] = 5)    -- Discharged   
     --  )      
         
     --01/july/2015 Basudev Sahu      
      AND (@ProgramStatusFilter = -1 OR                  -- All Statuses      
        (cp.[Status] = @ProgramStatusFilter)                         
      )    
                       
      -- Program Manager Check    
     AND (ISNULL(@ProgramManager,-1) = -1 OR EXISTS (SELECT * FROM Programs WHERE ProgramId=CP.PRogramId AND Programs.ProgramManager=@ProgramManager))    
      -- Program Views Check    
     AND (ISNULL(@ProgramView,-1) = -1 OR CP.ProgramId IN (SELECT ProgramId FROM ProgramViewPrograms WHERE ProgramViewId=@ProgramView ))    
      -- Clinician Check    
     AND (ISNULL(@Clinician,-1) = -1 OR s.StaffId = @Clinician)    
      -- Date Check    
     AND     
     -- If All statuses is selected filter by date accordingly    
     --(((@ProgramStatusFilter = 501) AND    
     --01/july/2015 Basudev Sahu     
     (((@ProgramStatusFilter = -1) AND    
      (((CP.Status = 1 OR CP.Status = 3) AND     
       (CP.RequestedDate IS NULL OR     
       (CP.RequestedDate IS NOT NULL AND     
       (@FromDate IS NULL OR CP.RequestedDate >= @FromDate) AND     
       (@ToDate IS NULL OR CP.RequestedDate <= @ToDate)))) OR    
      (CP.Status = 4 AND (CP.EnrolledDate IS NULL OR     
       (CP.EnrolledDate IS NOT NULL AND     
       (@FromDate IS NULL OR CP.EnrolledDate >= @FromDate) AND     
       (@ToDate IS NULL OR CP.EnrolledDate <= @ToDate)))) OR    
      (CP.Status = 5 AND (CP.DischargedDate IS NULL OR     
       (CP.DischargedDate IS NOT NULL AND     
       (@FromDate IS NULL OR CP.DischargedDate >= @FromDate) AND     
       (@ToDate IS NULL OR CP.DischargedDate <= @ToDate)))))    
     )     
     OR    
     -- If requested or scheduled is selected filter only by requested value    
     --((@ProgramStatusFilter = 502 OR @ProgramStatusFilter = 503) AND    
     --01/july/2015 Basudev Sahu     
     ((@ProgramStatusFilter = 1 OR @ProgramStatusFilter = 3) AND    
      (CP.RequestedDate IS NULL OR     
       (CP.RequestedDate IS NOT NULL AND     
       (@FromDate IS NULL OR CP.RequestedDate >= @FromDate) AND     
       (@ToDate IS NULL OR CP.RequestedDate <= @ToDate)))    
     ) OR    
     -- If enrolled is selected filter only by enrolled value    
     --((@ProgramStatusFilter = 504) AND    
     --01/july/2015 Basudev Sahu     
     ((@ProgramStatusFilter = 4) AND    
      (CP.EnrolledDate IS NULL OR     
       (CP.EnrolledDate IS NOT NULL AND     
       (@FromDate IS NULL OR CP.EnrolledDate >= @FromDate) AND     
       (@ToDate IS NULL OR CP.EnrolledDate <=@ToDate)))    
     ) OR    
     -- If discharged is selected filter only by discharged value    
     --((@ProgramStatusFilter = 505) AND    
     --01/july/2015 Basudev Sahu     
     -- 11/26/2015 Munish Sood changed the value from 505 to 5    
     ((@ProgramStatusFilter = 5) AND    
      (CP.DischargedDate IS NULL OR     
       (CP.DischargedDate IS NOT NULL AND     
       (@FromDate IS NULL OR CP.DischargedDate >= @FromDate) AND     
       (@ToDate IS NULL OR CP.DischargedDate <=@ToDate)))    
     ))    
    ))    
  )    
      

;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ClientId  ,    
				ClientName ,                               
				ClientProgramId  ,                                              
				ProgramName ,      
				ProgramId ,                        
				[Status] ,    
				GlobalCodeId ,    
				RequestedDate ,                       
				EnrolledDate ,                         
				DischargedDate ,                        
				ClinicianName ,                        
				PrimaryAssignment ,     
				Prerequisite ,    
				WaitListPriorityComment ,    
				PriorityNumber ,    
				MustBeEnrolledByDate,    
				PriorityPopulationDescription ,    
				color ,     
				PriorityPopulation                          
				,Count(*) OVER () AS TotalCount
				, row_number() OVER ( ORDER BY     
                CASE WHEN @SortExpression= 'ClientName'    THEN ClientName END,                                      
    CASE WHEN @SortExpression= 'ClientName DESC'  THEN ClientName END DESC,                                            
    CASE WHEN @SortExpression= 'Status'     THEN [Status] END,                                                
    CASE WHEN @SortExpression= 'Status DESC'   THEN [Status] END DESC,    
    CASE WHEN @SortExpression= 'RequestedDate'   THEN RequestedDate END,    
    CASE WHEN @SortExpression= 'RequestedDate DESC'  THEN RequestedDate  END  DESC,     
    CASE WHEN @SortExpression= 'EnrolledDate'   THEN EnrolledDate END,    
    CASE WHEN @SortExpression= 'EnrolledDate DESC'  THEN EnrolledDate  END  DESC,      
    CASE WHEN @SortExpression= 'DischargedDate'   THEN DischargedDate END,                                                
    CASE WHEN @SortExpression= 'DischargedDate DESC' THEN DischargedDate END DESC,                                             
    CASE WHEN @SortExpression= 'ClinicianName'   THEN ClinicianName END,                                                
    CASE WHEN @SortExpression= 'ClinicianName DESC'  THEN ClinicianName END DESC,                                            
    CASE WHEN @SortExpression= 'PrimaryAssignment'  THEN PrimaryAssignment END,                                                
    CASE WHEN @SortExpression= 'PrimaryAssignment DESC' THEN PrimaryAssignment END DESC,    
    CASE WHEN @SortExpression= 'ProgramName'   THEN ProgramName END,                                      
    CASE WHEN @SortExpression= 'ProgramName DESC'  THEN ProgramName END DESC,     
    CASE WHEN PriorityNumber is null and @SortExpression ='PriorityNumber' THEN 1 ELSE 0 END,Status DESC,PriorityNumber asc,RequestedDate desc,ClientName ASC,    
    ClientProgramId    
    )  AS RowNumber                                               
               from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  ClientId  ,    
				ClientName ,                               
				ClientProgramId  ,                                              
				ProgramName ,      
				ProgramId ,                        
				[Status] ,    
				GlobalCodeId ,    
				RequestedDate ,                       
				EnrolledDate ,                         
				DischargedDate ,                        
				ClinicianName ,                        
				PrimaryAssignment ,     
				Prerequisite ,    
				WaitListPriorityComment ,    
				PriorityNumber ,    
				MustBeEnrolledByDate,    
				PriorityPopulationDescription ,    
				color ,     
				PriorityPopulation   ,                              
			 TotalCount,
			 RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT ISNULL(Count(*), 0)	FROM #FinalResultSet) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

	SELECT    
		ClientId,     
		ClientName,                               
		ClientProgramId,                                              
		ProgramName ,      
		ProgramId,                        
		[Status] ,    
		CASE GlobalCodeId     
		WHEN '1' THEN '502'    
		WHEN '3' THEN '503'    
		WHEN '4' THEN '504'    
		WHEN '5' THEN '505'    
		ELSE '501'    
		END as GlobalSubCodeId,
		---  Aravind 11/20/2017
		---Begin---
		CONVERT(varchar(10), RequestedDate, 101) AS RequestedDate,      
        CONVERT(varchar(10), EnrolledDate, 101) AS EnrolledDate,      
		CONVERT(varchar(10), DischargedDate, 101) AS DischargedDate, 
      -- End ---                             
		ClinicianName ,                        
		PrimaryAssignment,    
		[dbo].ssf_GetGlobalCodeNameById(Prerequisite) as 'Prerequisite',    
		WaitListPriorityComment,    
		PriorityNumber,    
		MustBeEnrolledByDate,    
		PriorityPopulationDescription,    
		color,    
		PriorityPopulation         
		FROM #FinalResultSet
		ORDER BY RowNumber 
		
   -- DROP TABLE #ExcludePrograms
   -- DROP TABLE #tempExcludeProgramTYPE     
 END TRY    
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                 
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMProgramAssignment')                                                                                                 
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                  
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())    
  RAISERROR    
  (    
   @Error, -- Message text.    
   16,  -- Severity.    
   1  -- State.    
  );    
 END CATCH    
END
GO
		
     
    