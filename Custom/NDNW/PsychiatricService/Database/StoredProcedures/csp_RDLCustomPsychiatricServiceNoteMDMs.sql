/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPsychiatricServiceNoteMDMs]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricServiceNoteMDMs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNoteMDMs]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPsychiatricServiceNoteMDMs]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNoteMDMs] 
(@DocumentVersionId INT=0)
/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
02-Jan-2015    Revathi      What: Get Psychiatric Service Note Medical Decision Making Information 
                             Why:task #823 Woods-Customizations
************************************************/
  AS 
 BEGIN
				
	BEGIN TRY
	SELECT 
	   ISNULL(CM.MedicalRecords,'N') as MedicalRecords
	   ,ISNULL(CM.DiagnosticTest,'N') as DiagnosticTest
	   ,ISNULL(CM.Labs,'N') as Labs
	   ,(o.OrderName +'('+(CONVERT(varchar(20),  co.OrderStartDateTime,101) + ' ' +  RIGHT(CONVERT(VARCHAR,co.OrderStartDateTime,0),6)) + ')') as LabsSelected
	   ,CM.MedicalRecordsComments
	   ,ISNULL(CM.OrderedMedications,'N') as OrderedMedications
	   ,ISNULL(CM.RisksBenefits,'N') as RisksBenefits
	   ,ISNULL(CM.NewlyEmergentSideEffects,'N') as NewlyEmergentSideEffects
	   ,ISNULL(CM.LabOrder,'N') as LabOrder
	    ,ISNULL(CM.RadiologyOrder,'N') as RadiologyOrder
	    ,ISNULL(CM.Consultations,'N') as Consultations
	    ,CM.OrdersComments
	 	FROM CustomDocumentPsychiatricServiceNoteMDMs CM
	 	left join clientorders CO on cm.LabsSelected = Co.ClientOrderId     
         left join Orders O on co.orderid = o.orderid
	   	WHERE  CM.DocumentVersionId=@DocumentVersionId
	   	AND ISNULL(CM.RecordDeleted,'N')='N'
	   	End Try
 
  BEGIN CATCH          
   DECLARE @Error varchar(8000)                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomPsychiatricServiceNoteMDMs')                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
   + '*****' + Convert(varchar,ERROR_STATE())                                           
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
 END CATCH          
END
GO


