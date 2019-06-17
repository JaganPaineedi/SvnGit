/****** Object:  StoredProcedure [dbo].[csp_SCGetSOCFunctionalCognitiveDetails]    Script Date: 09/24/2017 14:33:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetSOCFunctionalCognitiveDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetSOCFunctionalCognitiveDetails]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetSOCFunctionalCognitiveDetails]    Script Date: 09/24/2017 14:33:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[csp_SCGetSOCFunctionalCognitiveDetails] @ClientId INT  
 ,@Startdate DATE  
 ,@EndDate DATE  
 ,@Type VARCHAR(1)  
AS /*********************************************************************/  
/* Stored Procedure: dbo.csp_SCGetSOCFunctionalCognitiveDetails            */  
/* Creation Date:    22/Aug/2017                */  
/* Purpose:  To Get summary Of care Functional, Cognitive ,Assessment and Plan of Treatment                */  
/*    Exec ssp_SCGetSOCFunctionalCognitiveDetails                                              */  
/* Input Parameters:                           */  
/* Date   Author   Purpose              */  
/* 22/Aug/2017  Gautam   Created           Certification MU3   */  
/*********************************************************************/  
BEGIN  
 BEGIN TRY  
  DECLARE @OrderIdForFunctionalStatus INT = 763 --@Type='F'        
  DECLARE @OrderIdForCognitiveStatus INT = 764 --@Type='C'        
  DECLARE @OrderIdForAssessment INT = 757 --@Type='A'        
  DECLARE @OrderIdForPlanofTreatment INT = 758 --@Type='A'        
  DECLARE @OrderIdForGoals INT = 759 --@Type='A'        
  DECLARE @OrderIdForHealthConcerns INT = 760 --@Type='A'        
  DECLARE @OrderIdForReasonforReferral INT = 761 --@Type='A'        
  DECLARE @OrderIdForDischargeInstructions INT = 762 --@Type='A'       
  DECLARE @OrderIdForUDI INT = 766 --@Type='U'   --Implantable Devices  
  DECLARE @OrderIdForProcedures INT = 765 --@Type='P'   --Procedures  
  
  INSERT INTO #FunctionalCognitiveDetails (  
   EffectiveDate  
   ,Question  
   ,answer  
   ,OrderName  
   ,SnomedCode
   ,AgencyName
   ,[Address]
   ,City
   ,[State]
   ,ZipCode
   ,MainPhone  
   )  
  SELECT DISTINCT CONVERT(VARCHAR, D.EffectiveDate, 107) AS EffectiveDate  
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
          OR CQ.AnswerType = 8537  
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
   ,O.OrderName  
   ,GC.ExternalCode1 As SnomedCode  
   ,A.AgencyName
   ,A.Address
   ,A.City
   ,A.State
   ,A.ZipCode
   ,A.MainPhone
  FROM OrderQuestions OQ  
  JOIN ClientOrders CO ON OQ.Orderid = CO.OrderId  
  JOIN Documents D ON CO.DocumentVersionId = CO.DocumentVersionId  
   AND ISNULL(D.RecordDeleted, 'N') = 'N'  
  JOIN Orders O ON CO.OrderId = O.OrderId  
  JOIN dbo.ClientOrderQnAnswers CQ ON CQ.QuestionId = OQ.QuestionId  
   AND CO.ClientOrderId = CQ.ClientOrderId  
  LEFT JOIN GlobalCodes GC ON Gc.GlobalCodeId = CQ.AnswerValue  
   AND ISNULL(Gc.RecordDeleted, 'N') <> 'Y' 
  CROSS JOIN  Agency A 
  WHERE CO.ClientId = @ClientId  
   AND cast(CO.OrderStartDateTime AS DATE) >= @Startdate  
   AND (  
    OrderEndDateTime IS NULL  
    OR cast(OrderEndDateTime AS DATE) <= @EndDate  
    )  
   AND D.DocumentCodeId = 1506  
   AND cast(D.EffectiveDate AS DATE) >= @Startdate  
   AND (cast(D.EffectiveDate AS DATE) <= @EndDate)  
   AND (  
    (  
     @Type = 'F'  
     AND O.OrderId IN (@OrderIdForFunctionalStatus)  
     )  
    OR (  
     @Type = 'C'  
     AND O.OrderId IN (@OrderIdForCognitiveStatus)  
     )  
    OR (  
     @Type = 'A'  
     AND O.OrderId IN (  
      @OrderIdForAssessment  
      ,@OrderIdForPlanofTreatment  
      ,@OrderIdForGoals  
      ,@OrderIdForHealthConcerns  
      ,@OrderIdForReasonforReferral  
      ,@OrderIdForDischargeInstructions  
      )  
     )  
    OR (  
     @Type = 'U'  
     AND O.OrderId IN (@OrderIdForUDI)  
     )  
    OR (  
     @Type = 'P'  
     AND O.OrderId IN (@OrderIdForProcedures)  
     )  
    )  
   AND ISNULL(OQ.RecordDeleted, 'N') = 'N'  
   AND ISNULL(CQ.RecordDeleted, 'N') = 'N'  
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(max)  
  
  SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'csp_SCGetSOCFunctionalCognitiveDetails') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR,   
    error_severity()) + '*****' + convert(VARCHAR, error_state())  
  
  RAISERROR (  
    @Error  
    ,  
    -- Message text.               
    16  
    ,  
    -- Severity.                                                                                                 
    1  
    -- State.                                                                                                 
    );  
 END CATCH  
END  
GO


