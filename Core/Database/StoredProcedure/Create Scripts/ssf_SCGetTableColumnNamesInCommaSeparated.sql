/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetTableColumnNamesInCommaSeparated]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCGetTableColumnNamesInCommaSeparated]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCGetTableColumnNamesInCommaSeparated]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetTableColumnNamesInCommaSeparated]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[ssf_SCGetTableColumnNamesInCommaSeparated] 
(
@TableName VARCHAR(2000)
)
/********************************************************************************    
-- Stored Procedure: dbo.[ssf_SCGetTableColumnNamesInCommaSeparated]      
-- Called By: [ssp_SCUpdateSameClientNotes]   
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 29-Jan-2019	 Irfan			What:To get the Table Columns in a comma separated          
--								Why:HighPlains - Environment Issues Tracking-#38
*********************************************************************************/ 
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @Return VARCHAR(MAX)
	  
  SELECT @Return= COALESCE(@Return + ',' ,'') + '['+COLUMN_NAME+']' FROM INFORMATION_SCHEMA.COLUMNS  
  WHERE TABLE_SCHEMA='dbo' AND Table_Name=@TableName
  AND ORDINAL_POSITION<>1
    
	RETURN @Return
END

GO


