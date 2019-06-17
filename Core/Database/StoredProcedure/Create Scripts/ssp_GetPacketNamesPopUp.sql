/****** Object:  StoredProcedure [dbo].[ssp_GetPacketNamesPopUp]    Script Date: 04/20/2017 15:00:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPacketNamesPopUp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPacketNamesPopUp]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetPacketNamesPopUp]    Script Date: 04/20/2017 15:00:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetPacketNamesPopUp] 
(    @DocumentAssignmentId INT,
     @ClientId INT
)
AS
-- =============================================    
-- Author      : Arjun K R
-- Date        : 06/Oct/2016  
-- Purpose     : To Get Packet Names.Task #447 Aspen Pointe Customizations	
-- 20-Apr-2017  Shankha     What: Added condition to not include Documents if Document already assigned is in ToDo status.task #447.11 AspenPoint-Customizations
-- =============================================   
BEGIN
	BEGIN TRY
		SELECT DA.[DocumentAssignmentId]
		  ,DA.[CreatedBy]
		  ,DA.[CreatedDate]  
		  ,DA.[ModifiedBy]
		  ,DA.[ModifiedDate]
		  ,ISNULL(DA.[RecordDeleted],'N') as [RecordDeleted]
		  ,DA.[DeletedBy]
		  ,DA.[DeletedDate]
		  ,DA.[PacketName]
		  ,DA.[Active]
		  ,DC.DocumentName
		  ,DC.DocumentCodeId
		 --,dbo.GetGlobalCodeName((SELECT top 1 [status] FROM Documents D WHERE D.DocumentCodeId=DC.DocumentCodeId AND D.ClientId=@ClientId order by DocumentId desc )) as progress
		 ,'To Do' AS progress
		 into #results
	  FROM DocumentAssignments DA
	  INNER JOIN DocumentAssignmentDocuments DAD ON DAD.DocumentAssignmentId=DA.DocumentAssignmentId
	  INNER JOIN DocumentCodes DC ON DC.DocumentCodeId=DAD.DocumentCodeId
	  WHERE ISNULL(DA.RecordDeleted,'N')='N' AND ISNULL(DAD.RecordDeleted,'N')='N'
	  AND DA.DocumentAssignmentId=@DocumentAssignmentId
	 -- AND DA.Active='Y'
	 AND NOT EXISTS (
		SELECT 1
		FROM Documents D
		JOIN ClientDocumentAssignmentDocuments s ON d.DocumentId = s.DocumentId
		JOIN ClientDocumentAssignments r ON r.ClientDocumentAssignmentId = s.ClientDocumentAssignmentId
		WHERE d.ClientId = @ClientId
			AND d.STATUS = 20 and D.DocumentCodeId = DC.DocumentCodeId
			AND ISNULL(D.RecordDeleted , 'N')  = 'N'
			AND ISNULL(r.RecordDeleted , 'N')  = 'N'
			AND ISNULL(s.RecordDeleted , 'N')  = 'N'
		)
	 
	-- UPDATE R
	-- SET progress='To Do'
	-- FROM #results R
	--WHERE  progress IS NULL
		  
	SELECT DocumentAssignmentId
	      ,[CreatedBy]
		  ,CreatedDate
		  ,[ModifiedBy]
		  ,[ModifiedDate]
		  ,[RecordDeleted]
		  ,[DeletedBy]
		  ,[DeletedDate]
		  ,[PacketName]
		  ,[Active]
		  ,DocumentName 
		  ,DocumentCodeId
		  ,progress
		  ,Convert(varchar(10),GETDATE(),101) as DocumentAssignmentDate
		  FROM 	#results   
	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPacketNamesPopUp') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


