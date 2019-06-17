-----------------Script to Correct the bad data which had been created under the task : 	MHP-Support Go Live #732-----------------------
----------------------------------------- Author : vsinha ---------- Date : 10/04/2018-----------------------------------
----------------------------------------------SQL query to correct the bad data------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

UPDATE ddc
set ddc.Billable='Y', ModifiedBy='Task#732',ModifiedDate=GetDate() 
from DocumentDiagnosisCodes as ddc
join DocumentVersions as dv on dv.DocumentVersionId = ddc.DocumentVersionId and isnull(dv.RecordDeleted, 'N') = 'N'
join Documents as d on d.DocumentId = dv.DocumentId and isnull(d.RecordDeleted, 'N') = 'N'
join DocumentCodes as dc on dc.DocumentCodeId = d.DocumentCodeId and isnull(dc.RecordDeleted, 'N') = 'N'
where ddc.Billable is null
and isnull(ddc.RecordDeleted, 'N') = 'N'

-------------------------------------------------------------------------------------------------------------------------