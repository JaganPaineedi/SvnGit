IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetPrescriberProxies]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE ssp_SCGetPrescriberProxies
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
        
CREATE PROCEDURE [DBO].[ssp_SCGetPrescriberProxies] 
   @StaffId    int                                         
As                                                
                                                        
Begin                                                        
/*********************************************************************/                                                          
/* Stored Procedure: dbo.ssp_SCGetPrescriberProxies      */                                                 
                                                
/* Copyright: 2005 Provider Claim Management System      */                                                          
                                                
/* Creation Date:  30th Jan 2010                */                                                          
/*                                                                   */                                                          
/* Purpose: Gets Prescriber proxies staff        */                                                         
/*                                                                   */                                                        
/* Input Parameters: None  @CurrentLoginUser                         */                                 
/*                                                                   */                                                           
/* Output Parameters:             */                                                          
/*                                                                   */                                                          
/* Return:                */                                                          
/*                                                                   */                                                          
/* Called By:               */                                                
/*                  */         
/*                                                                   */                                                          
/* Calls:                                                            */                                                          
/*                                                                   */                                                          
/* Data Modifications:                                               */                                                          
/*                                                                   */                                                          
/*   Updates:                                                        */          
/*       Date              Author                  Purpose           */                                                          
/*  30th Jan2010      Chandan Srivastava           Created           */   
/*  04th April 2017   PranayBodhu               Replaced PrescriberProxies.DeletedBy with  PrescriberProxies.RecordDeleted w.r.t Van Buren - Support: #705 */                                                       
/*********************************************************************/                                                           
                                                
        
        
select PrescriberProxies.PrescriberId,rtrim(ltrim(lastName)) + ', ' + rtrim(FirstName) as StaffName         
from PrescriberProxies         
inner join staff s on s.StaffId = PrescriberProxies.PrescriberId        
where ProxyStaffId = @StaffId and ISNULL(PrescriberProxies.RecordDeleted,'N')<>'Y'        
order by StaffName asc                     
                                      
                                        
                                            
  --Checking For Errors                                                
  If (@@error!=0)                                                
  Begin                                       
   RAISERROR  ('ssp_SCGetPrescriberProxies: An Error Occured',16,1)                                                 
   Return                         
   End                                     
                   
                                             
End 


GO

