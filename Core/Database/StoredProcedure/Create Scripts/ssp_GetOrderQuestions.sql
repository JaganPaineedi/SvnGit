  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetOrderQuestions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetOrderQuestions] 
GO

  /*********************************************************************/                            
/* Stored Procedure: dbo.ssp_GetOrderQuestions  -1,53,'N'
                     dbo.ssp_GetOrderQuestions  3,26,'N' 
                     dbo.ssp_GetOrderQuestions  3,3,'Y'   */                         
   
/* Creation Date:  08/09/2015             */                            
/* Author: Chethan N                            */                            
/* Purpose: To get Laboratory Questions  
                  */                           
/*                                                                   */                          
/* Input Parameters:             */                          
/*                                                                   */                            
/* Output Parameters:             */                            
/*                                                                   */                            
/*  Date       Author                 Purpose   
 11/07/2017    Pabitra			Engineering Improvement Initiatives- NBL(I)#585 
 26/04/2018    Chethan N        What : Added RecordDeleted check  
								Why : Engineering Improvement Initiatives- NBL(I)#585.2		*/                     
/*********************************************************************/       
Create Procedure [dbo].[ssp_GetOrderQuestions]      
@LaboratoryId INT,   
@OrderId INT, 
@IsOrderSet CHAR(1), 
@Orderlist VARCHAR(MAX)=NULL    
AS      
BEGIN      
BEGIN TRY    
     
CREATE TABLE #TemplateResult  
(QuestionId INT,  
CreatedBy VARCHAR(200),  
CreatedDate DATETIME,  
ModifiedBy varchar(250),  
ModifiedDate DATETIME,  
RecordDeleted CHAR(1),  
DeletedDate DATETIME,  
DeletedBy VARCHAR(250),  
Question VARCHAR(300),
OrderId INT,
AnswerType INT,
AnswerRelatedCategory VARCHAR(20),
IsRequired CHAR(1),
AnswerTypeName VARCHAR(500),
ShowQuestionTimeOption CHAR(1),
LaboratoryId INT,
QuestionCode VARCHAR(100),
OrderName VARCHAR(500),
QuestionNumber int
)  

IF(@IsOrderSet='N')
BEGIN  
 INSERT INTO  #TemplateResult     
SELECT ORQ.QuestionId  
   ,ORQ.CreatedBy  
   ,ORQ.CreatedDate  
   ,ORQ.ModifiedBy  
   ,ORQ.ModifiedDate  
   ,ORQ.RecordDeleted  
   ,ORQ.DeletedDate  
   ,ORQ.DeletedBy  
   ,ORQ.Question  
   ,ORQ.OrderId  
   ,ORQ.AnswerType  
   ,ORQ.AnswerRelatedCategory  
   ,ORQ.IsRequired  
   ,[dbo].[Getglobalcodename](ORQ.AnswerType) AS AnswerTypeName  
   ,ORQ.ShowQuestionTimeOption  
   ,ORQ.LaboratoryId AS LaboratoryId  
   ,ORQ.QuestionCode AS QuestionCode 
   ,ORD.OrderName 
   ,row_number() OVER(partition by ORQ.OrderId  order by ORQ.OrderId,ORQ.QuestionId ) as QuestionNumber 
  FROM OrderQuestions ORQ  
  JOIN Orders ORD ON ORD.OrderId=ORQ.OrderId  
  WHERE ORD.OrderId = @OrderId  
   AND Isnull(ORQ.RecordDeleted, 'N') <> 'Y'  
   AND ISNULL(ShowQuestionTimeOption,'O')='O'  
   AND ( ( ORD.OrderType = 6481 AND (   
    ORQ.LaboratoryId = 0 
    OR ORQ.LaboratoryId = @LaboratoryId  
    ) OR ORD.OrderType <> 6481)  )
    
      
 UPDATE #TemplateResult SET OrderName=NULL
 WHERE QuestionNumber>1
    
  SELECT * FROM  #TemplateResult
  
    END
    ELSE
    BEGIN

    
    
   INSERT INTO  #TemplateResult 
   
    SELECT ORQ.QuestionId  
   ,ORQ.CreatedBy  
   ,ORQ.CreatedDate  
   ,ORQ.ModifiedBy  
   ,ORQ.ModifiedDate  
   ,ORQ.RecordDeleted  
   ,ORQ.DeletedDate  
   ,ORQ.DeletedBy  
   ,ORQ.Question  
   ,ORQ.OrderId  
   ,ORQ.AnswerType  
   ,ORQ.AnswerRelatedCategory  
   ,ORQ.IsRequired  
   ,[dbo].[Getglobalcodename](ORQ.AnswerType) AS AnswerTypeName  
   ,ORQ.ShowQuestionTimeOption  
   ,ORQ.LaboratoryId AS LaboratoryId  
   ,ORQ.QuestionCode AS QuestionCode 
   ,ORD.OrderName 
   ,row_number() OVER(partition by ORQ.OrderId  order by ORQ.OrderId,ORQ.QuestionId ) as QuestionNumber 
  FROM OrderQuestions ORQ  
  JOIN Orders ORD ON ORD.OrderId=ORQ.OrderId  AND ISNULL(ORD.RecordDeleted, 'N') = 'N'
  JOIN OrderSetAttributes OSA ON OSA.OrderId =ORD.OrderId AND ISNULL(OSA.RecordDeleted, 'N') = 'N'
  JOIN OrderSets OS ON OS.OrderSetId=OSA.OrderSetId  
  WHERE OS.OrderSetId = @OrderId  
  AND ORQ.OrderId NOT IN (SELECT token
  FROM dbo.SplitString(@Orderlist, ','))
   AND Isnull(ORQ.RecordDeleted, 'N') <> 'Y'  
   AND ISNULL(ShowQuestionTimeOption,'O')='O'  
   AND ( ( ORD.OrderType = 6481 AND (   
    ORQ.LaboratoryId = 0 
    OR ORQ.LaboratoryId = @LaboratoryId  
    ) OR ORD.OrderType <> 6481)  )
  
 UPDATE #TemplateResult SET OrderName=NULL
 WHERE QuestionNumber>1
    
  SELECT * FROM  #TemplateResult
  
    END
    
   END TRY                    
 BEGIN CATCH                  
 DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetOrderQuestions') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);              
 END CATCH       
      
END      