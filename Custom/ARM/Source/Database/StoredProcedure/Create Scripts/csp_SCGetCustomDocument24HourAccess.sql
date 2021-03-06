/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocument24HourAccess]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocument24HourAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocument24HourAccess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocument24HourAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_SCGetCustomDocument24HourAccess]
(                                                                                                                                                                                                                                                              
      
  @DocumentVersionId int,                                                                                                                                                               
  @StaffId as int                                                                                                                                                                                                                                              
   
)                                                                                                                                                                                                                                                              
      
As                                                                                                                                                                                                                      
 /*********************************************************************/                                                                                                                                                        
/* Stored Procedure: csp_SCGetCustomDocument24HourAccess               */                                                                                                                                                        
/* Copyright: 2009 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                        
/* Creation Date: 25 July,2011                                     */                                                                                                                                                        
/*                                                                   */                                                                                                                                                        
/* Purpose:  Get Data for 24HourAccess Document  */                                                                                                                                                      
/*                                                                   */                                                                                                                                                      
/* Input Parameters:   @DocumentVersionId,@StaffId  */                                                                                                                                                      
/*                                                                   */                                                                                                                                                        
/* Output Parameters:   None                   */                                                                                                                                                        
/*                                                                   */                                                                                                                                                        
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                        
/*                                                                   */                               
/* Called By:  CustomDocument24HourAccess								*/       
/*																	*/                       
/* Calls:         */                                         
/*                         */                                           
/* Data Modifications:                   */                                                                        
/*      */                                                                                                       
/* Updates:               */                                                                                                
/*   Date			Author      Purpose                                */                                                                           
/*  25 July,2011	Minakshi	Get Data for 24HourAccess Document */                                                                                   
/*                                                                                                        
*/                                                                                                                             
/*********************************************************************/  

   
BEGIN                                                                                                                                                                        
                
                                                                                  
declare @LatestDocumentVersionID int                                                                                                                                                                          
                     
                            
BEGIN TRY  

  SELECT [DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[TimeOfCall]
      ,[TimeSpentMinutes]
      ,[PersonResponding]
      ,[PersonCalling]
      ,[PhoneNumber]
      ,[IssueConcern]
      ,[ActionTaken]
      ,[ResolvedNoFurtherAction]
      ,[ResolvedNeedsFollowup]
      ,[ReferredRescue]
      ,[ResultedInpatientAdmission]
      ,[Crisis911]
      ,[OtherAction]
      ,[OtherActionDescription]
      ,[DangerSelfOthers]
      ,[DangerDescription]
      ,[Plan]                                                                                                                                                                             
   FROM CustomDocument24HourAccess                                                                                                                                                                 
   WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''  
   
  END TRY                                                                   
                                                                                                                                                              
 BEGIN CATCH                                                                                                                                                                                                                                                   
 
  DECLARE @Error varchar(8000)                                                                                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                                  
                                                                
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCGetCustomDocument24HourAccess'')                                                                                                          
+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                          
                                                                                                                     
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                 
   RAISERROR (@Error  /* Message text*/,                                            
     16  /*Severity*/,                                             
              1  /*State*/   )                                                                                                                                 
 END CATCH                                                  
End ' 
END
GO
