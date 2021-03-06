/****** Object:  UserDefinedFunction [dbo].[GetTimePart]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTimePart]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetTimePart]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTimePart]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'





CREATE function [dbo].[GetTimePart] 
(
@InputDateTime datetime
)
returns varchar(10)

/*********************************************************************/              
/*Function:dbo.GetTimePart            */              
/* Copyright: 2005 Provider Claim Management System             */              
/* Creation Date:  4/7/2006                               */              
/*                                                                   */              
/* Purpose: This function returns time part of date passed            */             
/*                                                                   */            
/* Output Parameters:     time(varchar)                       */              
/*                                                                   */              
/* Called By:                                                        */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/*                                                                   */              
/* Updates:                                                          */              
/*  Date        	 Author      Purpose                                    */              
/* 4/7/2006   Meenu Chawla      Created                                    */              
Begin

declare @StrTime varchar(500)

set @StrTime=CONVERT(varchar(2),
          CASE
               WHEN DATEPART([hour], @InputDateTime) > 12 THEN CONVERT(varchar(2), (DATEPART([hour], @InputDateTime) - 12))
               WHEN DATEPART([hour], @InputDateTime) = 0 THEN ''12''
               ELSE CONVERT(varchar(2), DATEPART([hour], @InputDateTime))
          END
     ) + '':'' +
     CONVERT(char(2), SUBSTRING(CONVERT(char(5), @InputDateTime, 108), 4, 2)) + '' '' + 
     CONVERT(varchar(2),
          CASE
               WHEN DATEPART([hour], @InputDateTime) >= 12 THEN ''PM''
               ELSE ''AM''
          END
     )

return @StrTime
END

























' 
END
GO
