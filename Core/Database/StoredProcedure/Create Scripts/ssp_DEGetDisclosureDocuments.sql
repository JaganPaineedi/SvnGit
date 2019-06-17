
/****** Object:  StoredProcedure [dbo].[ssp_DEGetDisclosureDocuments]    Script Date: 12/14/2016 13:58:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_DEGetDisclosureDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_DEGetDisclosureDocuments]
GO



/****** Object:  StoredProcedure [dbo].[ssp_DEGetDisclosureDocuments]    Script Date: 12/14/2016 13:58:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE PROCEDURE [dbo].[ssp_DEGetDisclosureDocuments]
    @OrganizationIdFrom INT
   ,@TokenVal NVARCHAR(50)    
/*********************************************************************/                                                    
/* Stored Procedure: dbo.[ssp_DEGetDisclosureDocuments]      */                                                    
/* Creation Date:    18/Dec/2012                                     */                                                    
/* Created By: Raghu Mohindru                                        */                                                    
/* Purpose: Get Disclosure Documents                                 */                                                    
/*                  */                                                     
/* Input Parameters:             */                                                    
/*                                                                   */                                                    
/* Output Parameters:                                                */                                                    
/*                                                                   */                                                    
/* Return Status:                                                    */                                                    
/*                                                                   */                                                    
/* Called By:                                                        */                                                    
/*                                                                   */                                                    
/* Calls:                                                            */                                                    
/*                                                                   */                                                    
/* Data Modifications:                                               */                                                    
/*                                                                   */                                                    
/* Updates:                                                          */                                                    
/*   Date                   Author           Purpose                 */      
/*   26/Feb/2013			Samrat			Updated the ClientDisclosures Comments and status              */    
/*  22/April/2013           Samrat          added some custom stored procedures that will execute 
											if the sp exists in the database against the task #50 "DataShare"*/   
/*********************************************************************/
AS 
    BEGIN  
   
        BEGIN TRY  
	-------Added by samrat against the task #50 "DataShare"---------
	-------Start-------
	----If the below stored procedure is present in the database then that stored procedure will execute
            DECLARE @SpName VARCHAR(50)
	
            IF EXISTS ( SELECT  *
                        FROM    sys.objects
                        WHERE   object_id = OBJECT_ID(N'[dbo].[csp_DESCGetDisclosureDocuments]')
                                AND type IN (N'P', N'PC') ) 
                BEGIN 
                    SET @SpName = 'csp_DESCGetDisclosureDocuments'
                    EXEC @SpName @OrganizationIdFrom, @TokenVal
                    RETURN  
                END
	
            IF EXISTS ( SELECT  *
                        FROM    sys.objects
                        WHERE   object_id = OBJECT_ID(N'[dbo].[csp_DEPCMGetDisclosureDocuments]')
                                AND type IN (N'P', N'PC') ) 
                BEGIN  
                    SET @SpName = 'csp_DEPCMGetDisclosureDocuments'
                    EXEC @SpName @OrganizationIdFrom, @TokenVal
                    RETURN  
                END
	--------End--------
 
            DECLARE @DisclosureStatus INT;    
      
  --This table created to hold the validation messages  
            CREATE TABLE #ValidationMessages
                (
                 StoredProcedureName VARCHAR(200)
                ,ValidationMessage VARCHAR(500)
                ,DocumentId INT
                ,ImageRecordId INT
                )  
      
            CREATE TABLE #TempValidationMessages
                (
                 StoredProcedureName VARCHAR(200)
                ,ValidationMessage VARCHAR(500)
                ,DocumentId INT
                ,ImageRecordId INT
                )  
   
            DECLARE @TempTable TABLE
                (
                 RowID INT IDENTITY(1, 1)
                           NOT NULL
                ,ClientDisclosureId INT
                ,ClientId INT
                ,DisclosureType INT
                ,OrganizationIdTo INT
                ,ClientDisclosedRecordId INT
                ,DocumentId INT
                ,ServiceId INT
                ,ImageRecordId INT
                )    
  
            DECLARE @ClientDisclosureId INT
               ,@ClientId INT
               ,@DisclosureType INT
               ,@OrganizationIdTo INT;    
            DECLARE @ClientDisclosedRecordId INT
               ,@DocumentId INT
               ,@ServiceId INT
               ,@ImageRecordId INT;    
            DECLARE @ImageServerURL VARCHAR(500)
               ,@ImageServerId INT;    
  
            DECLARE @CentralTransferDocumentTypeID INT
               ,@LastVersionImportMessageDetailID INT    
            DECLARE @StoredProcedureName VARCHAR(100)
               ,@Format INT
               ,@DocumentCodeId INT;     
            DECLARE @ProgramID INT;    
  
            DECLARE @FormatPDF INT = 8245;    
            DECLARE @FormatEDI INT = 8246;    
            DECLARE @FormatXml INT = 8247;    
            DECLARE @FormatJPEG INT = 8248;    
            DECLARE @FormatPNG INT = 8249;    
  
            DECLARE @Rows INT;    
            DECLARE @CurrentRow INT;    
            DECLARE @XmlData XML;    
            DECLARE @ClaimFormatId INT;    
            DECLARE @DocData NVARCHAR(MAX);    
            DECLARE @MetaData XML;    
  
            DECLARE @ErrorMessage VARCHAR(500) = 'Unknown Error';
            DECLARE @VerboseInfo VARCHAR(50)= '';
            DECLARE @ErrorType VARCHAR(50)= 'General';
            DECLARE @CreatedBy VARCHAR(30)= 'shcdev';    
            DECLARE @CreatedDate DATETIME = GETDATE();
            DECLARE @DatasetInfo VARCHAR(50)= '';    
            DECLARE @DisclosedBy INT;
            DECLARE @ExportMessageId INT;
            DECLARE @ExportMessageStatus INT= 8260;    
  
   
           
        -- Disclosure Status -- it has not been hardcoded with GlobalcodeId  because its value is greater than 10000    
            SELECT  @DisclosureStatus = GlobalCodeId
            FROM    GlobalCodes
            WHERE   Category = 'DISCLOSURESTATUS'
                    AND LOWER(CodeName) = 'completed';    
    
  ---- Get Completed Disclosure document -----------------  
            SELECT TOP 1
                    @ClientDisclosureId = CD.ClientDisclosureId
                   ,@OrganizationIdTo = ISNULL(CD.DEOrganizationId, 0)
                   ,@DisclosedBy = ISNULL(CD.DisclosedBy, 0)
            FROM    ClientDisclosures CD
            WHERE   CD.DisclosureStatus = @DisclosureStatus
                    AND ISNULL(CD.RecordDeleted, 'N') = 'N'
                    AND NOT EXISTS ( SELECT EM.ClientDisclosureId
                                     FROM   DEExportMessages EM
                                     WHERE  EM.ClientDisclosureId = CD.ClientDisclosureId
                                            AND ISNULL(EM.RecordDeleted, 'N') = 'N' )  
  
            IF (ISNULL(@OrganizationIdFrom, 0) > 0
                AND ISNULL(@ClientDisclosureId, 0) > 0
               ) 
                BEGIN
                    PRINT '(OrganizationIdFrom > 0 AND ClientDisclosureId > 0) Then'
                    PRINT '@OrganizationIdFrom = ' + CAST(@OrganizationIdFrom AS VARCHAR(MAX)) + '   @ClientDisclosureId = '
                        + CAST(@ClientDisclosureId AS VARCHAR(MAX))
   /* Insert data into temp table */    
                    INSERT  INTO @TempTable
                            (ClientDisclosureId
                            ,ClientId
                            ,DisclosureType
                            ,OrganizationIdTo
                            ,ClientDisclosedRecordId
                            ,DocumentId
                            ,ServiceId 
                            )
                            SELECT  CD.ClientDisclosureId
                                   ,CD.ClientId
                                   ,CD.DisclosureType
                                   ,CD.DEOrganizationId
                                   ,CDR.ClientDisclosedRecordId
                                   ,CDR.DocumentId
                                   ,D.ServiceId
                            FROM    ClientDisclosures CD
                                    INNER JOIN ClientDisclosedRecords CDR ON CDR.ClientDisclosureId = CD.ClientDisclosureId
                                    LEFT JOIN Documents D ON D.DocumentId = CDR.DocumentId
                                                             AND ISNULL(D.RecordDeleted, 'N') = 'N'
                            WHERE   CD.DisclosureStatus = @DisclosureStatus
                                    AND CD.ClientDisclosureId = @ClientDisclosureId
                                    AND ISNULL(CD.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(CDR.RecordDeleted, 'N') = 'N'    
  
                    INSERT  INTO @TempTable
                            (ClientDisclosureId
                            ,ClientId
                            ,DisclosureType
                            ,OrganizationIdTo
                            ,ImageRecordId
                            )
                            SELECT  CD.ClientDisclosureId
                                   ,CD.ClientId
                                   ,CD.DisclosureType
                                   ,CD.DEOrganizationId
                                   ,IR.ImageRecordId
                            FROM    ClientDisclosures CD
                                    INNER JOIN ImageRecords IR ON IR.ClientDisclosureId = CD.ClientDisclosureId
                            WHERE   CD.DisclosureStatus = @DisclosureStatus
                                    AND CD.ClientDisclosureId = @ClientDisclosureId
                                    AND ISNULL(CD.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(IR.RecordDeleted, 'N') = 'N'    
  
                    SELECT  @Rows = COUNT(*)
                    FROM    @TempTable;  
                    DECLARE @MessageDetail TABLE
                        (
                         RowID INT
                        ,ClientDisclosureId INT
                        ,ClientDisclosedRecordId INT
                        ,DocumentType INT
                        ,DocumentFormat VARCHAR(10)
                        ,DocumentDetail TEXT
                        ,DocData NVARCHAR(MAX)
                        ,MetaData NVARCHAR(MAX)
                        ,LastVersionImportMessageDetailID INT
                        ,ImageServerURL VARCHAR(500)
                        ,ImageRecordID INT
                        );  
                    SET @CurrentRow = 1;    
  
                    IF (@Rows > 0) 
                        BEGIN    
                            PRINT '(@Rows > 0) Then'
                            PRINT '@Rows = ' + CAST(@Rows AS VARCHAR(MAX))

                            INSERT  INTO DEExportMessages
                                    (ClientDisclosureId
                                    ,MessageTo
                                    ,MessageDate
                                    ,NumberOfMessageItem
                                    ,Status
                                    )
                                    SELECT  @ClientDisclosureId
                                           ,@OrganizationIdTo
                                           ,GETDATE()
                                           ,@Rows
                                           ,8260 -- DATAEXCHDOCSTATUS- Open    
                            SET @ExportMessageId = SCOPE_IDENTITY();   
  
                            WHILE (@CurrentRow <= @Rows) 
                                BEGIN    
                                    SET @DocData = '';    
                                    SET @XmlData = '';    
                                    SET @MetaData = NULL;    
  
                                    SELECT  @ClientId = ClientId
                                           ,@DisclosureType = DisclosureType
                                           ,@ClientDisclosedRecordId = ClientDisclosedRecordId
                                           ,@DocumentId = DocumentId
                                           ,@ServiceId = ServiceId
                                           ,@ImageRecordId = ImageRecordId
                                    FROM    @TempTable
                                    WHERE   RowID = @CurrentRow    
                                          
                                    IF (ISNULL(@DocumentId, 0) > 0) 
                                        BEGIN    
                                            PRINT '(@DocumentId > 0) Then'
                                            PRINT '@DocumentId = ' + CAST(@DocumentId AS VARCHAR(MAX))
                                            SET @Format = @FormatXml;    

                                            SELECT  @CentralTransferDocumentTypeID = CentralTransferDocumentTypeId
                                                   ,@StoredProcedureName = StoredProcedureName
                                                   ,@DocumentCodeId = D.DocumentCodeId
                                            FROM    DEImportExport278DocumentFormats DEIE
                                                    INNER JOIN Documents D ON d.DocumentCodeId = DEIE.DocumentCode
                                            WHERE   ISNULL(DEIE.RecordDeleted, 'N') = 'N'
                                                    AND DEIE.DocumentFormat = @Format
                                                    AND DEIE.DocumentCode = d.DocumentCodeId
                                                    AND DEIE.FromDEOrganizationId = @OrganizationIdFrom
                                                    AND DEIE.ToDEOrganizationId = @OrganizationIdTo
                                                    AND D.DocumentId = @DocumentId
                                                    AND ISNULL(D.RecordDeleted, 'N') = 'N'    
                                          
                                              -------------------------------------------------------------------    
                                            PRINT '@StoredProcedureName = ' + ISNULL(@StoredProcedureName, 'NO SP')

                                            IF (ISNULL(@StoredProcedureName, '') <> '') 
                                                BEGIN    
                                                    BEGIN TRY  
                                                        EXECUTE @StoredProcedureName @DocumentId, @OrganizationIdFrom, @OrganizationIdTo, @XmlData OUT,
                                                            @MetaData OUT    
                                                    END TRY  
                                                    BEGIN CATCH  
                                                        DECLARE @Errors VARCHAR(8000);    
                                                        SET @Errors = CONVERT(VARCHAR(4000), ERROR_MESSAGE())    
                                                      
                                                ----Setting the DisclosureStatus to invalid and update the comment with the error message  
                                                        UPDATE  CD
                                                        SET     --commented by samrat as per discussion with katie Holtzman  
                                                --CD.Comments='Delivery Failed. Please contact system administrator for the error.',   
                                                                CD.DisclosureStatus = GC.GlobalCodeId
                                                        FROM    ClientDisclosures CD
                                                                INNER JOIN DEExportMessages EM ON EM.ClientDisclosureId = CD.ClientDisclosureId
                                                                LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId <> CD.DisclosureStatus
                                                                                            AND GC.Category = 'DISCLOSURESTATUS'
                                                                                            AND LOWER(GC.CodeName) = 'Invalid'
                                                                                            AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                                        WHERE   EM.DEExportMessageId = @ExportMessageID
                                                                AND ISNULL(CD.RecordDeleted, 'N') = 'N'
                                                                AND ISNULL(EM.RecordDeleted, 'N') = 'N'  
                                          
                                                        UPDATE  DEExportMessages
                                                        SET     --Comment = @Errors
                                                                Comment = 'Failure, most likely client is not set up in CustomFieldClientInformations.  :'
                                                                + @StoredProcedureName
                                                               ,Status = 8259 -- failure
                                                               ,RecordDeleted = 'Y'
                                                        WHERE   DEExportMessageId = @ExportMessageId  
                                                      
                                                        RAISERROR    
                                                (    
                                                 @Errors, -- Message text.    
                                                 16, -- Severity.    
                                                 1 -- State.    
                                                );  
                                                    END CATCH  
                                          
                                                    INSERT  INTO DEExportMessageDetails
                                                            (DEExportMessageId
                                                            ,ClientDisclosedRecordId
                                                            ,CentralTransferDocumentTypeId
                                                            ,DocumentFormatId
                                                            ,MessageDetail
                                                            ,MetaData
                                                            ,Status
                                                            ,RecieverImportMessageDetailId
                                                                                                    
                                                            )
                                                            SELECT  @ExportMessageId
                                                                   ,@ClientDisclosedRecordId
                                                                   ,@CentralTransferDocumentTypeID
                                                                   ,@Format
                                                                   ,CAST(@XmlData AS NVARCHAR(MAX))
                                                                   ,CAST(@MetaData AS NVARCHAR(MAX))
                                                                   ,8260
                                                                   ,0  
                                                END    
                                            ELSE 
                                                BEGIN    
                                               -- Error Log    
                                                    SET @VerboseInfo = @DocumentId;    
                                                    SET @ErrorMessage = 'Stored Procedure For Document Code= ' + ISNULL(CAST(@DocumentCodeId AS VARCHAR(MAX)),
                                                                                                                        'Unknown') + '  Not Found.';   
                                          
                                                    UPDATE  CD
                                                    SET     CD.DisclosureStatus = GC.GlobalCodeId
                                                    FROM    ClientDisclosures CD
                                                            INNER JOIN DEExportMessages EM ON EM.ClientDisclosureId = CD.ClientDisclosureId
                                                            LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId <> CD.DisclosureStatus
                                                                                        AND GC.Category = 'DISCLOSURESTATUS'
                                                                                        AND LOWER(GC.CodeName) = 'Invalid'
                                                                                        AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                                    WHERE   EM.DEExportMessageId = @ExportMessageID
                                                            AND ISNULL(CD.RecordDeleted, 'N') = 'N'
                                                            AND ISNULL(EM.RecordDeleted, 'N') = 'N'  
                                                     
                                                    UPDATE  DEExportMessages
                                                    SET     Comment = ISNULL(@ErrorMessage, 'null error message should not be possible')
                                                           ,RecordDeleted = 'Y'
                                                           ,Status = 8259 -- failure
                                                    WHERE   DEExportMessageId = @ExportMessageId  
                                                    EXEC ssp_DELogError @ErrorMessage, @VerboseInfo, @ErrorType, @CreatedBy, @CreatedDate, @DatasetInfo;    
                                                END    
                                            
                                            IF EXISTS ( SELECT  *
                                                        FROM    #ValidationMessages
                                                        WHERE   ISNULL(DocumentId, 0) = 0 ) 
                                                BEGIN  
                                                    UPDATE  #ValidationMessages
                                                    SET     DocumentId = @DocumentId
                                                           ,ImageRecordId = 0
                                                    WHERE   ISNULL(DocumentId, 0) = 0  
                                          
                                                    UPDATE  DE
                                                    SET     Comment = VM.ValidationMessage
                                                           ,status = 8259
                                                    FROM    DEExportmessageDetails DE
                                                            INNER JOIN ClientDisclosedRecords CR ON CR.ClientDisclosedRecordId = DE.ClientDisclosedRecordId
                                                            INNER JOIN #ValidationMessages VM ON VM.DocumentId = CR.DocumentId  
                                                END  
                                          
                                            SET @CurrentRow = @CurrentRow + 1   
                                                
                                            INSERT  INTO #TempValidationMessages
                                                    (StoredProcedureName
                                                    ,ValidationMessage
                                                    ,DocumentId
                                                    ,ImageRecordId
                                                                                            
                                                    )
                                                    SELECT  StoredProcedureName
                                                           ,ValidationMessage
                                                           ,DocumentId
                                                           ,ImageRecordId
                                                    FROM    #ValidationMessages  
                                          
                                            DELETE  FROM #ValidationMessages  
                                                   
                                            CONTINUE;    
                                        END    
                                                  
          
                                    SET @StoredProcedureName = ''  
                                    IF (ISNULL(@ImageRecordId, 0) > 0) 
                                        BEGIN    
                                            SET @Format = @FormatPDF;    
      -------------------Samrat----------------  
                                            SELECT  @CentralTransferDocumentTypeID = DEIE.CentralTransferDocumentTypeId
                                                   ,@StoredProcedureName = DEIE.StoredProcedureName
                                            FROM    DEImportExport278DocumentFormats DEIE
                                            WHERE   ISNULL(DEIE.RecordDeleted, 'N') = 'N'
                                                    AND DEIE.DocumentFormat = @Format
                                                    AND DEIE.FromDEOrganizationId = @OrganizationIdFrom
                                                    AND DEIE.ToDEOrganizationId = @OrganizationIdTo    
          
           
                                            IF (ISNULL(@StoredProcedureName, '') <> '') 
                                                BEGIN    
                                                    BEGIN TRY  
                                                        EXECUTE @StoredProcedureName @ImageRecordId, @ClientId, @MetaData OUT    
                                                    END TRY  
                                                    BEGIN CATCH  
                                                        DECLARE @ImageErrors VARCHAR(8000);    
                                                        SET @ImageErrors = CONVERT(VARCHAR(4000), ERROR_MESSAGE())    
          ----Setting the DisclosureStatus to invalid and update the comment with the error message  
                                                        UPDATE  CD    
          -- commented by samrat as per discussion with katie Holtzman  
          -- CD.Comments = 'Delivery Failed. Please contact system administrator for the error.',   
                                                        SET     CD.DisclosureStatus = GC.GlobalCodeId
                                                        FROM    ClientDisclosures CD
                                                                INNER JOIN DEExportMessages EM ON EM.ClientDisclosureId = CD.ClientDisclosureId
                                                                LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId <> CD.DisclosureStatus
                                                                                            AND GC.Category = 'DISCLOSURESTATUS'
                                                                                            AND LOWER(GC.CodeName) = 'Invalid'
                                                                                            AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                                        WHERE   EM.DEExportMessageId = @ExportMessageID
                                                                AND ISNULL(CD.RecordDeleted, 'N') = 'N'
                                                                AND ISNULL(EM.RecordDeleted, 'N') = 'N'  
  
                                                        UPDATE  DEExportMessages
                                                        SET     Comment = 'Failed while executing ' + @StoredProcedureName
                                                               ,RecordDeleted = 'Y'
                                                               ,Status = 8259 -- failure
                                                        WHERE   DEExportMessageId = @ExportMessageId  
  
                                                        RAISERROR    
          (    
           @ImageErrors, -- Message text.    
           16, -- Severity.    
           1 -- State.    
           );  
                                                    END CATCH  
           
                                                    SET @XmlData = '';    
                                                    SET @CurrentRow = @CurrentRow + 1  
  
                                                    INSERT  INTO DEExportMessageDetails
                                                            (DEExportMessageId
                                                            ,ImageRecordId
                                                            ,DocumentFormatId
                                                            ,MessageDetail
                                                            ,MetaData
                                                            ,Status
                                                            ,RecieverImportMessageDetailId
                                                            ,CentralTransferDocumentTypeId  
                                                            )
                                                            SELECT  @ExportMessageId
                                                                   ,@ImageRecordId
                                                                   ,@Format
                                                                   ,CAST(@XmlData AS VARCHAR(MAX))
                                                                   ,CAST(@MetaData AS VARCHAR(MAX))
                                                                   ,8259
                                                                   ,0
                                                                   ,@CentralTransferDocumentTypeID  
                                                END    
                                            ELSE 
                                                BEGIN    
         -- Error Log    
                                                    SET @VerboseInfo = @ImageRecordId;    
                                                    SET @ErrorMessage = 'Stored Procedure For ImageRecordId= ' + CAST(@ImageRecordId AS VARCHAR(MAX))
                                                        + '  Not Found.';   
           
                                                    UPDATE  CD   
           --commented by samrat as per discussion with katie Holtzman  
           --CD.Comments='Delivery Failed. Please contact system administrator for the error.',   
                                                    SET     CD.DisclosureStatus = GC.GlobalCodeId
                                                    FROM    ClientDisclosures CD
                                                            INNER JOIN DEExportMessages EM ON EM.ClientDisclosureId = CD.ClientDisclosureId
                                                            LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId <> CD.DisclosureStatus
                                                                                        AND GC.Category = 'DISCLOSURESTATUS'
                                                                                        AND LOWER(GC.CodeName) = 'Invalid'
                                                                                        AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                                    WHERE   EM.DEExportMessageId = @ExportMessageID
                                                            AND ISNULL(CD.RecordDeleted, 'N') = 'N'
                                                            AND ISNULL(EM.RecordDeleted, 'N') = 'N'  
            
                                                    UPDATE  DEExportMessages
                                                    SET     Comment = ISNULL(@ErrorMessage, 'no error message')
                                                           ,RecordDeleted = 'Y'
                                                           ,Status = 8259 -- failure
                                                    WHERE   DEExportMessageId = @ExportMessageId  
                                                    EXEC ssp_DELogError @ErrorMessage, @VerboseInfo, @ErrorType, @CreatedBy, @CreatedDate, @DatasetInfo;    
                                                END  
  
                                            IF EXISTS ( SELECT  *
                                                        FROM    #ValidationMessages
                                                        WHERE   ISNULL(ImageRecordId, 0) = 0 ) 
                                                BEGIN  
                                                    UPDATE  #ValidationMessages
                                                    SET     ImageRecordId = @ImageRecordId
                                                           ,DocumentId = 0
                                                    WHERE   ISNULL(ImageRecordId, 0) = 0  
  
                                                    UPDATE  DE
                                                    SET     Comment = VM.ValidationMessage
                                                           ,status = 8259
                                                    FROM    DEExportmessageDetails DE
                                                            INNER JOIN ImageRecords IR ON IR.ImageRecordId = DE.ImageRecordId
                                                            INNER JOIN #ValidationMessages VM ON VM.ImageRecordId = IR.ImageRecordId  
                                                END  
  
                                            SET @CurrentRow = @CurrentRow + 1     
  
                                            INSERT  INTO #TempValidationMessages
                                                    (StoredProcedureName
                                                    ,ValidationMessage
                                                    ,DocumentId
                                                    ,ImageRecordId
                                                    )
                                                    SELECT  StoredProcedureName
                                                           ,ValidationMessage
                                                           ,DocumentId
                                                           ,ImageRecordId
                                                    FROM    #ValidationMessages  
  
                                            DELETE  FROM #ValidationMessages  
                                        END    
                                END    
                            IF EXISTS ( SELECT  *
                                        FROM    #TempValidationMessages ) 
                                BEGIN  
                                    UPDATE  CD
                                    SET     CD.DisclosureStatus = GC.GlobalCodeId
                                    FROM    ClientDisclosures CD
                                            INNER JOIN DEExportMessages EM ON EM.ClientDisclosureId = CD.ClientDisclosureId
                                            LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId <> CD.DisclosureStatus
                                                                        AND GC.Category = 'DISCLOSURESTATUS'
                                                                        AND LOWER(GC.CodeName) = 'Invalid'
                                                                        AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                    WHERE   EM.DEExportMessageId = @ExportMessageID
                                            AND ISNULL(CD.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(EM.RecordDeleted, 'N') = 'N'  
  
                                    UPDATE  DEExportMessages
                                    SET     Comment = 'Failed temp vm'
                                           ,RecordDeleted = 'Y'
                                           ,status = 8259
                                    WHERE   DEExportMessageId = @ExportMessageId  
         
                                    RAISERROR(@ErrorMessage, 16, 1)  
                                END  
                        END    
                    ELSE 
                        BEGIN    
    -- Error Log    
                            SET @VerboseInfo = '';    
                            SET @ErrorMessage = 'There Is No New Disclosure Data To Send.';    
                            --EXEC ssp_DELogError @ErrorMessage, @VerboseInfo,
                            --    @ErrorType, @CreatedBy, @CreatedDate,
                            --    @DatasetInfo;   
      
                            UPDATE  CD
                            SET     CD.DisclosureStatus = GC.GlobalCodeId
                            FROM    ClientDisclosures CD
                                    LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId <> CD.DisclosureStatus
                                                                AND GC.Category = 'DISCLOSURESTATUS'
                                                                AND LOWER(GC.CodeName) = 'Invalid'
                                                                AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                            WHERE   CD.ClientDisclosureId = @ClientDisclosureId
                                    AND ISNULL(CD.RecordDeleted, 'N') = 'N'  
                        END    
                END    
            ELSE 
                BEGIN    
                    SET @VerboseInfo = '';    
                    SET @ErrorMessage = 'Disclosure Records Not Found.';    
                    --EXEC ssp_DELogError @ErrorMessage, @VerboseInfo,
                    --    @ErrorType, @CreatedBy, @CreatedDate, @DatasetInfo;   
    
                    UPDATE  CD
                    SET     CD.DisclosureStatus = GC.GlobalCodeId
                    FROM    ClientDisclosures CD
                            LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId <> CD.DisclosureStatus
                                                        AND GC.Category = 'DISCLOSURESTATUS'
                                                        AND LOWER(GC.CodeName) = 'Invalid'
                                                        AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                    WHERE   CD.ClientDisclosureId = @ClientDisclosureId
                            AND ISNULL(CD.RecordDeleted, 'N') = 'N'   
                END       
      
  
            SELECT  DEExportMessages.DEExportMessageId SenderDBMessageId
                   ,@OrganizationIdFrom OrganizationFrom
                   ,MessageTo OrganizationTo
                   ,ClientDisclosureId
                   ,MessageDate
                   ,NumberOfMessageItem NumberOfMessage
                   ,@TokenVal SecurityToken
            FROM    DEExportMessages
            WHERE   EXISTS ( SELECT 1
                             FROM   DEExportMessageDetails
                             WHERE  DEExportMessageDetails.DEExportMessageId = DEExportMessages.DEExportMessageId )
                    AND DEExportMessages.Status = @ExportMessageStatus    
                 
        -- Table DEExportMessageDetails (Message Details)    
            SELECT  EMD.DEExportMessageId ExportMessageId
                   ,EMD.DEExportMessageDetailId ExportMessageDetailId
                   ,EMD.ClientDisclosedRecordId
                   ,EMD.CentralTransferDocumentTypeId TransferDocumentTypeId
                   ,EMD.DocumentFormatId DocumentFormatId
                   ,EMD.MessageDetail DocumentDetail
                   ,EMD.MetaData MetaData
                   ,EMD.RecieverImportMessageDetailId LastVersionImportMessageDetailID
                   ,EMD.ImageRecordId ImageRecordId
            FROM    DEExportMessageDetails EMD
            WHERE   Status = @ExportMessageStatus
                    AND ISNULL(EMD.RecordDeleted, 'N') = 'N'                                     
                
   -- Table ImageRecords (Image Records)    
            SELECT  IR.ImageRecordId
                   ,ScannedOrUploaded
                   ,DocumentVersionId
                   ,ImageServerId
                   ,ClientId
                   ,AssociatedId
                   ,AssociatedWith
                   ,RecordDescription
                   ,EffectiveDate
                   ,NumberOfItems
                   ,AssociatedWithDocumentId
                   ,AppealId
                   ,StaffId
                   ,EventId
                   ,ProviderId
                   ,TaskId
                   ,AuthorizationDocumentId
                   ,ScannedBy
                   ,CoveragePlanId
                   ,ClientDisclosureId
            FROM    ImageRecords IR
                    INNER JOIN DEExportMessageDetails DE ON DE.ImageRecordId = IR.ImageRecordId
            WHERE   ISNULL(IR.RecordDeleted, 'N') = 'N'
                    AND ISNULL(DE.RecordDeleted, 'N') = 'N'
                    AND DE.Status = @ExportMessageStatus    
       
  
  -- Table ImageServerURL (ImageServerURL)    
            SELECT  IR.ImageRecordId
                   ,ISR.ImageServerURL
            FROM    ImageServers ISR
                    INNER JOIN ImageRecords IR ON IR.ImageServerId = ISR.ImageServerId
                    INNER JOIN DEExportMessageDetails EMD ON EMD.ImageRecordId = IR.ImageRecordId
            WHERE   ISNULL(ISR.RecordDeleted, 'N') = 'N'
                    AND ISNULL(IR.RecordDeleted, 'N') = 'N'
                    AND ISNULL(EMD.RecordDeleted, 'N') = 'N'
                    AND EMD.Status = @ExportMessageStatus     
  
  
        END TRY    
        BEGIN CATCH    
            DECLARE @Error VARCHAR(8000);    
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_DEGetDisclosureDocuments]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
            RAISERROR    
  (    
   @Error, -- Message text.    
   16, -- Severity.    
   1 -- State.    
  );    
        END CATCH    
    END    
    
  








GO


