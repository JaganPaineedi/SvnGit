-- Created By - Sachin Borgave  
-- What : For Existing FirstNameSoundex and LastNameSoundex Updating Based on FirstName and LastName
-- Why : Core Bugs #2400

UPDATE C
 SET C.FirstNameSoundex =SOUNDEX(C.FirstName),
     C.LastNameSoundex =SOUNDEX(C.LastName)
FROM Clients C Where C.FirstNameSoundex IS NULL AND C.LastNameSoundex IS NULL

 

