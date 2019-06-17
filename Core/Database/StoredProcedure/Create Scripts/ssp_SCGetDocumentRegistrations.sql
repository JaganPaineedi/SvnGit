/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentRegistrations]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDocumentRegistrations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDocumentRegistrations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentRegistrations]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                                
**  File: ssp_SCGetDocumentRegistrations	4169                                          
**  Name: ssp_SCGetDocumentRegistrations                        
**  Desc: To Get Document Registrations                                                  
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Alok Kumar                              
**  Date:  January 12 2018
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */ 
--*******************************************************************************/                                   
CREATE PROCEDURE  [dbo].[ssp_SCGetDocumentRegistrations]                                                                   
(                                                                                                                                                           
  @DocumentVersionId int                                                                           
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY   

	DECLARE @ClientID INT 
	SET @ClientID = (SELECT Top 1 ClientId 
                   FROM   Documents 
                   WHERE  InProgressDocumentVersionId = @DocumentVersionId)

	DECLARE @DOB datetime
	SET @DOB = (Select top 1 DOB
				FROM   DocumentRegistrationDemographics 
                WHERE  DocumentVersionId = @DocumentVersionId)
                
                
                
                
		--ClientCoveragePlans 
		DECLARE @InsuredId varchar(25)
		SET @InsuredId = ( Select top (1) a.InsuredId  
							from    ClientCoveragePlans as a    
							inner join CoveragePlans as b on b.CoveragePlanId = a.CoveragePlanId    
							inner join ClientCoverageHistory as c on a.ClientCoveragePlanId = c.ClientCoveragePlanId    
							where   a.ClientId = @ClientId    
									and b.MedicaidPlan = 'Y'    
									and ISNULL(a.RecordDeleted, 'N') <> 'Y'    
									and ISNULL(b.RecordDeleted, 'N') <> 'Y'    
									and ISNULL(c.RecordDeleted, 'N') <> 'Y'    
									and DATEDIFF(DAY, c.StartDate, GETDATE()) >= 0    
									and (    
										 (c.EndDate is null)    
									or (DATEDIFF(DAY, c.EndDate, GETDATE()) <= 0)    
										)    
							order by c.COBOrder     )
                
                
                
	DECLARE @PhysicianContact INT
	DECLARE @ProviderTypeId INT
	SET @ProviderTypeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE Category='PCPROVIDERTYPE' AND (Code = 'Primary Care Physician' OR CodeName = 'Primary Care Physician') AND ISNULL(RecordDeleted, 'N') = 'N')
	SET @PhysicianContact = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE Category='RELATIONSHIP' AND (Code = 'Primary Care Physician' OR CodeName = 'Primary Care Physician') AND ISNULL(RecordDeleted, 'N') = 'N')
                

	--DocumentRegistrations                  
	SELECT DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,ClientId
		,PrimaryClinicianId
		,PrimaryPhysicianId
		,ClientType
		,SSN
		,Prefix
		,FirstName
		,MiddleName
		,LastName
		,Suffix
		,Email
		,Active
		,ProfessionalSuffix
		,EIN
		,OrganizationName
		,CoverageInformation
		,SUBSTRING(SSN, 6, 9) AS ShortSSN
		,SUBSTRING(EIN, 6, 9) AS ShortEIN
		,Comment
		,@DOB AS DOB
		,@InsuredId AS InsuredId
	FROM DocumentRegistrations
	WHERE (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)

		
		
	--DocumentRegistrationDemographics                  
	SELECT DRD.DocumentVersionId
		,DRD.CreatedBy
		,DRD.CreatedDate
		,DRD.ModifiedBy
		,DRD.ModifiedDate
		,DRD.RecordDeleted
		,DRD.DeletedBy
		,DRD.DeletedDate
		,DRD.DOB
		,DRD.Comment
		,DRD.Sex
		,DRD.MaritalStatus
		,DRD.GenderIdentity
		,DRD.SexualOrientation
		,DRD.DeceasedOn
		,DRD.CauseofDeath
		,DRD.FinanciallyResponsible
		,AnnualHouseholdIncome
		,DRD.NumberOfDependents
		,DRD.LivingArrangement
		,DRD.CountyOfResidence
		,DRD.CountyOfTreatment
		,DRD.EducationalStatus
		,DRD.MilitaryStatus
		,DRD.EmploymentStatus
		,DRD.EmploymentInformation
		,DRD.PrimaryLanguage
		,DRD.DoesNotSpeakEnglish
		,DRD.HispanicOrigin
		,DRD.ReminderPreference
		,DRD.MobilePhoneProvider
		,DRD.SchedulingPreferenceMonday
		,DRD.SchedulingPreferenceTuesday
		,DRD.SchedulingPreferenceWednesday
		,DRD.SchedulingPreferenceThursday
		,DRD.SchedulingPreferenceFriday
		,DRD.GeographicLocation
		,DRD.SchedulingComment
		,CONVERT(varchar(5), DATEDIFF(YEAR, DRD.DOB, GETDATE()) - 1) + ' Years' AS Age
		,LTRIM(RTRIM(Ct.CountyName)) + ' - ' + St.StateAbbreviation AS CountyOfResidenceText
		,LTRIM(RTRIM(CF.CountyName)) + ' - ' + Ss.StateAbbreviation AS CountyOfTreatmentText
		,DRD.ExternalReferralProviderId
		,DRD.ClientDoesNotHavePCP
		,Erp.OrganizationName AS PCPOrganizationName
		,Erp.PhoneNumber AS PCPPhone
		,Erp.Email AS PCPEmail
		,DRD.PreferredGenderPronoun
	FROM DocumentRegistrationDemographics DRD
	LEFT JOIN Counties Ct
	  ON Ct.CountyFIPS = DRD.CountyOfResidence
	LEFT JOIN Counties CF
	  ON CF.CountyFIPS = DRD.CountyOfTreatment
	LEFT JOIN States St
	  ON St.StateFIPs = Ct.StateFIPs
	LEFT JOIN States Ss
	  ON Ss.StateFIPs = CF.StateFIPs
	LEFT JOIN ExternalReferralProviders Erp
	  ON Erp.ExternalReferralProviderId = DRD.ExternalReferralProviderId AND ISNULL(Erp.RecordDeleted, 'N') = 'N' 
	  AND Erp.[Type] IN (@PhysicianContact,@ProviderTypeId)
	WHERE (ISNULL(DRD.RecordDeleted, 'N') = 'N') AND (DRD.DocumentVersionId = @DocumentVersionId)
	
		
		
		
		
	--DocumentRegistrationAdditionalInformations                  
	SELECT DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,Citizenship
		,EmploymentStatus
		,BirthPlace
		,BirthCertificate
		,MilitaryStatus
		,EducationalLevel
		,JusticeSystemInvolvement
		,EducationStatus
		,NumberOfArrestsLast30Days
		,Religion
		,SmokingStatus
		,ForensicTreatment
		,CriminogenicRiskLevel
		,ScreenForMHSUD
		,AdvanceDirective
		,LivingArrangments
		,SSISSDStatus
	FROM DocumentRegistrationAdditionalInformations
	WHERE (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)
		
		
		
		
	--DocumentRegistrationEpisodes                  
	SELECT DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,Disposition
		,ReferralScreeningDate
		--,UrgencyLevel
		,ReferralReason1
		,ReferralReason2
		,ReferralReason3
		,ReferralComment
		,ProviderType
		,ExternalReferralProviderId
		,RegistrationDate
		,Information
		,ReferralDate
		,ReferralType
		,ReferralSubtype
		,ReferralOrganization
		,ReferrralPhone
		,ReferrralFirstName
		,ReferrralLastName
		,ReferrralAddress1
		,ReferrralAddress2
		,ReferrralCity
		,ReferrralState
		,ReferrralZipCode
		,ReferrralEmail
		,ReferrralComment
		,RegistrationComment
	FROM DocumentRegistrationEpisodes
	WHERE (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)
	
	
	
	--DocumentRegistrationProgramEnrollments                  
	SELECT DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,PrimaryProgramId
		,AssignedStaffId
		,ProgramStatus
		,ProgramRequestedDate
		,ProgramEnrolledDate
		,Comment
	FROM DocumentRegistrationProgramEnrollments
	WHERE (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)
	
	
	
	
	
	--DocumentRegistrationDemographicDeclines                  
	SELECT DocumentRegistrationDemographicDeclineId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,ClientDeclinedToProvide
		--,@ClientID AS ClientID
	FROM DocumentRegistrationDemographicDeclines
	WHERE (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)
	
	
	
	
	--DocumentRegistrationClientEthnicities                  
	SELECT DocumentRegistrationClientEthnicityId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,EthnicityId
		--,@ClientID AS ClientID
	FROM DocumentRegistrationClientEthnicities
	WHERE (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)
	
	
	
	
	--DocumentRegistrationClientRaces                  
	SELECT DocumentRegistrationClientRaceId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,RaceId
		--,@ClientID AS ClientID
	FROM DocumentRegistrationClientRaces
	WHERE (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)
	
	
	
	--DocumentRegistrationClientPictures                  
	SELECT DRCP.DocumentRegistrationClientPictureId
		,DRCP.CreatedBy
		,DRCP.CreatedDate
		,DRCP.ModifiedBy
		,DRCP.ModifiedDate
		,DRCP.RecordDeleted
		,DRCP.DeletedBy
		,DRCP.DeletedDate
		,DRCP.DocumentVersionId
		,DRCP.UploadedBy
		,DRCP.UploadedOn
		,DRCP.PictureFileName
		,DRCP.Picture
		,DRCP.Active
		,CONVERT(VARCHAR(10), DRCP.[UploadedOn], 101) AS UploadedOnText  
		,(S.LastName  + ', ' + S.FirstName ) AS UploadedByText 
	FROM DocumentRegistrationClientPictures DRCP
	left Join Staff S ON S.StaffId  = DRCP.UploadedBy
	WHERE (ISNULL(DRCP.RecordDeleted, 'N') = 'N') AND (DRCP.DocumentVersionId = @DocumentVersionId) AND ISNULL(DRCP.Active, 'N') = 'Y'
		


		
	--DocumentRegistrationClientPhones
	SELECT
	  RCP.DocumentRegistrationClientPhoneId,
	  RCP.ClientId,
	  RCP.PhoneType,
	  RCP.PhoneNumber,
	  RCP.PhoneNumberText,
	  RCP.IsPrimary,
	  RCP.DoNotContact,
	  RCP.ExternalReferenceId,
	  RCP.CreatedBy,
	  RCP.CreatedDate,
	  RCP.ModifiedBy,
	  RCP.ModifiedDate,
	  RCP.RecordDeleted,
	  RCP.DeletedDate,
	  RCP.DeletedBy,
	  GC.SortOrder,
	  RCP.DoNotLeaveMessage,
	  DocumentVersionId                                           
	FROM DocumentRegistrationClientPhones RCP
	INNER JOIN GlobalCodes GC
	  ON RCP.PhoneType = GC.GlobalCodeId
	WHERE (RCP.ClientId = @ClientID) AND (RCP.DocumentVersionId = @DocumentVersionId)
	AND (ISNULL(RCP.RecordDeleted, 'N') = 'N')
	AND (GC.Active = 'Y')
	AND (ISNULL(GC.RecordDeleted, 'N') = 'N')
		
		
		
	--DocumentRegistrationClientAddresses                         
	SELECT
	  RCA.DocumentRegistrationClientAddressId,
	  RCA.ClientId,
	  RCA.AddressType,
	  RCA.ClientAddress,	--Address
	  RCA.City,
	  RCA.ClientState,		--State
	  RCA.Zip,
	  RCA.Display,
	  RCA.Billing,
	  --RCA..RowIdentifier,
	  RCA.ExternalReferenceId,
	  RCA.CreatedBy,
	  RCA.CreatedDate,
	  RCA.ModifiedBy,
	  RCA.ModifiedDate,
	  RCA.RecordDeleted,
	  RCA.DeletedDate,
	  RCA.DeletedBy,
	  GC.SortOrder,
	  DocumentVersionId
	FROM DocumentRegistrationClientAddresses RCA
	INNER JOIN GlobalCodes GC
	  ON RCA.AddressType = GC.GlobalCodeId
	WHERE (RCA.ClientId = @ClientID) AND (RCA.DocumentVersionId = @DocumentVersionId)
	AND (ISNULL(RCA.RecordDeleted, 'N') = 'N')
	AND (GC.Active = 'Y')
	AND (ISNULL(GC.RecordDeleted, 'N') = 'N')
	
	
	
	
	--DocumentRegistrationCoverageInformations                  
	SELECT DocumentRegistrationCoverageInformationId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,CoveragePlanId
		,InsuredId
		,GroupId
		,Comment
		,NewlyAddedPlan
	FROM DocumentRegistrationCoverageInformations
	WHERE (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)
	
	
	
	
	--ClientContacts
	SELECT
	  'ClientContacts' AS TableName,
	  CC.CreatedBy,
	  CC.CreatedDate,
	  CC.ModifiedBy,
	  CC.ModifiedDate,
	  CC.ClientContactId,
	  CC.RecordDeleted,
	  CC.DeletedBy,
	  CC.DeletedDate,
	  CC.ListAs,
	  GC.CodeName AS RelationshipText,
	  ( SELECT TOP ( 1 )
					PhoneNumber
		  FROM      ClientContactPhones
		  WHERE     ( ClientContactId = CC.ClientContactId )
					AND ( PhoneNumber IS NOT NULL )
					AND ( ISNULL(RecordDeleted, 'N') = 'N' )
		  ORDER BY  PhoneType
		) AS Phone ,
	  CC.Organization,
	  CC.Guardian AS GuardianText,
	  CC.EmergencyContact AS EmergencyText,
	  CC.FinanciallyResponsible AS FinResponsibleText,
	  CC.HouseholdMember AS HouseholdnumberText,
	  CC.Active AS Active
	FROM ClientContacts CC
	INNER JOIN GlobalCodes GC
	  ON GC.GlobalCodeId = CC.Relationship
	  AND ISNULL(GC.RecordDeleted, 'N') <> 'Y'
	  AND GC.Category = 'RELATIONSHIP'
	WHERE (ISNULL(CC.RecordDeleted, 'N') <> 'Y')
	AND (CC.ClientId = @ClientID)

	
	
		
	--CustomDocumentRegistrations                  
	SELECT DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
	FROM CustomDocumentRegistrations
	WHERE (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)	
	
	
	EXEC ssp_SCGetFormsAndAgreementsData @ClientID, @DocumentVersionId

		
 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetDocumentRegistrations]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO


