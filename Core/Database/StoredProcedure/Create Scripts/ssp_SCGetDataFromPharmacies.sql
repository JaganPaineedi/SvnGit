IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataFromPharmacies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataFromPharmacies]
GO  
CREATE PROCEDURE [dbo].[ssp_SCGetDataFromPharmacies] ( @ClientId INT )  
AS   
    BEGIN                            
/*********************************************************************/                              
/* Stored Procedure: dbo.ssp_SCGetDataFromPharmacies                */                     
                    
/* Copyright: 2005 Provider Claim Management System             */                              
                    
/* Creation Date:  30/10/2006                                    */                              
/*                                                                   */                              
/* Purpose: Gets Data From Pharamacies Table  */                             
/*                                                                   */                            
/* Input Parameters: None */                            
/*                                                                   */                               
/* Output Parameters:                                */                              
/*                                                                   */                              
/* Return:   */                              
/*                                                                   */                              
/* Called By: getPharmacies() Method in MSDE Class Of DataService  in "Always Online Application"  */                    
/*      */                    
                    
/*                                                                   */                              
/* Calls:                                                            */                              
/*                                                                   */                              
/* Data Modifications:                                               */                              
/*                                                                   */                              
/*   Updates:                                                          */                              
                    
/*       Date              Author                  Purpose                                    */                              
/*  30/10/2006    Piyush Gajrani           Created                      
/* 12/02/2009    Loveena     Modified (as per task#188 to display Pharmacies in alphabetical order)*/                 
/* 26/02/2009    Loveena     Modified (as per task#92 drop-down to display all active pharmacies)*/                 
/* 02/03/2009  Loveena  Modified (as per task#155 To Remove Select * Statements from Stored Procedures */      
/* 22Oct2009   Loveena  Modified ( as ref to Task#2589 To Sort Pharmacies according to Sequence Number*/                                */                              
/* Oct 17 2012 Chuck Blaine Added SureScriptsPharmacyIdentifier to select statement when ClientId is not null*/  
/* Dec 11 2012 Chuck Blaine Added filter for PreferredPharmacy = 'Y'*/  
/* Jun 17 2016 Added ServiceLevel by  joining with SureScriptsPharmacyUpdate'*/  
/* Dec 12 2017   Added   ISNULL(#temp.SequenceNumber,99) w.r.t  */
/*********************************************************************/                               
                          
  --Commented by Loveena in ref to Task#155 on 2-March-2009 to remove Select * Statements.                
  --select * from dbo.Pharmacies where ISNULL(RecordDeleted,'N')='N'                
  --Added Select Statement by Loveena in ref to Task#155 on 2-March-2009 to remove Select * Statements               
  --Commented by Loveena in ref to Task#2589             
 -- select Pharmacies.PharmacyId,PharmacyName,Active,PhoneNumber,FaxNumber,Address,City,State,                
 -- ZipCode,AddressDisplay,Pharmacies.RowIdentifier,Pharmacies.ExternalReferenceId,Pharmacies.CreatedBy, Pharmacies.CreatedDate, Pharmacies.ModifiedBy, Pharmacies.ModifiedDate,               
 -- Pharmacies.RecordDeleted, Pharmacies.DeletedDate, Pharmacies.DeletedBy              
 -- from dbo.Pharmacies               
 --  where ISNULL(Pharmacies.RecordDeleted,'N')='N'         
 --And isnull(Active,'Y')<>'N' order by PharmacyName             
      BEGIN TRY  
        IF ( @ClientId IS NOT NULL )   
            BEGIN         
                CREATE TABLE #temp  
                    (  
                      PharmacyId INT ,  
                      PharmacyName VARCHAR(100) ,  
                      Active CHAR ,  
                      PhoneNumber VARCHAR(50) ,  
                      FaxNumber VARCHAR(50) ,  
                      Address VARCHAR(100) ,  
                      City VARCHAR(30) ,  
                      State VARCHAR(30) ,  
                      ZipCode VARCHAR(12) ,  
                      AddressDisplay VARCHAR(150) ,  
                      SequenceNumber INT ,  
                      SureScriptsPharmacyIdentifier VARCHAR(35)  
                    )            
                INSERT  INTO #temp  
                        SELECT  ph.PharmacyId ,  
                                PharmacyName ,  
                                Active ,  
                                PhoneNumber ,  
                                FaxNumber ,  
                                Address ,  
                                City ,  
                                State ,  
                                ZipCode ,  
                                AddressDisplay ,  
                                SequenceNumber ,  
                                SureScriptsPharmacyIdentifier  
                        FROM    Pharmacies ph  
                                JOIN ClientPharmacies cp ON cp.PharmacyId = ph.PharmacyId  
                        WHERE   ISNULL(ph.RecordDeleted, 'N') = 'N'  
                                AND ISNULL(cp.RecordDeleted, 'N') = 'N'  
                                AND ISNULL(Active, 'Y') <> 'N'  
        AND ph.PreferredPharmacy = 'Y'  
                                AND Clientid = @ClientId            
             
                SELECT  ph.PharmacyId ,  
                        dbo.csf_ReformatPharmacyName(ph.PharmacyId) AS [PharmacyName] ,  
                        ph.Active ,  
                        ph.PhoneNumber ,  
                        ph.FaxNumber ,  
                        ph.Address ,  
                        ph.City ,  
                        ph.State ,  
                        ph.ZipCode ,  
                        ph.AddressDisplay ,  
                        ph.RowIdentifier ,  
                        ph.ExternalReferenceId ,  
                        ph.CreatedBy ,  
                        ph.CreatedDate ,  
                        ph.ModifiedBy ,  
                        ph.ModifiedDate ,  
                        ph.RecordDeleted ,  
                        ph.DeletedDate ,  
                        ph.DeletedBy ,  
                        ISNULL(#temp.SequenceNumber,99) AS SequenceNumber ,  
                        ph.SureScriptsPharmacyIdentifier,  
                        SP.ServiceLevel  
                FROM    dbo.Pharmacies ph  
                        LEFT JOIN #temp ON #temp.PharmacyId = ph.PharmacyId  
                        LEFT JOIN SureScriptsPharmacyUpdate SP ON SP.NCPDPID = ph.SureScriptsPharmacyIdentifier  
                WHERE   ph.PreferredPharmacy = 'Y'  
                        AND ISNULL(ph.RecordDeleted, 'N') = 'N'  
                        AND ISNULL(ph.Active, 'Y') <> 'N'  
                ORDER BY ph.PharmacyName  
             
                DROP TABLE #temp           
            END        
        ELSE   
            SELECT  ph.PharmacyId ,  
                    dbo.csf_ReformatPharmacyName(ph.PharmacyId) AS [PharmacyName] ,  
                        ph.Active ,  
                        ph.PhoneNumber ,  
                        ph.FaxNumber ,  
                        ph.Address ,  
                        ph.City ,  
                        ph.State ,  
                        ph.ZipCode ,  
                        ph.AddressDisplay ,  
                        ph.RowIdentifier ,  
                        ph.ExternalReferenceId ,  
                        ph.CreatedBy ,  
                        ph.CreatedDate ,  
                        ph.ModifiedBy ,  
                        ph.ModifiedDate ,  
                        ph.RecordDeleted ,  
                        ph.DeletedDate ,  
                        ph.DeletedBy ,  
                        ph.SureScriptsPharmacyIdentifier  
                FROM    dbo.Pharmacies ph  
                WHERE   PreferredPharmacy = 'Y'  
                        AND ISNULL(RecordDeleted, 'N') = 'N'  
                    AND ISNULL(Active, 'Y') <> 'N'  
            ORDER BY PharmacyName              
                    
                                     
                            
    END TRY  
    BEGIN CATCH  
        EXEC ssp_SQLErrorHandler  
    END CATCH  
  
 END  
  
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  