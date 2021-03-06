/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataFromAlertClientGlobalCodes]    Script Date: 11/18/2011 16:25:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataFromAlertClientGlobalCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataFromAlertClientGlobalCodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataFromAlertClientGlobalCodes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create  PROCEDURE  [dbo].[ssp_SCGetDataFromAlertClientGlobalCodes]             
              
   @StaffId int             
As              
                      
Begin                      
/*********************************************************************/                        
/* Stored Procedure: dbo.ssp_SCGetDataFromAlertClientGlobalCodes                */               
              
/* Copyright: 2005 Provider Claim Management System             */                        
              
/* Creation Date:  17/10/2006                                    */                        
/*                                                                   */                        
/* Purpose: Gets Data from  Alert & Client & GlobalCode Table*/                       
/*                                                                   */                      
/* Input Parameters: None */                      
/*                                                                   */                         
/* Output Parameters:                                */                        
/*                                                                   */                        
/* Return:   */                        
/*                                                                   */                        
/* Called By: getAlerts()  Method in MSDE Class Of DataService  in "Always Online Application"      */              
              
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/*   Updates:                                                          */                        
              
/*       Date              Author                  Purpose                                    */                        
/* 17/10/2006    Piyush Gajrani           Created                                    */                   
/* 12/12/2007 Tom Remisoski   Alerts for Inactive Clients allowed.     */            
/* 26/02/2008 VinduPuri for alerts modified*/      
/* 19/Jan/2009 Rohit Verma added space between Staff lastname and firstname*/  
/* 20/Oct/2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
							why:task #609, Network180 Customization    */  
/*********************************************************************/                         
                    
              
     
select a.alertid,b.clientid,c.staffid,d.CodeName as Code,a.message,cast(convert(varchar,a.DateReceived,101)as datetime) as DateReceived,      
--Commented By Pramod On 3 March 2008      
--rtrim(b.lastname) as FromLastName, rtrim(b.firstname) as FromFirstName,      
--Code added by Pramod this will contact lastname and first name   
 -- Modified by   Revathi   20/Oct/2015 
case when  ISNULL(b.ClientType,''I'')=''I'' then isnull(rtrim(ISNULL(b.lastname,'''')) +'', ''+ rtrim(ISNULL(b.firstname,'''')),'''') else ISNULL(b.OrganizationName,'''') end as FromName,      
a.Subject,a.FollowUp,a.Reference,      
--Commented By Pramod on 3 march 2008      
--rtrim(c.lastname) as StaffLastName, rtrim(c.firstname) as        
--code added by pramod on 3 march 2008 to concat stafflast name and staff first name      
isnull(rtrim(c.lastname)+ '', ''+ rtrim(c.firstname),'''') as StaffName,         
a.AlertType,a.RecordDeleted,DC.DocumentCodeId ,        
--code added by pramod now rererence will be return from stored procedure      
isnull(doc.documentname,'''')  as Reference            
 from alerts a left join clients b on a.clientid=b.clientid and isnull(b.recorddeleted,''N'') <>''Y''  --and b.active=''Y''            
 join staff c on a.tostaffid=c.staffid left join GlobalCodes d on a.alerttype=d.GlobalCodeId        
 left join Documents DC on a.reference=DC.DocumentId    
-- and a.reference IS NOT NULL      
left join documentcodes doc on dc.documentcodeid=doc.documentcodeid      
where isnull(a.recorddeleted,''N'')<>''Y'' and  c.staffid=@StaffId       
      
        
              
  --Checking For Errors              
  If (@@error!=0)              
  Begin              
   RAISERROR  20006   ''ssp_SCGetDataFromAlertClientGlobalCodes: An Error Occured''               
   Return           
   End                       
                      
              
End
' 
END
GO
