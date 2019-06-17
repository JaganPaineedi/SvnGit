/****** Object:  StoredProcedure [dbo].[SSP_SCGETDATAFROMGLOBALCODES]    ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGETDATAFROMGLOBALCODES]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGETDATAFROMGLOBALCODES];
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGETDATAFROMGLOBALCODES]    ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO  
CREATE PROCEDURE [DBO].[SSP_SCGETDATAFROMGLOBALCODES]   
      
As      
              
Begin              
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_SCGetDataFromGlobalCodes                */       
      
/* Copyright: 2005 Provider Claim Management System             */                
      
/* Creation Date:  27/10/2006                                    */                
/*                                                                   */                
/* Purpose: Gets Data From GlobalCodes  */               
/*                                                                   */              
/* Input Parameters: None */              
/*                                                                   */                 
/* Output Parameters:                                */                
/*                                                                   */                
/* Return:   */                
/*                                                                   */                
/* Called By: getGlobalCodes()  Method in MSDE Class Of DataService  in "Always Online Application"  */      
/*      */      
      
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/*   Updates:                                                          */                
      
/*       Date              Author                  Purpose                                    */                
/*  27/10/2006    Piyush Gajrani           Created       
/*  02/03/2009   Loveena          Modified(as per task#155 to remove Select * Statements from Stored Procedure*/                                   */                
/*   12/01/2012  Himanshu Chetal  Chnages made due to datamodel chnage. Removed two columns RowIdentifier and ExternalReferenceID and add one column Code */                          
/*  4/1/2012     Maninder         Modified(included Code in select statement)   */  
/*  08/08/2018   Rajeshwari S     Added logic to get globalcodes based on order by Sort Order. Task: Harbor - Support #1513 */   
/*********************************************************************/                 
        --Commented by Loveena in ref to Task#155 to Remove Select * Statement from Stored Procedure      
  --select * from dbo.GlobalCodes      
  -- Added by Loveena in ref to Task#155 to Remove Select * Statement from Stored Procedure      
  select GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,      
  ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color,--RowIdentifier,ExternalReferenceId,      
  CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DeletedBy,RecordDeleted,DeletedDate       
  from GlobalCodes where      
  isnull(GlobalCodes.RecordDeleted,'N') <> 'Y'          
  and GlobalCodes.Active = 'Y' 
  Order by SortOrder,CodeName    
  --Checking For Errors      
  If (@@error!=0)      
  Begin      
   RAISERROR  ('ssp_SCGetDataFromGlobalCodes: An Error Occured',16,1)       
   Return      
   End               
              
      
End      
      
      
      