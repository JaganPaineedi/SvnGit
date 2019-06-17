



update agency
SET Address = '2200 Fourth Street'
where AgencyName ='New Directions Northwest'
go



update agency
SET AddressDisplay = '2200 Fourth Street Baker City, OR 97814'
where AgencyName ='New Directions Northwest'
go


update agency
SET BillingPhone = '(541) 523-3646'
where AgencyName ='New Directions Northwest'
go


--for prod
DELETE FROM dv
FROM NDNWProdSCImageRecords.dbo.documentversionviews dv
JOIN documents d on d.currentdocumentversionid = dv.documentversionid
WHERE d.Status = 22 
AND d.DocumentCodeId=15106
AND ISNULL(d.RecordDeleted, 'N') = 'N'


--for train
DELETE FROM dbo.documentversionviews
FROM documentversionviews dv
JOIN documents d on d.currentdocumentversionid = dv.documentversionid
WHERE d.Status = 22 
AND d.DocumentCodeId=15106
AND ISNULL(d.RecordDeleted, 'N') = 'N'




