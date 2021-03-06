/****** Object:  UserDefinedFunction [dbo].[scsf_MMDosageRangeRemoveTrailingZeroes]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsf_MMDosageRangeRemoveTrailingZeroes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[scsf_MMDosageRangeRemoveTrailingZeroes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsf_MMDosageRangeRemoveTrailingZeroes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[scsf_MMDosageRangeRemoveTrailingZeroes] (@s varchar(500)) returns varchar(500) as
/***************************************************************************************************/  
/* FUNCTION: scsf_MMDosageRangeRemoveTrailingZeroes													         */  
/*																									                        */  
/* PURPOSE: Remove trailing zeros (and possibly decimal points from the tail-end of a string.		*/
/*																									                        */  
/* CALLED BY: SmartCareRx																			                  */  
/*																									                        */  
/* CHANGE LOG:																						                     */  
/*    TER - 5/25/2010 - Created.																	                  */  
/*																									                        */  
/***************************************************************************************************/  
begin

   -- trim to single decimal place after decimal point

	while (len(@s) > 1) and (@s like ''%.%0'')
	begin
		set @s = substring(@s, 1, len(@s) - 1)
	end

	if (len(@s) > 1) and (@s like ''%.'') set @s = substring(@s, 1, len(@s) - 1)

	return @s

end
' 
END
GO
