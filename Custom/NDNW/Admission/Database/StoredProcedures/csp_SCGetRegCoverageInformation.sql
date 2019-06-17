
/****** Object:  StoredProcedure [dbo].[csp_SCGetRegCoverageInformation]    Script Date: 10/18/2014 12:09:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetRegCoverageInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetRegCoverageInformation]
GO



/****** Object:  StoredProcedure [dbo].[csp_SCGetRegCoverageInformation]    Script Date: 10/18/2014 12:09:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROC [dbo].[csp_SCGetRegCoverageInformation]       
 @clientid int      
as      
/*********************************************************************/      
/* Stored Procedure: dbo.csp_SCGetCoverageInformation   */            
/* Copyright: 2014 Streamline Healthcare Solutions,  LLC */            
/* Creation Date:    18-oct-2014     */            
/*       */            
/* Purpose:  Used in getdata() for MemberInquiries Detail Page  */           
/*       */          
/* Input Parameters:     @inquiryId   */          
/*       */            
/* Output Parameters:   None    */            
/*       */            
/* Return:  0=success, otherwise an error number                */            
/*--------------------------------------------------------------------------------------------------------------*/            
/*  Date			Author     Purpose                */      
/* ------------     -----------------       --------------------------------------------------------------------*/      
 /* 6-Dec-2018		Ponnin		Active check was not handled for Coverage Plans to bind the Plan Dropdown. Why: For task New Directions - Support Go Live #893 
 	04/04/2019		MD			Added ORDER BY Clause to sort the result in ascending (alphabetical) order per customer's request w.r.t New Directions - Support Go Live #945
 */
/*********************************************************************/                 
BEGIN         
 BEGIN TRY      
 
      
    SELECT CoveragePlanId,DisplayAs, 'N'  AS IsSelected       
    FROM CoveragePlans WHERE isNull(RecordDeleted,'N')<>'Y'  AND Active = 'Y'
    ORDER BY DisplayAs
           
              
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
      
GO


