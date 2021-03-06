/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentMedicationReviewNotes]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMedicationReviewNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentMedicationReviewNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMedicationReviewNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentMedicationReviewNotes]
(
@DocumentVersionId  int
)
As

BEGIN TRY
BEGIN
/************************************************************************/
/* Stored Procedure: csp_RDLCustomDocumentMedicationReviewNotes    */
/* Copyright: 2006 Streamline SmartCare                            */
/* Creation Date:  July 22 ,2011                                   */
/*                                                                 */
/* Purpose: Gets Data for CustomDocumentMedicationReviewNotes      */
/*                                                                 */
/* Input Parameters: @DocumentVersionId                            */
/*                                                                 */
/* Output Parameters:                                              */
/* Purpose: Use For Rdl Report                                     */
/* Call By:                                                        */
/* Calls:                                                          */
/*                                                                 */
/* Author: Jagdeep Hundal                                          */
/* 2012.11.14 - T. Remisoski - Changes for print request changes.  */
/************************************************************************/
DECLARE @ClientAge varchar(10)
DECLARE @ClientId int
DECLARE @clientName varchar(110)
DECLARE @clientGender varchar(1)
DECLARE @PreviousTreatmentRecommendationsAndOrders varchar(max)
DECLARE @StandardPatientInstructions varchar(max)

SELECT @ClientId = ClientId from Documents where
CurrentDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,''N'')= ''N''

SET @StandardPatientInstructions=''• If you experience a psychiatric or medical emergency, call 911.

• If thoughts of harming yourself or someone else occur:
       o Call 911
       o Call Rescue Crisis – 24 hours/day 7 days/week at 419-255-9585
       o Call the National Suicide Prevention Hotline at 1-800-273-TALK (8255)
       o Call Harbor after hours at 419-475-4449
       o Seek help at the nearest emergency room

• Take all medications as prescribed. Should you have questions or concerns regarding your medication, or if you experience side effects to your medication, call the Harbor location where you see your prescriber.

• If you need refills before your next appointment, contact the Harbor location at which you attend at least 5 days before running out of medications.

• Obtain all medical tests including lab work if ordered by your prescriber.

• Pay special attention to instructions for your particular medications, such as whether to take with food, if you should take special precautions in the sunlight, etc.

• Do not take any prescription medications that are not prescribed to you by your provider(s). 

• Do not give your prescription medication to others.

• Make sure that at every appointment you let the medical staff know of any changes in your medication, herbs and supplements including those provided by prescribers not at Harbor.
''

SET @clientName = (Select  (FirstName +'' ''+LastName ) from Clients
    where ClientId=@ClientID and IsNull(RecordDeleted,''N'')=''N'')
SET @clientGender = (Select  Sex from Clients
    where ClientId=@ClientID and IsNull(RecordDeleted,''N'')=''N'')

Exec csp_CalculateAge @ClientId, @ClientAge out

SELECT CDMN.[DocumentVersionId]
	  ,c.LastName + '', '' + c.FirstName as ClientName
	  ,st.LastName + '', '' + st.Firstname as ClinicianName
	  ,c.ClientId
	  ,LTRIM(RIGHT(CONVERT(VARCHAR(20), s.DateOfService, 100), 7)) as StartTime
	  ,pc.ProcedureCodeName as ProcedureName
	  ,d.EffectiveDate
	  ,l.LocationName as Location
	  ,gc3.CodeName as Status
	  ,convert(varchar(10),S.Unit)+'' ''+GC2.CodeName  as Duration
	  ,S.DiagnosisCode1 +'', ''+ S.DiagnosisCode2 as AXISIANDII
	  ,S.DiagnosisCode3 AXISIII
	  ,S.OtherPersonsPresent as OtherPersonPresent
      ,CDMN.[CreatedBy]
      ,CDMN.[CreatedDate]
      ,CDMN.[ModifiedBy]
      ,CDMN.[ModifiedDate]
      ,CDMN.[RecordDeleted]
      ,CDMN.[DeletedBy]
      ,CDMN.[DeletedDate]
      ,c.LastName + '', '' + c.FirstName as Client_Name
	  ,Case 
		When Left(@ClientAge,1) = ''8'' Then ''n ''
		When Left(@ClientAge,2) IN (''11'',''18'') Then ''n '' 
		Else '' '' End 
		+ Lower(Left(@ClientAge,Len(@ClientAge)-1)) as ClientAge
      ,@clientGender as [ClientGender]
      ,CDMN.[CurrentMedications]
      ,CDMN.[PreviousTreatmentRecommendationsAndOrders]
      ,CDMN.[PreviousChangesSinceLastVisit]
      ,CDMN.[ChangesSinceLastVisit]
      ,CDMN.[MedicationsPrescribed]
      ,CDMN.[MedEducationSideEffectsDiscussed]
      ,CDMN.[MedEducationAlternativesReviewed]
      ,CDMN.[MedEducationAgreedRegimen]
      ,CDMN.[MedEducationAwareOfSubstanceUseRisks]
      ,CDMN.[MedEducationAwareOfEmergencySymptoms]
      ,CDMN.[TreatmentRecommendationsAndOrders]
      ,CDMN.[OtherInstructions]
      ,s.DateOfService
      ,@StandardPatientInstructions as [StandardPatientInstructions]
      ,cdmn.MoreThan50PercentTimeSpentCounseling
FROM CustomDocumentMedicationReviewNotes CDMN
join dbo.DocumentVersions as dv on dv.DocumentVersionId = cdmn.DocumentVersionId
join dbo.Documents as d on d.DocumentId = dv.DocumentId
join dbo.Services as s on s.ServiceId = d.ServiceId
join dbo.Clients as c on c.ClientId = d.ClientId
join dbo.Staff as st on st.StaffId = s.ClinicianId
join dbo.ProcedureCodes as pc on pc.ProcedureCodeId = s.ProcedureCodeId
LEFT join dbo.Locations as l on l.LocationId = s.LocationId
left join GlobalCodes GC2 on S.UnitType = GC2.GlobalCodeId
left join GlobalCodes GC3 on S.Status=GC3.GlobalCodeId
where CDMN.DocumentVersionId = @DocumentVersionId



END
END TRY
--Checking For Errors
BEGIN CATCH
   DECLARE @Error varchar(8000)
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLCustomDocumentMedicationReviewNotes'')
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )

END CATCH


' 
END
GO
