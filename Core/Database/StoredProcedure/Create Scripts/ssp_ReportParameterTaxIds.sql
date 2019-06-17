
/****** Object:  StoredProcedure [dbo].[ssp_ReportParameterTaxIds]    Script Date: 09/06/2016 16:51:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ReportParameterTaxIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ReportParameterTaxIds]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ReportParameterTaxIds]    Script Date: 09/06/2016 16:51:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ReportParameterTaxIds]  
   
/****************************************  
Name:  csp_ReportCheckAffiliateId - Converted to ssp_ReportParameterTaxIds 
Purpose: to gather Affiliate specific Id if needed for DW Reporting  
Created: APR-09-2014  
Created By: dharvey  
  
MODIFICATIONS:  
  
 Date  User   Description  
 ------  ----------  ------------------------  
 12-July-2017  Sachin           What : Added 0 Instead of NULL ,becaues while opening the report it was trowing an error.
								Why : AspenPointe - Support Go Live #106

   
****************************************/  
AS  
  
BEGIN
	BEGIN TRY
  
 
select 'Print All' as ProviderTaxId, 0 as TaxId, 1 as OrderPriority
union
select distinct 
       p.ProviderName + ': ' + 
       case when s.TaxIdType = 'E' 
            then left(s.TaxId, 2) + '-' + substring(s.TaxId, 3, 7)
            else left(s.TaxId, 3) + '-' + substring(s.TaxId, 4, 2) + '-' + substring(s.TaxId, 6, 4) 
       end as ProviderTaxId,
       s.TaxId, 
       2 as OrderPriority
  from Providers p
       join Sites s on s.ProviderId = p.ProviderId
 where isnull(p.RecordDeleted, 'N') = 'N'
   and isnull(s.RecordDeleted, 'N') = 'N'
   and isnull(s.TaxId, '') <> ''
 order by OrderPriority, ProviderTaxId
 
 END TRY

 BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ReportParameterTaxIds') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


