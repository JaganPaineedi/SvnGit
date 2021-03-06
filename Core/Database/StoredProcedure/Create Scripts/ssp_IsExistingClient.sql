IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_IsExistingClient]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_IsExistingClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
   

/****** Object:  StoredProcedure [dbo].[ssp_IsExistingClient]    Script Date: 07/09/2012 14:21:45 ******/




CREATE PROCEDURE [dbo].[ssp_IsExistingClient] @ClientId INT   
   
/*********************************************************************************/            
/* Stored Procedure: ssp_IsExistingClient 4           */   
/* Copyright: Streamline Healthcare Solutions          */            
/* Creation Date:  2012-09-21              */            
/* Purpose: Populates Progress Note Template list page         */           
/* Input Parameters:@SessionId,@InstanceId,@PageNumber,@PageSize,@SortExpression,*/  
/*      @Active,@TagTypeId ,@Others      */          
/* Return:                      */            
/*       */            
/* Calls:                   */            
/* Data Modifications:                */            
/* Updates:                   */            
/* Date              Author             Purpose          */          
/* 2012-09-21   Vaibhav khare  Created          */  
/* 2016-12-16   Pabitra What: Added code to check the SystemConfiguration for  EMCoding Documents 
                        Why:  Camino Support Go Live #237 */
/*********************************************************************************/  
	
AS

BEGIN                                                              
	BEGIN TRY
	
   DECLARE @DocumentCodeIDs  CHAR(500)        
   SET @DocumentCodeIDs=( SELECT TOP 1 Value FROM SystemConfigurationKeys WHERE  [KEY]='EMCodingDocumentCodes' AND ISNULL(RecordDeleted,'N') = 'N' )  
   CREATE TABLE #tempDocuemntCodeList(DocuemntCodeList  VARCHAR(500) NULL)   
   INSERT INTO  #tempDocuemntCodeList(DocuemntCodeList)    
   SELECT item  FROM [dbo].fnSplit(@DocumentCodeIDs, ',')    
  
IF EXISTS(Select  DocumentVersionId from  DocumentProgressNotes DPN where DPN.ClientId=@ClientId AND ISNULL(DPN.RecordDeleted,'N') = 'N' )  
or EXISTS(Select D.InProgressDocumentVersionId from  Documents D where D.ClientId=@ClientId  AND ISNULL(D.RecordDeleted,'N') = 'N' AND D.Status=22   AND D.DocumentCodeId IN( Select DocuemntCodeList  from  #tempDocuemntCodeList ))  
BEGIN  
 SELECT 'True' as 'Result'  
END  
ELSE   
BEGIN   
SELECT 'False' as 'Result'   
END  
--Select case when  COUNT(DocumentVersionId)>1 THEN 'True' ELSE 'False' END AS 'Result'from  DocumentProgressNotes where ClientId=@ClientId
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_IsExistingClient')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END


