
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataFromGlobalCodes]    Script Date: 03/02/2009 18:04:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

Create  PROCEDURE  [dbo].[ssp_SCGetDataFromGlobalCodes]

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
/*  02/03/2009	  Loveena				   Modified(as per task#155 to remove Select * Statements from Stored Procedure*/                                   */          
/*********************************************************************/           
        --Commented by Loveena in ref to Task#155 to Remove Select * Statement from Stored Procedure
		--select * from dbo.GlobalCodes
		-- Added by Loveena in ref to Task#155 to Remove Select * Statement from Stored Procedure
		select GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,
		ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color,RowIdentifier,ExternalReferenceId,
		CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DeletedBy,RecordDeleted,DeletedDate 
		from GlobalCodes where
		isnull(GlobalCodes.RecordDeleted,'N') <> 'Y'    
		and GlobalCodes.Active = 'Y'
		--Checking For Errors
		If (@@error!=0)
		Begin
			RAISERROR  20006   'ssp_SCGetDataFromGlobalCodes: An Error Occured' 
			Return
		 End         
        

End




 