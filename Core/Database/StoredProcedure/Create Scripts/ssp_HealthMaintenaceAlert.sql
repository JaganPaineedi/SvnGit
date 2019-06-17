GO

/****** Object:  StoredProcedure [dbo].[ssp_HealthMaintenaceAlert]    Script Date: 08/12/2014 19:09:51 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_HealthMaintenaceAlert]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_HealthMaintenaceAlert]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_HealthMaintenaceAlert]    Script Date: 08/12/2014 19:09:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_HealthMaintenaceAlert] (
	@clientId INT
	,@staffId INT
	)
AS

/*****************************************************************
Updates:

3/15/2017    Hemant     What:Modified the logic to show the Health alerts
                        only if all triggering groups are true for that
                        specific template.
                        
                        Why: If a Factor match sucesses , then system not
                        checking for remaining Factors in that template
                        
                        Project:Woodlands - Support Task# 406
*****************************************************************/
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		----- (0) Declarations------------------------------------------------------------------
		DECLARE @performHealthMaintenaceAlert CHAR(1) = 'N'
			,@performHealthMaintenaceAlertForStaff CHAR(1) = 'N'
			,@RoleId INT = 0;
		DECLARE @rowTrackCount INT
			,@loopCount INT = 1
			,@doFactorValidation CHAR(1)
			,@factorID INT
			,@factorGroupID INT
			,@templateID INT
			,@factorResult CHAR(1)
			,@lastCheckedClientDocVerId INT
			,@lastCheckedClientMedId INT
			,@lastCheckedClientProcId INT
			,@lastCheckedClientHealthDataAttrId INT
			,@lastCheckedClientAlrgyId INT
			,@performanceLoopCount INT = 0;
		DECLARE @currDate DATETIME = GETDATE()
			,@staffUserCode VARCHAR(30);
		DECLARE @performanceCheckClientDocVerId INT = 0
			,@performanceCheckClientMedId INT = 0
			,@performanceCheckClientProcId INT = 0
			,@PerformCheckClientHealthDataAttrId INT=0
			,@PerformCheckClientAlrgyId INT=0
			,@TrackFactorMatchCount INT=0;

		SELECT @staffUserCode = s.UserCode
		FROM Staff s
		WHERE s.StaffId = @staffId

		IF OBJECT_ID('tempdb..#tmpClientHealthMaintenanceDecisions') IS NOT NULL
		BEGIN
			DROP TABLE #tmpClientHealthMaintenanceDecisions
		END

		CREATE TABLE #tmpClientHealthMaintenanceDecisions (
			ClientID INT
			,HealthMaintenanceTemplateId INT
			,HealthMaintenanceTriggeringFactorGroupId INT
			,LastClientDocumentVersionId INT
			,LastClientMedicationId INT
			,LastClientProcedureId INT
			,LastClientHealthDataAttributeId INT
			,LastClientAllergyId INT
			,ClientHealthMaintenanceDecisionId INT
			)

		----- (0) ENDS------------------------------------------------------------------
		----- (1) check Health Maintenace to be performed--------------------------------------
		SELECT @performHealthMaintenaceAlert = ISNULL(sck.Value, 'N')
		FROM SystemConfigurationKeys sck
		WHERE sck.[Key] = 'validateHealthMaintenaceForClient'
			AND ISNULL(sck.RecordDeleted, 'N') = 'N'

		----- (1) ENDS-------------------------------------------------------------------------	
		--(2) check Health Maintenace  to be performed for staff ------------------------------ 
		SELECT @RoleId = GlobalCodeId
		FROM globalcodes gc
		WHERE gc.category = 'STAFFROLE'
			AND gc.Code = 'HEALTHMAINTENANCEALERT'
			AND ISNULL(gc.RecordDeleted, 'N') = 'N'
			AND gc.Active = 'Y'

		SELECT @performHealthMaintenaceAlertForStaff = CASE 
				WHEN COUNT(*) > 0
					THEN 'Y'
				ELSE 'N'
				END
		FROM StaffRoles sr
		WHERE sr.StaffId = @staffId
			AND sr.RoleId = @RoleId
			AND ISNULL(sr.RecordDeleted, 'N') = 'N'

		----- (2) ENDS--------------------------------------------------------------------------
		------ (3)STARTS-------------------------------------------------------------------------- 
		IF (
				@performHealthMaintenaceAlert = 'Y'
				AND @performHealthMaintenaceAlertForStaff = 'Y'
				)
		BEGIN
			IF OBJECT_ID('tempdb..#tmpTriggerFactorTrack') IS NOT NULL
			BEGIN
				DROP TABLE #tmpTriggerFactorTrack
			END

			CREATE TABLE #tmpTriggerFactorTrack (
				RowId INT
				,HealthMaintenanceTemplateId INT
				,HealthMaintenanceTriggeringFactorGroupId INT
				,HealthMaintenanceTriggeringFactorId INT
				,TriggeringFactor INT
				,FactorMatched CHAR(1)
				,FactorGroupMatched CHAR(1)
				,TemplateMatched CHAR(1)
				,ValidatonPerformedNum INT
				,LastClientDocVerId INT
				,LastClientMedId INT
				,LastClientProcId INT
				,LastClientHealthDataAttrId INT
				,LastClientAlrgyId INT
				)

			IF (@clientId > 0)
			BEGIN
				------- (3.1) Get all triggering factor details--------------------------------------------------------------
				INSERT INTO #tmpTriggerFactorTrack (
					RowId
					,HealthMaintenanceTemplateId
					,HealthMaintenanceTriggeringFactorGroupId
					,HealthMaintenanceTriggeringFactorId
					,TriggeringFactor
					)
				SELECT RANK() OVER (
						ORDER BY HMTTFG.HealthMaintenanceTemplateId
							,HMTTFG.HealthMaintenanceTriggeringFactorGroupId
							,HMTF.HealthMaintenanceTriggeringFactorId
						) AS RowId
					,HMTTFG.HealthMaintenanceTemplateId
					,HMTTFG.HealthMaintenanceTriggeringFactorGroupId
					,HMTF.HealthMaintenanceTriggeringFactorId
					,HMTF.TrigerringFactor
				--to get TemplateId & FactorGroupId 	
				FROM HealthMaintenanceTemplateTriggeringFactorGroups HMTTFG
				--join with templates to just check active & record deleted
				INNER JOIN HealthMaintenanceTemplates HMT ON HMT.HealthMaintenanceTemplateId = HMTTFG.HealthMaintenanceTemplateId
					AND ISNULL(HMT.RecordDeleted, 'N') = 'N'
					AND ISNULL(HMT.Active, 'Y') = 'Y'
					--to prevent duplicate template entry for a client
					AND HMT.HealthMaintenanceTemplateId NOT IN (
						SELECT HMCT.HealthMaintenanceTemplateId
						FROM HealthMaintenanceClientTemplates HMCT
						WHERE HMCT.ClientId = @clientId
							AND HMCT.Active = 'Y'
							AND ISNULL(HMCT.RecordDeleted, 'N') = 'N'
						)
				--join with factor groups to just check record deleted  	
				INNER JOIN HealthMaintenanceTriggeringFactorGroups HMTFG ON HMTFG.HealthMaintenanceTriggeringFactorGroupId = HMTTFG.HealthMaintenanceTriggeringFactorGroupId
					AND ISNULL(HMTFG.RecordDeleted, 'N') = 'N'
				-- join to get factor id
				INNER JOIN HealthMaintenanceTriggeringFactors HMTF ON HMTF.HealthMaintenanceTriggeringFactorGroupId = HMTTFG.HealthMaintenanceTriggeringFactorGroupId
					AND ISNULL(HMTF.RecordDeleted, 'N') = 'N'
				WHERE ISNULL(HMTTFG.RecordDeleted, 'N') = 'N';

				SELECT @rowTrackCount = COUNT(*)
				FROM #tmpTriggerFactorTrack

				---------(3.1.1)---------------------------------------------------	
				SELECT @performanceCheckClientDocVerId = MAX(CHMD.LastClientDocumentVersionId)
					,@performanceCheckClientMedId = MAX(CHMD.LastClientMedicationId)
					,@performanceCheckClientProcId = MAX(CHMD.LastClientProcedureId)
					,@PerformCheckClientHealthDataAttrId = MAX(CHMD.LastClientHealthDataAttributeId)
					,@PerformCheckClientAlrgyId = MAX(CHMD.LastClientAllergyId)
				FROM ClientHealthMaintenanceDecisions CHMD
				WHERE CHMD.ClientID = @clientId
					AND ISNULL(CHMD.RecordDeleted, 'N') = 'N'

				---------(3.1.1) ENDS---------------------------------------------------	
				------- (3.1) ENDS--------------------------------------------------------------------------------------------------
				------- (3.2) COMMENTS--------------------------------------------------------------------------------------------------
				/*
         Logic :1> A template can have multiple FactorGroups and each FactorGroup can have multiple factors.
                2> A template get's matched when any one of one FactorGroups get's matched (OR operation)
                   A FactorGroup get's matched when all of it's factors get matched (AND operation)
         
         Points : Based on above logic , 
                 1> If a factor match fails , then no need to check for remaining factors in that group.
                 2> If a FactorGroup match sucesses , then no need to check for remaining FactorGroup in that template
                 3> Repeat Factor : Different Templates can have  similar FactorGroups . 
                    So single FactorGroup must be validated only once & that result can be used for similar FactorGroups     
                        
         Code Logic : 1>	If @factorResult == ‘N’,
			                   then update similar factors with   FactorMatched = ‘N’
			                   and  update similar groups with  FactorGroupMatched = ‘N’
			          2>	If @factorResult == ‘Y’,
			                then update similar factors with   FactorMatched = ‘Y’
			               2.1>	if all factors in that group have  FactorMatched = ‘Y’ , 
			                    then update FactorGroupMatched = ‘Y’ and TemplateMatched = ‘Y’ 

			*/
				------- (3.2) ENDS--------------------------------------------------------------------------------------------------
				--------(3.3) loop through #tmpTriggerFactorTrack rows for factor validation-----------------------------------------		
				WHILE (@loopCount <= @rowTrackCount)
				BEGIN
					
					SET @doFactorValidation = 'Y';
                
					--SELECT @doFactorValidation = 'Y'
					--FROM #tmpTriggerFactorTrack
					--WHERE RowId = @loopCount
					--	AND FactorGroupMatched IS NULL
					--	AND FactorMatched IS NULL
					--	AND TemplateMatched IS NULL
                   
					-------- (3.3.1) STARTS-------------------------------------------------------------------------------------------
					IF (@doFactorValidation = 'Y')
					BEGIN
						SELECT @factorID = HealthMaintenanceTriggeringFactorId
							,@factorGroupID = HealthMaintenanceTriggeringFactorGroupId
							,@templateID = HealthMaintenanceTemplateId
						FROM #tmpTriggerFactorTrack
						WHERE RowId = @loopCount;

						SELECT @factorResult = 'N'
							,@lastCheckedClientDocVerId = 0
							,@lastCheckedClientMedId = 0
							,@lastCheckedClientProcId = 0
							,@lastCheckedClientHealthDataAttrId = 0
							,@lastCheckedClientAlrgyId = 0
							

						EXEC ssp_HealthMaintenaceTriggeringFactorMatch @ParamClientId = @clientId
							,@ParamStaffId = @staffId
							,@ParamHealthMaintenanceTriggeringFactorId = @factorID
							,@ParamPerformCheckClientDocVerId = @performanceCheckClientDocVerId
							,@ParamPerformCheckClientMedId = @performanceCheckClientMedId
							,@ParamPerformCheckClientProcId = @performanceCheckClientProcId
							,@ParamPerformCheckClientHealthDataAttrId = @PerformCheckClientHealthDataAttrId
							,@ParamPerformCheckClientAllergyId = @PerformCheckClientAlrgyId
							,@ParamRetValue = @factorResult OUTPUT
							,@ParamClientDocVerId = @lastCheckedClientDocVerId OUTPUT
							,@ParamClientMedId = @lastCheckedClientMedId OUTPUT
							,@ParamClientProcId = @lastCheckedClientProcId OUTPUT
							,@ParamClientHealthDataAttrId = @lastCheckedClientHealthDataAttrId OUTPUT
							,@ParamClientAllergyId = @lastCheckedClientAlrgyId OUTPUT
							
					   	
					   SET @TrackFactorMatchCount = (select count(*) from #tmpTriggerFactorTrack
					   WHERE HealthMaintenanceTemplateId = @templateID AND FactorMatched = 'N' AND FactorGroupMatched = 'N')
					 
					     
						IF (@factorResult = 'Y' AND @TrackFactorMatchCount = 0)
						BEGIN
							UPDATE #tmpTriggerFactorTrack
							SET FactorMatched = 'Y'
							WHERE HealthMaintenanceTriggeringFactorId = @factorID 
							AND HealthMaintenanceTemplateId = @templateID

							IF (@lastCheckedClientDocVerId > 0)
							BEGIN
								UPDATE #tmpTriggerFactorTrack
								SET LastClientDocVerId = @lastCheckedClientDocVerId
								WHERE HealthMaintenanceTriggeringFactorId = @factorID 
								AND HealthMaintenanceTemplateId = @templateID
							END

							IF (@lastCheckedClientMedId > 0)
							BEGIN
								UPDATE #tmpTriggerFactorTrack
								SET LastClientMedId = @lastCheckedClientMedId
								WHERE HealthMaintenanceTriggeringFactorId = @factorID 
								AND HealthMaintenanceTemplateId = @templateID
							END

							IF (@lastCheckedClientProcId > 0)
							BEGIN
								UPDATE #tmpTriggerFactorTrack
								SET LastClientProcId = @lastCheckedClientProcId
								WHERE HealthMaintenanceTriggeringFactorId = @factorID 
								AND HealthMaintenanceTemplateId = @templateID
							END
							
							IF (@lastCheckedClientHealthDataAttrId > 0)
							BEGIN
								UPDATE #tmpTriggerFactorTrack
								SET LastClientHealthDataAttrId = @lastCheckedClientHealthDataAttrId
								WHERE HealthMaintenanceTriggeringFactorId = @factorID 
								AND HealthMaintenanceTemplateId = @templateID
							END
							
							IF (@lastCheckedClientAlrgyId > 0)
							BEGIN
								UPDATE #tmpTriggerFactorTrack
								SET LastClientAlrgyId = @lastCheckedClientAlrgyId
								WHERE HealthMaintenanceTriggeringFactorId = @factorID 
								AND HealthMaintenanceTemplateId = @templateID
							END

							DECLARE @factorCountInGroup INT
								,@factorMatchedCountInGroup INT;

							SELECT @factorCountInGroup = COUNT(*)
							FROM #tmpTriggerFactorTrack
							WHERE HealthMaintenanceTriggeringFactorGroupId = @factorGroupID
							AND HealthMaintenanceTemplateId = @templateID

							SELECT @factorMatchedCountInGroup = COUNT(*)
							FROM #tmpTriggerFactorTrack
							WHERE HealthMaintenanceTriggeringFactorGroupId = @factorGroupID
								AND ISNULL(FactorMatched, 'N') = 'Y'
								AND HealthMaintenanceTemplateId = @templateID

							IF (@factorCountInGroup = @factorMatchedCountInGroup)
							BEGIN
								UPDATE #tmpTriggerFactorTrack
								SET FactorGroupMatched = 'Y'
								WHERE HealthMaintenanceTriggeringFactorGroupId = @factorGroupID
								AND HealthMaintenanceTemplateId = @templateID;

								UPDATE #tmpTriggerFactorTrack
								SET TemplateMatched = 'Y'
								WHERE HealthMaintenanceTemplateId IN (
										SELECT DISTINCT HealthMaintenanceTemplateId
										FROM #tmpTriggerFactorTrack
										WHERE HealthMaintenanceTriggeringFactorGroupId = @factorGroupID
										AND HealthMaintenanceTemplateId = @templateID
										)
							END
						END
						ELSE IF (@factorResult = 'N')
						BEGIN
						
						
							UPDATE #tmpTriggerFactorTrack
							SET FactorMatched = 'N',FactorGroupMatched = 'N',TemplateMatched = 'N'
							WHERE HealthMaintenanceTemplateId = @templateID
					    
						END

						SET @performanceLoopCount += 1;

						UPDATE #tmpTriggerFactorTrack
						SET ValidatonPerformedNum = @performanceLoopCount
						WHERE RowId = @loopCount
					END

					-------- (3.3.1) ENDS-------------------------------------------------------------------------------------------
					SET @loopCount += 1;
				END

				--------(3.3) ENDS---------------------------------------------------------------------------------------------------
				--------(3.4) output-------------------------------------------------------------------------------------------------
				-- output table 1
				SELECT TFT.RowId
					,TFT.HealthMaintenanceTemplateId
					,TFT.HealthMaintenanceTriggeringFactorGroupId
					,TFT.HealthMaintenanceTriggeringFactorId
					,G.CodeName AS TriggeringFactor --TFT.TriggeringFactor 
					,TFT.FactorMatched
					,TFT.FactorGroupMatched
					,TFT.TemplateMatched
					,TFT.ValidatonPerformedNum
					,TFT.LastClientDocVerId
					,TFT.LastClientMedId
					,TFT.LastClientProcId
					,TFT.LastClientHealthDataAttrId
					,TFT.LastClientAlrgyId
				FROM #tmpTriggerFactorTrack TFT
				LEFT JOIN (
					SELECT *
					FROM GlobalCodes
					WHERE Category = 'PCTRIGGERINGFACTOR'
					) G ON TFT.TriggeringFactor = G.GlobalCodeId

				--SELECT cast(@performanceLoopCount AS VARCHAR) + ' validations done instead of ' + cast(@rowTrackCount AS VARCHAR) AS 'Factor validate Row Count'
				------(3.4.1) insert into  #tmpClientHealthMaintenanceDecisions--------------------------------------------------------------------------
				INSERT INTO #tmpClientHealthMaintenanceDecisions (
					ClientID
					,HealthMaintenanceTemplateId
					,HealthMaintenanceTriggeringFactorGroupId
					,LastClientDocumentVersionId
					,LastClientMedicationId
					,LastClientProcedureId
					,LastClientHealthDataAttributeId
					,LastClientAllergyId
					)
				SELECT m.ClientId
					,m.HealthMaintenanceTemplateId
					,m.HealthMaintenanceTriggeringFactorGroupId
					,m.LastClientDocVerId
					,m.LastClientMedId
					,m.LastClientProcId
					,m.LastClientHealthDataAttrId
					,m.LastClientAlrgyId
				FROM (
					/*			
		 one template  will have single FactorGroupMatched = 'Y' tested, 
		 if more than one are FactorGroup are matched , then it is updated by some other template.
		 So removing those rows (in below query ) by using ROW_NUMBER & ValidatonPerfNum concept
		*/
					SELECT ROW_NUMBER() OVER (
							PARTITION BY t.HealthMaintenanceTemplateId ORDER BY t.ValidatonPerfNum DESC
							) AS Rnk
						,*
					FROM (
						SELECT @clientId AS ClientId
							,TFT.HealthMaintenanceTemplateId
							,TFT.HealthMaintenanceTriggeringFactorGroupId
							,MAX(TFT.LastClientDocVerId) AS LastClientDocVerId
							,MAX(TFT.LastClientMedId) AS LastClientMedId
							,MAX(TFT.LastClientProcId) AS LastClientProcId
							,MAX(TFT.LastClientHealthDataAttrId) AS LastClientHealthDataAttrId
							,MAX(TFT.LastClientAlrgyId) AS LastClientAlrgyId
							,MAX(ISNULL(TFT.ValidatonPerformedNum, 0)) AS ValidatonPerfNum
						FROM #tmpTriggerFactorTrack TFT
						WHERE ISNULL(TFT.TemplateMatched, 'N') = 'Y'
							AND ISNULL(TFT.FactorGroupMatched, 'N') = 'Y'
						GROUP BY TFT.HealthMaintenanceTemplateId
							,TFT.HealthMaintenanceTriggeringFactorGroupId
						) t
					) m
				WHERE m.Rnk = 1

				-------(3.4.1) ENDS-------------------------------------------------------------------------
				------(3.4.2) update ClientHealthMaintenanceDecisions--------------------------------------------------------------------------
				/*In table 'ClientHealthMaintenanceDecisions'
		  If UserDecision is null for a row with particular(TemplateId,FactorGroupId) for a client
		         -> then update (ClientDocVerId,ClientMedId,ClientProcId) respectively  
		  Else insert new row with values
		*/
				UPDATE t
				SET t.ClientHealthMaintenanceDecisionId = CHMD.ClientHealthMaintenanceDecisionId
				FROM #tmpClientHealthMaintenanceDecisions t
				LEFT JOIN ClientHealthMaintenanceDecisions CHMD ON CHMD.ClientID = t.ClientID
					AND CHMD.HealthMaintenanceTemplateId = t.HealthMaintenanceTemplateId
					AND CHMD.HealthMaintenanceTriggeringFactorGroupId = t.HealthMaintenanceTriggeringFactorGroupId
					AND CHMD.UserDecision IS NULL
					AND ISNULL(CHMD.RecordDeleted, 'N') = 'N'

				-- output table 2 (effected table rows ,if ClientHealthMaintenanceDecisionId = null then inserted else updated)
				SELECT *
				FROM #tmpClientHealthMaintenanceDecisions

				--insert 	
				INSERT INTO [dbo].[ClientHealthMaintenanceDecisions] (
					[CreatedBy]
					,[CreatedDate]
					,[ModifiedBy]
					,[ModifiedDate]
					,[ClientID]
					,[HealthMaintenanceTemplateId]
					,[HealthMaintenanceTriggeringFactorGroupId]
					,[LastClientDocumentVersionId]
					,[LastClientMedicationId]
					,[LastClientProcedureId]
					,[LastClientHealthDataAttributeId]
					,[LastClientAllergyId]
					)
				SELECT @staffUserCode
					,@currDate
					,@staffUserCode
					,@currDate
					,@clientId
					,t.HealthMaintenanceTemplateId
					,t.HealthMaintenanceTriggeringFactorGroupId
					,t.LastClientDocumentVersionId
					,t.LastClientMedicationId
					,t.LastClientProcedureId
					,t.LastClientHealthDataAttributeId
					,t.LastClientAllergyId
				FROM #tmpClientHealthMaintenanceDecisions t
				WHERE ISNULL(t.ClientHealthMaintenanceDecisionId, 0) = 0

				--update 
				UPDATE CHMD
				SET CHMD.ModifiedBy = @staffUserCode
					,CHMD.ModifiedDate = @currDate
					,CHMD.LastClientDocumentVersionId = t.LastClientDocumentVersionId
					,CHMD.LastClientMedicationId = t.LastClientMedicationId
					,CHMD.LastClientProcedureId = t.LastClientProcedureId
					,CHMD.LastClientHealthDataAttributeId = t.LastClientHealthDataAttributeId
					,CHMD.LastClientAllergyId = t.LastClientAllergyId
				FROM #tmpClientHealthMaintenanceDecisions t
				INNER JOIN ClientHealthMaintenanceDecisions CHMD ON CHMD.ClientHealthMaintenanceDecisionId = t.ClientHealthMaintenanceDecisionId
					AND ISNULL(t.ClientHealthMaintenanceDecisionId, 0) > 0
					AND (
						CHMD.LastClientDocumentVersionId <> t.LastClientDocumentVersionId
						OR CHMD.LastClientMedicationId <> t.LastClientMedicationId
						OR CHMD.LastClientProcedureId <> t.LastClientProcedureId
						OR CHMD.LastClientHealthDataAttributeId <> t.LastClientHealthDataAttributeId
						OR CHMD.LastClientAllergyId <> t.LastClientAllergyId
						)

				-------(3.4.2) ENDS-------------------------------------------------------------------------
				-- output table 3				
				SELECT dbo.ssf_getHealthMaintenanceAlertCount(@clientId) AS TotalHealthMaintenanceAlertCount
					--------(3.4) ENDS----------------------------------------------------------------------------------------------------
			END
					/*ELSE
			BEGIN --@clientId = 0
				SELECT *
				FROM #tmpTriggerFactorTrack --blank

				SELECT *
				FROM #tmpClientHealthMaintenanceDecisions --blank

				-- output table 3
				SELECT COUNT(*) AS TotalHealthMaintenanceAlertCount
				FROM (
					SELECT CHMD.ClientID
						,CHMD.HealthMaintenanceTemplateId
						,COUNT(*) AS MatchFrequency
					FROM ClientHealthMaintenanceDecisions CHMD
					WHERE CHMD.UserDecision IS NULL
						AND ISNULL(CHMD.RecordDeleted, 'N') = 'N'
						AND cast(CONVERT(varchar,CHMD.ModifiedDate,101) as datetime) >= cast(CONVERT(varchar,GETDATE()-1,101) as datetime)
					GROUP BY CHMD.ClientID
						,CHMD.HealthMaintenanceTemplateId
					) t
			END
			*/
		END

		------ (3)ENDS----------------------------------------------------------------------------------------------
		----- (4) drop temp tables----------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#tmpTriggerFactorTrack') IS NOT NULL
		BEGIN
			DROP TABLE #tmpTriggerFactorTrack
		END

		IF OBJECT_ID('tempdb..#tmpClientHealthMaintenanceDecisions') IS NOT NULL
		BEGIN
			DROP TABLE #tmpClientHealthMaintenanceDecisions
		END

		----- (4) ENDS-----------------------------------------------------------------------------------------------	
		COMMIT TRANSACTION

		IF @@error <> 0
			GOTO rollback_tran

		RETURN

		rollback_tran:

		ROLLBACK TRANSACTION
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_HealthMaintenaceAlert') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

