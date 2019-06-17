IF OBJECT_ID('csp_ValidateCustomDocumentInformedConsents','P') IS NOT NULL
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentInformedConsents]
GO

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
GO

  
CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentInformedConsents]
    @CurrentUserId INT ,
    @ScreenKeyId INT
AS /******************************************************************************                                              
**  File: [csp_ValidateCustomDocumentInformedConsents]                                          
**  Name: [csp_ValidateCustomDocumentInformedConsents]                      
**  Desc: For Validation  on Informed Consents          
**  Return values: Resultset having validation messages                                              
**  Called by:  CustomDocumentInformedConsents Informed Consents Page                                             
**  Parameters:  @CurrentUserId,@ScreenKeyId                        
**  Auth:  Amit Kumar Srivastava                             
**  Date:  Jan 11 2012
*******************************************************************************                                              
**  Change History                                              
*******************************************************************************                                              
**  Date:       Author:     Description:       
**  11/01/2012  Amit Kumar Srivastava   To check server side validation       
**	1/8/2015 DBlankenberger UPdated to include Effective Date date range validation                            
*******************************************************************************/                                            
            
              
    BEGIN                                                            
                  
        BEGIN TRY    
            DECLARE @CurrentDocumentVersionId INT  
              
            SET @CurrentDocumentVersionId = ( SELECT TOP 1
                                                        InProgressDocumentVersionId
                                              FROM      CustomDocumentInformedConsents C
                                                        INNER JOIN Documents Doc ON C.DocumentVersionId = Doc.InProgressDocumentVersionId
                                                        INNER JOIN documentVersions d ON d.documentId = doc.documentId
                                              WHERE     d.documentID = @ScreenKeyId
                                                        AND ISNULL(C.RecordDeleted, 'N') = 'N'
                                                        AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
                                                        AND ISNULL(d.RecordDeleted, 'N') = 'N'
                                            )    
 --*TABLE CREATE*--     
            DECLARE @CustomDocumentInformedConsents TABLE
                (
                  DocumentVersionId INT ,
                  MemberRefusedSignature CHAR(1) ,
                  MemberRefusedExplaination VARCHAR(MAX)
                )  
  
--*INSERT LIST*--                
            INSERT  INTO @CustomDocumentInformedConsents
                    ( DocumentVersionId ,
                      MemberRefusedSignature ,
                      MemberRefusedExplaination 
                    )              
--*Select LIST*--                  
                    SELECT  DocumentVersionId ,
                            MemberRefusedSignature ,
                            MemberRefusedExplaination
                    FROM    CustomDocumentInformedConsents C
                    WHERE   C.DocumentVersionId = @CurrentDocumentVersionId
                            AND ISNULL(RecordDeleted, 'N') <> 'Y'   
  
            DECLARE @validationReturnTable TABLE
                (
                  TableName VARCHAR(200) ,
                  ColumnName VARCHAR(200) ,
                  ErrorMessage VARCHAR(1000)
                )           
-- Add Effective Date Validation 1-8-2015
            DECLARE @Edate DATETIME
            SET @Edate = ( SELECT   EffectiveDate
                           FROM     Documents d
                           WHERE    d.CurrentDocumentVersionId = @CurrentDocumentVersionId
                         )
            IF ( @Edate NOT BETWEEN DATEADD(MONTH, -6, GETDATE())
                        AND         DATEADD(DAY, 1, GETDATE()) ) 
                BEGIN
                    INSERT  INTO @validationReturnTable
                            ( TableName ,
                              ColumnName ,
                              ErrorMessage              
	                        ) 
	--This validation returns three fields              
	--Field1 = TableName              
	--Field2 = ColumnName              
	--Field3 = ErrorMessage   
                            SELECT  'CustomDocumentInformedConsents' ,
                                    'Effective Date' ,
                                    ( 'Please change the Effective Date to be between ' + CONVERT(VARCHAR, DATEADD(MONTH, -6, GETDATE()), 101) + ' and ' + CONVERT(VARCHAR, DATEADD(DAY, 1, GETDATE()), 101) )
                END


            DECLARE @varMemberRefusedSignature VARCHAR(1)
            SET @varMemberRefusedSignature = ( SELECT TOP 1
                                                        ISNULL(MemberRefusedSignature, 'N') AS 'MemberRefusedSignature'
                                               FROM     @CustomDocumentInformedConsents
                                             )

            IF ( @varMemberRefusedSignature != 'N' ) 
                BEGIN
                    INSERT  INTO @validationReturnTable
                            ( TableName ,
                              ColumnName ,
                              ErrorMessage              
	                        )     
	--This validation returns three fields              
	--Field1 = TableName              
	--Field2 = ColumnName              
	--Field3 = ErrorMessage   
                            SELECT  'CustomDocumentInformedConsents' ,
                                    'MemberRefusedExplaination' ,
                                    'Please specify why the member refuses or is unwilling to sign this consent.'
                            FROM    @CustomDocumentInformedConsents
                            WHERE   MemberRefusedExplaination = ''
                                    OR ISNULL(MemberRefusedExplaination, '') = ''   
                END
      
            SELECT  TableName ,
                    ColumnName ,
                    ErrorMessage
            FROM    @validationReturnTable    
        
            IF EXISTS ( SELECT  *
                        FROM    @validationReturnTable ) 
                BEGIN         
                    SELECT  1 AS ValidationStatus        
                END        
            ELSE 
                BEGIN        
                    SELECT  0 AS ValidationStatus        
                END        
        
  
        END TRY                                                            
                                                                                            
        BEGIN CATCH                
              
            DECLARE @Error VARCHAR(8000)                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[csp_ValidateCustomDocumentInformedConsents]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 );                                                                                       
        END CATCH                                      
    END    
  
GO


