--Update Script
--Created by : Manjunath K
--Date : 05th Dec 2016
--Task :  Bradford SGL task #262
--Purpose : Dischareging Client 152876 from BackEnd as Reported in Ace task : Bradford - Support Go Live #262
--
UPDATE BEDASSIGNMENTS 
SET MODIFIEDDATE=GETDATE(),  
ModifiedBy='SHS-USER',
ENDDATE='2016-11-16 12:11:00.000', DISPOSITION = 5205 
where BedAssignmentId= 9632 AND BedId=4647 AND ClientInpatientVisitId=1002270


UPDATE CLIENTINPATIENTVISITS 
SET MODIFIEDDATE= GETDATE(), 
ModifiedBy='SHS-USER',
STATUS = 4984, DISCHARGEDDATE='2016-11-16 12:11:00.000', 
DISCHARGETYPE=8905 WHERE ClientInpatientVisitId=1002270 AND ClientId=152876