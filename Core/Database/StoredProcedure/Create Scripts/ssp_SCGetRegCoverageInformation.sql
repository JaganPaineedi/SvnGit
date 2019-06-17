
/****** Object:  StoredProcedure [dbo].[ssp_SCGetRegCoverageInformation]    Script Date: 10/18/2014 12:09:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetRegCoverageInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetRegCoverageInformation]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCGetRegCoverageInformation]    Script Date: 10/18/2014 12:09:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROC [dbo].[ssp_SCGetRegCoverageInformation]       
 @ClientId int      
as      
/*********************************************************************/      
/* Stored Procedure: dbo.ssp_SCGetRegCoverageInformation   */            
/* Copyright: 2014 Streamline Healthcare Solutions,  LLC */            
/* Creation Date:    18 July 2016     */            
/*       */            
/* Purpose:  Used in getdata() for MemberInquiries Detail Page  */           
/*       */          
/* Input Parameters:     @inquiryId   */          
/*       */            
/* Output Parameters:   None    */            
/*       */            
/* Return:  0=success, otherwise an error number                */            
/*--------------------------------------------------------------------------------------------------------------*/            
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */ 
/*********************************************************************/                 
BEGIN         
 BEGIN TRY      
 
      
    Select CoveragePlanId,DisplayAs, 'N'  as IsSelected       
    FROM CoveragePlans WHERE isNull(RecordDeleted,'N')<>'Y'	AND Active='Y'  	 
           
              
   END TRY        
 BEGIN CATCH             
 DECLARE @Error varchar(8000)              
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetRegCoverageInformation')                 
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
      
GO


