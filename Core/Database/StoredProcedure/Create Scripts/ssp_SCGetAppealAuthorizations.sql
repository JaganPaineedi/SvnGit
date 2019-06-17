/****** Object:  StoredProcedure [dbo].[ssp_SCGetAppealAuthorizations]    Script Date: 07/17/2012 11:29:25 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAppealAuthorizations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetAppealAuthorizations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAppealAuthorizations]    Script Date: 07/17/2012 11:29:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetAppealAuthorizations] (
	@ClientId INT
	,@AppealId INT
	,@AuthType VARCHAR(1)
	)
AS
BEGIN
/********************************************************************                                                          
	Stored Procedure: dbo.[ssp_SCGetAppealAuthorizations]                                                                
                                                
	Copyright: 2006 Streamlin Healthcare Solutions                                                                                 
                                                
	Creation Date:  Dec/08/2010                                                                                                    
                                                     
	Author: Jitender Kumar Kamboj                                                                                                                                                        
	Purpose: Gets Data for Appeal Authorizations Details screen corressponding to ClientId                                                                
                                                                                                                           
	Input Parameters: @ClientId                                                       
                                                                                                                              
	Output Parameters:                                                                                          
                                                                                                                            
	Return:                                                            
                                                                                                                             
	Called By:                                                              
                                                                                                                                                                     
	Calls:                                                                                                                      
                                                                                                                             
	Data Modifications:                                                                                                         
                                                                                                                             
	Updates:                                                                                                                    
	Date					Author					Purpose                                                                                              
	17-June-2012			Davinderk				Commented the column Authorizations.[RowIdentifier] there is not column in the table Authorizations           
	25-Sep-2014				Prasan					Added 'COALESCE' statement which would consider (approved) TotalUnits  first & if that is null	then (requested) TotalUnitsRequested  is considered                             
	25-Sep-2014				Ponnin					What: If the BillingCode and TotalUnitsRequested is null then DisplayAppealAuthorizations column will not return the value to bind the External Authorization in Appealed Authorizations grid. Why : For task #2489 of Core Bugs 
********************************************************************/
	BEGIN TRY
		IF (@AuthType = 'A') --Regular Authorizations (default)
		BEGIN
			SELECT DISTINCT Authorizations.AuthorizationId
				,'A' AS AuthorizationType
				,AuthorizationDocuments.AuthorizationDocumentId
				,Clients.ClientId
				,CASE isnull(Providers.ProviderName, 'N')
					WHEN 'N'
						THEN ''
					ELSE Providers.ProviderName
					END + CASE isnull(Authorizations.SiteId, '0')
					WHEN '0'
						THEN Ag.AgencyName
					ELSE Sites.SiteName
					END AS ProviderName
				,AuthorizationCodes.DisplayAs AS AuthorizationCodeName
				,GlobalCodes.CodeName AS STATUS
				,CAST(CEILING(COALESCE(Authorizations.TotalUnits, Authorizations.TotalUnitsRequested)) AS VARCHAR) AS Units
				,Convert(VARCHAR(10), Authorizations.StartDateRequested, 101) AS StartDate
				,Convert(VARCHAR(10), Authorizations.EndDateRequested, 101) AS EndDate
				,Staff.LastName + ', ' + Staff.FirstName AS StaffName
				,Authorizations.[CreatedBy]
				,Authorizations.[CreatedDate]
				,Authorizations.[ModifiedBy]
				,Authorizations.[ModifiedDate]
				,Authorizations.[RecordDeleted]
				,Authorizations.[DeletedDate]
				,Authorizations.[DeletedBy]
				,'A ' + AuthorizationCodes.DisplayAs + ' ' + CAST(CEILING(COALESCE(Authorizations.TotalUnits, Authorizations.TotalUnitsRequested)) AS VARCHAR) + ' ' + 'Units' + ' ' + CASE 
					WHEN isnull(Authorizations.StartDateRequested, '') = ''
						THEN ''
					ELSE Convert(VARCHAR(10), isnull(Authorizations.StartDateRequested, ''), 101)
					END + ' ' + CASE 
					WHEN isnull(Authorizations.EndDateRequested, '') = ''
						THEN ''
					ELSE Convert(VARCHAR(10), isnull(Authorizations.EndDateRequested, ''), 101)
					END AS DisplayAppealAuthorizations
			FROM Agency AS Ag
				,ClientCoveragePlans
			INNER JOIN AuthorizationDocuments ON AuthorizationDocuments.ClientCoveragePlanId = ClientCoveragePlans.ClientCoveragePlanId
				AND IsNull(AuthorizationDocuments.RecordDeleted, 'N') = 'N'
				AND IsNull(ClientCoveragePlans.RecordDeleted, 'N') = 'N'
			INNER JOIN Authorizations ON Authorizations.AuthorizationDocumentId = AuthorizationDocuments.AuthorizationDocumentId
			INNER JOIN Clients ON ClientCoveragePlans.ClientId = Clients.ClientId
				AND IsNull(Clients.RecordDeleted, 'N') = 'N'
			INNER JOIN AuthorizationCodes ON Authorizations.AuthorizationCodeId = AuthorizationCodes.AuthorizationCodeId
				AND IsNull(AuthorizationCodes.RecordDeleted, 'N') = 'N'
			INNER JOIN CoveragePlans ON ClientCoveragePlans.CoveragePlanId = CoveragePlans.CoveragePlanId
				AND IsNull(CoveragePlans.RecordDeleted, 'N') = 'N'                                                 
			LEFT JOIN Providers ON Authorizations.ProviderId = Providers.ProviderId
				AND IsNull(Providers.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes ON Authorizations.STATUS = GlobalCodes.GlobalCodeId
				AND IsNull(GlobalCodes.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes gl ON gl.GlobalCodeId = AuthorizationCodes.UnitType
			LEFT JOIN Staff ON AuthorizationDocuments.StaffId = Staff.StaffId
				AND IsNull(Staff.RecordDeleted, 'N') = 'N'
			LEFT JOIN Sites ON Authorizations.SiteId = Sites.SiteId
				AND IsNull(Sites.RecordDeleted, 'N') = 'N'
			WHERE IsNull(Authorizations.RecordDeleted, 'N') = 'N'
				AND Clients.ClientId = @ClientId
				AND Authorizations.STATUS NOT IN (4243)
				AND Authorizations.AuthorizationId NOT IN (
					SELECT AuthorizationId
					FROM AppealAuthorizations
					WHERE IsNull(RecordDeleted, 'N') = 'N'
						AND AppealId <> @Appealid
					)
				AND Authorizations.EndDate > GETDATE()


		END 
		ELSE IF (@AuthType = 'C') --CM authorizations
		BEGIN

			SELECT	PA.ProviderAuthorizationId AS AuthorizationId
					,'C' AS AuthorizationType
					,PA.ProviderAuthorizationDocumentId AS AuthorizationDocumentId
					,PA.ClientId AS ClientId

					,ISNULL(P.ProviderName, '') + ' '
						+ CASE ISNULL(PA.SiteId, 0)
							WHEN 0
								THEN (SELECT TOP 1 AgencyName FROM Agency)
							ELSE
								Si.SiteName
							END AS ProviderName
					,BC.BillingCode AS AuthorizationCodeName
					,GC.CodeName AS Status
					,CAST(PA.TotalUnitsRequested AS VARCHAR) AS Units
					,CONVERT(VARCHAR(10), PA.StartDateRequested, 101) AS StartDate
					,CONVERT(VARCHAR(10), PA.EndDateRequested, 101) AS EndDate
					,St.LastName + ', ' + St.FirstName AS StaffName

					,PA.CreatedBy AS CreatedBy
					,PA.CreatedDate AS CreatedDate
					,PA.ModifiedBy AS ModifiedBy
					,PA.ModifiedDate AS ModifiedDate
					,PA.RecordDeleted AS RecordDeleted
					,PA.DeletedDate AS DeletedDate
					,PA.DeletedBy AS DeletedBy
					 ,'CM ' + ISNULL(BC.BillingCode, '') + ' ' + ISNULL(CAST(PA.TotalUnitsRequested AS VARCHAR), '') + ' Units ' 
					--,'CM ' + BC.BillingCode + ' ' + CAST(PA.TotalUnitsRequested AS VARCHAR) + ' Units ' 
						+ CASE 
							WHEN ISNULL(PA.StartDateRequested, '') = ''
								THEN ''
							ELSE CONVERT(VARCHAR(10), PA.StartDateRequested, 101)
						END + ' '
						+ CASE 
							WHEN ISNULL(PA.EndDateRequested, '') = ''
								THEN ''
							ELSE CONVERT(VARCHAR(10), PA.EndDateRequested, 101)
						END AS DisplayAppealAuthorizations
			FROM	ProviderAuthorizations PA
					INNER JOIN ProviderAuthorizationDocuments PAD ON PAD.ProviderAuthorizationDocumentId = PA.ProviderAuthorizationDocumentId
						AND ISNULL (PAD.RecordDeleted, 'N') = 'N'
					LEFT JOIN Providers P ON PA.ProviderId = P.ProviderId
						AND ISNULL(P.RecordDeleted, 'N') = 'N'
					LEFT JOIN GlobalCodes GC ON GC.GlobalCodeID = PA.Status
						AND ISNULL(GC.RecordDeleted, 'N') = 'N'
					LEFT JOIN Staff St ON St.StaffId = PAD.StaffId
						AND ISNULL(St.RecordDeleted, 'N') = 'N'
					LEFT JOIN Sites Si ON Si.SiteId = PA.SiteID
						AND ISNULL(Si.RecordDeleted, 'N') = 'N'
					LEFT JOIN BillingCodes BC ON BC.BillingCodeId = PA.BillingCodeId
						AND ISNULL(BC.RecordDeleted, 'N') = 'N'

			WHERE	ISNULL(PA.RecordDeleted, 'N') = 'N'
					AND PA.ClientId = @ClientId
					AND PA.Status NOT IN (2042)
					AND PA.EndDate > GETDATE()
					AND PA.ProviderAuthorizationId NOT IN (
							SELECT ProviderAuthorizationId
							FROM AppealAuthorizations
							WHERE IsNull(RecordDeleted, 'N') = 'N'
								AND AppealId <> @Appealid
							)
		END
		 
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetAppealAuthorizations') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

