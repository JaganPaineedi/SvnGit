Update  Dv set
Dv.RecordDeleted='Y' ,Dv.DeletedDate=GetDate(),DeletedBy='Date Correction'
 FROM services S inner Join Documents D ON D.serviceId=S.serviceId 
left JOin DocumentVERsions DV on Dv.DocumentID=D.DocumentId
 where s.status=76 and D.InProgressDocumentVersionId=Dv.DocumentVersionId
and D.CurrentVersionStatus=21 AND D.Status=22 AND  ISNULL(D.RecordDeleted,'N')='N'

------

UPDate D set d.CurrentVersionStatus=d.[Status],D.InProgressDocumentVersionId=D.CurrentDocumentVersionId
 FROM services S
  inner Join Documents D ON D.serviceId=S.serviceId 
   where s.status=76 and D.InProgressDocumentVersionId <> D.CurrentDocumentVersionId 
and D.CurrentVersionStatus=21 AND D.Status=22  AND ISNULL(D.RecordDeleted,'N')='N'
 
 
