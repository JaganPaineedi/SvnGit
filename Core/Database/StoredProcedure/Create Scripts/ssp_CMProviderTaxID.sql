
/****** Object:  StoredProcedure [dbo].[ssp_CMProviderTaxID]    Script Date: 09/06/2016 17:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMProviderTaxID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMProviderTaxID]
GO


/****** Object:  StoredProcedure [dbo].[ssp_CMProviderTaxID]    Script Date: 09/06/2016 17:07:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[ssp_CMProviderTaxID]    
    
/*********************************************************************    
-- Stored Procedure: dbo.ssp_CMProviderTaxID    
-- Copyright: 2006 Streamline Healthcare Solutions    
-- Creation Date:  11/7/2006    
--    
-- Purpose: It gets the ProviderName and Tax ID for Print 1099 Form    
--    
-- Input Parameters:     
--    
-- Data Modifications:    
--    
-- Updates:     
--  Date            Author        Purpose    
-- 11/7/2006    Gursharan       Created    
--10 July 2014 Task #55 CM to SC Project, Created and Modified for CM Checks List Page to get Provider TaxId. Taken the SSP from 3.5x   
--08/22/2016   MD Hussain  Added distinct clause to filter data and sort the resultset by Provider Name in ascending order w.r.t task #483 SWMBH - Support
**********************************************************************/                     
as    
    
select distinct  0 as Checkbox, P.ProviderID,P.ProviderName , S.Taxid from Providers P  Left outer join Sites S on      
P.providerID = S.ProviderID and isNull(S.RecordDeleted,'N') = 'N' and S.Active = 'Y'  
where  isNull(P.RecordDeleted,'N') = 'N'   and P.active = 'Y'    
order by P.ProviderName
         
if @@error <> 0    
begin    
 RAISERROR('Error in ssp_CMProviderTaxID procedure', 16, 1)  
 return    
end    
    
    
return 
GO


