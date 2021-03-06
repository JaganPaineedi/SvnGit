/****** Object:  StoredProcedure [dbo].[csp_ReportMMFaxSuccessRate]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMMFaxSuccessRate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportMMFaxSuccessRate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMMFaxSuccessRate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     Procedure [dbo].[csp_ReportMMFaxSuccessRate]  
@StartDate datetime,
@EndDate datetime
   
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
 
--5563	Successful
--5564	Failed
 
select cms.pharmacyid, PharmacyName,
Sum(case when cms.Status in (5563,5564) then 1 else 0 end) as Total,
Sum(case when cms.Status = 5563 then 1 else 0 end) as SUCCESS,
Sum(case when cms.Status = 5564 then 1 else 0 end) as FAILURE

from pharmacies as p 

join clientmedicationscriptactivities as cms on cms.pharmacyid = p.pharmacyid
where cms.method = ''F''
and	convert(varchar(20), cms.CreatedDate, 101) >= @StartDate
and convert(varchar(20), cms.CreatedDate, 101) <= @EndDate
and isnull(p.recorddeleted, ''N'')= ''N''
and isnull(cms.recorddeleted, ''N'')= ''N''

group by cms.pharmacyid, PharmacyName

order by 2
' 
END
GO
