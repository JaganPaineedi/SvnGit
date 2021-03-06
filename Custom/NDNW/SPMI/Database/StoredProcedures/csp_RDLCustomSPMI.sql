IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomSPMI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomSPMI]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[csp_RDLCustomSPMI]                                          
(                                                            
 @DocumentVersionId as int                                                            
)                                            
AS          
                                                       
                                                          
/*********************************************************************                        
-- Stored Procedure: dbo.[csp_RDLCustomSPMI]                                                           
                          
-- Creation Date:    05.05.2015                       
--                         
-- Purpose:  Return Tables for CustomSPMI and fill the type Dataset                        
--                        
-- Create:                        
--   Date       Author    Purpose                        
--  03.FEB.2015  Anto     To fetch CustomSPMI               
--        
*********************************************************************/     
BEGIN                                                      
  BEGIN TRY  
	    DECLARE @OrganizationName VARCHAR(250)		
		DECLARE @ClientID INT
		
		SELECT TOP 1 @OrganizationName = OrganizationName
		FROM SystemConfigurations
		
		SELECT 
			@ClientID = Documents.ClientID		
		FROM Documents
		JOIN Staff S ON Documents.AuthorId = S.StaffId
		JOIN Clients C ON Documents.ClientId = C.ClientId
			AND isnull(C.RecordDeleted, 'N') <> 'Y'
		JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
		INNER JOIN DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId      
			AND ISNULL(DocumentCodes.RecordDeleted,'N')='N' 
		LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
		WHERE dv.DocumentVersionId = @DocumentVersionId
			AND isnull(Documents.RecordDeleted, 'N') = 'N'

		SELECT DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		Schizophrenia,
		MajorDepression,
		Anxiety,
		Personality,
		Individual,
		@OrganizationName AS OrganizationName,
		@ClientID AS ClientID
		

		FROM CustomDocumentSPMIs Where DocumentVersionId = @DocumentVersionId AND ISNULL (RecordDeleted,'N') = 'N'		  
	END TRY	                                             
   
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomSPMI')                                                           
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                            
   + '*****' + Convert(varchar,ERROR_STATE())                                                          
  RAISERROR                                                           
  (                                                          
   @Error, -- Message text.                                                          
   16, -- Severity.                                                          
   1 -- State.                                                          
  )           
 END CATCH                                                
End  