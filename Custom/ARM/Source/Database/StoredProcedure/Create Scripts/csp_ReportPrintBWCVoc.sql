/****** Object:  StoredProcedure [dbo].[csp_ReportPrintBWCVoc]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintBWCVoc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintBWCVoc]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintBWCVoc]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_ReportPrintBWCVoc]

@ClaimBatchId  int = null,
@ClaimProcessId int = null
/*
Purpose: Selects data to print on BWC claim form based on HCFA1500 claim form.
      Either @ClaimBatchId or @ClaimProcessId has to be passed in.

Updates: 
Date         Author       Purpose
5/25/12      JJN          Created
7/24/12		JJN				Created CustomClaimBWcs table
*/                 

as
BEGIN

SET NOCOUNT ON

SELECT
	c.ClaimLineItemGroupId,Field02ClaimNumber,
	Field03SSN=LEFT(Field03SSN,9),
	SSN01=LEFT(Field03SSN,1),SSN02=RIGHT(LEFT(Field03SSN,2),1),SSN03=RIGHT(LEFT(Field03SSN,3),1),
	SSN04=RIGHT(LEFT(Field03SSN,4),1),SSN05=RIGHT(LEFT(Field03SSN,5),1),SSN06=RIGHT(LEFT(Field03SSN,6),1),
	SSN07=RIGHT(LEFT(Field03SSN,7),1),SSN08=RIGHT(LEFT(Field03SSN,8),1),SSN09=RIGHT(LEFT(Field03SSN,9),1),
	Field04InjuryDate,
	Field04InjuryMM=DATEPART(mm,Field04InjuryDate),
	Field04InjuryDD=DATEPART(dd,Field04InjuryDate),
	Field04InjuryYY=DATEPART(yy,Field04InjuryDate),
	Field05PatientName,Field06PatientAddress,
	Field06PatientCity,Field06PatientState,Field06PatientZip,Field07ReferringNPI,Field08ReferringName,Field09PriorAuthorizationNumber,Field10PatientNumber,
	Field11ProviderNumber=LEFT(Field11ProviderNumber,11),
    PN01=LEFT(Field11ProviderNumber,1),PN02=RIGHT(LEFT(Field11ProviderNumber,2),1),
    PN03=RIGHT(LEFT(Field11ProviderNumber,3),1),PN04=RIGHT(LEFT(Field11ProviderNumber,4),1),
    PN05=RIGHT(LEFT(Field11ProviderNumber,5),1),PN06=RIGHT(LEFT(Field11ProviderNumber,6),1),
    PN07=RIGHT(LEFT(Field11ProviderNumber,7),1),PN08=RIGHT(LEFT(Field11ProviderNumber,8),1),
    PN09=RIGHT(LEFT(Field11ProviderNumber,9),1),PN10=RIGHT(LEFT(Field11ProviderNumber,10),1),
    PN11=RIGHT(LEFT(Field11ProviderNumber,11),1),
	Field12ProviderName,Field13TotalPayment,Field14UseGroupNumber,
	Field14GroupNumber=LEFT(Field14GroupNumber,11),
	GN01=LEFT(Field14GroupNumber,1),GN02=RIGHT(LEFT(Field14GroupNumber,2),1),GN03=RIGHT(LEFT(Field14GroupNumber,3),1),
	GN04=RIGHT(LEFT(Field14GroupNumber,4),1),GN05=RIGHT(LEFT(Field14GroupNumber,5),1),GN06=RIGHT(LEFT(Field14GroupNumber,6),1),
	GN07=RIGHT(LEFT(Field14GroupNumber,7),1),GN08=RIGHT(LEFT(Field14GroupNumber,8),1),GN09=RIGHT(LEFT(Field14GroupNumber,9),1),
	GN10=RIGHT(LEFT(Field14GroupNumber,10),1),GN11=RIGHT(LEFT(Field14GroupNumber,11),1),
 	Field15DateofServce1,Field15DateofServce2,Field15DateofServce3,Field15DateofServce4,Field15DateofServce5,Field15DateofServce6,Field15DateofServce7,
	Field16PlaceofService1,Field16PlaceofService2,Field16PlaceofService3,Field16PlaceofService4,Field16PlaceofService5,Field16PlaceofService6,Field16PlaceofService7,
	Field17ProcedureCode1,Field17ProcedureCode2,Field17ProcedureCode3,Field17ProcedureCode4,Field17ProcedureCode5,Field17ProcedureCode6,Field17ProcedureCode7,
	Field18ModificationCode1,Field18ModificationCode2,Field18ModificationCode3,Field18ModificationCode4,Field18ModificationCode5,Field18ModificationCode6,Field18ModificationCode7,
	Field19DiagnosisCode1,Field19DiagnosisCode2,Field19DiagnosisCode3,Field19DiagnosisCode4,Field19DiagnosisCode5,Field19DiagnosisCode6,Field19DiagnosisCode7,
	Field20ServiceDescription1,Field20ServiceDescription2,Field20ServiceDescription3,Field20ServiceDescription4,Field20ServiceDescription5,Field20ServiceDescription6,Field20ServiceDescription7,
	Field21Charges1,Field21Charges2,Field21Charges3,Field21Charges4,Field21Charges5,Field21Charges6,Field21Charges7,
	Field22Units1,Field22Units2,Field22Units3,Field22Units4,Field22Units5,Field22Units6,Field22Units7,
	Field24Signed,Field25Date,Field26TotalCharge,Field28NameandAddress,Field28Phone
	            
FROM CustomClaimBWCs c
JOIN ClaimLineItemGroups clig on clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
JOIN ClaimBatches cb on cb.ClaimBatchId = clig.ClaimBatchId
WHERE (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
	AND isnull(clig.RecordDeleted, ''N'') = ''N''
	AND isnull(c.RecordDeleted, ''N'') = ''N''
	AND isnull(cb.RecordDeleted, ''N'') = ''N''
ORDER BY clig.ClientId, clig.ClaimLineItemGroupId 
    
END
' 
END
GO
