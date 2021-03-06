/****** Object:  StoredProcedure [dbo].[csp_Report_referrals_to_dev_peds]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_referrals_to_dev_peds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_referrals_to_dev_peds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_referrals_to_dev_peds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_referrals_to_dev_peds]
	@start_date	date,--time,
	@end_date	date--time

AS
--*/

/*
DECLARE	@start_date	datetime,
		@end_date	datetime

SELECT	@start_date =	''1/1/2012'',
		@end_date = ''12/31/2012''
--*/

/****************************************************************/
/* Stored Procedure: csp_Report_referrals_to_dev_peds			*/
/*																*/
/*	Updates:													*/
/*	Date		Author	Purpose									*/
/*	06-017-12	Jess	Converted from Psych Consult			*/
/****************************************************************/

DECLARE	@referrals TABLE
(
	LocationID int,
	staff varchar(55),
	DocumentVersionID int,
	indiv_therapy int,
	psych_test int,
	csp int
)
INSERT	INTO	@referrals
SELECT	DISTINCT
		null,
		st.LastName + '', '' + st.FirstName as ''Staff'',
		dv.DocumentVersionId,

		CASE	WHEN	cdar2.ServiceRecommended = 1
				THEN	1
				ELSE	0
		END,
		CASE	WHEN	cdar3.ServiceRecommended = 15
				THEN	1
				ELSE	0
		END,
		CASE	WHEN	cdar4.ServiceRecommended = 2
				THEN	1
				ELSE	0
		END

FROM	Documents d

JOIN	DocumentVersions dv
ON		d.CurrentDocumentVersionId = dv.DocumentVersionId
AND		isnull(dv.RecordDeleted, ''N'') <> ''Y'' 

JOIN	CustomDocumentAssessmentReferrals cdar
ON		dv.DocumentVersionId = cdar.DocumentVersionId
AND		isnull(cdar.recordDeleted, ''N'') <> ''Y'' 
AND		cdar.ServiceRecommended = 10	-- DP

LEFT	JOIN	CustomDocumentAssessmentReferrals cdar2
ON		cdar.DocumentVersionId = cdar2.DocumentVersionId
AND		isnull(cdar2.recordDeleted, ''N'') <> ''Y'' 
AND		cdar2.ServiceRecommended = 1	-- Behavioral Health Counseling

LEFT	JOIN	CustomDocumentAssessmentReferrals cdar3
ON		cdar.DocumentVersionId = cdar3.DocumentVersionId
AND		isnull(cdar3.recordDeleted, ''N'') <> ''Y'' 
AND		cdar3.ServiceRecommended = 15	-- Psychological Testing

LEFT	JOIN	CustomDocumentAssessmentReferrals cdar4
ON		cdar.DocumentVersionId = cdar4.DocumentVersionId
AND		isnull(cdar4.recordDeleted, ''N'') <> ''Y'' 
AND		cdar4.ServiceRecommended = 2	-- CPST

JOIN	staff st with (nolock)
ON		d.AuthorId = st.StaffId
AND		isnull(st.recordDeleted, ''N'') <> ''Y'' 

WHERE	d.EffectiveDate >= @start_date
AND		d.EffectiveDate < dateadd(dd, 1, @end_date)
AND		d.status = ''22''	-- Document is Signed


/*
SELECT	''@referrals'', *
FROM	@referrals
--*/

SELECT	LocationID,
		staff,
		COUNT (DISTINCT DocumentVersionID) as ''Dev Ped Referrals'',
		SUM(indiv_therapy) as ''Individual Therapy Referrals'',
		SUM(psych_test) as ''Psych Testing Referrals'',
		SUM(csp) as ''CSP Referrals''
FROM	@referrals
GROUP	BY
		LocationID,
		staff
ORDER	BY
		LocationID,
		staff



' 
END
GO
