
/****** Object:  StoredProcedure [dbo].[ssp_SCGetAcademicTermsDetails]    Script Date: 08/Mar/2018  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAcademicTermsDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAcademicTermsDetails]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetAcademicTermsDetails]    Script Date: 08/Mar/2018  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_SCGetAcademicTermsDetails] @AcademicTermId INT        
AS        
/*********************************************************************/        
/* Stored Procedure: dbo.ssp_SCGetAcademicTermsDetails              */        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */        
/* Creation Date:    08/Mar/2018                                         */        
/*                                                                   */        
/* Purpose:  Used in getdata() for AcademicTerms Detail Page  */        
/*                                                                   */        
/* Input Parameters: @AcademictermId   */        
/*                                                                   */        
/* Output Parameters:   None                */        
/*  Author: Chita Ranjan                                                                 */        
/*********************************************************************/        
BEGIN        
 BEGIN TRY       
 SELECT AT.AcademicTermId,    
        AT.CreatedBy,    
        AT.CreatedDate,    
        AT.ModifiedBy,    
        AT.ModifiedDate,    
        AT.RecordDeleted,    
        AT.DeletedBy,    
        AT.DeletedDate,    
        AT.AcademicYearId,    
        AT.QuarterOrSemester,    
        AT.Active,    
        AT.StartDate,    
        AT.EndDate,
        AT.AcademicTermName    
 FROM  AcademicTerms AT   
 WHERE AT.AcademicTermId =@AcademictermId      
        
 END TRY        
        
 BEGIN CATCH        
  DECLARE @Error VARCHAR(8000)        
        
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetClientFeeDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE())       
  + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())        
        
  RAISERROR (        
    @Error        
    ,-- Message text.                                                                                
    16        
    ,-- Severity.                                                                                
    1 -- State.                                                                                
    );        
 END CATCH        
END 