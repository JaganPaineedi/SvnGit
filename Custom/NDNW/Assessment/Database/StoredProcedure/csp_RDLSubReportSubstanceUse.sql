

/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportSubstanceUse]    Script Date: 01/16/2015 18:49:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportSubstanceUse]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportSubstanceUse]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportSubstanceUse]    Script Date: 01/16/2015 18:49:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE  [dbo].[csp_RDLSubReportSubstanceUse]                           
(                                          
  @DocumentVersionId int                  
)                                           
As                                                                                                                                                          
/************************************************************/                                                                  
/* Stored Procedure: csp_RDLSubReportSubstanceUse           */                                                                                                                   
/* Creation Date:       */                                                                                                                               
/* Purpose: Gets Data for Uncope    */                                                                 
/* Input Parameters: @DocumentVersionId      */                                                                                                                            
/* Author:         */      
    
/************************************************************/                                                                                                                                              
BEGIN TRY                                         
       
  BEGIN        
   SELECT     
  CDA.DocumentVersionId     
 ,CDA.CreatedBy      
 ,CDA.CreatedDate      
 ,CDA.ModifiedBy      
 ,CDA.ModifiedDate      
 ,CDA.RecordDeleted      
 ,CDA.DeletedBy      
 ,CDA.DeletedDate      
 ,CDA.UseOfAlcohol      
 ,CDA.AlcoholAddToNeedsList      
 ,CDA.UseOfTobaccoNicotine      
 ,CASE WHEN CDA.UseOfTobaccoNicotineQuit IS NOT NULL
		THEN CONVERT(VARCHAR(10), CDA.UseOfTobaccoNicotineQuit, 101)
	ELSE '' END UseOfTobaccoNicotineQuit     
 ,CDA.UseOfTobaccoNicotineTypeOfFrequency      
 ,CDA.UseOfTobaccoNicotineAddToNeedsList      
 ,CDA.UseOfIllicitDrugs      
 ,CDA.UseOfIllicitDrugsTypeFrequency      
 ,CDA.UseOfIllicitDrugsAddToNeedsList      
 ,CDA.PrescriptionOTCDrugs      
 ,CDA.PrescriptionOTCDrugsTypeFrequency      
 ,CDA.PrescriptionOTCDrugsAddtoNeedsList      
 FROM CustomDocumentAssessmentSubstanceUses CDA        
   WHERE DocumentVersionId = @DocumentVersionId         
        
 END      
                                                                                         
 END TRY                                                                                                     
 BEGIN CATCH                                                       
   DECLARE @Error varchar(8000)                                                                                                                                     
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                          
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLSubReportSubstanceUse')                         
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                          
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                                
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                         
                                                                                                                                    
 END CATCH 
GO


