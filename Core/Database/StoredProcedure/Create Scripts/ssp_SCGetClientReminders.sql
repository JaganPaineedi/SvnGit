/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientReminders]    Script Date: 11/18/2011 16:25:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientReminders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientReminders]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientReminders]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create  Procedure [dbo].[ssp_SCGetClientReminders]        
(                        
 @ClientReminderId int                        
)                      
As                
/*********************************************************************/                                
/* Stored Procedure: dbo.ssp_SCGetClientReminders             */                                
/* Creation Date:  07/11/2011                                            */                                
/*                                                                       */                                
/* Purpose: To  Get Client Reminders detail as per ClientReminderId              */                               
/*                                                                   */                              
/* Input Parameters: @ClientReminderId           */                              
/*                                                                   */                                
/* Output Parameters:                                */                                
/*                                                                   */                                
/*  Date                  Author                 Purpose          */                                
/* 07/11/2011             Damanpreet            Created         */    
/*  21 Oct 2015				Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */   
/*												why:task #609, Network180 Customization  */                              
/*********************************************************************/                         
                
    --ClientReminders--          
 Select [ClientReminderId]        
      ,CR.[CreatedBy]        
      ,CR.[CreatedDate]        
      ,CR.[ModifiedBy]        
      ,CR.[ModifiedDate]        
      ,CR.[RecordDeleted]        
      ,CR.[DeletedDate]        
      ,CR.[DeletedBy]        
      ,CR.[ClientId]        
      ,CR.[ClientReminderTypeId]        
      ,[ReminderDate]        
      ,[Processed]        
      ,[ProcessedDate]        
      ,[CommunicationType]        
      ,[PhoneNumber]        
      ,[MobilePhoneNumber]        
      ,CR.[Email]        
      ,CR.[EmailSubject]        E
      --Added by Revathi 21 Oct 2015
      ,REPLACE(REPLACE(CR.[EmailMessage],''[ClientId]'',CR.[ClientId]),''[ClientName]'',CASE WHEN ISNULL(C.ClientType,''I'')=''I'' THEN  ISNULL(C.LastName,'''') +'', ''+ ISNULL(C.FirstName,'''') ELSE ISNULL(C.OrganizationName,'''')END ) as EmailMessage  
      ,REPLACE(REPLACE(CR.[TextMessage],''[ClientId]'',CR.[ClientId]),''[ClientName]'',CASE WHEN ISNULL(C.ClientType,''I'')=''I'' THEN  ISNULL(C.LastName,'''') +'', ''+ ISNULL(C.FirstName,'''') ELSE ISNULL(C.OrganizationName,'''')END ) as TextMessage      
      ,CR.[VoicemailTemplateId]        
      ,REPLACE(REPLACE(CR.[SystemMessage],''[ClientId]'',CR.[ClientId]),''[ClientName]'',CASE WHEN ISNULL(C.ClientType,''I'')=''I'' THEN  ISNULL(C.LastName,'''') +'', ''+ ISNULL(C.FirstName,'''') ELSE ISNULL(C.OrganizationName,'''')END ) as SystemMessage         
      ,CASE WHEN ISNULL(C.ClientType,''I'')=''I'' THEN  ISNULL(C.LastName,'''') +'', ''+ ISNULL(C.FirstName,'''') ELSE ISNULL(C.OrganizationName,'''')END as ClientName        
      ,CRT.ReminderTypeName      
      ,gc.CodeName as CommunicationTypeName      
      ,CR.MobilePhoneProvider      
 FROM ClientReminders as CR        
 Join Clients C on C.ClientId = CR.ClientId and isnull(C.RecordDeleted, ''N'') = ''N''       
 Join ClientReminderTypes as CRT on CRT.ClientReminderTypeId = CR.ClientReminderTypeId and isnull(CRT.RecordDeleted, ''N'') = ''N''        
LEFT Join GlobalCodes gc on gc.GlobalCodeId = CR.CommunicationType  and isnull(gc.RecordDeleted, ''N'') = ''N''       
 Where CR.ClientReminderId = @ClientReminderId  and isnull(CR.RecordDeleted, ''N'') = ''N''       
              
--Checking For Errors                
If (@@error!=0)               
  Begin                
  RAISERROR  20006  ''ssp_SCGetClientReminders: An Error Occured''                   
  Return                
 End                ' 
END
GO
