/****** Object:  UserDefinedFunction [dbo].[GetSitePhoneNumberAndType]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSitePhoneNumberAndType]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetSitePhoneNumberAndType]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSitePhoneNumberAndType]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'






CREATE function [dbo].[GetSitePhoneNumberAndType]
(
@SiteID int,
@ReturnColumn varchar(15)    -- Used to return phoneNumber or PhoneType based on this variable
)
returns varchar(200)

/*********************************************************************/              
/*Function: dbo.ssp_GetSitePhoneNumberAndType           */              
/* Copyright: 2005 Provider Claim Management System             */              
/* Creation Date:  25/04/2006                                    */              
/*                                                                   */              
/* Purpose: returns PhoneNumber and PhoneType for a Site in a string       */             
/*                                                                   */            
/* Output Parameters:     strColumn                    */              
/*                                                                   */              
/* Called By:                                                        */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/*                                                                   */              
/* Updates:                                                          */              
/*  Date        	 Author                   Purpose                        */              
/* 25/04/2006   Bhupinder Bajwa      Created                       */              

Begin
-- Variables declared to hold different Status Values
Declare @BusinessPhoneType int, @FaxPhoneType int, @HomePhoneType int, @Home2PhoneType int, @Business2PhoneType int, @MobilePhoneType int, @Mobile2PhoneType int,
	@SchoolPhoneType int, @OtherPhoneType int

	Set @BusinessPhoneType=31
	Set @FaxPhoneType=36
	Set @HomePhoneType=30
	Set @Home2PhoneType=32
	Set @Business2PhoneType=33
	Set @MobilePhoneType=34
	Set @Mobile2PhoneType=35
	Set @SchoolPhoneType=37
	Set @OtherPhoneType=38	

Declare @strColumn varchar(200)
set @strColumn=''''
Declare @phoneNumber varchar(200), @phoneType varchar(10), @sortColumn int
Declare Cur Cursor
For Select sp.PhoneNumber, sp.PhoneType,
case when sp.PhoneType=@BusinessPhoneType then 1 when sp.PhoneType=@FaxPhoneType then 2 when sp.PhoneType=@HomePhoneType then 3
when sp.PhoneType=@Home2PhoneType then 4 when sp.PhoneType=@Business2PhoneType then 5 when sp.PhoneType=@MobilePhoneType then 6
when sp.PhoneType=@Mobile2PhoneType then 7 when sp.PhoneType=@SchoolPhoneType then 8 when sp.PhoneType=@OtherPhoneType then 9 else null end as SortOrder
from SitePhones sp where sp.Siteid=@SiteID and IsNull(sp.RecordDeleted,''N'')=''N'' order by SortOrder

OPEN Cur

FETCH from Cur INTO @phoneNumber, @phoneType, @sortColumn
WHILE (@@FETCH_STATUS=0) 
        BEGIN 

	IF (@ReturnColumn=''PhoneNumber'')
	     Set @strColumn = cast(@phoneNumber as varchar)
	ELSE
	     Set @strColumn = cast(@phoneType as varchar)
	
	if (Len(@strColumn)>0)
             begin
	        break
	end
             FETCH from Cur INTO @phoneNumber, @phoneType, @sortColumn
        END


 CLOSE Cur
 DEALLOCATE Cur
 Return NullIF(@strColumn,'''')
End

















' 
END
GO
