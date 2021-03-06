/****** Object:  StoredProcedure [ssp_PMCoveragePlanEligibleClient]    Script Date: 03/07/2012 19:38:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_PMCoveragePlanEligibleClient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_PMCoveragePlanEligibleClient]
GO

/****** Object:  StoredProcedure [ssp_PMCoveragePlanEligibleClient]    Script Date: 03/07/2012 19:38:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

create Procedure [ssp_PMCoveragePlanEligibleClient]      
		  /* Param List */  
		  @SessionId				VARCHAR(30),
		  @InstanceId				INT,
		  @PageNumber				INT,
		  @PageSize					INT,
		  @SortExpression			VARCHAR(100),     
		  @CoveragePlanID			INT,
		  @StaffId					INT,
		  @FromDate					DATETIME,
		  @COBorder					INT ,
		  @OtherFilter				INT   
		AS      
/******************************************************************************    
**  File: dbo..ssp_PMCoveragePlanEligibleClient .prc    
**  Name: dbo.ssp_PMCoveragePlanEligibleClient     
**  Desc:     
**    
**  This template can be customized:    
**                  
**  Return values:    
**     
**  Called by:       
**                  
**  Parameters:    
**  Input       Output    
**     ----------       -----------    
**    
**  Auth: Mary Suma
**  Date: 05/12/2011    
*******************************************************************************    
**  Change History    
*******************************************************************************    
**  Date:		Author:		Description:    
**  --------	--------    -------------------------------------------    
**  28/09/2011	MSuma		renamed the temp table with Prefix as 'ListPage'
**	23/11/2011  MSuma	    Inclued Filter criteria for EligibleAsof
**	26/11/2011  MSuma	    Inclued COveragePlanId in the FinalSelect
-- 07.03.2012	Ponnin Selvan   Redesigned for Performance Tunning. 
-- 12.03.2012   Ponnin Selvan   Removed default @PageNumber 
-- 4.04.2012	Ponnin Selvan   Conditions added for Export 
-- 4.12.2012	MSuma			Dropped table #CustomFilters
-- 13.04.2012   PSelvan        Added Conditions for NumberOfPages.
-- 11-June-2014 Gautam      Displayed client multiple Race as comma seperated because multiple records 
							are showing Task#1502, core bugs 
-- 18-July-2014  Gautam      Change the datatype of InsuredId from Int to Varchar(25) in #ResultSet
							 Ref. Core bugs #1578
-- 18-Jan-2016    Himmat      Replaced Age calculating function datediff() with GetAge()scalar function in #ResultSet
*******************************************************************************/    
BEGIN  
BEGIN TRY  
  
            CREATE TABLE #CustomFilters
                (
                  CoveragePlanId INT NOT NULL 
                )
             
              CREATE TABLE #ResultSet
                (
                  	ClientID Int,    
					ClientName varchar(130),     
					PlanID int,    
					CoveragePlanId Int,
					InsuredId varchar(25),    
					COBOrder Int,     
					DOB Datetime,    
					Age Int,     
					Sex varchar(10),    
					Race varchar(max),    
					StartDate datetime,    
					EndDate  Datetime  
                )
                                                                    
		DECLARE @ApplyFilterClicked		CHAR(1)
		DECLARE @CustomFiltersApplied	CHAR(1)
		
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))
		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression= 'ClientName'
		
	
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
			
			EXEC scsp_PMCoveragePlanEligibleClients
				  @CoveragePlanID			=@CoveragePlanID,
				  @StaffId					=@StaffId,
				  @FromDate					=@FromDate,
				  @COBorder					=@COBorder ,
				  @OtherFilter				=@OtherFilter  
		END		 
		
	--
	--  Find only billable procedure codes for the corresponding coverage plan
	--
	
	
	 --ALTER TABLE #CustomFilters ADD  CONSTRAINT [CustomerFilters_PK] PRIMARY KEY CLUSTERED 
  --          (
  --          [CoveragePlanId] ASC
  --          ) ;
            
		Insert into #ResultSet
		SELECT         
			C.ClientID,    
			C.LastName + ', ' + C.FirstName AS ClientName,     
			 1 AS PlanID,    
			 CCP.ClientCoveragePlanId AS CoveragePlanId,
			 CCP.InsuredId,    
			 CCH.COBOrder,     
			 C.DOB, 
			  --Modified Date :-18-01-2016 As Per Core_Bug Issue #270
             CASE WHEN C.DOB IS NOT NULL THEN dbo.GetAge(C.DOB,GETDATE()) ELSE NULL END AS Age,   
			-- CASE WHEN C.DOB IS NOT NULL THEN DATEDIFF(YEAR,C.DOB,GETDATE()) ELSE NULL END AS Age,     
			 C.Sex,    
			 GC.CodeName AS Race,    
			 CAST(CONVERT(VARCHAR, CCH.StartDate, 101) AS DATETIME) AS StartDate,    
			 CAST(CONVERT(VARCHAR, CCH.EndDate, 101) AS DATETIME) AS EndDate    
		FROM             
			ClientCoverageHistory CCH    
		LEFT JOIN     
			ClientCoveragePlans CCP    
		ON     
			CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId     
		LEFT JOIN    
			Clients C    
		ON     
			CCP.ClientId = C.ClientId     
		/*Join with ClientRaces and GlobalCodes for selecting Race field*/    
		LEFT JOIN    
			ClientRaces CR    
		ON     
			C.ClientID = CR.ClientID  AND ISNULL(CR.RecordDeleted, 'N') = 'N' 
		LEFT JOIN    
			GlobalCodes GC    
		ON     
		 CR.RaceId = GC.GlobalcodeID    		    
		WHERE  CCH.ClientCoveragePlanId     
		  IN  
		  (    
		   SELECT    
			ClientCoveragePlanId      
		   FROM      
			ClientCoveragePlans     
		   WHERE     
			CoveragePlanId = @CoveragePlanID    
		  )    
		  AND    
		  C.Active='Y'    
		  AND    
		  ISNULL(CCH.RecordDeleted, 'N') = 'N'      
		  AND    
		  ISNULL(CCP.RecordDeleted, 'N') = 'N'     
		  AND    
		  ISNULL(C.RecordDeleted, 'N') = 'N'
		  AND (@COBorder = -1 OR
			(@COBorder = CCH.COBOrder))
		  and  exists (Select SC.ClientId from StaffClients SC  where SC.StaffId = @StaffId )
		  --Inclued Filter criteria for EligibleAsof
		  AND (@FromDate IS NULL OR
		  (cch.StartDate <= @FromDate
							AND (DATEADD(dd, 1, cch.EndDate) > @FromDate OR cch.EndDate IS NULL) ))
		  --((StartDate <= @FromDate AND EndDate >=@FromDate) OR (StartDate <= @FromDate AND EndDate IS NULL )))
			--and SC.ClientId = c.ClientId      
		--Order by ClientName

	;WITH ClientCoverageData as (
       Select	ClientId    ,  
					ClientName    ,   
					InsuredId    ,  
					COBOrder    ,  
					Age      ,  
					Race,
					Sex      ,  
					CoveragePlanId  
			From (			
			SELECT	ClientId    ,  
					ClientName    ,   
					InsuredId    ,  
					COBOrder    ,  
					Age      ,  
					REPLACE(REPLACE(STUFF(  
							(SELECT Distinct ', ' + FR.Race    
							From #ResultSet FR   
							Where FR.ClientId=FS.ClientId												  
							FOR XML PATH(''))  
							,1,1,'')  
							,'&lt;','<'),'&gt;','>')'Race',  
					Sex      ,  
					CoveragePlanId  
			FROM    #ResultSet  FS
			Group by ClientId,ClientName,InsuredId,COBOrder,Age ,Sex,CoveragePlanId) As ResultData)
		, 

		counts as ( 
			select count(*) as TotalRows from ClientCoverageData
		),
		RankResultSet
		as

		(                                             
			SELECT
						ClientId				,
						ClientName				,	
						InsuredId				,
						COBOrder				,
						Age						,
						Race	                ,
						Sex						,
						CoveragePlanId      ,            
				 COUNT(*) OVER ( ) AS TotalCount ,
											RANK() OVER ( ORDER BY CASE
						 WHEN @SortExpression= 'ClientId'					THEN CoveragePlanId END,                                  
						CASE WHEN @SortExpression= 'ClientId desc'			THEN CoveragePlanId END DESC,
						CASE WHEN @SortExpression= 'ClientName'						THEN ClientName END,                                  
						CASE WHEN @SortExpression= 'ClientName desc'				THEN ClientName END DESC,
						CASE WHEN @SortExpression= 'InsuredId'						THEN InsuredId END,                                  
						CASE WHEN @SortExpression= 'InsuredId desc'					THEN InsuredId END DESC,
						CASE WHEN @SortExpression= 'COBOrder'						THEN COBOrder END,                                  
						CASE WHEN @SortExpression= 'COBOrder desc'					THEN COBOrder END DESC,
						CASE WHEN @SortExpression= 'Age'							THEN Age END,                                  
						CASE WHEN @SortExpression= 'Age desc'						THEN Age END DESC,
						CASE WHEN @SortExpression= 'Race'							THEN Race END,                                  
						CASE WHEN @SortExpression= 'Race desc'						THEN Race END DESC,
						CASE WHEN @SortExpression= 'Sex'							THEN Sex END ,
						CASE WHEN @SortExpression= 'Sex desc'						THEN Sex END DESC,
						CoveragePlanId
						)  AS RowNumber
				FROM     ClientCoverageData
				 )
					 	 
			SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
							ClientId				,
					ClientName				,	
					InsuredId				,
					COBOrder				,
					Age						,
					Race	                ,
					Sex						,
					CoveragePlanId			,
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
							case when @PageNumber=0 then 1 else @PageNumber end AS PageNumber ,
							CASE (TotalCount % @PageSize) WHEN 0 THEN 
							ISNULL(( TotalCount / @PageSize ), 0)
							ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,
							ISNULL(TotalCount, 0) AS NumberOfRows
					FROM    #FinalResultSet      
				END                   

            Select	ClientId    ,  
					ClientName    ,   
					InsuredId    ,  
					COBOrder    ,  
					Age      ,  
					Race,
					Sex      ,  
					CoveragePlanId  
			From #FinalResultSet
			Order by RowNumber
            
            
		DROP TABLE #CustomFilters
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMCoveragePlanEligibleClient')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + Convert(VARCHAR,ERROR_SEVERITY())                                                                                              
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


