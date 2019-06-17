IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[csp_InitCustomInvoluntaryServices]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_InitCustomInvoluntaryServices] 

GO 

CREATE PROCEDURE [dbo].[csp_InitCustomInvoluntaryServices] 
-- csp_InitCustomInvoluntaryServices 13,550,null                        
(@ClientID          INT 
 ,@StaffID          INT 
 ,@CustomParameters XML) 
AS 
/***************************************************************************/ 
/* Stored Procedure: [csp_InitCustomInvoluntaryServices]          */ 
/* Creation Date:  05/May/2015                      */ 
/* Author:  Malathi Shiva                     */ 
/* Purpose: To Initialize                          */ 
/* Input Parameters:                            */ 
/* Output Parameters:                            */ 
/* Return:                                  */ 
/* Calls:                                  */ 
/*                        */ 
/* Data Modifications:                   */ 
/*  Modified By    Modified Date    Purpose        */ 
  /*********************************************************************/ 
  BEGIN 
      BEGIN TRY 
          DECLARE @SID VARCHAR(30) 

          SELECT @SID = AIPSIDNumber 
          FROM   CustomClients 
          WHERE  ClientID = @ClientID 
                 AND IsNull(RecordDeleted, 'N') = 'N' 

          --CustomDocumentInvoluntaryServices          
          SELECT TOP 1 Placeholder.TableName 
                       ,ISNULL(CR.DocumentVersionId, -1) AS DocumentVersionId 
                       ,CR.CreatedBy 
                       ,CR.CreatedDate 
                       ,CR.ModifiedBy 
                       ,CR.ModifiedDate 
                       ,CR.RecordDeleted 
                       ,CR.DeletedBy 
                       ,CR.DeletedDate 
                       ,@SID                             AS SIDNumber 
                       ,NULL                             AS ServiceStatus 
                       ,NULL                             AS TypeOfPetition 
                       ,CR.DateOfPetition 
                       ,NULL                             AS HearingRecommended 
                       ,NULL                             AS ReasonForHearing 
                       ,NULL                             AS 
                        BasisForInvoluntaryServices 
                       ,NULL                             AS DispositionByJudge 
                       ,NULL                             AS 
                        InvoluntaryServicesCommitted 
                       ,NULL                             AS 
                        ServiceSettingAssignedTo 
                       ,CR.DateOfCommitment 
                       ,NULL AS  LengthOfCommitment 
                       ,CR.PeriodOfIntensiveTreatment 
          FROM   (SELECT 'CustomDocumentInvoluntaryServices' AS TableName) AS 
                 Placeholder 
                 LEFT JOIN Documents Doc 
                        ON ( Doc.ClientId = @ClientID 
                             AND ISNULL(Doc.RecordDeleted, 'N') <> 'Y' ) 
                 LEFT JOIN DocumentVersions DV 
                        ON ( DV.DocumentId = Doc.DocumentId 
                             AND ISNULL(DV.RecordDeleted, 'N') <> 'Y' ) 
                 LEFT JOIN CustomDocumentInvoluntaryServices CR 
                        ON ( DV.DocumentVersionId = CR.DocumentVersionId 
                             AND ISNULL(CR.RecordDeleted, 'N') <> 'Y' ) 
          ORDER  BY Doc.EffectiveDate DESC 
                    ,Doc.ModifiedDate DESC 
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'csp_InitCustomInvoluntaryServices') 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                                      
                      16, 
                      -- Severity.                                                                                                      
                      1 
          -- State.                                                                                                      
          ); 
      END CATCH 
  END 

GO 