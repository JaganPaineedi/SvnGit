IF OBJECT_ID('scsp_PMClaims837UpdateClaimLines','P') is not NULL
DROP PROC scsp_PMClaims837UpdateClaimLines
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[scsp_PMClaims837UpdateClaimLines] 
@CurrentUser VARCHAR(30), @ClaimBatchId INT, @FormatType CHAR(1) = 'P'
AS
/*********************************************************************/
/* Stored Procedure: dbo.scsp_PMClaims837UpdateClaimLines                         */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   */

/* Input Parameters:						     */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author      Purpose                                    */
/*  9/25/06   JHB	  Created                                    */
/* 04/28/2009 avoss		add npi for some comercial insurers			 */
/* 02/18/2010 avoss		changed npi sent for kalamazoo
   03/01/2010 avoss		changed npi sent for barry
   05/28/2010 avoss		send 1245559988 npi for FFS injectables	
   12/13/2017	MJensen	Update modifiers for BH Redesign		
   12/27/2017	MJensen	Call a separate procedure for BH redesign changes				
*/

declare @CurrentDate datetime

SET @CurrentDate = GETDATE()
/*
-- For BCBS Out Of State set facility information
update a 
set FacilityEntityCode = '77', FacilityName = a.PayToProviderLastName,
FacilityTaxIdType = '24', FacilityTaxId = a.PayToProviderTaxId,
FacilityAddress1 = PaymentAddress1, FacilityAddress2 = PaymentAddress2, 
FacilityCity = PaymentCity, FacilityState = PaymentState, FacilityZip = PaymentZip, 
FacilityProviderIdType = '1A', FacilityProviderId = '10497',
FacilityNPI = BillingProviderNPI
from #ClaimLines a
where a.ClaimFilingIndicatorCode = 'BL'
and substring(isnull(a.InsuredId,''), 1, 3) not in ('XYZ','XYP')

if @@error <> 0 goto error

-- For Medicare the billing provider id is first 7 characters of 
-- the rendering provider id
update #ClaimLines
set BillingProviderId = substring(RenderingProviderId, 1, 7)
where CoveragePlanId in (106, 107)

if @@error <> 0 goto error

--For BCBS set npi for staff without NPI Numbers av 7/24/2008
update a
	set RenderingProviderNPI = case when st.nationalProviderId is not null then st.NationalProviderId
							else '1952357410'
							END
from #ClaimLines a
join Locations b on b.LocationId = a.LocationId
Join Staff st on st.StaffId = a.ClinicianId
Where a.claimFilingIndicatorCode in ('BL')
if @@error <> 0 goto error

--For BCBS set referring Provider NPI for jail services
update a
	set  
	ReferringProviderNPI = RenderingProviderNPI,
	ReferringProviderLastname = RenderingProviderLastname,
	ReferringProviderFirstname = RenderingProviderFirstname						
from #ClaimLines a
join services s on s.ServiceId  = a.ServiceId
Where a.claimFilingIndicatorCode in ('BL')
and s.ProcedureCodeId in ( 73 ) --Jail Consult

if @@error <> 0 goto error

--
-- NPI Legacy Removal tax id removal -
--
--update a
--set BillingProviderTaxIdType = NULL,
--BillingProviderTaxId =NULL
--from #Claimlines a
--Where a.claimFilingIndicatorCode in ('BL')

/**/
--For CMW set Rendering Provider NPI as Barry NPI av 7/24/2008
update a
	set RenderingProviderNPI = '1952357410'
from #ClaimLines a
where a.CoveragePlanId = 170  --CMW

if @@error <> 0 goto error


--Send Rendering Provider NPI to plans sent to claims sent to cofinity
update a
	set RenderingProviderNPI = case when st.nationalProviderId is not null then st.NationalProviderId
							else '1952357410'
							END
from #ClaimLines a
join Locations b on b.LocationId = a.LocationId
Join Staff st on st.StaffId = a.ClinicianId
Where a.CoveragePlanId in ( 185, 15, 77  )  --cofinity, american community mutuual ins, GROUP MARKETING SERVICES



--Send Rendering Provider NPI to claims sent to the Following Commercial Coverages
update a
	set RenderingProviderNPI = case when st.nationalProviderId is not null then st.NationalProviderId
							else '1952357410'
							END
from #ClaimLines a
join Locations b on b.LocationId = a.LocationId
Join Staff st on st.StaffId = a.ClinicianId
Where a.CoveragePlanId in ( 5, 184, 147, 189  )  --Adminserv, Wellcare, Tricare, priority health


/**/
--For CA's set Rendering Provider NPI as Barry SA NPI av 7/24/2008
--For Kalamazoo Send 1952357410 npi
update a
	set RenderingProviderNPI = '1952357410'--'1457353146'  --SA NPI
	--,BillingProviderNPI = '1457353146'
--av
		,RenderingProviderLastname = 'Barry County Substance Abuse'
		,RenderingProviderFirstname = ''
from #ClaimLines a
where a.CoveragePlanId In ( 
201 --Kalamazoo SA
--select CoveragePlanId From coveragePlans where active='Y' and displayAs like 'SA_CA %'
)
if @@error <> 0 goto error

update a
	set 
		 RenderingProviderNPI = '1952357410'
--		 RenderingProviderNPI = '1457353146'  --SA NPI
		,RenderingProviderLastname = 'Barry County Community Mental Health Authority'
		,RenderingProviderFirstname = ''
--		,BillingProviderLastName = 'Barry County Community Mental Health Authority'
--		,BillingProviderFirstName = ''
	--,BillingProviderNPI = '1457353146'
from #ClaimLines a
where a.CoveragePlanId In ( 
202 --Venture SA
)
if @@error <> 0 goto error

/**/
--Remove Kalamazoo HF Modifiers for SA Claims sent to venture
update a
set
	Modifier1 = Modifier2,
	Modifier2 = Modifier3,
	Modifier3 = Modifier4,
	Modifier4 = null
from #ClaimLines a
where a.CoveragePlanId In ( 
202 --Venture SA
)
and Modifier1 = 'HF'
if @@error <> 0 goto error



--Remove all Modifiers for SA Services sent to Medicare
--Per Julie Webster 3/29/2010
update a
set
	Modifier1 = null,
	Modifier2 = null,
	Modifier3 = null,
	Modifier4 = null
from #ClaimLines a
where a.Modifier1 = 'HF'
and a.ClaimFilingIndicatorCode in ( 'MB' ) --Medicare
if @@error <> 0 goto error


--Remove NON HF SA Modifiers for Priority Health  Per Julie Webster / Jane Owen 01/20/2011
update a
set
	Modifier2 = null,
	Modifier3 = null,
	Modifier4 = null
from #ClaimLines a
where a.Modifier1 = 'HF'
and a.CoveragePlanId In ( 
189, --Priority Health
--srf 3-29-2011 added PRIOR232 per Julie W
131 -- PRIOR232  
)
if @@error <> 0 goto error


--select * from ProcedureCodes
--Remove NON HF SA Modifiers for Priority Health  Per Julie Webster / Jane Owen 01/20/2011
update a
set
	Modifier2 = null,
	Modifier3 = null,
	Modifier4 = null
from #ClaimLines a
join services s on s.ServiceId  = a.ServiceId
join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId 
Where a.CoveragePlanId in (
	189, --Priority Health
--srf 3-29-2011 added PRIOR232 per Julie W
131 -- PRIOR232  
)
and pc.DisplayAs like 'SA - %'
if @@error <> 0 goto error

--Per Julie Webster send 1245559988 as NPI for Injectables to Medicaid FFS - 05/28/2010 - av
update a
	set RenderingProviderNPI = '1245559988'
from #ClaimLines a
join services s on s.ServiceId  = a.ServiceId
Where a.CoveragePlanId in ( 104 )  --Medicaid FFS
and s.ProcedureCodeId in 
(
--Haldol D
 44
,45
,46
,47
,48
--Prolixin
,104
,105
,106
,107
--Risperdal
,179
)

*/

UPDATE a SET BillingProviderId = '1902084528', PayToProviderId = '1902084528'
FROM #ClaimLInes AS a
CROSS JOIN ClaimBatches AS b
WHERE b.ClaimBatchId = @ClaimBatchId
AND b.ClaimFormatId = 10003

-- The NPI that needs to be sent is coverage plan spacific in Ohio. - 8/27/2013 dknewtson
-- This assumes the Provider ID from Coverage Plans is pulled as the ProviderId in ssp_PMClaimsGetProviderIds
UPDATE	 #ClaimLines
SET		 BillingProviderNPI = BillingProviderId
		,PayToProviderNPI = PayToProviderId


--
-- Changes for BH Redesign - remove modifiers when billing by supervisor
--
IF EXISTS (
		SELECT *
		FROM ClaimBatches AS cb
		JOIN dbo.ssf_RecodeValuesCurrent('XBHREDESIGNCLAIMFORMATS') AS rcf ON rcf.IntegerCodeId = cb.ClaimFormatId
		WHERE cb.ClaimBatchId = @ClaimBatchId
		)
BEGIN
	EXEC csp_PMClaims837UpdateClaimLines @CurrentUser = @CurrentUser
		,@ClaimBatchId = @ClaimBatchId
		,@FormatType = @FormatType
END
error:



GO


