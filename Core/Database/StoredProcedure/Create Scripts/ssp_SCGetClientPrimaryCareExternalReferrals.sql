
/****** Object:  StoredProcedure [dbo].[SSP_SCGetClientPrimaryCareExternalReferrals]    Script Date: 05/15/2013 18:38:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetClientPrimaryCareExternalReferrals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetClientPrimaryCareExternalReferrals]
GO



/****** Object:  StoredProcedure [dbo].[SSP_SCGetClientPrimaryCareExternalReferrals]    Script Date: 05/15/2013 18:38:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--SSP_SCGetClientPrimaryCareExternalReferrals 2110308

CREATE PROCEDURE [dbo].[SSP_SCGetClientPrimaryCareExternalReferrals] --8016
	@ClientId int
	
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 25.05.2014	Vaibhav Khare		Commiting on DEV environment 
-- 01.Aug.2016	Chethan N		What : Added column 'ReferringProviderId' to table 'ClientPrimaryCareExternalReferrals'
--								Why : Engineering Improvement Initiatives- NBL(I) task# 388
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
    Left Join ExternalReferralProviders ERPV on ERPV.ExternalReferralProviderId = CPCR.ProviderName  AND ISNULL(ERPV.RecordDeleted,'N')<>'Y'      
  WHERE ClientId=@ClientId AND ISNULL(CPCR.RecordDeleted,'N')<>'Y'   
 --------ClientPrimaryCareExternalReferral   
 SELECT [ClientPrimaryCareExternalReferralId]    
      ,CPCER.[CreatedBy]    
      ,CPCER.[CreatedDate]    
      ,CPCER.[ModifiedBy]    
      ,CPCER.[ModifiedDate]    
      ,CPCER.[RecordDeleted]    
      ,CPCER.[DeletedBy]    
      ,CPCER.[DeletedDate]    
   ,CPCER.[ClientId]    
      ,[ReferralDate]    
      ,[ProviderType]    
       ,ERPV.ExternalReferralProviderId AS 'ExternalReferralProviderId'     
      ,CPCER.ProviderInformation  
      ,[ReferralReason1]    
      ,[ReferralReason2]    
      ,[ReferralReason3]    
      ,[ReasonComment]    
      ,[AppointmentDate]    
      ,[AppointmentTime]    
      ,[AppointmentComment]    
      ,[PatientAppointment]    
      ,[Reason]    
      ,[ReceiveInformation]    
      ,[FollowUp]    
      ,[Status]    
      ,[FollowUpComment]    
      ,ERPV.[Name] as 'ExternalReferralProviderIdText'  
      ,dbo.csf_GetGlobalCodeNameById(Status) AS 'StatusText'  
      ,dbo.csf_GetGlobalCodeNameById(ProviderType) AS 'ProviderTypeText' 
	  ,CPCER.ReferringProviderId
	  ,S.DisplayAs AS ReferringProviderName
  FROM [ClientPrimaryCareExternalReferrals] AS CPCER     
 -- commented for 441 
-- Left Join ExternalReferralProviders ERPV on ERPV.ExternalReferralProviderId = CPCER.ProviderName AND ISNULL(ERPV.RecordDeleted,'N')<>'Y'
 Left Join ExternalReferralProviders ERPV on ERPV.ExternalReferralProviderId = CPCER.ExternalReferralProviderId AND ISNULL(ERPV.RecordDeleted,'N')<>'Y'
  
  LEFT JOIN Staff S ON S.StaffId = CPCER.ReferringProviderId       
  WHERE CPCER.ClientId=@ClientID AND ISNULL(CPCER.RecordDeleted,'N')<>'Y' 
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


