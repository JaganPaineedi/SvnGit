/****** Object:  StoredProcedure [dbo].[ssp_CMGetProviderCredentials]    Script Date: 09/01/2014 13:08:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetProviderCredentials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetProviderCredentials]
GO



/****** Object:  StoredProcedure [dbo].[ssp_CMGetProviderCredentials]    Script Date: 09/01/2014 13:08:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE  Procedure [dbo].[ssp_CMGetProviderCredentials]             
(                      
 @ProviderId		int,
 @CredentialingId	int                     
)
/*******************************************************************************************************************************
**	Copyright: 2005 Provider Claim Management System
**	Stored Procedure		:
**	Creation Date			:	26 May 2014
**	Author					:	Rohith Uppin
**	Purpose:				:	To get data of Credentialing
**	Input Parameters		:	@ProviderId, @CredentialingId
**	Data Modifications		:
**
**	Date			Author					Purpose
**	5/12/2014       Venkatesh MR            For task #19 in SWMBH-Enhancement - Changes is to get the data from CredentialingSpecialty,
											CredentialingHospitals,CredentialingEducations as per new requirement.
**  03/06/2016      Shruthi.S               Added new tables "CredentialingSites", "CredentialingCulturalConsiderations", 
                                           "CredentialingAgeGroupServed", "CredentialingLanguages" 
                                            for multi select dropdowns in General section.Ref : #401 AspenPointe-Customizations.											
*******************************************************************************************************************************/
As			
		---Credentialing Information
  BEGIN 
      BEGIN TRY 
          SELECT C.CredentialingId,
				 C.CreatedBy,
                 C.CreatedDate,
                 C.ModifiedBy,
                 C.ModifiedDate,
                 C.DeletedBy,
                 C.DeletedDate,
                 C.RecordDeleted, 
                 C.CredentialingType, 
                 C.Status, 
                 c.EffectiveFrom, 
                 c.ExpirationDate, 
                 C.CredentialApproachingExpiration, 
                 C.PerformedBy, 
                 C.Share, 
                 C.ApplicationSent, 
                 C.ApplicationReceived, 
                 C.DocumentationComplete, 
                 C.DateApproved, 
                 C.NoticeToProvider, 
                 C.EventNote, 
                 C.AccreditationNote, 
                 C.Comment, 
                 C.LiabilityStartDate, 
                 C.LiabilityEndDate, 
                 C.LiabilityInsurance, 
                 C.ProviderId, 
                 C.SiteId,                 
                 Case 
					 WHEN C.SiteId IS NULL THEN 'N'
					 ELSE 'Y' END
                  as ProviderSite,
                  -- Added below columns by venkatesh for task #19 in SWMBH-Enhancement
                 C.GeneralDOB,
				 C.GeneralDualsProvider,
				 C.GeneralSex,
				 C.EducationComments,
				 C.SpecialityComments,
				 C.HospitalComments
          FROM   CREDENTIALING C 
                 INNER JOIN PROVIDERS P ON c.PROVIDERID = P.PROVIDERID 
                 LEFT JOIN GLOBALCODES GC ON c.CREDENTIALINGTYPE = GC.GLOBALCODEID 
                 LEFT JOIN GLOBALCODES GC1 ON c.STATUS = GC1.GLOBALCODEID 
                 LEFT JOIN SITES S ON c.SITEID = S.SITEID 
          WHERE  c.PROVIDERID = @ProviderId  AND Isnull(c.RECORDDELETED, 'N') = 'N' 
                 AND C.CREDENTIALINGID = @CredentialingId 


    --Accreditation Information 
          SELECT CA.[CredentailingAccreditationId],
				 CA.CreatedBy,
                 CA.CreatedDate,
                 CA.ModifiedBy,
                 CA.ModifiedDate,
                 CA.DeletedBy,
                 CA.DeletedDate,
                 CA.RecordDeleted, 
                 CA.[CredentialingId], 
                 CA.[AccreditationType], 
                 CA.[AccreditationExpirationDate], 
                 AccreditationVerificationDate, -- Added by venkatesh for task #19 in SWMBH-Enhancement
                 CA.RowIdentifier,
                 GCS.CODENAME AS AccreditationTypeText                
          FROM   CREDENTAILINGACCREDITATION CA 
					INNER JOIN GLOBALCODES GCS ON GCS.GLOBALCODEID = ca.ACCREDITATIONTYPE 
          WHERE  CREDENTIALINGID = @CredentialingId             


    ---CredentialingLicense Information                       
          SELECT [CREDENTIALINGLICENSEID],
				 CL.CreatedBy,
                 CL.CreatedDate,
                 CL.ModifiedBy,
                 CL.ModifiedDate,
                 CL.DeletedBy,
                 CL.DeletedDate,
                 CL.RecordDeleted,  
                 [CREDENTIALINGID], 
                 [LICENSETYPE], 
                 [LICENSENUMBER], 
                 [LICENSEEXPIRATIONDATE], 
                 [SOURCEVERIFIED],
                 LicenseVerificationDate,          -- Added by venkatesh for task #19 in SWMBH-Enhancement
				 CL.RowIdentifier,				
                 GBC.CODENAME as [LICENSETYPETEXT]
          FROM   CREDENTIALINGLICENSE CL 
					INNER JOIN GLOBALCODES GBC ON GBC.GLOBALCODEID = CL.LICENSETYPE
          WHERE  CREDENTIALINGID = @CredentialingId
          
          
      
      ---CredentialingProviderBillingCodes
          SELECT	C.CredentialingProviderBillingCodeId
					,C.ProviderId
					,C.BillingCodeId,
					 C.CreatedBy,
					 C.CreatedDate,
					 C.ModifiedBy,
					 C.ModifiedDate,
					 C.DeletedBy,
					 C.DeletedDate,
					 C.RecordDeleted,
					 C.FromDate,
					 C.ToDate,
					 C.AnyModifier,
					 C.Modifier1,
					 C.Modifier2,
					 C.Modifier3,
					 C.Modifier4,
					 BC.BillingCode as BillingCodeIdText
			FROM	CredentialingProviderBillingCodes C
					INNER JOIN BillingCodes BC ON   BC.BillingCodeId = C.BillingCodeId        
			WHERE	ISNULL(C.RecordDeleted,'N')<>'Y'          
					AND C.ProviderId = @ProviderId
         -- Added below script by venkatesh for task #19 in SWMBH-Enhancement
            ---CredentialingEducations Information                       
          SELECT CredentialingEducationId,
				CE.CreatedBy,
				CE.CreatedDate,
				CE.ModifiedBy,
				CE.ModifiedDate,
				CE.RecordDeleted,
				CE.DeletedBy,
				CE.DeletedDate,
				CE.CredentialingId,
				CE.DegreeType,
				CE.DegreeDate, 
                GBC.CODENAME as [DegreeTypeText]
          FROM   CredentialingEducations CE 
					INNER JOIN GLOBALCODES GBC ON GBC.GLOBALCODEID = CE.DegreeType
          WHERE  CREDENTIALINGID = @CredentialingId
          
          ---CredentialingSpecialty Information                       
          SELECT CredentialingSpecialtyId,
				CS.CreatedBy,
				CS.CreatedDate,
				CS.ModifiedBy,
				CS.ModifiedDate,
				CS.RecordDeleted,
				CS.DeletedBy,
				CS.DeletedDate,
				CS.CredentialingId,
				CS.Specialty,
				CS.ExpirationDate, 
                 GBC.CODENAME as [SpecialtyText]
          FROM   CredentialingSpecialty CS 
					INNER JOIN GLOBALCODES GBC ON GBC.GLOBALCODEID = CS.Specialty
          WHERE  CREDENTIALINGID = @CredentialingId
          
          ---CredentialingHospitals Information                       
          SELECT CredentialingHospitalId,
				CH.CreatedBy,
				CH.CreatedDate,
				CH.ModifiedBy,
				CH.ModifiedDate,
				CH.RecordDeleted,
				CH.DeletedBy,
				CH.DeletedDate,
				CH.Hospital,
				CH.CredentialingId,
				CH.ExpirationDate, 
                 GBC.CODENAME as [HospitalText]
          FROM   CredentialingHospitals CH 
					INNER JOIN GLOBALCODES GBC ON GBC.GLOBALCODEID = CH.Hospital
          WHERE  CREDENTIALINGID = @CredentialingId
          
          ---Sites dropdown data-----------
          
          SELECT    CR.CredentialingSiteId,
					CR.CreatedBy,
					CR.CreatedDate,
					CR.ModifiedBy,
					CR.ModifiedDate,
					CR.RecordDeleted,
					CR.DeletedBy,
					CR.DeletedDate,
					CR.CredentialingId,
					CR.SiteInformation
          FROM      CredentialingSites CR
          WHERE CR.CREDENTIALINGID = @CredentialingId and ISNULL(CR.RecordDeleted,'N')<>'Y'    
          
          --Cultural Considerations dropdown data-----------
          
          SELECT    CC.CredentialingCulturalConsiderationId,
					CC.CreatedBy,
					CC.CreatedDate,
					CC.ModifiedBy,
					CC.ModifiedDate,
					CC.RecordDeleted,
					CC.DeletedBy,
					CC.DeletedDate,
					CC.CredentialingId,
					CC.CulturalConsiderations
          FROM CredentialingCulturalConsiderations CC
          WHERE CC.CREDENTIALINGID = @CredentialingId and ISNULL(CC.RecordDeleted,'N')<>'Y' 
          
          --Age Group Served dropdown data-----------
          
          SELECT    CA.CredentialingAgeGroupServedId,
					CA.CreatedBy,
					CA.CreatedDate,
					CA.ModifiedBy,
					CA.ModifiedDate,
					CA.RecordDeleted,
					CA.DeletedBy,
					CA.DeletedDate,
					CA.CredentialingId,
					CA.AgeGroupServed
          FROM CredentialingAgeGroupServed CA 
          WHERE CA.CREDENTIALINGID = @CredentialingId and ISNULL(CA.RecordDeleted,'N')<>'Y'
          
          --Languages dropdown data-----------
          
          SELECT    CL.CredentialingLanguageId,
					CL.CreatedBy,
					CL.CreatedDate,
					CL.ModifiedBy,
					CL.ModifiedDate,
					CL.RecordDeleted,
					CL.DeletedBy,
					CL.DeletedDate,
					CL.CredentialingId,
					CL.CredentialLanguage
          FROM CredentialingLanguages CL
          WHERE CL.CREDENTIALINGID = @CredentialingId and ISNULL(CL.RecordDeleted,'N')<>'Y'
          
          
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), '[ssp_CMGetProviderCredentials]')+ '*****'
                      +CONVERT(VARCHAR, Error_line()) + '*****ERROR_SEVERITY=' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****ERROR_STATE=' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error /* Message text*/,
						16 /*Severity*/,
						1/*State*/ 
					) 
      END CATCH 
      
  END 


GO


