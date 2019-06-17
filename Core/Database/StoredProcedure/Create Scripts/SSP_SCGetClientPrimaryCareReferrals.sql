
/****** Object:  StoredProcedure [dbo].[SSP_SCGetClientPrimaryCareReferrals]    Script Date: 05/15/2013 18:38:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetClientPrimaryCareReferrals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetClientPrimaryCareReferrals]
GO


/****** Object:  StoredProcedure [dbo].[SSP_SCGetClientPrimaryCareReferrals]    Script Date: 05/15/2013 18:38:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCGetClientPrimaryCareReferrals]
	@ClientId int
	-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 25.05.2014	Vaibhav Khare		Commiting on DEV environment 
-- =============================================
AS
BEGIN

 Begin try 
 SELECT [ClientPrimaryCareReferralId]    
      ,CPCR.[CreatedBy]    
      ,CPCR.[CreatedDate]    
      ,CPCR.[ModifiedBy]    
      ,CPCR.[ModifiedDate]    
      ,CPCR.[RecordDeleted]    
      ,CPCR.[DeletedDate]    
      ,CPCR.[DeletedBy]    
      ,[ClientId]    
      ,[ReferralDate]    
      ,[ReferralType]    
      ,[ReferralSubType]    
      ,[ProviderType]    
      ,ERPV.ExternalReferralProviderId AS 'ProviderName'    
      ,[ContactName]    
      ,CPCR.ProviderInformation    
      ,[ReferralReason1]    
      ,[ReferralReason2]    
      ,[ReferralReason3]    
      ,[Comment]    
  FROM [ClientPrimaryCareReferrals] CPCR  
    Left Join ExternalReferralProviders ERPV on ERPV.ExternalReferralProviderId = CPCR.ProviderName  WHERE  ISNULL(ERPV.RecordDeleted,'N')<>'Y'  AND  ISNULL(CPCR.RecordDeleted,'N')<>'Y' AND [ClientId] = @ClientId
    end try                                                      
                                                                                      
BEGIN CATCH          
        
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetClientFinancialSummaryReports')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                   
 RAISERROR                                                                                     
 (                                                       
  @Error, -- Message text.                                                                                    
  16, -- Severity.                                                                                    
  1 -- State.                                                                                    
 );                                                                                 
END CATCH 
END

GO





