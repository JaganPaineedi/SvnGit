-----------------Systemconfiguration -------------------------


IF NOT EXISTS(SELECT * FROM SystemConfigurationKeys where [key]='WBLegalStatus')
 INSERT INTO  SystemConfigurationKeys ([Key],value,Description,AcceptedValues) VALUES ('WBLegalStatus','N','To choose legal status in Whiteboard','Y,N')
 