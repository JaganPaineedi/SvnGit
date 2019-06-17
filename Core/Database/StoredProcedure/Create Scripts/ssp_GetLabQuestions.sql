/****** Object:  StoredProcedure [dbo].[ssp_GetLabQuestions]    Script Date: 09/08/2015 14:27:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetLabQuestions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetLabQuestions]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetLabQuestions]    Script Date: 09/08/2015 14:27:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*********************************************************************/                          
/* Stored Procedure: dbo.ssp_GetLabQuestions     */                          
/* Creation Date:  08/09/2015                                        */                          
/* Author: Chethan N                                                                  */                          
/* Purpose: To get Laboratory Questions
                  */                         
/*                                                                   */                        
/* Input Parameters:             */                        
/*                                                                   */                          
/* Output Parameters:             */                          
/*                                                                   */                          
/*  Date                  Author                 Purpose             */                   
/*********************************************************************/     
CREATE Procedure [dbo].[ssp_GetLabQuestions]    
@LaboratoryId INT, 
@OrderId INT    
AS    
BEGIN    
BEGIN TRY    
     
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
		FROM OrderQuestions ORQ
		JOIN Orders ORD ON ORD.OrderId=ORQ.OrderId
		WHERE ORD.OrderId = @OrderId
			AND Isnull(ORQ.RecordDeleted, 'N') <> 'Y'
			AND (ISNULL(ORQ.ShowQuestionTimeOption,'B')='O' OR ISNULL(ORQ.ShowQuestionTimeOption,'B')='B')
			AND ( ORD.OrderType = 6481 AND ( 
				ISNULL(ORQ.LaboratoryId, 0)=0
				OR ORQ.LaboratoryId = @LaboratoryId
				) )
   END TRY                  
 BEGIN CATCH                
  DECLARE @Error VARCHAR(8000) 

        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                    + CONVERT(VARCHAR(4000), Error_message()) 
                    + '*****' 
                    + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                    'ssp_GetLabQuestions') 
                    + '*****' + CONVERT(VARCHAR, Error_line()) 
                    + '*****' + CONVERT(VARCHAR, Error_severity()) 
                    + '*****' + CONVERT(VARCHAR, Error_state()) 

        RAISERROR ( @Error,-- Message text.             
                    16,-- Severity.             
                    1 -- State.             
        );                   
 END CATCH     
    
END    
GO


