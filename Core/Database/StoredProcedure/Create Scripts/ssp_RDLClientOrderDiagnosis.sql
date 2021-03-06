IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientOrderDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClientOrderDiagnosis]
GO
/****** Object:  StoredProcedure [dbo].[csp_RDLClientOrderDiagnosis]    Script Date: 03/18/2014 12:27:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ssp_RDLClientOrderDiagnosis]
(@ClientOrderId int =0 )
/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 18-mar-2014    Revathi      What:Get ClientOrdersDiagnosis
                             Why:Philhaven Development #26 Inpatient Order Management
13 Jul 2015		Chethan N	 What: Retrieving ICD10Code from DiagnosisICD10Codes
							 Why:  Diagnosis Changes (ICD10) task # 1 
************************************************/
as
BEGIN				
	Begin Try 
	select 	
	DICD.ICD10Code AS ICDCode,
	[Description] 
	from ClientOrdersDiagnosisIIICodes COD
	JOIN DiagnosisICD10Codes DICD ON DICD.ICD10CodeId = cod.ICD10CodeId
	where ClientOrderId=@ClientOrderId and ISNULL(COD.RecordDeleted,'N')<>'Y'
End Try
BEGIN CATCH          
	DECLARE @Error varchar(8000)                                                 
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
	+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLClientOrderDiagnosis')                                                                               
	+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
	+ '*****' + Convert(varchar,ERROR_STATE())                                           
	RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
END CATCH          
END			