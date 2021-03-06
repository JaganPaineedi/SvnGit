/****** Object:  UserDefinedFunction [dbo].[GetSitePhone]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSitePhone]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetSitePhone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSitePhone]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'










CREATE  FUNCTION [dbo].[GetSitePhone](@SiteId int)  
RETURNS varchar(50) AS  
/*********************************************************************/              
/*Function: dbo.ssp_GetSitePhone           */              
/* Copyright: 2005 Provider Claim Management System             */              
/* Creation Date:  11/25/2005                                    */              
/*                                                                   */              
/* Purpose: it will get SitePhone            */             
/*                                                                   */            
/* Output Parameters:        SitePhone                        */              
/*                                                                   */              
/* Called By:                                                        */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/*                                                                   */              
/* Updates:                                                          */              
/*  Date        	 Author      Purpose                                    */              
/* 11/35/2005   	Gagan      Created                                    */              

BEGIN 
Declare @SitePhone as varchar(100)
set @SitePhone=(SELECT top 1 PhoneNumber FROM SitePhones WHERE SiteId=@SiteId) 
return @SitePhone

END











' 
END
GO
