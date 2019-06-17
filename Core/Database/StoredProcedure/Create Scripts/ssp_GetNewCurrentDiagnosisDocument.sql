 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetNewCurrentDiagnosisDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetNewCurrentDiagnosisDocument]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
Create PROCEDURE [dbo].[ssp_GetNewCurrentDiagnosisDocument]   (              
 @ClientId INT,           
 @DocumentVersionID INT              
 )              
AS              
  
  /*********************************************************************/                                                                                          
 /* Stored Procedure:[ssp_GetNewCurrentDiagnosisDocument]*/                                                                      
 /* Creation Date: 20/09/2017                                        */                                                                                          
 /*                                                                    */                                                                                          
 /* Purpose: To Initialize  last signed  DSM diagnosis document  */                                                                                         
 /*                                                                    */                                                                                          
 /* Created By: Kavya                                              */                                                                                
 /* 09/09/2018      Veena      	 Added ClientID as it was pulling the latest diagnosis without considering the selected client  CCC Go live Critical  */								  
 /* 09/10/2018      Veena        Adding task no for yesterday's commit 	CCC-Environmental Issues: #156   */	
 /* 10/01/2018      Vijeta       Added Billable field to initialize in the diagnosis tab from last signed document, Because Billable field field hould should not be NULL.
                                 MHP-Support Go Live : #732  */								  
 /*********************************************************************/  
  
           
BEGIN              
 BEGIN TRY              
 DECLARE @LatestICD10DocumentVersionID INT                
               
SET @LatestICD10DocumentVersionID =(SELECT  TOP 1   a.CurrentDocumentVersionId                
         FROM Documents AS a INNER JOIN     DocumentCodes AS Dc               
         ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN                
         DocumentDiagnosis AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                                     
         WHERE a.EffectiveDate <=  GETDATE()                                                                       
         and a.[Status] = 22 and Dc.DiagnosisDocument='Y'  and a.ClientID=@ClientId             
         and isNull(a.RecordDeleted,'N')<>'Y'               
         and isNull(Dc.RecordDeleted,'N')<>'Y'               
         and ISNULL(DDC.RecordDeleted,'N')<>'Y'                 
         ORDER BY a.EffectiveDate desc,a.ModifiedDate DESC)                 
                       
 IF (@LatestICD10DocumentVersionID>0)              
   BEGIN               
   SELECT Placeholder.TableName                 
      ,DDC.CreatedBy                
      ,DDC.CreatedDate                
      ,DDC.ModifiedBy                
      ,DDC.ModifiedDate                
      ,DDC.RecordDeleted                 
      ,DDC.DeletedDate                
      ,DDC.DeletedBy                
      ,@DocumentVersionId AS 'DocumentVersionId'                
      ,DDC.DocumentDiagnosisCodeId              
      ,DDC.ICD10Code  ,          
      DDC.ICD10CodeId              
      ,DDC.ICD9Code                                                                              
      ,ICD10.ICDDescription AS DSMDescription                
      ,case DDC.RuleOut when 'Y' then 'R/O' else '' end as RuleOutText          
      --case DDC.RuleOut when 'Y' then 'Y' else 'N' end as RuleOutText ,          
      ,DDC.RuleOut  
      ,DDC.Billable             
      ,dbo.csf_GetGlobalCodeNameById(DDC.DiagnosisType)as 'DiagnosisTypeText'                
      ,'Y' AS DSM5              
     ,DDC.DocumentVersionId AS LastDocumentVersionId ,          
     DDC.SNOMEDCODE ,          
     dbo.csf_GetGlobalCodeNameById(DDC.Severity) as 'SeverityText' ,          
     DDC.Severity ,          
     DDC.[Source],          
     DDC.Comments,          
     DDC.DiagnosisOrder ,          
     SNC.SNOMEDCTDescription     
     ,'Dummy' as   EducationInfoButton ,  
     DDC.DiagnosisType         
               
    FROM (SELECT 'DocumentDiagnosisCodes' AS TableName) AS Placeholder                  
    LEFT JOIN DocumentDiagnosisCodes DDC ON ( DDC.DocumentVersionId = @LatestICD10DocumentVersionID                  
    AND ISNULL(DDC.RecordDeleted,'N') <> 'Y' )                
    INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId                
    LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE      
    ORDER BY  DDC.DiagnosisOrder       
             
  END                         
                       
                       
 END TRY              
              
 BEGIN CATCH              
  DECLARE @Error VARCHAR(8000)              
              
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetNewCurrentDiagnosisDocument') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())              
              
  RAISERROR (              
    @Error              
    ,-- Message text.                                                                                                                          
    16              
    ,-- Severity.                                                         
    1 -- State.                                                                                                            
    );              
 END CATCH              
END 