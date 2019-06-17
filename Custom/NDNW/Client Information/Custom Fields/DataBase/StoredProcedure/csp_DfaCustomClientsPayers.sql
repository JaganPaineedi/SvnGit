IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[csp_DfaCustomClientsPayers]' 
                              ) 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_DfaCustomClientsPayers] 

GO 
CREATE PROCEDURE [dbo].[csp_DfaCustomClientsPayers] (@ClientId INT)      
AS 

/*********************************************************************/ 
/* Stored Procedure: [csp_DfaCustomClientsPayers]               */ 
/* Creation Date:  6/9/2016                                    */ 
/* Author:  Hemant Kumar                     */ 
/* Purpose: To bind payer drop down after save */ 
/* Data Modifications:                   */ 
/*  Modified By    Modified Date    Purpose        */ 
/*                                                                   */ 
  /*********************************************************************/ 
       
Select     
PayerId,    
PayerName    
from     
Payers    
where PayerType =(select InsuranceType from CustomClients where clientid=@ClientId)     
and ISNULL(RecordDeleted,'N') <> 'Y' AND Active='Y'    
order by  PayerName    
    
    
    
  
  
  
  


