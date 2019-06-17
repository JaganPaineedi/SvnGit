/************************************************
Update script for updating RecreatePDFOnClientSignature and RegenerateRDLOnCoSignature columns in DocumentCodes table
Author : Anto Jenkins
Created Date : 17/Jan/2018
Purpose : What/Why : Task #776  - New Directions - Support Go Live
Client and staff Signatures are not displaying in the RDL once they co-sign .
*************************************************/

IF EXISTS (SELECT * FROM DocumentCodes WHERE DocumentCodeId = 1620 and ISNULL(RecordDeleted,'N')='N')
BEGIN 
  UPDATE DocumentCodes  SET RecreatePDFOnClientSignature = 'Y' WHERE DocumentCodeId = 1620
  UPDATE DocumentCodes  SET RegenerateRDLOnCoSignature = 'Y' WHERE DocumentCodeId = 1620
END
