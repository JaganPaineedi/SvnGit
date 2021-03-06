IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetClientFees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetClientFees]
GO

CREATE PROCEDURE [dbo].[csp_SCGetClientFees]             
@ClientID int            
as            
/*********************************************************************/                                                                      
/* Stored Procedure: dbo.csp_SCGetClientFees               */                                                                      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                      
/* Creation Date:    10/Mar/2015                                         */                                                                      
/*                                                                   */                                                                      
/* Purpose:  Used in getdata() for ClientFees Detail Page  */                                                                     
/*                                                                   */                                                                    
/* Input Parameters:     @ClientID   */                                                                    
/*                                                                   */                                                                      
/* Output Parameters:   None                */                                                                      
/*                                                                   */                                                                      
                                                                                                                               
/*********************************************************************/                                                                           
BEGIN                                                       
 BEGIN TRY
 
 SELECT  AccountingNotes ,  
        Active ,  
        AnnualHouseholdIncome ,  
        AssignedAdminStaffId ,  
        CareManagementId ,  
        ClientId ,  
        Comment ,  
        CorrectionStatus ,  
        CountyOfResidence ,  
        CountyOfTreatment ,  
        CreatedBy ,  
        CreatedDate ,  
        CurrentBalance ,  
        CurrentEpisodeNumber ,  
        DeceasedOn ,  
        DeletedBy ,  
        DeletedDate ,  
        Disposition ,  
        DOB ,  
        DoesNotSpeakEnglish ,  
        DoNotOverwritePlan ,  
        DoNotSendStatement ,  
        DoNotSendStatementReason ,  
        EducationalStatus ,  
        Email ,  
        EmploymentInformation ,  
        EmploymentStatus ,  
        ExternalClientId ,  
        ExternalReferenceId ,  
        FinanciallyResponsible ,  
        FirstName ,  
        FirstNameSoundex ,  
        HispanicOrigin ,  
        InformationComplete ,  
        InpatientCaseManager ,  
        LastClientStatementId ,  
        LastName ,  
        LastNameSoundex ,  
        LastPaymentId ,  
        LastStatementDate ,  
        LivingArrangement ,  
        MaritalStatus ,  
        MasterRecord ,  
        MiddleName ,  
        MilitaryStatus ,  
        MinimumWage ,  
        MobilePhoneProvider ,  
        ModifiedBy ,  
        ModifiedDate ,  
        MRN ,  
        NoKnownAllergies ,  
        NumberOfBeds ,  
        NumberOfDependents ,  
        Prefix ,  
        PrimaryClinicianId ,  
        PrimaryLanguage ,  
        PrimaryProgramId ,  
        ProviderPrimaryClinicianId ,  
        RecordDeleted ,  
        ReminderPreference ,  
        RowIdentifier ,  
        Sex ,  
        SSN ,  
        Suffix FROM dbo.Clients  
        WHERE ClientID=@ClientID 
 
 DECLARE @ProgramText varchar(max)
    
 SELECT   
	ClientFeeId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	ClientId,
	StartDate,
	EndDate,
	StandardRatePercentage,
	Rate,
	Locations,
	Programs,
	Comment,
	case
        when StandardRatePercentage is not null then convert(varchar(10),StandardRatePercentage) + '%'
        else convert(varchar(20),Rate) end  as 'StandardRatePercentage1',
	dbo.csf_GetProgramnamesById(ISNULL(Programs,'')) as ProgramsText,	
	dbo.csf_GetLocationnamesById(ISNULL(Locations,'')) LocationsText
	
	FROM CustomClientFees
	WHERE ClientID=@ClientID       
 END TRY                                          
 BEGIN CATCH                       
 DECLARE @Error varchar(8000)                                                                        
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_SCGetClientFees]')               
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                                                        
                                                                       
    RAISERROR                                                                         
    (                                                              
  @Error, -- Message text.                                                                        
  16, -- Severity.                                                                        
  1 -- State.                                                                        
    );                                                         
 End CATCH                                                                                                               
                                                   
End
