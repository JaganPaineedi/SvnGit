IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitAdminDocumentAssignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitAdminDocumentAssignment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InitAdminDocumentAssignment] 
 (
	 @ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
-- =============================================    
-- Author      : Arjun K R
-- Date        : 06/Oct/2016  
-- Purpose     : Initializing SP Created. Task #447 Aspen Pointe Customizations	
-- Modified
--11 DEC 2018	  Alok Kumar		Added a new fields 'PacketType'.	Ref#618 EII.
-- =============================================   
BEGIN
	BEGIN TRY
		SELECT 'DocumentAssignments' AS TableName 
		  ,-1 as [DocumentAssignmentId]
		  ,DA.[CreatedBy]
		  ,DA.[CreatedDate]
		  ,DA.[ModifiedBy]
		  ,DA.[ModifiedDate]
		  ,DA.[RecordDeleted]
		  ,DA.[DeletedBy]
		  ,DA.[DeletedDate]
		  ,DA.[PacketName]
		  ,'Y' AS [Active]
		  ,DA.[PacketType]
	  FROM systemconfigurations s
	  LEFT OUTER JOIN DocumentAssignments DA on  s.Databaseversion = -1
	  
	  
	-- SELECT 'DocumentAssignmentDocuments' AS TableName
	--  ,-1 AS [DocumentAssignmentDocumentId]
 --     ,DAD.[CreatedBy]
 --     ,DAD.[CreatedDate]
 --     ,DAD.[ModifiedBy]
 --     ,DAD.[ModifiedDate]
 --     ,DAD.[RecordDeleted]
 --     ,DAD.[DeletedBy]
 --     ,DAD.[DeletedDate]
 --     ,DAD.[DocumentAssignmentId]
 --     ,DAD.[DocumentCodeId]
 --   FROM systemconfigurations s
	--LEFT OUTER JOIN [DocumentAssignmentDocuments] DAD on  s.Databaseversion = -1
	  
	  
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitAdminDocumentAssignment') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END

