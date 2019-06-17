
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitializeImmunizationDetail]    Script Date: 06/13/2015 17:23:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitializeImmunizationDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitializeImmunizationDetail]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_InitializeImmunizationDetail]    Script Date: 06/13/2015 17:23:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 CREATE PROCEDURE  [dbo].[ssp_InitializeImmunizationDetail]               
(                                  
 @StaffId int,            
 @ClientID int,            
 @CustomParameters xml                                  
)                                                          
As                                                                 
 Begin                                                                    
 /*********************************************************************/                                                                      
 /* Stored Procedure: [ssp_InitializeImmunizationDetail]               */                                                             
                                                             
                                                             
 /* Creation Date:  11/May/2011                                   */                                                                      
 /*                                                                   */                                                                      
 /* Purpose: To Initialize */                                                                     
 /*                                                                   */                                                                    
 /* Input Parameters:  */                                                                    
 /*                                                                   */                                                                       
 /* Output Parameters:                                */                                                                      
 /*                                                                   */                                                                      
 /* Return:   */                                                                      
 /*                                                                   */                                                                      
 /* Called By:Immunization Deatails    */                                                            
 /*      */                                                            
                                                             
 /*                                                                   */                                                                      
 /* Calls:                                                            */                                                                      
 /*                                                                   */                                                                      
 /* Data Modifications:                                               */                                                                      
 /*                                                                   */                                                                      
 /*   Updates:                                                          */                                                                      
                                                             
 /*       Date              Author                  Purpose                                    */                                                                      
 /*       11/May/2011       Ashwani             To Retrieve Data      */                                                                      
 /*       27/June/2011       Jagdeep              Added       */       
 /*		  18/Feb/2014		Chethan N			Changed Custom SP(CSP) to Core SP(SSP) since this is core SP */
 
 /*		04/Nov/2014       Vaibhav				Adding new table */
 /*********************************************************************/                                                                       
                                    
               
                          
SELECT             
 'ClientImmunizations' as TableName            
 ,-1 as ClientImmunizationId            
 ,@ClientID as ClientId            
 ,'' as CreatedBy,                      
 getdate() as CreatedDate,                      
 '' as ModifiedBy,                      
 getdate() as ModifiedDate  
 --@,StaffId as OrderingStaffId    
from systemconfigurations s left outer join ClientImmunizations            
on s.Databaseversion = -1            
       
                                      
SELECT            
 'ImmunizationDetails' as TableName              
 ,-1 as ImmunizationDetailId              
 ,-1 as ClientImmunizationId              
 ,'' as CreatedBy,                        
 getdate() as CreatedDate,                        
 '' as ModifiedBy,                        
 getdate() as ModifiedDate    
 --@,StaffId as OrderingStaffId      
from systemconfigurations s left outer join ImmunizationDetails              
on s.Databaseversion = -1                                      
                            
END                                    
                                      
--Checking For Errors                               
                              
If (@@error!=0)                               
                              
Begin                               
                              
RAISERROR 20006 '[ssp_InitializeImmunizationDetail] : An Error Occured'                               
                              
Return                               
                              
End     


GO

