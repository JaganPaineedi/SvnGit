/****** Object:  StoredProcedure [dbo].[csp_PMProcedureRatesAVOSS]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMProcedureRatesAVOSS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMProcedureRatesAVOSS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMProcedureRatesAVOSS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create PROCEDURE [dbo].[csp_PMProcedureRatesAVOSS]
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMProcedureRates
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Query to return data for the procedure rates list page.
--
-- Author:  Girish Sanaba
-- Date:    18 Apr 2011
-- 
-- *****History****
-- Author:				Date						Reason
-- MSuma				17 Aug 2011					Service ARea Changes included, Fixed Isues on Datatype LEngth
-- MSuma				03 Oct 2011					Datamodel Changes for ChargeType    
-- 
-- 
*********************************************************************************/

	@SessionId				VARCHAR(30),
	@InstanceId				INT,
	@PageNumber				INT,
	@PageSize				INT,
	@SortExpression			VARCHAR(100),
	@ActiveProcedure		INT,
	@ActivePlan				INT,
	@Degrees				INT,
	@Programs				INT,
	@Staff					INT,
	@Client					INT,
	@CodeRates				INT,
	@Locations				INT,
	@EffectiveOn			VARCHAR(100),
	@OtherFilter			INT,
	@StaffId				INT,
	@ServiceArea			INT,
	@PlaceOfService			INT
	
	
AS
BEGIN                                                              
	BEGIN TRY
	
	CREATE TABLE #ResultSet
	(
	RowNumber				INT,                                                  
	PageNumber				INT,
	ProcedureRateId			INT,
	ProcedureCodeId			INT,
	ProcedureCode			VARCHAR(25),
	Amount					VARCHAR(30),
	BillingCode				VARCHAR(10),
	ProgramGroupName		VARCHAR(250),
	LocationGroupName		VARCHAR(250),
	DegreeGroupName			VARCHAR(250),
	StaffGroupName			VARCHAR(250),
	ServiceAreaGroupName	VARCHAR(250),
	PlaceOfServiceGroupName	VARCHAR(250),
	ClientName				VARCHAR(110),
	RevenueCode				VARCHAR(100),
	FromDate				DATETIME,
	ToDate					DATETIME,
	ClientId				INT,
	NotBillable				VARCHAR(5),
	Active					VARCHAR(5),
	)
	
	DECLARE @CustomFilters			TABLE (ProcedureRateId INT)                                                  
	DECLARE @ApplyFilterClicked		CHAR(1)
	DECLARE @CustomFiltersApplied	CHAR(1)
	DECLARE @EffectiveDate			DATETIME
	DECLARE @CoveragePlanId			INT
	
	IF @ActivePlan = -1
		SET @CoveragePlanId = NULL
	ELSE
		SET @CoveragePlanId = @ActivePlan
		
	IF @EffectiveOn = ''''
		SET @EffectiveDate = NULL	
	ELSE
		SET @EffectiveDate = CONVERT(DATETIME,@EffectiveOn,101)
		
	SET @SortExpression = RTRIM(LTRIM(@SortExpression))
	IF ISNULL(@SortExpression, '''') = ''''
		SET @SortExpression= ''ProcedureCode''
	-- 
	-- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data                                                  
	--                                                  
	IF @PageNumber > 0 AND EXISTS(SELECT * FROM ListPagePMProcedureRates WHERE SessionId = @SessionId AND InstanceId = @InstanceId)                                                   
	BEGIN                                                  
		SET	@ApplyFilterClicked = ''N''                                                  
		GOTO GetPage                                                  
	END
	-- 
	-- New retrieve - the request came by clicking on the Apply Filter button                   
	--
	SET @ApplyFilterClicked = ''Y'' 
	SET @CustomFiltersApplied = ''N''                                                 
	SET @PageNumber = 1
	
	IF @OtherFilter > 10000                                    
	BEGIN
		SET @CustomFiltersApplied = ''Y''
		
		INSERT INTO @CustomFilters (ProcedureRateId) 
		EXEC scsp_PMProcedureRates 
			@ActiveProcedure		=@ActiveProcedure,
			@ActivePlan				=@ActivePlan,
			@Degrees				=@Degrees,
			@Programs				=@Programs,
			@Staff					=@Staff,
			@ServiceArea			=@ServiceArea,
			@PlaceOfService			=@PlaceOfService,
			@Client					=@Client,
			@CodeRates				=@CodeRates,
			@Locations				=@Locations,
			@EffectiveOn			=@EffectiveOn,
			@OtherFilter			=@OtherFilter,
			@StaffId				=@StaffId
	END
	
	--
	--	
	IF @CoveragePlanId IS NULL 

	BEGIN	

		
		INSERT INTO #ResultSet
		( 
		 ProcedureRateId
		,ProcedureCodeId
		,ProcedureCode
		,Amount
		,BillingCode
		,ProgramGroupName
		,LocationGroupName
		,DegreeGroupName
		,StaffGroupName
		,ServiceAreaGroupName
		,PlaceOfServiceGroupName
		,ClientName
		,RevenueCode
		,FromDate
		,ToDate
		,ClientId
		,NotBillable
		,Active
		)
		SELECT
		PR.ProcedureRateId       
		,PC.ProcedureCodeid       
		,CAST(PC.DisplayAs AS VARCHAR(25)) AS ProcedureCode       
		,CAST(''$'' +        
		CONVERT(VARCHAR,PR.Amount,1) + '' ''        
		+ CASE PR.Chargetype      
		--DataType changes for ChargeType  
		WHEN ''6761''-- ''P'' 
		THEN ''Per '' + (CASE WHEN AllowDecimals=''Y'' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END)  --Per       
		WHEN ''6763''--''R'' 
		THEN (CASE WHEN AllowDecimals=''Y'' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END) + '' to '' + (CASE WHEN AllowDecimals=''Y'' THEN CONVERT(VARCHAR,ToUnit,1) ELSE CAST(CAST(ROUND(ToUnit,0)AS INT)AS VARCHAR)  END) --Range       
		WHEN ''6762''--''E'' 
		THEN ''for '' + (CASE WHEN AllowDecimals=''Y'' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END) --Exact       
		END  + '' '' + GC1.CodeName AS VARCHAR(30)) AS Amount--Unit       
		,CASE             
		WHEN  EXISTS (SELECT * FROM ProcedureRateBillingCodes BC WHERE BC.ProcedureRateId=PR.ProcedureRateId AND ISNULL(BC.RecordDeleted, ''N'') = ''N'') THEN ''Varies''       
		ELSE CAST(PR.BillingCode + '' '' + ISNULL(PR.Modifier1, '''') +  '' '' + ISNULL(PR.Modifier2, '''') +  '' '' + ISNULL(PR.Modifier3, '''') +  '' '' + ISNULL(PR.Modifier4, '''') AS VARCHAR(10))       
		END AS BillingCode          
		,CAST(PR.ProgramGroupName AS VARCHAR(25)) AS ProgramGroupName       
		,CAST(PR.LocationGroupName AS VARCHAR(25)) AS LocationGroupName       
		,CAST(PR.DegreeGroupName AS VARCHAR(10)) AS DegreeGroupName       
		,CAST(PR.StaffGroupName AS VARCHAR(30)) AS StaffGroupName   
		,CAST(PR.ServiceAreaGroupName AS VARCHAR(30)) AS ServiceAreaGroupName 
		,CAST(PR.PlaceOfServiceGroupName AS VARCHAR(30)) AS PlaceOfServiceGroupName 
		,CAST(CL.LastName + '', '' + CL.FirstName AS VARCHAR(30))AS ClientName       
		,CAST(PR.RevenueCode AS VARCHAR(10)) AS RevenueCode       
		,PR.FromDate       
		,PR.ToDate       
		,PR.ClientId       
		,PC.NotBillable     
		,PC.Active        
		FROM        
		ProcedureCodes PC       				        
		 JOIN ProcedureRates PR 
		ON  PR.ProcedureCodeId = PC.ProcedureCodeId        AND ISNULL(PR.RecordDeleted,''N'') = ''N''  
		LEFT JOIN Clients CL        
		ON  PR.ClientID = CL.ClientID        AND ISNULL(cl.RecordDeleted,''N'') = ''N''  
		LEFT JOIN GlobalCodes GC1       
		ON PC.EnteredAs = GC1.GlobalCodeId      AND ISNULL(GC1.RecordDeleted,''N'') = ''N''  
		LEFT JOIN ProcedureRateDegrees PRD
		ON PR.ProcedureRateId = PRD.ProcedureRateId  AND ISNULL(PRD.RecordDeleted,''N'') = ''N''  
		LEFT JOIN ProcedureRatePrograms PRP
		ON PR.ProcedureRateId = PRP.ProcedureRateId  AND ISNULL(PRP.RecordDeleted,''N'') = ''N''  
		LEFT JOIN ProcedureRateLocations PRL
		ON PR.ProcedureRateId = PRL.ProcedureRateId  AND ISNULL(PRL.RecordDeleted,''N'') = ''N''  
		LEFT JOIN ProcedureRateStaff PRS
		ON PR.ProcedureRateId = PRS.ProcedureRateId  AND ISNULL(PRS.RecordDeleted,''N'') = ''N''  
		LEFT JOIN ProcedureRateServiceAreas PRSA
		ON PR.ProcedureRateId = PRSA.ProcedureRateId  AND ISNULL(PRSA.RecordDeleted,''N'') = ''N''  
		LEFT JOIN ProcedureRatePlacesOfServices PRPL
		ON PR.ProcedureRateId = PRPL.ProcedureRateId  AND ISNULL(PRPL.RecordDeleted,''N'') = ''N''  
		WHERE ((@CustomFiltersApplied = ''Y'' AND EXISTS(SELECT * FROM @CustomFilters cf WHERE cf.ProcedureRateId = PR.ProcedureRateId)) OR
		(@CustomFiltersApplied = ''N''
		AND ISNULL(PR.RecordDeleted,''N'') = ''N''       
		AND ISNULL(PC.RecordDeleted,''N'') = ''N''
		AND PR.CoveragePlanID IS NULL  
		AND (@ActiveProcedure = -1 OR									-- All Category states  
			(@ActiveProcedure = 1 AND ISNULL(PC.Active,''N'') = ''Y'') OR    -- Active               
			(@ActiveProcedure = 2 AND ISNULL(PC.Active,''N'') = ''N''))		-- InActive     
		AND (@Degrees = -1 OR
			(@Degrees = PRD.Degree))
		AND (ISNULL(PRD.RecordDeleted,''N'') = ''N'')       
		AND (@Programs = -1 OR
			(@Programs = PRP.ProgramId))
		AND (ISNULL(PRP.RecordDeleted,''N'') = ''N'')       
		AND (@Staff = -1 OR
			(@Staff = PRS.StaffId))	
		AND (ISNULL(PRS.RecordDeleted,''N'') = ''N'')       
		AND (@Client = -1 OR
			(@Client = CL.ClientId))	
		AND (ISNULL(CL.RecordDeleted,''N'') = ''N'')       	
		AND (@Locations = -1 OR
			(@Locations = PRL.LocationId))	
		AND (ISNULL(PRL.RecordDeleted,''N'') = ''N'')   
		AND (@ServiceArea = -1 OR
			(@ServiceArea = PRSA.ServiceAreaId))
		AND (ISNULL(PRSA.RecordDeleted,''N'') = ''N'')  
		AND (@PlaceOfService = -1 OR
			(@PlaceOfService = PRPL.PlaceOfServieId))
		AND (ISNULL(PRPL.RecordDeleted,''N'') = ''N'')    
		AND ((@CodeRates = -1)
			OR (@CodeRates = 1 AND PR.ProgramGroupName IS NOT NULL)
			OR (@CodeRates = 2 AND PR.LocationGroupName IS NOT NULL)
			OR (@CodeRates = 3 AND PR.DegreeGroupName IS NOT NULL)
			OR (@CodeRates = 4 AND PR.StaffGroupName IS NOT NULL)
			OR (@CodeRates = 5 AND CAST(CL.LastName + '', '' + CL.FirstName AS VARCHAR(30)) IS NOT NULL)
			OR (@CodeRates = 6 
					 AND PR.ProgramGroupName IS NULL
					 AND PR.LocationGroupName IS NULL 
					 AND PR.DegreeGroupName IS NULL  
					 AND PR.StaffGroupName IS NULL  
					 AND PR.ServiceAreaGroupName IS NULL
					 AND PR.PlaceOfServiceGroupName IS NULL
					 AND CAST(CL.LastName + '', '' + CL.FirstName AS VARCHAR(30)) IS NULL )
				)
		AND (@CodeRates <> 7)))	
		
		UNION
		
		 SELECT      
		''0''AS ProcedureRateId--PR.ProcedureRateId       
		,ProcedureCodeid       
		,CAST(DisplayAs AS VARCHAR(25)) AS ProcedureCode       
		,'''' AS Amount--Unit       
		,NULL AS BillingCode--PR.BillingCode       
		,NULL AS ProgramGroupName--PR.ProgramGroupName       
		,NULL AS LocationGroupName--PR.LocationGroupName       
		,NULL AS DegreeGroupName--PR.DegreeGroupName       
		,NULL AS StaffGroupName--PR.StaffGroupName  
		,NULL AS ServiceAreaGroupName
		,NULL AS PlaceOfServiceGroupName     
		,NULL AS ClientName--CL.LastName + '', '' + CL.FirstName AS ClientName       
		,NULL AS RevenueCode--PR.RevenueCode       
		,NULL AS FromDate--PR.FromDate       
		,NULL AS ToDate--PR.ToDate       
		,NULL AS ClientId--PR.ClientId       
		,NotBillable     
		,Active        
		FROM         
		ProcedureCodes PC        
		WHERE       
		ISNULL(PC.RecordDeleted,''N'') = ''N'' 
		AND (@ActiveProcedure = -1 OR									-- All Category states  
			(@ActiveProcedure = 1 AND ISNULL(PC.Active,''N'') = ''Y'') OR    -- Active               
			(@ActiveProcedure = 2 AND ISNULL(PC.Active,''N'') = ''N'')		-- InActive 
			)		    
		AND ( @CodeRates = -1 OR @CodeRates = 6 OR @CodeRates = 7 )		
		AND	(@Degrees = -1)
		AND	(@Programs = -1)
		AND	(@Staff = -1)
		AND	(@Client = -1)
		AND (@Locations = -1)	
		AND (@ServiceArea = -1)
		AND (@PlaceOfService = -1)
		AND (NOT EXISTS ( SELECT * FROM ProcedureRates PR
						 WHERE  PR.ProcedureCodeId = PC.ProcedureCodeId
						 AND ISNULL(PR.RecordDeleted,''N'') = ''N''
						 AND PR.CoveragePlanId IS NULL)
			)
			
			
		DELETE #ResultSet
		WHERE (ProcedureRateId = 0
		AND @CodeRates IN (-1,6)		
		AND @EffectiveDate IS NOT NULL
		AND ISNULL(NotBillable,''N'') = ''N'')		
		OR (@EffectiveDate < ISNULL(FromDate,CONVERT(DATETIME,''01/01/1900'',101)) OR @EffectiveDate > ISNULL(ToDate, CONVERT(DATETIME,''12/31/2299'',101)))
			
		
		END	
	
	ELSE
	
	--
	--  Find only billable procedure codes for the corresponding coverage plan
	--
	BEGIN

		INSERT INTO #ResultSet
		( 
		 ProcedureRateId
		,ProcedureCodeId
		,ProcedureCode
		,Amount
		,BillingCode
		,ProgramGroupName
		,LocationGroupName
		,DegreeGroupName
		,StaffGroupName
		,ServiceAreaGroupName
		,PlaceOfServiceGroupName
		,ClientName
		,RevenueCode
		,FromDate
		,ToDate
		,ClientId
		,NotBillable
		,Active
		)
		( SELECT    DISTINCT    
		  ISNULL(PR.ProcedureRateId,0) AS ProcedureRateId
		  ,PC.ProcedureCodeid        
		  ,CAST(PC.DisplayAs AS VARCHAR(25)) AS ProcedureCode        
		  ,CAST(''$'' +         
		   CONVERT(VARCHAR,PR.Amount,1) + '' ''       
		   --DataType changes for ChargeType  
		   + CASE PR.Chargetype         
			 WHEN ''6761''--''P''
			  THEN ''Per '' + (CASE WHEN AllowDecimals=''Y'' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END)  --Per        
			 WHEN ''6763''--''R'' 
			 THEN (CASE WHEN AllowDecimals=''Y'' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END) + '' to '' + (CASE WHEN AllowDecimals=''Y'' THEN CONVERT(VARCHAR,ToUnit,1) ELSE CAST(CAST(ROUND(ToUnit,0)AS INT)AS VARCHAR)  END) --Range        
			 WHEN ''6762''--''E'' 
			 THEN ''for '' + (CASE WHEN AllowDecimals=''Y'' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END) --Exact        
		   END  + '' '' + GC.CodeName AS VARCHAR(30)) AS Amount--Unit        
		  ,CASE              
		   WHEN  EXISTS (SELECT * FROM ProcedureRateBillingCodes BC WHERE BC.ProcedureRateId=PR.ProcedureRateId AND ISNULL(BC.RecordDeleted, ''N'') = ''N'') THEN ''Varies''        
		   ELSE CAST(PR.BillingCode + '' '' + ISNULL(PR.Modifier1, '''') +  '' '' + ISNULL(PR.Modifier2, '''') +  '' '' + ISNULL(PR.Modifier3, '''') +  '' '' + ISNULL(PR.Modifier4, '''') AS VARCHAR(10))        
		   END AS BillingCode           
		  ,CAST(PR.ProgramGroupName AS VARCHAR(25)) AS ProgramGroupName        
		  ,CAST(PR.LocationGroupName AS VARCHAR(25)) AS LocationGroupName        
		  ,CAST(PR.DegreeGroupName AS VARCHAR(10)) AS DegreeGroupName        
		  ,CAST(PR.StaffGroupName AS VARCHAR(30)) AS StaffGroupName
		  ,CAST(PR.ServiceAreaGroupName AS VARCHAR(30)) AS ServiceAreaGroupName
		  ,CAST(PR.PlaceOfServiceGroupName AS VARCHAR(30))  AS PlaceOfServiceGroupName
		  ,CAST(CL.LastName + '', '' + CL.FirstName AS VARCHAR(30))AS ClientName        
		  ,CAST(PR.RevenueCode AS VARCHAR(10)) AS RevenueCode        
		  ,PR.FromDate        
		  ,PR.ToDate        
		  ,PR.ClientId        
		  ,PC.NotBillable      
		  ,PC.Active         
		 FROM ProcedureCodes PC
		 LEFT JOIN ProcedureRates PR ON PR.ProcedureCodeId = PC.ProcedureCodeId 
		 LEFT JOIN Clients CL ON  PR.ClientID = CL.ClientID         
		 LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=PC.EnteredAs        
		LEFT JOIN ProcedureRateDegrees PRD ON PR.ProcedureRateId = PRD.ProcedureRateId
		LEFT JOIN ProcedureRatePrograms PRP ON PR.ProcedureRateId = PRP.ProcedureRateId
		LEFT JOIN ProcedureRateLocations PRL ON PR.ProcedureRateId = PRL.ProcedureRateId
		LEFT JOIN ProcedureRateStaff PRS ON PR.ProcedureRateId = PRS.ProcedureRateId
		LEFT JOIN ProcedureRateServiceAreas PRSA ON PR.ProcedureRateId = PRSA.ProcedureRateId
		LEFT JOIN ProcedureRatePlacesOfServices PRPL ON PR.ProcedureRateId = PRPL.ProcedureRateId
 
		 WHERE ((@CustomFiltersApplied = ''Y'' AND EXISTS(SELECT * FROM @CustomFilters cf WHERE cf.ProcedureRateId = PR.ProcedureRateId)) OR
		(@CustomFiltersApplied = ''N''		   
		AND ISNULL(PC.RecordDeleted,''N'') = ''N''       
		AND ISNULL(PR.RecordDeleted,''N'') = ''N''   
		AND (@ActiveProcedure = -1 OR									-- All Category states  
			(@ActiveProcedure = 1 AND ISNULL(PC.Active,''N'') = ''Y'') OR    -- Active               
			(@ActiveProcedure = 2 AND ISNULL(PC.Active,''N'') = ''N''))		-- InActive     
		AND (@Degrees = -1 OR
			(@Degrees = PRD.Degree))
		AND (ISNULL(PRD.RecordDeleted,''N'') = ''N'')       
		AND (@Programs = -1 OR
			(@Programs = PRP.ProgramId))
		AND (ISNULL(PRP.RecordDeleted,''N'') = ''N'')       
		AND (@Staff = -1 OR
			(@Staff = PRS.StaffId))	
		AND (ISNULL(PRS.RecordDeleted,''N'') = ''N'')       
		AND (@Client = -1 OR
			(@Client = CL.ClientId))	
		AND (ISNULL(CL.RecordDeleted,''N'') = ''N'')       
		AND (@Locations = -1 OR
			(@Locations = PRL.LocationId))	
		AND (ISNULL(PRL.RecordDeleted,''N'') = ''N'')
		AND (@ServiceArea = -1 OR
			(@ServiceArea = PRSA.ServiceAreaId))
		AND (ISNULL(PRSA.RecordDeleted,''N'') = ''N'')  
		AND (@PlaceOfService = -1 OR
			(@PlaceOfService = PRPL.PlaceOfServieId))
		AND (ISNULL(PRPL.RecordDeleted,''N'') = ''N'')  
		AND ((@CodeRates = -1)
			OR (@CodeRates = 1 AND PR.ProgramGroupName IS NOT NULL)
			OR (@CodeRates = 2 AND PR.LocationGroupName IS NOT NULL)
			OR (@CodeRates = 3 AND PR.DegreeGroupName IS NOT NULL)
			OR (@CodeRates = 4 AND PR.StaffGroupName IS NOT NULL)
			OR (@CodeRates = 5 AND CL.LastName IS NOT NULL AND CL.FirstName IS NOT NULL)
			OR (@CodeRates = 6 AND PR.ProgramGroupName IS NULL
			 AND PR.LocationGroupName IS NULL AND PR.DegreeGroupName IS NULL  
			 AND PR.StaffGroupName IS NULL  
			 AND PR.ServiceAreaGroupName IS NULL
			 AND PR.PlaceOfServiceGroupName IS NULL
			 AND CAST(CL.LastName + '', '' + CL.FirstName AS VARCHAR(30)) IS NULL 
			))
		AND (@CodeRates <> 7)
		       
		AND (ISNULL(@EffectiveDate,PR.FromDate) BETWEEN PR.FromDate AND ISNULL(PR.ToDate,CONVERT(DATETIME,''12/31/2299'',101)))   
    
		AND NOT EXISTS (SELECT * FROM CoveragePlanRules cpr
						LEFT JOIN CoveragePlanRuleVariables cprv ON cpr.CoveragePlanRuleId = cprv.CoveragePlanRuleId 
						WHERE cpr.RuleTypeId = 4267  --Not billable to this plan
						AND ISNULL(CPRV.ProcedureCodeId,PC.ProcedureCodeId) = PC.ProcedureCodeId 
						AND (isnull(cpr.AppliesToAllProcedureCodes,''Y'') = ''Y'' OR ISNULL(cprv.AppliesToAllProcedureCodes,''Y'') = ''Y'') 
						AND cpr.CoveragePlanId = @CoveragePlanId
						AND ISNULL(cpr.RecordDeleted, ''N'')= ''N''
						AND ISNULL(cprv.RecordDeleted, ''N'')= ''N''
						)
		AND ISNULL(pr.CoveragePlanId, 0) IN  (SELECT CASE WHEN ISNULL(cp2.BillingCodeTemplate, ''S'')= ''S'' THEN 0
													 WHEN ISNULL(cp2.BillingCodeTemplate, ''S'')= ''T'' THEN cp2.CoveragePlanid
													 WHEN ISNULL(cp2.BillingCodeTemplate, ''S'')= ''O'' THEN cp2.UseBillingCodesFrom
													 END 
											  FROM CoveragePlans cp2 
											  WHERE cp2.CoveragePlanId = @CoveragePlanId
											  AND ISNULL(cp2.RecordDeleted, ''N'')= ''N''
											)))
		)

		
	END		
	
	GetPage:
               
		IF @ApplyFilterClicked = ''N'' 
			AND EXISTS(SELECT * FROM ListPagePMProcedureRates 
						WHERE SessionId = @SessionId 
						AND InstanceId = @InstanceId 
						AND SortExpression = @SortExpression) 
			GOTO Final                                            
	                                            
		SET @PageNumber = 1
	                                            
		IF @ApplyFilterClicked = ''N''                                            
		BEGIN
			INSERT INTO #ResultSet 
			( 
			 ProcedureRateId
			,ProcedureCodeId
			,ProcedureCode
			,Amount
			,BillingCode
			,ProgramGroupName
			,LocationGroupName
			,DegreeGroupName
			,StaffGroupName
			,ServiceAreaGroupName
			,PlaceOfServiceGroupName
			,ClientName
			,RevenueCode
			,FromDate
			,ToDate
			,NotBillable
			,Active      
			)                                              
			SELECT
			 ProcedureRateId
			,ProcedureCodeId
			,ProcedureCode
			,Amount
			,BillingCode
			,ProgramGroupName
			,LocationGroupName
			,DegreeGroupName
			,StaffGroupName
			,ServiceAreaGroupName
			,PlaceOfServiceGroupName
			,ClientName
			,RevenueCode
			,FromDate
			,ToDate
			,NotBillable
			,Active 
			FROM ListPagePMProcedureRates                                            
			WHERE SessionId = @SessionId AND InstanceId = @InstanceId                                            
		END                                            
	                                            
		UPDATE d 
			SET RowNumber = rn.RowNumber,                         
				PageNumber = (rn.RowNumber/@PageSize) + CASE WHEN rn.RowNumber % @PageSize = 0 THEN 0 ELSE 1 END                                        
			FROM #ResultSet d JOIN (SELECT ProcedureRateId, ProcedureCodeId, ROW_NUMBER() OVER (ORDER BY 
				CASE WHEN @SortExpression= ''ProcedureCode''			THEN ProcedureCode END,                                  
				CASE WHEN @SortExpression= ''ProcedureCode desc''		THEN ProcedureCode END DESC,
				CASE WHEN @SortExpression= ''Amount''					THEN Amount END,                                  
				CASE WHEN @SortExpression= ''Amount desc''			THEN Amount END DESC,
				CASE WHEN @SortExpression= ''BillingCode''			THEN BillingCode END,                                  
				CASE WHEN @SortExpression= ''BillingCode desc''		THEN BillingCode END DESC,
				CASE WHEN @SortExpression= ''ProgramGroupName''		THEN ProgramGroupName END,                                  
				CASE WHEN @SortExpression= ''ProgramGroupName desc''	THEN ProgramGroupName END DESC,
				CASE WHEN @SortExpression= ''LocationGroupName''		THEN LocationGroupName END,                                  
				CASE WHEN @SortExpression= ''LocationGroupName desc''	THEN LocationGroupName END DESC,
				CASE WHEN @SortExpression= ''DegreeGroupName''		THEN DegreeGroupName END,                                  
				CASE WHEN @SortExpression= ''DegreeGroupName desc''	THEN DegreeGroupName END DESC,
				CASE WHEN @SortExpression= ''StaffGroupName''			THEN StaffGroupName END,                                  
				CASE WHEN @SortExpression= ''StaffGroupName desc''	THEN StaffGroupName END DESC,
				CASE WHEN @SortExpression= ''ServiceAreaGroupName''	THEN ServiceAreaGroupName END,                                  
				CASE WHEN @SortExpression= ''ServiceAreaGroupName desc''	THEN ServiceAreaGroupName END DESC,
				CASE WHEN @SortExpression= ''PlaceOfServiceGroupName''	THEN PlaceOfServiceGroupName END,                                  
				CASE WHEN @SortExpression= ''PlaceOfServiceGroupName desc''	THEN PlaceOfServiceGroupName END DESC,
				CASE WHEN @SortExpression= ''ClientName''				THEN ClientName END,                                  
				CASE WHEN @SortExpression= ''ClientName desc''		THEN ClientName END DESC,
				CASE WHEN @SortExpression= ''RevenueCode''			THEN RevenueCode END,                                  
				CASE WHEN @SortExpression= ''RevenueCode desc''		THEN RevenueCode END DESC,
				CASE WHEN @SortExpression= ''FromDate''				THEN FromDate END,                                  
				CASE WHEN @SortExpression= ''FromDate desc''			THEN FromDate END DESC,
				CASE WHEN @SortExpression= ''ToDate''					THEN ToDate END,                                  
				CASE WHEN @SortExpression= ''ToDate desc''			THEN ToDate END DESC,
				ProcedureRateId
				) AS RowNumber FROM #ResultSet) rn ON rn.ProcedureRateId = d.ProcedureRateId AND rn.ProcedureCodeId = d.ProcedureCodeId 
	                                        
		DELETE FROM ListPagePMProcedureRates
			WHERE SessionId = @SessionId AND InstanceId = @InstanceId                                        
	                                    
		INSERT INTO ListPagePMProcedureRates
		(                                        
			 SessionId                                       
			,InstanceId                                        
			,RowNumber                                       
			,PageNumber                   
			,SortExpression 
			,ProcedureRateId
			,ProcedureCodeId
			,ProcedureCode
			,Amount
			,BillingCode
			,ProgramGroupName
			,LocationGroupName
			,DegreeGroupName
			,StaffGroupName
			,ServiceAreaGroupName
			,PlaceOfServiceGroupName
			,ClientName
			,RevenueCode
			,FromDate
			,ToDate
			,NotBillable
			,Active 
		)                                        
		SELECT  
			@SessionId                                        
			,@InstanceId                                       
			,RowNumber                                        
			,PageNumber                                        
			,@SortExpression
			,ProcedureRateId
			,ProcedureCodeId
			,ProcedureCode
			,Amount
			,BillingCode
			,ProgramGroupName
			,LocationGroupName
			,DegreeGroupName
			,StaffGroupName
			,ServiceAreaGroupName
			,PlaceOfServiceGroupName
			,ClientName
			,RevenueCode
			,FromDate
			,ToDate
			,NotBillable
			,Active 
		FROM #ResultSet
	                                        
Final:	                                        
		SELECT @PageNumber AS PageNumber, ISNULL(MAX(PageNumber), 0) AS NumberOfPages, ISNULL(MAX(RowNumber), 0) AS NumberOfRows                                        
			FROM ListPagePMProcedureRates                                        
		WHERE SessionId = @SessionId                                        
			AND InstanceId = @InstanceId                                        
	                                   
		SELECT
			 ProcedureRateId
			,ProcedureCodeId
			,ProcedureCode
			,Amount
			,BillingCode
			,ProgramGroupName
			,LocationGroupName
			,DegreeGroupName
			,StaffGroupName
			,ServiceAreaGroupName
			,PlaceOfServiceGroupName
			,ClientName
			,RevenueCode
			,FromDate
			,ToDate
			,NotBillable
			,Active  
		FROM ListPagePMProcedureRates                                        
		WHERE SessionId = @SessionId                                        
			AND InstanceId = @InstanceId                                        
			AND PageNumber = @PageNumber                                        
		ORDER BY RowNumber
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''ssp_PMProcedureRates'')                                                                                             
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END

' 
END
GO
