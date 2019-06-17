/****** Object:  StoredProcedure [dbo].[ssp_SCGetSites]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSites]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetSites]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSites]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE  [dbo].[ssp_SCGetSites]                   
As                             
Begin                            
/*********************************************************************/                              
/* Stored Procedure: dbo.ssp_SCGetSites               */                     
                    
/* Copyright: 2005 SmartCare Always online             */                              
                    
/* Creation Date:  05/03/2010                                  */                              
/*                                                                   */                              
/* Purpose: Gets Sites Details          */                             
/*                                                                   */                            
/* Input Parameters:      */                            
/*                                                                   */                               
/* Output Parameters:                                    */                              
/*                                                                   */                              
/* Return:   */                              
/*                                                                   */                              
/* Called By:         */                  
/*                                                                   */                              
/* Calls:                                                            */                              
/*                                                                   */                              
/* Data Modifications:                                               */                              
/*                                                                   */                              
/*   Updates:                                                          */                              
                    
/*       Date              Author- Priya                 Purpose - Get data from Insurers                                  */ 
/*      24/03/2014         Md Hussain Khusro             Fetching Active column to filter active records in code    */               
/*      26.May.2015			Rohith Uppin				 RecordDeleted column added. Task#147 CEI EIT    */                 
/*********************************************************************/                               
                          
 SELECT SiteId,ProviderId,SiteName,Active, RecordDeleted from sites  where   (RecordDeleted='N' or RecordDeleted is null)                 
                  
    --Checking For Errors                    
    If (@@error!=0)                    
     Begin                    
      RAISERROR  20006   'ssp_SCGetSites: An Error Occured'                     
     Return                    
     End                         
                       
                       
                    
End

GO


