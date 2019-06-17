/****** Object:  StoredProcedure [dbo].[ssp_GetExternalPrimaryPhysician]    Script Date: 01/08/2012 16:25:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetExternalPrimaryPhysician]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetExternalPrimaryPhysician] --''
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure ssp_GetExternalPrimaryPhysician 
@ExternalReferralProviderId INT 
,@ClientId INT
AS
/************************************************************--*********/                          
/* Stored Procedure: dbo.ssp_GetExternalPrimaryPhysician             */                          
/* Creation Date:  01 August, 2012                                    */                          
/*                                                                   */                          
/* Purpose: get the data from ExternalProviders table .             */                         
/*                                                                   */                        
/* Input Parameters:                                    */                        
/*                                                                   */                          
/* Output Parameters:                                */                          
/*                                                                   */                          
/*                                                                   */                          
/* Called By:  CleintInformation.cs                                                      */                          
/*                                                                   */                          
/* Calls:                                                            */                                                                                                                
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */ 
/*********************************************************************/ 

BEGIN

	BEGIN TRY
	DECLARE @PhysicianContact INT
	DECLARE @ProviderTypeId INT
	SET @ProviderTypeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE Category='PCPROVIDERTYPE' AND (Code = 'Primary Care Physician' OR CodeName = 'Primary Care Physician') AND ISNULL(RecordDeleted, 'N') = 'N')
	SET @PhysicianContact = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE Category='RELATIONSHIP' AND (Code = 'Primary Care Physician' OR CodeName = 'Primary Care Physician') AND ISNULL(RecordDeleted, 'N') = 'N')

	Select 
		ERP.ExternalReferralProviderId, 
		ERP.CreatedBy, 
		ERP.CreatedDate,
		ERP.ModifiedBy, 
		ERP.ModifiedDate, 
		ERP.RecordDeleted, 
		ERP.DeletedDate, 
		ERP.DeletedBy, 
		ERP.Type, 
		ERP.Name, 
		ERP.Address, 
		ERP.City, 
		ERP.State, 
		ERP.ZipCode, 
		ERP.PhoneNumber, 
		ERP.Fax, 
		ERP.Email, 
		ERP.Website, 
		ERP.Active, 
		ERP.DataEntryComplete,
		S.StateAbbreviation AS StateName  
		,ERP.OrganizationName
		/*  08 May 2015   Venkatesh MR */
		,ERP.LastName
		,ERP.FirstName
		,ERP.Address2
		,ERP.Suffix
		,CASE WHEN ISNull(ERP.FirstName,'')='' then ERP.Name ELSE ISNULL(ERP.LastName, '') + ', ' + ISNULL(ERP.FirstName,ERP.Name) END PhysicianName
	FROM ExternalReferralProviders  ERP
	LEFT JOIN states S ON S.stateFIPS=  ERP.state  
	WHERE (ERP.ExternalReferralProviderId = 0 OR 0 =0) AND ISNULL(ERP.RecordDeleted,'N')='N' AND ERP.Type=@ProviderTypeId 

 UNION 
	SELECT 
		 cc.ClientContactId as ExternalReferralProviderId 
		,CC.CreatedBy as CreatedBy, 
		  CC.CreatedDate as CreatedDate,
		 CC.ModifiedBy as ModifiedBy, 
		 CC.ModifiedDate as ModifiedBy, 
		 CC.RecordDeleted as ModifiedBy, 
		 CC.DeletedDate as ModifiedBy, 
		 CC.DeletedBy as ModifiedBy,
		'' as Type, 
		'' as Name, 
		'' as Address, 
		'' as City, 
		'' as State, 
		'' as ZipCode, 
		CCP.PhoneNumber as PhoneNumber, 
		' ' as Fax, 
		CC.Email as Email, 
		'' as Website, 
		CC.Active as Active, 
		'' as DataEntryComplete,
		'' AS StateName,  
		CC.Organization as Organization,
		/*  08 May 2015   Venkatesh MR */
		'' as LastName,
		''  as FirstName,
		'' as Address2,
		'' as Suffix
		,CC.LastName + ', ' + CC.FirstName as PhysicianName    
    From ClientContacts  CC
    LEFT JOIN  ClientContactPhones CCP ON CC.ClientContactId=CCP.ClientContactId AND CCP.PhoneType=30
    WHERE CC.ClientId=@ClientId AND ISNULL(CC.RecordDeleted,'N')='N' AND ISNULL(CCP.RecordDeleted,'N')='N'
    AND CC.Relationship=@PhysicianContact
    

END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetExternalPrimaryPhysician')                                                                                             
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










