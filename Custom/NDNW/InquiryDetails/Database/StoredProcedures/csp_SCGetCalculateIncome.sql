IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCalculateIncome]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCalculateIncome]
GO

CREATE PROC [dbo].[csp_SCGetCalculateIncome]   
 @Income Decimal,
 @Type Char(1)  
as    
/*********************************************************************/    
/* Stored Procedure: dbo.csp_SCGetCalculateIncome   */          
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC */          
/* Creation Date:    15-Dec-2011     */          
/*       */          
/* Purpose:  Used in getdata() for MemberInquiries Detail Page  */         
/*       */        
/* Input Parameters:     @inquiryId   */        
/*       */          
/* Output Parameters:   None    */          
/*       */          
/* Return:  0=success, otherwise an error number                */          
/*--------------------------------------------------------------------------------------------------------------*/          
/*  Date   Author     Purpose                */    
/* ------------     -----------------       --------------------------------------------------------------------*/    
/*********************************************************************/               
BEGIN       
 BEGIN TRY
Declare @Result  Decimal
If @Type = 'A'
Begin
	Set @Result= @Income/12
END
ELSE 
Begin
	Set @Result= @Income*12
END
select  @Result as Income
   END TRY      
 BEGIN CATCH           
 DECLARE @Error varchar(8000)            
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())             
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetCalculateIncome')               
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())              
    + '*****' + Convert(varchar,ERROR_STATE())            
           
    RAISERROR             
    (              
  @Error, -- Message text.            
  16, -- Severity.            
  1 -- State.            
    );         
 End CATCH               
End         
    
  