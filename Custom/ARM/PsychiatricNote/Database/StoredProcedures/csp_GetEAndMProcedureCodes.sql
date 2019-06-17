/****** Object:  StoredProcedure [dbo].[csp_GetEAndMProcedureCodes]   Script Date: 12/19/2016 15:15:31.027 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetEAndMProcedureCodes]') AND type IN (N'P',N'PC'))
	DROP PROCEDURE [dbo].[csp_GetEAndMProcedureCodes]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetEAndMProcedureCodes]    Script Date: 12/19/2016 15:15:31.027******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetEAndMProcedureCodes] 
AS
BEGIN
	/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "psyc Note" csp_GetEAndMProcedureCodes 4
-- Purpose: Get the Procedure codes which no need to open the E&M pop up
--  
-- Author: Venkatesh MR
-- Date:   26- 07 -2017
-- *****History****  
*********************************************************************************/
	DECLARE @XYList varchar(MAX)
	SET @XYList = ''
	
	IF EXISTS (SELECT 1 FROM Recodes R
	JOIN RecodeCategories RC ON RC.RecodeCategoryId=R.RecodeCategoryId
	WHERE RC.CategoryCode='XPSYEMCALCULATIONS' AND ISNULL(R.RecordDeleted,'N') = 'N')
	BEGIN
		SELECT @XYList = @XYList + CONVERT(varchar, IntegerCodeId) + ','
		FROM Recodes R
		JOIN RecodeCategories RC ON RC.RecodeCategoryId=R.RecodeCategoryId
		WHERE RC.CategoryCode='XPSYEMCALCULATIONS' AND ISNULL(R.RecordDeleted,'N') = 'N'

		-- Remove last comma
		SELECT LEFT(@XYList, LEN(@XYList) - 1) 
	END 
	ELSE 
	BEGIN
		SELECT ''
	END
	 
END

--Checking For Errors             
IF (@@error != 0)
BEGIN
	DECLARE @Error varchar(8000)                                                                         
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetEAndMProcedureCodes')                                                                                                       
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                        
		+ '*****' + Convert(varchar,ERROR_STATE())                                                    
	 RAISERROR                                                                                                       
	 (                                                                         
	  @Error, -- Message text.                                                                                                      
	  16, -- Severity.                                                                                                      
	  1 -- State.                                                                                                      
	 );

	RETURN
END
GO


