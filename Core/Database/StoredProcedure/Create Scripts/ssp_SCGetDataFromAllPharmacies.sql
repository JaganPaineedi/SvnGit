/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataFromAllPharmacies]    Script Date: 12/17/2013 8:45:38 PM ******/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_SCHEMA = 'dbo'
                    AND SPECIFIC_NAME = 'ssp_SCGetDataFromAllPharmacies' )
DROP PROCEDURE [dbo].[ssp_SCGetDataFromAllPharmacies]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataFromAllPharmacies]    Script Date: 12/17/2013 8:45:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[ssp_SCGetDataFromAllPharmacies]
AS 
    BEGIN                          
/*********************************************************************/                            
/* Stored Procedure: dbo.ssp_SCGetDataFromPharmacies                */                   
                  
/* Copyright: 2005 Provider Claim Management System             */                            
                  
/* Creation Date:  03/04/2009                                    */                            
/*                                                                   */                            
/* Purpose: Gets Data From Pharamacies Table  */                           
/*                                                                   */                          
/* Input Parameters: None */                          
/*                                                                   */                             
/* Output Parameters:                                */                            
/*                                                                   */                            
/* Return:   */                            
/*                                                                   */                            
/* Called By: GetPharmaciesData() Method in ClientMedications Class Of DataService  in "Always Online Application"  */                  
/*      */                  
                  
/*                                                                   */                            
/* Calls:                                                            */                            
/*                                                                   */                            
/* Data Modifications:                                               */                            
/*                                                                   */                            
/*   Updates:                                                          */                            
                  
/*       Date              Author                  Purpose                                    */                            
/*  03/04/2009      Loveena                 Created (To Rertieve All Pharmacies Active=''Y'' or ''N'' for Pharmacy Management)             */                            
/*  Feb. 01,2010     Sahil Bhagat      Added  new fields (PreferredPharmacy,Email,SureScriptsPharmacyIdentifier) in ref of DataModel 8.685 to 8.688. */      
/* Aug 28, 2013      Kneale Added the column Specialty */
/*********************************************************************/                             
                             
        SELECT  PharmacyId ,
                PharmacyName ,
                Active ,
                PreferredPharmacy ,
                PhoneNumber ,
                FaxNumber ,
                Email ,
                Address ,
                SUBSTRING(City, 1, 30) AS City ,
                State ,
                ZipCode ,
                AddressDisplay ,
                NumberOfTimesFaxed ,
                SureScriptsPharmacyIdentifier ,
                RowIdentifier ,
                ExternalReferenceId ,
                CreatedBy ,
                CreatedDate ,
                ModifiedBy ,
                ModifiedDate ,
                RecordDeleted ,
                DeletedDate ,
                DeletedBy,
				Specialty
        FROM    dbo.Pharmacies
        WHERE   ISNULL(RecordDeleted, 'N') = 'N'
                AND PreferredPharmacy = 'Y'
        ORDER BY PharmacyName                     
  --Checking For Errors                  
        IF ( @@error != 0 ) 
            BEGIN                  
                RAISERROR  20006   'ssp_SCGetDataFromPharmacies: An Error Occured'                   
                RETURN                  
            END                           
                          
                  
    END

GO


