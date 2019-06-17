/****** Object:  StoredProcedure [dbo].[csp_InitCustomScreeningStandardInitialization]    Script Date: 06/02/2014 14:13:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomScreeningStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomScreeningStandardInitialization]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomScreeningStandardInitialization]    Script Date: 06/02/2014 14:13:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitCustomScreeningStandardInitialization]
    (
      @ClientID INT ,
      @StaffID INT ,
      @CustomParameters XML                                                                                                                
    )
AS /*********************************************************************/ 
 /* Stored Procedure: [csp_InitCustomScreeningStandardInitialization]               */                                                                                                                                                         
 /* Copyright: 2006 Streamline SmartCare*/                                                                                                                                                                  
 /* Creation Date:  07/05/2015                                   */                                                                                                                                                                  
 /*                                                                   */                                                                                                                                                                  
 /* Purpose: To Initialize */                                                                                                                                                                 
 /*                                                                   */                                                                                                                                                                
 /* Input Parameters:  */                                                                                                                                                                
 /*                                                                   */                                                                                                                                                                   
 /* Output Parameters:                                */                                                                                                                                                                  
 /*                                                                   */                                                                                                                                                                  
 /* Return:   */                                                                                                                                                                  
 /*                                                                   */                                                                                                                                                                  
 /* Called By:CustomDocuments Class Of DataService    */                            
 /*      */                                   
 /*                   */                                                        
 /* Calls:     */             
 /*                     */                              
 /* Data Modifications:       
 
 --Shruthi.S  07/05/2015 Added Initialization sp for Screening document.Ref : #39 New Directions - Customizations
   
 *********************************************************************/
 
 BEGIN
   BEGIN TRY
    --To initialize main custom tables
            SELECT TOP 1
                    'CustomDocumentSubstanceAbuseScreenings' AS TableName ,
                    -1 AS 'DocumentVersionId' ,
                    'shc' AS CreatedBy ,
                    GETDATE() AS CreatedDate ,
                    'shc' AS ModifiedBy ,
                    GETDATE() AS ModifiedDate ,
                    'N' as RecordDeleted 
            FROM    systemconfigurations s
                    LEFT OUTER JOIN CustomDocumentSubstanceAbuseScreenings ON s.Databaseversion = -1    
                    
                    
            SELECT TOP 1
                    'CustomDocumentMentalHealthScreenings' AS TableName ,
                    -1 AS 'DocumentVersionId' ,
                    'shc' AS CreatedBy ,
                    GETDATE() AS CreatedDate ,
                    'shc' AS ModifiedBy ,
                    GETDATE() AS ModifiedDate ,
                    'N' as RecordDeleted 
            FROM    systemconfigurations s
                    LEFT OUTER JOIN CustomDocumentMentalHealthScreenings ON s.Databaseversion = -1 
                    
            SELECT TOP 1
                    'CustomDocumentTraumaticBrainInjuryScreenings' AS TableName ,
                    -1 AS 'DocumentVersionId' ,
                    'shc' AS CreatedBy ,
                    GETDATE() AS CreatedDate ,
                    'shc' AS ModifiedBy ,
                    GETDATE() AS ModifiedDate ,
                    'N' as RecordDeleted 
            FROM    systemconfigurations s
                    LEFT OUTER JOIN CustomDocumentTraumaticBrainInjuryScreenings ON s.Databaseversion = -1 
                    
            
             SELECT TOP 1
                    'CustomDocumentOutComesScreenings' AS TableName ,
                    -1 AS 'DocumentVersionId' ,
                    'shc' AS CreatedBy ,
                    GETDATE() AS CreatedDate ,
                    'shc' AS ModifiedBy ,
                    GETDATE() AS ModifiedDate ,
                    'N' as RecordDeleted 
            FROM    systemconfigurations s
                    LEFT OUTER JOIN CustomDocumentOutComesScreenings ON s.Databaseversion = -1  
   END TRY                                                                     
                                                                                                              
        BEGIN CATCH                     
            DECLARE @Error VARCHAR(8000)                                                                                        
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         '[csp_InitCustomScreeningStandardInitialization]')
                + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE())                                                                                                                            
            RAISERROR                                                                                     
(                                                                                                                                             
    @Error, -- Message text.                                                                           
    16, -- Severity.                                                                                            
    1 -- State.                                                                                                                             
  ) ;                                                                                                                                                                            
        END CATCH  
 END   