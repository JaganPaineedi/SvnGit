/****** Object:  StoredProcedure [dbo].[csp_Productivity_Summary12]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Productivity_Summary12]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Productivity_Summary12]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Productivity_Summary12]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************/
/* Stored Procedure: csp_productivity_summary12                            */
/* Creation Date:    5/30/2012                                      */
/* Copyright:                                                         */
/*                                                                   */
/* Purpose: Units of Service Report                                  */
/*                                                                   */
/* Input Parameters: @EndDate,@Repotvalue,@ReportType				 */
/*	               													 */
/*																	 */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:  0=success                                         */
/*                                                                   */
/* Called By:  Crystal productivity_summary							 */
/*                                                                   */
/* Calls: 															 */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*Code for Value UnitType :											 */
			--110 Minute --113 Items  --111 Hours                    */
			--110 Minutes --112 Days								 */
/*																	 */
/*********************************************************************/


Create proc [dbo].[csp_Productivity_Summary12]  	
                             @EndDate     AS DateTime 
							,@ReportType  AS INT  --Supervior or staff report	
							,@ReportValue AS INT		  
			
      
      AS
      
      
		
			
			
			
DECLARE @startDate 	datetime
-- Go back to 12 months

SELECT @startDate = DATEADD(MONTH,-12,@ENDDATE)
	
-- Check if the temp stafflist exist
-- if yes drop the table			
IF OBJECT_ID(''tempdb..#StaffList'') is not null
     BEGIN DROP TABLE #StaffList 
      
       End 

     
	 CREATE TABLE #StaffList (
 			  
			     StaffID				INT NOT NULL,
			     StaffLastName			VARCHAR(30) NOT NULL,
			     StaffFirstName			VARCHAR(20) NOT NULL,
			     SupervisorID			INT NULL,
        		 SupervisorLastName		VARCHAR(30) NULL,
			     SupervisorFirstName	VARCHAR(20) NULL)
	 


	 
if @ReportType=1 	 -- Select the Supervisor and His staffs for the selected Supervisor
	 BEGIN 
		       		
      		INSERT	#StaffList
	 
			 SELECT   Distinct
					  S.StaffID			AS StaffID
					 ,S.LastName		AS StaffLastName
					 ,S.FirstName		AS StaffFirstName
					 ,SS.SupervisorID	AS SupervisorID
					 ,S2.LastName		AS SupervisorLastName 
					 ,S2.FirstName		AS SupervisorFirstName 
				
			 From Staff AS S
			 Inner Join StaffSupervisors AS SS ON SS.StaffID =S.StaffID
			 Inner Join Staff            AS S2 ON SS.SuperVisorID=S2.StaffID
			 where SS.SuperVisorID=@ReportValue
        End
ELSE IF @ReportType=2
	BEGIN  
	      -- Select the Staff and His Superviors for the selected staff
			INSERT	#StaffList
      			
			 SELECT Distinct  
					  S.StaffID			AS StaffID
			         ,S.LastName		AS StaffLastName
					 ,S.FirstName		AS StaffFirstName
					 ,SS.SupervisorID	AS SupervisorID
					 ,S2.LastName		AS SupervisorLastName 
					 ,S2.FirstName		AS SupervisorFirstName 
			
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
										   
										--   Select * from #StaffList
 
     END 
    
     
    

     
        
IF OBJECT_ID(''tempdb..#ServicesList'') is not null
drop table #ServicesList
      
      
      Select --Top 10000 
			  S.ServiceID 
             ,S.ProcedureCodeID
             ,ClinicianID
             ,Billable
             ,PC.DisplayAs AS ProcedureCode
             
           
             ,Unit        AS Unit
             ,UnitType    AS UnitType
          
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
			 END								AS duration_units
			,S.GroupServiceID					AS GroupServiceID
			,1									AS  num_co_therapists
			,DATEPART(MONTH,S.DateofService)	AS MM
			,DATEPART(YEAR, S.DateofService)	AS YY
	Into #ServicesList 
    FROM Services				AS S
       JOIN ProcedureCodes		AS PC	ON S.ProcedureCodeID=PC.ProcedureCodeID
       INNER JOIN #Stafflist    AS Stf	ON stf.StaffID =ClinicianID
   WHERE ISNULL(S.RecordDeleted,''N'')<>''Y''
   AND S.[Status]=75								-- Completed Status
   And (DateOfService <=@EndDate 
		And DateofService >=@StartDate)   
                          
                          
-- Get How many Therapists Count Per Group Service 
UPDATE S 
	SET S.num_co_therapists = GrpService.num_co_therapists
				
FROM #ServicesList AS S
Inner Join (  
			SELECT GroupServiceID,count(StaffId)AS num_co_therapists 
			 FROM GroupServiceStaff cts	 with (nolock)
			 WHERE GroupServiceID in 
									( Select GroupServiceID   from #ServicesList
	     							 Where GroupServiceID IS Not Null
	     							 )
			Group by GroupServiceID 
		  ) AS GrpService
on  GrpService.GroupServiceID=s.GroupServiceID


          
IF OBJECT_ID(''tempdb..#ProductivityfinalResults'') is not null
		drop table #ProductivityfinalResults 

SELECT
     
   
			 S.StaffLastName
			,S.StaffFirstName
			,S.SupervisorLastName 
			,S.SupervisorFirstName 
			,S.StaffID
			,S.SupervisorID		   ,(sum(CASE WHEN s.MM =1	THEN s.duration_units/num_co_therapists   ELSE 0  END	 )) as units_january,
		   (sum(CASE WHEN s.MM =2	THEN s.duration_units/num_co_therapists   ELSE 0  END	 )) as units_february,
		   (sum(CASE WHEN s.MM =3	THEN s.duration_units/num_co_therapists   ELSE 0  END	 )) as units_march,
		   (sum(CASE WHEN s.MM =4	THEN s.duration_units/num_co_therapists   ELSE 0  END	 )) as units_april,
		   (sum(CASE WHEN s.MM =5  	THEN s.duration_units/num_co_therapists   ELSE 0  END	 )) as units_may,
		   (sum(CASE WHEN s.MM =6 	THEN s.duration_units/num_co_therapists   ELSE 0  END	 )) as units_june,
		   (sum(CASE WHEN s.MM =7 	THEN s.duration_units/num_co_therapists   ELSE 0  END	 )) as units_july,
		   (sum(CASE WHEN s.MM =8 	THEN S.duration_units/num_co_therapists   ELSE 0  END	 )) as units_august,		   (sum(CASE WHEN s.MM =9	THEN S.duration_units/num_co_therapists   ELSE 0  END	 )) as units_september,
		   (sum(CASE WHEN s.MM =10	THEN S.duration_units/num_co_therapists   ELSE 0  END	 )) as units_october,
		   (sum(CASE WHEN s.MM =11	THEN s.duration_units/num_co_therapists   ELSE 0  END	 )) as units_november,
		   (sum(CASE WHEN s.MM =12 	THEN s.duration_units/num_co_therapists   ELSE 0  END	 )) as units_december,
		 	sum(s.duration_units/num_co_therapists) as units_ytd,			end_month =DATEPART(MONTH,@EndDate),
			end_year  =DATEPART(YEAR, @EndDate)

INTO #ProductivityfinalResults
FROM  #ServicesList S 
    Group by              
			 S.StaffLastName
			,S.StaffFirstName
			,S.SupervisorLastName 
			,S.SupervisorFirstName 
			,S.StaffID
			,S.SupervisorID--Select * from #ProductivityfinalResults print '' hell''/*---------------------------------------------------------------------------------------*/
/* This section gathers data for the lower half of the report for the session summary.	 */
/*	 										 */
/*---------------------------------------------------------------------------------------*/
SELECT 
	         S.StaffLastName
			,S.StaffFirstName
			,S.SupervisorLastName 
			,S.SupervisorFirstName 
			,S.StaffID
			,S.SupervisorID	        ,units_july/86.8		AS Jul
			,units_august /86.8 	as Aug
	        ,units_september/86.8 	as Sep
	        ,units_october/86.8 	as Oct             ,units_november/86.8 	as Nov
	        ,units_december/86.8 	as [Dec]       	    ,units_january/86.8 	as Jan 
	        ,units_february/86.8 	as Feb
			,units_march/86.8 		as Mar	
			,units_april/86.8 		as Apr 
			,units_may/86.8 		as May 
			,units_june/86.8        as Jun			,units_ytd/1040 	    as Ytd
		    ,units_ytd                  
	        ,end_month 
            ,end_year 
			,start_year = datepart(year,@StartDate)
			,@StartDate                AS FromDate
			,@EndDate                  AS ToDate
	        ,f.OrganizationName
              --convert(char(10), @start_proc_chron,101)  as start_proc_chron,
              --  convert(char(10), dateadd(day,-1,@end_proc_chron),101)  as end_proc_chron,
	--@db_name as dbname
FROM #ProductivityfinalResults  AS Scross join SystemConfigurations fORDER BY S.StaffLastName
			,S.StaffFirstName
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
IF OBJECT_ID(''tempdb..#ServicesList'') is not null
drop table #ServicesList			
			
          
IF OBJECT_ID(''tempdb..#ProductivityfinalResults'') is not null
		drop table #ProductivityfinalResults 
		
IF OBJECT_ID(''tempdb..#StaffList'') is not null
     BEGIN DROP TABLE #StaffList 
      
       End ' 
END
GO
