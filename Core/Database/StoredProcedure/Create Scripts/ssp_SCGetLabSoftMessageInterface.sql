/****** Object:  StoredProcedure [dbo].[ssp_SCGetLabSoftMessageInterface]    Script Date: 03/02/2016 18:01:25 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetLabSoftMessageInterface]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetLabSoftMessageInterface]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetLabSoftMessageInterface]    Script Date: 03/02/2016 18:01:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetLabSoftMessageInterface] @LabSoftMessageId INT
AS
/*
-- ================================================================  
-- Stored Procedure: [ssp_SCGetLabSoftMessageInterface]  
-- Create Date : Sep 09 2015 
-- Purpose : Retuns LabSoft Detail page screen data  
-- Created By : Pradeep  
	exec [ssp_SCGetLabSoftMessageInterface] 1
-- ================================================================  
-- History --  
05 July 2016		PradeepA	Added new column LaboratoryName for Order Information section.
-- ================================================================  
*/
BEGIN
	BEGIN TRY
		SELECT TOP 1 LS.[LabSoftMessageId]
			,LS.[CreatedBy]
			,LS.[CreatedDate]
			,LS.[ModifiedBy]
			,LS.[ModifiedDate]
			,LS.[RecordDeleted]
			,LS.[DeletedDate]
			,LS.[DeletedBy]
			,ls.[ClientOrderId]
			,LS.[TransactionId]
			,LS.[AccessionId]
			,LS.[CustomerId]
			,LS.[MessageId]
			,LS.[RequestMessage]
			,LS.[ResultMessage]
			,LS.[MessageProcessingState]
			,LS.[MessageStatus]
			,LS.[ErrorDescription]
			,LS.[ReportType]
		FROM LabSoftMessages LS
		WHERE LS.LabSoftMessageId = @LabSoftMessageId
			AND ISNULL(LS.RecordDeleted, 'N') = 'N'

		SELECT TOP 1 CO.[ClientId]
			,(ISNULL(C.[Lastname], '') + ', ' + ISNULL(C.[FirstName], '') + ' ' + ISNULL(C.[Middlename], '')) AS ClientName
			,CONVERT(NVARCHAR(10), C.[DOB], 101) AS DOB
			,C.SSN AS SSN
			,CASE C.[Sex]
				WHEN 'M'
					THEN 'Male'
				WHEN 'F'
					THEN 'Female'
				END AS Sex
			,(CA.[Address] + ' ' + CA.[City] + ' ' + CA.[State] + ' ' + CA.[Zip]) AS Address
		FROM LabSoftMessages LSM
		INNER JOIN ClientOrders CO ON CO.ClientOrderId = LSM.ClientOrderId
		INNER JOIN Clients C ON CO.ClientId = C.ClientId
		LEFT JOIN ClientAddresses CA ON CA.ClientId = C.ClientId
		WHERE LSM.LabSoftMessageId = @LabSoftMessageId
			AND ISNULL(LSM.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND C.Active = 'Y'

		SELECT TOP 1 CO.[ClientOrderId]
			,O.[Ordername]
			,O.[LabId]
			,HDT.[OrderCode]
			,HDT.[TemplateName]
			,ISNULL(L.LaboratoryName,'') AS LaboratoryName
		FROM LabSoftMessages LSM
		INNER JOIN LabSoftMessageLinks LSML ON LSM.LabSoftMessageId = LSML.LabSoftMessageId
		INNER JOIN ClientOrders CO ON Co.ClientOrderId = LSML.EntityId
		INNER JOIN Orders O ON O.OrderId = CO.OrderId
		LEFT JOIN HealthDataTemplates HDT ON O.LabId = HDT.HealthDataTemplateId
		LEFT JOIN dbo.Laboratories L ON L.LaboratoryId = CO.LaboratoryId
		WHERE LSML.EntityType = 8747
			AND LSM.LabSoftMessageId = @LabSoftMessageId
			AND ISNULL(LSM.RecordDeleted, 'N') = 'N'
			AND ISNULL(LSML.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(HDT.RecordDeleted, 'N') = 'N'

		SELECT LSEL.[LabSoftEventLogId]
			,LSEL.[LabSoftMessageId]
			,('Type :' + Convert(VARCHAR(max), ISNULL(GC.CodeName, '')) + CHAR(13) + 'Details :' + Convert(VARCHAR(max), ISNULL(LSEL.[ErrorMessage], '')) + CHAR(13)) AS ErrorMessage
			,LSEL.[VerboseInfo]
			,LSEL.[ErrorType]
		FROM LabSoftEventLog LSEL
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = LSEL.ErrorType
		WHERE LSEL.LabSoftMessageId = @LabSoftMessageId
			AND ISNULL(LSEL.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetLabSoftMessageInterface') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


