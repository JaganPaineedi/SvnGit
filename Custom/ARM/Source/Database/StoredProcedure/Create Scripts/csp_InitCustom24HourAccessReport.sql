/****** Object:  StoredProcedure [dbo].[csp_InitCustom24HourAccessReport]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustom24HourAccessReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustom24HourAccessReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustom24HourAccessReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_InitCustom24HourAccessReport]
(                                                                                
 @StaffId int,                                                          
 @ClientID int,                                                          
 @CustomParameters xml                                                                                
)                                                                                                        
As                                                                                                               
 Begin    
/*********************************************************************/                                                                                                                                                          
/* Stored Procedure: csp_InitCustom24HourAccessReport              */                                                                                                                                                          
/* Copyright: 2009 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                          
/* Creation Date: 25 July,2011                                       */                                                                                                                                                          
/*                                                                   */                                                                                                                                                          
/* Purpose:  To Initialize Data for 24HourAccessReport Pages  */                                                                                                                                                        
/*                                                                   */                                                                                                                                                        
/* Input Parameters:   @StaffId,@ClientID,@CustomParameters  */                                                                                                                                                        
/*                                                                   */                                                                                                                                                          
/* Output Parameters:   None                   */                                                                                                                                                          
/*                                                                   */                                                                                                                                                          
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                          
/*                                                                   */                                 
/* Called By:  24HourAccessReport         */         
/*                 */                         
/* Calls:         */                                           
/*                         */                                             
/* Data Modifications:                   */                                                                          
/*      */                                                                                                         
/* Updates:               */                                                                             
/*   Date			 Author      Purpose                                */                                                                             
/*  25 July,2011     Minakshi  To Initialize Data for 24HourAccessReport */                                                                                     
/*                                                                                                          
*/                                                                                                                              
/*********************************************************************/   
                                                      
BEGIN TRY                                              
                                   
Declare @LatestSignedDocumentVersionID int                            
SET @LatestSignedDocumentVersionID=-1                             
                                           
-- --Get the latest signed document version ID                                                                      
-- SET @LatestSignedDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId from CustomDocument24HourAccess C,Documents D                                                                                                                        
--  where C.DocumentVersionId=D.CurrentDocumentVersionId and D.ClientId=@ClientID                                                                                                                                  
-- and D.Status=22 and DocumentCodeId =1491 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                                   
-- ORDER BY D.EffectiveDate DESC,D.ModifiedDate desc                                                        
--)                                             
 BEGIN   
    SELECT Placeholder.TableName,ISNULL(a.DocumentVersionId,-1) AS DocumentVersionId,
	   GETDATE() as ''timeofcall''
      ,b.TimeSpentMinutes
      ,@StaffId as ''PersonResponding''
      ,b.PersonCalling
      ,b.PhoneNumber
      ,b.IssueConcern
      ,b.ActionTaken
      ,b.ResolvedNoFurtherAction
      ,b.ResolvedNeedsFollowup
      ,b.ReferredRescue
      ,b.ResultedInpatientAdmission
      ,b.Crisis911
      ,b.OtherAction
      ,b.OtherActionDescription
      ,b.DangerSelfOthers
      ,b.DangerDescription
      ,b.[Plan]
 FROM  ( SELECT ''CustomDocument24HourAccess'' AS TableName) AS Placeholder
        LEFT JOIN documentversions a ON (a.DocumentVersionId = @LatestSignedDocumentVersionID AND ISNULL(a.RecordDeleted,''N'') <> ''Y'' )
        LEFT JOIN CustomDocument24HourAccess b ON ( a.DocumentVersionId = b.DocumentVersionId AND ISNULL(b.RecordDeleted,''N'') <> ''Y'' )
  
END
--Checking For Errors                                                                             
                                                                            
END TRY                                                                     
                                                                                                                                                                
 BEGIN CATCH                                                                                                                                                                                                                                                   
   DECLARE @Error varchar(8000)                                                                                                                                                                                                     
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                                    
                                                                  
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustom24HourAccessReport'')                                                                                                            
+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                            
                                                                                                                       
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                   
   RAISERROR (@Error  /* Message text*/,                                              
     16  /*Severity*/,                                               
              1  /*State*/   )                                                                                                                                   
 END CATCH                               
END 
' 
END
GO
