
/****** Object:  StoredProcedure [dbo].[ssp_CMGetBillingCodeValidMembers]    Script Date: 06/03/2014 11:33:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetBillingCodeValidMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetBillingCodeValidMembers]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetBillingCodeValidMembers]    Script Date: 06/03/2014 11:33:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE  PROCEDURE [dbo].[ssp_CMGetBillingCodeValidMembers]   
  
AS  
  
/**********************************************************************/                
/* Stored Procedure: dbo.ssp_GetBillingCodeValidMembers           */                
/* Copyright: 2005 Provider Claim Management System             */                
/* Creation Date:  01/03/2006                                    */                
     
/* Purpose: it will get all Members for Billing Codes            */               
/*                                                                   */              
/* Output Parameters:                                */                
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*Last Changed by Tarunjit on 1 March 2006 as to provide , between last name and first name    */                
/* Updates:                                                          */                
/*  Date          Author      Purpose                                    */                
/*  01/03/2006       Meenu      Created          */  
/* 01/08/2014	  Vichee	Added  order by for membername CM to SC #56*/
/*  21 Oct 2015	Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */   
 /*********************************************************************/              
  
 --Select 'All Members' as 'MemberName',0 as ClientId,0 as ProviderId  
 --union  all
 Select distinct (case when ISNULL(cl.ClientType,'I')='I' then  (ISNULL(cl.LastName,'''') + ' , ' + ISNULL(cl.FirstName,''''))  --Added by Revathi 21.Oct.2015   
 else ISNULL(cl.OrganizationName,'''') end ) as MemberName
 ,cl.ClientId,c.ProviderId  
 from Contracts as c
 inner join ContractRates as cr on cr.ContractId=c.ContractId and IsNull(cr.RecordDeleted,'N') <> 'Y'  
 inner join Clients as cl on cl.ClientId=cr.ClientId and cl.Active='Y' and IsNull(cl.RecordDeleted,'N') <> 'Y'  
 where IsNull(c.RecordDeleted,'N') <> 'Y'  order by MemberName   
 --and c.ProviderId=@ProviderId  
  
IF (@@error!=0)              
 BEGIN              
        RAISERROR  20005  'ssp_GetBillingCodeValidMembers: An Error Occured'              
        RETURN              
 END

GO


