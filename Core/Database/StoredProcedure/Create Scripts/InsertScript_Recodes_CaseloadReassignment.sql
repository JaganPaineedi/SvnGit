
------------------------------------------------------------------------------------------
-------Recode entry for REASSIGNMENTPROGRAMSTATUS
-- Client Progam Current Status of 'Program Assignment Details'
------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='REASSIGNMENTPROGRAMSTATUS')
INSERT INTO RecodeCategories(CategoryCode,CategoryName,[Description],MappingEntity)
VALUES( 'REASSIGNMENTPROGRAMSTATUS','GlobalCodeCategory PROGRAMSTATUS',
         'Client Progam Current Status',
         'GlobalCodeId') 
else
UPDATE recodecategories
SET    categorycode = 'REASSIGNMENTPROGRAMSTATUS',
       categoryname = 'GlobalCodeCategory PROGRAMSTATUS',
       [description] ='Client Progam Current Status',
		mappingentity = 'GlobalCodeId'
WHERE  categorycode = 'REASSIGNMENTPROGRAMSTATUS'  



------------------------------------------------------------------------------------------
-------Recode entry for REASSIGNMENTCONTACTNOTES
-- Client Contact Notes Status
-- Create Recodes for Inprogress status using the CodeName as 'INPROGRESS' and CodeName as 'COMPLETED' for completed status.
------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='REASSIGNMENTCONTACTNOTESTATUS')
INSERT INTO RecodeCategories(CategoryCode,CategoryName,[Description],MappingEntity)
VALUES( 'REASSIGNMENTCONTACTNOTESTATUS','GlobalCodeCategory CONTACTNOTESTATUS',
         'Client Contact Notes Status',
         'GlobalCodeId') 
else
UPDATE recodecategories
SET    categorycode = 'REASSIGNMENTCONTACTNOTESTATUS',
       categoryname = 'GlobalCodeCategory CONTACTNOTESTATUS',
       [description] ='Client Contact Notes Status',
		mappingentity = 'GlobalCodeId'
WHERE  categorycode = 'REASSIGNMENTCONTACTNOTESTATUS'  


------------------------------------------------------------------------------------------
-------Recode entry for REASSIGNMENTINQUIRYSTATUS
-- Client Inquiry Status
-- Create Recodes for Inprogress status using the CodeName as 'INPROGRESS' and CodeName as 'COMPLETED' for completed status.
------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='REASSIGNMENTINQUIRYSTATUS')
INSERT INTO RecodeCategories(CategoryCode,CategoryName,[Description],MappingEntity)
VALUES( 'REASSIGNMENTINQUIRYSTATUS','GlobalCodeCategory XINQUIRYSTATUS',
         'Client Inquiry Status',
         'GlobalCodeId') 
else
UPDATE recodecategories
SET    categorycode = 'REASSIGNMENTINQUIRYSTATUS',
       categoryname = 'GlobalCodeCategory XINQUIRYSTATUS',
       [description] ='Client Inquiry Status',
		mappingentity = 'GlobalCodeId'
WHERE  categorycode = 'REASSIGNMENTINQUIRYSTATUS'  

------------------------------------------------------------------------------------------
-------Recode entry for REASSIGNMENTDISCLOSURESTATUS
-- Client Disclosures Status
-- Create Recodes for Inprogress status using the CodeName as 'INPROGRESS' and CodeName as 'COMPLETED' for completed status.
------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='REASSIGNMENTDISCLOSURESTATUS')
INSERT INTO RecodeCategories(CategoryCode,CategoryName,[Description],MappingEntity)
VALUES( 'REASSIGNMENTDISCLOSURESTATUS','GlobalCodeCategory DISCLOSURESTATUS',
         'Client Disclosures Status',
         'GlobalCodeId') 
else
UPDATE recodecategories
SET    categorycode = 'REASSIGNMENTDISCLOSURESTATUS',
       categoryname = 'GlobalCodeCategory DISCLOSURESTATUS',
       [description] ='Client Disclosures Status',
		mappingentity = 'GlobalCodeId'
WHERE  categorycode = 'REASSIGNMENTDISCLOSURESTATUS'  



