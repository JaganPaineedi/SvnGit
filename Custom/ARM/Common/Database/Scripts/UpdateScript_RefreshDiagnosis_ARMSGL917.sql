--created by  Veena to refresh the sub report error in the ARM environment after 1/25 build.
--	A Renewed Mind - Support #917

Update DV  SET RefreshView='Y' 
 From Documentversions DV JOIN Documents D ON
 DV.DocumentVersionId=D.InProgressDocumentVersionId
 and D.Status=22 and D.documentcodeid=1601
 and Isnull(D.Recorddeleted,'N')='N' and Isnull(DV.Recorddeleted,'N')='N'
 
 
 
 
