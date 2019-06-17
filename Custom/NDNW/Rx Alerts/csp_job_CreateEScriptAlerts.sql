 IF EXISTS ( SELECT *
             FROM   sys.objects
             WHERE  object_id = OBJECT_ID(N'csp_job_CreateEScriptAlerts')
                    AND type IN ( N'P' , N'PC' ) ) 
    BEGIN 
                    
        DROP PROCEDURE csp_job_CreateEScriptAlerts
    END 
                    go
                    
 CREATE PROCEDURE csp_job_CreateEScriptAlerts
 AS 
 /*****************************************************************************************************
* Stored Procedure: dbo.csp_job_CreateEScriptAlerts                     
* Creation Date:	11/10/2015
*            
* Created By:		jcarlson
* Purpose:		Create an alert when an electronic script has an error and does not go through 
*            
* Test Call:  Exec dbo.csp_job_CreateEScriptAlerts 
*                                                                                                                                       
* Date		By					Description
* --------	-------------------	--------------------------------------------------------------------
* 11/10/2015	 jcarlson			 Valley SGL 90, creation
*****************************************************************************************************/  
    BEGIN TRY
        DECLARE @errorMessage VARCHAR(MAX)
 
        DECLARE @alertType INTEGER
 
        SELECT  @alertType = gc.GlobalCodeId
        FROM    dbo.GlobalCodes gc
        WHERE   gc.CodeName = 'Electronic Script Error'
                AND gc.Category = 'ALERTTYPE'
                AND ISNULL(gc.RecordDeleted , 'N') = 'N'



        INSERT  INTO dbo.Alerts
                ( ToStaffId
                , ClientId
                , AlertType
                , Unread
                , DateReceived
                , [Subject]
                , [Message]
                , ReferenceLink
                , CreatedBy
                , CreatedDate
                , ModifiedBy
                , ModifiedDate
                )
                SELECT  cms.OrderingPrescriberId
                      , cms.ClientId
                      , @alertType
                      ,  'Y'
                      , GETDATE()
                      , 'Electronic Script Error'
                      , 'The prescription ' + mdmn.MedicationName + ' for client ' + c.LastName + ', ' + c.FirstName + ' has not gone through. Please fax or call the order in.'
                      , CAST(cmsa.ClientMedicationScriptActivityId AS VARCHAR(MAX))
                      , 'E Script Alert Job'
                      , GETDATE()
                      , 'E Script Alert Job'
                      , GETDATE()
                FROM    dbo.ClientMedicationScripts cms
                JOIN    dbo.ClientMedicationScriptActivities cmsa ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
                                                                 AND ISNULL(cmsa.RecordDeleted , 'N') = 'N'
                JOIN    dbo.Clients c ON cms.clientId = c.ClientId
                                         AND ISNULL(c.RecordDeleted , 'N') = 'N'
                JOIN    dbo.ClientMedicationScriptDrugs cmsd ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
                                                            AND ISNULL(cmsd.RecordDeleted , 'N') = 'N'
                JOIN    dbo.ClientMedicationInstructions cmi ON cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                                                            AND ISNULL(cmi.RecordDeleted , 'N') = 'N'
                JOIN    dbo.ClientMedications cm ON cmi.ClientMedicationId = cm.ClientMedicationId
                                                AND ISNULL(cm.RecordDeleted , 'N') = 'N'
                JOIN    dbo.MDMedicationNames mdmn ON cm.MedicationNameId = mdmn.MedicationNameId
                                                  AND ISNULL(mdmn.RecordDeleted , 'N') = 'N'
                WHERE   cmsa.Method = 'E'
                AND ISNULL(cms.RecordDeleted,'N')='N'
                AND CAST(cmsa.CreatedDate AS DATE) >= CAST('11/12/2015' AS Date)
                        AND cmsa.SureScriptsOutgoingMessageId IS NOT NULL
                        AND cmsa.StatusDescription NOT LIKE '%Success%'
                        AND cmsa.StatusDescription NOT LIKE '%Mailbox%'
                        AND cmsa.StatusDescription NOT LIKE '%Pending%'
                        AND NOT EXISTS ( SELECT 1
                                         FROM   dbo.Alerts a
                                         WHERE  a.ReferenceLink = CAST(cmsa.ClientMedicationScriptActivityId AS VARCHAR(MAX))
                                                AND ISNULL(a.RecordDeleted , 'N') = 'N' )
	
    END TRY
    BEGIN CATCH
        SET @errorMessage = ERROR_MESSAGE() + CHAR(13) + ERROR_PROCEDURE()
        RAISERROR                                                                                               
      (                                                               
       @ErrorMessage,  16,   1 
      );      
    END CATCH
    
    GO