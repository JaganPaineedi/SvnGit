IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCInitClaimDenialOverrides]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCInitClaimDenialOverrides]
GO

CREATE PROCEDURE [dbo].[SSP_SCInitClaimDenialOverrides] (
	@StaffId INT
	,@ClientID INT =null
	,@CustomParameters XML
	)
AS
----------------------------------------------  
--Modified : Shruthi.S  
--Date     : 24/07/2015   
--Purpose  : Added to init for Copy Claim and New.Ref #603 Network 180 -Customizations.  
--Modified : Basudev Sahu
--Date     : 29/04/2016   
--Purpose  : Modified for Copy Claim and New.Ref #56 Network 180 -Customizations.  

--------------------------------------------  
BEGIN
	DECLARE @ClaimDenialOverrideId INT

	--DECLARE @CopyClaim varchar(10)  
	SET @ClaimDenialOverrideId = @CustomParameters.value('(/Root/Parameters/@ClaimDenialOverrideId)[1]', 'int')

	---Temp table for ClaimDenialOverrideDenialReasons
	CREATE TABLE #ClaimDenialOverrideDenialReasons (
		TableName VARCHAR(100)
		,ClaimDenialOverrideDenialReasonId INT identity(- 1, - 1)
		,CreatedBy VARCHAR(300)
		,CreatedDate DATETIME
		,ModifiedBy VARCHAR(300)
		,ModifiedDate DATETIME
		,RecordDeleted CHAR(1)
		,DeletedBy VARCHAR(300)
		,DeletedDate DATETIME
		,ClaimDenialOverrideId INT
		,DenialReasonId INT
		,DenialReasonName VARCHAR(250)
		)

	---Temp table for ClaimDenialOverrideBillingCodes
	CREATE TABLE #ClaimDenialOverrideBillingCodes (
		TableName VARCHAR(100)
		,ClaimDenialOverrideBillingCodeId INT identity(- 1, - 1)
		,CreatedBy VARCHAR(300)
		,CreatedDate DATETIME
		,ModifiedBy VARCHAR(300)
		,ModifiedDate DATETIME
		,RecordDeleted CHAR(1)
		,DeletedBy VARCHAR(300)
		,DeletedDate DATETIME
		,ClaimDenialOverrideId INT
		,BillingCodeId INT
		,BillingCodeName VARCHAR(20)
		)

	---Temp table for ClaimDenialOverrideAuthorizationNumbers
	--CREATE TABLE #ClaimDenialOverrideAuthorizationNumbers (
	--	TableName VARCHAR(100)
	--	,ClaimDenialOverrideAuthorizationNumberId INT identity(- 1, - 1)
	--	,CreatedBy VARCHAR(300)
	--	,CreatedDate DATETIME
	--	,ModifiedBy VARCHAR(300)
	--	,ModifiedDate DATETIME
	--	,RecordDeleted CHAR(1)
	--	,DeletedBy VARCHAR(300)
	--	,DeletedDate DATETIME
	--	,ClaimDenialOverrideId INT
	--	,ProviderAuthorizationId INT
	--	,AuthorizationNumber varchar(35)
	--	)
	
	
	
	
	--Temp table for ClaimDenialOverrideClients
	
	CREATE TABLE #ClaimDenialOverrideClients (
		TableName VARCHAR(100)
		,ClaimDenialOverrideClientId INT identity(- 1, - 1)
		,CreatedBy VARCHAR(300)
		,CreatedDate DATETIME
		,ModifiedBy VARCHAR(300)
		,ModifiedDate DATETIME
		,RecordDeleted CHAR(1)
		,DeletedBy VARCHAR(300)
		,DeletedDate DATETIME
		,ClaimDenialOverrideId INT
		,ClientId INT
		,ClientName VARCHAR(300)
		)
	
	

	---Temp table for ClaimDenialOverrideReasonComments
	CREATE TABLE #ClaimDenialOverrideReasonComments (
		TableName VARCHAR(100)
		,ClaimDenialOverrideReasonCommentId INT identity(- 1, - 1)
		,CreatedBy VARCHAR(300)
		,CreatedDate DATETIME
		,ModifiedBy VARCHAR(300)
		,ModifiedDate DATETIME
		,RecordDeleted CHAR(1)
		,DeletedBy VARCHAR(300)
		,DeletedDate DATETIME
		,ClaimDenialOverrideId INT
		,ReasonId INT
		,ReasonName VARCHAR(20)
		)

	--Inserting for Denial Reasons grid
	INSERT INTO #ClaimDenialOverrideDenialReasons (
		TableName
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,ClaimDenialOverrideId
		,DenialReasonId
		,DenialReasonName
		)
	SELECT 'ClaimDenialOverrideDenialReasons'
		,CR.CreatedBy
		,CR.CreatedDate
		,CR.ModifiedBy
		,CR.ModifiedDate
		,CR.RecordDeleted
		,CR.DeletedBy
		,CR.DeletedDate
		, - 1 AS 'ClaimDenialOverrideId' 
		,CR.DenialReasonId
		,CASE 
			WHEN CR.DenialReasonId = - 1
				THEN 'ALL'
			ELSE GC.CodeName
			END AS DenialReasonName
	FROM ClaimDenialOverrideDenialReasons CR
	left JOIN GlobalCodes GC ON GC.GlobalCodeId = CR.DenialReasonId
	WHERE CR.ClaimDenialOverrideId = @ClaimDenialOverrideId
		AND ISNULL(CR.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(GC.RecordDeleted, 'N') <> 'Y'

	--Inserting for Billing Codes grid
	INSERT INTO #ClaimDenialOverrideBillingCodes (
		TableName
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,ClaimDenialOverrideId
		,BillingCodeId
		,BillingCodeName
		)
	SELECT 'ClaimDenialOverrideBillingCodes'
		,CB.CreatedBy
		,CB.CreatedDate
		,CB.ModifiedBy
		,CB.ModifiedDate
		,CB.RecordDeleted
		,CB.DeletedBy
		,CB.DeletedDate
		, - 1 AS 'ClaimDenialOverrideId' 
		,CB.BillingCodeId
		,CASE 
			WHEN CB.BillingCodeId = - 1
				THEN 'ALL'
			ELSE BC.BillingCode
			END AS BillingCodeName
	FROM ClaimDenialOverrideBillingCodes CB
	left JOIN BillingCodes BC ON BC.BillingCodeID = CB.BillingCodeId
		AND ISNULL(BC.RecordDeleted, 'N') <> 'Y'
	WHERE CB.ClaimDenialOverrideId = @ClaimDenialOverrideId
		AND ISNULL(CB.RecordDeleted, 'N') <> 'Y'

	--Inserting for Auth grid

	--INSERT INTO #ClaimDenialOverrideAuthorizationNumbers (
	--	TableName
	--	,CreatedBy
	--	,CreatedDate
	--	,ModifiedBy
	--	,ModifiedDate
	--	,RecordDeleted
	--	,DeletedBy
	--	,DeletedDate
	--	,ClaimDenialOverrideId
	--	,ProviderAuthorizationId
	--	,AuthorizationNumber
	--	)
	--SELECT 'ClaimDenialOverrideAuthorizationNumbers' AS TableName
	--	,CA.CreatedBy
	--	,CA.CreatedDate
	--	,CA.ModifiedBy
	--	,CA.ModifiedDate
	--	,CA.RecordDeleted
	--	,CA.DeletedBy
	--	,CA.DeletedDate
	--	,CA.ClaimDenialOverrideId
	--	,CA.ProviderAuthorizationId
	--	,CASE 
	--		WHEN CA.ProviderAuthorizationId = - 1
	--			THEN 'ALL'
	--		ELSE PA.AuthorizationNumber
	--		END AS AuthorizationNumber
	--FROM ClaimDenialOverrideAuthorizationNumbers CA
	--LEFT JOIN ProviderAuthorizations PA ON PA.ProviderAuthorizationId = CA.ProviderAuthorizationId
	--	AND ISNULL(PA.RecordDeleted, 'N') <> 'Y'
	--WHERE CA.ClaimDenialOverrideId = @ClaimDenialOverrideId
	--	AND ISNULL(CA.RecordDeleted, 'N') <> 'Y'
	
	--Inserting to Reason comments grid
	
	-- inserting into ClaimDenialOverrideClients
	Insert into  #ClaimDenialOverrideClients (
		TableName 
		,CreatedBy 
		,CreatedDate 
		,ModifiedBy 
		,ModifiedDate 
		,RecordDeleted 
		,DeletedBy 
		,DeletedDate 
		,ClaimDenialOverrideId 
		,ClientId 
		,ClientName 
		)
	SELECT
    'ClaimDenialOverrideClients' AS TableName
    ,CDC.CreatedBy,
    CDC.CreatedDate,
    CDC.ModifiedBy,
    CDC.ModifiedDate,
    CDC.RecordDeleted,
    CDC.DeletedBy,
    CDC.DeletedDate,
     - 1 AS 'ClaimDenialOverrideId' ,
    CDC.ClientId,
    isnull(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') as ClientName
    FROM ClaimDenialOverrideClients CDC left join ClientS C on c.ClientId=CDC.ClientId
     WHERE CDC.ClaimDenialOverrideId = @ClaimDenialOverrideId and ISNULL(CDC.RecordDeleted,'N') <> 'Y'
	
	
	
	INSERT INTO #ClaimDenialOverrideReasonComments (
		TableName
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,ClaimDenialOverrideId
		,ReasonId
		,ReasonName
		)
	SELECT 'ClaimDenialOverrideReasonComments' AS TableName
		,CR.CreatedBy
		,CR.CreatedDate
		,CR.ModifiedBy
		,CR.ModifiedDate
		,CR.RecordDeleted
		,CR.DeletedBy
		,CR.DeletedDate
		, - 1 AS 'ClaimDenialOverrideId' 
		,CR.ReasonId
		,GC.CodeName AS ReasonName
	FROM ClaimDenialOverrideReasonComments CR
	LEFT JOIN GlobalCodes GC ON Gc.GlobalCodeId = CR.ReasonId
	WHERE CR.ClaimDenialOverrideId = @ClaimDenialOverrideId
		AND ISNULL(CR.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(GC.RecordDeleted, 'N') <> 'Y'

	BEGIN
		IF (@ClaimDenialOverrideId < 0)
		BEGIN
			SELECT 'ClaimDenialOverrides' AS TableName
				,- 1 AS 'ClaimDenialOverrideId'
				,'Y' As Active 
				--,@ClientID AS 'ClientId'
				,'Y' As Active
				,@ClientID AS 'ClientId'
				,CBTA.CreatedBy
				,CBTA.CreatedDate
				,CBTA.ModifiedBy
				,CBTA.ModifiedDate
				,CBTA.RecordDeleted
				,CBTA.DeletedDate
				,CBTA.DeletedBy
			FROM systemconfigurations SC
			LEFT JOIN ClaimDenialOverrides CBTA ON SC.DatabaseVersion = - 1
		END
		ELSE
		BEGIN
			SELECT 'ClaimDenialOverrides' AS TableName
				,- 1 AS 'ClaimDenialOverrideId'
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,RecordDeleted
				,DeletedBy
				,DeletedDate
				--,ProviderId
				--,SiteId
				--,@ClientID AS 'ClientId'
				,StartDate
				,EndDate
				,Active
				,RateNotFound
				,RatePerUnit
				,ReasonComment
				,ProviderSiteGroupName
				,InsurerGroupName
				,DenialReasonGroupName
				,BillingCodeGroupName
				,ReasonComment
			FROM ClaimDenialOverrides CD
			WHERE CD.ClaimDenialOverrideId = @ClaimDenialOverrideId
				AND isnull(RecordDeleted, 'N') = 'N'

			--ClaimDenialOverrideDenialReasons for Denial Reasons grid
			SELECT TableName
				,ClaimDenialOverrideDenialReasonId 
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,RecordDeleted
				,DeletedBy
				,DeletedDate
				,ClaimDenialOverrideId
				,DenialReasonId
				,DenialReasonName
			FROM #ClaimDenialOverrideDenialReasons

			--ClaimDenialOverrideBillingCodes for BillingCodes grid
			SELECT TableName
				,ClaimDenialOverrideBillingCodeId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,RecordDeleted
				,DeletedBy
				,DeletedDate
				, - 1 AS 'ClaimDenialOverrideId' 
				,BillingCodeId
				,BillingCodeName
			FROM #ClaimDenialOverrideBillingCodes

			----ClaimDenialOverrideAuthorizationNumbers for Auth numbers grid
			--SELECT TableName
			--	,ClaimDenialOverrideAuthorizationNumberId
			--	,CreatedBy
			--	,CreatedDate
			--	,ModifiedBy
			--	,ModifiedDate
			--	,RecordDeleted
			--	,DeletedBy
			--	,DeletedDate
			--	,ClaimDenialOverrideId
			--	,ProviderAuthorizationId
			--	,AuthorizationNumber
			--FROM #ClaimDenialOverrideAuthorizationNumbers
			
			
			--ClaimDenialOverrideClients for client grid
			SELECT
			TableName,
			ClaimDenialOverrideClientId,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate,
			RecordDeleted,
			DeletedBy,
			DeletedDate,
			ClaimDenialOverrideId,
			ClientId,
			ClientName
			FROM #ClaimDenialOverrideClients 
			
			
		--ClaimDenialOverrideReasonComments for Reasonscomments grid
		SELECT TableName
			,ClaimDenialOverrideReasonCommentId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,ClaimDenialOverrideId
			,ReasonId
			,ReasonName
		FROM #ClaimDenialOverrideReasonComments
			
			
			--TEmp table for ClaimDenialOverrideProviderSites
	
	CREATE TABLE #ClaimDenialOverrideProviderSites (
		TableName VARCHAR(100)
		,ClaimDenialOverrideProviderSiteId INT identity(- 1, - 1)
		,CreatedBy VARCHAR(300)
		,CreatedDate DATETIME
		,ModifiedBy VARCHAR(300)
		,ModifiedDate DATETIME
		,RecordDeleted CHAR(1)
		,DeletedBy VARCHAR(300)
		,DeletedDate DATETIME
		,ClaimDenialOverrideId INT
		,ProviderId INT
		,SiteId INT
		)
		
		
	--TEmp table for ClaimDenialOverrideInsurers
	
	CREATE TABLE #ClaimDenialOverrideInsurers (
		TableName VARCHAR(100)
		,ClaimDenialOverrideInsurerId INT identity(- 1, - 1)
		,CreatedBy VARCHAR(300)
		,CreatedDate DATETIME
		,ModifiedBy VARCHAR(300)
		,ModifiedDate DATETIME
		,RecordDeleted CHAR(1)
		,DeletedBy VARCHAR(300)
		,DeletedDate DATETIME
		,ClaimDenialOverrideId INT
		,InsurerId INT
		)
			
	Insert into  #ClaimDenialOverrideProviderSites (
	TableName 
	,CreatedBy 
	,CreatedDate 
	,ModifiedBy 
	,ModifiedDate 
	,RecordDeleted 
	,DeletedBy 
	,DeletedDate 
	,ClaimDenialOverrideId 
	,ProviderId 
	,SiteId 
	)
	 select
    'ClaimDenialOverrideProviderSites' AS TableName,
    CPS.CreatedBy,
    CPS.CreatedDate,
    CPS.ModifiedBy,
    CPS.ModifiedDate,
    CPS.RecordDeleted,
    CPS.DeletedBy,
    CPS.DeletedDate,
     - 1 AS 'ClaimDenialOverrideId' ,
    CPS.ProviderId,
    CPS.SiteId
    FROM ClaimDenialOverrideProviderSites CPS WHERE CPS.ClaimDenialOverrideId = @ClaimDenialOverrideId  and ISNULL(CPS.RecordDeleted,'N') <> 'Y'
    	
			
	Insert into  #ClaimDenialOverrideInsurers (
	TableName 
	,CreatedBy 
	,CreatedDate 
	,ModifiedBy 
	,ModifiedDate 
	,RecordDeleted 
	,DeletedBy 
	,DeletedDate 
	,ClaimDenialOverrideId 
	,InsurerId 
	)
 	SELECT
   'ClaimDenialOverrideInsurers' AS TableName,
    COI.CreatedBy,
    COI.CreatedDate,
    COI.ModifiedBy,
    COI.ModifiedDate,
    COI.RecordDeleted,
    COI.DeletedBy,
    COI.DeletedDate,
     - 1 AS 'ClaimDenialOverrideId' ,
    COI.InsurerId
    FROM ClaimDenialOverrideInsurers COI WHERE COI.ClaimDenialOverrideId = @ClaimDenialOverrideId and ISNULL(COI.RecordDeleted,'N') <> 'Y'
    
			
	-- getting  ClaimDenialOverrideProviderSites 
    select
    TableName,
    ClaimDenialOverrideProviderSiteId,
    CreatedBy,
    CreatedDate,
    ModifiedBy,
    ModifiedDate,
    RecordDeleted,
    DeletedBy,
    DeletedDate,
    ClaimDenialOverrideId,
    ProviderId,
    SiteId
    FROM #ClaimDenialOverrideProviderSites 
    
    --ClaimDenialOverrideInsurers
    SELECT
    TableName,
    ClaimDenialOverrideInsurerId,
    CreatedBy,
    CreatedDate,
    ModifiedBy,
    ModifiedDate,
    RecordDeleted,
    DeletedBy,
    DeletedDate,
    ClaimDenialOverrideId,
    InsurerId
    FROM #ClaimDenialOverrideInsurers 
			
		END
	END
END

IF (@@error != 0)
BEGIN
	RAISERROR 20006 '[SSP_SCInitClaimDenialOverrides] : An Error Occured'

	RETURN
END