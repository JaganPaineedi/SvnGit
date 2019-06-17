/****** Object:  StoredProcedure [dbo].[ssp_GetDataRecodesAndRecodeCategory]    Script Date: 05/03/2013 11:20:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDataRecodesAndRecodeCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDataRecodesAndRecodeCategory]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetDataRecodesAndRecodeCategory]    Script Date: 05/03/2013 11:20:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
      
 /*********************************************************/                                      
/* Stored Procedure: dbo.ssp_GetDataRecodesAndRecodeCategory				  */                                      
/* Creation Date:  05/03/2013                             */                                     
/* Purpose: To Get Data Recodes and Recode Categories to bind dropdown in list page      */                                                                  
/*  Date                  Author                 Purpose  */                                      
/* 25/11/2013             Chethan N               Created  */ 
/* 18/04/2017			  kishore	What: Checked empty Or Null value based on CodeName		
									why: AspenPointe-Environment Issues,
									Task  #206 - Recodes: Unable to find recodes and enter new recodes  */                                   
/**********************************************************/                 
CREATE Procedure [dbo].[ssp_GetDataRecodesAndRecodeCategory]
AS
BEGIN
BEGIN TRY
----------------TABLE RecodeCategories--------------------
SELECT
		RC.RecodeCategoryId,
		RC.CategoryCode
FROM RecodeCategories RC
WHERE  ISNULL(RC.RecordDeleted,'N')='N'
ORDER BY RC.CategoryCode

--------------TABLE RECODES--------------------------------------

SELECT 
		RD.RecodeId,
		RD.CodeName
FROM RECODES RD
WHERE  
-- kishore 18/04/2017 
 ISNULL(RD.CodeName,'')!='' 
 
  AND ISNULL(RD.RecordDeleted,'N')='N'
ORDER BY RD.CodeName

END TRY              
 BEGIN CATCH            
    RAISERROR ( 'ssp_GetDataRecodesAndRecodeCategory: An Error Occured', 16,1)                  
   Return                
 END CATCH 

END



GO