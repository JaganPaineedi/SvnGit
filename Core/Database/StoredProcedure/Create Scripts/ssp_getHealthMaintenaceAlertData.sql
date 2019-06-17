
GO

/****** Object:  StoredProcedure [dbo].[ssp_getHealthMaintenaceAlertData]    Script Date: 08/12/2014 19:11:23 ******/

/********************************************************************************************/                                                                    
/* Stored Procedure: sp_HealthMaintenaceTriggeringFactorMatch          */                                                           
/* Copyright: 2012 Streamline Healthcare Solutions           */                                                                    
/* Creation Date:  18 July 2014 by Prasan               */                                                                    
/* Purpose: Gets Data from PrimaryCate Health Maintenance Alert Data */                                                                                                                                            
/* Output Parameters:                  */                                                                    
/* Return:                     */  
/* Data Modifications:                  */
/* 18 July 2014    Prasan   Created   */    
/* 24 Sep  2014	   Prasan	Alert count fix.  Why : Task 31.1 of MeaningFul Use */ 
/* 04 Nov  2014	   Ponnin	Show info icon for Lab - Template Action Criteria.  Why :  For task #4 of Certification 2014 */ 
/* 08 Nov  2014	   PPOTNURU	Show info icon for Health Maintenance Templates.  Why :  For task #4 of Certification 2014 */                                                                        
/********************************************************************************************/ 



IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_getHealthMaintenaceAlertData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_getHealthMaintenaceAlertData]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_getHealthMaintenaceAlertData]    Script Date: 08/12/2014 19:11:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_getHealthMaintenaceAlertData] (
	@clientId INT
	,@staffId INT
	)
AS
BEGIN
	DECLARE @performHealthMaintenaceAlert CHAR(1) = 'N'
		,@performHealthMaintenaceAlertForStaff CHAR(1) = 'N'
		,@RoleId INT = 0;

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
		IF OBJECT_ID('tempdb..#tmpClientHealthMaintenanceDecisions') IS NOT NULL
		BEGIN
			DROP TABLE #tmpClientHealthMaintenanceDecisions
		END

		CREATE TABLE #tmpClientHealthMaintenanceDecisions (
			ClientID INT
			,ClientName VARCHAR(MAX)
			,HealthMaintenanceTemplateId INT
			,TemplateName VARCHAR(MAX)
			,ClientHealthMaintenanceDecisionId INT
			,HealthMaintenanceTriggeringFactorGroupId INT
			,FactorName VARCHAR(MAX)
			,CreatedDate DATETIME
			,ModifiedDate DATETIME
			,TemplateDescription VARCHAR(MAX)
			,DocumentType VARCHAR(1)
			,ResourceURL VARCHAR(1000)
			,EducationResourceId int
			,[ResourceComment] varchar(max) NULL     
			)

		INSERT INTO #tmpClientHealthMaintenanceDecisions (
			ClientID
			,ClientName
			,HealthMaintenanceTemplateId
			,TemplateName
			,ClientHealthMaintenanceDecisionId
			,HealthMaintenanceTriggeringFactorGroupId
			,FactorName
			,CreatedDate
			,ModifiedDate
			,TemplateDescription
			,DocumentType
			,ResourceURL
			,EducationResourceId
			,ResourceComment
			)
		SELECT CHMD.ClientID
			,(C.LastName + ',' + C.FirstName) AS ClientName
			,CHMD.HealthMaintenanceTemplateId
			,HMT.TemplateName
			,CHMD.ClientHealthMaintenanceDecisionId
			,CHMD.HealthMaintenanceTriggeringFactorGroupId
			,HMTFG.FactorName
			,CHMD.CreatedDate
			,CHMD.ModifiedDate
			,HMT.TemplateDescription
			,ER.DocumentType
			,ER.ResourceURL
			,ER.EducationResourceId
			,ER.ResourceComment
		FROM ClientHealthMaintenanceDecisions CHMD
		INNER JOIN Clients C ON C.ClientId = CHMD.ClientID
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN HealthMaintenanceTemplates HMT ON HMT.HealthMaintenanceTemplateId = CHMD.HealthMaintenanceTemplateId
			AND ISNULL(HMT.RecordDeleted, 'N') = 'N'
			AND ISNULL(HMT.Active, 'Y') = 'Y'
		INNER JOIN HealthMaintenanceTriggeringFactorGroups HMTFG ON HMTFG.HealthMaintenanceTriggeringFactorGroupId = CHMD.HealthMaintenanceTriggeringFactorGroupId
			AND ISNULL(HMTFG.RecordDeleted, 'N') = 'N'
		LEFT JOIN EducationResourceHealthMaintenanceTemplates ERH ON ERH.EducationResourceHealthMaintenanceTemplateId = 
		(SELECT  MIN(EducationResourceHealthMaintenanceTemplateId) FROM EducationResourceHealthMaintenanceTemplates
	     	WHERE HealthMaintenanceTemplateId=HMT.HealthMaintenanceTemplateId AND ISNULL(RecordDeleted, 'N') = 'N') AND ISNULL(ERH.RecordDeleted, 'N') = 'N'
		 LEFT JOIN EducationResources ER ON ER.EducationResourceId=ERH.EducationResourceId
			AND ISNULL(ER.RecordDeleted, 'N') = 'N'
		WHERE CHMD.UserDecision IS NULL
			AND ISNULL(CHMD.RecordDeleted, 'N') = 'N'
			AND CHMD.ClientID = @clientId
			AND cast(CONVERT(varchar,CHMD.ModifiedDate,101) as datetime) >= cast(CONVERT(varchar,GETDATE()-1,101) as datetime)

		--ORDER BY CHMD.ModifiedDate desc,CHMD.CreatedDate desc
		-- output table 1
		SELECT tbl1.ClientID
			,tbl1.ClientName
			,tbl1.HealthMaintenanceTemplateId
			,tbl1.TemplateName
			,PrimaryKeyList = REPLACE((
					SELECT t2.ClientHealthMaintenanceDecisionId AS [data()]
					FROM #tmpClientHealthMaintenanceDecisions t2
					WHERE t2.ClientID = tbl1.ClientID
						AND t2.HealthMaintenanceTemplateId = tbl1.HealthMaintenanceTemplateId
					FOR XML PATH('')
					), ' ', ',')
			,FactorGroupIdList = REPLACE((
					SELECT t2.HealthMaintenanceTriggeringFactorGroupId AS [data()]
					FROM #tmpClientHealthMaintenanceDecisions t2
					WHERE t2.ClientID = tbl1.ClientID
						AND t2.HealthMaintenanceTemplateId = tbl1.HealthMaintenanceTemplateId
					FOR XML PATH('')
					), ' ', ',')
			,FactorGroupNameList = REPLACE(REPLACE((
						SELECT REPLACE(t2.FactorName, ' ', '##') AS [data()]
						FROM #tmpClientHealthMaintenanceDecisions t2
						WHERE t2.ClientID = tbl1.ClientID
							AND t2.HealthMaintenanceTemplateId = tbl1.HealthMaintenanceTemplateId
						FOR XML PATH('')
						), ' ', ','), '##', ' ')
			,MAX(ModifiedDate) AS ModifiedDateTmp
			,MAX(CreatedDate) AS CreatedDateTmp
			,tbl1.TemplateDescription
			,tbl1.DocumentType
			,tbl1.ResourceURL
			,tbl1.EducationResourceId
			,tbl1.ResourceComment
		FROM #tmpClientHealthMaintenanceDecisions tbl1
		GROUP BY tbl1.ClientID
			,tbl1.HealthMaintenanceTemplateId
			,tbl1.TemplateName
			,tbl1.TemplateDescription
			,tbl1.ClientName
			,tbl1.DocumentType
			,tbl1.ResourceURL
			,tbl1.EducationResourceId
			,tbl1.ResourceComment
		ORDER BY ModifiedDateTmp DESC
			,CreatedDateTmp DESC

		-- output table 2
				
			select dbo.ssf_getHealthMaintenanceAlertCount (@clientId) as TotalHealthMaintenanceAlertCount

		--output table 3
		SELECT PCHMC.HealthMaintenanceCriteriaId
			,PCHMC.HealthMaintenanceTemplateId
			,HDT.LoincCode
			,PCHMC.OrderId
			,O.OrderName
			,CASE 
				WHEN PCHMC.ActionTaken = 'O'
					THEN 'Do once in ' + Cast(ISnull(PCHMC.[Once], '') AS VARCHAR(2)) + ' ' + ISNULL((
								SELECT CodeName
								FROM GlobalCodes
								WHERE GlobalCodeId = PCHMC.[OnceFrquency]
								), '')
				WHEN PCHMC.ActionTaken = 'E'
					THEN 'Do every ' + Cast(ISNull(PCHMC.[Every], '') AS VARCHAR(2)) + ' ' + ISNULL((
								SELECT CodeName
								FROM GlobalCodes
								WHERE GlobalCodeId = PCHMC.[EveryFrquency]
								), '') + ' For ' + Cast(ISNULL(PCHMC.[EveryTimes], '') AS VARCHAR(2)) + ' times'
				WHEN PCHMC.ActionTaken = 'BA'
					AND ISNULL(PCHMC.[IncludeAllAge], 'N') = 'N'
					THEN 'Do between ' + Cast(ISNULL(PCHMC.[AgeTo], '') AS VARCHAR(2)) + ' to ' + Cast(ISNULL(PCHMC.[AgeFrom], '') AS VARCHAR(2)) + ' age group for every ' + ISNULL((
								SELECT CodeName
								FROM GlobalCodes
								WHERE GlobalCodeId = PCHMC.[AgeFrequency]
								), '')
				WHEN PCHMC.ActionTaken = 'BA'
					AND ISNULL(PCHMC.[IncludeAllAge], 'N') = 'Y'
					THEN 'All ages are included'
				WHEN PCHMC.ActionTaken = 'AC'
					THEN 'Do at ages ' + PCHMC.[AgeCriteria]
				WHEN PCHMC.ActionTaken = 'PI'
					AND IsNull(PCHMC.[CountProcedures], 'N') = 'Y'
					THEN 'Count Procedure minimum for ' + Cast(ISNULL(PCHMC.[ProcedureInterval], '') AS VARCHAR(2)) + ' ' + ISNULL((
								SELECT CodeName
								FROM GlobalCodes
								WHERE GlobalCodeId = PCHMC.[ProcedureIntervalFrequency]
								), '')
				WHEN ISNULL(PCHMC.ActionTaken, '') = ''
					THEN ''
				END AS CriteriaDescription
			,GC.[CodeName] AS HealthDataGroupDescription
		FROM (
			SELECT DISTINCT tbl1.HealthMaintenanceTemplateId
			FROM #tmpClientHealthMaintenanceDecisions tbl1
			) t
		INNER JOIN HealthMaintenanceCriteria PCHMC ON PCHMC.HealthMaintenanceTemplateId = t.HealthMaintenanceTemplateId
			AND ISNULL(PCHMC.RecordDeleted, 'N') <> 'Y'
		INNER JOIN Orders O ON O.OrderId = PCHMC.OrderId
		LEFT JOIN HealthDataTemplates  HDT on O.LabID = HDT.HealthDataTemplateId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.Active, 'Y') = 'Y'
		LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = PCHMC.HealthDataGroup

		IF OBJECT_ID('tempdb..#tmpClientHealthMaintenanceDecisions') IS NOT NULL
		BEGIN
			DROP TABLE #tmpClientHealthMaintenanceDecisions
		END
	END
			------ (3)ENDS----------------------------------------------------------------------------------------------
END
GO

