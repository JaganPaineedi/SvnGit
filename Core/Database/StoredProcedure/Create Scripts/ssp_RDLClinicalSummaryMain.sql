
/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryMain]    Script Date: 06/18/2015 12:36:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryMain]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryMain]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryMain]    Script Date: 06/18/2015 12:36:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryMain]   
    @ServiceId INT = NULL  
 ,@ClientId INT  
 ,@DocumentVersionId INT = NULL  
 ,@FilterString varchar(max)= NULL  
   
AS  
/******************************************************************************  
**  File: ssp_RDLClinicalSummaryMain.sql  
**  Name: ssp_RDLClinicalSummaryMain  
**  Desc: Provides general client information for the Clinical Summary  
**  
**  Return values:  
**  
**  Called by:  
**  
**  Parameters:  
**  Input   Output  
**  ServiceId      -----------  
**  
**  Created By: Veena S Mani  
**  Date:  Feb 20 2014  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:  Author:    Description:  
**  -------- --------   -------------------------------------------  
  
26/4/14   Veena S Mani  Added ShowClinicalSummaryCareTeam Section  
02/05/2014  Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18    
19/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.              
  
*******************************************************************************/  
  
BEGIN  
 SET NOCOUNT ON;  
  
 BEGIN TRY  
  DECLARE @IsProgressNote CHAR(1)  
  DECLARE @DocumentCodeId INT  
    
    
  --INSERT THE FILTER FOR EXPORT  
  IF ISNULL(@FilterString,'') <> ''  
  BEGIN   
   DELETE FROM CSFilterData WHERE ServiceId = @ServiceId  
     
   INSERT INTO CSFilterData(ServiceId,ClientId,DocumentVersionId,FilterString)  
   VALUES(@ServiceId,@ClientId,@DocumentVersionId,@FilterString)  
     
  END  
    
  IF (@DocumentVersionId IS NULL)  
  BEGIN  
   SET @IsProgressNote = 'N'  
  END  
  ELSE  
  BEGIN  
   SELECT TOP 1 @DocumentCodeId = DocumentCodeId  
   FROM Documents  
   WHERE InProgressDocumentVersionId = @DocumentVersionId   
   AND ISNULL(RecordDeleted,'N')='N'  
  
   IF (@DocumentCodeId = 300)  
   BEGIN  
    SET @IsProgressNote = 'Y'  
   END  
   ELSE  
   BEGIN  
    SET @IsProgressNote = 'N'  
   END  
  END  
  
  SELECT ClientId  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryGeneralInfo'  
    ) AS ShowClinicalSummaryGeneralInfo  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryClientInfo'  
    ) AS ShowClinicalSummaryClientInfo  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryVisitReason'  
    ) AS ShowClinicalSummaryVisitReason  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryDiagnosis'  
    ) AS ShowClinicalSummaryDiagnosis  
   ,  
    --WHEN @IsProgressNote = 'Y'  
    -- THEN 'N'  
    --ELSE  
     (  
      SELECT value  
      FROM systemconfigurationkeys  
      WHERE [key] = 'ShowClinicalSummaryProcedureIntervention'  
      )  
     AS ShowClinicalSummaryProcedureIntervention  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryVitals'  
    ) AS ShowClinicalSummaryVitals  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryAllergies'  
    ) AS ShowClinicalSummaryAllergies  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummarySmokingStatus'  
    ) AS ShowClinicalSummarySmokingStatus  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryCurrentMedication'  
    ) AS ShowClinicalSummaryCurrentMedication  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryMedicationAdministrated'  
    ) AS ShowClinicalSummaryMedicationAdministrated  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryImmunizations'  
    ) AS ShowClinicalSummaryImmunizations  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryResultReviewed'  
    ) AS ShowClinicalSummaryResultReviewed  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryEducation'  
    ) AS ShowClinicalSummaryEducation  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryReferralToOther'  
    ) AS ShowClinicalSummaryReferralToOther  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryAppointments'  
    ) AS ShowClinicalSummaryAppointments  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryGoalsObjectives'  
    ) AS ShowClinicalSummaryGoalsObjectives  
   ,  
    --WHEN @IsProgressNote = 'N'  
    -- THEN 'N'  
    --ELSE   
    (  
      SELECT value  
      FROM systemconfigurationkeys  
      WHERE [key] = 'ShowClinicalSummaryProcedureDuringVisit'  
      )  
    AS ShowClinicalSummaryProcedureDuringVisit  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryOrderPending'  
    ) AS ShowClinicalSummaryOrderPending  
   ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryCareTeam'  
    ) AS ShowClinicalSummaryCareTeam  
    ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalInstruction'  
    ) AS ShowClinicalInstruction  
    ,(  
    SELECT value  
    FROM systemconfigurationkeys  
    WHERE [key] = 'ShowClinicalSummaryFutureOrders'  
    ) AS ShowFutureOrders  
  FROM dbo.clients AS c  
  WHERE C.ClientId = @ClientId  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'   
  + CONVERT(VARCHAR(4000), Error_message()) + '*****'  
   + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_RDLClinicalSummaryMain') + '*****'   
   + CONVERT(VARCHAR, Error_line()) + '*****'  
    + CONVERT(VARCHAR, Error_severity()) + '*****'  
     + CONVERT(VARCHAR, Error_state())  
  
  RAISERROR (  
    @Error  
    ,16  
    ,1  
    );  
 END CATCH  
END  
GO


