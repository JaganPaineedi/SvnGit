/****** Object:  StoredProcedure [dbo].[ssp_GetInquiryDetailInformation]    Script Date: 11/18/2011 16:25:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetInquiryDetailInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetInquiryDetailInformation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetInquiryDetailInformation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'          
CREATE procedure [dbo].[ssp_GetInquiryDetailInformation]               
(                      
@GrievanceId int                      
                    
)                      
As                      
/******************************************************************************                                      
**  File:                                       
**  Name: ssp_GetInquiryDetailInformation                                      
**  Desc: This storeProcedure will return information regarding InquiryDetail                                    
**                                                    
**  Parameters:                                      
**  Input  GrievanceId                     
                                        
**  Output     ----------       -----------                                      
**  DocumentId                                    
    Version                        
                                    
**  Auth:  Vikas Vyas                                  
**  Date:  20 April 2010                                    
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:			Author:		Description:                                      
**  --------  --------    -------------------------------------------                                      
**  02-Sept-2014	Vithobha	Added GrievanceResolutionOutcomes, GreivanceResolutionSteps tables Philhaven Development: #200 Customer Service Inquiry Changes                              
 ** 15.10.2015		Revathi		  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
									why:task #609, Network180 Customization                              
                      
*******************************************************************************/                        
Begin                      
 Begin Try                      
   --Grievance InforMation--                    
 SELECT [GrievanceId]              
      ,Grievances.[ClientId]              
      ,[MedicaidId]              
      ,[ComplainantRelationToClient]              
      ,[ComplainantName]              
      ,[ComplainantAddress]              
      ,[DateReceived]              
      ,[ReceivedVia]              
      ,[ComplaintCategory]              
      ,[GrievanceAboutCategory]              
      ,[GrievanceAboutStaffId]              
      ,[GrievanceAboutProviderId]              
      ,[GrievanceAboutName]              
      ,[Inquiry]              
      ,[GrievanceDescription]              
      ,[StaffInvolved]              
      ,[DateAcknowledgedInWriting]              
      ,[AdditionalInformation]              
      ,[StepsTakenComments]              
      ,[OutcomeComments]              
      ,[DateResolved]              
      ,InformedRightToStateFairHearing      
      ,[InquiryStatus]              
      ,[InquiryClosedDate]              
      --,Grievances.[RowIdentifier]              
      ,Grievances.[CreatedBy]              
      ,Grievances.[CreatedDate]              
      ,Grievances.[ModifiedBy]              
      ,Grievances.[ModifiedDate]              
      ,Grievances.[RecordDeleted]              
      ,Grievances.[DeletedDate]              
      ,Grievances.[DeletedBy]              
       ,-1 as ''OrganizationId''                
      ,'''' as ''OrganizationName''                
      --Added by Revathi  10/15/2015                            
      ,case when  ISNULL(Clients.ClientType,''I'')=''I'' then ISNULL(Clients.LastName,'''') + '', '' + ISNULL(Clients.FirstName,'''')  else ISNULL(Clients.OrganizationName,'''') end  as ClientName                           
       ,'''' as ''GrievanceStatus''                 
      , -1 as ''AcknowledgementLetterTemplateId''                
      , '''' as ''AcknowledgementLetterTemplateName''                
      , -1 as ''GrievanceAcknowledgementLetterId''                 
      , -1 as ''ResolutionLetterTemplateId''                
      , '''' as ''ResolutionLetterTemplateName''                
      , -1 as ''GrievanceResolutionLetterId''              
      ,'''' as  ''GrievanceCreatedBy''              
      ,'''' as ''GrievanceCreatedDate''                 
      ,'''' as ''GrievaceModifiedBy''              
      ,'''' as ''GrievanceModifiedDate''             
      ,'''' as ''ResolutionLetterSentOn''             
               
  FROM [Grievances] left Join Clients on Grievances.ClientId=Clients.ClientId and ISNULL(Clients.RecordDeleted,''N'')<>''Y''                   
  where GrievanceId=@GrievanceId and ISNULL(Grievances.RecordDeleted,''N'')<>''Y''                     
  --End Grievance Information--                    
  --InquiryResolutionInforation--                    
   SELECT [InquiryResolutionId]              
      ,[GrievanceId]              
      ,[ResolutionId]              
      ,IRS.[RowIdentifier]              
      ,IRS.[CreatedBy]              
      ,IRS.[CreatedDate]              
      ,IRS.[ModifiedBy]              
      ,IRS.[ModifiedDate]              
      ,IRS.[RecordDeleted]              
      ,IRS.[DeletedDate]              
      ,IRS.[DeletedBy]            
      ,GlobalCodes.CodeName as InquiryResolutionName              
  FROM [InquiryResolutions] IRS left join GlobalCodes on GlobalCodes.GlobalCodeId=IRS.ResolutionId                 
  and ISNULL(GlobalCodes.RecordDeleted,''N'')<>''Y'' and GlobalCodes.Active=''Y''                
  where GrievanceId=@GrievanceId and ISNULL(IRS.RecordDeleted,''N'')<>''Y''                     
   --End InquiryResolutionInforation--                    
   --GrievanceLetters--                    
   SELECT [GrievanceLetterId]                    
      ,[GrievanceId]                    
      ,GL.[LetterTemplateId]                    
      ,[SentOn]                    
      ,[Acknowledgement]                    
      ,[Resolution]                    
      ,[LetterText]                    
      ,GL.[RowIdentifier]                    
      ,GL.[CreatedBy]                    
      ,GL.[CreatedDate]                    
      ,GL.[ModifiedBy]                    
   ,GL.[ModifiedDate]                    
      ,GL.[RecordDeleted]                    
      ,GL.[DeletedDate]                    
      ,GL.[DeletedBy]             
      ,LT.[TemplateName]                     
  FROM [GrievanceLetters] GL join LetterTemplates LT on GL.LetterTemplateId = LT.LetterTemplateId where GrievanceId=@GrievanceId and ISNULL(GL.RecordDeleted,''N'')<>''Y''                    
   --GrievanceLetters Infromation                    
   --End           
            --Messages          
  SELECT [MessageId]          
      ,[FromStaffId]          
      ,[FromSystemDatabaseId]          
      ,[FromSystemStaffId]          
      ,[FromSystemStaffName]          
      ,[ToStaffId]          
      ,[ToSystemDatabaseId]          
      ,[ToSystemStaffId]          
      ,[ToSystemStaffName]          
      ,[ClientId]          
      ,[Unread]          
      ,[DateReceived]          
      ,[Subject]          
      ,[Message]          
      ,[Priority]          
      ,[ReferenceSystemDatabaseId]          
      ,[ReferenceType]          
      ,[ReferenceId]          
      ,[Reference]          
      ,[ReferenceLink]          
      ,[DocumentId]          
      ,[TabId]          
      ,[DeletedBySender]          
      ,[OtherRecipients]          
      ,[SenderCopy]          
      ,[ReceiverCopy]          
      --,[RowIdentifier]          
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]  
       ,PartOfClientRecord      
  FROM [dbo].[Messages] where Reference =''Grievances'' and ReferenceId=@GrievanceId and SenderCopy=''Y'' and ISNULL(RecordDeleted,''N'')<>''Y''           
 --Messages          
 --END          
           
--MessageRecepients          
SELECT [MessageRecepientId]          
      ,MR.[MessageId]          
      ,[StaffId]          
      ,[SystemDatabaseId]          
      ,[SystemStaffId]          
      ,[SystemStaffName]          
      ,MR.[RowIdentifier]          
      ,MR.[CreatedBy]          
      ,MR.[CreatedDate]          
      ,MR.[ModifiedBy]          
      ,MR.[ModifiedDate]          
      ,MR.[RecordDeleted]          
      ,MR.[DeletedDate]          
      ,MR.[DeletedBy]          
  FROM [dbo].[MessageRecepients] MR join [Messages] MS  on MR.MessageId = MS.MessageId where MS.ReferenceId = @GrievanceId AND ISNULL(MR.RecordDeleted,''N'')<>''Y''                      
  --MessageRecepients           
  --END   
   --GrievanceResolutionInforation--                        
     SELECT [GreivanceResolutionStepId]                        
      ,[GrievanceId]                        
      ,[StepTakenId]                        
      ,GRS.[RowIdentifier]                        
      ,GRS.[CreatedBy]                        
      ,GRS.[CreatedDate]                        
      ,GRS.[ModifiedBy]                        
      ,GRS.[ModifiedDate]                        
      ,GRS.[RecordDeleted]                        
      ,GRS.[DeletedDate]                        
      ,GRS.[DeletedBy]                        
      ,GlobalCodes.CodeName as StepsTakenName                    
  FROM [GreivanceResolutionSteps] GRS left join GlobalCodes on GlobalCodes.GlobalCodeId=GRS.StepTakenId                     
  and ISNULL(GlobalCodes.RecordDeleted,''N'')<>''Y'' and GlobalCodes.Active=''Y''                    
   where GrievanceId=@GrievanceId and ISNULL(GRS.RecordDeleted,''N'')<>''Y''                          
                         
      SELECT [GrievanceResolutionOutcomeId]                        
      ,[GrievanceId]                        
      ,[OutcomeId]                        
      ,GRO.[RowIdentifier]                        
      ,GRO.[CreatedBy]                        
      ,GRO.[CreatedDate]                        
      ,GRO.[ModifiedBy]                        
      ,GRO.[ModifiedDate]                        
      ,GRO.[RecordDeleted]                        
      ,GRO.[DeletedDate]                        
      ,GRO.[DeletedBy]                    
      ,GlobalCodes.CodeName as OutComesTakenName                        
  FROM [GrievanceResolutionOutcomes]  GRO                    
  left join GlobalCodes on GlobalCodes.GlobalCodeId=GRO.OutcomeId                     
  and ISNULL(GlobalCodes.RecordDeleted,''N'')<>''Y'' and GlobalCodes.Active=''Y''                    
                      
  where GrievanceId=@GrievanceId and ISNULL(GRO.RecordDeleted,''N'')<>''Y''                        
   --End ResolutionOutcomes--                      
                       
End Try                    
  Begin Catch                      
  declare @Error varchar(8000)                                    
  set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                     
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_GetInquiryDetailInformation'')                                     
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                      
  + ''*****'' + Convert(varchar,ERROR_STATE())                      
                        
 End Catch                      
End ' 
END
GO
