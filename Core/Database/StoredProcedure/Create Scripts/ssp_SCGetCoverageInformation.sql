/****** Object:  StoredProcedure [dbo].[ssp_SCGetCoverageInformation]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCoverageInformation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetCoverageInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetCoverageInformation]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ssp_SCGetCoverageInformation]             
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
   Select InquiryCoverageInformationId        
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
    FROM InquiryCoverageInformations WHERE InquiryId=@inquiryId AND isNull(RecordDeleted,'N')<>'Y'        
            
    Select CoveragePlanId,DisplayAs, 'N'  as IsSelected             
    FROM CoveragePlans WHERE isNull(RecordDeleted,'N')<>'Y'        
                 
                    
   END TRY              
 BEGIN CATCH                   
 DECLARE @Error varchar(8000)                    
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetCoverageInformation')                       
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