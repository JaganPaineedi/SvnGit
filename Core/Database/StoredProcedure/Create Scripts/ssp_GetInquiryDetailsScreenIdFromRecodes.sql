IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetInquiryDetailsScreenIdFromRecodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetInquiryDetailsScreenIdFromRecodes]
GO
/********************************************************************************                                                    
-- Stored Procedure: ssp_GetInquiryDetailsScreenIdFromRecodes
-- Copyright: Streamline Healthcate Solutions
-- Purpose: Procedure to return Inquiry Screen Id to the Reception Triage Arrival Details page.
-- Author:  Avi Goyal
-- Date:    03 Jul 2015  
-- *****History****  
-- Date				Author			Purpose
---------------------------------------------------------------------------------
-- 03 Jul 2015		Avi Goyal		What :Created 
									Why: Task 331 Reception - New Arrival - Arrival Details - Open Inquiry of Valley Client Acceptance Testing Issues
*********************************************************************************/  
CREATE PROCEDURE [dbo].[ssp_GetInquiryDetailsScreenIdFromRecodes]
AS 
BEGIN  
	BEGIN TRY  
		DECLARE @InquiryDetailsScreenId INT=-1
		
		SELECT TOP 1 @InquiryDetailsScreenId=R.IntegerCodeId
		FROM Recodes R
		INNER JOIN RecodeCategories RC ON RC.RecodeCategoryId=R.RecodeCategoryId AND RC.CategoryCode='INQUIRYDETAILSSCREENID'
				
		SELECT CAST(@InquiryDetailsScreenId AS VARCHAR)
		
	END TRY 
    BEGIN CATCH                                
		DECLARE @Error VARCHAR(8000)                                                                          
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                       
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetInquiryDetailsScreenIdFromRecodes')                                                                                                           
					+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                            
					+ '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                        
		RAISERROR                                                                                                           
		(                                                                             
			@Error, -- Message text.         
			16, -- Severity.         
			1 -- State.                                                           
		);                                                                                                        
	END CATCH
END