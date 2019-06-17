/****** Object:  StoredProcedure [dbo].[csp_ReportMMFaxFailure]    Script Date: 04/18/2013 10:22:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMMFaxFailure]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportMMFaxFailure]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportMMFaxFailure]    Script Date: 04/18/2013 10:22:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE     Procedure [dbo].[csp_ReportMMFaxFailure]    
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
**  Author: Date:     Description:    
**  -------- --------    -------------------------------------------    
*******************************************************************************/    
    
select cmsa.CreatedDate, c.ClientId, c.LastName +', ' + c.FirstName as ClientName,  
s.LastName +', ' + s.FirstName as CreatedBy, p.PharmacyName, p.FaxNumber, gc.CodeName AS 'FaxStatus'
from ClientMedicationScriptActivities as cmsa  
 join ClientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId  
 left outer join Pharmacies as p on p.PharmacyId = cmsa.PharmacyId  
 join Staff as s on s.UserCode = cmsa.CreatedBy  
 join Clients as c on c.ClientId = cms.ClientId  
 JOIN GlobalCodes gc ON gc.GlobalCodeId = cmsa.Status
 where  gc.codeName <> 'Successful'  
 and cmsa.method = 'F'  
 and isnull(cmsa.recorddeleted, 'N') ='N'  
 and isnull(cms.recorddeleted, 'N') ='N'  
 and convert(varchar(20), cmsa.CreatedDate, 101) >= @StartDate  
 and convert(varchar(20), cmsa.CreatedDate, 101) <= @EndDate  
order by cmsa.createddate desc  
  
  
GO

