/****** Object:  StoredProcedure [dbo].[ssp_SCGetMessageInterface]    Script Date: 01/05/2016 13:19:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetMessageInterface]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetMessageInterface]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetMessageInterface]    Script Date: 01/05/2016 13:19:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetMessageInterface] @HL7CPQueueMessageID INT
AS
/******************************************************************************                                          
**  File: [ssp_SCGetMessageInterface]                                 
**  Name: [ssp_SCGetMessageInterface]                  
**  Desc: Get Recordds to Detail Page      
**  Return values:                                 
**  Called by:                                           
**  Parameters:                                            
*******************************************************************************                                          
**  Change History                                          
*******************************************************************************                                          
**  Date:       Author:			Description:                   
	11-30-2018	Chethan N		What : Retrieving HL7CPEventLogs details.
								Why : Engineering Improvement Initiatives- NBL(I) task #745.   
	03/26/2019  MD				What: Commented the unwanted Left Join condition in first select query and moved the record deleted check from WHERE clause to ON clause for Left Join condition
								Why: Journey-Support Go Live #355.2							                 
*******************************************************************************/ 
BEGIN
	BEGIN TRY
		SELECT TOP 1 HCPQM.[HL7CPQueueMessageID]
			,HCPQM.[CreatedBy]
			,HCPQM.[CreatedDate]
			,HCPQM.[ModifiedBy]
			,HCPQM.[ModifiedDate]
			,HCPQM.[RecordDeleted]
			,HCPQM.[DeletedDate]
			,HCPQM.[DeletedBy]
			,HCPQM.[CPVendorConnectorID]
			,HCPQM.[Direction]
			,HCPQM.[MessageRaw]
			,HCPQM.[MessageXML]
			,HCPQM.[MessageProcessingState]
			,HCPQM.[MessageStatus]
			,HCPQM.[ErrorDescription]
			,HCPQM.[MessageControlID]
			,HCPQM.[ClientId]
			,HCPQM.[MessageType]
			,HCPQM.[EventType]
		FROM HL7CPQueueMessages HCPQM
		--LEFT JOIN HL7CPQueueMessageLinks HCPQML ON HCPQM.HL7CPQueueMessageID = HCPQML.HL7CPQueueMessageID
		WHERE HCPQM.HL7CPQueueMessageID = @HL7CPQueueMessageID
			AND ISNULL(HCPQM.RecordDeleted, 'N') = 'N'
			--AND ISNULL(HCPQML.RecordDeleted, 'N') = 'N'

		SELECT TOP 1 HCPQM.[ClientId]
			,(C.[Lastname] + ', ' + C.[FirstName] + ' ' + C.[Middlename]) AS ClientName
			,CONVERT(NVARCHAR(10), C.[DOB], 101) AS DOB
			,C.SSN AS SSN
			,CASE C.[Sex]
				WHEN 'M'
					THEN 'Male'
				WHEN 'F'
					THEN 'Female'
				END AS Sex
			,(CA.[Address] + ' ' + CA.[City] + ' ' + CA.[State] + ' ' + CA.[Zip]) AS Address
		FROM HL7CPQueueMessages HCPQM
		INNER JOIN Clients C ON HCPQM.ClientId = C.ClientId
		LEFT JOIN ClientAddresses CA ON CA.ClientId = C.ClientId
		WHERE HCPQM.HL7CPQueueMessageID = @HL7CPQueueMessageID
			AND ISNULL(HCPQM.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND Active = 'Y'

		SELECT TOP 1 CO.[ClientOrderId]
			,O.[Ordername]
			,O.[LabId]
			,HDT.[OrderCode]
			,HDT.[TemplateName]
		FROM HL7CPQueueMessages HCPQM
		LEFT JOIN HL7CPQueueMessageLinks HCPQML ON HCPQM.HL7CPQueueMessageID = HCPQML.HL7CPQueueMessageID
			 AND ISNULL(HCPQML.RecordDeleted, 'N') = 'N'
		LEFT JOIN ClientOrders CO ON Co.ClientOrderId = HCPQML.EntityId
		LEFT JOIN Orders O ON O.OrderId = CO.OrderId
		LEFT JOIN HealthDataTemplates HDT ON O.LabId = HDT.HealthDataTemplateId
		WHERE HCPQM.HL7CPQueueMessageID = @HL7CPQueueMessageID
			AND ISNULL(HCPQM.RecordDeleted, 'N') = 'N'
			

		SELECT HEL.[HL7CPEventLogId]
				,CAST(HEL.[HL7CPQueueMessageId] AS VARCHAR(MAX)) AS HL7CPQueueMessageId
			,HEL.ErrorMessage
			,HEL.[VerboseInfo]
			,CASE WHEN HEL.[VerboseInfo] LIKE '%MSH%' 
			THEN '<img title="Details"  src="../App_Themes/Includes/Images/SearchIcon.png" id="span_VerboseInfo_'+ CAST(HL7CPEventLogId AS VARCHAR(99)) + '" VerboseMessage = "'+ HEL.[VerboseInfo] +'"  onclick="ShowVerboseMessage(this);" style="Cursor: Pointer;" />'
			ELSE '' 
			END AS [ViewVerboseInfo]
			,HEL.[ErrorType]
			,HEL.RecordDeleted
			,GC.CodeName AS LogType
		FROM HL7CPEventLogs HEL
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = HEL.ErrorType
		WHERE HEL.HL7CPQueueMessageID = @HL7CPQueueMessageID
			AND ISNULL(HEL.RecordDeleted, 'N') = 'N'
			ORDER BY HEL.[HL7CPEventLogId]
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetMessageInterface') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


