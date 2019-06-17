/****** Object:  StoredProcedure [dbo].[csp_RDLHarborConsentElectronicSignature]    Script Date: 10/23/2013 9:20:33 AM ******/
IF EXISTS ( SELECT	1
			FROM	INFORMATION_SCHEMA.ROUTINES
			WHERE	SPECIFIC_SCHEMA = 'dbo'
					AND SPECIFIC_NAME = 'csp_RDLHarborConsentElectronicSignature' ) 
	DROP PROCEDURE [dbo].[csp_RDLHarborConsentElectronicSignature]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLHarborConsentElectronicSignature]    Script Date: 10/23/2013 9:20:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLHarborConsentElectronicSignature]
	(
	  @DocumentVersionId INT                  
	)         
/*********************************************************************/      
/* Procedure: csp_RDLHarborConsentElectronicSignature            */      
/*                                                                   */      
/* Purpose: retrieve  data for rendering the RDL Report for Harbor Consent */      
/*                  */      
/*                                                                   */      
/* Parameters: @DocumentVersionId int                           */      
/*                                                                   */      
/*                                                                   */      
/* Returns/Results: Returns fields required for generating RDL Report (Electronic Signature) */      
/*                                                                   */      
/* Created By: Loveena                                       */      
/*                                                                   */      
/* Created Date: 25-May-2009                                          */      
/*                                                                   */      
/* Revision History:                                                 */      
/* Date : 13/April/2018         Anto		   What : Modified the logic to display the correct staff name when they do only patient consent sign(not staff sign) with different staff logged in.  
											   Why  : MFS - Support Go Live #370.    */      
/*********************************************************************/  
AS 
	BEGIN       
      
		BEGIN TRY                 
                                               
			DECLARE	@ClientId AS INT  			
			SELECT	@ClientId = DocumentSignatures.ClientId				  
			FROM	DocumentSignatures
					INNER JOIN Documents ON Documents.DocumentId = DocumentSignatures.DocumentId
					INNER JOIN DocumentVersions ON DocumentVersions.DocumentId = Documents.DocumentId
			WHERE	DocumentVersions.DocumentVersionId = @DocumentVersionId
					AND ISNULL(Documents.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(DocumentVersions.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(DocumentSignatures.RecordDeleted, 'N') <> 'Y'     
                            
			SELECT	Staff.LastName + ',' + Staff.FirstName AS StaffName
				  , Clients.LastName + ',' + Clients.FirstName AS ClientName
				  , CASE DocumentSignatures.IsClient
					  WHEN 'N'
					  THEN ( SELECT	SignerName + ' (' + CodeName + ')'
									+ ' on '
									+ CONVERT(VARCHAR, DocumentSignatures.CreatedDate, 101)
							 FROM	GlobalCodes
							 WHERE	Category = 'CONSENTRELATIONSHIP'
									AND ISNULL(GlobalCodes.RecordDeleted, 'N') <> 'Y'
									AND GlobalCodeId = RelationToClient
									AND DocumentSignatures.ClientId = @ClientId
									AND ISNULL(DocumentSignatures.RecordDeleted,
											   'N') <> 'Y'
									AND ISNULL(GlobalCodes.RecordDeleted, 'N') <> 'Y'
						   )
					  WHEN 'Y'
					  THEN ( SELECT	Clients.LastName + ',' + Clients.FirstName
									+ ' (Patient)' + ' on '
									+ CONVERT(VARCHAR, DocumentSignatures.CreatedDate, 101)
							 FROM	Clients
							 WHERE	ClientId = @ClientId
									AND ISNULL(Clients.RecordDeleted, 'N') <> 'Y'
						   )
					  ELSE ( SELECT	Staff.LastName + ',' + Staff.FirstName
									+ ' (Medical Staff)' + ' on '
									+ CONVERT(VARCHAR, DocumentSignatures.CreatedDate, 101)
							 FROM	Staff
							 WHERE	StaffId = DocumentSignatures.StaffId
									AND ISNULL(Staff.RecordDeleted, 'N') <> 'Y'
						   )
					END AS SignedBy
				  , PhysicalSignature
			FROM	DocumentSignatures
					INNER JOIN Staff ON Staff.StaffId = DocumentSignatures.StaffId
					LEFT OUTER JOIN Clients ON Clients.ClientId = DocumentSignatures.ClientId
					INNER JOIN Documents ON Documents.DocumentId = DocumentSignatures.DocumentId
					INNER JOIN DocumentVersions ON DocumentVersions.DocumentId = Documents.DocumentId
			WHERE	DocumentVersions.DocumentVersionId = @DocumentVersionId
					AND ISNULL(Documents.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(DocumentVersions.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(DocumentSignatures.RecordDeleted, 'N') <> 'Y'
			ORDER BY SignatureId ASC  

		END TRY      
       
		BEGIN CATCH      
			DECLARE	@Error VARCHAR(8000)                             
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'csp_RDLHarborConsentElectronicSignature') + '*****'
				+ CONVERT(VARCHAR, ERROR_LINE()) + '*****'
				+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
				+ CONVERT(VARCHAR, ERROR_STATE())                                                          
			RAISERROR                                                           
  (                                                          
   @Error, -- Message text.                                                      
   16, -- Severity.                                                          
   1 -- State.                                                          
  );                  
		END CATCH      
    
	END

GO


