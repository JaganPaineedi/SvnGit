IF exists(select * from documentversions where documentversionid=1678913 and Documentid=1596697)
Begin
    Update DocumentVersions set RecordDeleted='Y',DeletedBy='ARM-Support#1064',Deleteddate=GetDate() where documentversionid=1678913
End    
IF exists(select * from CustomDocumentCounselingNotes where documentversionid=1678913)
Begin
    Update CustomDocumentCounselingNotes set RecordDeleted='Y',DeletedBy='ARM-Support#1064',Deleteddate=GetDate() where documentversionid=1678913
END

If exists (select * from documents where Documentid=1596697 and documentcodeid=10014 and InprogressDocumentVersionId=1678913)
Begin
      Update Documents set InProgressDocumentVersionId=1649091,CurrentVersionStatus=22,Modifiedby='ARM-Support#1064',ModifiedDate=getdate() where Documentid=1596697
End

IF exists(select * from documentversions where documentversionid=1733131 and Documentid=1630296)
Begin
    Update DocumentVersions set RecordDeleted='Y',DeletedBy='ARM-Support#1064',Deleteddate=GetDate() where documentversionid=1733131
End    
IF exists(select * from CustomDocumentCounselingNotes where documentversionid=1733131)
Begin
    Update CustomDocumentCounselingNotes set RecordDeleted='Y',DeletedBy='ARM-Support#1064',Deleteddate=GetDate() where documentversionid=1733131
END

If exists (select * from documents where Documentid=1630296 and documentcodeid=10014 and InprogressDocumentVersionId=1733131)
Begin
      Update Documents set InProgressDocumentVersionId=1683584,CurrentVersionStatus=22,Modifiedby='ARM-Support#1064',ModifiedDate=getdate() where Documentid=1630296
End

IF exists(select * from documentversions where documentversionid=1748882 and Documentid=1276614)
Begin
    Update DocumentVersions set RecordDeleted='Y',DeletedBy='ARM-Support#1064',Deleteddate=GetDate() where documentversionid=1748882
End    
IF exists(select * from CustomDocumentCounselingNotes where documentversionid=1748882)
Begin
    Update CustomDocumentCounselingNotes set RecordDeleted='Y',DeletedBy='ARM-Support#1064',Deleteddate=GetDate() where documentversionid=1748882
END

If exists (select * from documents where Documentid=1276614 and documentcodeid=10014 and InprogressDocumentVersionId=1748882)
Begin
      Update Documents set InProgressDocumentVersionId=1319954,CurrentVersionStatus=22,Modifiedby='ARM-Support#1064',ModifiedDate=getdate() where Documentid=1276614
End
