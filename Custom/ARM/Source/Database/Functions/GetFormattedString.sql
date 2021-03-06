/****** Object:  UserDefinedFunction [dbo].[GetFormattedString]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFormattedString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetFormattedString]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFormattedString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'


/*********************************************************************/              
/*Function: dbo.GetFormattedString           */              
/* Copyright: 2005 Practice Management Application            */              
/* Creation Date:  19/02/2007                                    */              
/*                                                                   */              
/* Purpose: it will replace the special characters from string             */             
/*                                                                   */            
/* Output Parameters:    returns the string without special characters                        */              
/*                                                                   */              
/* Called By:    ssp_PMGetClaimBatches stored procedure                */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/*                                                                   */              
/* Updates:                                                          */              
/*  Date        	 Author                     Purpose                                    */              
/* 19/02/2007   Bhupinder Bajwa      Created                                    */              
CREATE FUNCTION [dbo].[GetFormattedString]
(
    @strName varchar(255)
)  
RETURNS varchar(255) AS  
BEGIN 
Declare @FileName as varchar(255)

Set @FileName = @strName
Set @FileName = replace(@FileName,''/'','''')
Set @FileName = replace(@FileName,''\'','''')
Set @FileName = replace(@FileName,''*'','''')
Set @FileName = replace(@FileName,''?'','''')
Set @FileName = replace(@FileName,''<'','''')
Set @FileName = replace(@FileName,''>'','''')
Set @FileName = replace(@FileName,''|'','''')
Set @FileName = replace(@FileName,''"'','''')

Return @FileName

END












' 
END
GO
