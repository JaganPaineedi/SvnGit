IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAdminDocumentAssignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAdminDocumentAssignment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetAdminDocumentAssignment] 
 (
	@DocumentAssignmentId INT	 
 )
AS
-- =============================================    
-- Author      : Arjun K R
-- Date        : 06/Oct/2016  
-- Purpose     : Get Admin Document Assignment. Task #447 Aspen Pointe Customizations	
-- Modified
--11 DEC 2018	  Alok Kumar		Added a new fields 'PacketType'.	Ref#618 EII.
-- =============================================   
BEGIN
	BEGIN TRY
		SELECT DA.[DocumentAssignmentId]
		  ,DA.[CreatedBy]
		  ,DA.[CreatedDate]
		  ,DA.[ModifiedBy]
		  ,DA.[ModifiedDate]
		  ,DA.[RecordDeleted]
		  ,DA.[DeletedBy]
		  ,DA.[DeletedDate]
		  ,DA.[PacketName]
		  ,DA.[Active]
		  ,DA.[PacketType]
	  FROM DocumentAssignments DA
	  WHERE ISNULL(DA.RecordDeleted,'N')='N'
	  AND DA.DocumentAssignmentId=@DocumentAssignmentId
	  
	  SELECT DAD.[DocumentAssignmentDocumentId]
      ,DAD.[CreatedBy]
      ,DAD.[CreatedDate]
      ,DAD.[ModifiedBy]
      ,DAD.[ModifiedDate]
      ,DAD.[RecordDeleted]
      ,DAD.[DeletedBy]
      ,DAD.[DeletedDate]
      ,DAD.[DocumentAssignmentId]
      ,DAD.[DocumentCodeId]
      ,DC.DocumentName as DocumentName
      FROM [DocumentAssignmentDocuments] DAD
      INNER JOIN DocumentAssignments DA ON DA.DocumentAssignmentId=DAD.DocumentAssignmentId
      INNER JOIN DocumentCodes DC ON DC.DocumentCodeId=DAD.DocumentCodeId
      WHERE ISNULL(DAD.RecordDeleted,'N')='N'
      AND ISNULL(DA.RecordDeleted,'N')='N'
      AND DA.DocumentAssignmentId=@DocumentAssignmentId
      
      
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetAdminDocumentAssignment') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END

