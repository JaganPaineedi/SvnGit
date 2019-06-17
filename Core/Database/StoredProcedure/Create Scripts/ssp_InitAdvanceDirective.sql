

/****** Object:  StoredProcedure [dbo].[ssp_InitAdvanceDirective]    Script Date: 05/06/2016 16:09:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitAdvanceDirective]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitAdvanceDirective]
GO



/****** Object:  StoredProcedure [dbo].[ssp_InitAdvanceDirective]    Script Date: 05/06/2016 16:09:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE  PROCEDURE  [dbo].[ssp_InitAdvanceDirective]                  
(                                      
 @ClientID int,                
 @StaffID int,              
 @CustomParameters xml                                      
)                                                              
AS                                                                     
/********************************************************************************                                                    
-- Stored Procedure: ssp_InitAdvanceDirective  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose:To Initialize data for AdvanceDirective  
--  
-- *****History****  
-- 8/2/2013  Wasif Butt  Created  
-- 06/05/2016  Pradeep Kumar Yadav  Instead of join I made it left join because its not returning 
--                                  anything in case of New Client For Task #548 Interact Support   
*********************************************************************************/                                                                                        
BEGIN         
 BEGIN TRY     
                                      
  Select TOP 1 'AdvanceDirective' AS TableName,     
  -1 as 'DocumentVersionId',      
  '' as CreatedBy,                            
  getdate() as CreatedDate,                            
  '' as ModifiedBy,                            
  getdate() as ModifiedDate, 
		  CASE   
		  WHEN ISNULL(Cl.ClientType, 'I') = 'I'
		  THEN ISNULL(Cl.LastName, '') + ', ' + ISNULL(Cl.FirstName, '')  
		  ELSE ISNULL(Cl.OrganizationName, '')  
		  END AS ClientName,   
          IsNull(Ca.Address,'') + ' ' + ISnull(ca.City,'') + ' ' + isnull(ca.State,'') + ' ' + isnull(ca.Zip,'') as ClientAddress ,  
          C.Attorney1 ,  
          C.Attorney2 ,  
          C.Attorney3 ,  
          C.AnatomicalGift ,  
          C.AnatomicalGiftComment ,  
          C.RuleLimitationComment ,  
          C.ProlongedLife ,  
          C.PowerEffectiveDate ,  
          C.PowerEffectiveComment ,  
          C.PowerTerminateDate ,  
          C.PowerTerminateComment ,  
          C.SuccessorsToAgentName1 ,  
          C.SuccessorsToAgentAddress1 ,  
          C.SuccessorsToAgentPhone1 ,  
          C.SuccessorsToAgentName2 ,  
          C.SuccessorsToAgentAddress2 ,  
          C.SuccessorsToAgentPhone2 ,  
          C.OtherInstructions  
  from systemconfigurations s left outer join dbo.AdvanceDirective C                                                                          
  on s.Databaseversion = -1                                             
  join clients cl on cl.ClientId = @ClientID  
  left join dbo.ClientAddresses ca on cl.ClientId = ca.ClientId   
 END TRY                                                                                      
 BEGIN CATCH            
  DECLARE @Error varchar(8000)                                                         
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                       
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InitAdvanceDirective')                                                                                       
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


