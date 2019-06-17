

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAcademicYearsDetails]    Script Date: 03/14/2018 12:38:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAcademicYearsDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAcademicYearsDetails]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCGetAcademicYearsDetails]    Script Date: 03/14/2018 12:38:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_SCGetAcademicYearsDetails] @AcademicYearId INT      
AS      
/*********************************************************************/      
/* Stored Procedure: dbo.ssp_SCGetAcademicYearsDetails              */      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */      
/* Creation Date:    08/Mar/2018                                         */      
/*                                                                   */      
/* Purpose:  Used in getdata() for AcademicYears Detail Page  */      
/*                                                                   */      
/* Input Parameters: @AcademicYearId   */      
/*                                                                   */      
/* Output Parameters:   None                */      
/*                                                                   */      
/*********************************************************************/      
-- exec dbo.ssp_SCGetAcademicYearsDetails   1     
BEGIN      
 BEGIN TRY     
 SELECT AY.AcademicYearId,  
        AY.CreatedBy,  
        AY.CreatedDate,  
        AY.ModifiedBy,  
        AY.ModifiedDate,  
        AY.RecordDeleted,  
        AY.DeletedBy,  
        AY.DeletedDate,  
        AY.AcademicName,  
        AY.QuarterOrSemester,  
        AY.Active,  
        AY.StartDate,  
        AY.EndDate  
 FROM  AcademicYears AY   
 WHERE AY.AcademicYearId =@AcademicYearId    
      
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
GO


