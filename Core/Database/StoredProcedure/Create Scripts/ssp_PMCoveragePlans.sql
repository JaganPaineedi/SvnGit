/****** Object:  StoredProcedure [ssp_PMCoveragePlans]    Script Date: 03/07/2012 19:39:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_PMCoveragePlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_PMCoveragePlans]
GO

/****** Object:  StoredProcedure [ssp_PMCoveragePlans]    Script Date: 03/07/2012 19:39:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create PROCEDURE [ssp_PMCoveragePlans]  

/******************************************************************************   
** File: ssp_PMCoveragePlans.sql  
** Name: ssp_PMCoveragePlans  
** Desc:    
**   
**   
** This template can be customized:   
**   
** Return values: Filter Values - CoveragePlan List Page  
**   
** Called by:   
**   
** Parameters:   
** Input Output   
** ---------- -----------   
** N/A   Dropdown values  
** Auth: Malathi  
** Date: 03/30/2011  
*******************************************************************************   
** Change History   
*******************************************************************************   
** Date:		Author:		Description:   
** 03/30/2011	Malathi		Query to return values for the grid in CoveragePlan List Page  
--------		--------    ---------------   
** 29/08/2011	Mary Suma		Modified  Header , Included Service area Changes
** 01/09/2011	Pradeep			Modified Added Display as in resultset
** 12/09/2011	MSuma			Fix Included Display as in Sort
** 15/11/2011	MSuma			Removed ServiceArea chanegs on the ListPage
** 16/01/2012	MSuma			Replaced Address with AddressDisplay
-- 07.03.2012	Ponnin Selvan	Redesigned for Performance Tunning. 
-- 12.03.2012	Ponnin Selvan	Removed default @PageNumber 
-- 4.04.2012	Ponnin Selvan	Conditions added for Export 
-- 12.04.2012	MSuma			Deleted Temp table  
-- 13.04.2012   PSelvan         Added Conditions for NumberOfPages.
-- 20.04.2012   Shruthi.S       Uncommented check for service area filter
-- 24.04.2012   MSuma			Included GroupBy to avoid duplicate service areas
-- 18-May-2012	Rachna Singh	Add parameter @CoveragePlanName for partial Search
-- 10-June-2014 Kirtee			The Service Area joins and conditions are modified wrf Philhaven - Customization Issues Tracking Task# 1130	
-- 11-June-2014 Gautam          Added code Max(RaceId) reason: CurrentClients count showing wrong due to multiple race related to client, 
								Task#1502, core bugs 
-- 28-Feb-2017 Sachin           Added CP.DisplayAs TO filter Dispaly wise Task #2348 Core Bugs.
*******************************************************************************/  

                                                    
	@SessionId							VARCHAR(30),
	@InstanceId							INT,
	@PageNumber							INT,
	@PageSize							INT,
	@SortExpression						VARCHAR(100),
	@PlanStatus							INT,
	@Capitation							INT,
	@Payer								INT,
	@Information						INT,
	@OtherFilter						INT,
	@StaffId							INT,
	@ServiceAreaId						INT,
	@CoveragePlanName					VARCHAR(250)--Added by Rachna Singh
AS     
BEGIN                                                              
	BEGIN TRY
		 CREATE TABLE #CustomFilters
                (
                  CoveragePlanId INT NOT NULL 
                )                                                
	                                                                                                    
		DECLARE @ApplyFilterClicked		CHAR(1)
		DECLARE @CustomFiltersApplied	CHAR(1)
		
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))
		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression= 'CoveragePlanName'
		

		
		-- 
		-- New retrieve - the request came by clicking on the Apply Filter button                   
		--
		SET @ApplyFilterClicked = 'Y' 
		SET @CustomFiltersApplied = 'N'                                                 
		--SET @PageNumber = 1
		
		IF @OtherFilter > 10000                                    
		BEGIN
			SET @CustomFiltersApplied = 'Y'
			
			INSERT INTO #CustomFilters (CoveragePlanId) 
			EXEC scsp_PMCoveragePlans 
				@PlanStatus				= @PlanStatus,
				@Capitation				= @Capitation,
				@Payer					= @Payer,
				@Information			= @Information,
				@OtherFilter			= @OtherFilter,
				@StaffId				= @StaffId,
				@ServiceAreaId			=@ServiceAreaId,
				@CoveragePlanName		=@CoveragePlanName--Added by Rachna Singh
		END		 
		
		
		 --ALTER TABLE #CustomFilters ADD  CONSTRAINT [CustomerFilters_PK] PRIMARY KEY CLUSTERED 
   --         (
   --         [CoveragePlanId] ASC
   --         )  
            
        ;WITH PMCoveragePlans
		as
		(
		SELECT         
			CP.CoveragePlanId,  
			CP.CoveragePlanName,
			--REPLACE(CP.[Address],CHAR(13)+CHAR(10),' ') AS [Address],
			CP.AddressDisplay AS [Address],
			NULL AS Business,  
			NULL AS CurrentAR,              
			ISNULL(cc.CurrentClients, 0) AS CurrentClients  ,
			--SA.ServiceAreaName,
			CP.DisplayAs as DisplayAs
		FROM CoveragePlans CP              
			INNER JOIN Payers P ON CP.PayerId=P.PayerId   
			--Included as a part of ServiceArea Changes 
			LEFT JOIN 
				(SELECT ccp.CoveragePlanId, COUNT(*) AS CurrentClients
				  FROM ClientCoveragePlans ccp  
				  JOIN ClientCoverageHistory cch ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
					JOIN Clients c ON c.clientid = ccp.clientid 
					--Included Join on CLientRace to match with EligibleClients count
					-- 11-June-2014 Gautam 
					LEFT JOIN  ( Select ClientId, max(RaceId) as RaceId From ClientRaces CR   Where ISNULL(CR.RecordDeleted,'N') = 'N'  
									Group by ClientId) CR ON  C.ClientID = CR.ClientID      
					LEFT JOIN  GlobalCodes GC   ON  CR.RaceId = GC.GlobalcodeID    
					
					WHERE c.Active = 'Y'
						AND cch.StartDate <= GETDATE()
						AND (DATEADD(dd, 1, cch.EndDate) > GETDATE() OR cch.EndDate IS NULL)  
						AND ISNULL(cch.RecordDeleted, 'N') = 'N'
						AND ISNULL(ccp.RecordDeleted, 'N')= 'N'
						AND ISNULL(c.RecordDeleted,'N') = 'N'
					
					GROUP BY ccp.CoveragePlanId
				) AS cc ON cc.CoveragePlanId = cp.CoveragePlanId
				
				
		WHERE 
		
			ISNULL(CP.RecordDeleted, 'N' )= 'N' 
	               
			AND ((@CustomFiltersApplied = 'Y' AND EXISTS(SELECT * FROM #CustomFilters cf WHERE cf.CoveragePlanId = CP.CoveragePlanId)) OR
				(@CustomFiltersApplied = 'N'
				AND (@PlanStatus = -1 OR										--   All
					 (@PlanStatus = 1 AND ISNULL(CP.Active,'N') = 'Y') OR		--   Active
					 (@PlanStatus = 2  AND ISNULL(CP.Active,'N') = 'N'))			--   InActive									--   All status 
				     		   
	       
				AND (@Capitation = -1 OR											--   Show Capitated and Non-Capitated Plans 
				   (@Capitation = 1 AND ISNULL(CP.Capitated,'N') = 'Y') OR		--   Show Capitated Plans Only             
				   (@Capitation = 2 AND ISNULL(CP.Capitated,'N') = 'N'))		--   Show Non-Capitated Plans Only
	   
				AND (@Payer = -1 OR
				   (CP.PayerId = @Payer))   
	       
				AND(@Information = -1 OR													--   Complete and Incomplete Information 
				   (@Information = 1 AND ISNULL(CP.InformationComplete,'N') = 'Y') OR		--   Complete Information             
				   (@Information = 2 AND ISNULL(CP.InformationComplete,'N') = 'N'))		--   Incomplete Information
				     AND (@CoveragePlanName='' OR (CP.CoveragePlanName LIKE '%' + @CoveragePlanName + '%')OR (CP.DisplayAs LIKE '%' + @CoveragePlanName + '%'))
				)
			)	
			-- 10-June-2014,Kirtee The Service Area joins and conditions are modified, as the records are not displaying on list page if delete the associate ServiceArea.
			AND (@ServiceAreaId = -1 OR exists( Select * from CoveragePlanServiceAreas CPSA  Join  
			 ServiceAreas SA ON SA.ServiceAreaId = CPSA.ServiceAreaId where CP.CoveragePlanId = CPSA.CoveragePlanId 
			 AND ISNULL(SA.RecordDeleted,'N')= 'N' 
			AND ISNULL(CPSA.RecordDeleted,'N')= 'N' AND
				   CPSA.ServiceAreaId = @ServiceAreaId))   
			GROUP BY 
			CP.CoveragePlanId,  
			CP.CoveragePlanName,
			CP.AddressDisplay ,
			CurrentClients  ,
			CP.DisplayAs
		),
		
		   counts as ( 
    select count(*) as totalrows from PMCoveragePlans
    ),
    
		RankResultSet
		as

(                                             
			SELECT
				CoveragePlanId, 
				CoveragePlanName,
				[Address],
				Business,
				CurrentAR,
				CurrentClients ,
				--ServiceAreas,
				DisplayAs  ,                           
			 COUNT(*) OVER ( ) AS TotalCount ,
                                    RANK() OVER ( ORDER BY CASE
				 WHEN @SortExpression= 'CoveragePlanName'			    THEN ISNULL(CoveragePlanName,'') END,                                
				CASE WHEN @SortExpression= 'CoveragePlanName DESC'		THEN ISNULL(CoveragePlanName,'') END DESC,                        
				CASE WHEN @SortExpression= 'Address'					THEN ISNULL([Address],'') END,                                                
				CASE WHEN @SortExpression= 'Address DESC'				THEN ISNULL([Address],'') END DESC,
				CASE WHEN @SortExpression= 'Business'					THEN ISNULL(Business,'') END,                                  
				CASE WHEN @SortExpression= 'Business DESC'				THEN ISNULL(Business,'') END DESC, 
				CASE WHEN @SortExpression= 'CurrentAR'					THEN ISNULL(CurrentAR,'') END,                                   
				CASE WHEN @SortExpression= 'CurrentAR DESC'				THEN ISNULL(CurrentAR,'') END DESC, 
				CASE WHEN @SortExpression= 'CurrentClients'				THEN ISNULL(CurrentClients,'') END,                                   
				CASE WHEN @SortExpression= 'CurrentClients DESC'		THEN ISNULL(CurrentClients,'') END DESC,
				CASE WHEN @SortExpression= 'DisplayAs'					THEN ISNULL(DisplayAs,'') END,                                  
				CASE WHEN @SortExpression= 'DisplayAs DESC'				THEN ISNULL(DisplayAs,'') END DESC,  
				
				CoveragePlanId
				) AS RowNumber
                           FROM     PMCoveragePlans                   
                         )
                         
                         
                           SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
                      CoveragePlanId, 
				CoveragePlanName,
				[Address],
				Business,
				CurrentAR,
				CurrentClients ,
				DisplayAs,
                        TotalCount ,
                        RowNumber
                INTO    #FinalResultSet
                FROM    RankResultSet
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 
                           
	      IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1
             BEGIN
                    SELECT 0 AS PageNumber ,
                    0 AS NumberOfPages ,
                    0 NumberOfRows
                  END
             ELSE
		BEGIN
	                SELECT TOP 1
                    @PageNumber AS PageNumber ,
                    CASE (TotalCount % @PageSize) WHEN 0 THEN 
                    ISNULL(( TotalCount / @PageSize ), 0)
                    ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,
                    ISNULL(TotalCount, 0) AS NumberOfRows
            FROM    #FinalResultSet     
            END                    

            SELECT  CoveragePlanId, 
				CoveragePlanName,
				[Address],
				Business,
				CurrentAR,
				CurrentClients ,
				DisplayAs			
            FROM    #FinalResultSet
            ORDER BY RowNumber
            
        DROP TABLE #CustomFilters                                      
	
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMCoveragePlans')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END



GO


