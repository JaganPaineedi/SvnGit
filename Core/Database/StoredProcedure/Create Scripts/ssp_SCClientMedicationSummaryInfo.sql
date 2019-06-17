IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_SCClientMedicationSummaryInfo]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_SCClientMedicationSummaryInfo]
GO
      
      
CREATE PROCEDURE [dbo].[ssp_SCClientMedicationSummaryInfo]
    @ClientRowIdentifier VARCHAR(150) ,
    @StaffRowIdentifier VARCHAR(150),
	@RequirePharamcies INT = 1
AS /**********************************************************************/                                  
/* Stored Procedure: dbo.ssp_SCClientMedicationSummaryInfo            */                                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC              */                                  
/* Creation Date:    08/23/2007                                       */                                  
/*                                                                    */                                  
/* Purpose:Used to fill the values in Medication Tab                  */                                 
/*                                                                    */                                
/* Input Parameters: @varClientId, @varClinicianId                    */                                
/*                                                                    */                                  
/* Output Parameters:   None                                          */                                  
/*                                                                    */                                  
/* Return:  0=success, otherwise an error number                      */                                  
/*                                                                    */                                  
/* Called By: DownloadClientMedicationSummary() in MSDE               */                                  
/*                                                                    */                                  
/* Calls:                                                             */                                  
/*                                                                    */                                  
/* Data Modifications:                                                */                                  
/*                                                                    */                                  
/* Updates:                                                           */                                  
/*    Date        Author       Purpose                                */                                  
/* 08/23/2007   Rohit Verma    Created                                */              
/* 12/23/2007 Sonia Dhamija Modified to retrive data related to Allergy interactions and to get DiagnosisIII codes*/                              
/* 12/04/2008 Rohit Verma   Modified to get the patient information as final html text*/      
/* 12/26/2008 Loveena Sukhija Modified to get ClientPharmacies*/       
/* Aug 19, 2011 Kneale Alpers updated the ssp_SCGetClientMedicationData to call ssp_SCGetClientMedicationDataWithOverrides */
/* Aug 25, 2011 Kneale Alpers Remove unwanted/commented out code      */
/* Oct 8, 2013  Kneale Alpers Added the parameter RequirePharamcies to pass to the ssp_MMGetClientPharmacies stored procedure*/
/* 05 Jan, 2018 Bernardin  Added RecordDeleted check and Active check.Subquery returning multiple values.MHP-Support Go Live# 435*/
/* 25/02/2019 Musman, Subquery was returning multiple client with the same rowidentifier so added check on selecting Active client as part of  CEI - Support Go Live #1120  */


/**********************************************************************/                                   
                              
    BEGIN                                
      BEGIN TRY                        
        DECLARE @varClinicianId AS INT                                    
        DECLARE @varClientId AS INT                                    
        DECLARE @varCurrentDocumentVersionid INT
                                
        SET @varClinicianId = ( SELECT  StaffId
                                FROM    Staff
                                WHERE   RowIdentifier = @StaffRowIdentifier 
                                -- Added by Bernardin on 05/01/2018 For MHP-Support Go Live# 435
                                AND ISNULL(RecordDeleted, 'N') = 'N' AND Active = 'Y'
                              )                                           
                                
        SET @varClientId = ( SELECT ClientId
                             FROM   Clients
                             WHERE  RowIdentifier = @ClientRowIdentifier
                                    AND ISNULL(RecordDeleted, 'N') = 'N'
     			           -- Added by Musmanon 02/25/2019 For CEI - Support Go Live # 1120
                                  AND Active = 'Y'
                           )                                     
                              
   
        SELECT  @varCurrentDocumentVersionid = a.CurrentDocumentVersionId
        FROM    Documents a
        WHERE   a.ClientId = @varClientId
                AND a.DocumentCodeId = 5
                AND a.Status = 22
                AND ISNULL(a.RecordDeleted, 'N') = 'N'
                AND NOT EXISTS ( SELECT *
                                 FROM   Documents b
                                 WHERE  b.ClientId = @varClientId
                                        AND b.DocumentCodeId = 5
                                        AND b.Status = 22
                                        AND b.EffectiveDate > a.EffectiveDate
                                        AND ISNULL(b.RecordDeleted, 'N') = 'N' )                                
                                
                              
/*========= Client Allergies =========*/                              
                      
        EXEC ssp_SCGetClientAllergiesData @varClientId                         
                           
/*========= Get Client Allergy History===================================start*/      
        EXEC ssp_SCGetClientAllergiesHistoryData @varClientId              
/*====================End Client Allergy History===========================*/      

/*========= END Client Allergies =========*/                              
                              
/*========= Medication Information =========*/                              
        --EXEC ssp_SCGetClientMedicationData @varClientId                  
        EXEC ssp_SCGetClientMedicationDataWithOverrides @varClientId,
            @varClinicianId   
        
        
/*========= END Medication Information =========*/       

--Added as per Task 2373 SC-Support              
/*========= Diagnosis Information for Axis I,II and III=========*/                              
   --EXEC ssp_SCClientMedicationDiagnosisAxisCodes @varClientId   
        EXEC ssp_SCClientMedicationDxpurpose @varClientId                          
/*========= END Medication Information =========*/                            
                      
/*========= Get Formated html text of clinet Information=========start*/      
        EXEC scsp_SCClientMedicationClientInformation @varClientId     --added by Rohit MM #81                               
/*========= Get Formated html text of clinet Information =========end*/      


/*========= Get Formated html text of clinet Information=========start*/                        
        --EXEC scsp_SCClientMedicationClientInformation @varClientId     --added by Rohit MM #81                               
/*========= Get Formated html text of clinet Information =========end*/ 
      
/*========= Get ClientPharmacies===================================start*/      
        EXEC ssp_MMGetClientPharmacies @varClientId, @RequirePharamcies
/*====================End ClientPharmacies===========================*/      
             
END TRY                              
BEGIN CATCH                    
DECLARE @Error varchar(8000)                                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCClientMedicationSummaryInfo')                                                                                               
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                             
 RAISERROR                                                                                               
 (                                                                 
  @Error, -- Message text.                                                                                              
  16, -- Severity.                                                                                              
  1 -- State.                                                                                              
 );                                                                                            
END CATCH                                
END 

GO


