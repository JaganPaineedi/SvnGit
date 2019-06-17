---------------------------------------------------------
--Author : Shruthi.S
--Date   : 02/06/2016
--Purpose: Added for Status dropdown.Ref : #401 Aspen Pointe Customizations.
---------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'CredentialingStatus' AND CodeName='Provider Tracking Only')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Active,CannotModifyNameOrDelete,Code)
  values('CredentialingStatus','Provider Tracking Only','Y','Y','PROVIDERTRACKINGONLY')
 END