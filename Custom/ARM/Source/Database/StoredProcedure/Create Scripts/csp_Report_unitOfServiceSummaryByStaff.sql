/****** Object:  StoredProcedure [dbo].[csp_Report_unitOfServiceSummaryByStaff]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_unitOfServiceSummaryByStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_unitOfServiceSummaryByStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_unitOfServiceSummaryByStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE proc [dbo].[csp_Report_unitOfServiceSummaryByStaff]
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


			--Declare				@StartDate		DateTime
			--Declare             @EndDate		AS DateTime
			--Declare				@ReportType	AS INT  --Supervior or staff report	
			--Declare				@ReportValue	AS INT
			--Declare				@Billable		AS INT


			--SET				@StartDate		=''12/12/2011''
			--SET             @EndDate		=''6/12/2012''--AS DateTime
			--SET				@ReportType		=1  --Supervior or staff report	
			--SET				@ReportValue	=1396
			--SET				@Billable		=0



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
                  left join (
					select ss1.StaffId, min(ss1.SupervisorId) as SupervisorId
					from dbo.StaffSupervisors as ss1
					where ISNULL(ss1.RecordDeleted, ''N'') <> ''Y''
					group by ss1.StaffId
				  ) as ss on ss.StaffId = S.StaffId
				  LEFT JOIN Staff AS S2 ON SS.SuperVisorID=S2.StaffID
				  WHERE S.StaffID=@ReportValue

     END



      IF OBJECT_ID(''tempdb..#SummaryServiceUnitList'') is not null
		drop table #SummaryServiceUnitList








   Select
			  S.ServiceID
			  ,s.DateOfService
             ,S.ProcedureCodeID
             ,ClinicianID
			,Billable = case when C.ProcedureCategory is not null then ''Y'' else ''N'' end
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
             ,	CASE WHEN S.UnitType=110 AND (
			PC.DisplayAs <> ''GROUP_CN'' and PC.DisplayAs <> ''CSP_GROUP''
			and PC.DisplayAs <> ''SA_IOP'' and PC.DisplayAs <> ''SA_GROUPCN''
			and PC.DisplayAs <> ''PART_HOSP'' and PC.DisplayAs <> ''EDUC_CLASS''
			and pc.DisplayAs <> ''CBA_GROUP'') THEN CONVERT(FLOAT,Unit/60)
        WHEN PC.DisplayAs =''PART_HOSP'' and S.Unit <>1  THEN CONVERT(FLOAT,(Unit))/180
		WHEN PC.DisplayAs =''PART_HOSP'' and (S.Unit =1 or S.Unit=10) THEN 1
		WHEN S.UnitType=110 and (PC.DisplayAs  = ''GROUP_CN''  or PC.DisplayAs =''CSP_GROUP''
			OR PC.DisplayAs  = ''SA_IOP''    
			or PC.DisplayAs  = ''SA_GROUPCN'' or pc.DisplayAs = ''CBA_GROUP'') THEN CONVERT(FLOAT,(unit/60))/3
		WHEN S.UnitType =110 and PC.DisplayAs = ''EDUC_CLASS''        THEN CONVERT(FLOAT,Unit)/60/6
		WHEN S.UnitType =111 or S.UnitType=112 or S.UnitType=113     THEN CONVERT(FLOAT,Unit) /60
			END AS Duration_units,
		CAST(null as int) AS num_co_therapists,
		Cast(Null As Decimal)  AS Units,
		case
			WHEN S.UnitType=110
				and (
					PC.DisplayAs  = ''GROUP_CN''
					or PC.DisplayAs =''CSP_GROUP''
					OR PC.DisplayAs  = ''SA_IOP''
					or PC.DisplayAs  = ''SA_GROUPCN''
					or PC.DisplayAs = ''EDUC_CLASS''
					or pc.DisplayAs = ''CBA_GROUP''
				) then ''Y''
			else ''N'' 
		end as isGroupService

			,S.GroupServiceID					AS GroupServiceID
			,CASE WHEN s.Status in (75) then ''Completed'' when s.status in (71) then ''Pending'' Else ''Not Completed'' end As ServiceStatus
			,CASE WHEN s.Status in (75) then  1 when s.Status in (71) then 2 Else 0 End As  ServiceStatusID
		
	Into #SummaryServiceUnitList
    FROM Services				AS S
       JOIN ProcedureCodes		AS PC	ON S.ProcedureCodeID=PC.ProcedureCodeID
       JOIN Programs            AS PR   ON PR.ProgramId=S.ProgramId
       Join ServiceAreas        AS SR   ON SR.ServiceAreaId=PR.ServiceAreaId
       jOIN Locations           AS LO   ON LO.LocationId=S.LocationId
       LEFT JOIN CustomUnitsOfServiceProcedureCategories C ON c.ProcedureCodeId = PC.ProcedureCodeId
       JOIN #SummaryServiceUnitStaff    AS Stf	ON stf.StaffID =ClinicianID

    --INNER JOIN #SummaryServiceUnitStaff    AS Stf	ON stf.StaffID =ClinicianID
   WHERE ISNULL(S.RecordDeleted,''N'')<>''Y''
   AND S.[Status]in (  71 -- Show,
                      ,75 --Completed
                      ,72 -- No show
                      ,73 -- cancel
                      )								-- Completed Status
  and DATEDIFF(DAY,DateOfService, @EndDate) >= 0
  and DATEDIFF(DAY,DateofService, @StartDate) <= 0






-- SmartCare Group Services
UPDATE S SET 
	S.num_co_therapists = GrpService.num_co_therapists
FROM #SummaryServiceUnitList AS S
JOIN (  
	SELECT GroupServiceID,count(distinct StaffId)AS num_co_therapists 
	FROM GroupServiceStaff cts   with (nolock)
	WHERE GroupServiceID in (
		SELECT GroupServiceID FROM #SummaryServiceUnitList
		WHERE GroupServiceID IS Not Null
		)
	GROUP BY GroupServiceID 
	) AS GrpService ON GrpService.GroupServiceID=s.GroupServiceID
	where S.isGroupService = ''Y''

-- PsychConsult groups
update s set
	num_co_therapists = grp.numClinicians
from #SummaryServiceUnitList as s
join (
	select s.ServiceId, COUNT(distinct ss.StaffId) as numClinicians
	from dbo.Services as S
	join dbo.ProcedureCodes as PC on PC.ProcedureCodeId = S.ProcedureCodeId
	join dbo.CustomLegacyServiceStaff as ss on ss.ServiceId = s.ServiceId
	where S.UnitType=110 
	and (
		PC.DisplayAs = ''GROUP_CN''
		or PC.DisplayAs =''CSP_GROUP''
		or PC.DisplayAs  = ''SA_IOP''
		or PC.DisplayAs  = ''SA_GROUPCN''
		or PC.DisplayAs = ''CBA_GROUP''
	)
	group by s.ServiceId
) as grp on grp.ServiceId = s.ServiceId
where s.isGroupService = ''Y''
and s.num_co_therapists is null

update #SummaryServiceUnitList set num_co_therapists = 1 where ((num_co_therapists is null) or (num_co_therapists = 0))

update #SummaryServiceUnitList set Duration_units = Duration_units / CAST(num_co_therapists as float)





  IF OBJECT_ID(''tempdb..#SummaryServiceUnitsResult'') is not null
		drop table #SummaryServiceUnitewsResult




   Select
             S.SupervisorName
			,CASE WHEN @ServiceAreaID=0 THEN NULL ELSE ServiceAreaName END as ServiceAreaName
			,CASE WHEN @ProgramID=0	 THEN NULL ELSE ProgramName     END as ProgramName
			,CASE WHEN @locationID=0	 THEN NULL ELSE LocationCode    END as LocationCode
			,Billable
			,s.staffID
			,S.StaffName
			,ISNULL(gc.CodeName, ''Other'') as ProcedureCodeCatgory
			,SUM(Case when ServiceStatusID=2 then s.Duration_units Else 0 end)			AS UnitsPending
			,SUM(Case when ServiceStatusID=1 then s.Duration_units Else 0 end)			AS UnitsCompleted
			,Sum(Case when ServiceStatusID=0 then s.Duration_units Else 0 end)			AS UnitsNotCompleted
			,SUM(Case when ServiceStatusID=2 then  1  Else 0 end) 	AS VisitPending
			,SUM(Case when ServiceStatusID=1 then  1  Else 0 end) 	AS VisitCompleted
			,SUM(Case when ServiceStatusID=0 then  1  Else 0 end)		AS VisitNotCompleted
			,COUNT(distinct ClientId) as Clients
			,ISNULL(sc.DistinctStaffClients, 0) as DistinctStaffClients
			,ISNULL(ac.DistinctClients, 0) as DistinctClients
		Into #SummaryServiceUnitsResult
				
	    --From (   SELECT  	S.SupervisorName
					--			,CASE WHEN @ServiceAreaID=0 THEN NULL ELSE ServiceAreaName END ServiceAreaName
					--			,CASE WHEN @ProgramID=0		THEN NULL ELSE ProgramName     END AS ProgramName
					--			,CASE WHEN @locationID=0	 THEN NULL ELSE LocationCode     END AS LocationCode
					--			,s.staffID
					--			,S.StaffName
					--			,CodeName  AS ProcedureCodeCatgory
					--			,Billable
					--			,Case when ServiceStatusID=1 then Sum(s.Duration_units) Else 0 End AS UnitsCompleted
					--			,Case when ServiceStatusID=0 then Sum(s.Duration_units) Else 0 End AS UnitsNotCompleted
					--			,Case when ServiceStatusID=1 then  Count(Distinct s.ClientID)  Else 0 End AS VisitCompleted
					--			,Case when ServiceStatusID=0 then  Count(Distinct s.ClientID)  Else 0 End AS VisitNotCompleted
										FROM  #SummaryServiceUnitList S					LEFT join (						select StaffId, COUNT(distinct clientid) as DistinctStaffClients						from #SummaryServiceUnitList						group by staffid					) as sc on sc.StaffId = S.StaffId					cross join (						select COUNT(distinct ClientId) as DistinctClients from #SummaryServiceUnitList					) as ac					LEFT join CustomUnitsOfServiceProcedureCategories  AS P on p.ProcedureCodeId = s.ProcedureCodeId					LEFT join GlobalCodes as gc on P.ProcedureCategory = gc.GlobalCodeID									   Group by
		S.SupervisorName
		,CASE WHEN @ServiceAreaID=0 THEN NULL ELSE ServiceAreaName END
		,CASE WHEN @ProgramID=0	 THEN NULL ELSE ProgramName     END
		,CASE WHEN @locationID=0	 THEN NULL ELSE LocationCode    END
		,Billable
		,s.staffID
		,S.StaffName
		,ISNULL(gc.CodeName, ''Other'')
		,ISNULL(sc.DistinctStaffClients, 0)
		,ISNULL(ac.DistinctClients, 0)
			
		
			
  IF OBJECT_ID(''tempdb..#SummaryServiceUnitList'') is not null
     drop table #SummaryServiceUnitList


       Select s.*
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
       WHERE Billable = CASE @Billable
			WHEN 0 THEN Billable
			WHEN 1 THEN ''Y''
			WHEN 2 THEN ''N'' END

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
