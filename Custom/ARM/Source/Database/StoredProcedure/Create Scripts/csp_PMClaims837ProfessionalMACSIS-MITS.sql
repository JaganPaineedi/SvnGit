/****** Object:  StoredProcedure [dbo].[csp_PMClaims837ProfessionalMACSIS-MITS]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837ProfessionalMACSIS-MITS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaims837ProfessionalMACSIS-MITS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837ProfessionalMACSIS-MITS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
CREATE procedure [dbo].[csp_PMClaims837ProfessionalMACSIS-MITS]
@CurrentUser varchar(30), 
@ClaimBatchId int
AS
BEGIN

Declare @Max datetime=NULL,@Min datetime=NULL,@Med1 char(1),@Med2 char(1)

SELECT @Max=MAX(s.DateofService), @Min=MIN(s.DateofService),@Med1=MIN(cp.MedicaidPlan),@Med2=MAX(cp.MedicaidPlan)
FROM ClaimBatches cb
JOIN ClaimBatchCharges cbc ON cbc.ClaimBatchId = cb.ClaimBatchId
JOIN Charges c ON c.ChargeId = cbc.ChargeId
JOIN Services s ON s.ServiceId = c.ServiceId
JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
WHERE cb.ClaimBatchId = @ClaimBatchId
AND IsNull(cb.RecordDeleted,''N'') <> ''Y''
AND IsNull(cbc.RecordDeleted,''N'') <> ''Y''
AND IsNull(c.RecordDeleted,''N'') <> ''Y''
AND IsNull(s.RecordDeleted,''N'') <> ''Y''
AND IsNull(ccp.RecordDeleted,''N'') <> ''Y''
AND IsNull(cp.RecordDeleted,''N'') <> ''Y''

IF (@Med1 = ''Y'' OR @Med2 = ''Y'') AND (@Min < ''20120701'' AND @Max >=''20120701'') --If any Medicaid and range crosses 7/1/12
BEGIN
	UPDATE ClaimBatches
	SET BatchProcessProgress = 0
	WHERE ClaimBatchId = @ClaimBatchId
	
	RETURN
	
END
ELSE IF (@Med1=''Y'' AND @Med2=''Y'') AND (@MAX >= ''20120701'' AND @MIN >= ''20120701'')  --All Medicaid and date range is after 7/1/12
BEGIN
	--Do MITS Stuff
	UPDATE ClaimBatches
	SET ClaimFormatId = 10008
	WHERE ClaimBatchId = @ClaimBatchId
	
	EXEC csp_PMClaims837ProfessionalMITS @CurrentUser,@ClaimBatchId
	
END
ELSE IF (@Med1=''N'' AND @Med2=''N'') OR (@Min < ''20120701'' AND @Max < ''20120701'') --All non-Medicaid or all dates are before 7/1/12
BEGIN
	--Do MACSIS Stuff
	UPDATE ClaimBatches
	SET ClaimFormatId = 10003
	WHERE ClaimBatchId = @ClaimBatchId
	
	EXEC csp_PMClaims837ProfessionalMACSIS5010 @CurrentUser,@ClaimBatchId
END
ELSE
	UPDATE ClaimBatches
	SET BatchProcessProgress = 0
	WHERE ClaimBatchId = @ClaimBatchId
	
	RETURN

END

' 
END
GO
