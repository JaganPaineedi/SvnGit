/****** Object:  UserDefinedFunction [dbo].[csf_PMClaims837StripInvalidChars]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PMClaims837StripInvalidChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_PMClaims837StripInvalidChars]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_PMClaims837StripInvalidChars]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[csf_PMClaims837StripInvalidChars] (@incoming varchar(8000)) returns varchar(8000) as
/*********************************************************************/
/* Function: dbo.csf_PMClaims837StripInvalidChars                         */
/* Creation Date:    4/3/2009                                         */
/*                                                                   */
/* Purpose: Common function to cleanup names in the claim lines data	*/
/*                                                                   */
/* Input Parameters:											     */
/*	@incoming varchar(8000) - The string to be cleaned				*/
/*                                                                   */
/* Returns:															*/
/*	varchar(8000) modified string stripped of invalid chars			*/
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author      Purpose                                    */
/*  4/3/09		TER			created									*/
/*********************************************************************/
begin

declare @retVal varchar(8000)

set @retVal = @incoming

set @retVal = replace(@retVal, ''('', '' '')
set @retVal = replace(@retVal, '')'', '' '')
set @retVal = replace(@retVal, ''-'', '' '')
set @retVal = replace(@retVal, ''"'', '' '')
set @retVal = replace(@retVal, ''.'', '' '')


return ltrim(rtrim(@retVal))

end


' 
END
GO
