/****** Object:  StoredProcedure [dbo].[ ssp_BatchDocumentSign]    Script Date: 10/01/2013 16:56:13 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.Objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_BatchDocumentSign]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_BatchDocumentSign] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_BatchDocumentSign]    Script Date: 10/01/2013 16:56:13 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[Ssp_batchdocumentsign] 
@DocumentIdList         VARCHAR(max) 
,@CurrentUserId         INT 
,@IgnoreWarnings        CHAR(1)='N' 
,@DocumentsReadyforSign CHAR(1) 
,@SignatureData         IMAGE 
,@status                VARCHAR(max) --Added by Prem on 26/07/2017 

AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_BatchDocumentSign          */ 
/* Creation Date: 10/01/2013                                           */ 
/*                                                                     */ 
/* Purpose: To process sign for In progress and Co-sign documents 
         
                                   */ 
/*                                                                   */ 
/* Input Parameters: @DocumentIdList,@CurrentUserId               */ 
/*                                                                   */ 
/* Output Parameters:  None                       */ 
/*     Exec ssp_BatchDocumentSign '1234,56677',3                                                             */ 
/*  Date             Author            Purpose             */ 
/* 1st Oct 2013      Gautam            Created             */ 
/* 27 April 2015	Md Hussain Khusro  Added two new parameters w.r.t Core Bugs #1748 */
/* 14 Sep 2015	    Akwianss           Conditions Implemented to Avoid Checking Validations and Warnings (Task #425 in Batch Signature - Issues) */
/* 03 May 2016		Shaik Irfan		   To Refresh the Document After Signing the Document from the Batch Signature (Woods - Support Go Live - Task#33) */ 
/* 20 July 2017      Prem              Added one new parameter  as part of Harbor Enhancements #821  */
/*********************************************************************/ 
  BEGIN 
      BEGIN try 
          DECLARE @TotalDocumentList AS INT 
          DECLARE @CurrentSequence AS INT 
          DECLARE @ProcedureName AS VARCHAR(100) 
          DECLARE @WarningStoredProcedureComplete AS VARCHAR(100) 
          DECLARE @DocumentName AS VARCHAR(100) 
          DECLARE @ClientName AS VARCHAR(120) 
          DECLARE @DocumentId AS INT 
          DECLARE @ServiceId AS INT 
          DECLARE @DocumentVersionId AS INT 
          DECLARE @ErrorMsg AS NVARCHAR(max) 
          DECLARE @PostUpdateStoredProcedureName AS VARCHAR(100)
          DECLARE @ModifiedBy varchar(max)

          SELECT 
@ErrorMsg = 
dbo.Ssf_getmesagebymessagecode(913, 'VALIDATEBATCHMESSAGE', 'This Document signing can not be done through this process. Please sign the document from respective document screen.')

    CREATE TABLE #documentlist 
      ( 
         SequenceId                          INT IDENTITY(1, 1) 
         ,DocumentId                         INT 
         ,DocumentVersionId                  INT 
         ,CustomValidationStoreProcedureName VARCHAR(100) 
         ,ValidationError                    VARCHAR(max) 
         ,Error                              CHAR(1) 
         ,WarningStoredProcedureComplete     VARCHAR(100) 
         ,ServiceId                          INT 
         ,ServiceNote                        CHAR(1) 
         ,DocumentName                       VARCHAR(100) 
         ,ClientName                         VARCHAR(120) 
         ,PostUpdateProcedureName            VARCHAR(100) 
      ) 

    CREATE TABLE #warninglist 
      ( 
         DocumentId    INT 
         ,DocumentName VARCHAR(100) 
         ,ClientName   VARCHAR(120) 
         ,WarningError VARCHAR(max) 
      ) 



    -- Inserted all DocumentId in to #DocumentList table 
    INSERT INTO #documentlist 
                (DocumentId) 
    SELECT item 
    FROM   dbo.Fnsplit(@DocumentIdList, ',') 

    CREATE TABLE #tocosign 
      ( 
         DocumentId INT 
      )--14 Sep 2015 Akwianss 
    INSERT INTO #tocosign 
                (DocumentId)--14 Sep 2015 Akwianss 
    SELECT DISTINCT d.DocumentId 
    FROM   Documentsignatures dss WITH (nolock) 
           JOIN Documents d WITH (nolock) 
             ON d.DocumentId = dss.DocumentId 
                AND Isnull(dss.RecordDeleted, 'N') = 'N' 
                AND Isnull(d.RecordDeleted, 'N') = 'N' 
           JOIN #documentlist DL 
             ON d.DocumentId = DL.DocumentId 
    WHERE  dss.StaffId = @CurrentUserId 
           AND ( dss.StaffId <> d.AuthorId ) 
           AND ( dss.StaffId <> Isnull(d.ReviewerId, 0) ) 
           AND dss.SignatureDate IS NULL 
           AND Isnull(dss.DeclinedSignature, 'N') = 'N' 
           AND d.CurrentVersionStatus = 22 

    -- Updated ValidationStoredProcedureName in #DocumentList from DocumentCodes and Screens 
    UPDATE Dl 
    SET    Dl.CustomValidationStoreProcedureName = 
  Isnull(DC.ValidationStoredProcedure, SC.ValidationStoredProcedureComplete) 
  ,DocumentVersionId = D.CurrentDocumentVersionId 
  ,Dl.WarningStoredProcedureComplete = SC.WarningStoredProcedureComplete 
  ,Dl.ServiceId = D.ServiceId 
  ,Dl.ServiceNote = DC.ServiceNote 
  ,Dl.DocumentName = DC.DocumentName 
  ,Dl.ClientName = C.LastName + ', ' + C.FirstName 
  ,Dl.PostUpdateProcedureName = SC.PostUpdateStoredProcedure 
  FROM   #documentlist DL 
         JOIN Documents D 
           ON DL.DocumentId = D.DocumentId 
              AND Isnull(D.RecordDeleted, 'N') = 'N' 
         JOIN Documentcodes DC 
           ON D.DocumentCodeId = DC.DocumentCodeId 
              AND Isnull(DC.RecordDeleted, 'N') = 'N' 
         JOIN Screens SC 
           ON SC.DocumentCodeId = DC.DocumentCodeId 
         JOIN Clients C 
           ON D.ClientId = C.ClientId 
              AND Isnull(C.RecordDeleted, 'N') = 'N' 
  WHERE  Isnull(SC.RecordDeleted, 'N') = 'N' 

  SELECT @TotalDocumentList = Count(*) 
  FROM   #documentlist 

  SET @CurrentSequence=1 

  CREATE TABLE #validationreturntablebatch 
    ( 
       TableName        VARCHAR(200) 
       ,ColumnName      VARCHAR(200) 
       ,ErrorMessage    NVARCHAR(max) 
       ,PageIndex       INT 
       ,TabOrder        INT 
       ,ValidationOrder INT 
    ) 

  CREATE TABLE #warningtable 
    ( 
       TableName        VARCHAR(200) 
       ,ColumnName      VARCHAR(200) 
       ,ErrorMessage    VARCHAR(200) 
       ,PageIndex       INT 
       ,TabOrder        INT 
       ,ValidationOrder INT 
    ) 

 IF ( @status <> 'TOACKNOWLEDGE' ) --Added by Prem on 26/07/2017 
 BEGIN
          -- Loop through all DocumentList    
          WHILE ( @CurrentSequence <= @TotalDocumentList ) 
            BEGIN 
                SELECT @ProcedureName = CustomValidationStoreProcedureName 
                       ,@DocumentId = DocumentId 
                       ,@DocumentVersionId = DocumentVersionId 
                       ,@WarningStoredProcedureComplete = 
                        WarningStoredProcedureComplete 
                       ,@ServiceId = ServiceId 
                       ,@DocumentName = DocumentName 
                       ,@ClientName = ClientName 
                       ,@PostUpdateStoredProcedureName = PostUpdateProcedureName 
                FROM   #documentlist 
                WHERE  SequenceId = @CurrentSequence 

                IF NOT EXISTS(SELECT DocumentId 
                              FROM   #tocosign 
                              WHERE  DocumentId = @DocumentId) 
                  --14 Sep 2015 Akwianss 
                  BEGIN 
                      BEGIN try 
                          EXEC Ssp_scvalidatedocument 
                            @CurrentUserId, 
                            @DocumentId, 
                            @ProcedureName, 
                            'Y' 

                          IF EXISTS(SELECT 1 
                                    FROM   #validationreturntablebatch) 
                            BEGIN 
                                UPDATE Dl 
                                SET    Dl.ValidationError = (SELECT 
                                       Replace(Replace(Stuff( 
                                       (SELECT DISTINCT ' <br/> ' 
                                                 + Cast(VRT.ErrorMessage AS 
                                                            VARCHAR(100) ) 
                                               FROM 
                                       #validationreturntablebatch 
                                       VRT 
                                               FOR xml path('')), 1, 1, ''), 
                                               '&lt;', 
                                                '<'), 
                                                    '&gt;', '>')) 
                                       ,Dl.Error = 'Y' 
                                FROM   #documentlist DL 
                                WHERE  Dl.SequenceId = @CurrentSequence 
                            END 
                      END try 

                      BEGIN catch 
                          UPDATE Dl 
                          SET    Dl.ValidationError = @ErrorMsg + ' ( ' 
                                                      + CONVERT(VARCHAR(4000), 
                                                      Error_message 
                                                      () ) 
                                                      + ' )' 
                                 ,Dl.Error = 'Y' 
                          FROM   #documentlist DL 
                          WHERE  Dl.SequenceId = @CurrentSequence 
                      END catch 

                      IF NOT EXISTS(SELECT 1 
                                    FROM   #validationreturntablebatch) 
                        BEGIN 
                            IF @IgnoreWarnings = 'N' 
                              BEGIN 
                                  BEGIN try 
                                      IF @WarningStoredProcedureComplete IS NOT 
                                         NULL 
                                        BEGIN 
                                            INSERT INTO #warningtable 
                                                        (TableName 
                                                         ,ColumnName 
                                                         ,ErrorMessage 
                                                         ,PageIndex 
                                                         ,TabOrder 
                                                         ,ValidationOrder) 
                                            EXEC @WarningStoredProcedureComplete 
                                              @DocumentVersionId 
                                        END 

                                      INSERT INTO #warningtable 
                                                  (TableName 
                                                   ,ColumnName 
                                                   ,ErrorMessage 
                                                   ,PageIndex) 
                                      SELECT ''  AS TableName 
                                             ,'' AS ColumnName 
                                             ,ErrorMessage 
                                             ,1 
                                      FROM   Serviceerrors 
                                      WHERE  ServiceId = @ServiceId 
                                  END try 

                                  BEGIN catch 
                                  END catch 

                                  IF Object_id('tempdb..#warningTable') IS NOT 
                                     NULL 
                                    BEGIN 
                                        IF EXISTS(SELECT 1 
                                                  FROM   #warningtable) 
                                          BEGIN 
                                              INSERT INTO #warninglist 
                                              SELECT @DocumentId 
                                                     ,@DocumentName 
                                                     ,@ClientName 
                                                     ,(SELECT Replace(Replace( 
                                              Stuff((SELECT DISTINCT 
                        Cast(WRT.ErrorMessage 
                        AS 
                        VARCHAR( 
                         100)) 
                        + ' <br/> ' 
                         FROM   #warningtable 
                                WRT 
                         FOR xml path('')), 1, 0 
                        , 
                        ''), 
                        '&lt;', 
                        '<' 
                        ), 
                        '&gt;', '>')) 
                        END 
                        END 

                        DELETE FROM #warningtable 
                        END 
                        END 
                  END 

                IF NOT EXISTS(SELECT 1 
                              FROM   #warninglist 
                              WHERE  DocumentId = @DocumentId) 
                   AND NOT EXISTS(SELECT 1 
                                  FROM   #validationreturntablebatch) 
                   AND NOT EXISTS(SELECT 1 
                                  FROM   #documentlist 
                                  WHERE  SequenceId = @CurrentSequence 
                                         AND error = 'Y') 
                   AND @DocumentsReadyforSign = 'Y' 
                  -- Added by Khusro on 04/27/2015                                                   
                  BEGIN 
                      BEGIN try 
                          EXEC Ssp_scsignaturesignedstaffwithpad 
                            @StaffID=@CurrentUserId, 
                            @DocumentID=@DocumentId, 
                            @ClientSignedPaper='N', 
                            @SignatureData=@SignatureData, 
                            -- Added by Khusro on 04/27/2015 
                            @DocumentVersionId=@DocumentVersionId 

                          --Added By Irfan To Refresh the Document After Signing the Document from the Batch Signature on 05/03/2015
                          IF EXISTS(SELECT 1 
                                    FROM   Documentsignatures 
                                    WHERE  VerificationMode = 'S' 
                                           AND SignerName IS NOT NULL 
                                           AND SignedDocumentVersionId = 
                                               @DocumentVersionId 
                                           AND documentid = @DocumentID 
                                           AND StaffID = @CurrentUserId 
                                           AND SignatureDate IS NOT NULL 
                                           AND Isnull(RecordDeleted, 'N') <> 'Y' 
                                   ) 
                            BEGIN 
                                UPDATE Documentversions 
                                SET    Refreshview = 'Y' 
                                WHERE  Documentversionid = @DocumentVersionId 
                                       AND DocumentID = @DocumentID 
                            END 

                          EXEC Ssp_scdocumentpostsignatureupdates 
                            @CurrentUserId, 
                            @DocumentId 

                          IF @PostUpdateStoredProcedureName IS NOT NULL 
                            BEGIN 
                                EXEC @PostUpdateStoredProcedureName 
                                  @DocumentId, 
                                  @CurrentUserId, 
                                  @ClientName, 
                                  NULL 
                            END 

                          UPDATE Dl 
                          SET    Dl.Error = 'N' 
                          FROM   #documentlist DL 
                          WHERE  Dl.SequenceId = @CurrentSequence 
                      END try 

                      BEGIN catch 
                          UPDATE Dl 
                          SET    Dl.ValidationError = @ErrorMsg + ' ( ' 
                                                      + CONVERT(VARCHAR(4000), 
                                                      Error_message 
                                                      () 
                                                      ) 
                                                      + ' )' 
                                 ,Dl.Error = 'Y' 
                          FROM   #documentlist DL 
                          WHERE  Dl.SequenceId = @CurrentSequence 
                      END catch 
                  END 

                DELETE FROM #validationreturntablebatch 

                SET @CurrentSequence=@CurrentSequence + 1 

                IF ( @CurrentSequence > @TotalDocumentList ) 
                  BREAK 
                ELSE 
                  CONTINUE 
            END 


 END
ELSE --Added by Prem on 26/07/2017 
   --Start
    BEGIN 
        select  @ModifiedBy=UserCode from Staff Where staffid=@CurrentUserId
        UPDATE Documentsacknowledgements  
        SET    DateAcknowledged = CURRENT_TIMESTAMP ,ModifiedBy=@ModifiedBy,Modifieddate=getdate()
        WHERE  DocumentId IN (SELECT DocumentId 
                              FROM   #documentlist) 
               AND AcknowledgedByStaffId = @CurrentUserId  
    END 
        
     --End  
SELECT DocumentId 
         ,CustomValidationStoreProcedureName 
         ,ValidationError 
         ,error 
  FROM   #documentlist 
  
  SELECT DocumentId 
         ,DocumentName 
         ,WarningError 
         ,ClientName 
  FROM   #warninglist  

         
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_BatchDocumentSign' ) 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error,-- Message text.               
                      16,-- Severity.               
                      1 -- State.               
          ); 
      END catch 
  END 

go 