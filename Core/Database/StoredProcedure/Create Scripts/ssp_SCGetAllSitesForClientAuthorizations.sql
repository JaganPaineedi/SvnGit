/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllSitesForClientAuthorizations]    Script Date: 05/22/2018 15:50:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAllSitesForClientAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAllSitesForClientAuthorizations]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[ssp_SCGetAllSitesForClientAuthorizations]               
(@ProviderID int)                        
as                       
/*********************************************************************/                        
/* Stored Procedure: ssp_SCGetAllSitesForClientAuthorizations                   */                        
/*           */                        
/*                                     */                        
/*                                                                   */                        
/* Purpose:   Populate All the Sites which are exist with ProviderId   */                        
/*                                                                   */                      
/* Input Parameters: @ProviderID - ProviderID   -     */                        
/*                                                                   */                        
/* Output Parameters:   None                                         */                        
/*                                                                   */                        
/* Return:  0=success, otherwise an error number                     */                        
/*                                                                   */                        
/* Called By:                                                        */                        
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/* Updates:                                                          */                        
/*    Date     Author       Purpose                                    */                        
/*                                  */                        
/*  8/1/2010  Ankesh        Created  */              
/* 05/22/2018	MSood		What: Added RecordDeleted and Active check 
							Why: Allegan - Support Task #1380 */
/*********************************************************************/                         
BEGIN        
    
 SELECT S.SiteId, S.SiteName,S.Active,S.RecordDeleted    
 FROM Sites S  WHERE S.ProviderId = @ProviderID    
 -- Msood 05/22/2018 
 and isnull(S.Active,'Y')='Y'
 and isnull(S.RecordDeleted,'N')='N'   
     
IF (@@error!=0)                        
    BEGIN                        
        RAISERROR  ('ssp_SCGetAllSitesForClientAuthorizations: An Error Occured',16,1)                        
        RETURN(1)           
    END                 
    RETURN(0)                        
END  
