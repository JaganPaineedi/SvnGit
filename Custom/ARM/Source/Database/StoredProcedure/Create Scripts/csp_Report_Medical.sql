/****** Object:  StoredProcedure [dbo].[csp_Report_Medical]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Medical]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Medical]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Medical]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_Report_Medical]

@date datetime,

@choice int,

@StaffId Int,

@staff_super_or_vp varchar(10)

as
--*/
-- =============================================
-- Author:		<Ryan Mapes>
-- Create date: <02/27/2013>
-- Description:	<As per WO: 27519. Finds clients perscribed a specific number of medication, lists supervisor and prescriber. Does not include Larry Johnson and Teresa Graham>
-- =============================================

--declare @date datetime,
--@choice int,
--@StaffId Int,
--@staff_super_or_vp varchar(10)


--select @date=''2013-2-28'',
--@choice = 6,
--@StaffId = 64,
--@staff_super_or_vp = ''st''


DECLARE @staff TABLE

(
StaffId Int,
StaffName Varchar(100)
)


IF @staff_super_or_vp like ''su%'' AND @StaffId <> 0

--If Super is input then grab all staff 1 level below input staff 

BEGIN

INSERT INTO @staff(StaffId, StaffName)
SELECT * FROM dbo.fn_Supervisor_List(1, @StaffId)

END

IF @staff_super_or_vp like ''v%'' AND @StaffId <> 0
--If VP is input then grab all staff up to 10 levels below input staff
BEGIN

INSERT INTO @staff(StaffId, StaffName)
SELECT * FROM dbo.fn_Supervisor_List(10, @StaffId)

END

IF @staff_super_or_vp LIKE ''st%'' AND @StaffId <> 0

BEGIN

INSERT INTO @staff(StaffId, StaffName)
VALUES (@StaffId, (Select LastName + '', '' + FirstName from Staff where StaffId = @StaffId))

END

IF @StaffId = 0

BEGIN

INSERT INTO @staff(StaffId, StaffName)
SELECT * FROM dbo.fn_Active_And_Inactive_Staff_Full_Name()
DELETE FROM @staff
WHERE StaffId = 000
END


declare @Table TABLE (Clientid INT, count int )

--Select * from @staffNameTable 


INSERT INTO @Table

select c.ClientId, count (c.clientid ) from ClientMedications m

join clients c

on m.clientid = c.ClientId

where ISNULL(c.RecordDeleted,''N'')<>''Y''
AND ISNULL(m.RecordDeleted,''N'')<>''Y''

AND @date >= MedicationStartDate
AND @date < MedicationEndDate

and c.Active like ''y''

AND PrescriberId <> 760 -- Larry Johnson
AND PrescriberId <> 1799 --Teresa Graham

--and Case when @choice = 3 then count=3 else count = 5 end

group by c.ClientId

order by ClientId

IF @choice < 6 begin

delete from @Table 

where count <> @choice 

end

IF @choice = 6 begin

delete from @Table 

where count < 6

end

--select * from @Table


select distinct st.lastname + '', '' + st.FirstName as Supervisor , m.PrescriberName,  c.ClientId, c.LastName + '', '' + c.FirstName as ''Client Name'',MedicationName, MedicationStartDate,MedicationEndDate, count from ClientMedications m

join clients c

on m.clientid = c.ClientId

join MDMedicationNames n

on m.MedicationNameId = n.MedicationNameId

--join StaffDirectSupervisors su

--on m.PrescriberId = su.StaffId

join StaffSupervisors su

on m.PrescriberId = su.StaffId 
and su.SupervisorId in (select StaffId from @staff)
and su.SupervisorId not in (1068, 1396) --Jennifer Riha and Erin Bajas 

join Staff st
on st.staffid = su.SupervisorId

join @Table t

on t.clientid = c.ClientId

join @staff s

on s.StaffId = m.PrescriberId 

where ISNULL(c.RecordDeleted,''N'')<>''Y''
AND ISNULL(n.RecordDeleted,''N'')<>''Y''
AND ISNULL(m.RecordDeleted,''N'')<>''Y''
AND ISNULL(st.RecordDeleted,''N'')<>''Y''
AND ISNULL(su.RecordDeleted,''N'')<>''Y''

AND @date >= MedicationStartDate
AND @date < MedicationEndDate

and c.Active like ''y''

AND PrescriberId <> 760 -- Larry Johnson
AND PrescriberId <> 1799 --Teresa Graham

order by Supervisor, PrescriberName, ClientId, MedicationName

 
--select * from @staff order by StaffName

--select * from @staffNameTable' 
END
GO
