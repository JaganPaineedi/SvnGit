/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderElectronicRequisitionQuestionsAnswers]    Script Date: 01/29/2019 10:51:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientOrderElectronicRequisitionQuestionsAnswers]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.ssp_RDLClientOrderElectronicRequisitionQuestionsAnswers
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderElectronicRequisitionQuestionsAnswers]    Script Date: 01/29/2019 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
CREATE PROCEDURE [dbo].[ssp_RDLClientOrderElectronicRequisitionQuestionsAnswers] (@ClientOrderId INT)  
 /********************************************************************************************************     
    Report Request:     
     Details ... Gulf Bend - Enhancements > Tasks #211 > CPL - Add Lab  
  
             
    Purpose:  
    Parameters: DocumentVersionId  
    Modified Date   Modified By   Reason     
    ----------------------------------------------------------------     
    Ravi      21/11/2018   Created  Gulf Bend - Enhancements > Tasks #211> CPL - Add Lab  
    ************************************************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  CREATE TABLE #Questions (  
   QId INT  
   ,Que VARCHAR(max)  
   ,ans VARCHAR(max)  
   )  
  
  INSERT INTO #Questions  
  SELECT DISTINCT OQ.QuestionId  
   ,OQ.Question  
   ,(  
    CASE   
     WHEN (  
       CQ.AnswerType = 8535  
       OR CQ.AnswerType = 8536  
       OR CQ.AnswerType = 8538  
       )  
      THEN GC.CodeName  
     ELSE (  
       CASE   
        WHEN (  
          CQ.AnswerType = 8537  
          OR CQ.AnswerType = 8820  
          OR CQ.AnswerType = 8539  
          )  
         THEN CQ.AnswerText  
        ELSE CASE   
          WHEN CQ.AnswerType = 8540  
           THEN CONVERT(VARCHAR(10), CQ.AnswerDateTime, 101)  
          ELSE (  
            CASE   
             WHEN RIGHT(CONVERT(VARCHAR, CQ.AnswerDateTime, 100), 8) = ' 12:00AM'  
              THEN CONVERT(VARCHAR, CQ.AnswerDateTime, 101)  
             ELSE CONVERT(VARCHAR, CQ.AnswerDateTime, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, CQ.AnswerDateTime, 0), 7)), 7)  
             END  
            )  
          END  
        END  
       )  
     END  
    ) AS answer  
  FROM OrderQuestions OQ  
  JOIN ClientOrders CO ON OQ.Orderid = CO.OrderId  
  LEFT JOIN dbo.ClientOrderQnAnswers CQ ON CQ.QuestionId = OQ.QuestionId  
   AND CO.ClientOrderId = CQ.ClientOrderId  
   AND ISNULL(CQ.RecordDeleted, 'N') = 'N'  
  LEFT JOIN GlobalCodes GC ON Gc.GlobalCodeId = CQ.AnswerValue  
   AND ISNULL(Gc.RecordDeleted, 'N') = 'N'  
  WHERE CO.ClientOrderId = @ClientOrderId  
   AND ISNULL(OQ.RecordDeleted, 'N') = 'N'  
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'  
  
  DELETE FROM #Questions WHERE Que= 'Fasting' AND isnull(ans, '') = ''

  SELECT QU.QId AS 'QuestionId'  
   ,QU.Que + ': '  AS 'Question'  
   ,REPLACE(REPLACE(STUFF((  
       SELECT DISTINCT ', ' + QE.ans  
       FROM #Questions QE  
       WHERE QU.QId = QE.QId  
       FOR XML PATH('')  
       ), 1, 1, ''), '&lt;', '<'), '&gt;', '>') 'Answer'  
  FROM #Questions QU  
  GROUP BY QU.QId  
   ,QU.Que  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClientOrderElectronicRequisitionQuestionsAnswers') + '*****' + Convert(VARCHAR, ERROR_LINE(
)) + '*****ERROR  
_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error /* Message text*/  
    ,16 /*Severity*/  
    ,1 /*State*/  
    )  
 END CATCH  
END  