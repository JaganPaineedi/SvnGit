/****** Object:  StoredProcedure [dbo].[csp_SCCanStaffSignUsingSignaturePad]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCCanStaffSignUsingSignaturePad]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCCanStaffSignUsingSignaturePad]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCCanStaffSignUsingSignaturePad]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[csp_SCCanStaffSignUsingSignaturePad]  
(  
 @ApplicationId int,
 @DocumentVersionId int,  
 @SigningStaffId int  
)  
As  
/*********************************************************************/                
/* Stored Procedure: dbo.csp_SCCanStaffSignUsingSignaturePad                         */                
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                
/* Creation Date:    01/18/2011                                         */                
/*                                                                   */                
/* Purpose: this is used for enable/disable feature of signature pad for staff members   */                
/*                                                                   */              
/* Input Parameters: @ApplicationId ,@DocumentVersionId  ,@SigningStaffId             */              
/*                                                                   */                
/* Output Parameters:   None                           */                
/*                                                                   */                
/* Return: 0=Staff user is allowed to using signature pad., otherwise disable the signature pad feature.*/                
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/* Updates:                                                          */                
/*   Date         Author         Purpose                                    */                
/*   01/18/2011   Vikas Monga    Created                                     */                
/*                                                                    */
/*********************************************************************/                
Begin  
 Begin Try 
 If(@ApplicationId = 4)
	Begin 
	  SELECT Count(*)  
	  FROM DocumentSignatures ds  
	   join staff s on s.StaffID = ds.StaffId  
	  WHERE ds.SignedDocumentversionId = @DocumentVersionId  
	   and ds.StaffId = @SigningStaffId  
	   and isnull(s.CanSignUsingSignaturePad,''Y'')=''N''  
	End
 ELSE
	BEGIN
	 --Custom logic will be implemented as per requirement based on application id.	 
	 Select 0
	END
 End Try  
 BEGIN CATCH                                                                                    
  DECLARE @Error varchar(8000)                                                                                                                            
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_CheckSignUsingSignaturePad'')                                                                                                                             
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                              
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                           
   RAISERROR                                                                    
   (                                                                      
    @Error, -- Message text.                                                                                          
    16, -- Severity.               
    1 -- State.                                                      
   );                                                                                                                            
 END CATCH               
End' 
END
GO
