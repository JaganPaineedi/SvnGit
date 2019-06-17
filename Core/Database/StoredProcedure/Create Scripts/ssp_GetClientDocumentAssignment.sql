
/****** Object:  StoredProcedure [dbo].[ssp_GetClientDocumentAssignment]    Script Date: 03/22/2017 17:47:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientDocumentAssignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientDocumentAssignment]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientDocumentAssignment]    Script Date: 03/22/2017 17:47:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetClientDocumentAssignment] --23432
 (
	@ClientId INT	 
 )
AS
-- =============================================    
-- Author      : Arjun K R
-- Date        : 06/Oct/2016  
-- Purpose     : Get Client Document Assignment.Task #447 Aspen Pointe Customizations	
-- 22-Mar-2017  Pradeep Y  Changes has been done as per the requirement of task #447.11 AspenPoint-Customizations  
-- 19-Apr-2017  Gautam     What: Added record deleted check for few table.task #447.11 AspenPoint-Customizations
-- =============================================   
BEGIN
	BEGIN TRY
	SELECT CDAD.[ClientDocumentAssignmentId]
		  ,CDAD.[CreatedBy]
		  ,CDAD.[CreatedDate]
		  ,CDAD.[ModifiedBy]
		  ,CDAD.[ModifiedDate]
		  ,CDAD.[RecordDeleted]
		  ,CDAD.[DeletedBy]
		  ,CDAD.[DeletedDate]
		  ,CDAD.[ClientId]
		  ,CDAD.[DocumentAssignmentId]
		  ,CDAD.[DocumentCodeId]
		  ,CDAD.[DocumentAssignmentDate]
		  ,CDAD.[PriorityOrder]		  
		  ,G.CodeName AS DocumentStatus 
		   ,DA.PacketName
		  ,DC.DocumentName as Documents
      FROM [ClientDocumentAssignments] CDAD 
      INNER JOIN ClientDocumentAssignmentDocuments CD ON CD.ClientDocumentAssignmentId  = CDAD.ClientDocumentAssignmentId
		AND ISNULL(CD.RecordDeleted,'N')='N'  -- 28-Mar-2017  Gautam
      INNER JOIN Documents D on D.DocumentId	 = CD.DocumentId
			AND ISNULL(D.RecordDeleted,'N')='N'  -- 28-Mar-2017  Gautam
      INNER JOIN DocumentAssignments DA ON DA.DocumentAssignmentId = CDAD.DocumentAssignmentId
			AND ISNULL(DA.RecordDeleted,'N')='N'  -- 28-Mar-2017  Gautam
      INNER JOIN DocumentCodes DC ON DC.DocumentCodeId=CDAD.DocumentCodeId
      INNER JOIN GlobalCodes G ON G.GlobalCodeId = D.Status
      WHERE ISNULL(CDAD.RecordDeleted,'N')='N'
      AND CDAD.ClientId=@ClientId
	  order by CDAD.[DocumentAssignmentDate] desc
	       
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientDocumentAssignment') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END



GO


