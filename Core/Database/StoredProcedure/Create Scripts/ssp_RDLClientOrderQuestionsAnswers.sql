IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientOrderQuestionsAnswers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClientOrderQuestionsAnswers]
GO
/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderQuestionsAnswers]    Script Date: 03/18/2014 12:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[ssp_RDLClientOrderQuestionsAnswers]
(@ClientOrderId int)
/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 18-mar-2014    Revathi      What:Get ClientOrders Questions and answer
                             Why:Philhaven Development #26 Inpatient Order Management
19-Sep-2017		Ravichandra  What: Made Left join ClientOrderQnAnswers (not answered to questions also need to show)
								   And Added CQ.AnswerType=8820 (Add Flowsheet-- Text box) in answer case statement 
							 Why:  Bear River - Support Go Live > Tasks #318.         
************************************************/
As
BEGIN				
	Begin Try 	
	create table #Questions
(QId int,
Que varchar(max),
ans varchar(max))


Insert into #Questions
select distinct  
   OQ.QuestionId
   ,OQ.Question   
   ,(case when (CQ.AnswerType=8535 or  CQ.AnswerType=8536 or  CQ.AnswerType=8538) then GC.CodeName
   else (case when (CQ.AnswerType=8537 or  CQ.AnswerType=8820 OR CQ.AnswerType=8539) then CQ.AnswerText else
   case when  CQ.AnswerType=8540 then CONVERT(VARCHAR(10), CQ.AnswerDateTime, 101) else 
   (CASE WHEN RIGHT(CONVERT(varchar, CQ.AnswerDateTime, 100), 8) = ' 12:00AM' THEN CONVERT(varchar, CQ.AnswerDateTime, 101) ELSE CONVERT(varchar, CQ.AnswerDateTime, 101) +' '+ RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,CQ.AnswerDateTime,0),7)),7) END)
    end
    end) end) as answer   
   from OrderQuestions OQ
   join  ClientOrders  CO on OQ.Orderid = CO.OrderId
   LEFT join dbo.ClientOrderQnAnswers CQ on CQ.QuestionId=OQ.QuestionId and CO.ClientOrderId= CQ.ClientOrderId AND ISNULL(CQ.RecordDeleted,'N')<>'Y'
   left join GlobalCodes GC on Gc.GlobalCodeId=CQ.AnswerValue AND ISNULL(Gc.RecordDeleted,'N')<>'Y'
   where CO.ClientOrderId=@ClientOrderId 
   AND ISNULL(OQ.RecordDeleted,'N')<>'Y' 
   AND ISNULL(CO.RecordDeleted,'N')<>'Y'
   
  Select QU.QId as 'QuestionId',QU.Que as 'Question',REPLACE(REPLACE(STUFF(  
      (SELECT Distinct ', ' + QE.ans    
      From #Questions QE 
      Where QU.QId=QE.QId              
      FOR XML PATH(''))  
      ,1,1,'')  
      ,'&lt;','<'),'&gt;','>')'Answer'          
 From #Questions QU 
 group by  QU.QId,QU.Que
End Try
		BEGIN CATCH          
		DECLARE @Error varchar(8000)                                                 
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLClientOrderQuestionsAnswers')                                                                               
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
		+ '*****' + Convert(varchar,ERROR_STATE())                                           
		RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
	END CATCH          
END			
		
					
				