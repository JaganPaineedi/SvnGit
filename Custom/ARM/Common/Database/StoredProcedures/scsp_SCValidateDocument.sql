IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCSP_SCVALIDATEDOCUMENT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SCSP_SCVALIDATEDOCUMENT]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO    
CREATE PROCEDURE [DBO].[SCSP_SCVALIDATEDOCUMENT]    
    @CurrentUserId INT ,    
    @DocumentId INT ,    
    @CustomValidationStoreProcedureName VARCHAR(100)    
AS /*******************************************************************************************************************/                             /* Stored Procedure: dbo.scsp_SCValidateDocument  */                          
--  Copyright: Streamline Healthcate Solutions                                                                                                                                      
-- Purpose: SHS Team will create business logic for each customer specific in this scsp_SCValidateDocument      
-- This  scsp_SCValidateDocument is called from ssp_SCValidateDocument                                                                                                                                      
-- Updates:                                                                                                                                 
-- Date                   Author      Purpose                                                                          
-- 17thAugust 2009        Vikas      Created.      
-- 05 August 2011         Rakesh     Modified           
-- 23 jan 2013         Varinder Verma      added one csp w r t  task #3  for  Newaygo customization for vaidation purpose.                      
/*******************************************************************************************/                               
    DECLARE @documentVersionId INT ,    
        @ServiceId INT      
          
    SET @ServiceId = 0         
                                
    SELECT  @documentVersionId = CurrentDocumentVersionId ,    
            @ServiceId = ServiceId    
    FROM    Documents    
            JOIN DocumentCodes ON Documents.DocumentCodeId = DocumentCodes.DocumentCodeId    
    WHERE   DocumentId = @DocumentId          
      
    
    IF EXISTS ( SELECT  1    
                FROM    DocumentCodes dc    
                        JOIN Documents d ON d.DocumentCodeId = dc.DocumentCodeId    
                WHERE   d.CurrentDocumentVersionId = @DocumentVersionId    
                        AND ( ISNULL(dc.DiagnosisDocument, 'N') = 'Y'    
                              OR ISNULL(dc.DSMV, 'N') = 'Y'    
                            )    
                        AND ( NOT EXISTS ( SELECT   1    
                                           FROM     dbo.DocumentDiagnosisCodes ddc    
                                           WHERE    DDC.DocumentVersionId = @DocumentVersionId    
                                                    AND ISNULL(ddc.RecordDeleted,    
                                                              'N') = 'N' )    
                            )    
                        AND EXISTS ( SELECT 1    
                                     FROM   dbo.DocumentDiagnosis dd    
                                     WHERE  dd.DocumentVersionId = @DocumentVersionId    
                                            AND ISNULL(dd.NoDiagnosis, 'N') = 'N'    
                                            AND ISNULL(dd.RecordDeleted, 'N') = 'N' ) )     
      BEGIN    
            INSERT  INTO #ValidationReturnTable    
                    ( TableName ,    
                      ColumnName ,    
                      ErrorMessage     
                    )    
                    SELECT  'Diagnosis' ,    
                            '' ,    
                            'Document requires at least one diagnosis or that the No Diagnosis box is checked.'    
        END      
--        
-- Validation rules which apply for all documents        
--        
        IF EXISTS ( SELECT  *    
                    FROM    sys.objects    
                    WHERE   object_id = OBJECT_ID(N'[dbo].[csp_AllStandardSignatureValidations]')    
                            AND type IN ( N'P', N'PC' ) )     
            BEGIN        
                EXEC csp_AllStandardSignatureValidations @DocumentVersionId,   
                    @ServiceId        
            END        
        
        
  -------      
      
  -- below csp  is added  by Varinder Verma  w r t task #3 in Newaygo Customzation        
    IF ( @ServiceId > 0 )     
        BEGIN    
            IF EXISTS ( SELECT  *    
                        FROM    sys.objects    
                        WHERE   object_id = OBJECT_ID(N'[dbo].[csp_validateCustomServiceNote]')    
                                AND type IN ( N'P', N'PC' ) )     
                BEGIN          
                    EXEC csp_validateCustomServiceNote @ServiceId          
                END        
        END   
          
          
    --SELECT TableName,ColumnName,ErrorMessage FROM #validationReturnTable        
                                                        
    RETURN                                      
                
    error:                                      
                                      
    RAISERROR ('scsp_SCValidateDocument failed.  Contact your system administrator.',16,1)                                      
                                      
    RETURN           
        
        
         
        
        
        
        