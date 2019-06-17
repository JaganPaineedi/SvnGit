
-- Renewed Mind - Customizations Task#16
--GlobalCode Category XDISCHARGEREASON , Adding CodeName 'Other' 
--Created By Manju Padmanabhan
--Created on 18 June 2013
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category='XDISCHARGEREASON' AND CodeName='Other' ) 
	begin 
	
		INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('XDISCHARGEREASON','Other',NULL,'Y','Y',10) 
		
	END 

