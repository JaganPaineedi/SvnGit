IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCoverageInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCoverageInformation]
GO

CREATE PROC [dbo].[csp_SCGetCoverageInformation]     
 @inquiryId int    
as    
/*********************************************************************/    
/* Stored Procedure: dbo.csp_SCGetCoverageInformation   */          
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
   Select InquiriesCoverageInformationId
		,CreatedBy							
		,CreatedDate							
		,ModifiedBy							
		,ModifiedDate						
		,RecordDeleted				
		,DeletedBy							
		,DeletedDate							
		,InquiryId							
		,CoveragePlanId								
		,InsuredId							
		,GroupId								
		,Comment
		,NewlyAddedplan										
    FROM CustomInquiriesCoverageInformations WHERE InquiryId=@inquiryId AND isNull(RecordDeleted,'N')<>'Y'
    
    Select CoveragePlanId,DisplayAs, 'N'  as IsSelected     
    FROM CoveragePlans WHERE isNull(RecordDeleted,'N')<>'Y'
         
            
   END TRY      
 BEGIN CATCH           
 DECLARE @Error varchar(8000)            
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())             
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetCoverageInformation')               
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
    
  