/*  Date			Author			Purpose																							*/ 
/*  --------------------------------------------------------------------------------------------------------------------------------*/           
/*  17-May-2016	    Rohith			New key added to trigger Validation for Multiple site for claims. Newaygo Support #501                        	                    */
/*  --------------------------------------------------------------------------------------------------------------------------------*/ 


IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'ValidateMultipleSitesforClaim')
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
       ('ValidateMultipleSitesforClaim'
       ,'Y'
       ,'Only one Provider/Site combination can be added to a claim'
       ,'Y,N,NULL'
       ,'Y'
       ,'Claims')
            
 END
BEGIN
      UPDATE [SystemConfigurationKeys]
      SET [Value] = 'Y'
	   ,[Description] = 'Only one Provider/Site combination can be added to a claim'
       ,[AcceptedValues] = 'Y,N,NULL'
       ,[ShowKeyForViewingAndEditing] = 'Y'
       ,[Modules] = 'Claims'
    WHERE [Key] = 'ValidateMultipleSitesforClaim'
END