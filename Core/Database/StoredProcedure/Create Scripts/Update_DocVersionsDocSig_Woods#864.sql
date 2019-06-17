-- Author : Vijeta Sinha
-- task: Woods - Support Go Live #864
--Reason: we have made the RecordDeleted='N' for tables DocumentVersions and DocumentSignatures whose documents are not set as RecordDeleted='Y' (non-deleted document) 
--         and DocumentVersions and DocumentSignatures were set as RecordDeleted='Y' for those documents whose status is set as 26(error).

--------------------------------------------------Update DocumentVersions------------------------------------------------------------------

UPDATE dv
SET dv.RecordDeleted='N',
dv.DeletedBy='Woods-SGL#864'
from DocumentVersions dv
Join Documents d on d.DocumentId=dv.DocumentId And IsNULL(d.RecordDeleted,'N')='N'
where dv.RecordDeleted='Y' and d.status=26
Go
---------------------------------------------------Update DocumentSignatures------------------------------------------------------------------
UPDATE ds
SET ds.RecordDeleted='N',
ds.DeletedBy='Woods-SGL#864'
from DocumentSignatures ds
Join Documents d on d.DocumentId=ds.DocumentId And IsNULL(d.RecordDeleted,'N')='N'
where ds.RecordDeleted='Y' and d.status=26
Go
----------------------------------------------------------------------------------------------------------------------------------------------