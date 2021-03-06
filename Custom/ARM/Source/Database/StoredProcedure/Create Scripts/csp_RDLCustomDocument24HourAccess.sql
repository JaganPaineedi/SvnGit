/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocument24HourAccess]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocument24HourAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocument24HourAccess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocument24HourAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLCustomDocument24HourAccess]                 
(                                                                                                                                                                                                  
  @DocumentVersionId int                                                                                                                                                                        
)                                                                                                                                                                                                  
As            
                                                                                                                                   
/*********************************************************************/                                                                                                                                                
/* Stored Procedure: dbo.[csp_RDLCustomDocument24HourAccess]                */                                                                                                                                                
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                
/* Creation Date:  26 July,2011                                        */                                                                                                                                                
/* Created By  Jagdeep Hundal                                                                  */                                                                                                                                                
/* Purpose:  Get Data for csp_RDLCustomDocument24HourAccess Pages */                                                                                                                                              
/*                                                                   */                                                                                                                                              
/* Input Parameters:  @DocumentVersionId             */                                                                                                                                              
/*                                                                   */                                                                                                                                                
/* Output Parameters:   None                   */                                                                                                                                                
/*                                                                   */                                                                                                                                                
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                
/*                                                                   */                                                                                                                                                
/* Called By:                                                        */                                                                                                                                                
/*                                                                   */                            
/* Calls:             */         
/* */                  
/* Data Modifications:   */                                               
/* */                                                                                               
/* Updates:               */                                                            
/* Date     Author            Purpose                             */                                                                   
 /*22.12.2017 - Kavya.N     - Changed clientname and staffname format to (Firstname Lastname)*/                                                                                                                
/*********************************************************************/                                                                                                                                           
                                                                                                                                          
                                                                                                             
BEGIN TRY                               
BEGIN          
  
                                       
SELECT CDHA.[DocumentVersionId]         
      ,(Select OrganizationName from SystemConfigurations) as OrganizationName                                
      ,Documents.ClientId                                
      ,Clients.FirstName + '' '' + Clients.Lastname as ClientName  
      ,Documents.EffectiveDate 
      ,CONVERT(varchar(12),TimeOfCall,110) as CallDate 
      ,RIGHT(CONVERT(VARCHAR, TimeOfCall, 100),7) as TimeOfCall                                   
      ,CDHA.[TimeSpentMinutes]
      ,S.FirstName + '' '' + S.Lastname as PersonResponding  
      ,CDHA.[PersonCalling]
      ,CDHA.[PhoneNumber]
      ,CDHA.[IssueConcern]
      ,CDHA.[ActionTaken]
      ,CDHA.[ResolvedNoFurtherAction]
      ,CDHA.[ResolvedNeedsFollowup]	
      ,CDHA.[ReferredRescue]
      ,CDHA.[ResultedInpatientAdmission]
      ,CDHA.[Crisis911]
      ,CDHA.[OtherAction]
      ,CDHA.[OtherActionDescription]
      ,CDHA.[DangerSelfOthers]
      ,CDHA.[DangerDescription]
      ,CDHA.[Plan]                         
From Documents                  
INNER JOIN DocumentVersions  on Documents.DocumentId = DocumentVersions.DocumentId               
inner Join CustomDocument24HourAccess as CDHA on CDHA.DocumentVersionId = DocumentVersions.DocumentVersionId             
INNER JOIN Clients on Clients.ClientId = Documents.ClientId
left join Staff S on S.StaffId = CDHA.PersonResponding                                  
                                
Where CDHA.DocumentVersionId =@DocumentVersionId           
and ISNULL(Documents.RecordDeleted,''N'')=''N''                
and ISNULL(DocumentVersions.RecordDeleted,''N'')=''N''                             
and ISNULL(CDHA.RecordDeleted,''N'')=''N''                               
and ISNULL(Clients.RecordDeleted,''N'')=''N''         
 END                                                                                  
 END TRY                                                                                           
 BEGIN CATCH                                             
   DECLARE @Error varchar(8000)                                                                                                                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLCustomDocument24HourAccess'')               
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                                                                      
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                               
                                                                                                                          
 END CATCH     ' 
END
GO
