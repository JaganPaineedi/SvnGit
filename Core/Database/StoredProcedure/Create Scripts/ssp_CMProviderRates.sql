/****** Object:  StoredProcedure [dbo].[ssp_CMProviderRates]    Script Date: 11/18/2011 16:25:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMProviderRates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMProviderRates]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMProviderRates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE    PROCEDURE  [dbo].[ssp_CMProviderRates]
(
	@userid int
)

As  
Begin                    
/*********************************************************************/                        
/* Stored Procedure: dbo.ssp_ProviderRates                */                        
/* Copyright: 2005 Provider Claim Management System             */                        
/* Creation Date:  12/20/2005                                    */                        
/*                                                                   */                        
/* Purpose: Used in the provider rates screen to fill dropdowns         */                       
/*                                                                   */                      
/* Input Parameters:			            */                      
/*                                                                   */                        
/* Output Parameters:                                */                        
/*                                                                   */                        
/* Return:Member   */                        
/*                                                                   */                        
/* Called By:                                                        */                        
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/* Updates:                                                          */                        
/*  Date       	  Author       Purpose                                    */                        
/* 12/20/2005    Gursharan      Created                                    */              
/* 1/4/2006        Gursharan      Modified                                    */   
 /*  21 Oct 2015	Revathi		what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 								why:task #609, Network180 Customization  */                    
/*********************************************************************/                         

-- For Insurer
select distinct contracts.insurerid,insurers.insurername,providers.providerid from contracts,insurers,providers,userinsurers where  contracts.insurerid = insurers.insurerid and 
providers.providerid = contracts.providerid and userinsurers.userid = @userid and isnull(contracts.RecordDeleted,''N'') = ''N'' and isnull(insurers.RecordDeleted,''N'') = ''N''  order by insurers.insurername

-- For User Specific
/*select distinct contracts.insurerid,insurers.insurername,providers.providerid from contracts,insurers,providers,userinsurers 
where  contracts.insurerid = insurers.insurerid and 
providers.providerid = contracts.providerid and userinsurers.insurerid = contracts.insurerid and 
userinsurers.userid = @userid and isnull(contracts.RecordDeleted,''N'') = ''N'' and 
isnull(insurers.RecordDeleted,''N'') = ''N''  and
IsNull(UserInsurers.RecordDeleted,''N'')=''N''
order by insurers.insurername  */

--Checking For Errors
If (@@error!=0)  Begin  RAISERROR  20006     ''ssp_ProviderRates: An Error Occured''   Return  End                                   

-- For Sites
select distinct contractrates.siteid,sites.sitename,contracts.providerid from contractrates,sites,contracts where 
contractrates.siteid = sites.siteid  and contractrates.contractid = contracts.contractid and isnull(contractrates.RecordDeleted,''N'') = ''N'' and  isnull(contracts.RecordDeleted,''N'') = ''N'' 
and isnull(sites.RecordDeleted,''N'') = ''N''  order by sites.sitename

--Checking For Errors
If (@@error!=0)  Begin  RAISERROR  20006     ''ssp_ProviderRates: An Error Occured''   Return  End                                   

-- For Members
select distinct contractrates.clientid,
--Added by Revathi  21 Oct 2015 
(case when  ISNULL(clients.ClientType,''I'')=''I'' then ISNULL(clients.firstname,'''')+'' ''+ISNULL(clients.lastname,'''') else ISNULL(clients.OrganizationName,'''') end) as "Member Name"
--clients.firstname+'' ''+clients.lastname as "Member Name"
,contracts.providerid from contractrates,clients,contracts where 
contracts.contractid = contractrates.contractid and contractrates.clientid = clients.clientid  and isnull(contractrates.RecordDeleted,''N'') = ''N'' and isnull(contracts.RecordDeleted,''N'') = ''N''  and isnull(clients.RecordDeleted,''N'') = ''N''  order by "Member Name"

--Checking For Errors
If (@@error!=0)  Begin  RAISERROR  20006     ''ssp_ProviderRates: An Error Occured''   Return  End                                   

-- For Contracts
select contractid,contractname,contracts.providerid from contracts,providers where 
contracts.providerid = providers.providerid and isnull(contracts.RecordDeleted,''N'') = ''N'' order by contractname

-- For User Specific
/*select contractid,contractname,contracts.providerid 
from contracts,providers,insurers,userinsurers where 
contracts.providerid = providers.providerid 
and contracts.insurerid = userinsurers.insurerid
and contracts.insurerid = insurers.insurerid  
and userinsurers.userid = @userid 
--and providers.providerid = 179 
and isnull(contracts.RecordDeleted,''N'') = ''N'' 
and isnull(UserInsurers.RecordDeleted,''N'') = ''N'' 
order by contractname*/



--Checking For Errors
If (@@error!=0)  Begin  RAISERROR  20006     ''ssp_CMProviderRates: An Error Occured''   Return  End                                   

                     

End
' 
END
GO
