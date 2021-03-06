/****** Object:  StoredProcedure [dbo].[csp_PopulateCustomU277ReportData]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PopulateCustomU277ReportData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PopulateCustomU277ReportData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PopulateCustomU277ReportData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_PopulateCustomU277ReportData] as

;with gsSegments as (
	select *
	from Custom999ProcessWorkingSet
	where SegmentName = ''GS''
),	
stSegments as (
	select *
	from Custom999ProcessWorkingSet
	where SegmentName = ''ST''
),	
trnSegments as (
	select *
	from Custom999ProcessWorkingSet
	where SegmentName = ''TRN''
),
svcSegments as (
	select *
	from Custom999ProcessWorkingSet
	where SegmentName = ''SVC''
),
stcSegments as (
	select *
	from Custom999ProcessWorkingSet
	where SegmentName = ''STC''
),
u277 (DateProcessed, SenderId, ClaimLineItemId, BillingCode, Error1, Error2, SenderControlNumber) as (
	select CAST(dbo.csf_GetDelimitedStringElement(gsSegments.SegmentData, ''*'', 4) as datetime) as DateProcessed,
	dbo.csf_GetDelimitedStringElement(gsSegments.SegmentData, ''*'', 2) as SenderId,
	CAST(dbo.csf_GetDelimitedStringElement(dbo.csf_GetDelimitedStringElement(trnSegments.SegmentData, ''*'', 2), ''-'', 2) as bigint) as ClaimLineItemId,
	dbo.csf_GetDelimitedStringElement(svcSegments.SegmentData, ''*'', 1) as BillingCode,
	dbo.csf_GetDelimitedStringElement(stcSegments.SegmentData, ''*'', 1) as Error1,
	dbo.csf_GetDelimitedStringElement(stcSegments.SegmentData, ''*'', 10) as Error2,
	dbo.csf_GetDelimitedStringElement(stSegments.SegmentData, ''*'', 2) as SenderControlNumber
	--,
	--trnSegments.LineNumber, trnSegments.SegmentData, stcSegments.LineNumber, stcSegments.SegmentData,
	--svcSegments.LineNumber, svcSegments.SegmentData
	from gsSegments
	-- multiple children for GS parent
	join trnSegments on trnSegments.LineNumber > gsSegments.LineNumber
		and not exists (
			select *
			from Custom999ProcessWorkingSet as gs2
			where gs2.SegmentName = ''GS''
			and gs2.LineNumber < trnSegments.LineNumber
			and gs2.LineNumber > gsSegments.LineNumber
		)
	join stSegments on stSegments.LineNumber > gsSegments.LineNumber
		and not exists (
			select *
			from Custom999ProcessWorkingSet as gs2
			where gs2.SegmentName = ''GS''
			and gs2.LineNumber < stSegments.LineNumber
			and gs2.LineNumber > gsSegments.LineNumber
		)
	-- only one svc segment for a trn
	join svcSegments on svcSegments.LineNumber = (
				select MIN(LineNumber)
				from Custom999ProcessWorkingSet as svc2
				where svc2.SegmentName = ''SVC''
				and svc2.LineNumber > trnSegments.LineNumber
		)
	-- only one stc segment for a svc
	join stcSegments on stcSegments.LineNumber = (
				select MIN(LineNumber)
				from Custom999ProcessWorkingSet as stc2
				where stc2.SegmentName = ''STC''
				and stc2.LineNumber > svcSegments.LineNumber
		)
)
select u277.*
into #u277
from u277

delete from c
from CustomU277ReportData as c
join #u277 as u on u.SenderId = c.SenderId and u.SenderControlNumber = c.SenderControlNumber and u.ClaimLineItemId = c.ClaimLineItemId

--select claimlineitemid, COUNT(*) from #u277 group by ClaimLineItemId having COUNT(*) > 1

insert into CustomU277ReportData (
	SenderId,
	SenderControlNumber,
	DateProcessed,
	ClaimLineItemId,
	BillingCode,
	Error1,
	Error2
)
select
	SenderId,
	SenderControlNumber,
	DateProcessed,
	ClaimLineItemId,
	BillingCode,
	Error1,
	Error2
from #u277

' 
END
GO
