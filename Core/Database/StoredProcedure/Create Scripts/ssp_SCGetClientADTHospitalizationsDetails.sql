/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientADTHospitalizationsDetails]    Script Date: 05/25/2017 11:54:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientADTHospitalizationsDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientADTHospitalizationsDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientADTHospitalizationsDetails]    Script Date: 05/25/2017 11:54:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
Create Procedure [dbo].[ssp_SCGetClientADTHospitalizationsDetails]   
  
(          
@ADTHospitalizationId int          
)          
        
AS   
  
BEGIN
  BEGIN TRY
  
/*********************************************************************/                                                                                        
 /* Stored Procedure: [ssp_SCGetClientADTHospitalizationsDetails]              */                                                                               
 /* Created By: Chethan N					*/
/* Creation Date:  02/09/2017             */                                                                                      
 /* Input Parameters: */                  
  /* Output Parameters:   */            
  /*Returns The Table of Hospitals  */                                                                                        
 /* Called By:                                                       */                                                                              
 /* Data Modifications:                                              */                                                                                        
 /*   Updates:                                                       */                                                                                        
 /*   Date    Author   Purpose                       */             
   
 /********************************************************************/    
		SELECT AH.ADTHospitalizationId
			,AH.CreatedBy
			,AH.CreatedDate
			,AH.ModifiedBy
			,AH.ModifiedDate
			,AH.RecordDeleted
			,AH.DeletedBy
			,AH.DeletedDate
			,AH.ClientId
			,AH.AssignedReviewerId
			,AH.AdmissionDateTime
			,AH.DischargeDateTime
			,'{Admission ' + CONVERT(VARCHAR(10), CAST(AH.AdmissionDateTime AS DATE), 101) + ' - ' + CASE 
				WHEN AH.DischargeDateTime IS NOT NULL
					THEN 'Discharge ' + CONVERT(VARCHAR(10), CAST(AH.DischargeDateTime AS DATE), 101) 
				ELSE ''
				END + '}' AS AdmitDischarge
		FROM ADTHospitalizations AS AH
		WHERE AH.ADTHospitalizationId = @ADTHospitalizationId

		SELECT AHD.ADTHospitalizationDetailId
			,AHD.CreatedBy
			,AHD.CreatedDate
			,AHD.ModifiedBy
			,AHD.ModifiedDate
			,AHD.RecordDeleted
			,AHD.DeletedBy
			,AHD.DeletedDate
			,AHD.ADTHospitalizationId
			,AHD.MessageType
			--,GC.CodeName AS MessageTypeText
			,AHD.PatientName
			,AHD.DateofBirth
			,AHD.PatientAddress
			,AHD.MaritalStatus
			,AHD.MRN
			,AHD.SSN
			,AHD.Gender
			,AHD.Race
			,AHD.PrimaryLanguage
			,AHD.PhoneNumber
			,AHD.InsuranceCompany
			,AHD.PolicyId
			,AHD.VisitType
			,AHD.Hospital
			,AHD.PresentingProblem
			,AHD.AdmissionDateTime
			,AHD.DischargeDateTime
			,AHD.UpdateDateTime
			,AHD.TransferDateTime
			,AHD.CurrentBed
			,AHD.PreviousBed
			,AHD.DischargeDisposition
		FROM ADTHospitalizationDetails AS AHD
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = AHD.MessageType
		WHERE AHD.ADTHospitalizationId = @ADTHospitalizationId
				AND ISNULL(AHD.RecordDeleted, 'N') = 'N'

		SELECT AHDI.ADTHospitalizationDiagnosisId
			,AHDI.CreatedBy
			,AHDI.CreatedDate
			,AHDI.ModifiedBy
			,AHDI.ModifiedDate
			,AHDI.RecordDeleted
			,AHDI.DeletedBy
			,AHDI.DeletedDate
			,AHDI.ADTHospitalizationDetailId
			,AHDI.Code
			,AHDI.DiagnosisType
			,AHDI.DiagnosisType
		FROM ADTHospitalizationDiagnosis AHDI
		INNER JOIN ADTHospitalizationDetails AHD ON AHD.ADTHospitalizationDetailId = AHDI.ADTHospitalizationDetailId 
				AND ISNULL(AHD.RecordDeleted, 'N') = 'N'
		WHERE AHD.ADTHospitalizationId = @ADTHospitalizationId
				AND ISNULL(AHDI.RecordDeleted, 'N') = 'N'

  
END TRY

  BEGIN CATCH
    DECLARE @Error varchar(8000)

    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
    + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****'
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
    'ssp_SCGetClientADTHospitalizationsDetails')
    + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (@Error,
    -- Message text.                                            
    16,-- Severity.                                            
    1 -- State.                                            
    );
  END CATCH
END

GO


