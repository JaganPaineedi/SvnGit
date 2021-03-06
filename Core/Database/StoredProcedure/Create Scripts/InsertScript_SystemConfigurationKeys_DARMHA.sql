/********************************************************************************                                                     
-- Copyright: Streamline Healthcare Solutions  
-- "ANSA - Indiana"
-- Purpose: Script to add entries in SystemConfigurationKeys table for Task #10002.1 Porter Starke-Customizations. 
-- Please note that the entries should be updated for Go-Live
--  
-- Date:    8 Jun 2018
--  
-- *****History****  
--	Date			Author		 Description
   8 Jun 2018      Abhishek      Task  Porter Starke-Customizations#10002.1
-------------------- -----------------------------------------------------------
--	
--
*********************************************************************************/

IF NOT EXISTS (SELECT
    [key]
  FROM SystemConfigurationKeys
  WHERE [key] = 'DARMHAUsername')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value, [Description])
    VALUES ('DARMHAUsername', 'wssl_qa', 'User Name to log into DARMHA Service')
END
ELSE
BEGIN
  UPDATE SystemConfigurationKeys
  SET value = 'wssl_qa'
  WHERE [key] = 'DARMHAUsername'
END


IF NOT EXISTS (SELECT
    [key]
  FROM SystemConfigurationKeys
  WHERE [key] = 'DARMHAPassword')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value, [Description])
    VALUES ('DARMHAPassword', 'XWd_HC51', 'Password to log into DARMHA Service')
END
ELSE
BEGIN
  UPDATE SystemConfigurationKeys
  SET value = 'XWd_HC51'
  WHERE [key] = 'DARMHAPassword'
END


IF NOT EXISTS (SELECT
    [key]
  FROM SystemConfigurationKeys
  WHERE [key] = 'DARMHAURL')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value, [Description])
    VALUES ('DARMHAURL', 'https://dmhaqa.fssa.in.gov/darmhaqa/darmhaservice.svc', 'DARMHA Service URL')
END
ELSE
BEGIN
  UPDATE SystemConfigurationKeys
  SET value = 'https://dmhaqa.fssa.in.gov/darmhaqa/darmhaservice.svc'
  WHERE [key] = 'DARMHAURL'
END
GO

IF NOT EXISTS (SELECT
    [key]
  FROM SystemConfigurationKeys
  WHERE [key] = 'DARMHASTAFFTEST')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value, [Description])
    VALUES ('DARMHASTAFFTEST', 'Y', 'Hardcoded Staff Id. The value should be updated to N when moving to production environment.')
END
ELSE
BEGIN
  UPDATE SystemConfigurationKeys
  SET value = 'Y'
  WHERE [key] = 'DARMHASTAFFTEST'
END
GO