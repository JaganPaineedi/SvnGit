


IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_CMGetMemberByContractId]') 
                  AND type IN ( N'P', N'PC' )) 
DROP PROCEDURE [dbo].[ssp_CMGetMemberByContractId] 

GO
Create Procedure [dbo].[ssp_CMGetMemberByContractId] 
( @ContractId int)  
As   
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_CMGetMemberByContractId            */                  
/* Copyright: 2005 Provider Claim Management System             */                  
/* Creation Date:  May 22/2014                                */                  
/*                                                                   */                  
/* Purpose: it will get all Members for a contractId.             */                 
/*                                                                   */                
/* Input Parameters: @Active          */                
/*                                                                   */                  
/* Output Parameters:                                */                  
/*                                                                   */                  
/* Return:Plan Records based on the applied filer  */                  
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/*  Date          Author      Purpose                                    */                  
/* May 22/2014    Shruthi.S   Created                                    */  
 /*  21 Oct 2015	Revathi	 what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 							why:task #609, Network180 Customization  */                   
/*********************************************************************/  
Begin Try
SELECT Distinct(Clients.ClientId),
--Added by Revathi   21 Oct 2015
case when  ISNULL(Clients.ClientType,'I')='I' then (IsNull(Clients.LastName,'') + ', ' + IsNull(Clients.FirstName,'')) else ISNULL(Clients.OrganizationName,'') end As MemberName 
,case when  ISNULL(Clients.ClientType,'I')='I' then (IsNull(Clients.LastName,'') + ' ' + IsNull(Clients.FirstName,'')) else ISNULL(Clients.OrganizationName,'') end  As MemberNameA
,case when  ISNULL(Clients.ClientType,'I')='I' then  rtrim(IsNull(Clients.LastName,'') + ', ' + IsNull(Clients.FirstName,'')) else ISNULL(Clients.OrganizationName,'') end + ' - ' + rtrim(ltrim(str(Clients.ClientId)))   as Member  
FROM    ContractRates,Clients Where ContractRates.ClientId = Clients.ClientId 
And ContractId = @ContractId
 And Clients.Active ='Y' And (Clients.RecordDeleted = 'N' or Clients.RecordDeleted is null )  
And (ContractRates.RecordDeleted = 'N' or ContractRates.RecordDeleted is null )

order by MemberName

End Try
Begin Catch            

declare @Error varchar(8000)                
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_CMGetMemberByContractId')                 
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                  
  + '*****' + Convert(varchar,ERROR_STATE())                
                  
 RAISERROR                 
 (                
  @Error, -- Message text.                
  16, -- Severity.                
  1 -- State.                
 )                
          
          
End Catch   
  