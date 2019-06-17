---------------------------------------------------------------------------------------------------- 
---------------------------------------------------------------------------------------------------- 
--InsertScript_SystemConfigurationKeys_ValidateClientGenderOnBedAdmit
-- 
-- Ace project: Renaissance - Dev Items - Whiteboard Add Validation 
-- Ace task: #630.18 
-- 
-- Date      By							Description 
-- ----------  ---------------------  ------------------------------------------------------------ 
-- 2018-03-20  Kaushal Pandey			Non Renaissance - We are setting normal to non Renaissance Customer. (need a validation that prevents the staff from admitting males and females to the same room)
---------------------------------------------------------------------------------------------------- 
IF NOT  EXISTS (SELECT [key] 
               FROM   systemconfigurationkeys 
               WHERE  [key] = 'ValidateClientGenderOnBedAdmit' 
                      AND Isnull(recorddeleted, 'N') = 'N') 
	BEGIN 
	  INSERT INTO systemconfigurationkeys 
			  ([key], 
			   value, 
			   [description]) 
	  VALUES   ('ValidateClientGenderOnBedAdmit', 
			   'NO', 
				'This value of this key is used for customer Renaissance - Whiteboard Add Validation. We need a validation that prevents the staff from admitting males and females to the same room.'
			  ) 
	END 
ELSE 
	BEGIN 
	  UPDATE systemconfigurationkeys 
	  SET    value = 'NO', 
			 [description] ='This value of this key is used for customer Renaissance - Whiteboard Add Validation. We need a validation that prevents the staff from admitting males and females to the same room.'
	  Where  [key] = 'ValidateClientGenderOnBedAdmit' AND Isnull(recorddeleted, 'N') = 'N'         
	END 
go 

