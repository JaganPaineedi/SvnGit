--Task: #228 New Directions - Support Go Live
--Date: 02/01/2016


UPDATE DocumentVersions
SET RefreshView = 'Y'
WHERE DocumentVersionId in (SELECT DocumentVersionId
	FROM DocumentVersions dv
	JOIN Documents        d  on dv.DocumentVersionId=d.CurrentDocumentVersionId
	WHERE d.DocumentCodeId=10018 and d.Status=22 and isnull(dv.RecordDeleted,'N')='N' and isnull(d.RecordDeleted,'N')='N')
