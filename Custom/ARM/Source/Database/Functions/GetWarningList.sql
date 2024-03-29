/****** Object:  UserDefinedFunction [dbo].[GetWarningList]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetWarningList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetWarningList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetWarningList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'



create function [dbo].[GetWarningList]
(@ChargeId int)
returns varchar(5000)
/*********************************************************************
-- Function: dbo.GetWarningList
--
-- Copyright: 2006 Streamline Healthcare Solutions
-- Creation Date:  09/14/2006
--
-- Purpose: Get error messages for a charge
--
-- Data Modifications:
--
-- Updates: 
--  Date         Author       Purpose
-- 11/06/2006    SFarber      Modified to return errors for a charge instead of a service 
**********************************************************************/                 
as  
begin 

  declare @Warnings varchar(5000)

  select @Warnings = isnull(@Warnings + ''; '', '''') + Convert(varchar(100), ErrorDescription) 
    from ChargeErrors 
   where ChargeId = @ChargeId

  return (@Warnings)

end



' 
END
GO
