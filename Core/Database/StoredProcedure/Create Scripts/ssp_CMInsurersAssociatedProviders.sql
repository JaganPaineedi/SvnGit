IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_CMInsurersAssociatedProviders]') 
                  AND type IN ( N'P', N'PC' )) 
DROP PROCEDURE [dbo].[ssp_CMInsurersAssociatedProviders] 

GO
CREATE PROC [dbo].[ssp_CMInsurersAssociatedProviders]
(
@ProviderID int )
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_CMInsurersAssociatedProviders             */                  
/* Get Insurers list depends on the Provider Selected task #33 Contract Details: Insurer Drop Down is not binded to associated insurers     */                  
/* Project: Care Management to SmartCare Env. Issues Tracking Added by SuryaBalan 8-Oct-2014    
-- 03/15/2016	Alok Kumar		Added RecordDeleted and Active condition check in where clause for Insurers table for task#793 SWMBH - Support		*/                  
 
AS
Select PIn.ProviderInsurerId,PIn.InsurerId,I.InsurerName,PIn.ProviderId from ProviderInsurers PIn 
inner join Insurers I on I.InsurerId=PIn.InsurerId 
where PIn.ProviderId =@ProviderID and isNull(PIn.RecordDeleted,'N')<>'Y' AND isNull(I.RecordDeleted, 'N') <> 'Y' AND isNull(I.Active, 'N') = 'Y'

--Checking For Errors  
If (@@error!=0)  Begin  RAISERROR  20006 'ssp_CMInsurersAssociatedProviders  : An Error Occured'   Return  End  


  