/****** Object:  StoredProcedure [ssp_PMLocations]    Script Date: 03/07/2012 19:41:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_PMLocations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_PMLocations]
GO

/****** Object:  StoredProcedure [ssp_PMLocations]    Script Date: 03/07/2012 19:41:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create PROCEDURE [ssp_PMLocations]         

/****************************************************************************** 
** File: ssp_PMLocations.sql
** Name: ssp_PMLocations
** Desc:  
** 
** 
** This template can be customized: 
** 
** Return values: Filter Values - Locations List Page
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** N/A   Dropdown values
** Auth: Kiran
** Date: 16/06/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 05/08/2011		Mary Suma			Query to return values for the grid in Locations List Page
-------- 			-------- 			--------------- 
** 29/08/2011		Mary Suma			Included additional column LocationCode in Locations grid
** 10/09/2011		Mary Suma			Updated ErrorMessage
-- 12.03.2012		Ponnin Selvan		Removed default @PageNumber 
-- 4.04.2012		Ponnin Selvan		Conditions added for Export
-- 4.12.2012		MSuma				Removed #CustomFilters
-- 13.04.2012       PSelvan             Added Conditions for NumberOfPages.
--24.04.2012        Atul Pandey         Added Partial Search functionality by Location Name
-- 11.17.2015		MD Hussain			Modified to fetch Address data from 'AddressDisplay' column instead of 'Address' w.r.t #249 Engineering Improvement Initiatives- NBL(I) 
-- 28-Feb-2017      Sachin              Added c.LocationCode TO filter LocationCode wise Task #2348 Core Bugs. 
--08.21.2018        Neha                Added a new column called 'Lab Location' to the filter. Engineering Improvement Initiatives- NBL(I)-#667 

*******************************************************************************/
                                             
@SessionId				VARCHAR(30),
@InstanceId				INT,
@PageNumber				INT,
@PageSize				INT,
@SortExpression			VARCHAR(100),
@LocationActive			INT,
@LocationType			INT,
@OtherFilter			INT,
@StaffId				INT,
@locationName           VARCHAR(100),--Added by Atul Pandey
@lablocation            CHAR(1)
AS     
BEGIN                                                              
	BEGIN TRY
		
            CREATE TABLE #CustomFilters
                (
                  LocationId INT NOT NULL 
                )                                              
	                                                                                                  
		DECLARE @ApplyFilterClicked		CHAR(1)
		DECLARE @CustomFiltersApplied	CHAR(1)
		
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))
		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression= 'LocationName'
		
	
		
		-- 
		-- New retrieve - the request came by clicking on the Apply Filter button                   
		--
		SET @ApplyFilterClicked = 'Y' 
		SET @CustomFiltersApplied = 'N'                                                 
		--SET @PageNumber = 1
		
		IF @OtherFilter > 10000                                    
		BEGIN
			SET @CustomFiltersApplied = 'Y'
			
			INSERT INTO #CustomFilters (LocationId) 
			EXEC scsp_PMLocations 
				@LocationActive			= @LocationActive,
				@LocationType			= @LocationType,
				@OtherFilter			= @OtherFilter,
				@StaffId				= @StaffId
		END 
		
		 --ALTER TABLE #CustomFilters ADD  CONSTRAINT [CustomerFilters_PK] PRIMARY KEY CLUSTERED 
   --         (
   --         [LocationId] ASC
   --         ) 
            
	;WITH ListPMLocations
	AS
	(                      
		SELECT  c.LocationId, c.LocationName, c.LocationCode,
			REPLACE(ISNULL(c.AddressDisplay,''),CHAR(13)+CHAR(10),' ') AS LocationAddress,
			c.PhoneNumber AS LocationPhone,
			CASE ISNULL(c.LabLocation,'N') WHEN 'Y' THEN 'Yes' ELSE 'No'   
            END AS LabLocation
		FROM Locations AS c
		WHERE 
		( 
		 ((ISNULL(c.LabLocation,'N')=@lablocation) OR @lablocation='') 
			AND ISNULL(c.RecordDeleted,'N')<>'Y'
			AND ((@CustomFiltersApplied = 'Y' AND EXISTS(SELECT * FROM #CustomFilters cf WHERE cf.LocationId = c.LocationId)) OR
			    (@CustomFiltersApplied = 'N'
				 -- AND filters checks
				 AND (ISNULL(@LocationType,-1) = -1 OR LocationType=@LocationType)
				 AND (	@LocationActive = -1 OR										-- All States  
						(@LocationActive = 1 AND ISNULL(c.Active,'N') = 'Y') OR     -- Active               
						(@LocationActive = 2 AND ISNULL(c.Active,'N') = 'N'))		-- InActive
						 --AND   (--Added by atul pandey on 2/24/2012
					  --       @locationName='' OR c.LocationName like '%'+@locationName+'%'
					  --      )
					  AND   (    
								 @locationName='' OR c.LocationName like '%'+@locationName+'%'  OR c.LocationCode like '%'+@locationName+'%'  
							 )  
			    )
			)
		)
		),
		
		     counts as ( 
    select count(*) as totalrows from ListPMLocations
    ),

RankResultSet
as
		(
SELECT
				LocationId,
			LocationName,
			LocationCode,
			LocationAddress,
			LocationPhone  ,
			LabLocation  ,        
		 COUNT(*) OVER ( ) AS TotalCount ,
                                    RANK() OVER ( ORDER BY 
                CASE WHEN @SortExpression= 'LocationName'			THEN LocationName END,                                  
				CASE WHEN @SortExpression= 'LocationName DESC'		THEN LocationName END DESC,
				CASE WHEN @SortExpression= 'LocationCode'			THEN LocationCode END,                                  
				CASE WHEN @SortExpression= 'LocationCode DESC'		THEN LocationCode END DESC,
				CASE WHEN @SortExpression= 'LocationAddress'		THEN LocationAddress END,                                            
				CASE WHEN @SortExpression= 'LocationAddress DESC'	THEN LocationAddress END DESC,
				CASE WHEN @SortExpression= 'LocationPhone'			THEN LocationPhone END,                                  
				CASE WHEN @SortExpression= 'LocationPhone DESC'		THEN LocationPhone END DESC,
				CASE WHEN @SortExpression= 'LabLocation'            THEN LabLocation END, 
				CASE WHEN @SortExpression= 'LabLocation DESC'       THEN LabLocation END DESC ,  
				LocationId
				) AS RowNumber
                           FROM     ListPMLocations
                           )
	                                        
		 SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
							LocationId,
			LocationName,
			LocationCode,
			LocationAddress,
			LocationPhone  ,
			LabLocation,
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

            SELECT
            LocationId,
			LocationName,
			LocationCode,
			LocationAddress,
			LocationPhone  ,
			LabLocation		
            FROM    #FinalResultSet
            ORDER BY RowNumber
	DROP TABLE #CustomFilters	
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMLocations')                                                                                             
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


