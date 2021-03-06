/****** Object:  UserDefinedFunction [dbo].[GetContactPhone]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContactPhone]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetContactPhone]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContactPhone]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'






CREATE FUNCTION [dbo].[GetContactPhone](

	@ClientContactId int 
	
)

RETURNS VARCHAR(200)
 AS  

BEGIN 



DECLARE @Phone  varchar (200)

declare  CurContactPhoneId  Cursor   for
select ContactPhoneId ,PhoneType from ClientContactPhones  where ClientContactId = @ClientContactId


declare @ContactPhoneId int 
declare @PhoneType int 

open CurContactPhoneId 

FETCH NEXT FROM CurContactPhoneId 
INTO @ContactPhoneId, @PhoneType

WHILE @@FETCH_STATUS = 0
	BEGIN
	
		if (@PhoneType =30)  
		 begin
			select @Phone = phonenumber 
			from ClientContactPhones  where  ContactPhoneId = @ContactPhoneId
			return @Phone
		end	

	FETCH NEXT FROM CurContactPhoneId 
	INTO @ContactPhoneId, @PhoneType

end

select   top 1  @Phone =phonenumber from ClientContactPhones 
where ClientContactId = @ClientContactId order by ContactPhoneId

return @Phone

END













' 
END
GO
