/****** Object:  StoredProcedure [dbo].[csp_ReportActivePharmacies]    Script Date: 11/18/2011 16:25:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportActivePharmacies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportActivePharmacies]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportActivePharmacies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create     Procedure [dbo].[csp_ReportActivePharmacies]  
   
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
  
Select PharmacyName,
		PhoneNumber,
		FaxNumber,
		Address,
		City,
		State,
		ZipCode
From Pharmacies
Where Active = ''Y''
and isnull(recorddeleted, ''N'')= ''N''
and isnull(PharmacyName, '''') <> ''''
Order by PharmacyName
' 
END
GO
