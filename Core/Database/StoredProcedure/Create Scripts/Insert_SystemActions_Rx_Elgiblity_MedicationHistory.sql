/* What : Adding seperate permissions for Eligibility,MedicationHistory,DrugFormulary */
/* Why  : Since Eligibility and MedicationHistory tabs used the same Reconciliation pemission to show/hide of tabs.
          seperate permissions are created. DrugFormulary is used to show/hide the DrugFormulary tab*/
/* Created by : Anto 02/02/2016  Engineering Improvement Initiatives #270*/
/* Modified By : Malathi Shiva 12/May/2016 Queue Order button Permission entry was missing in the db and svn so added the same*/

SET IDENTITY_INSERT dbo.SystemActions ON  
IF ( NOT EXISTS ( SELECT    *
                  FROM      dbo.SystemActions
                  WHERE     actionid = 10071 )
   ) 
    BEGIN   
        INSERT  dbo.SystemActions
                ( actionid ,
                  ApplicationId ,
                  ScreenName ,
                  Action
                )
        VALUES  ( 10071 ,
                  5 , -- ApplicationId 
                  'Medication Management' , 
                  'Eligibility'
                )
    END 
    
    
    IF ( NOT EXISTS ( SELECT    *
                  FROM      dbo.SystemActions
                  WHERE     actionid = 10072 )
   ) 
    BEGIN   
        INSERT  dbo.SystemActions
                ( actionid ,
                  ApplicationId ,
                  ScreenName ,
                  Action
                )
        VALUES  ( 10072 ,
                  5 , -- ApplicationId 
                  'Medication Management' , 
                  'Medication History'
                )
    END    
    
    
     IF ( NOT EXISTS ( SELECT    *
                  FROM      dbo.SystemActions
                  WHERE     actionid = 10073 )
   ) 
    BEGIN   
        INSERT  dbo.SystemActions
                ( actionid ,
                  ApplicationId ,
                  ScreenName ,
                  Action
                )
        VALUES  ( 10073 ,
                  5 , -- ApplicationId 
                  'Medication Management' , 
                  'Drug Formulary'
                )
    END    
    
    IF ( NOT EXISTS ( SELECT    *
                  FROM      dbo.SystemActions
                  WHERE     actionid = 10052 )
   ) 
    BEGIN   
		INSERT  dbo.SystemActions
                ( actionid ,
                  ApplicationId ,
                  ScreenName ,
                  Action
                )
        VALUES  ( 10052 ,
                  5 , -- ApplicationId 
                  'Medication Management' , 
                  'Queue Order'
                )
                
	END
	
SET IDENTITY_INSERT dbo.SystemActions OFF