/****** Object:  StoredProcedure [dbo].[csp_PAInitVenturePreScreen]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAInitVenturePreScreen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PAInitVenturePreScreen]
GO


/****** Object:  StoredProcedure [dbo].[csp_PAInitVenturePreScreen]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


                        
Create PROCEDURE  [dbo].[csp_PAInitVenturePreScreen]                                
(                                                          
 @ClientID int,                                    
 @StaffID int,                                  
 @CustomParameters xml                                                          
)                                                                                  
As                                                                                          
 /*********************************************************************/                                                                                              
 /* Stored Procedure: [csp_PAInitVenturePreScreen]               */                                                                                     
                                                                                     
 /* Copyright: 2006 Streamline SmartCare*/                                                                                              
                                                                                     
 /* Creation Date:  26/Feb/2010                                    */                                                                                              
 /*                                                                   */                                                                                              
 /* Purpose: To Initialize */                                                                                             
 /*                                                                   */                                                                                            
 /* Input Parameters:  */                                                                                            
 /*                                                                   */                                                                                               
 /* Output Parameters:                                */                                                                                              
 /*                                                                   */                                                                                              
 /* Return:   */                                                                                              
 /*                                                                   */                                                                                              
 /* Called By:CustomDocuments Class Of DataService    */                                                                                    
 /*      */                                                                                    
                                                                                     
 /*                                                                   */                                                                                              
 /* Calls:                                                            */                                                                                              
 /*                                                                   */                                                                                              
 /* Data Modifications:                                               */                                                                                              
 /*                                                                   */                                                                                              
 /*   Updates:                                                          */                                                                                              
       
 /*  Date				Author                   Purpose                                    */                                                                   
 /*  Feb 26 -2010		Priya					To Retrieve Data             */
 /*  17 July 2010		Jitender Kumar Kamboj	Commented  ICDCode columns in DiagnosesIII table  */
 /*  01 April 2011		Rakesh					Change Columns Name RiskSelfPreviousSelfHarmOutcome  to RiskSelfPreviousSelfHarmOutcomes as datamodel changes  */                                                                												   
 /*  10 Nov 2011		Sourabh					Commented DiagnosesIAndII table because not initialized for task#455*/													
 /*  17 April 2012      Rakesh Garg				Changes made w.rf to task 135 in General Implemenation for Kalamazoo  
	 3/Aug/2012			Mamta Gupta				Ref Task No. 1877 - Kalamazoo Bugs - Go Live - CustomAcuteServicesPrescreens table columns commented as
												accoding to 1877 task they need only Ethnicity,Gender,CMH case number, DOB, Social Security Number, Address
												County of Residence, Home Telephone, Emergency Contact, Relationship Phone, Name of Guardian/Responsible Adult Phone
 */                  
 /*********************************************************************/                               
Begin                              
Begin try       
  
declare @LatestDocumentVersionID int            
set @LatestDocumentVersionID =(select top 1 CurrentDocumentVersionId                                  
from Documents a                                                      
where a.ClientId = @ClientID                                                      
and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                      
and a.Status = 22                  
and a.DocumentCodeId=5                                                       
and isNull(a.RecordDeleted,'N')<>'Y'                                                                                         
order by a.EffectiveDate desc,a.ModifiedDate desc ) 


-- Intialiaze from assessment the health history information
Declare @LastAssessmentDocumentVersionId as int
Declare @PreviousHealthConcerns as varchar(max)

Set @LastAssessmentDocumentVersionId = (Select top 1 CurrentDocumentVersionId from Documents where ClientId = @ClientID 
and DocumentCodeId = 1469 and ISNULL(RecordDeleted,'N') = 'N' and Status = 22  -- 22 Status is for signed 
and EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))
order by EffectiveDate desc,ModifiedDate desc)
Set @PreviousHealthConcerns = (Select top 1 c.PsCurrentHealthIssuesComment from CustomHRMAssessments c 
where  DocumentVersionId =  @LastAssessmentDocumentVersionId)

--Changes end here



 --If previous Prescreen document exists then intialize from previous Prescreen document.                                                                                                                                                                 
if(exists(Select C.DocumentVersionId from CustomAcuteServicesPrescreens C,Documents D ,                                  
 DocumentVersions V                                     
    where C.DocumentVersionId=V.DocumentVersionId and D.DocumentId = V.DocumentId                                  
     and D.ClientId=@ClientID                                                                  
and D.Status=22 and IsNull(C.RecordDeleted,'N')='N' and IsNull(D.RecordDeleted,'N')='N' ))                                                              
BEGIN        
--3/Aug/2012 - Mamta Gupta - Ref Task No. 1877 - Kalamazoo Bugs - Go Live                                     
Select TOP 1 'CustomAcuteServicesPrescreens' AS TableName                                   
      ,C.DocumentVersionId
   --   ,[DateOfPrescreen]                      
   --   ,[InitialCallTime]                      
   --   ,[ClientAvailableTimeForScreen]                      
   --   ,[DispositionTime]                      
   --   ,[ElapsedHours]                      
   --   ,[ElapsedMinutes]                      
   --   ,[CMHStatus]                      
   --   ,[CMHStatusPrimaryClinician]                      
      ,[CMHCaseNumber]                      
   --   ,[ClientName]                      
      ,[ClientEthnicity]                      
      ,[ClientSex]                      
   --   ,[ClientMaritalStatus]                      
      ,[ClientSSN]                      
      ,[ClientDateOfBirth]                      
      ,[ClientAddress]                      
   --   ,[ClientCity]                      
   --   ,[ClientState]                      
   --   ,[ClientZip]                      
      ,[ClientCounty]                      
      ,[ClientHomePhone]                      
      ,[ClientEmergencyContact]                      
   --   ,[ClientRelationship]                      
      ,[ClientEmergencyPhone]                      
      ,[ClientGuardianName]                      
      ,[ClientGuardianPhone]                
   
      ,Isnull(@PreviousHealthConcerns,[HHCurrentHealthConcerns]) as [HHPreviousHealthConcerns] -- Added by Rakesh w.rf to task 135 in General Implementation as always pulls information from  last Assessment                       
                           
      ,C.[RowIdentifier]                      
      ,C.[CreatedBy]                      
      ,C.[CreatedDate]                      
      ,C.[ModifiedBy]                      
      ,C.[ModifiedDate]                      
      ,C.[RecordDeleted]                      
      ,C.[DeletedDate]                      
      ,C.[DeletedBy]                                      
  FROM [CustomAcuteServicesPrescreens]                                  
  C,Documents D,                                  
  DocumentVersions V                                          
  where C.DocumentVersionId=V.DocumentVersionId and V.DocumentId=D.DocumentId                                   
  and D.ClientId=@ClientID                                  
  and D.Status=22  and IsNull(C.RecordDeleted,'N')='N' and IsNull(D.RecordDeleted,'N')='N'                                                               
  order by D.EffectiveDate Desc,D.ModifiedDate Desc         

 
                                         
END                                   
                                                             
ELSE                                                              
BEGIN 

--Added by Rakesh w.rf to task 135 in General Implemenation for Kalamazoo Intialization Inquiry - Disposition text for Prescreen - Service Requested by Consumer
declare @DispostionComment as varchar(max)
Set @DispostionComment = (Select top 1 CI.DispositionComment from CustomInquiries CI
left join GlobalCodes gc on  CI.InquiryStatus = gc.GlobalCodeId
 where CI.ClientId = @ClientID and ISNULL( CI.RecordDeleted,'N') = 'N'
 and gc.Category = 'XINQUIRYSTATUS' and gc.CodeName = 'COMPLETE' order by InquiryId asc)   --Get DispositionComment For Last Completed Inquiry 
 

-- Get last 12 monthis client hostpitalizaion Count
declare @HospitalizationNumber as int
declare @LastHospitalizationDate as datetime
Set @HospitalizationNumber = (Select Count(HospitalizationId) from ClientHospitalizations where ClientId = @ClientID 
and ISNULL(RecordDeleted,'N')= 'N' and
DATEDIFF(DAY,Isnull(PreScreenDate,'01/01/1900'),getdate())  <=  366)   -- Inpatient in last 12 months

--Last Hospitalization Date 
set @LastHospitalizationDate =(Select top 1 Convert(Datetime, Convert(Varchar,Isnull(PreScreenDate,'01/01/1900'),101)) from ClientHospitalizations 
where ClientId = @ClientID and ISNULL(RecordDeleted,'N')= 'N' order by PreScreenDate desc)
--Changes end here


 --3/Aug/2012 - Mamta Gupta - Ref Task No. 1877 - Kalamazoo Bugs - Go Live                                                           
Select TOP 1 'CustomAcuteServicesPrescreens' AS TableName, -1 as 'DocumentVersionId'                                                
--Custom data                                              
   --   ,[DateOfPrescreen]                      
   --   ,[InitialCallTime]                      
   --   ,[ClientAvailableTimeForScreen]                      
   --   ,[DispositionTime]                      
   --   ,[ElapsedHours]                      
   --   ,[ElapsedMinutes]                      
   --   ,[CMHStatus]                      
   --   ,[CMHStatusPrimaryClinician]                      
      ,[CMHCaseNumber]                      
   --   ,[ClientName]                      
      ,[ClientEthnicity]                  
      ,[ClientSex]                      
   --   ,[ClientMaritalStatus]                      
      ,[ClientSSN]                      
      ,[ClientDateOfBirth]                      
      ,[ClientAddress]                      
   --   ,[ClientCity]                      
   --   ,[ClientState]                      
   --   ,[ClientZip]                      
      ,[ClientCounty]                      
      ,[ClientHomePhone]                      
      ,[ClientEmergencyContact]                      
   --   ,[ClientRelationship]                      
      ,[ClientEmergencyPhone]                      
      ,[ClientGuardianName]                      
      ,[ClientGuardianPhone]                   
       ,@DispostionComment as ServiceRequested          --- Added by Rakesh for Intializing Inquiry - Disposition text                 
                       
        ,@HospitalizationNumber  as [HHNumberOfIPPsychHospitalizations]    --  Added by Rakesh w.rf to task 135 in General Implementation                    
        ,@LastHospitalizationDate as [HHMostRecentIPHospitalizationDate]   --  Added by Rakesh w.rf to task 135 in General Implementation                    
                     
      , @PreviousHealthConcerns as [HHPreviousHealthConcerns]     -- Added by Rakesh w.rf to task 135 in General Implementation                    
                       
      ,[RowIdentifier]                          
      ,[RecordDeleted]                      
      ,[DeletedDate]                      
      ,[DeletedBy]                           
 FROM systemconfigurations s left outer join CustomAcuteServicesPrescreens                                                
      on s.DatabaseVersion=-1                      
                                                                                                                                                                
                       
  
                                            
                                         
END       

  exec ssp_InitCustomDiagnosisStandardInitializationNew @ClientID, @StaffID, @CustomParameters                                                      
end try                                                                            
                                                                                                                     
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                              
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_PAInitVenturePreScreen')                                                                                                           
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

GO


