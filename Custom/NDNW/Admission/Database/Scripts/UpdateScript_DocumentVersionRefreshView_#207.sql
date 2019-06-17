--Task: #207 New Directions - Support Go Live
--Date: 01/27/2016

UPDATE DocumentVersions
SET RefreshView = 'Y'
WHERE DocumentVersionId IN (
		SELECT ds.DocumentVersionId
		FROM documents d
		JOIN documentversions ds ON d.currentdocumentversionid = ds.documentversionid
		WHERE d.documentcodeid = 10500
		)