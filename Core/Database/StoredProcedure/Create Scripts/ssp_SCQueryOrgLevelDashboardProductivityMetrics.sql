IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCQueryOrgLevelDashboardProductivityMetrics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCQueryOrgLevelDashboardProductivityMetrics]
GO   
    
    
CREATE PROCEDURE [dbo].[ssp_SCQueryOrgLevelDashboardProductivityMetrics] --'2018-02-02 10:45:36.430',1  
    @ProductivityDate AS DATE = NULL ,    
    @OrganizationLevelId AS INT    
AS -- =============================================    
-- Author:  Suhail Ali    
-- Create date: 4/3/2012    
-- Description: Query current day org level productivity metrics to be displayed     
-- Sample Usage:     
--DECLARE @ProductivityDate AS DATE = GETDATE()    
--DECLARE @OrganizationLevelId AS INT    
--SELECT @OrganizationLevelId = OrganizationLevelId FROM dbo.OrganizationLevels WHERE LevelName = 'Thresholds' AND LevelTypeId = 1    
--EXEC [dbo].[ssp_SCQueryOrgLevelDashboardProductivityMetrics] @ProductivityDate,@OrganizationLevelId    
--SELECT @OrganizationLevelId = OrganizationLevelId FROM dbo.OrganizationLevels WHERE LevelName = 'SupervisorB' AND LevelTypeId = 2    
--EXEC [dbo].[ssp_SCQueryOrgLevelDashboardProductivityMetrics] @ProductivityDate,@OrganizationLevelId    
--Modify ParentLevelName display as (Lastname + ', ' + st.FirstName)by Jagdeep     
--Added order by ParentLevelName asc to get Staff names  in alpha order by last name by Jagdeep     
--Modified By:Vikas Kashyap, w.r.t. Task#2063(TH Bugs/Features) Added New Case condition for handling Actual Hours(0 or null) dipaly N/A     
--Modified by Maninder: Added else keyword to avoid duplicate dataset return  
-- 05 Jan 2018   Kavya  : Added BEGIN , END keywords for IF Condition,   let the else condition calculate the staffproductivity from DailyStaffProductivity. #Spring River SGL#163   
--=============================================    
    BEGIN
    BEGIN TRY     
  DECLARE @SPNAME varchar(200)    
  SELECT @SPNAME=Value FROM SystemConfigurationKeys WHERE "Key"='SuperVisorServiceTotalsWidgetSP'        
        
        IF @ProductivityDate IS NULL     
            SELECT  @ProductivityDate = CAST(GETDATE() AS DATE)    
  /* Calculate productivity period date if none exists for the previous day */    
        IF NOT EXISTS ( SELECT  *    
                        FROM    DailyStaffProductivity    
                        WHERE   ProductivityDate = DATEADD(DAY, -1,    
                                                           @ProductivityDate) )     
            AND EXISTS ( SELECT *    
                         FROM   dbo.ProgramProductivityPeriodDates    
                         WHERE  StartDate <= @ProductivityDate    
                                AND EndDate >= @ProductivityDate)     
				BEGIN                       
				--EXEC csp_SCCalculateOpenPeriodProductivityMetrics     
				IF(@SPNAME IS NOT NULL AND LTRIM(RTRIM(@SPNAME))!='')    
					BEGIN 
					EXEC @SPNAME     
					END 
				 END  
				  
		 ELSE  
			 BEGIN    
		  /* Take all the childern of the org level and find out all ProgramIds so we can aggergate metrics from DailyStaffProductivity table */    
		  ;    
				WITH    ChildPrograms    
						  AS ( SELECT   *    
							   FROM     Organizationlevels    
							   WHERE    OrganizationLevelId = @OrganizationLevelId    
										AND ISNULL(RecordDeleted, 'N') = 'N'    
							   UNION ALL    
							   SELECT   t.*    
							   FROM     Organizationlevels t    
										INNER JOIN ChildPrograms icp    
											ON t.ParentLevelId = icp.OrganizationLevelId    
							 )    
					SELECT  AVG(dp.AverageLagPeriodToDate) AvgLagOrg ,    
			 /*Added New Case condition for handling Actual Hours(0 or null) dipaly N/A*/    
							CASE WHEN SUM(ActualHoursPeriodToDate) IS NULL      
									  OR SUM(ActualHoursPeriodToDate) = 0 THEN NULL    
							WHEN SUM(TargetHoursPeriodToDate) IS NULL    
									  OR SUM(TargetHoursPeriodToDate) = 0 THEN 1    
								 ELSE SUM(ActualHoursPeriodToDate)    
									  / SUM(TargetHoursPeriodToDate)    
							END AS AvgHourToTargetRatioPeriodToDateOrg    
					FROM    ChildPrograms AS cp    
							INNER JOIN DailyStaffProductivity AS dp   
								ON cp.ProgramId = dp.ProgramId    
					WHERE   dp.ProductivityDate = DATEADD(DAY, -1, @ProductivityDate) ;    
		            
		  -- If the org level type is at the program level (lowest level) then show staff */    
				IF NOT EXISTS ( SELECT  *    
								FROM    Organizationlevels orglevel    
										INNER JOIN dbo.OrganizationLevelTypes orgtype    
											ON orglevel.LevelTypeId = orgtype.LevelTypeId    
								WHERE   OrganizationLevelId = @OrganizationLevelId    
										AND ProgramLevel = 'Y' )     
					WITH    ChildPrograms    
							  AS ( SELECT   child.LevelName AS ParentLevelName ,    
											child.OrganizationLevelId AS ParentOrganizationLevelId ,    
											child.OrganizationLevelId ,    
											child.LevelName ,    
											child.LevelTypeId ,    
											child.ProgramId ,    
											child.ParentLevelId    
								   FROM     Organizationlevels parent    
											INNER JOIN Organizationlevels child    
												ON parent.OrganizationLevelId = child.ParentLevelId    
												   AND ISNULL(parent.RecordDeleted,    
															  'N') = 'N'    
												   AND ISNULL(child.RecordDeleted, 'N') = 'N'    
								   WHERE    parent.OrganizationLevelId = @OrganizationLevelId    
								   UNION ALL    
								   SELECT   icp.ParentLevelName ,    
											icp.ParentOrganizationLevelId ,    
											t.OrganizationLevelId ,    
											t.LevelName ,    
											t.LevelTypeId ,    
											t.ProgramId ,    
											t.ParentLevelId    
								   FROM     Organizationlevels t    
											INNER JOIN ChildPrograms icp    
												ON t.ParentLevelId = icp.OrganizationLevelId    
												   AND ISNULL(t.RecordDeleted, 'N') = 'N'    
								 )    
						SELECT  CAST(CASE WHEN pg.ProgramId IS NOT NULL    
											   AND ParentOrganizationLevelId = OrganizationLevelId    
										  THEN pg.ProgramCode    
										  ELSE ParentLevelName    
									 END AS VARCHAR(250)) AS ParentLevelName ,    
								ParentOrganizationLevelId AS OrganizationLevelId ,    
								AVG(dp.AverageLagPeriodToDate) AvgLagOrg ,    
								CASE WHEN SUM(TargetHoursPeriodToDate) IS NULL    
										  OR SUM(TargetHoursPeriodToDate) = 0    
									 THEN NULL    
									 ELSE SUM(ActualHoursPeriodToDate)    
										  / SUM(TargetHoursPeriodToDate)    
								END AS AvgHourToTargetRatioPeriodToDateOrg    
						FROM    ChildPrograms cp    
								LEFT OUTER JOIN DailyStaffProductivity AS dp    
									ON cp.ProgramId = dp.ProgramId    
									   AND dp.ProductivityDate = DATEADD(DAY, -1,    
																	  @ProductivityDate)    
								LEFT OUTER JOIN Programs AS pg    
									ON cp.ProgramId = pg.ProgramId    
						GROUP BY CASE WHEN pg.ProgramId IS NOT NULL    
										   AND ParentOrganizationLevelId = OrganizationLevelId                                  THEN pg.ProgramCode    
									  ELSE ParentLevelName    
								 END ,    
								ParentOrganizationLevelId ;    
				ELSE -- show staff level if at program level    
					SELECT  CAST(st.Lastname + ', ' + st.FirstName AS VARCHAR(250)) AS ParentLevelName ,    
					--SELECT  CAST(st.FirstName + ' ' + st.Lastname AS VARCHAR(250)) AS ParentLevelName ,    
							CAST(NULL AS INT) AS OrganizationLevelId ,    
							AverageLagPeriodToDate AS AvgLagOrg ,    
							ActualHourToTargetRatioPeriodToDate AS AvgHourToTargetRatioPeriodToDateOrg    
					FROM    DailyStaffProductivity AS dp    
							INNER JOIN Staff st    
								ON dp.StaffId = st.StaffId    
					WHERE   ProgramId IN (    
							SELECT  ProgramId    
							FROM    Organizationlevels orglevel    
									INNER JOIN dbo.OrganizationLevelTypes orgtype    
										ON orglevel.LevelTypeId = orgtype.LevelTypeId    
							WHERE   OrganizationLevelId = @OrganizationLevelId    
									AND ProgramLevel = 'Y' )    
							AND ISNULL(st.RecordDeleted, 'N') = 'N'    
							AND dp.ProductivityDate = DATEADD(DAY, -1,@ProductivityDate)    
							order by ParentLevelName asc;    
					WITH    ChildPrograms    
							  AS ( SELECT   child.LevelName AS ParentLevelName ,    
											child.OrganizationLevelId ,    
											child.LevelName ,    
											child.LevelTypeId ,    
											child.ProgramId ,    
											child.ParentLevelId    
								   FROM     Organizationlevels parent    
											INNER JOIN Organizationlevels child    
												ON parent.OrganizationLevelId = child.ParentLevelId    
												   AND ISNULL(parent.RecordDeleted,    
															  'N') = 'N'    
												   AND ISNULL(child.RecordDeleted, 'N') = 'N'    
								   WHERE    parent.OrganizationLevelId = @OrganizationLevelId    
								   UNION ALL    
								   SELECT   icp.ParentLevelName ,    
											t.OrganizationLevelId ,    
											t.LevelName ,    
											t.LevelTypeId ,    
											t.ProgramId ,    
											t.ParentLevelId    
								   FROM     Organizationlevels t    
											INNER JOIN ChildPrograms icp    
												ON t.ParentLevelId = icp.OrganizationLevelId    
												   AND ISNULL(t.RecordDeleted, 'N') = 'N'    
								 ),    
							PreviousPeriodOrgProductivity    
							  AS ( SELECT   SUM(TargetHoursPeriodToDate) AS PreviousPeriodTargetHoursPeriodToDate ,    
											SUM(ActualHoursPeriodToDate) AS PreviousPeriodActualHoursPeriodToDate ,    
											( CASE WHEN SUM(TargetHoursPeriodToDate) IS NULL    
														OR SUM(TargetHoursPeriodToDate) = 0    
												   THEN 1    
												   ELSE SUM(ActualHoursPeriodToDate)    
														/ SUM(TargetHoursPeriodToDate)    
											  END ) AS PreviousPeriodActualHourToTargetRatioPeriodToDate    
								   FROM     dbo.DailyStaffProductivity dsp    
				 INNER JOIN ChildPrograms cp    
												ON dsp.ProgramId = cp.ProgramId    
											INNER JOIN ( SELECT MAX(ProductivityDate) AS PreviousProgramProductivityEndDate ,    
																idsp.ProgramId    
														 FROM   dbo.DailyStaffProductivity idsp    
												WHERE  DATEADD(DAY, -1,    
																	  @ProductivityDate) > ProductivityDate    
																AND ProductivityPeriodId NOT IN (    
																SELECT    
																	  ProductivityPeriodId    
																FROM  dbo.DailyStaffProductivity iidsp    
																WHERE iidsp.ProgramId = idsp.ProgramId    
																	  AND iidsp.ProductivityDate = DATEADD(DAY,    
																	  -1,    
																	  @ProductivityDate) )    
														 GROUP BY idsp.ProgramId    
													   ) ppped    
												ON ppped.PreviousProgramProductivityEndDate = dsp.ProductivityDate    
												   AND ppped.ProgramId = dsp.ProgramId    
								 )    
					SELECT  pplp.PreviousPeriodTargetHoursPeriodToDate AS PreviousOrgPeriodTargetHoursPeriodToDate , -- Org Level Target (previous period)    
							pplp.PreviousPeriodActualHoursPeriodToDate AS PreviousOrgPeriodActualHoursPeriodToDate , -- Org Level Hours (previous period)    
							pplp.PreviousPeriodActualHourToTargetRatioPeriodToDate AS PreviousOrgPeriodActualHourToTargetRatioPeriodToDate -- Level Hours % (previous period)    
					FROM    PreviousPeriodOrgProductivity pplp    
			   END                  
    END  TRY 
    
                                              
                                                                                                           
 BEGIN CATCH           
                                                                           
		DECLARE @Error varchar(8000)                                                                          
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                    
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCQueryOrgLevelDashboardProductivityMetrics]')                                                
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                            
		+ '*****' + Convert(varchar,ERROR_STATE())                                                                          
	                                                        
		RAISERROR                                                                           
		(                                         
		  @Error, -- Message text.                                                                          
		  16, -- Severity.                                                                          
		  1 -- State.                                                                          
		); 
		 
  END CATCH     
END  
GO 