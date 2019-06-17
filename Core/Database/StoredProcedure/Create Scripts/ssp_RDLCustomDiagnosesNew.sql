IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_RDLCustomDiagnosesNew]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_RDLCustomDiagnosesNew]
GO
CREATE PROCEDURE [dbo].[ssp_RDLCustomDiagnosesNew]
    (
      @DocumentVersionId INT                                                                   
    )
AS /*********************************************************************/                                                                                          
 /* Stored Procedure:[ssp_RDLCustomDiagnosesNew]*/                                                                      
 /* Creation Date: 19 May 2014                                         */                                                                                          
 /*                                                                    */                                                                                          
 /* Purpose: To Initialize                                             */                                                                                         
 /*                                                                    */                                                                                          
 /* Created By: Bernardin                                              */                                                                                
 /*                                                                    */                                                                                          
 /*   Updates:                                                         */                                                                                          
 /*       Date              Author                  Purpose            */                                                                                          
       
/*   20 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */ 
--13-April-2016 SuryaBalan Pathway - Environment Issues Tracking #28 Pathway wants OrganizationName as 'Pathway Caring For Children' above to Document Name  
/*05-May-2017   NJain			   - MFS SGL # Updated to join to Documents table using DocumentVersions table, instead of using CurrentDocumentVersionId. If the Document has more											than 2 Versions, this join fails for older versions.  */
 /*********************************************************************/                                                  
                                                 
    BEGIN                                                            
                        
        BEGIN TRY       

            SELECT  D.ClientId
	-- Modified by   Revathi   20 Oct 2015
                    ,
                    CASE WHEN ISNULL(C.ClientType, 'I') = 'I' THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
                         ELSE ISNULL(C.OrganizationName, '')
                    END AS ClientName ,
                    CASE WHEN C.DOB IS NOT NULL THEN CONVERT(VARCHAR(10), C.DOB, 101)
                         ELSE ''
                    END DOB ,
                    CONVERT(VARCHAR(10), D.EffectiveDate, 101) AS EffectiveDate ,
                    ( SELECT    OrganizationName
                      FROM      SystemConfigurations
                    ) AS OrganizationName  
--,A.AgencyName AS OrganizationName 
                    ,
                    DDICD10.DocumentVersionId ,
                    DDICD10.ScreeeningTool ,
                    DDICD10.OtherMedicalCondition ,
                    DDICD10.FactorComments ,
                    DDICD10.GAFScore ,
                    DDICD10.WHODASScore ,
                    DDICD10.CAFASScore ,
                    DDICD10.NoDiagnosis
            FROM    DocumentDiagnosis DDICD10
                    CROSS JOIN Agency A
                    JOIN dbo.DocumentVersions DV ON DV.DocumentVersionId = DDICD10.DocumentVersionId
                    JOIN Documents D ON D.DocumentId = DV.DocumentId
                    JOIN Clients C ON D.ClientId = C.ClientId
                    JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId
                    LEFT JOIN ClientAddresses CA ON C.ClientId = CA.ClientId
            WHERE   DDICD10.DocumentVersionId = @DocumentVersionId
                    AND ISNULL(C.RecordDeleted, 'N') = 'N'
                    AND ISNULL(D.RecordDeleted, 'N') = 'N'
                    AND ISNULL(DV.RecordDeleted, 'N') = 'N'
                    AND ISNULL(DC.RecordDeleted, 'N') = 'N'
                    AND ISNULL(DDICD10.RecordDeleted, 'N') = 'N'                                      
     
        END TRY                                                                  
                                                                                                           
        BEGIN CATCH                      
            DECLARE @Error VARCHAR(8000)                                                                   
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLCustomDiagnosesNew') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                              
            RAISERROR                                                                                                 
 (                                       
  @Error, -- Message text.                                                                                                
  16, -- Severity.                                                                                                
  1 -- State.                                                                           
 );                                                                                              
        END CATCH                                             
    END 