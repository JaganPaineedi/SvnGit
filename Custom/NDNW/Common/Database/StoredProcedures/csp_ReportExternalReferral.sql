
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportExternalReferral]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportExternalReferral]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/***********************************************************************************************************************
Created by tmu 
Ace # 313 New Directions is requesting a report to track External Referrals

MODIFICATIONS:
	Date		User		Description
	--------	-------		------------------------------
	04-28-2016	tmu			Modified to allow NULL value for ProviderTypeId and ExternalReferralProviderId
	
***********************************************************************************************************************/

CREATE PROCEDURE [dbo].[csp_ReportExternalReferral] 
(
	@ProviderTypeId INT
	,@ExternalReferralProviderId INT
	,@ReferralReasonId INT
	,@ReferralStatusId INT
	,@StartDate DATE
	,@EndDate DATE
)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Title VARCHAR(max)
DECLARE @SubTitle VARCHAR(max)
DECLARE @Comment VARCHAR(max)

SET @Title = 'New Directions Northwest - External Referrals Report'
SET @SubTitle = 'Subtitle'
SET @Comment = 'Ace # 313 New Directions is requesting a report to track External Referrals'

DECLARE @StoredProcedure VARCHAR(300)
SET @StoredProcedure = object_name(@@procid)

IF @StartDate IS NULL
	SET @StartDate = DATEADD(DAY, - 1, GETDATE())

IF @EndDate IS NULL
	SET @EndDate = @StartDate
	
--  Now that @StartDate and @EndDate are declared, craft the SubTitle
IF @StartDate = @EndDate
	SET @SubTitle = CONVERT(VARCHAR, @StartDate, 101)
ELSE
	SET @SubTitle = 'Referral Date Period: ' + CONVERT(VARCHAR, @StartDate, 101) + ' - ' + CONVERT(VARCHAR, @EndDate, 101)

IF @StoredProcedure IS NOT NULL
	AND NOT EXISTS 
	(
		SELECT 1
		FROM CustomReportParts
		WHERE StoredProcedure = @StoredProcedure
	)
BEGIN
	INSERT INTO CustomReportParts 
	(
		StoredProcedure
		,ReportName
		,Title
		,SubTitle
		,Comment
	)
	SELECT @StoredProcedure
		,@Title
		,@Title
		,@SubTitle
		,@Comment
END
ELSE
BEGIN
	UPDATE CustomReportParts
	SET ReportName = @Title
		,Title = @Title
		,SubTitle = @SubTitle
		,Comment = @Comment
	WHERE StoredProcedure = @StoredProcedure
END

--==============================================================================
-- Get the report contents
--==============================================================================
IF OBJECT_ID('tempdb..#ReportExternalReferrals') IS NOT NULL
	DROP TABLE #ReportExternalReferrals
	
CREATE TABLE #ReportExternalReferrals
(
	ClientName VARCHAR(150),
	ProviderType VARCHAR(150),
	ProviderName VARCHAR(150),
	ReferralReason1 VARCHAR(150),
	ReferralReason2 VARCHAR(150),
	ReferralReason3 VARCHAR(150),
	MakeAppointment CHAR(5),
	Reason VARCHAR(150),
	FollowUp CHAR(5),
	ReferralStatus VARCHAR(100)
)
INSERT INTO #ReportExternalReferrals (ClientName, ProviderType, ProviderName, ReferralReason1, ReferralReason2, ReferralReason3, MakeAppointment, Reason, FollowUp, ReferralStatus)
SELECT	c.FirstName + ' ' + c.LastName AS ClientName,
		ptype.CodeName,
		erp.Name,
		CASE 
			WHEN reason1.CodeName IS NULL THEN 'N/A'
			ELSE reason1.CodeName
		END AS Reason1,
		CASE 
			WHEN reason2.CodeName IS NULL THEN 'N/A'
			ELSE reason2.CodeName
		END AS Reason2,
		CASE 
			WHEN reason3.CodeName IS NULL THEN 'N/A'
			ELSE reason3.CodeName
		END AS Reason3,
		CASE
			WHEN ext.PatientAppointment IS NULL THEN 'N/A'
			ELSE ext.PatientAppointment
		END AS MakeAppointment,
		CASE 
			WHEN nreason.CodeName IS NULL THEN 'N/A'
			ELSE nreason.CodeName
		END AS N_Reason,
		CASE 
			WHEN ext.FollowUp IS NULL THEN 'N/A'
			ELSE ext.FollowUp
		END AS FollwoUp,
		CASE 
			WHEN stat.CodeName IS NULL THEN 'N/A'
			ELSE stat.CodeName
		END AS Status
FROM		ClientPrimaryCareExternalReferrals ext
LEFT JOIN	ExternalReferralProviders erp ON ext.ProviderName = erp.ExternalReferralProviderId
LEFT JOIN	Clients c ON ext.ClientId = c.ClientId
LEFT JOIN	GlobalCodes ptype ON ext.ProviderType = ptype.GlobalCodeId
LEFT JOIN	GlobalCodes reason1 ON ext.ReferralReason1 = reason1.GlobalCodeId
LEFT JOIN	GlobalCodes reason2 ON ext.ReferralReason2 = reason2.GlobalCodeId
LEFT JOIN	GlobalCodes reason3 ON ext.ReferralReason3 = reason3.GlobalCodeId
LEFT JOIN	GlobalCodes nreason ON ext.Reason = nreason.GlobalCodeId
LEFT JOIN	GlobalCodes stat ON ext.Status = stat.GlobalCodeId
WHERE	ISNULL(ext.RecordDeleted, 'N') <> 'Y'
AND		(@ProviderTypeId IS NULL OR ext.ProviderType = @ProviderTypeId)
AND		(@ExternalReferralProviderId IS NULL OR ext.ProviderName = @ExternalReferralProviderId)
AND 	(ext.ReferralReason1 = @ReferralReasonId OR @ReferralReasonId IS NULL)
AND 	(ext.Status = @ReferralStatusId OR @ReferralStatusId IS NULL)
AND		DATEDIFF(DAY, @StartDate, ext.ReferralDate) >= 0
AND		DATEDIFF(DAY, ext.ReferralDate, @EndDate) >= 0

--==============================================================================
-- Final select
--==============================================================================
IF EXISTS (SELECT 1 FROM #ReportExternalReferrals)
BEGIN
	SELECT *, @StoredProcedure AS StoredProcedure FROM #ReportExternalReferrals
	ORDER BY ClientName ASC
END
ELSE
	SELECT @StoredProcedure AS StoredProcedure

DROP TABLE #ReportExternalReferrals

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO
