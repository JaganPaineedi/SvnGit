/****** Object:  StoredProcedure [dbo].[csp_validateCustomMedicationAdministrations]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMedicationAdministrations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomMedicationAdministrations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMedicationAdministrations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     PROCEDURE [dbo].[csp_validateCustomMedicationAdministrations]
@DocumentVersionId	Int
as


IF exists (Select 1 From Services s 
			Join Documents d on s.ServiceId=d.ServiceId
			Where d.CurrentDocumentVersionId=@DocumentVersionId
			and s.Status in (72,73, 76)
			)
	Return
	
ELSE 


execute csp_validateFullMentalStatus @DocumentVersionId

if @@error <> 0 goto error


CREATE TABLE [#CustomMedicationAdministrations] (
	DocumentVersionId int,
	[BloodPressure] varchar (24) ,
	[Pulse] varchar (24) ,
	[Respiratory] varchar (24)  ,
	[Weight] varchar (24) ,
	[Intervention] varchar(max)  ,
	[ResponseToIntervention] varchar(max)  ,
	[AxisV] int 
	)

INSERT INTO  [#CustomMedicationAdministrations](
	DocumentVersionId,
	[BloodPressure]  ,
	[Pulse]  ,
	[Respiratory]  ,
	[Weight]  ,
	[Intervention]   ,
	[ResponseToIntervention]  ,
	[AxisV] 
	)
select 
a.DocumentVersionId,
a.BloodPressure,
a.Pulse,
a.Respiratory,
a.Weight,
a.Intervention,
a.ResponseToIntervention,
a.AxisV 
from CustomMedicationAdministrations a 
where a.DocumentVersionId = @DocumentVersionId


Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

--
--DJH - Require medication - 7/27/2010
--
Select ''CustomMedicationAdministrations'', ''DeletedBy'', ''Note - Current Medications must be specified.''
From #CustomMedicationAdministrations ca
Where not exists (Select 1 From CustomMedications cm 
				Where cm.DocumentVersionId = ca.DocumentVersionId
				and isnull(cm.RecordDeleted, ''N'') = ''N'')

UNION

--
--DJH - Require Doctor on service when Medications have been administered. - 9/13/2010
--
Select ''CustomMedicationAdministrations'', ''DeletedBy'', ''Service - Attending Physician must be specified.''
From #CustomMedicationAdministrations ca
Join CustomMedications cm on cm.DocumentVersionId = ca.DocumentVersionId and ISNULL(cm.RecordDeleted,''N'')=''N''
JOin Documents d on d.CurrentDocumentVersionId = ca.DocumentVersionId and ISNULL(d.RecordDeleted,''N'')=''N''
Join Services s on s.ServiceId=d.ServiceId and ISNULL(s.RecordDeleted,''N'')=''N''
Where isnull(s.AttendingId,0) = 0



/*
Select ''CustomMedicationAdministrations'', ''Intervention'', ''Note - Intervention must be specified.''
From #CustomMedicationAdministrations
Where isnull(Intervention,'''')=''''
Union
Select ''CustomMedicationAdministrations'', ''ResponseToIntervention'', ''Note - ResponseToIntervention must be specified.''
From #CustomMedicationAdministrations
Where isnull(ResponseToIntervention,'''')=''''
--Union
--Select ''CustomMedicationAdministrations'', ''AxisV'', ''Axis V must be specified.''
Union
Select ''CustomMedicationAdministrations'', ''DeletedBy'', ''Service - Attending physician must be specified.''
From services s
join documents d on d.serviceid = s.serviceId
Where s.AttendingId is null
and isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
and d.CurrentDocumentVersionId = @DocumentVersionId
*/

if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomMedicationAdministrations failed.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
