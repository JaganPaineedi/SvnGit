 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CriticalAlertsProcess]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE ssp_CriticalAlertsProcess
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ssp_CriticalAlertsProcess]
AS /* ========================================================================================== 
  Procedure Name :[ssp_CriticalAlertsProcess]
  Purpose : Emails Alerts and Notifications
  Author: PranayBodhu
  Created Date:03/26/2018
  Modifications:
  Date                              Name                                      Purpose
  -06/11/2018                      PranayB                                 Added Alerts for DEExportMessages,DEImportMessages,HL7CPQueueMessages.
 --07/03/2018                      PranayB                                 Added @CriticalAlertSetUpDateTime to get the records from the setup datetime.
-- 07/05/2018                      PranayB                                 Added Custom type.
  =========================================================================================*/

	BEGIN TRY
        DECLARE @ErrorFlag BIT = 0;
        DECLARE @TimeFrame INTEGER = 5;
        DECLARE @TimeFrameFax INTEGER = 10;
        DECLARE @Subject NVARCHAR(MAX) = DB_NAME() + ' Critical Alert';
        DECLARE @Body NVARCHAR(MAX);
        DECLARE @ErrorCount INT = 0 ,
            @MostRecent DATETIME;
        DECLARE @StateError NVARCHAR(MAX);
        DECLARE @StateError1 NVARCHAR(MAX);
   
        DECLARE @MesageNotes NVARCHAR(MAX); 
        DECLARE @TableStart NVARCHAR(MAX) = '<html><body><H3> </H3
                                <table border = 1> 
                                <tr>
                                <th> CriticalAlertProcessID </th> <th> TableName </th> <th> RecordID </th> <th> ErrorMessage </th> <th> Duration </th> </tr>';
        DECLARE @TableEnd NVARCHAR(MAX)= '</table></body></html>';  

        DECLARE @Message NVARCHAR(MAX);
        DECLARE @Message1 NVARCHAR(MAX);
        DECLARE @ClientMedicationScriptActivitiesTableID INT;    
        DECLARE @ClientMedicationFaxActivitiesTableID INT;  
		DECLARE @DEExportMessagesTableID INT;
		DECLARE @DEImportMessagesTableID INT;  
	    DECLARE @HL7CPQueueMessagesTableID INT;
        DECLARE @ProcessedDate DATETIME;   
        DECLARE @NotificaionMessage NVARCHAR(MAX)  = NULL;
        DECLARE @ToRecipients VARCHAR(MAX);
        DECLARE @CCRecipients VARCHAR(MAX);
	    DECLARE @CriticalAlertSetUpDateTime DATETIME;
        CREATE TABLE #TempCritalAlerts
            (
              CriticalAlertProcessID int IDENTITY(1,1) ,
              TableName VARCHAR(100) ,
              RecordID VARCHAR(100) ,
              ErrorMessage VARCHAR(max) ,
              Duration VARCHAR(100)
            );
        SET @ErrorFlag = 1;

        SELECT  @ClientMedicationScriptActivitiesTableID = object_id
        FROM    sys.tables
        WHERE   name = 'ClientMedicationScriptActivities';

		SELECT @ClientMedicationFaxActivitiesTableID=object_id
        FROM    sys.tables
        WHERE   name = 'ClientMedicationFaxActivities'


		SELECT @DEExportMessagesTableID=  object_id
        FROM    sys.tables
        WHERE   name = 'DEExportMessages'

		SELECT @DEImportMessagesTableID= object_id
        FROM    sys.tables
        WHERE   name = 'DEImportMessages'

		SELECT @HL7CPQueueMessagesTableID=  object_id
        FROM    sys.tables
        WHERE   name = 'HL7CPQueueMessages'

        SELECT  @ToRecipients = Value
        FROM    dbo.SystemConfigurationKeys
        WHERE   [Key] = 'CriticalAlertToRecipients'
                AND ISNULL(RecordDeleted, 'N') = 'N';
        SELECT  @CCRecipients = Value
        FROM    dbo.SystemConfigurationKeys
        WHERE   [Key] = 'CriticalAlertCCRecipients'
                AND ISNULL(RecordDeleted, 'N') = 'N';
      
       SELECT   @CriticalAlertSetUpDateTime =  CONVERT(DATETIME,Value) 
       FROM     dbo.SystemConfigurationKeys
       WHERE    [Key] = 'CriticalAlertSetUpDateTime'
                AND ISNULL(RecordDeleted, 'N') = 'N';

        DECLARE @errorMessage VARCHAR(MAX);
	  
        DECLARE @temp_CriticalAlertsProcess TABLE
            (
              ProcessId VARCHAR(MAX) ,
              TableId VARCHAR(MAX) ,
              AlertType CHAR(35)
            );
        DECLARE @temp_NotificationAlertsProcess TABLE
            (
              ProcessId INTEGER ,
              TableId VARCHAR(MAX) ,
              ProcessedDate DATETIME
            );
        INSERT  INTO @temp_CriticalAlertsProcess -- Insert all  Alert Scripts for every Activity.
                ( ProcessId ,
                  TableId ,
                  AlertType
                )
                SELECT  csa.ClientMedicationScriptActivityId ,
                        @ClientMedicationScriptActivitiesTableID ,
                        'Critical-ELE'
                FROM    dbo.ClientMedicationScriptActivities AS csa
                        LEFT JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = csa.ClientMedicationScriptActivityId
                WHERE   csa.CreatedDate <= DATEADD(MINUTE, -@TimeFrame,
                                                   GETDATE())
                        AND ISNULL(csa.StatusDescription, '') = ''
                        AND csa.Status IN ( 5561, 5562 )
                        AND csa.SureScriptsOutgoingMessageId IS NULL
                        AND csa.Method = 'E'
                        AND ISNULL(csa.RecordDeleted, 'N') = 'N'
                        AND cap.ProcessId IS NULL
                        AND ISNULL(cap.RecordDeleted, 'N') = 'N'
						AND csa.CreatedDate >= @CriticalAlertSetUpDateTime
                UNION
                SELECT  csa.ClientMedicationScriptActivityId ,
                        @ClientMedicationScriptActivitiesTableID ,
                        'Critical-FAX'
                FROM    dbo.ClientMedicationScriptActivities AS csa
                        LEFT JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = csa.ClientMedicationScriptActivityId
                                                              AND cap.TableId = CONVERT(VARCHAR(100), @ClientMedicationScriptActivitiesTableID)
                WHERE   csa.CreatedDate <= DATEADD(MINUTE, -@TimeFrameFax,
                                                   GETDATE())
                        AND ISNULL(csa.FaxExternalIdentifier, '') = ''
                        AND csa.Method = 'F'
                        AND ISNULL(csa.RecordDeleted, 'N') = 'N'
                        AND cap.ProcessId IS NULL
                        AND ISNULL(cap.RecordDeleted, 'N') = 'N'
						AND csa.CreatedDate>= @CriticalAlertSetUpDateTime
                UNION
                SELECT  csa.ClientMedicationFaxActivityId ,
                        @ClientMedicationFaxActivitiesTableID ,
                        'Critical-FAX'
                FROM    dbo.ClientMedicationFaxActivities AS csa
                        LEFT JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = csa.ClientMedicationFaxActivityId
                                                              AND cap.TableId = CONVERT(VARCHAR(100), @ClientMedicationFaxActivitiesTableID)
                WHERE   csa.CreatedDate <= DATEADD(MINUTE, -@TimeFrameFax,
                                                   GETDATE())
                        AND ISNULL(csa.FaxExternalIdentifier, '') = ''
                        AND ISNULL(csa.RecordDeleted, 'N') = 'N'
                        AND cap.ProcessId IS NULL
                        AND ISNULL(cap.RecordDeleted, 'N') = 'N'
                        AND csa.CreatedDate >= @CriticalAlertSetUpDateTime
				UNION

                SELECT  deeMessage.DEExportMessageId ,
                        @DEExportMessagesTableID ,
                        'Critical-DEExport'
                FROM    dbo.DEExportMessages deeMessage
				LEFT JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = deeMessage.DEExportMessageId
                                                              AND cap.TableId = CONVERT(VARCHAR(100), @DEExportMessagesTableID)
                WHERE   deeMessage.[Status] NOT IN (8256,8257,8258,8259)  
                        AND deeMessage.CreatedDate <= DATEADD(MINUTE,
                                                              -@TimeFrame,
                                                              GETDATE())
                        AND ISNULL(deeMessage.RecordDeleted, 'N') = 'N'
						   AND cap.ProcessId IS NULL
						   AND deeMessage.CreatedDate >=@CriticalAlertSetUpDateTime
                UNION
                SELECT  deIMessage.DEImportMessageId ,
                        @DEImportMessagesTableID ,
                        'Critical-DEImport'
                FROM    dbo.DEImportMessages deIMessage
				LEFT JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = deIMessage.DEImportMessageId
                                                              AND cap.TableId = CONVERT(VARCHAR(100), @DEImportMessagesTableID)
                WHERE   deIMessage.[Status] NOT IN (8256,8257,8258,8259)  
                        AND deIMessage.CreatedDate <= DATEADD(MINUTE,
                                                              -@TimeFrame,
                                                              GETDATE())
                        AND ISNULL(deIMessage.RecordDeleted, 'N') = 'N'
						  AND cap.ProcessId IS NULL
						  AND deIMessage.CreatedDate >= @CriticalAlertSetUpDateTime
				UNION
				
						
                SELECT  HL.HL7CPQueueMessageID ,
                        @HL7CPQueueMessagesTableID ,
                        'Critical-HL7CP'
                FROM    HL7CPQueueMessages HL
					LEFT JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = Hl.HL7CPQueueMessageID
                                                              AND cap.TableId = CONVERT(VARCHAR(100), @HL7CPQueueMessagesTableID)
                WHERE   HL.MessageStatus NOT IN (8611,8612) 
                        AND HL.CreatedDate <= DATEADD(MINUTE, -@TimeFrame,
                                                      GETDATE())
                        AND ISNULL(HL.RecordDeleted, 'N') = 'N'
						AND cap.ProcessId IS NULL AND HL.CreatedDate>=@CriticalAlertSetUpDateTime

				 UNION

                 SELECT CriticalAlertsProcessId ,
                        TableId ,
                        'Custom'
                 FROM   dbo.CriticalAlertsProcess
                 WHERE  AlertType = 'Custom'
                        AND ISNULL(RecordDeleted, 'N') = 'N'
                        AND ISNULL(Sent, 'N') = 'N'		
						;

        INSERT  INTO @temp_NotificationAlertsProcess
                ( ProcessId ,
                  TableId ,
                  ProcessedDate
                )
                SELECT  csa.ClientMedicationScriptActivityId ,
                        CONVERT(VARCHAR(MAX), @ClientMedicationScriptActivitiesTableID) ,
                        csa.ModifiedDate
                FROM    dbo.ClientMedicationScriptActivities AS csa
                        JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = csa.ClientMedicationScriptActivityId
                                                              AND csa.SureScriptsOutgoingMessageId IS NOT NULL
                                                              AND csa.StatusDescription LIKE '%Success%'
                                                              AND ISNULL(csa.RecordDeleted,
                                                              'N') = 'N'
                                                              AND ISNULL(cap.Processed,
                                                              'N') = 'N'
                                                              AND csa.Method = 'E'
                                                              AND cap.TableId = CONVERT(VARCHAR(100), @ClientMedicationScriptActivitiesTableID)
                UNION
                SELECT  csa.ClientMedicationScriptActivityId ,
                        CONVERT(VARCHAR(MAX), @ClientMedicationScriptActivitiesTableID) ,
                        csa.ModifiedDate
                FROM    dbo.ClientMedicationScriptActivities AS csa
                        JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = csa.ClientMedicationScriptActivityId
                                                              AND ISNULL(csa.RecordDeleted,
                                                              'N') = 'N'
                                                              AND ISNULL(cap.Processed,
                                                              'N') = 'N'
                                                              AND csa.Method = 'F'
                                                              AND cap.TableId = CAST(@ClientMedicationScriptActivitiesTableID AS VARCHAR(100))
                                                              AND ISNULL(csa.FaxExternalIdentifier,
                                                              '') <> ''
                UNION
                SELECT  cfa.ClientMedicationFaxActivityId ,
                        CONVERT(VARCHAR(MAX), @ClientMedicationFaxActivitiesTableID) ,
                        cfa.ModifiedDate
                FROM    dbo.ClientMedicationFaxActivities cfa
                        JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = cfa.ClientMedicationFaxActivityId
                                                              AND ISNULL(cfa.RecordDeleted,
                                                              'N') = 'N'
                                                              AND ISNULL(cap.Processed,
                                                              'N') = 'N'
                                                              AND cap.TableId = CAST(@ClientMedicationFaxActivitiesTableID AS VARCHAR(100))
                                                              AND ISNULL(cfa.FaxExternalIdentifier,
                                                              '') <> ''
                UNION

                SELECT  deeMessage.DEExportMessageId ,
                        CONVERT(VARCHAR(MAX), @DEExportMessagesTableID) ,
                        deeMessage.ModifiedDate
                FROM    dbo.DEExportMessages deeMessage
                        JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = deeMessage.DEExportMessageId
                WHERE   deeMessage.[Status] IN (8256,8257,8258,8259)  
                        AND ISNULL(deeMessage.RecordDeleted, 'N') = 'N'
                        AND ISNULL(cap.Processed, 'N') = 'N'
                        AND cap.TableId = CAST(@DEExportMessagesTableID AS VARCHAR(100))
                UNION

                SELECT  deIMessage.DEImportMessageId ,
                        CONVERT(VARCHAR(MAX), @DEImportMessagesTableID) ,
                        deIMessage.ModifiedDate
                FROM    dbo.DEImportMessages deIMessage
                        JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = deIMessage.DEImportMessageId
                WHERE   deIMessage.[Status] IN (8256,8257,8258,8259)
                        AND ISNULL(deIMessage.RecordDeleted, 'N') = 'N'
                        AND ISNULL(cap.Processed, 'N') = 'N'
                        AND cap.TableId = CAST(@DEImportMessagesTableID AS VARCHAR(100))
                UNION

                SELECT  HL.HL7CPQueueMessageID ,
                        CONVERT(VARCHAR(MAX), @HL7CPQueueMessagesTableID) ,
                        HL.ModifiedDate
                FROM    HL7CPQueueMessages HL
                        JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = HL.HL7CPQueueMessageID
                WHERE   HL.MessageStatus  IN (8611,8612)
                        AND ISNULL(HL.RecordDeleted, 'N') = 'N'
                        AND ISNULL(cap.Processed, 'N') = 'N'
                        AND cap.TableId = CAST(@HL7CPQueueMessagesTableID AS VARCHAR(100))
						
						;
						

   BEGIN Try
     BEGIN TRANSACTION;
        INSERT  INTO dbo.CriticalAlertsProcess
                ( ProcessId ,
                  TableId ,
                  ErrorDescription ,
                  AlertType
                )
                SELECT  tp.ProcessId ,
                        tp.TableId ,
                        'Pending' ,
                       tp.AlertType
                FROM    @temp_CriticalAlertsProcess tp
				WHERE tp.AlertType<>'Custom';
				COMMIT TRANSACTION;
	END TRY
	     BEGIN CATCH
         ROLLBACK TRANSACTION
	END CATCH


 /*-------------------------CRITICAL CUSTOM ALERT EMAIL  BEGINS---------------------------------------*/

	   IF EXISTS ( SELECT TOP 1
                            ProcessId
                    FROM    @temp_CriticalAlertsProcess
                    WHERE   AlertType = 'Custom' )
            BEGIN
                SET @MesageNotes = 'Critical Alert.';
                INSERT  INTO #TempCritalAlerts
                         ( TableName ,
                          RecordID ,
                          ErrorMessage ,
                          Duration
		                )
                        SELECT
                                'CriticalAlertsProcess' ,
                                CAST(tp.ProcessId AS NVARCHAR(MAX)) ,
                                cap.ErrorDescription ,
                                CONVERT(VARCHAR(max),cap.CreatedDate)
                        FROM    @temp_CriticalAlertsProcess tp
                                JOIN dbo.CriticalAlertsProcess cap ON cap.CriticalAlertsProcessId = tp.ProcessId
                        WHERE   tp.AlertType = 'Custom'
                                AND ISNULL(cap.RecordDeleted, 'N') = 'N'
                                AND ISNULL(cap.Processed, 'N') = 'N'
                                AND ISNULL(cap.Sent, 'N') = 'N';
                         
                SELECT  @Message = CAST(( SELECT    CriticalAlertProcessID AS 'td' ,
                                                    '' ,
                                                    TableName AS 'td' ,
                                                    '' ,
                                                    RecordID AS 'td' ,
                                                    '' ,
                                                    ErrorMessage AS 'td' ,
                                                    '' ,
                                                    Duration AS 'td'
                                          FROM      #TempCritalAlerts
                                          ORDER BY  CriticalAlertProcessID
                                        FOR
                                          XML PATH('tr') ,
                                              ELEMENTS
                                        ) AS NVARCHAR(MAX));
             
                SET @Body = @MesageNotes + @TableStart + @Message + @TableEnd;

                IF ( ISNULL(@ToRecipients, '') != ''
                     AND ISNULL(@CCRecipients, '') != ''
                   )
                    BEGIN
                        EXEC msdb..sp_send_dbmail @recipients = @ToRecipients, -- varchar(max)
                            @copy_recipients = @CCRecipients, -- varchar(max)
                            @subject = @Subject, -- nvarchar(255)
                            @body = @Body, -- nvarchar(max)
                            @body_format = 'html';

				
                        UPDATE  dbo.CriticalAlertsProcess
                        SET     CriticalAlertsProcess.[Sent] = 'Y',ModifiedBy='CriticalJob',ModifiedDate=GETDATE()
                        FROM    @temp_CriticalAlertsProcess
                        WHERE   CriticalAlertsProcess.CriticalAlertsProcessId = [@temp_CriticalAlertsProcess].ProcessId
                                AND [@temp_CriticalAlertsProcess].AlertType = 'Custom';;
                    END;		
                TRUNCATE TABLE  #TempCritalAlerts;
            END;	


 /*-------------------------CRITICAL CUSTOM ALERT EMAIL  BEGINS---------------------------------------*/

  /*-------------------------CRITICAL ELECTRONIC ALERT EMAIL  BEGINS---------------------------------------*/
        IF EXISTS ( SELECT TOP 1
                            ProcessId
                    FROM    @temp_CriticalAlertsProcess
                    WHERE   AlertType = 'Critical-ELE' )
            BEGIN
                SET @MesageNotes = 'Critical Alert For Electronic Scripts.';
                INSERT  INTO #TempCritalAlerts
                        (-- CriticalAlertProcessID ,
                          TableName ,
                          RecordID ,
                          ErrorMessage ,
                          Duration
		                )
                        SELECT -- CONVERT(VARCHAR(MAX), ROW_NUMBER() OVER ( ORDER BY ( SELECT
                                                           --   1
                                                           --   ) )) ,
                                'ClientMedicationScriptActivities' ,
                                CAST(tp.ProcessId AS NVARCHAR(MAX)) ,
                                'Pending' ,
                                CONVERT(NVARCHAR(MAX), DATEDIFF(mi,
                                                              csa.CreatedDate,
                                                              GETDATE()))
                        FROM    @temp_CriticalAlertsProcess tp
                                JOIN dbo.ClientMedicationScriptActivities csa ON csa.ClientMedicationScriptActivityId = tp.ProcessId
                                JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = tp.ProcessId
                        WHERE   tp.AlertType = 'Critical-ELE'
                                AND ISNULL(cap.RecordDeleted, 'N') = 'N'
                                AND ISNULL(cap.Processed, 'N') = 'N'
                                AND ISNULL(cap.Sent, 'N') = 'N';
                                     
                SELECT  @Message = CAST(( SELECT    CriticalAlertProcessID AS 'td' ,
                                                    '' ,
                                                    TableName AS 'td' ,
                                                    '' ,
                                                    RecordID AS 'td' ,
                                                    '' ,
                                                    ErrorMessage AS 'td' ,
                                                    '' ,
                                                    Duration AS 'td'
                                          FROM      #TempCritalAlerts
                                          ORDER BY  CriticalAlertProcessID
                                        FOR
                                          XML PATH('tr') ,
                                              ELEMENTS
                                        ) AS NVARCHAR(MAX));
             
                SET @Body = @MesageNotes + @TableStart + @Message + @TableEnd;

                IF ( ISNULL(@ToRecipients, '') != ''
                     AND ISNULL(@CCRecipients, '') != ''
                   )
                    BEGIN
                        EXEC msdb..sp_send_dbmail @recipients = @ToRecipients, -- varchar(max)
                            @copy_recipients = @CCRecipients, -- varchar(max)
                            @subject = @Subject, -- nvarchar(255)
                            @body = @Body, -- nvarchar(max)
                            @body_format = 'html';

				
                        UPDATE  dbo.CriticalAlertsProcess
                        SET     CriticalAlertsProcess.[Sent] = 'Y'
                        FROM    @temp_CriticalAlertsProcess
                        WHERE   CriticalAlertsProcess.ProcessId = [@temp_CriticalAlertsProcess].ProcessId
                                AND [@temp_CriticalAlertsProcess].AlertType = 'Critical-ELE';;
                    END;		
                TRUNCATE TABLE  #TempCritalAlerts;
            END;	
			  
/*-------------------------CRITICAL ELECTONIC ALERT EMAIL  ENDS---------------------------------------*/   

/*-------------------------CRITICAL FAX ALERT EMAIL  BEGIN---------------------------------------*/   

        IF EXISTS ( SELECT TOP 1
                            ProcessId
                    FROM    @temp_CriticalAlertsProcess
                    WHERE   AlertType = 'Critical-FAX' )
            BEGIN
		
                IF EXISTS ( SELECT TOP 1
                                    ProcessId
                            FROM    @temp_CriticalAlertsProcess
                            WHERE   TableId = CONVERT(VARCHAR(100), @ClientMedicationScriptActivitiesTableID)
                                    AND AlertType = 'Critical-FAX' )
                    BEGIN 
			  
                        INSERT  INTO #TempCritalAlerts
                                ( --CriticalAlertProcessID ,
                                  TableName ,
                                  RecordID ,
                                  ErrorMessage ,
                                  Duration
				                )   
                                SELECT -- CONVERT(VARCHAR(MAX), ROW_NUMBER() OVER ( ORDER BY ( SELECT
                                                --              1
                                                --              ) )) ,
                                        'ClientMedicationScriptActivities' ,
                                        CAST(tp.ProcessId AS NVARCHAR(MAX)) ,
                                        'Pending' ,
                                        CONVERT(NVARCHAR(MAX), DATEDIFF(mi,
                                                              csa.CreatedDate,
                                                              GETDATE()))
                                FROM    @temp_CriticalAlertsProcess tp
                                        JOIN dbo.ClientMedicationScriptActivities csa ON csa.ClientMedicationScriptActivityId = tp.ProcessId
                                        JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = tp.ProcessId
                                WHERE   tp.AlertType = 'Critical-FAX'
                                        AND tp.TableId = CONVERT(VARCHAR(MAX), @ClientMedicationScriptActivitiesTableID)
                                        AND ISNULL(cap.RecordDeleted, 'N') = 'N'
                                        AND ISNULL(cap.Processed, 'N') = 'N'
                                        AND ISNULL(cap.Sent, 'N') = 'N';
                                   
                        SELECT  @Message = CAST(( SELECT    CriticalAlertProcessID AS 'td' ,
                                                            '' ,
                                                            TableName AS 'td' ,
                                                            '' ,
                                                            RecordID AS 'td' ,
                                                            '' ,
                                                            ErrorMessage AS 'td' ,
                                                            '' ,
                                                            Duration AS 'td'
                                                  FROM      #TempCritalAlerts
                                                  ORDER BY  CriticalAlertProcessID ASC
                                                FOR
                                                  XML PATH('tr') ,
                                                      ELEMENTS
                                                ) AS NVARCHAR(MAX));

                        SET @MesageNotes = 'Critical Alert For Fax Scripts.';
                        SET @Body = @MesageNotes + @TableStart + @Message + @TableEnd;  
                        IF ( ISNULL(@ToRecipients, '') != ''
                             AND ISNULL(@CCRecipients, '') != ''
                           )
                            BEGIN
                                EXEC msdb..sp_send_dbmail @recipients = @ToRecipients, -- varchar(max)
                                    @copy_recipients = @CCRecipients, -- varchar(max)
                                    @subject = @Subject, -- nvarchar(255)
                                    @body = @Body, -- nvarchar(max)
                                    @body_format = 'html';

				
                                UPDATE  dbo.CriticalAlertsProcess
                                SET     CriticalAlertsProcess.[Sent] = 'Y'
                                FROM    @temp_CriticalAlertsProcess
                                WHERE   CriticalAlertsProcess.ProcessId = [@temp_CriticalAlertsProcess].ProcessId
                                        AND [@temp_CriticalAlertsProcess].AlertType = 'Critical-FAX';
                            END;		
                        TRUNCATE TABLE #TempCritalAlerts;
		
                    END; 
                IF EXISTS ( SELECT TOP 1
                                    ProcessId
                            FROM    @temp_CriticalAlertsProcess
                            WHERE   TableId = CONVERT(VARCHAR(100), @ClientMedicationFaxActivitiesTableID) )
                    BEGIN 
                        INSERT  INTO #TempCritalAlerts
                                ( --CriticalAlertProcessID ,
                                  TableName ,
                                  RecordID ,
                                  ErrorMessage ,
                                  Duration
					            )
                                SELECT -- CONVERT(VARCHAR(MAX), ROW_NUMBER() OVER ( ORDER BY ( SELECT
                                                  --            1
                                                  --            ) )) ,
                                        'ClientMedicationFaxActivities' ,
                                        CAST(tp.ProcessId AS NVARCHAR(MAX)) ,
                                        'Pending' ,
                                        CONVERT(NVARCHAR(MAX), DATEDIFF(mi,
                                                              csa.CreatedDate,
                                                              GETDATE()))
                                FROM    @temp_CriticalAlertsProcess tp
                                        JOIN dbo.ClientMedicationFaxActivities csa ON csa.ClientMedicationFaxActivityId = tp.ProcessId
                                        JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = tp.ProcessId
                                WHERE   tp.AlertType = 'Critical-FAX'
                                        AND tp.TableId = CONVERT(VARCHAR(MAX), @ClientMedicationFaxActivitiesTableID)
                                        AND ISNULL(cap.RecordDeleted, 'N') = 'N'
                                        AND ISNULL(cap.Processed, 'N') = 'N'
                                        AND ISNULL(cap.Sent, 'N') = 'N' ;
                                  
                                      
                        SELECT  @Message = CAST(( SELECT    CriticalAlertProcessID AS 'td' ,
                                                            '' ,
                                                            TableName AS 'td' ,
                                                            '' ,
                                                            RecordID AS 'td' ,
                                                            '' ,
                                                            ErrorMessage AS 'td' ,
                                                            '' ,
                                                            Duration AS 'td'
                                                  FROM      #TempCritalAlerts
                                                  ORDER BY  CriticalAlertProcessID
                                                FOR
                                                  XML PATH('tr') ,
                                                      ELEMENTS
                                                ) AS NVARCHAR(MAX));
             
                        SET @MesageNotes = 'Critical Alert For Fax Scripts.';
                        SET @Body = @MesageNotes + @TableStart + @Message + @TableEnd;
						  
                        IF ( ISNULL(@ToRecipients, '') != ''
                             AND ISNULL(@CCRecipients, '') != ''
                           )
                            BEGIN
                                EXEC msdb..sp_send_dbmail @recipients = @ToRecipients, -- varchar(max)
                                    @copy_recipients = @CCRecipients, -- varchar(max)
                                    @subject = @Subject, -- nvarchar(255)
                                    @body = @Body, -- nvarchar(max)
                                    @body_format = 'html';

                                UPDATE  dbo.CriticalAlertsProcess
                                SET     CriticalAlertsProcess.[Sent] = 'Y'
                                FROM    @temp_CriticalAlertsProcess
                                WHERE   CriticalAlertsProcess.ProcessId = [@temp_CriticalAlertsProcess].ProcessId
                                        AND [@temp_CriticalAlertsProcess].AlertType = 'Critical-FAX'
                                        AND CriticalAlertsProcess.TableId = CONVERT(VARCHAR(100), @ClientMedicationFaxActivitiesTableID);
                            END;
							
                       TRUNCATE TABLE #TempCritalAlerts;
		
                    END;
             
            END;

/*-------------------------CRITICAL FAX ALERT EMAIL  END---------------------------------------*/     

/*----------------------------CRITICAL DEEXPORT ALERT EMAIL BEGINS---------------------------------------------------------------------*/


 IF EXISTS ( SELECT TOP 1
                            ProcessId
                    FROM    @temp_CriticalAlertsProcess
                    WHERE   AlertType = 'Critical-DEExport' )
            BEGIN
                SET @MesageNotes = 'Critical Alert For DEExportMessages.';
                INSERT  INTO #TempCritalAlerts
                        (-- CriticalAlertProcessID ,
                          TableName ,
                          RecordID ,
                          ErrorMessage ,
                          Duration
		                )
                        SELECT 
                                'DEExportMessages' ,
                                CAST(tp.ProcessId AS NVARCHAR(MAX)) ,
                                'Pending' ,
                                CONVERT(NVARCHAR(MAX), DATEDIFF(mi,
                                                              csa.CreatedDate,
                                                              GETDATE()))
                        FROM    @temp_CriticalAlertsProcess tp
                                JOIN dbo.DEExportMessages csa ON csa.DEExportMessageId = tp.ProcessId
                                JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = tp.ProcessId
                        WHERE   tp.AlertType = 'Critical-DEExport'
                                AND ISNULL(cap.RecordDeleted, 'N') = 'N'
                                AND ISNULL(cap.Processed, 'N') = 'N'
                                AND ISNULL(cap.Sent, 'N') = 'N';
                                     
                SELECT  @Message = CAST(( SELECT    CriticalAlertProcessID AS 'td' ,
                                                    '' ,
                                                    TableName AS 'td' ,
                                                    '' ,
                                                    RecordID AS 'td' ,
                                                    '' ,
                                                    ErrorMessage AS 'td' ,
                                                    '' ,
                                                    Duration AS 'td'
                                          FROM      #TempCritalAlerts
                                          ORDER BY  CriticalAlertProcessID
                                        FOR
                                          XML PATH('tr') ,
                                              ELEMENTS
                                        ) AS NVARCHAR(MAX));
             
                SET @Body = @MesageNotes + @TableStart + @Message + @TableEnd;

                IF ( ISNULL(@ToRecipients, '') != ''
                     AND ISNULL(@CCRecipients, '') != ''
                   )
                    BEGIN
                        EXEC msdb..sp_send_dbmail @recipients = @ToRecipients, -- varchar(max)
                            @copy_recipients = @CCRecipients, -- varchar(max)
                            @subject = @Subject, -- nvarchar(255)
                            @body = @Body, -- nvarchar(max)
                            @body_format = 'html';

				
                        UPDATE  dbo.CriticalAlertsProcess
                        SET     CriticalAlertsProcess.[Sent] = 'Y'
                        FROM    @temp_CriticalAlertsProcess
                        WHERE   CriticalAlertsProcess.ProcessId = [@temp_CriticalAlertsProcess].ProcessId
                                AND [@temp_CriticalAlertsProcess].AlertType = 'Critical-DEExport';
                    END;		
                TRUNCATE TABLE  #TempCritalAlerts;
            END;	
			  

/*-----------------------------CRICAL ALERT DEEXPORT EMAIL END--------------*/



/*-----------------------------CRITICAL ALERT DEIMPORT EMAIL START---------------*/

 IF EXISTS ( SELECT TOP 1
                            ProcessId
                    FROM    @temp_CriticalAlertsProcess
                    WHERE   AlertType = 'Critical-DEImport' )
            BEGIN
                SET @MesageNotes = 'Critical Alert For DEImportMessages.';
                INSERT  INTO #TempCritalAlerts
                        (-- CriticalAlertProcessID ,
                          TableName ,
                          RecordID ,
                          ErrorMessage ,
                          Duration
		                )
                        SELECT 
                                'DEImportMessages' ,
                                CAST(tp.ProcessId AS NVARCHAR(MAX)) ,
                                'Pending' ,
                                CONVERT(NVARCHAR(MAX), DATEDIFF(mi,
                                                              csa.CreatedDate,
                                                              GETDATE()))
                        FROM    @temp_CriticalAlertsProcess tp
                                JOIN dbo.DEImportMessages csa ON csa.DEImportMessageId = tp.ProcessId
                                JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = tp.ProcessId
                        WHERE   tp.AlertType = 'Critical-DEImport'
                                AND ISNULL(cap.RecordDeleted, 'N') = 'N'
                                AND ISNULL(cap.Processed, 'N') = 'N'
                                AND ISNULL(cap.Sent, 'N') = 'N';
                                     
                SELECT  @Message = CAST(( SELECT    CriticalAlertProcessID AS 'td' ,
                                                    '' ,
                                                    TableName AS 'td' ,
                                                    '' ,
                                                    RecordID AS 'td' ,
                                                    '' ,
                                                    ErrorMessage AS 'td' ,
                                                    '' ,
                                                    Duration AS 'td'
                                          FROM      #TempCritalAlerts
                                          ORDER BY  CriticalAlertProcessID
                                        FOR
                                          XML PATH('tr') ,
                                              ELEMENTS
                                        ) AS NVARCHAR(MAX));
             
                SET @Body = @MesageNotes + @TableStart + @Message + @TableEnd;

                IF ( ISNULL(@ToRecipients, '') != ''
                     AND ISNULL(@CCRecipients, '') != ''
                   )
                    BEGIN
                        EXEC msdb..sp_send_dbmail @recipients = @ToRecipients, -- varchar(max)
                            @copy_recipients = @CCRecipients, -- varchar(max)
                            @subject = @Subject, -- nvarchar(255)
                            @body = @Body, -- nvarchar(max)
                            @body_format = 'html';

				
                        UPDATE  dbo.CriticalAlertsProcess
                        SET     CriticalAlertsProcess.[Sent] = 'Y'
                        FROM    @temp_CriticalAlertsProcess
                        WHERE   CriticalAlertsProcess.ProcessId = [@temp_CriticalAlertsProcess].ProcessId
                                AND [@temp_CriticalAlertsProcess].AlertType = 'Critical-DEImport';
                    END;		
                TRUNCATE TABLE  #TempCritalAlerts;
            END;	
			  

/*-----------------------------------------CRITICAL ALERT DEIMPORT END --------------------------------------------------*/


/*-----------------------------------------CRITICAL ALERT HL7CPQueueMessages START---------------------------------------*/


 IF EXISTS ( SELECT TOP 1
                            ProcessId
                    FROM    @temp_CriticalAlertsProcess
                    WHERE   AlertType = 'Critical-HL7CP' )
            BEGIN
                SET @MesageNotes = 'Critical Alert For HL7CPQueueMessages.';
                INSERT  INTO #TempCritalAlerts
                         ( TableName ,
                          RecordID ,
                          ErrorMessage ,
                          Duration
		                )
                        SELECT 
                                'HL7CPQueueMessages' ,
                                CAST(tp.ProcessId AS NVARCHAR(MAX)) ,
                                'Pending' ,
                                CONVERT(NVARCHAR(MAX), DATEDIFF(mi,
                                                              csa.CreatedDate,
                                                              GETDATE()))
                        FROM    @temp_CriticalAlertsProcess tp
                                JOIN dbo.HL7CPQueueMessages csa ON csa.HL7CPQueueMessageID = tp.ProcessId
                                JOIN dbo.CriticalAlertsProcess cap ON cap.ProcessId = tp.ProcessId
                        WHERE   tp.AlertType = 'Critical-HL7CP'
                                AND ISNULL(cap.RecordDeleted, 'N') = 'N'
                                AND ISNULL(cap.Processed, 'N') = 'N'
                                AND ISNULL(cap.Sent, 'N') = 'N';
                                     
                SELECT  @Message = CAST(( SELECT    CriticalAlertProcessID AS 'td' ,
                                                    '' ,
                                                    TableName AS 'td' ,
                                                    '' ,
                                                    RecordID AS 'td' ,
                                                    '' ,
                                                    ErrorMessage AS 'td' ,
                                                    '' ,
                                                    Duration AS 'td'
                                          FROM      #TempCritalAlerts
                                          ORDER BY  CriticalAlertProcessID
                                        FOR
                                          XML PATH('tr') ,
                                              ELEMENTS
                                        ) AS NVARCHAR(MAX));
             
                SET @Body = @MesageNotes + @TableStart + @Message + @TableEnd;

                IF ( ISNULL(@ToRecipients, '') != ''
                     AND ISNULL(@CCRecipients, '') != ''
                   )
                    BEGIN
                        EXEC msdb..sp_send_dbmail @recipients = @ToRecipients, -- varchar(max)
                            @copy_recipients = @CCRecipients, -- varchar(max)
                            @subject = @Subject, -- nvarchar(255)
                            @body = @Body, -- nvarchar(max)
                            @body_format = 'html';

				
                        UPDATE  dbo.CriticalAlertsProcess
                        SET     CriticalAlertsProcess.[Sent] = 'Y'
                        FROM    @temp_CriticalAlertsProcess
                        WHERE   CriticalAlertsProcess.ProcessId = [@temp_CriticalAlertsProcess].ProcessId
                                AND [@temp_CriticalAlertsProcess].AlertType = 'Critical-HL7CP';
                    END;		
                TRUNCATE TABLE  #TempCritalAlerts;
            END;	


/*-----------------------------------------CRITICAL ALERT HL7CPQueueMessages END---------------------------------------*/


/*-------------------------Notification ELECTONIC ALERT EMAIL  BEGINS---------------------------------------*/     

        IF EXISTS ( SELECT TOP 1
                            ProcessId
                    FROM    @temp_NotificationAlertsProcess )
            BEGIN
                SELECT  @NotificaionMessage = 'The Following Scripts-'
                        + REPLACE(STUFF(( SELECT    ',TableName: '
						                           + CAST(st.name AS VARCHAR(MAX))
                                                    + CAST(ProcessId AS VARCHAR(MAX))
                                                    + ' got processed at '
                                                    + CAST(ProcessedDate AS VARCHAR(MAX))
                                          FROM      @temp_NotificationAlertsProcess tmp
										  JOIN     sys.tables st ON st.object_id=CAST(TableId AS INT)
                                        FOR
                                          XML PATH('')
                                        ), 1, 1, ''), ',', CHAR(13) + CHAR(10))
                FROM    @temp_NotificationAlertsProcess;
                   
                SET @Subject = DB_NAME() + 'Notification';
                IF ( ISNULL(@ToRecipients, '') != ''
                     AND ISNULL(@CCRecipients, '') != ''
                   )
                    BEGIN    
                        EXEC msdb..sp_send_dbmail @recipients = @ToRecipients, -- varchar(max)
                            @copy_recipients = @CCRecipients, -- varchar(max)
                            @subject = @Subject, -- nvarchar(255)
                            @body = @NotificaionMessage, -- nvarchar(max)
                            @body_format = 'text';
					--@query='update CriticalAlertsProcess set SendMail '
                    
                        UPDATE  dbo.CriticalAlertsProcess
                        SET     CriticalAlertsProcess.[Processed] = 'Y'
                        FROM    @temp_NotificationAlertsProcess
                        WHERE   CriticalAlertsProcess.ProcessId = [@temp_NotificationAlertsProcess].ProcessId;
                    END;
            END;
	/*-------------------------Notification ELECTONIC ALERT EMAIL  BEGINS---------------------------------------*/     
      DROP TABLE #TempCritalAlerts
   
    END TRY
    
    BEGIN CATCH
        SET @errorMessage = ERROR_MESSAGE() + CHAR(13) + ERROR_PROCEDURE();
        RAISERROR                                                                                               
      (                                                               
       @errorMessage,  16,   1 
      );      
    END CATCH; 

GO

