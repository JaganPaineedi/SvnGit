/****** Object:  UserDefinedFunction [dbo].[fnNumberToWords]    Script Date: 12/09/2015 16:43:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnNumberToWords]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnNumberToWords]
GO

/****** Object:  UserDefinedFunction [dbo].[fnNumberToWords]    Script Date: 12/09/2015 16:43:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE FUNCTION [dbo].[fnNumberToWords](@Number AS decimal(18,2))  
    RETURNS VARCHAR(1024)  
/********************************************************************************/                           
 -- Function: fnNumberToWords        
-- Purpose: Query to return data for the Charges and Claims list page.         
--         
-- Author: Revathi       
-- Date:    25 Nov 2015         
--           
 /********************************************************************************/     
AS  
BEGIN  
  RETURN (dbo.fnNumberToWordNL(@Number, @@NESTLEVEL))  
END  
GO


