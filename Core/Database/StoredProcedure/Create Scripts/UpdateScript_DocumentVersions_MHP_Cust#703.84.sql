---Author: Bibhu
---Date:   16 May 2017
---Task:   MHP - Customization #703.84	(Refreshing Signed Documents after Label Change)
-----------------------------------------------------------------------------------------------------------


Update Documentversions SET Refreshview='Y' Where DocumentVersionId in (
Select CurrentDocumentVersionId from Documents Where Status=22 and DocumentCodeid=2701
 AND IsNull(RecordDeleted,'N')='N') AND IsNull(RecordDeleted,'N')='N'