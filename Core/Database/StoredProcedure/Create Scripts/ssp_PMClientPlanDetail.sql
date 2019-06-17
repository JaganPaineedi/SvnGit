/****** Object:  StoredProcedure [dbo].[ssp_PMClientPlanDetail]    Script Date: 12/09/2013 18:46:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMClientPlanDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMClientPlanDetail]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMClientPlanDetail]    Script Date: 12/09/2013 18:46:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[ssp_PMClientPlanDetail] 
 @ClientCovPlanId INT,                                       
 @ClientId INT 
AS

/********************************************************************************                                                  
-- Stored Procedure: ssp_PMClientPlanDetail
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Procedure to return data for the client plan details page.
--
-- Author:  Girish Sanaba
-- Date:    18 May 2011
--
-- *****History****
-- 24 Aug 2011 Girish Removed References to Rowidentifier and/or ExternalReferenceId
-- 27 Aug 2011 Girish Readded References to Rowidentifier
-- 07 Oct 2011 Varun Removed Rowidentifier from 'General'
-- 21 Nov 2011 Msuma Removed * 
-- 27 Jan 2011 - T Remisoski - added two fields from latest data model version to avoid concurrency error
--06  Feb 2012   Rakesh Garg -- Comment the column RowIdentifier as in Copayments table it has been removed 10.679
--24  Sept 2012  AmitSr		 -- Added CMD.CashOnHand,CMD.MonthlyWages in ClientMonthlyDeductibles due to Interact Development Task # 14 (Managing Spend down Reports)
-- 09 Dec 2013      Akwinass.D          Phillhaven Development Task #122 - Plan Detail Changes
--	                                    (Cliam Information Columns included in select query)
-- 24 Dec 2013   Kirtee      --Monthly Deductible History be ordered with the most recent at top WRF Venture Region 3.5 Implementation Task# 451
-- 27 Dec 2013   Kirtee      --Monthly Deductible History be ordered with Month/Year WRF Venture Region 3.5 Implementation Task# 451
-- 05 Jan 2014   Aravind     Added  ProfessionalSuffix,CareTeamMember,MailingName columns in ClientContacts
                             #1727 - Core Bugs
-- 25 June 2015  Akwinass.D   New Columns 'OrganizationClaimAddress1, OrganizationClaimCity, OrganizationClaimState, OrganizationClaimZipCode' Added
								(Philhaven Set Up #21)
-- 10 Oct. 2015  MD Hussain   Added New Columns 'ClaimAddress, ClaimCity, ClaimState, ClaimZipCode' w.r.t Core Bugs #1817
-- 05 Oct  2016  Lakshmi      Added Enable/disable plan logic based on the Authorizations,ClientCoverageHistory,Charges, 
							  task #904 Harbor - Support 
-- 16 Nov 2018  Chita Ranjan  Added Address and PhoneNumber columns to ClientContacts table in the select statement.  
							  This columns are required to display a warning message in 'Client Plans' Details Screen.Task #18 Harbor - Enhancement
*********************************************************************************/


BEGIN

	BEGIN TRY
	--Added by Lakshmi 05/10/2016, #904 Harbor - Support 
	DECLARE @Authorizations CHAR(1)
	DECLARE @ClientCoverageHistory CHAR(1)
	DECLARE @Charges CHAR(1)
	DECLARE @PlanEnableStatus CHAR(1)
	DECLARE @ClientContactAddress VARCHAR(MAX)
	DECLARE @ClientContactPhone VARCHAR(100)
	--Authorizations
	IF NOT EXISTS(SELECT 1 FROM AuthorizationDocuments AD INNER JOIN ClientCoveragePlans CP
	              ON AD.ClientCoveragePlanId=CP.ClientCoveragePlanId
                  WHERE AD.ClientCoveragePlanId=@ClientCovPlanId AND CP.ClientId=@ClientId 
                  AND ISNULL(CP.RecordDeleted,'N')='N' AND ISNULL(AD.RecordDeleted,'N')='N') 
				  BEGIN
			      SET @Authorizations='Y'
				  END
    --ClientCoverageHistory
    IF NOT EXISTS(SELECT 1 FROM ClientCoverageHistory CH INNER JOIN ClientCoveragePlans CP ON 
				  CH.ClientCoveragePlanId=CP.ClientCoveragePlanId WHERE CH.ClientCoveragePlanId=@ClientCovPlanId AND CP.ClientId=@ClientId
				  AND ISNULL(CP.RecordDeleted,'N')='N' AND ISNULL(CH.RecordDeleted,'N')='N')
				  BEGIN
				  SET @ClientCoverageHistory='Y'
				  END
	--Charges
	IF NOT EXISTS(SELECT 1 FROM Services SC INNER JOIN Charges CC ON SC.ServiceId=CC.ServiceId 
                  WHERE SC.ClientId=@ClientId AND CC.ClientCoveragePlanId=@ClientCovPlanId
	              AND ISNULL(SC.RecordDeleted,'N')='N' AND ISNULL(CC.RecordDeleted,'N')='N')
	              BEGIN
	              SET @Charges='Y'
	              END
	IF(@Authorizations='Y' AND @ClientCoverageHistory='Y' AND @Charges='Y')
				  BEGIN
				  SET @PlanEnableStatus='Y'
				  END          
				   
	 SET @ClientContactAddress = (SELECT TOP 1 CCD.Display FROM ClientContacts  CC LEFT JOIN ClientContactAddresses CCD ON CCD.ClientContactId=CC.ClientContactId 
	                             AND ISNULL(CCD.RecordDeleted,'N')='N' WHERE ISNULL(CC.RecordDeleted,'N')='N' AND CC.ClientId = @ClientId )            
	
	 SET @ClientContactPhone = (SELECT TOP 1 CCP.PhoneNumber FROM ClientContacts CC LEFT JOIN ClientContactPhones CCP ON CCP.ClientContactId=CC.ClientContactId  
	                             AND ISNULL(CCP.RecordDeleted,'N')='N' WHERE ISNULL(CC.RecordDeleted,'N')='N' AND CC.ClientId = @ClientId )             
 
	-- General                      
	SELECT [ClientCoveragePlanId]
      ,[ClientId]
      ,[CoveragePlanId]
      ,[InsuredId]					
      ,[GroupNumber]
      ,[GroupName]
      ,[ClientIsSubscriber]
      ,[SubscriberContactId]
      ,[CopayCollectUpfront]
      ,[Deductible]
      ,[ClientHasMonthlyDeductible]
      ,[AuthorizationRequiredOverride]
      ,[NoAuthorizationRequiredOverride]
      ,[PlanContactPhone]
      ,[LastVerified]
      ,[VerifiedBy]
      ,[MedicareSecondaryInsuranceType]
      ,[Comment]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
    
    -- 09 Dec 2013      Akwinass.D          Phillhaven Development Task #122 - Plan Detail Changes
	--	                                    (Cliam Information Columns included in select query)
	,OverrideClaim
	,CoveragePlanName
	,ElectronicClaimsPayerId
	,ElectronicClaimsOfficeNumber
	,AddressDisplay
	,ContactName
	,ContactPhone
	,ContactFax
	,ClaimInformationComment
	,OrganizationName
	,OrganizationContactName
	,OrganizationTelephone
	,OrganizationFax
	,OrganizationClaimAddress
	,OrganizationEmailAddress
	,OrganizationCommentText
	-- 25 June 2015      Akwinass.D 
	,OrganizationClaimAddress1
	,OrganizationClaimCity
	,OrganizationClaimState
	,OrganizationClaimZipCode
	-- Added on 10/29/2015 by MD Hussain
	,ClaimAddress  
	,ClaimCity  
	,ClaimState  
	,ClaimZipCode
	,@PlanEnableStatus AS PlanEnableStatus
	FROM ClientCoveragePlans                     
	WHERE ClientCoveragePlanId=@ClientCovPlanId                    
	 
	SELECT ClientCoverageHistoryId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedDate,
		DeletedBy,
		ClientCoveragePlanId,
		StartDate,
		EndDate,
		COBOrder,
		ServiceAreaId                            
	FROM ClientCoverageHistory                       
	WHERE ClientCoveragePlanId = @ClientCovPlanId 
	AND ISNULL(RecordDeleted,'N') = 'N'
	
	SELECT   CC.ClientContactId
      ,CC.CreatedBy
      ,CC.CreatedDate
      ,CC.ModifiedBy
      ,CC.ModifiedDate
      ,CC.RecordDeleted
      ,CC.DeletedDate
      ,CC.DeletedBy
      ,CC.ListAs
      ,CC.ClientId
      ,CC.Relationship
      ,CC.FirstName
      ,CC.LastName
      ,CC.MiddleName
      ,CC.Prefix
      ,CC.Suffix
      ,CC.FinanciallyResponsible
      ,CC.Organization
      ,CC.SSN
      ,CC.Sex
      ,CC.DOB
      ,CC.Guardian
      ,CC.EmergencyContact
      ,CC.Email
      ,CC.Comment
      ,CC.LastNameSoundex
      ,CC.FirstNameSoundex    
      ,CC.HouseholdMember
      ,CC.Active 
      ,CC.ProfessionalSuffix
      ,CC.CareTeamMember
      ,CC.MailingName  
      ,CC.AssociatedClientId
      ,@ClientContactAddress  AS [Address]             --Chita Ranjan 16/11/2018
      ,@ClientContactPhone  AS PhoneNumber
	FROM ClientContacts CC    
	WHERE ISNULL(CC.RecordDeleted,'N') = 'N' 
	AND CC.ClientId = @ClientId                                            

	--Co-Payments
	SELECT [ClientCopaymentId]
      ,[ClientCoveragePlanId]
      ,[StartDate]
      ,[EndDate]
      ,[ProcedureCap]
      ,[DailyCap]
      ,[WeeklyCap]
      ,[MonthlyCap]
      ,[YearlyCap]
      ,[IncludeOrExcludeProcedures]
      ,[ProcedureGroupName]
      --,[RowIdentifier]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy] 
	FROM ClientCopayments  
	WHERE ClientCoveragePlanId=@ClientCovPlanId               
	                    
	-- ClientMonthlyDeductibles                       
	SELECT CMD.ClientMonthlyDeductibleId
      ,CMD.ClientCoveragePlanId
      ,CMD.DeductibleYear
      ,CMD.DeductibleMonth
      ,CMD.DeductibleMet
      ,CMD.DateMet
      ,CMD.Amount
      ,CMD.VerifiedBy
      ,CMD.VerifiedOn
      ,CMD.Source
      ,CMD.SourceDate
      ,CMD.Comment
      ,CMD.RowIdentifier
      ,CMD.CreatedBy
      ,CMD.CreatedDate
      ,CMD.ModifiedBy
      ,CMD.ModifiedDate
      ,CMD.RecordDeleted
      ,CMD.DeletedDate
      ,CMD.DeletedBy
      ,GC.CodeName AS SourceDisplay,                     
	S.LastName + ', ' + S.FirstName AS VerifiedByName,
	CAST(CMD.DeductibleMonth as varchar) + '/' + CAST(CMD.DeductibleYear as varchar)  AS MonthYear
	,CMD.CashOnHand
	,CMD.MonthlyWages     	          
	FROM ClientMonthlyDeductibles CMD                     
	LEFT JOIN Staff S ON CMD.VerifiedBy = S.StaffId                      
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CMD.[Source]
	WHERE CMD.ClientCoveragePlanId = @ClientCovPlanId                      
	AND ISNULL(CMD.RecordDeleted,'N') = 'N'                    
	ORDER BY CMD.DeductibleYear DESC,CMD.DeductibleMonth DESC                       

	-- For Unique Insured Id                       
	SELECT b.ClientCoveragePlanId, 
	b.CoveragePlanId, 
	b.InsuredId,
	b.ClientId                      
	FROM ClientCoveragePlans a                      
	JOIN ClientCoveragePlans b ON (a.ClientId = b.ClientId)                      
	WHERE a.ClientId = @ClientId                      
	AND ISNULL(b.RecordDeleted,'N') = 'N' 
	
	-- FOr Procedures
	
	select 
		CCP.ClientCopaymentProcedureId
      ,CCP.ClientCopaymentId
      ,CCP.ProcedureCodeId
      ,CCP.RowIdentifier
      ,CCP.CreatedBy
      ,CCP.CreatedDate
      ,CCP.ModifiedBy
      ,CCP.ModifiedDate
      ,CCP.RecordDeleted
      ,CCP.DeletedDate
      ,CCP.DeletedBy
      ,PC.ProcedureCodeName
      ,PC.DisplayAs 
	from ClientCopaymentProcedures CCP join  ProcedureCodes PC on CCP.ProcedureCodeId=PC.ProcedureCodeId               
	where CCP.ClientCopaymentId in (select ClientcopaymentId from ClientCopayments  where ClientCoveragePlanId=@ClientCovPlanId )                 

	SELECT CP.CoveragePlanId,  
		CP.CoveragePlanName,  
		CP.PayerId ,  
	   CCP.InsuredId,  
	   CCP.GroupNumber,  
	   CASE WHEN CCP.ClientIsSubscriber='Y' THEN C.LastName ELSE CC.LastName END AS SubscriberLastName     ,  
	   CASE WHEN CCP.ClientIsSubscriber='Y' THEN C.FirstName ELSE CC.FirstName END AS SubscriberFirstName    ,    
	   CONVERT (varchar(10),CC.DOB,101) as DOB,  
	   CASE WHEN CCP.ClientIsSubscriber='Y' THEN C.Sex ELSE CC.Sex  END AS Sex,  
	   CASE WHEN CCP.ClientIsSubscriber='N' THEN C.LastName ELSE '' END AS DependentLastName,  
	   CASE WHEN CCP.ClientIsSubscriber='N' THEN C.FirstName ELSE '' END AS DependentFirstName,  
	   CASE WHEN CCP.ClientIsSubscriber='N' THEN CONVERT (varchar(10),C.DOB,101) ELSE '' END AS DependentDOB,  
	   CASE WHEN CCP.ClientIsSubscriber='N' THEN C.Sex ELSE '' END AS DependentSex,  
	   GC.ExternalCode1 AS Relationship,
	   CP.ElectronicClaimsPayerId  
	   FROM  
	   ClientCoveragePlans CCP JOIN   
	   CoveragePlans CP   
	   ON CP.CoveragePlanId = CCP.CoveragePlanId   
	   JOIN Clients C ON  
	   C.ClientId = CCP.ClientId  
	   LEFT JOIN  
	   ClientContacts CC ON  
	   CCP.SubscriberContactId = CC.ClientContactId  
	   LEFT JOIN   
	   GlobalCodes GC ON  
	   GC.GlobalCOdeId = CC.Relationship  
	   where CCP.ClientId = @ClientId and   
	   CCP.ClientCoveragePlanId = @ClientCovPlanId 
	
	END TRY
              
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMClientPlanDetail')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH 
	RETURN
END


GO


