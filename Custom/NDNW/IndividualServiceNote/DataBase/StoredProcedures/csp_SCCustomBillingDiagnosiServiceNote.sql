
/****** Object:  StoredProcedure [dbo].[csp_SCCustomBillingDiagnosiServiceNote]    Script Date: 08/13/2015 15:01:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCCustomBillingDiagnosiServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCCustomBillingDiagnosiServiceNote]
GO
/****** Object:  StoredProcedure [dbo].[csp_SCCustomBillingDiagnosiServiceNote]    Script Date: 08/13/2015 15:01:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SCCustomBillingDiagnosiServiceNote]
@DocumentVersionId int          
--@varDate datetime = null,
--@varProgramId INT = NULL
AS 
/***********************************************************************/            
/* Stored Procedure: dbo.ssp_BillingDiagnosiServiceNote                */            
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC               */            
/* Creation Date:    02/20/2015                                        */
/*  Date			Author			Purpose							   */ 
/*	03-09-2015		Basudev Sahu	To get BillingDiagnos what we have added Task #24 New Directions - Support Go Live												   */
/***********************************************************************/  

BEGIN 
Declare @ServiceID int 

Select top 1 @ServiceID = ServiceId  from Documents where CurrentDocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'

Declare @ServiceDiagnosis table (DSMCode varchar(50),[Order] int,[Description] varchar(MAX))

Insert Into  @ServiceDiagnosis 
SELECT SD.DSMCode	
	,SD.[Order]
	,DD.DSMDescription AS 'Description'
FROM ServiceDiagnosis SD
join Services as s on SD.ServiceId = s.ServiceId
JOIN DiagnosisDSMDescriptions DD ON SD.DSMCode = DD.DSMCode
	AND SD.DSMNumber = DD.DSMNumber
WHERE ISNULL(SD.RecordDeleted, 'N') = 'N'
	AND ISNULL(S.RecordDeleted, 'N') = 'N'
	AND SD.ServiceId = @ServiceID 

UNION

SELECT SD.DSMCode	
	,SD.[Order]
	,DD.ICDDescription AS 'Description'
FROM ServiceDiagnosis SD
join Services as s on SD.ServiceId = s.ServiceId
JOIN DiagnosisICDCodes DD ON SD.DSMCode = DD.ICDCode
WHERE SD.DSMNumber IS NULL
	AND ISNULL(SD.RecordDeleted, 'N') = 'N'
	AND ISNULL(S.RecordDeleted, 'N') = 'N'
	AND SD.ServiceId = @ServiceID 
	
UNION

SELECT SD.ICD10Code		
	,SD.[Order]
	,DD.ICDDescription AS 'Description'
FROM ServiceDiagnosis SD
join Services as s on SD.ServiceId = s.ServiceId
JOIN DiagnosisICD10Codes DD ON SD.DSMVCodeId = DD.ICD10CodeId
	AND SD.ICD10Code = DD.ICD10Code
WHERE SD.DSMNumber IS NULL
	AND ISNULL(SD.RecordDeleted, 'N') = 'N'
	AND ISNULL(S.RecordDeleted, 'N') = 'N'
	AND SD.ServiceId = @ServiceID 
	
	Select DSMCode,[Order],[Description] from  @ServiceDiagnosis  order by [Order] asc
	
 IF (@@error!=0)                
 BEGIN                
        RAISERROR  20002  'csp_SCCustomBillingDiagnosiServiceNote: An Error Occured'                
        RETURN(1)                
 END                
 RETURN(0)                
                
END 
GO


