   
 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCGetVitals]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLSCGetVitals]
GO   
   
CREATE PROCEDURE [dbo].[csp_RDLSCGetVitals] (@DocumentVersionId int  )    
AS    
/*********************************************************************/    
/* Stored Procedure: [csp_RDLSCGetVitals] 34708
34708
  */    
/*       Date              Author                  Purpose                   */    
/*      12-29-2014         PABITRA              To Get Vitals Data          */    
/*********************************************************************/    
BEGIN    
 BEGIN TRY  
 DECLARE @ClientId INT    
  
  DECLARE @DateOfService DATETIME    
   
   SELECT @ClientId = D.ClientId    
    ,@DateOfService=S.DateOfService      
   FROM Documents D      
    INNER JOIN Services S ON D.ServiceId=S.ServiceId      
   WHERE D.InProgressDocumentVersionId=@DocumentVersionId AND      
   IsNull(D.RecordDeleted,'N')='N'      
   AND IsNull(S.RecordDeleted,'N')='N'     
   
  DECLARE @IntegerCodeId INT    
    
  SET @IntegerCodeId = (    
    SELECT integercodeid    
    FROM dbo.Ssf_recodevaluescurrent('XPSYCHIATRICNOTEVITAL')    
    )    
    
  CREATE TABLE #tempvitals (    
   rowid INT PRIMARY KEY IDENTITY(1, 1)    
   ,healthdatatemplateid INT    
   ,healthdatasubtemplateid INT    
   ,healthdataattributeid INT    
   ,subtemplatename VARCHAR(20)    
   ,attributename VARCHAR(50)    
   ,value VARCHAR(20)    
   ,healthrecorddate DATETIME    
   ,clienthealthdataattributeid INT    
   ,datatype INT    
   )    
    
  INSERT INTO #tempvitals    
  SELECT ta.healthdatatemplateid    
   ,ta.healthdatasubtemplateid    
   ,st.healthdataattributeid    
   ,s.NAME    
   ,a.NAME    
   ,chd.value    
   ,chd.healthrecorddate    
   ,chd.clienthealthdataattributeid    
   ,a.datatype    
  FROM healthdatatemplateattributes ta    
  INNER JOIN healthdatasubtemplateattributes st ON ta.healthdatasubtemplateid = st.healthdatasubtemplateid    
  INNER JOIN healthdatasubtemplates s ON ta.healthdatasubtemplateid = s.healthdatasubtemplateid    
  INNER JOIN healthdataattributes a ON a.healthdataattributeid = st.healthdataattributeid    
  INNER JOIN clienthealthdataattributes chd ON chd.healthdataattributeid = st.healthdataattributeid    
  WHERE ta.healthdatatemplateid = @IntegerCodeId    
   AND Isnull(ta.recorddeleted, 'N') <> 'Y'    
   AND chd.clientid = @ClientID    
   AND chd.healthrecorddate = (    
    SELECT Max(healthrecorddate)    
    FROM clienthealthdataattributes    
    WHERE clientid = @ClientID    
    )    
   AND Isnull(st.recorddeleted, 'N') <> 'Y'    
   AND Isnull(s.recorddeleted, 'N') <> 'Y'    
   AND Isnull(a.recorddeleted, 'N') <> 'Y'    
   AND Isnull(chd.recorddeleted, 'N') <> 'Y'    
    
  DECLARE @Currentvitals VARCHAR(max)    
  DECLARE @CurrentVitalDate AS DATETIME    
  DECLARE @CurrentLatestHealthRecordFormated VARCHAR(max)    
    
  SET @CurrentVitalDate = (    
    SELECT Max(healthrecorddate)    
    FROM clienthealthdataattributes    
    WHERE clientid = @ClientID    
    )    
  SET @Currentvitals = ''    
  SET @CurrentLatestHealthRecordFormated = ''    
    
  SELECT @Currentvitals = @Currentvitals + ' ' + attributename + ': ' + Isnull(CASE     
     WHEN datatype = 8081    
      THEN dbo.Getglobalcodename(value)    
     ELSE value    
     END, '') + '<br>'    
  FROM #tempvitals    
  ORDER BY attributename    
    
  SET @CurrentLatestHealthRecordFormated = (    
    SELECT CONVERT(VARCHAR, @CurrentVitalDate, 101)    
    )    
    
  IF NOT (    
    --NULLIF(@CurrentLatestHealthRecordFormated, '') IS NULL          
    --AND           
    NULLIF(@Currentvitals, '') IS NULL    
    )    
  BEGIN    
   SET @Currentvitals = @Currentvitals    
  END    
  ELSE    
  BEGIN    
   SET @Currentvitals = ''    
  END    
    
  --SELECT  LEFT(@Currentvitals,LEN(@Currentvitals)-1) AS Value           
  DECLARE @CountofPrevious AS INT    
  DECLARE @SecondLatestHealthRecord AS DATETIME    
  DECLARE @PreviousVitalsWithDate VARCHAR(max)    
    
  SET @PreviousVitalsWithDate = ''    
    
  DECLARE @SecondLatestHealthRecordFormated VARCHAR(max)    
    
  SET @SecondLatestHealthRecordFormated = ''    
    
  DECLARE @PreviousVitals VARCHAR(max)    
    
  SET @PreviousVitals = ''    
  SET @CountofPrevious = (    
    SELECT Count(DISTINCT healthrecorddate)    
    FROM clienthealthdataattributes    
    WHERE clientid = @ClientID    
    )    
    
  IF (@CountofPrevious > 1)    
  BEGIN    
   SET @SecondLatestHealthRecord = (    
     SELECT DISTINCT healthrecorddate    
     FROM clienthealthdataattributes    
     WHERE clientid = @ClientID    
      AND healthrecorddate = (    
       SELECT Min(healthrecorddate)    
       FROM (    
        SELECT DISTINCT TOP (2) healthrecorddate    
        FROM clienthealthdataattributes    
        WHERE clientid = @ClientID    
        ORDER BY healthrecorddate DESC    
        ) T    
       )    
     )    
    
   DELETE    
   FROM #tempvitals    
    
   INSERT INTO #tempvitals    
   SELECT ta.healthdatatemplateid    
    ,ta.healthdatasubtemplateid    
    ,st.healthdataattributeid    
    ,s.NAME    
    ,a.NAME    
    ,chd.value    
    ,chd.healthrecorddate    
    ,chd.clienthealthdataattributeid    
    ,a.datatype    
   FROM healthdatatemplateattributes ta    
   INNER JOIN healthdatasubtemplateattributes st ON ta.healthdatasubtemplateid = st.healthdatasubtemplateid    
   INNER JOIN healthdatasubtemplates s ON ta.healthdatasubtemplateid = s.healthdatasubtemplateid    
   INNER JOIN healthdataattributes a ON a.healthdataattributeid = st.healthdataattributeid    
   INNER JOIN clienthealthdataattributes chd ON chd.healthdataattributeid = st.healthdataattributeid    
   WHERE ta.healthdatatemplateid = @IntegerCodeId    
    AND Isnull(ta.recorddeleted, 'N') <> 'Y'    
    AND chd.clientid = @ClientID    
    AND chd.healthrecorddate = @SecondLatestHealthRecord    
    AND Isnull(st.recorddeleted, 'N') <> 'Y'    
    AND Isnull(s.recorddeleted, 'N') <> 'Y'    
    AND Isnull(a.recorddeleted, 'N') <> 'Y'    
    AND Isnull(chd.recorddeleted, 'N') <> 'Y'    
    
   SELECT @PreviousVitals = @PreviousVitals + ' ' + attributename + ': ' + Isnull(CASE     
      WHEN datatype = 8081    
       THEN dbo.Getglobalcodename(value)    
      ELSE value    
      END, '') + '<br>'    
   FROM #tempvitals    
   ORDER BY attributename    
    
   SET @SecondLatestHealthRecordFormated = (    
     SELECT CONVERT(VARCHAR, @SecondLatestHealthRecord, 101)    
     )    
  END    
    
  --SET @PreviousVitalsWithDate='Date/Time: '+ IsNull(@SecondLatestHealthRecordFormated,'') + CHAR(13) + @PreviousVitals          
  IF NOT (    
    --NULLIF(@SecondLatestHealthRecordFormated, '') IS NULL          
    --AND           
    NULLIF(@PreviousVitals, '') IS NULL    
    )    
  BEGIN    
   SET @PreviousVitalsWithDate = @PreviousVitals    
  END    
  ELSE    
  BEGIN    
   SET @PreviousVitalsWithDate = ''    
  END    
    
  DROP TABLE #tempvitals    
    
  SELECT 'CustomDocumentPsychiatricNoteExams' AS TableName    
   ,@PreviousVitalsWithDate AS VitalsPrevious    
   ,@Currentvitals AS VitalsCurrent    
   ,@CurrentLatestHealthRecordFormated AS CurreentVitalDate    
   ,@SecondLatestHealthRecordFormated AS PreviousVitalDate    
  FROM systemconfigurations s    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE())  
   + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
  'csp_RDLSCGetVitals') + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' +   
  CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                                                    
    16    
    ,-- Severity.                                                                                                                    
    1 -- State.                                                                                                                    
    );    
 END CATCH    
END 