/****** Object:  UserDefinedFunction [dbo].[GetPlanName]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPlanName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetPlanName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPlanName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'









/*********************************************************************/              
/*Function: dbo.GetPlanName           */              
/* Copyright: 2005 Provider Claim Management System             */              
/* Creation Date:  12/02/2005                                    */              
/*                                                                   */              
/* Purpose: it will get Plan Name            */             
/*                                                                   */            
/* Output Parameters:        PlanName                        */              
/*                                                                   */              
/* Called By:                                                        */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/*                                                                   */              
/* Updates:                                                          */              
/*  Date        	 Author      Purpose                                    */              
/* 12/02/2005   Tarunjeet Singh      Created                                    */              
CREATE FUNCTION [dbo].[GetPlanName](@PlanId int)  
RETURNS varchar(15) AS  
BEGIN 
Declare @PlanName as varchar(100)
set @PlanName=(SELECT PlanName FROM Plans WHERE (PlanId = @PlanId)) 
return @PlanName

END









' 
END
GO
