/*Here we are updating FinanciallyResponsible ='N' in Clients Table(it is for both child and Adult Clients) 
if Any of the records in ClientContacts are FinanciallyResponsible ='Y' and Active='Y'
Task #307 MFS - Support Go Live */

Update C set FinanciallyResponsible ='N' 
From Clients C join ClientContacts CC on C.Clientid=CC.clientid 
where isnull(C.FinanciallyResponsible,'N')='Y' and isnull(C.recorddeleted,'N')<>'Y' 
and isnull(CC.recorddeleted,'N')<>'Y' and isnull(CC.FinanciallyResponsible,'N')='Y' AND CC.Active='Y'