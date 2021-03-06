/****** Object:  UserDefinedFunction [dbo].[ssf_SureScriptsAddressElement]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SureScriptsAddressElement]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SureScriptsAddressElement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SureScriptsAddressElement]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ssf_SureScriptsAddressElement](
/******************************************************************************                                              
**  File: [ssf_SureScriptsAddressElement]                                          
**  Name: [ssf_SureScriptsAddressElement]                      
**  Desc: Get "address line 1" or "address line 2" from our funky address format
**  Return values: either the first line or second line of the freeform address text                                         
**  Called by: Surescripts client and ARRA meaningful use functions                                               
**  Parameters:                          
**  Auth:  TER
**  Date:  05/13/2011                                         
*******************************************************************************                                              
**  Change History                                              
*******************************************************************************                                              
**  Date:       Author:       Description:                            
**  05/13/2011  TER			  Initial
**  -------------------------------------------------------------------------            
*******************************************************************************/                                            
   @FormattedAddress varchar(1000),	-- incoming address value
   @ElementNumber int,   -- 1 or 2
   @truncateTo35 char(1)	-- Y/N.  Yes will truncate the return value to 35 chars as required by Surescripts
) returns varchar(1000) as
begin

declare @AddressElement varchar(1000)
set @AddressElement = ''''

set @FormattedAddress = ltrim(rtrim(@FormattedAddress))
if @FormattedAddress is not null
begin

   if @ElementNumber = 1
   begin
      if charindex(char(13), @FormattedAddress) between 2 and 35
         set @AddressElement = substring(@FormattedAddress, 1, charindex(char(13), @FormattedAddress) - 1)
      else
      if @truncateTo35 = ''Y''
      begin
         set @AddressElement = substring(@FormattedAddress, 1, 35)
      end
      else if charindex(char(13), @FormattedAddress) > 35
      begin
         set @AddressElement = substring(@FormattedAddress, 1, charindex(char(13), @FormattedAddress) - 1)
      end
      else
         set @AddressElement = @FormattedAddress
      

   end
   else if @ElementNumber = 2
   begin

      if (charindex(char(10), @FormattedAddress) > 1) and (len(@FormattedAddress) > charindex(char(10), @FormattedAddress))
         if @truncateTo35 = ''Y''
            set @AddressElement = replace(replace(substring(@FormattedAddress, charindex(char(10), @FormattedAddress) + 1, 35), char(10), '' ''), char(13), '' '')
         else
            set @AddressElement = replace(replace(substring(@FormattedAddress, charindex(char(10), @FormattedAddress) + 1, 1000), char(10), '' ''), char(13), '' '')

   end

   end

return @AddressElement

end

' 
END
GO
