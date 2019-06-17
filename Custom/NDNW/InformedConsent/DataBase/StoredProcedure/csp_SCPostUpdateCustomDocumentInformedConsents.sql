
/****** Object:  StoredProcedure [dbo].[csp_SCPostUpdateCustomDocumentInformedConsents]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCPostUpdateCustomDocumentInformedConsents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCPostUpdateCustomDocumentInformedConsents]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCPostUpdateCustomDocumentInformedConsents]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[csp_SCPostUpdateCustomDocumentInformedConsents]
    (
      @ScreenKeyId INT ,
      @StaffId INT ,
      @CurrentUser VARCHAR(30) ,
      @CustomParameters XML                                               
    )
AS /******************************************************************************                                
**  File:                                 
**  Name: csp_SCPostUpdateCustomDocumentInformedConsents                                
**  Desc:                                 
**  This template can be customized:                                
**  Return values:                                
**  Called by:                                   
**  Parameters: @ScreenKeyId , @StaffId , @CurrentUser,  @CustomParameters                                                            
*******************************************************************************                                
**  Change Histor6y                                
*******************************************************************************                                
**  Date:      Author:     Description:                                
**  ---------  --------    -------------------------------------------                                
**  12 Jan 2012  Amit Kumar Srivastava    Created Procedure to call After signed documents  
**	1/8/2015	DBlankenberger		Updated to only alter Effective date to match client's electronic signature                      
*******************************************************************************/                              
    BEGIN                             
                        
        BEGIN TRY 
            DECLARE @InProgressDocumentVersionId INT  
            DECLARE @CurrentVersionstatus INT
            DECLARE @CurrentEffectiveDate DATETIME
            DECLARE @NewEffectiveDate DATETIME

            SELECT  @InProgressDocumentVersionId = InProgressDocumentVersionId ,
                    @CurrentVersionstatus = currentversionstatus ,
                    @CurrentEffectiveDate = EffectiveDate
            FROM    Documents
            WHERE   documentId = @ScreenKeyId

            SET @NewEffectiveDate = ( SELECT DISTINCT
                                                CAST (signatureDate AS DATE)
                                      FROM      DocumentSignatures
                                      WHERE     DocumentId = @ScreenKeyId
                                                AND ISNULL(isclient, 'N') = 'Y'
                                                AND ISNULL(DeclinedSignature, 'N') = 'N'
                                                AND ISNULL(ClientSignedPaper, 'Y') = 'N'
                                                AND ISNULL(RecordDeleted, 'N') = 'N'
                                    )

            IF ( @CurrentVersionstatus = 22 )
                AND @NewEffectiveDate IS NOT NULL
                AND @NewEffectiveDate <> @CurrentEffectiveDate 
                BEGIN
                    UPDATE  documents
                    SET     EffectiveDate = @NewEffectiveDate
                    WHERE   documentid = @ScreenKeyId
                END
        END TRY                                                                                                                             
        BEGIN CATCH                                                
            DECLARE @Error VARCHAR(8000)                                                                                           
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCPostUpdateCustomDocumentInformedConsents') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                                        
            RAISERROR                                                                                               
 (                                               
  @Error, -- Message text.                                                               
  16, -- Severity.                                                      
  1 -- State.                                                   
 );                                                                                   
        END CATCH                          
                          
    END


GO


