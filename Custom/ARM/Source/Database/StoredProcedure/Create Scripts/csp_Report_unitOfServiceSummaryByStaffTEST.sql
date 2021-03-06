/****** Object:  StoredProcedure [dbo].[csp_Report_unitOfServiceSummaryByStaffTEST]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_unitOfServiceSummaryByStaffTEST]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_unitOfServiceSummaryByStaffTEST]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_unitOfServiceSummaryByStaffTEST]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
CREATE proc [dbo].[csp_Report_unitOfServiceSummaryByStaffTEST]
  	                         @StartDate		AS DateTime 
                            ,@EndDate		AS DateTime 
							,@ReportType	AS INT  --Supervior or staff report	
							,@ReportValue	AS INT
							,@Billable		AS INT  -- 0 Mean All, 1 Billable, 2 Not Billable
							,@ServiceAreaID AS INT  -- 0 Means don''t group by, 1 means group by 
							,@ProgramID		AS INT  -- 0 Means don''t group by, 1 means group by 
							,@locationID    AS INT  -- 0 Means don''t group by, 1 means group by 
			
  AS
BEGIN
      
/*      
declare 
  	                         @StartDate		AS DateTime 
                            ,@EndDate		AS DateTime 
							,@ReportType	AS INT  --Supervior or staff report	
							,@ReportValue	AS INT
							,@Billable		AS INT  -- 0 Mean All, 1 Billable, 2 Not Billable
							,@ServiceAreaID AS INT  -- 0 Means don''t group by, 1 means group by 
							,@ProgramID		AS INT  -- 0 Means don''t group by, 1 means group by 
							,@locationID    AS INT  -- 0 Means don''t group by, 1 means group by 

			SET				@StartDate		=''12/12/2011'' 
			SET             @EndDate		=''6/12/2012''--AS DateTime 
			SET				@ReportType		=1  --Supervior or staff report	
			SET				@ReportValue	=1396
			SET				@Billable		=0
         
      
exec [dbo].[csp_Report_unitOfServiceSummaryByStaffTEST]
  	                         @StartDate		
                            ,@EndDate		
							,@ReportType	
							,@ReportValue	
							,@Billable		
							,@ServiceAreaID 
							,@ProgramID		
							,@locationID    

*/      
      IF OBJECT_ID(''tempdb..#SummaryServiceUnitStaff'') is not null
     BEGIN DROP TABLE #SummaryServiceUnitStaff 
      
       End 

      
	 CREATE TABLE #SummaryServiceUnitStaff (
 			  
			     StaffID				INT NOT NULL,
			     StaffName			VARCHAR(50) NOT NULL,
			     SupervisorID			INT NULL,
        		 SupervisorName		VARCHAR(50) NULL
			     )
      
      
      if @ReportType=1 	 -- Select the Supervisor and His staffs for the selected Supervisor
	 BEGIN 
		       		
      		INSERT	#SummaryServiceUnitStaff
	 
			 SELECT   Distinct
					  S.StaffID			AS StaffID
			         ,S.LastName  + '', ''+S.FirstName	AS StaffName
					 ,SS.SupervisorID	AS SupervisorID
					 ,S2.LastName + '', ''+S2.FirstName		AS SupervisorName  
				
			 From Staff AS S
			 Inner Join StaffSupervisors AS SS ON SS.StaffID =S.StaffID
			 Inner Join Staff            AS S2 ON SS.SuperVisorID=S2.StaffID
			 where SS.SuperVisorID=@ReportValue
			 
			 
			 
        End
ELSE IF @ReportType=2
	BEGIN  
	      -- Select the Staff and His Superviors for the selected staff
			INSERT	#SummaryServiceUnitStaff
      			
			 SELECT Distinct  
					  S.StaffID							AS StaffID
			         ,S.LastName  + '', ''+S.FirstName	AS StaffName
					 ,SS.SupervisorID					AS SupervisorID
					 ,S2.LastName + '', ''+S2.FirstName	AS SupervisorName 
			
			 FROM Staff AS S
			 LEFT JOIN StaffSuperVisors AS SS ON SS.StaffID =S.StaffID
			 LEFT JOIN Staff            AS S2 ON SS.SuperVisorID=S2.StaffID
			 where S.StaffID=@ReportValue
			 And ( SS.StaffSuperVisorID in (
										   SELECT MAX(StaffSupervisorID)AS StaffSuperVisorID
										   FROM StaffSupervisors
										   WHERE StaffID=@ReportValue
										   Group By StaffID
										   )
										   Or SS.StaffSuperVisorID IS NULL)
										   
										--   Select * from #SummaryServiceUnitStaff
 
     END 
      
      
      
      IF OBJECT_ID(''tempdb..#SummaryServiceUnitList'') is not null
drop table #SummaryServiceUnitList
      
      
      
      
      
      
      
  
   Select  
			  S.ServiceID 
             ,S.ProcedureCodeID
             ,ClinicianID
             ,Billable
             ,ClientID
             ,PR.ProgramId
             ,pr.ProgramName
             ,SR.ServiceAreaId
             ,SR.ServiceAreaName
             ,LO.LocationCode
             ,LO.LocationId
            -- ,CAT.CodeName
             ,PC.DisplayAs AS ProcedureCode
             ,Stf.*
             ,CASE WHEN S.UnitType=110 AND (	 PC.DisplayAs <> ''GROUP_CN'' Or PC.DisplayAs <> ''CSP_GROUP''
                                              OR PC.DisplayAs <> ''SA_IOP''   OR PC.DisplayAs <> ''SA_GROUPCN'' 
                                              OR PC.DisplayAs <> ''PART_HOSP''OR PC.DisplayAs <> ''EDUC_CLASS''
                                            ) 
			 THEN CONVERT(FLOAT,Unit/60)
             WHEN PC.DisplayAs =''PART_HOSP'' and S.Unit <>1  THEN CONVERT(FLOAT,(Unit))/180 
             WHEN PC.DisplayAs =''PART_HOSP'' and (S.Unit =1 or S.Unit=10) THEN 1
             WHEN S.UnitType=110 and (PC.DisplayAs  = ''GROUP_CN''  or PC.DisplayAs =''CSP_GROUP''
                                   or PC.DisplayAs  = ''SA_IOP''    or PC.DisplayAs  = ''SA_GROUPCN''
                                      ) THEN CONVERT(FLOAT,(unit/60))/3 
		          
            WHEN S.UnitType =110 and PC.DisplayAs = ''EDUC_CLASS''		 THEN CONVERT(FLOAT,Unit)/60/6   
	        WHEN S.UnitType =111 or S.UnitType=112 or S.UnitType=113     THEN CONVERT(FLOAT,Unit) /60 
			 END								AS Duration_units
			,S.GroupServiceID					AS GroupServiceID
			,1									AS num_co_therapists
			,CASE WHEN s.Status in (71,75) then ''Completed'' Else ''Not Completed'' end As ServiceStatus 
			,CASE WHEN s.Status in (71,75) then  1 Else 0 End As  ServiceStatusID  
			,Cast(Null As Decimal)  AS Units
			
	Into #SummaryServiceUnitList 
    FROM Services				AS S
       JOIN ProcedureCodes		AS PC	ON S.ProcedureCodeID=PC.ProcedureCodeID
       JOIN Programs            AS PR   ON PR.ProgramId=S.ProgramId
       Join ServiceAreas        AS SR   ON SR.ServiceAreaId=PR.ServiceAreaId
       jOIN Locations           AS LO   ON LO.LocationId=S.LocationId
       JOIN #SummaryServiceUnitStaff    AS Stf	ON stf.StaffID =ClinicianID
       
    --INNER JOIN #SummaryServiceUnitStaff    AS Stf	ON stf.StaffID =ClinicianID
   WHERE ISNULL(S.RecordDeleted,''N'')<>''Y''
   AND S.[Status]in (  71 -- Show,
                      ,75 --Completed
                      ,72 -- No show
                      ,73 -- cancel
                      )								-- Completed Status
  And (DateOfService <=@EndDate 
  And  DateofService >=@StartDate)   
  --And  Billable= case  @Billable
  --                     when 0 Then Billable  --All
  --                     when 1 Then ''Y''       -- Billable only
  --                     When 2 then ''N''		 -- Not Billable
  --                     Else ''Y'' End          -- Default to Bill O
   AND ( 
	( ( pc.NotBillable = ''N'' OR s.Billable = ''Y'' )		
		AND @Billable = 1 )
	OR
	( ( pc.NotBillable = ''Y'' OR s.Billable = ''N'' )
		AND @Billable = 2 )
	OR
	( @Billable = 0 )
      )  

           
      
      
      
      
      
  UPDATE S 
	SET S.num_co_therapists = GrpService.num_co_therapists
	,Duration_units=Duration_units/GrpService.num_co_therapists			
FROM #SummaryServiceUnitList AS S
Inner Join (  
			SELECT GroupServiceID,count(StaffId)AS num_co_therapists 
				 FROM GroupServiceStaff cts	 with (nolock)
				 WHERE GroupServiceID in 
									( Select GroupServiceID   from #SummaryServiceUnitList
	     							 Where GroupServiceID IS Not Null
	     							 )
			Group by GroupServiceID 
		  ) AS GrpService
on  GrpService.GroupServiceID=s.GroupServiceID
      
      
      
     
     
  IF OBJECT_ID(''tempdb..#SummaryServiceUnitsResult'') is not null
		drop table #SummaryServiceUnitsResult
      
      
      
      
   Select 
             S.SupervisorName 
			,ServiceAreaName
			,ProgramName
			,LocationCode
			,s.staffID
			,S.StaffName
			,ProcedureCodeCatgory
			,Sum(UnitsCompleted)			AS UnitsCompleted
			,Sum(UnitsNotCompleted)			AS UnitsNotCompleted
			,Sum(VisitCompleted)			AS VisitCompleted
			,Sum(VisitNotCompleted)			AS VisitNotCompleted
		    ,SUM(NumberofClients)		AS NumberOfClients
		Into #SummaryServiceUnitsResult
				
           From (   SELECT  	S.SupervisorName 
								,CASE WHEN @ServiceAreaID=0 THEN NULL ELSE ServiceAreaName END ServiceAreaName
								,CASE WHEN @ProgramID=0		THEN NULL ELSE ProgramName     END AS ProgramName
								,CASE WHEN @locationID=0	 THEN NULL ELSE LocationCode     END AS LocationCode
								,s.staffID
								,S.StaffName
								,CodeName  AS ProcedureCodeCatgory
								,Case when ServiceStatusID=1 then Sum(s.Duration_units) Else 0 End AS UnitsCompleted
								,Case when ServiceStatusID=0 then Sum(s.Duration_units) Else 0 End AS UnitsNotCompleted
								,Case when ServiceStatusID=1 then  Count( s.ClientID)  Else 0 End AS VisitCompleted
								,Case when ServiceStatusID=0 then  Count( s.ClientID)  Else 0 End AS VisitNotCompleted
								, COUNT(DISTINCT clientId) AS NumberOfClients					FROM  #SummaryServiceUnitList S						Inner Join ( Select CodeName,ProcedureCodeID										from CustomUnitsOfServiceProcedureCategories  AS P 										inner join GlobalCodes on ProcedureCategory = GlobalCodeID									)AS Cat On S.ProcedureCodeId=Cat.ProcedureCodeID					  Group by  							  Grouping sets((S.SupervisorID
											,S.SupervisorName 
											 ,CASE WHEN @ServiceAreaID=0 THEN NULL ELSE ServiceAreaName END 
											 ,CASE WHEN @ProgramID=0	 THEN NULL ELSE ProgramName     END 
											 ,CASE WHEN @locationID=0	 THEN NULL ELSE LocationCode    END 
										     , s.staffID
											 ,S.StaffName											 ,CodeName											 ,ServiceStatusID)											)									 				) AS S      Group by S.SupervisorName 
			,ServiceAreaName
			,ProgramName
			,LocationCode
			,s.staffID
			,S.StaffName
			,ProcedureCodeCatgory
			



IF OBJECT_ID(''tempdb..#SummaryServiceUnitList'') is not null
     drop table #SummaryServiceUnitList
      
    
       Select  s.* 
   --          S.SupervisorName 
			--,CASE WHEN @ServiceAreaID=0 THEN NULL ELSE ServiceAreaName END ServiceAreaName
			--,CASE WHEN @ProgramID=0		THEN NULL ELSE ProgramName     END AS ProgramName
			--,CASE WHEN @locationID=0	 THEN NULL ELSE LocationCode     END AS LocationCode
			--,s.staffID
			--,S.StaffName
			--,ProcedureCodeCatgory
			--,Sum(UnitsCompleted)			AS UnitsCompleted
			--,Sum(UnitsNotCompleted)			AS UnitsNotCompleted
			--,Sum(VisitCompleted)			AS VisitCompleted
			--,Sum(VisitNotCompleted)			AS VisitNotCompleted
     ,f.OrganizationName
       from #SummaryServiceUnitsResult AS S
       cross join SystemConfigurations f
    --   Group by  S.SupervisorName 
    --            ,CASE WHEN @ServiceAreaID=0 THEN NULL ELSE ServiceAreaName END 
				--,CASE WHEN @ProgramID=0		THEN NULL ELSE ProgramName     END 
				--,CASE WHEN @locationID=0	THEN NULL ELSE LocationCode    END 
    --            ,s.staffID
    --            ,S.StaffName
			 --   ,ProcedureCodeCatgory
			   -- ,f.OrganizationName
       ORDER BY S.SupervisorName 
                ,CASE WHEN @ServiceAreaID=0 THEN NULL ELSE ServiceAreaName END 
				,CASE WHEN @ProgramID=0		THEN NULL ELSE ProgramName     END 
				,CASE WHEN @locationID=0	THEN NULL ELSE LocationCode    END 
                ,s.staffID
			    ,S.StaffName
			    ,ProcedureCodeCatgory
                
      
      
            IF OBJECT_ID(''tempdb..#SummaryServiceUnitStaff'') is not null
     BEGIN DROP TABLE #SummaryServiceUnitStaff 
      
       End  
       
END
' 
END
GO
