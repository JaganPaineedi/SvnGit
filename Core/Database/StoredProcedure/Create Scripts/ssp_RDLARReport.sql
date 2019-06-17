If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.ssp_RDLARReport') 
                  And Type In ( N'P', N'PC' )) 
 Drop Procedure dbo.ssp_RDLARReport
Go

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	This Report is used to summarize payments and charges by coverage plan.
--				This only includes services where they choose a coverageplan when
--				making a payment.
-- 02-DEC-2015  Govind			Modifed join logic for Woods Custom Reports Task#904.01 
-- 11-JUL-2016	Govind			Added  ISNULL(RecordDeleted, 'N') = 'N' Checks for 4 tables - Pathway Sup Go Live#167
-- 06-FAB-2017 Sanjay              what -: Modified Inner join to Left join for financialassignmentplans,financialassignments Table and Moved  RecordDeleted Check from where clause to join
---                                why-:AspenPointe-Environment Issues #129
-- 08-MAY-2017 Sanjay              what -: I have removed the pay.DateReceived from group by clause
---                                why-: max(pay.DateReceived) is not working AspenPointe-Environment Issues #129
---09-MAY-2017 Sanjay              what-: Tom has done modification on order of joins and commented  on payment datereceived check
--                                 why -:It was calculating wrong charges amount for client.(AspenPointe-Environment Issues #129)
---15 Nov 2018	MJensen			Correct Date of service range selection.  Correct include unbilled charges selection.  Core bugs 2677.
-- =============================================
create PROCEDURE [dbo].[ssp_RDLARReport]
	@UnbilledCharge Bit,
	@ServiceArea varchar(max),
	@Payer varchar(max),
	@Plan varchar(max),
	@Program varchar(max),
	@Location varchar(max),
	@DateOfServiceStart datetime,
	@DateOfServiceEnd datetime,
	@FinancialAssignment varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	
    -- Begin GL Summary
	SELECT	cp.CoveragePlanName as CoveragePlan,
			c.ClientId as ClientID,
			c.LastName as ClientLastName,
			c.FirstName as ClientFirstName,
			convert(varchar,max(pay.DateReceived),107) as LastPaymentDate,
			
			--select convert(varchar, getdate(), 107)
			pay.Amount as LastPaymentAmount,
			pay.unpostedamount,
			SUM(case when DATEDIFF(day, s.DateOfService, GETDATE()) >= 0 and DATEDIFF(day, s.DateOfService, GETDATE()) <= 30
						then ar.Amount
						else 0
				end
				) as Zeroto30Days,
			SUM(case when DATEDIFF(day, s.DateOfService, GETDATE()) > 30 and DATEDIFF(day, s.DateOfService, GETDATE()) <= 60
						then ar.Amount
						else 0
				end
				) as ThirtyOneto60Days,
			SUM(case when DATEDIFF(day, s.DateOfService, GETDATE()) >= 61 and DATEDIFF(day, s.DateOfService, GETDATE()) <= 90
						then ar.Amount
						else 0
				end
				) as SixtyOneto90Days,
			SUM(case when DATEDIFF(day, s.DateOfService, GETDATE()) >= 91 and DATEDIFF(day, s.DateOfService, GETDATE()) <= 120
						then ar.Amount
						else 0
				end
				) as NinetyOneto120Days,
			SUM(case when DATEDIFF(day, s.DateOfService, GETDATE()) >= 121 and DATEDIFF(day, s.DateOfService, GETDATE()) <= 180
						then ar.Amount
						else 0
				end
				) as OneTwentyOneto180Days,
			SUM(case when DATEDIFF(day, s.DateOfService, GETDATE()) >= 181 and DATEDIFF(day, s.DateOfService, GETDATE()) <= 360
						then ar.Amount
						else 0
				end
				) as OneEightyOneto360Days,
			SUM(case when DATEDIFF(day, s.DateOfService, GETDATE()) > 360
						then ar.Amount
						else 0
				end
				) as Over360Days
			
	FROM Charges ch
		join Services s on ch.ServiceId = s.ServiceId
		join Clients c on s.ClientId = c.ClientId
		join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId
		join CoveragePlans cp on ccp.CoveragePlanId = cp.CoveragePlanId
		join ARLedger ar on ar.ChargeId = ch.ChargeId
		join Programs p on p.ProgramId = s.ProgramId
		left join Payments pay on (pay.ClientId = c.ClientId or Pay.coverageplanid=cp.coverageplanid) AND ISNULL(pay.RecordDeleted,'N') = 'N'
			and not exists (select *
							from Payments pay2
							where (pay2.ClientId = pay.ClientId
							or pay.CoveragePlanId = pay2.CoveragePlanId)
							and (pay2.DateReceived > pay.DateReceived or (pay2.DateReceived = pay.DateReceived and pay2.PaymentId > pay.PaymentId))
							--and pay2.DateReceived > s.DateOfService
							--and pay2.DateReceived < s.EndDateOfService        
							and ISNULL(pay2.RecordDeleted, 'N') = 'N'
							)
		join Payers Paye on Paye.PayerId = cp.payerid--woods cus.reports task#904.01
		--------Task AspenPointe-Environment Issues #129 ON 06-FAB-2016 Modifed by SANJAY from INNER JOIN to LEFT JOIN and and Moved RecordDeleted Check from where clause to join for financialassignmentplans,financialassignments Table---
		LEFT join financialassignmentplans fap on fap.coverageplanid = cp.coverageplanid AND ISNULL(fap.RecordDeleted,'N') = 'N'--woods cus.reports task#904.01  
		LEFT join financialassignments fa on fa.financialassignmentid = fap.financialassignmentid AND ISNULL(fa.RecordDeleted,'N') = 'N'--woods cus.reports task#904.01  
		where s.Status = 75
		
		and s.DateOfService >=  ISNULL(@DateOfServiceStart, '1/1/1753')
		and cast(s.DateOfService as date) <= @DateOfServiceEnd
		And (@UnbilledCharge = 1 
			Or @UnbilledCharge = 0 And ch.firstbilleddate is not null)
		and (@ServiceArea is null or p.ServiceAreaId in (select CAST(item as int) from dbo.fnSplit(@ServiceArea, ',')))
		and (@Payer is null or paye.PayerId in (select CAST(item as int) from dbo.fnSplit(@Payer, ',')))--woods cus.reports task#904.01
		and (@Program is null or s.ProgramId in (select CAST(item as int) from dbo.fnSplit(@Program, ',')))
		and (@Location is null or s.LocationId in (select CAST(item as int) from dbo.fnSplit(@Location, ',')))
		and (@Plan is null or ccp.CoveragePlanId in (select CAST(item as int) from dbo.fnSplit(@Plan, ',')))
		and (@FinancialAssignment is null or fa.financialassignmentid in (select CAST(item as int) from dbo.fnSplit(@FinancialAssignment, ',')))--woods cus.reports task#904.01
		and ISNULL(ch.RecordDeleted, 'N') = 'N'
		and ISNULL(s.RecordDeleted, 'N') = 'N'
		and ISNULL(c.RecordDeleted, 'N') = 'N'
		and ISNULL(ccp.RecordDeleted, 'N') = 'N'
		and ISNULL(cp.RecordDeleted, 'N') = 'N'
		and ISNULL(ar.RecordDeleted, 'N') = 'N'
		and ISNULL(p.RecordDeleted, 'N') = 'N'
		--Record Deleted Checks for the below tables Added on 07/11/16 - Pathway Sup Go Live#167-------------------------
		AND ISNULL(paye.RecordDeleted,'N') = 'N'
		AND ISNULL(fap.RecordDeleted,'N') = 'N'
		AND ISNULL(fa.RecordDeleted,'N') = 'N'
		----------------------------------------------------------------------------------------------------------------
	group by cp.CoveragePlanName, c.ClientId, c.LastName, c.FirstName, pay.Amount,pay.UnpostedAmount---Modified BY Sanjay on 08-MAY-2017 (I have removed the pay.DateReceived from group by clause)
	
END







GO


