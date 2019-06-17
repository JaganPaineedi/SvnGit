IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[csp_SCInitRevokeReleaseofInformation]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[csp_SCInitRevokeReleaseofInformation] 
  END 

GO 

/********************************************************************************                                                    
-- Stored Procedure: csp_SCInitRevokeReleaseofInformation    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose:initialization    
--    
-- Author:  Atul Pandey
-- Date:    17 January 2013  

Modified Date			Modified By			Description
/* 15 Feb 2019 K.Soujanya   Added ClientUnableToGiveWrittenConsent and RevokeROSComments in select statement as per the requirement, Why:New Directions - Enhancements,#22   */ 
*********************************************************************************/ 
CREATE PROCEDURE [csp_SCInitRevokeReleaseofInformation] --897,50062,N'<Root><Parameters ScreenType="I"  CurrentAuthorId="897"   ></Parameters></Root>'
( 
@StaffId          INT, 
@ClientId         INT, 
@CustomParameters XML
) 
AS 
  BEGIN 
      BEGIN TRY 
       SELECT TOP 1 'CustomDocumentRevokeReleaseOfInformations' AS TableName               
         , -1 AS [DocumentVersionId]
		  ,'' AS [CreatedBy]
		  , getDate() AS[CreatedDate]
		  ,'' as [ModifiedBy]
		  ,getdate() AS [ModifiedDate]
		  ,[RecordDeleted]
		  ,[DeletedDate]
		  ,[DeletedBy]
		  ,[ClientInformationReleaseId]
		  ,@StaffId [StaffId]
		  ,getdate() [RevokeEndDate]
		  ,[ClientUnableToGiveWrittenConsent]
		  ,[RevokeROSComments]
  FROM  
systemconfigurations s  
 LEFT OUTER JOIN
  [CustomDocumentRevokeReleaseOfInformations]
 ON s.Databaseversion = -1  


 
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + 
                                  CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + 
                      '*****' + 
                                  isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'csp_SCInitRevokeReleaseofInformation' 
                      ) + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + 
                                  CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + 
                      CONVERT( 
                      VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                                                                    
                      16, 
                      -- Severity.                                                                                                                                                                                                                         
                      1 
          -- State.                                                                                                                                                                                                                                             
          ); 
      END CATCH 
  END 
  
