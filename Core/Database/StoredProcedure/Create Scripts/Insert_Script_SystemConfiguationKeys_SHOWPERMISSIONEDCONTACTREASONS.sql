/*Added By: Ajay       Date: 13-Dec-1016    Purpose: To add a new system configuration called ‘SHOWPERMISSIONEDCONTACTREASONS’
-	                                        Y – then contact reasons will be added to permissions
-	                                        N – (default) contact reasons will not be added to permissions (Woods - Support Go Live Task#143)  
*/


IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [Key] = 'SHOWPERMISSIONEDCONTACTREASONS')
BEGIN
	INSERT INTO SystemConfigurationKeys (CreatedBy,CreateDate,ModifiedBy,ModifiedDate,[Key],Value,AcceptedValues,Modules,Screens)
	VALUES (SYSTEM_USER,CURRENT_TIMESTAMP,SYSTEM_USER,CURRENT_TIMESTAMP,'SHOWPERMISSIONEDCONTACTREASONS','N','Y,N,NULL','ContactNotes','Contact Notes Details')
END

 