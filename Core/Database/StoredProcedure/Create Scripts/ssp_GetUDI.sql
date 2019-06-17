/****** Object:  StoredProcedure [dbo].[ssp_GetUDI]    Script Date: 09/27/2017 15:07:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetUDI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetUDI]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetUDI]    Script Date: 09/27/2017 15:07:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetUDI]  @ClientId INT = null
, @Type VARCHAR(10)  =null
, @DocumentVersionId INT =null
, @FromDate DATETIME =null
, @ToDate DATETIME =null
, @JsonResult VARCHAR(MAX)=null OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves Unique Device Identifier details
-- Task:   MUS3 - Task#30 Application Access - Patient Selection (G7)      
/*      
 Author			Modified Date			Reason     
*/
-- =============================================      
BEGIN
	BEGIN TRY
		IF @ClientId IS NOT NULL
		BEGIN
			IF @Type = 'Inpatient'
				BEGIN
					--InPatient
					SELECT @JsonResult = dbo.smsf_FlattenedJSON((
						SELECT DISTINCT c.ClientId
						,'' AS UdiDeviceIdentifier
						,'' AS UdiName
						,'' AS UdiJurisdiction
						,'' AS UdiCarrierHRF
						,'' AS UdiArrierAIDC
						,'' AS UdiIssuer
						,'' AS UdiEntryType
						,dbo.ssf_GetGlobalCodeNameById(ID.Active)  AS [Status]
						,'' AS [Type]
						,ID.LotOrBatchNumber AS LotNumber
						,ID.CompanyName AS Manufacturer
						,ID.ManufacturingDate AS ManufactureDate
						,ID.ExpirationDate AS ExpirationDate
						,ID.VersionOrModel AS Model
						,ID.VersionOrModel AS [Version]
						,C.LastName+' '+C.FirstName AS Patient
						,'' AS [Owner]
						--,'' AS Contact
						,'' AS Location
						,'' AS Url
						--,ID.Descrpition AS Note
						,'' AS [Safety]
					FROM Clients c
					JOIN ImplantableDevices ID ON ID.ClientId=C.ClientId
					LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))
					LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
					LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))	
					--LEFT JOIN Documents d ON d.ClientId = c.ClientId
					WHERE  (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
					--AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)
					AND c.Active = 'Y' 
					AND ISNULL(c.RecordDeleted,'N')='N'	
					FOR XML path
					,ROOT
					))	
				END
			ELSE
				BEGIN
					--OutPatient
					SELECT @JsonResult = dbo.smsf_FlattenedJSON((
						SELECT DISTINCT c.ClientId
						,'' AS UdiDeviceIdentifier
						,'' AS UdiName
						,'' AS UdiJurisdiction
						,'' AS UdiCarrierHRF
						,'' AS UdiArrierAIDC
						,'' AS UdiIssuer
						,'' AS UdiEntryType
						,dbo.ssf_GetGlobalCodeNameById(ID.Active)  AS [Status]
						,'' AS [Type]
						,ID.LotOrBatchNumber AS LotNumber
						,ID.CompanyName AS Manufacturer
						,ID.ManufacturingDate AS ManufactureDate
						,ID.ExpirationDate AS ExpirationDate
						,ID.VersionOrModel AS Model
						,ID.VersionOrModel AS [Version]
						,C.LastName+' '+C.FirstName AS Patient
						,'' AS [Owner]
						--,'' AS Contact
						,'' AS Location
						,'' AS Url
						--,ID.Descrpition AS Note
						,'' AS [Safety]
					FROM Clients c
					JOIN ImplantableDevices ID ON ID.ClientId=C.ClientId
					LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))
					WHERE  (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
					AND c.Active = 'Y' 
					AND ISNULL(c.RecordDeleted,'N')='N'	
					 FOR XML path
					,ROOT
					))	
			END					
		END
  
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetUDI') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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