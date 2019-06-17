/*  Date			Author			Purpose																							*/ 
/*  --------------------------------------------------------------------------------------------------------------------------------*/           
/*  2-Feb-2018	   Nandita			New key added to display full pharmacy address in Prescription. Andrews Center #184                        	                    */
/*  --------------------------------------------------------------------------------------------------------------------------------*/ 


IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'DisplayFullPharmacyAddress')
BEGIN
  INSERT INTO [dbo].[SystemConfigurationKeys]
       ([Key]
       ,[Value]
       ,[Description]
       ,[AcceptedValues]
       ,[ShowKeyForViewingAndEditing]
       ,[Modules]
       )
    VALUES    
       ('DisplayFullPharmacyAddress'
       ,'N'
       ,'Display full pharmacy address in Prescription'
       ,'Y,N,NULL'
       ,'N'
       ,'Rx')
            
 END
BEGIN
      UPDATE [SystemConfigurationKeys]
      SET [Value] = 'N'
	   ,[Description] = 'Display full pharmacy address in Prescription'
       ,[AcceptedValues] = 'Y,N,NULL'
       ,[ShowKeyForViewingAndEditing] = 'N'
       ,[Modules] = 'Rx'
    WHERE [Key] = 'DisplayFullPharmacyAddress'
END