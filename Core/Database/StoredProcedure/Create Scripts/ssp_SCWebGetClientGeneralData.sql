
/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientGeneralData]    Script Date: 05/15/2013 18:07:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetClientGeneralData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetClientGeneralData]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientGeneralData]    Script Date: 05/15/2013 18:07:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


    
      
                          
create procedure [dbo].[ssp_SCWebGetClientGeneralData]                  
@ClientID as bigint                                                                                                                                
                                                                                                                                
as                        
	-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 25.05.2014	Vaibhav Khare		Commiting on DEV environment 
-- 12.12.2015	Venkatesh MR		Make unique query of client coverage plan which same as in the main sp (ssp_SCWebGetClientData) Ref task-Valley Go Live Support 134
-- 11.Mar.2016	Rohith uppin		Join Modified for Coverage plans. Task#912 Riverwood-Support
-- 09.Jun.2016	Alok Kumar			Added column 'DoNotLeaveMessage' in ClientPhones for task#333 Engineering Improvement Initiatives- NBL(I)
-- =============================================                                                 
--ClientPhones                    
BEGIN
BEGIN TRY                                                                                                     
SELECT     ClientPhones.ClientPhoneId, ClientPhones.ClientId, ClientPhones.PhoneType, ClientPhones.PhoneNumber, ClientPhones.PhoneNumberText, ClientPhones.IsPrimary,                                             
                      ClientPhones.DoNotContact, ClientPhones.RowIdentifier, ClientPhones.ExternalReferenceId, ClientPhones.CreatedBy, ClientPhones.CreatedDate,                                             
                      ClientPhones.ModifiedBy, ClientPhones.ModifiedDate, ClientPhones.RecordDeleted, ClientPhones.DeletedDate, ClientPhones.DeletedBy,                                             
                      GlobalCodes.SortOrder ,ClientPhones.DoNotLeaveMessage   -- 09.Jun.2016	Alok Kumar                                         
FROM         ClientPhones INNER JOIN                                            
                      GlobalCodes ON ClientPhones.PhoneType = GlobalCodes.GlobalCodeId                                            
WHERE     (ClientPhones.ClientId = @ClientID) AND (ISNULL(ClientPhones.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND (ISNULL(GlobalCodes.RecordDeleted,                                             
                      'N') = 'N')                                                                                             
                                            
--ClientAddresses                         
SELECT     ClientAddresses.ClientAddressId, ClientAddresses.ClientId, ClientAddresses.AddressType, ClientAddresses.Address, ClientAddresses.City, ClientAddresses.State,                                             
               ClientAddresses.Zip, ClientAddresses.Display, ClientAddresses.Billing, ClientAddresses.RowIdentifier, ClientAddresses.ExternalReferenceId,                                             
                      ClientAddresses.CreatedBy, ClientAddresses.CreatedDate, ClientAddresses.ModifiedBy, ClientAddresses.ModifiedDate, ClientAddresses.RecordDeleted,                                        
      ClientAddresses.DeletedDate, ClientAddresses.DeletedBy, GlobalCodes.SortOrder                                            
FROM         ClientAddresses INNER JOIN                                           
                    GlobalCodes ON ClientAddresses.AddressType = GlobalCodes.GlobalCodeId                                            
WHERE  (ClientAddresses.ClientId = @ClientID) AND (ISNULL(ClientAddresses.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND                                             
                      (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')                               
                                                                         
--ClientEpisodes                                                                                                                                 
SELECT     0 AS DeleteButton, CE.ClientEpisodeId, CE.ClientId, CE.EpisodeNumber, CE.RegistrationDate, CE.Status, CE.DischargeDate, CE.InitialRequestDate, CE.IntakeStaff,                                               
                      CE.AssessmentDate, CE.AssessmentFirstOffered, CE.AssessmentDeclinedReason, CE.TxStartDate, CE.TxStartFirstOffered, CE.TxStartDeclinedReason,                                               
                      CE.RegistrationComment, CE.ReferralSource, CE.ReferralType, CE.ReferralComment, CE.HasAlternateTreatmentOrder, CE.AlternateTreatmentOrderType,                                               
                      CE.AlternateTreatmentOrderExpirationDate
                      --Added BY Rakesh-II Task 623            
				   ,CE.ReferralDate
				  ,CE.ReferralSubtype
				  ,CE.ReferralName
				  ,CE.ReferralAdditionalInformation
				  ,CE.ReferralReason1
				  ,CE.ReferralReason2
				  ,CE.ReferralReason3
				  ,CE.ExternalReferralInformation
					--ends here,
                      
                      -----commented by priyanka
                      -- CE.RowIdentifier, CE.ExternalReferenceId,
                        ,CE.CreatedBy, CE.CreatedDate, CE.ModifiedBy, CE.ModifiedDate,                                               
                      CE.RecordDeleted, CE.DeletedDate, CE.DeletedBy, GC.CodeName                                              
FROM         ClientEpisodes AS CE INNER JOIN                                              
                      Clients ON CE.ClientId = Clients.ClientId AND CE.EpisodeNumber = Clients.CurrentEpisodeNumber LEFT OUTER JOIN                                              
                      GlobalCodes AS GC ON CE.Status = GC.GlobalCodeId                                              
WHERE     (CE.ClientId = @ClientID) AND (CE.RecordDeleted IS NULL OR                                              
                      CE.RecordDeleted = 'N')                                              
                                              
 --ClientCoveragePlans                                                  
    select top (1)    
        a.CoveragePlanId,    
        a.InsuredId,    
        a.ClientId,    
        a.ClientCoveragePlanId,    
        c.COBOrder    
from    ClientCoveragePlans as a    
inner join CoveragePlans as b on b.CoveragePlanId = a.CoveragePlanId    
inner join ClientCoverageHistory as c on c.ClientCoveragePlanId = a.ClientCoveragePlanId    
where   a.ClientId = @ClientId    
        and b.MedicaidPlan = 'Y'    
        and ISNULL(a.RecordDeleted, 'N') <> 'Y'    
        and ISNULL(b.RecordDeleted, 'N') <> 'Y'    
        and ISNULL(c.RecordDeleted, 'N') <> 'Y'    
        and DATEDIFF(DAY, c.StartDate, GETDATE()) >= 0    
        and (    
             (c.EndDate is null)    
        or (DATEDIFF(DAY, c.EndDate, GETDATE()) <= 0)    
            )    
order by c.COBOrder                                              
END TRY                                            
         
                                                          
                                                                                                               
BEGIN CATCH          
        
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebGetClientGeneralData')                                                                                     
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


