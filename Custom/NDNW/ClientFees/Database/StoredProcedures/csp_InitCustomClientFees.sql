IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomClientFees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomClientFees]
GO

CREATE Procedure [dbo].[csp_InitCustomClientFees]  
(                                                      
 @ClientID int,                                
 @StaffID int,                              
 @CustomParameters xml                                                      
)                                                                              
As                                                                                      
/*********************************************************************/                                                                                          
 /* Stored Procedure: [csp_InitCustomClientFees]               */                                                                                 
 /* Creation Date:  10/MAR/2015                                    */                                                                                          
 /* Purpose: To Initialize */                                                                                         
 /* Input Parameters:   @ClientID,@StaffID ,@CustomParameters*/                                                                                        

 /*********************************************************************/       
      
                                                                                           
Begin                            
Begin try      

 SELECT   Placeholder.TableName AS 'TableName',
		'N' AS 'IsInitialize',
		AccountingNotes ,
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
        Suffix
        FROM  (SELECT 'Clients' AS TableName) AS Placeholder      
 LEFT JOIN Clients  
 ON  Clients.ClientId = @ClientID
 AND ISNULL(Clients.RecordDeleted,'N') <> 'Y'
         
 /*SELECT top 1 Placeholder.TableName,
		ISNULL(CSLD.CustomMemberFeeId,-1) AS CustomMemberFeeId,
        CSLD.BeginDate ,
       CSLD.ClientID ,
       CSLD.Comment ,
       CSLD.CreatedBy ,
       CSLD.CreatedDate ,
       CSLD.DeletedBy ,
       CSLD.DeletedDate ,               
       CSLD.EndDate ,
       CSLD.MemberFee ,
       CSLD.ModifiedBy ,
       CSLD.ModifiedDate ,
       CSLD.RecordDeleted 
              
 FROM (SELECT 'CustomMemberFees' AS TableName) AS Placeholder      
 LEFT JOIN CustomMemberFees CSLD ON 
 ( ISNULL(CSLD.RecordDeleted,'N') <> 'Y'  
 AND CSLD.CustomMemberFeeId = -1
 )    */
     
                           
END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_InitCustomClientFees]')                                                                                                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                        
    + '*****' + Convert(varchar,ERROR_STATE())                                                    
 RAISERROR                                                                                                       
 (                                                                         
  @Error, -- Message text.                                                                                                      
  16, -- Severity.                                                                                                      
  1 -- State.                                                                                                      
 );                                                                                                    
END CATCH                                                   
END 