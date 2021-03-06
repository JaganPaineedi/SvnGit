/****** Object:  StoredProcedure [dbo].[csp_RetriveClintsForPrimaryClinician]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RetriveClintsForPrimaryClinician]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RetriveClintsForPrimaryClinician]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RetriveClintsForPrimaryClinician]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_RetriveClintsForPrimaryClinician]
as
/*  CreatedBy		  Date						Reason
	JSchultz		9.02.2011	Retrieve all clients with Primary Clinician of ''1''
*/

select C.Lastname + '', '' + C.Firstname As ClientName,
CP.PhoneNumber, CA.Address, CA.City, CA.State, CA.Zip,
S.Lastname + '', '' + S.Firstname AS StaffName
from Clients C
join ClientPhones CP on CP.ClientId = C.ClientId
join ClientAddresses CA on CA.ClientId = C.ClientId
join Staff S on S.StaffId = C.PrimaryClinicianId 
where C.PrimaryClinicianId = 1
order by ClientName
' 
END
GO
