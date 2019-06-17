IF OBJECT_ID('csp_ImportLarge835') IS NOT NULL
   DROP PROCEDURE dbo.csp_ImportLarge835
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE csp_ImportLarge835
       @TransactionSetId INT
AS 
       BEGIN
/******************************************************************************
 * Procedure Name: csp_ImportLarge835
 * Author: David Knewtson
 * Created Date: 2/1/2016
 *
 * Purpose: Tool for processing large 835 files through the backend.
 ******************************************************************************
 * Change History
 ******************************************************************************
 * Author		Date		Purpose
 *-----------------------------------------------------------------------------
 ******************************************************************************/
             BEGIN TRY

                   DECLARE @TempErrorMessage VARCHAR(4000)
                   DECLARE @EDIFileId INT 
                   DECLARE @StaffUserCode VARCHAR(MAX)
                   DECLARE @StaffId INT
                  
                   SELECT @StaffUserCode = dbo.ssf_GetSystemConfigurationKeyValue('XAUTOMATIC835UPLOADUSERCODE') 
                   
                   SELECT @StaffId = s.StaffId FROM Staff s WHERE s.UserCode = @StaffUserCode
                                                                  AND ISNULL(s.RecordDeleted,'N') <> 'Y'                 
                                                                  AND ISNULL(s.Active,'N') = 'Y'

                   

                   SELECT   @EDIFileId = ef.EDIFileId
                   FROM     dbo.EDITransactionSets ets
                            JOIN dbo.EDIFunctionalGroups efg
                                ON ets.EDIFunctionalGroupId = efg.EDIFunctionalGroupId
                            JOIN dbo.EDIInterchanges ei
                                ON efg.EDIInterchangeId = ei.EDIInterchangeId
                            JOIN dbo.EDIFiles ef
                                ON ei.EDIFileId = ef.EDIFileId
                            --JOIN dbo.CustomEDIFilesERFiles cefef ON ef.EDIFileId = cefef.EDIFileId
                   WHERE    ets.EDITransactionSetId = @TransactionSetId

                   IF EXISTS ( SELECT   1
                               FROM     dbo.CustomEDIFilesERFiles cefef
                               WHERE    cefef.EDIFileId = @EDIFileId ) 
                      BEGIN
                            RETURN -- don't need to do anything, we'll be processing these by file.
                      END    

                   IF NOT EXISTS ( SELECT   1
                                   FROM     dbo.EDITransactionSets ets
                                            JOIN dbo.CustomEDITradingPartnersERSenders cetpes
                                                ON cetpes.EDITradingPartnerId = ets.EDITradingPartnerId
                                   WHERE    ets.EDITransactionSetId = @TransactionSetId ) 
                      BEGIN
                        
                            SELECT  @TempErrorMessage = LEFT('Unable to determine ERSender for Trading Partner '
                                                         + RTRIM(LTRIM(etp.[Description])), 4000)
                            FROM    dbo.EDITradingPartners etp
                                    JOIN dbo.EDITransactionSets ets
                                        ON etp.EDITradingPartnerId = ets.EDITradingPartnerId
                            WHERE   ets.EDITransactionSetId = @TransactionSetId
                                                                         
                            RAISERROR (@TempErrorMessage,16,1)
                      END               
                      
                   IF @StaffId IS NULL
                   BEGIN
                     SELECT @TempErrorMessage = LEFT('Unable to locate staff record for user ' + ISNULL(@StaffUserCode,'(Automated 835 Upload Staff not configured)') + '. The staff may be deleted or inactive.',4000)
                     RAISERROR(@TempErrorMessage,16,1)
                   END    

                   DECLARE @ERFileId INT 


                   INSERT   INTO dbo.ERFiles
                            ( 
                             FileName
                            ,ImportDate
                            ,FileText
                            ,ERSenderId
                            ,ApplyAdjustments
                            ,ApplyTransfers
                            ,RowIdentifier
                            ,CreatedBy
                            ,CreatedDate
                            ,ModifiedBy
                            ,ModifiedDate
                            )
                            SELECT RIGHT(ef.FileName,CHARINDEX('\',REVERSE(ef.FileName))-1)  -- FileName - varchar(100)
                                   ,ef.CreatedDate-- ImportDate - datetime
                                   ,ef.FileText-- FileText - text
                                   ,cetpes.ERSenderId-- ERSenderId - int
                                   ,'Y'-- ApplyAdjustments - type_YOrN
                                   ,'Y'-- ApplyTransfers - type_YOrN
                                   ,NEWID()-- RowIdentifier - type_GUID
                                   ,@StaffUserCode-- CreatedBy - type_CurrentUser
                                   ,GETDATE()-- CreatedDate - type_CurrentDatetime
                                   ,@StaffUserCode-- ModifiedBy - type_CurrentUser
                                   ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                            FROM    dbo.EDIFiles ef
                                    JOIN dbo.EDIInterchanges ei
                                        ON ef.EDIFileId = ei.EDIFileId
                                    JOIN dbo.EDIFunctionalGroups efg
                                        ON ei.EDIInterchangeId = efg.EDIInterchangeId
                                    JOIN dbo.EDITransactionSets ets
                                        ON efg.EDIFunctionalGroupId = ets.EDIFunctionalGroupId
                                    JOIN dbo.EDITradingPartners etp
                                        ON ets.EDITradingPartnerId = etp.EDITradingPartnerId
                                           AND ISNULL(etp.RecordDeleted, 'N') <> 'Y'
                                    JOIN dbo.CustomEDITradingPartnersERSenders cetpes
                                        ON etp.EDITradingPartnerId = cetpes.EDITradingPartnerId
                                           AND ISNULL(cetpes.RecordDeleted, 'N') <> 'Y'
                                    JOIN dbo.ERSenders es
                                        ON es.ERSenderId = cetpes.ERSenderId
                            WHERE   ets.EDITransactionSetId = @TransactionSetId

                  SET @ERFileId = SCOPE_IDENTITY()

                  INSERT INTO dbo.CustomEDIFilesERFiles
                          ( EDIFileId
                          ,CreatedBy
                          ,CreatedDate
                          ,ModifiedBy
                          ,ModifiedDate
                          ,ERFileId
                          )
                  VALUES  (@EDIFileId  -- EDIFileId - int
                           ,@StaffUserCode-- CreatedBy - type_CurrentUser
                           ,GETDATE()-- CreatedDate - type_CurrentDatetime
                           ,@StaffUserCode-- ModifiedBy - type_CurrentUser
                           ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                           ,@ERFileId-- ERFileId - int
                          )

               CREATE TABLE #Tokens 
                  ( rownum INT IDENTITY
                    ,toke INT
                  )                
               
               ;
               WITH lv0
                      AS (
                           SELECT   0 g
                           UNION ALL
                           SELECT   0
                         ), --2
                    lv1
                      AS (
                           SELECT   0 g
                           FROM     lv0 a
                                    CROSS JOIN lv0 b
                         ), -- 4
                    lv2
                      AS (
                           SELECT   0 g
                           FROM     lv1 a
                                    CROSS JOIN lv1 b
                         ), --16
                    lv3
                      AS (
                           SELECT   0 g
                           FROM     lv2 a
                                    CROSS JOIN lv2 b
                         ),--256
                    lv4
                      AS (
                           SELECT   0 g
                           FROM     lv3 a
                                    CROSS JOIN lv3 b
                         ), --65536
                    lv5
                      AS (
                           SELECT   0 g
                           FROM     lv4 a
                                    CROSS JOIN lv3 b
                         ), --16777216
                    Tally ( n )
                      AS (
                           SELECT   ROW_NUMBER() OVER ( ORDER BY (
                                                                   SELECT   NULL
                                                                 ) )
                           FROM     lv5
                         )
                    INSERT INTO #Tokens
                            (toke
                            )
                    SELECT DISTINCT
                            CHARINDEX(ef.SegmentSeparator, ef.SegmentSeparator + ef.FileText, N) AS toke
                    FROM    dbo.EDIFiles ef
                            JOIN Tally
                                ON N BETWEEN 1 AND LEN(ef.FileText) + 1
                           --AND CHARINDEX(ef.SegmentSeparator,ef.SegmentSeparator+ef.FileText,N) = 1 
                    WHERE   ef.EDIFileId = @EDIFileId
                   ORDER BY toke
   
                    INSERT INTO dbo.ERFileSegments
                        ( ERFileId
                        ,LineNumber
                        ,FileLineText
                        ,RowIdentifier
                        ,CreatedBy
                        ,CreatedDate
                        ,ModifiedBy
                        ,ModifiedDate
                        )
               SELECT   @ERFileId -- ERFileId - int
                       ,t.rownum-- LineNumber - int
                       ,SUBSTRING(ef.FileText, t.toke,
                                  t2.toke - t.toke-1)-- FileLineText - varchar(1000)
                       ,NEWID()-- RowIdentifier - type_GUID
                       ,@StaffUserCode-- CreatedBy - type_CurrentUser
                       ,GETDATE()-- CreatedDate - type_CurrentDatetime
                       ,@StaffUserCode-- ModifiedBy - type_CurrentUser
                       ,GETDATE()-- ModifiedDate - type_CurrentDatetime
               FROM     dbo.EDIFiles ef
                        CROSS JOIN #Tokens t
                        -- technically there would be one more token but we don't need the last token since it's the end of the file.
                        -- ergo we only need a straight join.
                        JOIN #Tokens t2 ON t.rownum + 1 = t2.rownum 
               WHERE    ef.EDIFileId = @EDIFileId 
               ORDER BY 2

               DROP TABLE #Tokens

               EXEC dbo.ssp_PMElectronicProcessERFile @ERFileId = @ERFileId, -- int
                   @UserId = @StaffId -- int
               

             END TRY
             BEGIN CATCH
                   IF @@Trancount > 0 
                      ROLLBACK TRAN

                   DECLARE @ErrorMessage NVARCHAR(4000)
                          ,@VerboseInfo VARCHAR(4000)
                          ,@CurrentDate DATETIME
                          ,@ErrorNumber INT
                          ,@ErrorSeverity INT
                          ,@ErrorState INT
                          ,@ErrorLine INT
                          ,@ErrorProcedure NVARCHAR(256);    

                   SELECT   @ErrorNumber = ERROR_NUMBER()
                           ,@ErrorSeverity = ERROR_SEVERITY()
                           ,@ErrorState = ERROR_STATE()
                           ,@ErrorLine = ERROR_LINE()
                           ,@ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'); 

                   SELECT   @ErrorMessage = N'Error ' + CAST(@ErrorNumber AS NVARCHAR) + ', Level '
                            + CAST(@ErrorSeverity AS NVARCHAR) + ', State ' + CAST(@ErrorState AS NVARCHAR)
                            + ', Procedure ' + ISNULL(@ErrorProcedure, '-') + ', Line ' + CAST(@ErrorLine AS NVARCHAR)
                            + ': ' + ERROR_MESSAGE()
                           ,@CurrentDate = GETDATE()
                           ,@VerboseInfo = N'TransactionSetId = ' + CAST(@TransactionSetId AS NVARCHAR)

                   EXEC ssp_SCLogError @ErrorMessage = @ErrorMessage, @VerboseInfo = @VerboseInfo,
                    @ErrorType = '835ProcessingError', @CreatedBy = '834Enrollment', @CreatedDate = @CurrentDate,
                    @DataSetInfo = ''
			
                   RAISERROR (
					@ErrorMessage,
					@ErrorSeverity,
					1	
					);

             END CATCH



       END
GO
