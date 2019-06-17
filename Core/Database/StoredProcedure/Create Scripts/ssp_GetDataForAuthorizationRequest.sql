IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDataForAuthorizationRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDataForAuthorizationRequest]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
Create PROCEDURE  [dbo].[ssp_GetDataForAuthorizationRequest]                                         
(                                                                            
  @DocumentVersionId int                                                                         
)                                                                            
As                    
/*********************************************************************/                                                                                                      
 /* Stored Procedure: [ssp_GetDataForAuthorizationRequest]           */                                                                                                                                                                                                                                                                                              
 /* Author : Arjun K R                                               */                         
 /* Creation Date:  05/Nov/2015                                      */ 
 /* Purpose : Task #604.6 Network180 Customizations                  */  
 -- Updates:                                                                                                                                                                               
-- Date				Author			Purpose  
-- May/16/2016		Alok Kumar		Added query to return ImageRecords table for task #602.5 Network 180 Environment Issues Tracking
-- Sep/20/2018   k.Soujanya  What:Added DocumentId column to the ImageRecords table.Why:Partner Solutions - Enhancements #1                                                                                              
 /********************************************************************/                  
 BEGIN                                   
   BEGIN TRY                                                              
    SELECT [DocumentVersionId]                
      ,[CreatedBy]                
      ,[CreatedDate]                
      ,[ModifiedBy]                
      ,[ModifiedDate]                
      ,[RecordDeleted]                
      ,[DeletedBy]                
      ,[DeletedDate]                
      ,[InsurerId]                
      ,[ProviderId]                              
  FROM [DocumentAuthorizationRequests]                 
  WHERE ISNull(RecordDeleted,'N')='N' AND DocumentVersionId=@DocumentVersionId                  
  
    
 SELECT Distinct CA.[AuthorizationRequestId]
      ,CA.[CreatedBy]
      ,CA.[CreatedDate]
      ,CA.[ModifiedBy]
      ,CA.[ModifiedDate]
      ,CA.[RecordDeleted]
      ,CA.[DeletedBy]
      ,CA.[DeletedDate]
      ,CA.[DocumentVersionId]
      ,CA.[BillingCodeId]
      ,CA.[SiteId]
      ,CA.[BillingCodeModifierId]
      ,CA.[ProviderAuthorizationId]
      ,CA.[StartDate]
      ,CA.[EndDate]
      ,CA.[Modifier1]
      ,CA.[Modifier2]
      ,CA.[Modifier3]
      ,CA.[Modifier4]
      ,CA.[Frequency]
      ,CA.[Units]
      ,CA.[TotalUnits]
      ,CA.[Active]
      ,CA.[Appealed]
      ,CA.[Status]
      ,CA.[Urgent]
      ,CA.[Comment]
      ,BC.CodeName AS BillingCodeIdText
      ,GC.CodeName AS StatusText
  FROM [AuthorizationRequests] As CA
  INNER JOIN GlobalCodes GC on GC.GlobalCodeId=CA.[Status] 
  LEFT OUTER JOIN  ProviderAuthorizations As PA On CA.ProviderAuthorizationId=PA.ProviderAuthorizationId                   
  LEFT JOIN BillingCodes BC on BC.BillingCodeId = CA.BillingCodeId  
  LEFT JOIN BillingCodeModifiers BM on BC.BillingCodeId = BM.BillingCodeId
  
  
    
 AND    
   
  case  when len(((rtrim(ltrim(BM.Modifier1))))) = 0 or rtrim(ltrim(BM.Modifier1)) IS NULL then '$' else 
        rtrim(ltrim(BM.Modifier1)) end +
  case  when len(((rtrim(ltrim(BM.Modifier2))))) = 0 or rtrim(ltrim(BM.Modifier2)) IS NULL then '$' else 
        rtrim(ltrim(BM.Modifier2)) end +
  case  when len(((rtrim(ltrim(BM.Modifier3))))) = 0 or rtrim(ltrim(BM.Modifier3)) IS NULL then '$' else 
        rtrim(ltrim(BM.Modifier3)) end +
  case  when len(((rtrim(ltrim(BM.Modifier4))))) = 0 or rtrim(ltrim(BM.Modifier4)) IS NULL then '$' else 
        rtrim(ltrim(BM.Modifier4)) end      
         = 
case  when len(((rtrim(ltrim(CA.Modifier1))))) = 0 or rtrim(ltrim(CA.Modifier1)) IS NULL then '$' else 
        rtrim(ltrim(CA.Modifier1)) end +      
case  when len(((rtrim(ltrim(CA.Modifier2))))) = 0 or rtrim(ltrim(CA.Modifier2)) IS NULL then '$' else 
        rtrim(ltrim(CA.Modifier2)) end +  
case  when len(((rtrim(ltrim(CA.Modifier3))))) = 0 or rtrim(ltrim(CA.Modifier3)) IS NULL then '$' else 
        rtrim(ltrim(CA.Modifier3)) end +  
case  when len(((rtrim(ltrim(CA.Modifier4))))) = 0 or rtrim(ltrim(CA.Modifier4)) IS NULL then '$' else 
        rtrim(ltrim(CA.Modifier4)) end 
         or (isnull(BM.Modifier1,'') = '
' and isnull(BM.Modifier2,'') = '' and isnull(BM.Modifier3,'') = '' and isnull(BM.Modifier4,'') = '')
           
  WHERE ISNull(CA.RecordDeleted,'N')='N' AND DocumentVersionId=@DocumentVersionId  
  
  
  SELECT IR.ImageRecordId
			,IR.CreatedBy
			,IR.CreatedDate
			,IR.ModifiedBy
			,IR.ModifiedDate
			,IR.RecordDeleted
			,IR.DeletedDate
			,IR.DeletedBy
			,IR.ScannedOrUploaded
			,IR.DocumentVersionId
			,IR.ImageServerId
			,IR.ClientId
			,IR.AssociatedId
			,IR.AssociatedWith
			,IR.RecordDescription
			,IR.EffectiveDate
			,IR.NumberOfItems
			,IR.AssociatedWithDocumentId
			,IR.AppealId
			,IR.StaffId
			,IR.EventId
			,IR.ProviderId
			,IR.TaskId
			,IR.AuthorizationDocumentId
			,IR.ScannedBy
			,IR.CoveragePlanId
			,IR.ClientDisclosureId
			,IR.ProviderAuthorizationDocumentId
			,IR.BatchId
			,IR.PaymentId
            ,NULL AS DocumentId --K.Soujanya 20-Sep-2018  
		FROM ImageRecords IR
		WHERE ISNULL(IR.RecordDeleted, 'N') = 'N' 
			AND IR.DocumentVersionId = @DocumentVersionId

  
 /********************************************************************************************************************************************/ 
                                                                                            
 END TRY                                      
                                                      
 BEGIN CATCH                                                          
   DECLARE @Error varchar(8000)                                                                      
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                            
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetDataForAuthorizationRequest')                                                                                             
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                    
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                          
 END CATCH                                                                        
End   

GO


