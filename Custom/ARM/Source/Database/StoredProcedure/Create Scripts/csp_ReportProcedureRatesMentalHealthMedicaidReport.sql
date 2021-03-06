/****** Object:  StoredProcedure [dbo].[csp_ReportProcedureRatesMentalHealthMedicaidReport]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportProcedureRatesMentalHealthMedicaidReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportProcedureRatesMentalHealthMedicaidReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportProcedureRatesMentalHealthMedicaidReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     Procedure [dbo].[csp_ReportProcedureRatesMentalHealthMedicaidReport]  
@CoveragePlanTemplate int
   
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
**  --------	--------   	-------------------------------------------  
*******************************************************************************/  
Declare @Date datetime

Set @Date = convert(varchar(20), getdate(), 101)
  
select 
sc.organizationname, billingcode,  modifier1, pc.displayas, 
case when isnull(notbillable, ''Y'') = ''Y'' then ''N'' else ''Y'' end as Billable, 
minunits, maxunits, unitincrements, unitslist,
fromdate, todate, amount, 
case when chargetype = ''E'' then ''For Exactly''
	when chargetype = ''R'' then ''For a Range of''
	when chargetype = ''P'' then ''Per''
end as chargetype, 
fromunit, tounit, gc.codename
, billingcodeclaimunits, 
case when billingcodeunittype = ''A'' then ''Unit Always'' 
	 when billingcodeunittype = ''P'' then ''Unit Per''
end as billingcodeunittype, 
case when billingcodeunittype = ''A'' then NULL else billingcodeunits end as billingcodeunits,
case when isnull(billingcodeunittype, ''X'') = ''P'' then gc.codename else NULL end as ''BillingCodeDuration'' ,
RequiresTimeInTimeOut
from procedurecodes pc
join globalcodes gc on gc.globalcodeid = pc.enteredas
join systemconfigurations sc on sc.organizationname = sc.organizationname
left join procedurerates pr on pr.procedurecodeid = pc.procedurecodeid 
							and isnull(pr.recorddeleted, ''N'') = ''N''
							and ((@CoveragePlanTemplate is not null and pr.CoveragePlanId = @CoveragePlanTemplate)
									OR
									(@CoveragePlanTemplate is null and pr.CoveragePlanId is null)
								)
							and (notbillable = ''Y''
								 OR (fromdate <= @Date
									and (todate >= @Date or todate is null)
									)
								)
where pc.active = ''Y''
and (fromdate is not null or (fromdate is null and notbillable = ''Y''))
and isnull(pr.billingcode, '''') <> ''''
and isnull(pc.recorddeleted,''N'') = ''N''
order by  pr.billingcode, pr.modifier1, pc.displayas,fromdate
' 
END
GO
