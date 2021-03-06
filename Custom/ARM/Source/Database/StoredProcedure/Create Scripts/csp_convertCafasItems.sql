/****** Object:  StoredProcedure [dbo].[csp_convertCafasItems]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_convertCafasItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_convertCafasItems]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_convertCafasItems]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_convertCafasItems]
AS

begin tran
update a
set a.MRNOrSSN = b.clientId
from customCaseInformationForMigration a
join cstm_conv_map_clients b on substring(a.MRNorSSN,1,8) = b.patient_id
where a.SiteName = ''Summit Pointe''

if @@error <> 0 goto error

update a
set a.RaterId = b.StaffId
from customRaterForMigration a
join cstm_conv_map_staff b on a.RaterId = b.staff_id
where a.SiteName = ''Summit Pointe''

if @@error <> 0 goto error

update a
set a.RaterId = c.StaffId
from customRatingPeriodInformationForMigration a
join customCaseInformationForMigration b on a.CaseId = b.CaseId
join cstm_conv_map_staff c on a.RaterId = c.staff_id
where b.SiteName = ''Summit Pointe''

if @@error <> 0 goto error


commit tran
print ''success''
return

error:
rollback tran
print ''failure''

' 
END
GO
