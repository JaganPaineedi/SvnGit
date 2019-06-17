IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomReleaseOfInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomReleaseOfInformation]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE Procedure [dbo].[csp_validateCustomReleaseOfInformation]
@DocumentVersionId int  
As 
/************************************************************************************/        
/* Stored Procedure: dbo.[csp_validateCustomReleaseOfInformation]   171     */        
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */        
/* Creation Date:   25/jan/2013            */             
/* Purpose:To validate 'Release of Information' document    */       
/*                     */      
/* Input Parameters:  @DocumentVersionId      */      
/*                     */        
/* Output Parameters:   None              */        
/*                     */        
/* Return:  0=success, otherwise an error number         */        
/*                     */        
/* Called By:                  */        
/*                     */        
/* Calls:                   */        
/*                     */        
/* Data Modifications:                */        
/*                     */        
/* Updates:                   */        
/*  Date           Author             Purpose            */        
/* 25/jan/2013   Atul Pandey          created  */  
/* 01/Feb/2013   Sanjay Bhardwaj      Modified wrt Task#2 in newaygo Customization  */  
/*                                    Add ValidationOrder column in #validationReturnTable*/
/*                                    Add ROI#1,#2,#3... logic for comparing validation for each ROI*/
/*                                    Move some validaton to up as per the order by UI*/
/* 04/Feb/2013   Sanjay Bhardwaj      Modified wrt Task#2 in newaygo Customization  */  
/*                                    Add new validation for Organization Name as suggested by heather and Katie H*/
/*                                      Organization name should be the only required field as it is necessary for our functionality.
                                        There may be a case that only the address or only the phone number is known based on how information
                                        will be disclosed so not having one or another of these fields filled in should NOT prevent the 
                                        document from being saved/signed.
                                        -Heather*/
/************************************************************************************/   

Begin  
  Begin Try
Declare @DocumentCodeId int  
Set @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId=@DocumentVersionId)  
  
Declare @DocumentId int  
Set @DocumentId = (Select DocumentId From Documents Where CurrentDocumentVersionId=@DocumentVersionId)  
  
  
--  
--Create Temp Tables  
-- 
create table #CustomDocumentReleaseOfInformations
     (
         [ReleaseOfInformationId] int,
         CreatedBy varchar(100),  
		 CreatedDate Datetime,  
		 ModifiedBy varchar(100),  
		 ModifiedDate Datetime,  
		 RecordDeleted char(1),  
		 DeletedDate datetime NULL ,  
		 DeletedBy varchar(100)
      ,[DocumentVersionId]  int
      ,[OldDocumentVersionId] int
      ,[ReleaseOfInformationOrder] int
      ,[GetInformationFrom]    varchar(3)
      ,[ReleaseInformationFrom] varchar(3)
      ,[ReleaseToReceiveFrom]  int
      ,[ReleaseEndDate]         Datetime
      ,[ReleaseContactType]    varchar(3)
      ,[ReleaseName]           varchar(200)
      ,[ReleaseAddress]        varchar(200)
      ,[ReleaseCity]           varchar(100)
      ,[ReleasedState]         varchar(100)
      ,[ReleasePhoneNumber]    varchar(100)
      ,[ReleasedZip]           varchar(50)
      ,[AssessmentEvaluation]  varchar(3)
      ,[PersonPlan]            varchar(3)
      ,[ProgressNote]          varchar(3)
      ,[PsychologicalTesting]  varchar(3)
      ,[PsychiatricTreatment]  varchar(3)
      ,[TreatmentServiceRecommendation] varchar(3)
      ,[EducationalDevelopmental]       varchar(3)
      ,[DischargeTransferRecommendation] varchar(3)
      ,[InformationBenefitInsurance]     varchar(3)
      ,[WorkRelatedInformation]          varchar(3)
      ,[ReleasedInfoOther]               varchar(3)
      ,[ReleasedInfoOtherComment]         varchar(MAX)
      ,[TransmissionModesWritten]        varchar(3) 
      ,[TransmissionModesVerbal]         varchar(3)
      ,[TransmissionModesElectronic]     varchar(3)
      ,[TransmissionModesAudio]          varchar(3)
      ,[TransmissionModesPhoto]          varchar(3) 
      ,[TransmissionModesReleaseInOther] varchar(3)
      ,[TransmissionModesReleaseInOtherComment]  varchar(MAX)
      ,[TransmissionModesToProvideCaseCoordination]   varchar(3)
      ,[TransmissionModesToDetermineEligibleService]  varchar(3)
      ,[TransmissionModesAtRequestIndividual]         varchar(3)
      ,[TransmissionModesInOther]                     varchar(3)
      ,[TransmissionModesOtherComment]                varchar(MAX)
      ,[AlcoholDrugAbuse]                             varchar(3) 
      ,[AIDSRelatedComplex]							  varchar(3)
      )



  
Insert into #CustomDocumentReleaseOfInformations
(  
       [ReleaseOfInformationId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[DocumentVersionId]
      ,[OldDocumentVersionId]
      ,[ReleaseOfInformationOrder]
      ,[GetInformationFrom]
      ,[ReleaseInformationFrom]
      ,[ReleaseToReceiveFrom]
      ,[ReleaseEndDate]
      ,[ReleaseContactType]
      ,[ReleaseName]
      ,[ReleaseAddress]
      ,[ReleaseCity]
      ,[ReleasedState]
      ,[ReleasePhoneNumber]
      ,[ReleasedZip]
      ,[AssessmentEvaluation]
      ,[PersonPlan]
      ,[ProgressNote]
      ,[PsychologicalTesting]
      ,[PsychiatricTreatment]
      ,[TreatmentServiceRecommendation]
      ,[EducationalDevelopmental]
      ,[DischargeTransferRecommendation]
      ,[InformationBenefitInsurance]
      ,[WorkRelatedInformation]
      ,[ReleasedInfoOther]
      ,[ReleasedInfoOtherComment]
      ,[TransmissionModesWritten]
      ,[TransmissionModesVerbal]
      ,[TransmissionModesElectronic]
      ,[TransmissionModesAudio]
      ,[TransmissionModesPhoto]
      ,[TransmissionModesReleaseInOther]
      ,[TransmissionModesReleaseInOtherComment]
      ,[TransmissionModesToProvideCaseCoordination]
      ,[TransmissionModesToDetermineEligibleService]
      ,[TransmissionModesAtRequestIndividual]
      ,[TransmissionModesInOther]
      ,[TransmissionModesOtherComment]
      ,[AlcoholDrugAbuse]
      ,[AIDSRelatedComplex] 
)  
SELECT [ReleaseOfInformationId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[DocumentVersionId]
      ,[OldDocumentVersionId]
      ,[ReleaseOfInformationOrder]
      ,[GetInformationFrom]
      ,[ReleaseInformationFrom]
      ,[ReleaseToReceiveFrom]
      ,[ReleaseEndDate]
      ,[ReleaseContactType]
      ,[ReleaseName]
      ,[ReleaseAddress]
      ,[ReleaseCity]
      ,[ReleasedState]
      ,[ReleasePhoneNumber]
      ,[ReleasedZip]
      ,[AssessmentEvaluation]
      ,[PersonPlan]
      ,[ProgressNote]
      ,[PsychologicalTesting]
      ,[PsychiatricTreatment]
      ,[TreatmentServiceRecommendation]
      ,[EducationalDevelopmental]
      ,[DischargeTransferRecommendation]
      ,[InformationBenefitInsurance]
      ,[WorkRelatedInformation]
      ,[ReleasedInfoOther]
      ,[ReleasedInfoOtherComment]
      ,[TransmissionModesWritten]
      ,[TransmissionModesVerbal]
      ,[TransmissionModesElectronic]
      ,[TransmissionModesAudio]
      ,[TransmissionModesPhoto]
      ,[TransmissionModesReleaseInOther]
      ,[TransmissionModesReleaseInOtherComment]
      ,[TransmissionModesToProvideCaseCoordination]
      ,[TransmissionModesToDetermineEligibleService]
      ,[TransmissionModesAtRequestIndividual]
      ,[TransmissionModesInOther]
      ,[TransmissionModesOtherComment]
      ,[AlcoholDrugAbuse]
      ,[AIDSRelatedComplex]
  FROM [CustomDocumentReleaseOfInformations] CDRI
  where CDRI.documentVersionId = @documentVersionId  
  and isnull(CDRI.RecordDeleted,'N') = 'N'  
  


  
  
Insert into #validationReturnTable  
 (TableName,  
 ColumnName,  
 ErrorMessage,
 ValidationOrder  
 )  
  
 Select 'CustomDocumentReleaseOfInformations', 'GetInformationFrom', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select either Get Information From  or Release private (confidential) information to...',(13*ReleaseOfInformationOrder)+1  
 from #CustomDocumentReleaseOfInformations
 where ISNULL(GetInformationFrom,'N')='N' and ISNULL(ReleaseInformationFrom,'N')='N'
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'ReleaseContactType', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select Organization/Contact.'  ,(13*ReleaseOfInformationOrder)+2
 from #CustomDocumentReleaseOfInformations
 where ISNULL(ReleaseContactType,'')='' 
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'ReleaseToReceiveFrom', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select Release To/From.'  ,(13*ReleaseOfInformationOrder)+3
 from #CustomDocumentReleaseOfInformations
 where ISNULL(ReleaseToReceiveFrom,'')='' and ISNULL(ReleaseContactType,'')='C'
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'ReleaseName', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please enter Organization Name.'  ,(13*ReleaseOfInformationOrder)+4
 from #CustomDocumentReleaseOfInformations
 where ISNULL(ReleaseName,'')='' and ISNULL(ReleaseContactType,'')='O'
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'ReleaseEndDate', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please enter End Date.'  ,(13*ReleaseOfInformationOrder)+5
 from #CustomDocumentReleaseOfInformations
 where ISNULL(ReleaseEndDate,'')=''  
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'AssessmentEvaluation', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select at least one checkbox from section Information To Be Released.'  ,(13*ReleaseOfInformationOrder)+6
 from #CustomDocumentReleaseOfInformations
 where ISNULL(ReleaseInformationFrom,'')='Y' and (ISNULL(AssessmentEvaluation,'N')='N' and ISNULL(PersonPlan,'N')='N' and ISNULL(ProgressNote,'N')='N' 
       and ISNULL(PsychologicalTesting,'N')='N' and ISNULL(PsychiatricTreatment,'N')='N' and ISNULL(TreatmentServiceRecommendation,'N')='N' 
       and ISNULL(EducationalDevelopmental,'N')='N' and ISNULL(DischargeTransferRecommendation,'N')='N' and ISNULL(InformationBenefitInsurance,'N')='N' 
       and ISNULL(WorkRelatedInformation,'N')='N' and ISNULL(ReleasedInfoOther,'N')='N'  ) 
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'ReleasedInfoOtherComment', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please enter other comment in Information To Be Released.' ,(13*ReleaseOfInformationOrder)+7 
 from #CustomDocumentReleaseOfInformations
 where ISNULL(ReleasedInfoOtherComment,'')='' and isnull(ReleasedInfoOther,'N')='Y'       

 UNION
 Select 'CustomDocumentReleaseOfInformations', 'TransmissionModesWritten', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select at least one checkbox from Transmission Modes, The Information may be released in..'  ,(13*ReleaseOfInformationOrder)+8
 from #CustomDocumentReleaseOfInformations
 where ISNULL(TransmissionModesWritten,'N')='N' and  ISNULL(TransmissionModesVerbal,'N')='N' and ISNULL(TransmissionModesElectronic,'N')='N' 
       and ISNULL(TransmissionModesPhoto,'N')='N' and ISNULL(TransmissionModesReleaseInOther,'N')='N'
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'TransmissionModesReleaseInOtherComment', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please enter other comment of information released type in Transmission Modes .'  ,(13*ReleaseOfInformationOrder)+9
 from #CustomDocumentReleaseOfInformations
 where ISNULL(TransmissionModesReleaseInOtherComment,'')='' and isnull(TransmissionModesReleaseInOther,'N')='Y'
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'TransmissionModesToProvideCaseCoordination', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select from Transmission Modes, either To provide comprehensive case coordination or To determine eligibility for services or At the request of the individual or Other.'  ,(13*ReleaseOfInformationOrder)+10
 from #CustomDocumentReleaseOfInformations
 where ISNULL(TransmissionModesToProvideCaseCoordination,'N')='N' and  ISNULL(TransmissionModesToDetermineEligibleService,'N')='N'  and  ISNULL(TransmissionModesAtRequestIndividual,'N')='N' and  ISNULL(TransmissionModesInOther,'N')='N'  
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'TransmissionModesOtherComment', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please enter other comment of purposes in Transmission Modes .'  ,(13*ReleaseOfInformationOrder)+11
 from #CustomDocumentReleaseOfInformations
 where ISNULL(TransmissionModesOtherComment,'')='' and isnull(TransmissionModesInOther,'N')='Y'
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', '#CustomDocumentReleaseOfInformations', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select from Additional information, alcohol and drug abuse information.'  ,(13*ReleaseOfInformationOrder)+12
 from #CustomDocumentReleaseOfInformations
 where ISNULL(AlcoholDrugAbuse,'')='' 
  
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'AIDSRelatedComplex', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select from Additional information, HIV/AIDS/Sexually Transmitted Disease/Communicable Disease.'  ,(13*ReleaseOfInformationOrder)+13
 from #CustomDocumentReleaseOfInformations
 where ISNULL(AIDSRelatedComplex,'')='' 
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'ReleasedInfoOther', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select other checkbox of Information To Be Released when explanation is there.' ,(13*ReleaseOfInformationOrder)+14 
 from #CustomDocumentReleaseOfInformations
 where ReleasedInfoOtherComment is not null and isnull(ReleasedInfoOther,'N')='N'  
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'TransmissionModesReleaseInOther', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select other checkbox  of information released type in Transmission Modes when explanation is there.' ,(13*ReleaseOfInformationOrder)+15 
 from #CustomDocumentReleaseOfInformations
 where TransmissionModesReleaseInOtherComment is not null and isnull(TransmissionModesReleaseInOther,'N')='N'  
 
 UNION
 Select 'CustomDocumentReleaseOfInformations', 'TransmissionModesInOther', 'ROI#' + convert(nvarchar(3),ReleaseOfInformationOrder) + ' - Please select other checkbox of purposes in Transmission Modes when explanation is there.' ,(13*ReleaseOfInformationOrder)+16 
 from #CustomDocumentReleaseOfInformations
 where TransmissionModesOtherComment is not null and isnull(TransmissionModesInOther,'N')='N'    
 
 
  
  
 
   END TRY
  Begin Catch                              
  declare @Error varchar(8000)                                            
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_validateCustomReleaseOfInformation')                                             
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                              
  + '*****' + Convert(varchar,ERROR_STATE())                                                            
  End Catch
 End 