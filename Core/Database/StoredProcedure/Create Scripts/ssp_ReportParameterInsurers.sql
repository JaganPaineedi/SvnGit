

/****** Object:  StoredProcedure [dbo].[ssp_ReportParameterInsurers]    Script Date: 09/06/2016 16:42:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ReportParameterInsurers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ReportParameterInsurers]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ReportParameterInsurers]    Script Date: 09/06/2016 16:42:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_ReportParameterInsurers]    
     
/****************************************    
Name:  csp_ReportCheckAffiliateId -- converted to ssp_ReportParameterInsurers    
Purpose: to gather Affiliate specific Id if needed for DW Reporting    
Created: APR-09-2014    
Created By: dharvey    
    
MODIFICATIONS:    
    
 Date  User   Description    
 ------  ----------  ------------------------    
     
****************************************/    
AS    
    
BEGIN
	BEGIN TRY  
    
  select InsurerId,  
         InsurerName  
  from Insurers  
 where IsNull(RecordDeleted, 'N') = 'N'  
 --and InsurerId in (7,8) -- Limited to SWMBH  
 order by InsurerName  
   
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ReportParameterInsurers') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                            
				16
				,-- Severity.                                                                                                            
				1 -- State.                                                                                                            
				);
	END CATCH
END
GO


