 
/****** Object:  StoredProcedure [dbo].[ssp_GetSecondOpinionDetailInformation]    Script Date: 07/17/2012 12:19:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSecondOpinionDetailInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSecondOpinionDetailInformation]
GO
 

/****** Object:  StoredProcedure [dbo].[ssp_GetSecondOpinionDetailInformation]    Script Date: 07/17/2012 12:19:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  --exec [dbo].[ssp_GetSecondOpinionDetailInformation] '12'
CREATE procedure [dbo].[ssp_GetSecondOpinionDetailInformation]                 
(                      
@secondopinionid int                      
                    
)                      
As                      
/******************************************************************************                                      
**  File:                                       
**  Name: ssp_GetSecondOpinionDetailInformation                                      
**  Desc: This storeProcedure will return information regarding InquiryDetail                                    
**                                                    
**  Parameters:                                      
**  Input  secondopinionid                     
                                        
**  Output     ----------       -----------                                      
**  DocumentId                                    
    Version                        
                                    
**  Auth:  Vikas Vyas                                  
**  Date:  22 April 2010                                    
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:				  Author:			Description:                                      
/*  17-June-2012          Davinderk			Commented the column StaffInvolved,SecondOpinions.[RowIdentifier] there is no column in the table SecondOpinions*/         /*  01Oct2012			  Shifali	  Modified - Added Column SecondOpinions.StafInvolvedResolution && StaffInvolvedInitial*/   
/*  25-October-2012		  Rachna Singh      Add column [SecondOpinionDescription] with ref to task #75 in 3.5xIssues    */                  
/*  16-Oct-2015			  Revathi			 what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName. */ 
/*											 why:task #609, Network180 Customization      */   
                            
                      
*******************************************************************************/                        
Begin                      
 Begin Try                      
   --SecondOpinions InforMation--                    
SELECT [SecondOpinionId]          
      ,SecondOpinions.[ClientId]          
      ,[MedicaidId]          
      ,[ComplainantRelationToClient]          
      ,[ComplainantName]          
      ,[ComplainantAddress]          
      ,[DateReceived]          
      ,[SecondOpinionStatus]          
      ,[SecondOpinionType]          
      ,[RequestApproved]          
      ,[NotifyRightToStateFairHearing]          
      ,[SecondOpinionDescription]          
      --,[StaffInvolved] 
      ,[StaffInvolvedInitial]         
      ,[AdditionalInformation]          
      ,[DateResolved]          
      ,[Resolution]          
      ,[DateResolutionLetterSent]          
      ,[ResolutionComment]          
      --,SecondOpinions.[RowIdentifier]          
      ,SecondOpinions.[CreatedBy]          
      ,SecondOpinions.[CreatedDate]          
      ,SecondOpinions.[ModifiedBy]          
      ,SecondOpinions.[ModifiedDate]          
      ,SecondOpinions.[RecordDeleted]          
      ,SecondOpinions.[DeletedDate]          
      ,SecondOpinions.[DeletedBy]          
       ,-1 as 'OrganizationId'                
      ,'' as 'OrganizationName'                
      --Added by Revathi  16-Oct-2015          
			,CASE 
				WHEN ISNULL(Clients.ClientType, 'I') = 'I'
					THEN ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '')
				ELSE ISNULL(Clients.OrganizationName, '')
				END AS ClientName         
     , -1 as 'AcknowledgementLetterTemplateId'          
      , '' as 'AcknowledgementLetterTemplateName'            
     , -1 as 'ResolutionLetterTemplateId'          
     , '' as 'ResolutionLetterTemplateName'          
     , -1 as 'SecondOpinionResolutionLetterId'        
     , -1 as 'SecondOpinionAcknowledgementLetterId'               
      ,'' as 'SecondOpinionCreatedBy'            
      ,'' as 'SecondOpinionCreatedDate'               
      ,'' as 'SecondOpinionModifiedBy'            
      ,'' as 'SecondOpinionModifiedDate'           
      ,'' as 'SecondOpinionLetterSentOn'   
      ,StafInvolvedResolution    
      ,StaffInvolvedInitial      
  FROM [SecondOpinions] left Join Clients on SecondOpinions.ClientId=Clients.ClientId and ISNULL(Clients.RecordDeleted,'N')<>'Y'                   
  where SecondOpinionId=@secondopinionid and ISNULL(SecondOpinions.RecordDeleted,'N')<>'Y'                     
  --End SecondOpinions InforMation--                    
  --SecondOpinionLetter Inforation--                    
       SELECT [GrievanceLetterId]          
      ,[SecondOpinionId]          
      ,SOL.[LetterTemplateId]          
      ,[SentOn]          
     ,[Acknowledgement]          
      ,[Resolution]          
      ,[LetterText]          
      ,SOL.[RowIdentifier]          
      ,SOL.[CreatedBy]          
      ,SOL.[CreatedDate]          
      ,SOL.[ModifiedBy]          
      ,SOL.[ModifiedDate]          
      ,SOL.[RecordDeleted]          
      ,SOL.[DeletedDate]          
      ,SOL.[DeletedBy]          
       ,LT.[TemplateName]      FROM [SecondOpinionLetters] SOL join LetterTemplates LT on SOL.LetterTemplateId = LT.LetterTemplateId          
   where SecondOpinionId=@secondopinionid and ISNULL(SOL.RecordDeleted,'N')<>'Y'                    
                       
   --End SecondOpinionLetter Inforation--                    
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
  FROM [dbo].[Messages] where Reference ='SecondOpinion' and ReferenceId=@secondopinionid and SenderCopy='Y' and ISNULL(RecordDeleted,'N')<>'Y'         
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
  FROM [dbo].[MessageRecepients] MR join [Messages] MS  on MR.MessageId = MS.MessageId where MS.ReferenceId = @secondopinionid AND ISNULL(MR.RecordDeleted,'N')<>'Y'                    
  --MessageRecepients         
  --END                   
   --End                    
                       
End Try                    
  Begin Catch                      
  declare @Error varchar(8000)                                    
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetSecondOpinionDetailInformation')                                     
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                      
  + '*****' + Convert(varchar,ERROR_STATE())                      
                        
 End Catch                      
End 
GO


