/****** Object:  StoredProcedure [dbo].[csp_SCGetClientInfoByclientID]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetClientInfoByclientID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetClientInfoByclientID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetClientInfoByclientID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     PROCEDURE [dbo].[csp_SCGetClientInfoByclientID]          
(          
 @ClientID int          
)          
As          
/*********************************************************************/                        
/* Stored Procedure: dbo.csp_SCGetClientInfoByclientID            */                        
/* Copyright: 2006 Smart Management System             */                        
/* Creation Date:  16/11/2005                                    */                        
/*                                                                   */                        
/* Purpose: It will retrieve Name and Address of customer and gaurdian Name And Address if any  */                       
/*                                                                   */                      
/* Input Parameters: @ClientID          */                      
/*                                                                   */                        
/* Output Parameters:                                */                        
/*                                                                   */                        
/*                                                                   */                        
/* Called By:                                                        */                        
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/* Updates:                                                          */                        
/*  Date          Author      Purpose                                    */                        
/* 6/11/2006    Neelam Prasad     Created                                    */                        
/*********************************************************************/                    
BEGIN          
SELECT   DISTINCT TOP 1   ISNULL(Clients.FirstName,'''') + '', '' + ISNULL(Clients.MiddleName,'''') + '' '' + ISNULL(Clients.LastName,'''') AS CustomerName,  ClientAddresses.Address AS CustomerAddress,           
                      ClientAddresses.City AS CustomerCity, ClientAddresses.State  AS CustomerState, ClientAddresses.Zip AS CustomerZip, ClientContactAddresses.City AS CustomerContactCity,           
                      ClientContactAddresses.Address AS ClientContactsAddress, ClientContactAddresses.State  AS ClientContactState, ClientContactAddresses.Zip AS ClientContactZip,           
                     ISNULL(ClientContacts.LastName,'''') + '', '' + ISNULL(ClientContacts.MiddleName,'''') + '' '' + ISNULL(ClientContacts.FirstName,'''')  AS CustomerContactName,  ISNULL(ClientContacts.Guardian,'''') AS GuardianStatus,           
                      Clients.ClientId          
FROM ClientContactAddresses 
RIGHT OUTER JOIN ClientContacts ON ClientContactAddresses.ClientContactId = ClientContacts.ClientContactId 
			and (ClientContactAddresses.RecordDeleted is null or ClientContactAddresses.RecordDeleted =''N'') 
			and isnull(clientcontacts.recorddeleted, ''N'') = ''N''  
RIGHT OUTER JOIN Clients ON ClientContacts.ClientId = Clients.ClientId 
			and clientcontacts.guardian=''Y'' 
			and (clientcontacts.Recorddeleted is null or clientcontacts.Recorddeleted =''N'') 
			and isnull(clients.recorddeleted, ''N'') = ''N''
LEFT  OUTER JOIN ClientAddresses ON Clients.ClientId = ClientAddresses.ClientId  
			and ( Clients.Recorddeleted is null  or Clients.Recorddeleted =''N'') 
			and isnull(ClientAddresses.recorddeleted, ''N'') = ''N''
WHERE (Clients.ClientId = @ClientID)           

        
SELECT  TOP 1   --3/23/2007 Modified by SRF to look for only current Medicaid Coverage
ClientCoveragePlans.ClientId AS ClientID, CoveragePlans.MedicaidPlan AS MedicaidPlan,
CoveragePlans.Active AS ACTIVE, ClientCoveragePlans.InsuredId  AS CoveragePlanId, 
CoveragePlans.CoveragePlanName AS CoveragePlanName        
FROM ClientCoveragePlans
INNER JOIN CoveragePlans ON ClientCoveragePlans.CoveragePlanId = CoveragePlans.CoveragePlanId
Join ClientCoverageHistory CH on ch.ClientCoveragePlanId = ClientCoveragePlans.ClientCoveragePlanId and isnull(ch.RecordDeleted, ''N'') = ''N''
WHERE (ClientCoveragePlans.ClientId =  @ClientId) 
and CoveragePlans.MedicaidPlan = ''Y''  
and isnull(CoveragePlans.RecordDeleted, ''N'') = ''N''
and isnull(ClientCoveragePlans.RecordDeleted, ''N'') = ''N'' 
and ch.StartDate <= convert(datetime, convert(varchar(24), getdate(), 101))
and (ch.EndDate >= convert(datetime, convert(varchar(24), getdate(), 101))
	or
     ch.EndDate is null
     )
    
select  primaryClinicianId  from Clients where ClientID=@ClientID      
        
          
END
' 
END
GO
