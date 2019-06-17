/****** Object:  StoredProcedure [dbo].[smsp_GetAddress]    Script Date: 09/27/2017 15:23:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetAddress]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetAddress]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetAddress]    Script Date: 09/27/2017 15:23:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetAddress]  @ClientId INT
, @Text VARCHAR(100)
, @Type VARCHAR(10)
, @FromDate DATETIME
, @ToDate DATETIME
, @JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Sept 27, 2017      
-- Description: Retrieves Patient Address details
-- Task:   MUS3 - Task#30 Application Access - Patient Selection (G7)        
/*      
 Author			Modified Date			Reason     
*/
-- =============================================      
BEGIN
	BEGIN TRY
	
	SET NOCOUNT ON
		IF @ClientId IS NOT NULL
			BEGIN
				IF @Type = 'Inpatient'
					BEGIN
					IF @Text = 'DemographicPatientAddress'
						BEGIN
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									--,'Address' AS ResourceType
									,gc.CodeName as [Use]	--home | work | temp | old | mobile - purpose of this contact point
									,'' as [Type]			--postal | physical | both
									,ca.Address as [Text]   --Text representation of the address
									,'' as Line				--Street name, number, direction & P.O. Box etc.
									,ca.City
									,'' as District
									,ca.State
									,ca.Zip as PostalCode
									,'' as Country			
									,ca.CreatedDate AS Start	--dbo.smsf_GetPatientPeriod(@ClientId) AS Period
									,ca.DeletedDate AS [End]
								FROM Clients c 
									JOIN ClientAddresses ca on ca.ClientId = c.ClientId
									LEFT JOIN GlobalCodes gc on gc.GlobalCodeId = ca.AddressType		
									WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
									AND c.Active = 'Y'
									AND ISNULL(c.RecordDeleted,'N')='N'
									FOR XML path
									,ROOT
									))
							END
						ELSE IF @Text = 'DemographicPatientContactPersonAddress'
						BEGIN
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
							SELECT DISTINCT c.ClientId
								--,'Address' AS ResourceType
								,gc.CodeName as [Use]	--home | work | temp | old | mobile - purpose of this contact point
								,'' as [Type]			--postal | physical | both
								,ca.Address as [Text]   --Text representation of the address
								,'' as Line				--Street name, number, direction & P.O. Box etc.
								,ca.City
								,'' as District
								,ca.State
								,ca.Zip as PostalCode
								,'' as Country			
								,cc.CreatedDate AS Start	--dbo.smsf_GetPatientPeriod(@ClientId) AS Period
								,cc.DeletedDate AS [End]
							FROM Clients c 
								JOIN ClientContacts cc on cc.ClientId = c.ClientId
								JOIN ClientContactAddresses ca on ca.ClientContactId = cc.ClientContactId
								LEFT JOIN GlobalCodes gc on gc.GlobalCodeId = ca.AddressType		
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
								AND c.Active = 'Y'
								AND ISNULL(c.RecordDeleted,'N')='N'
							FOR XML path
							,ROOT
							))
						END
					END
					ELSE IF @Type = 'Outpatient'
						BEGIN
							IF @Text = 'DemographicPatientAddress'
							BEGIN
								SELECT @JsonResult = dbo.smsf_FlattenedJSON((
									SELECT DISTINCT c.ClientId
										--,'Address' AS ResourceType
										,gc.CodeName as [Use]	--home | work | temp | old | mobile - purpose of this contact point
										,'' as [Type]			--postal | physical | both
										,ca.Address as [Text]   --Text representation of the address
										,'' as Line				--Street name, number, direction & P.O. Box etc.
										,ca.City
										,'' as District
										,ca.State
										,ca.Zip as PostalCode
										,'' as Country			
										,ca.CreatedDate AS Start	--dbo.smsf_GetPatientPeriod(@ClientId) AS Period
										,ca.DeletedDate AS [End]
									FROM Clients c 
										JOIN ClientAddresses ca on ca.ClientId = c.ClientId
										LEFT JOIN GlobalCodes gc on gc.GlobalCodeId = ca.AddressType		
										WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
										AND c.Active = 'Y'
										AND ISNULL(c.RecordDeleted,'N')='N'
										FOR XML path
										,ROOT
										))
							END
							ELSE IF @Text = 'DemographicPatientContactPersonAddress'
								BEGIN
									SELECT @JsonResult = dbo.smsf_FlattenedJSON((
									SELECT DISTINCT c.ClientId
										--,'Address' AS ResourceType
										,gc.CodeName as [Use]	--home | work | temp | old | mobile - purpose of this contact point
										,'' as [Type]			--postal | physical | both
										,ca.Address as [Text]   --Text representation of the address
										,'' as Line				--Street name, number, direction & P.O. Box etc.
										,ca.City
										,'' as District
										,ca.State
										,ca.Zip as PostalCode
										,'' as Country			
										,cc.CreatedDate AS Start	--dbo.smsf_GetPatientPeriod(@ClientId) AS Period
										,cc.DeletedDate AS [End]
									FROM Clients c 
										JOIN ClientContacts cc on cc.ClientId = c.ClientId
										JOIN ClientContactAddresses ca on ca.ClientContactId = cc.ClientContactId
										LEFT JOIN GlobalCodes gc on gc.GlobalCodeId = ca.AddressType		
										WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
										AND c.Active = 'Y'
										AND ISNULL(c.RecordDeleted,'N')='N'
									FOR XML path
									,ROOT
									))
								END
						END
				END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetAddress') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


