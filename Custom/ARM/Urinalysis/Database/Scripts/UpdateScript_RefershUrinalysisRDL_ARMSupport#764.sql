Update DV  SET RefreshView='Y' 
 From Documentversions DV JOIN Documents D  ON
 DV.DocumentVersionId=D.InProgressDocumentVersionId
 and D.Status=22 and D.documentcodeid=1000408
 and Isnull(D.Recorddeleted,'N')='N' and Isnull(DV.Recorddeleted,'N')='N'