--refreshing the Existing RDL's A Renewed Mind - Support: #764 PDF documents; Names generate in First name, comma, Last name format--Kavya
Update DV  SET RefreshView='Y' 
 From Documentversions DV JOIN Documents D  ON
 DV.DocumentVersionId=D.InProgressDocumentVersionId
 and D.Status=22 
 and Isnull(D.Recorddeleted,'N')='N' and Isnull(DV.Recorddeleted,'N')='N'