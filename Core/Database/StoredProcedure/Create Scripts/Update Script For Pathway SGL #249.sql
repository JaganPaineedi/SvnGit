--Manjunath K 
--Update Script For Pathway - Support Go Live #249
If EXISTS( select Top 1 * from DocumentCodes where DocumentCodeId=1620)
Begin
update DocumentCodes set DSMV='Y', DiagnosisDocument='Y' where DocumentCodeId=1620
End