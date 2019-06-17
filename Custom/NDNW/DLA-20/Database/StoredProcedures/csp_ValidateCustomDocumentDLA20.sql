/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentDLA20]    Script Date: 06/30/2014 18:07:09 ******/ 
IF EXISTS 
( 
       SELECT * 
       FROM   sys.objects 
       WHERE  object_id = Object_id(N'[dbo].[csp_ValidateCustomDocumentDLA20]') 
       AND    type IN (N'P', 
                       N'PC')) 
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDLA20] --545600
go 
/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentDLA20]    Script Date: 06/30/2014 18:07:09 ******/SET ansi_nulls ON
go
SET quoted_identifier ON
go
CREATE PROCEDURE [dbo].[Csp_validatecustomdocumentdla20] 
  @DocumentVersionId INT 
AS 
  BEGIN 
   BEGIN try 
      /************************************************************** 
          Created By   : Veena 
          Created Date : 23 Feb 2018 
          Description  : Used to Validate Custom DLA 20 Document 
          Called From  : DLA 20 
          /*  Date     Author      Description */ 
          /*  23 Feb 2018       Veena          Created    */ 
          **************************************************************/ 
      DECLARE @DocumentType   VARCHAR(10) 
      DECLARE @ClientId       INT 
      DECLARE @EffectiveDate  DATETIME 
      DECLARE @StaffId        INT 
      DECLARE @DocumentCodeId INT 
      SELECT @ClientId = d.clientid 
      FROM   documents d 
      WHERE  d.inprogressdocumentversionid = @DocumentVersionId 
      SELECT @StaffId = d.authorid 
      FROM   documents d 
      WHERE  d.inprogressdocumentversionid = @DocumentVersionId 
      SET @EffectiveDate = CONVERT(DATETIME, CONVERT(VARCHAR, Getdate(), 101)) 
      CREATE TABLE [#validationreturntable] 
                   ( 
                                tablename       VARCHAR(100) NULL, 
                                columnname      VARCHAR(100) NULL, 
                                errormessage    VARCHAR(max) NULL, 
                                taborder        INT NULL, 
                                validationorder INT NULL 
                   ) 
      IF NOT EXISTS 
      ( 
             SELECT 1 
             FROM   customdocumentvalidationexceptions 
             WHERE  documentversionid = @DocumentVersionId 
             AND    documentvalidationid IS NULL 
      ) 
      BEGIN 
        IF NOT EXISTS 
        ( 
               SELECT 1 
               FROM   customdocumentdla20s 
               WHERE  documentversionid = @DocumentVersionId 
               AND    Isnull(nodla,'N')= 'Y' 
        ) 
        BEGIN 
        
          DECLARE @clientAge VARCHAR(50), 
            @Activity        INT 
          EXEC Csp_calculateage 
            @ClientId, 
            @clientAge out 
          SET @clientAge=Replace(Isnull( @clientAge, '' ),'Years', '' ) 
          SET @clientAge=Replace(Isnull( @clientAge, '' ),'Months', '' ) 
          IF(@clientAge >= 18) 
          BEGIN 
            
            SELECT @Activity = Count(documentversionid) 
            FROM   customdailylivingactivityscores 
            WHERE  ( 
                          activityscore IS NOT NULL 
                   OR     activitycomment IS NOT NULL) 
            AND    documentversionid = @DocumentVersionId 
            AND    Isnull(recorddeleted,'N')<>'Y' 
            IF (@Activity = 0) 
            BEGIN 
              INSERT INTO #validationreturntable 
                          ( 
                                      tablename, 
                                      columnname, 
                                      errormessage, 
                                      taborder, 
                                      validationorder 
                          ) 
              SELECT 'CustomDailyLivingActivityScores', 
                     'ActivityScore', 
                     'DLA 20 - DLA 20 - Activities  - At least one Activity is required or select No DLA Activities', 
                     1,1 
            END 
          END 
         
        ELSE 
        BEGIN 
          SELECT @Activity = Count(documentversionid) 
          FROM   customyouthdlascores 
          WHERE  ( 
                        activityscore IS NOT NULL 
                 OR     activitycomment IS NOT NULL) 
          AND    documentversionid = @DocumentVersionId 
          AND    Isnull(recorddeleted,'N')<>'Y' 
          IF (@Activity = 0) 
          BEGIN 
            INSERT INTO #validationreturntable 
                        ( 
                                    tablename, 
                                    columnname, 
                                    errormessage, 
                                    taborder, 
                                    validationorder 
                        ) 
            SELECT 'CustomYouthDLAScores', 
                   'ActivityScore', 
                   'DLA 20 - DLA 20 Y - Activities  - At least one Activity is required or select No DLA Activities.', 
                   1,1 
          END 
        END 
       
     select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by taborder,ValidationOrder

   
               END
       END
    END try 
    BEGIN catch 
      DECLARE @Error VARCHAR(8000) 
      SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'csp_ValidateCustomDocumentDLA20') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())
      RAISERROR ( @Error ,-- Message text. 
      16 ,                -- Severity. 
      1                   -- State. 
      ); 
    END catch 
  END
  go