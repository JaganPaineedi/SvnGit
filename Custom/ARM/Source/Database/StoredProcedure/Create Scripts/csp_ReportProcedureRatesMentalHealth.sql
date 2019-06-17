/****** Object:  StoredProcedure [dbo].[csp_ReportProcedureRatesMentalHealth]    Script Date: 04/18/2013 11:31:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportProcedureRatesMentalHealth]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportProcedureRatesMentalHealth]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportProcedureRatesMentalHealth]    Script Date: 04/18/2013 11:31:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





create     Procedure [dbo].[csp_ReportProcedureRatesMentalHealth]  

   
AS  
  
/******************************************************************************  
**  
**  This template can be customized:  
**                
**  Return values:  
**   
**  Called by:     
**                
**  Parameters:  
**  Input       Output  
**     ----------       -----------  
**  
 srf 4/10/2008 Created
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Author:	Date:    	Description:  
**  wherman	02/04/2013	Replaced alpha codes with globalcodes  
*******************************************************************************/  
Declare @Date datetime

Set @Date = convert(varchar(20), getdate(), 101)
  
select 
sc.organizationname
,pr.billingcode
,pr.modifier1
,pc.displayas
, 
case when isnull(pc.notbillable, 'Y') = 'Y' then 'N' else 'Y' end as Billable
,pc.minunits
,pc.maxunits
,pc.unitincrements
,pc.unitslist
,pr.fromdate 
,pr.todate
,pr.amount
, 
case when gc.GlobalCodeId = 6762 then 'For Exactly'
	when gc.GlobalCodeId = 6763 then 'For a Range of'
	when gc.GlobalCodeId = 6761 then 'Per'
end as chargetype
,fromunit
,tounit
,gc.codename
,billingcodeclaimunits
, 
case when billingcodeunittype = 6762 then 'Unit Always' 
	 when billingcodeunittype = 6761 then 'Unit Per'
end as billingcodeunittype
, 
case when billingcodeunittype = 6762 then NULL else billingcodeunits end as billingcodeunits
,
case when isnull(billingcodeunittype, 0) = 6761 then gc.codename else NULL end as BillingCodeDuration --should 0 be some other code?  was 'X'
,RequiresTimeInTimeOut
from procedurecodes pc
join globalcodes gc on gc.globalcodeid = pc.enteredas
join systemconfigurations sc on sc.organizationname = sc.organizationname  
left join procedurerates pr on pr.procedurecodeid = pc.procedurecodeid 
							and pr.coverageplanid is null
							and isnull(pr.recorddeleted, 'N') = 'N'
							and (notbillable = 'Y'
								 OR (fromdate <= @Date
									and (todate >= @Date or todate is null)
									)
								)
where pc.active = 'Y'
and (fromdate is not null or (fromdate is null and notbillable = 'Y'))
and not exists (select * from procedurerateprograms prp
							where prp.procedurerateid = pr.procedurerateid
							and prp.programid = 35 -- PrimaryCare
							and isnull(prp.recorddeleted, 'N')= 'N')
and isnull(pc.recorddeleted,'N') = 'N'
order by  pr.billingcode, pr.modifier1, pc.displayas,fromdate

GO

