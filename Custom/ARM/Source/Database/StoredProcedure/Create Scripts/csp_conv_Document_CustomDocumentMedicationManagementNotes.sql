/****** Object:  StoredProcedure [dbo].[csp_conv_Document_CustomDocumentMedicationManagementNotes]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocumentMedicationManagementNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_CustomDocumentMedicationManagementNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocumentMedicationManagementNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
CREATE procedure [dbo].[csp_conv_Document_CustomDocumentMedicationManagementNotes]
as
    
insert into dbo.CustomDocumentMedicationManagementNotes (
       DocumentVersionId ,
       CreatedBy ,
       CreatedDate ,
       ModifiedBy ,
       ModifiedDate ,
       ClientIdentification,
	   ClinicalStatus,
	   ChangesResponse,
	   MentalStatusExam,
       MedicationEducation,
       TreatmentRecommendations,
	   Allergies,
	   GAFScore,
	   Comments)
select dvm.DocumentVersionId,
       d.orig_user_id ,
       d.orig_entry_chron ,
       d.user_id,
       d.entry_chron,
       d.patient_iden,
       d.clinical_status,
       d.changes_response,
       d.mental_status_exam,
       d.medication_education,
       d.treatment_recommendation,
       d.allergies,
       d.gaf_score,
       d.comments
  from Psych..Doc_Rx_Mgt d
       join Cstm_Conv_Map_DocumentVersions dvm on dvm.doc_session_no = d.doc_session_no and dvm.version_no = d.doc_version_no
 where not exists (select *
                     from CustomDocumentMedicationManagementNotes c
                    where c.DocumentVersionId = isnull(dvm.DocumentVersionId, -1)) 
                       
if @@error <> 0 goto error

set identity_insert CustomDocumentMedicationManagementNotePrescriptions on

insert into CustomDocumentMedicationManagementNotePrescriptions (
       MedicationManagementNotePrescriptionId
      ,CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate
      ,DocumentVersionId
      ,PsychMedication
      ,Action
      ,PrescriptionDate
      ,Status
      ,DrugName
      ,DrugStrength
      ,DrugStrengthUnitType
      ,DrugAdministrationMethod
      ,DrugForm
      ,Medication
      ,Dosage
      ,DosageeUnitType
      ,DosageDescription
      ,DosageFrequency
      ,SIG
      ,Quantity
      ,Refills
      ,RefillExpirationDate
      ,DaysSupply
      ,TSPPrescriptionId
      ,TSPEpiosodeId
      ,TSPNewPrescriptionID)
select d.prescription_id
      ,d.orig_user_id
      ,d.orig_entry_chron
      ,d.user_id
      ,d.entry_chron
      ,dvm.DocumentVersionId
      ,d.psych_med
      ,d.action
      ,d.prescription_date
      ,d.status
      ,d.drug_name
      ,d.drug_strength
      ,gcds.GlobalCodeId --drug_strength_unit_cd
      ,gcam.GlobalCodeId --drug_admin_method_cd
      ,gcdf.GlobalCodeId --dosage_form_cd
      ,d.medication
      ,d.dose
      ,gcdo.GlobalCodeId --dose_unit_cd
      ,d.dosage
      ,gcfr.GlobalCodeId --d.dose_freq_cd
      ,d.sig
      ,d.quantity
      ,d.refills
      ,d.expiration_date
      ,d.days_supply
      ,d.tsp_prescription_id
      ,d.tsp_episode_id
      ,d.tsp_new_prescription_id
  from Psych.dbo.Doc_Rx d
       join Cstm_Conv_Map_DocumentVersions dvm on dvm.doc_session_no = d.doc_session_no and dvm.version_no = d.doc_version_no
       left join GlobalCodes gcds on gcds.Category = ''XRXUNIT'' and gcds.ExternalCode1 = d.drug_strength_unit_cd       
       left join GlobalCodes gcdf on gcdf.Category = ''XRXDRUGFORM'' and gcdf.ExternalCode1 = d.dosage_form_cd       
       left join GlobalCodes gcam on gcam.Category = ''XRXADMINMETHOD'' and gcam.ExternalCode1 = d.drug_admin_method_cd       
       left join GlobalCodes gcdo on gcdo.Category = ''XRXUNIT'' and gcdo.ExternalCode1 = d.dose_unit_cd       
       left join GlobalCodes gcfr on gcfr.Category = ''XRXFREQUENCY'' and gcfr.ExternalCode1 = d.dose_freq_cd       

if @@error <> 0 goto error

set identity_insert CustomDocumentMedicationManagementNotePrescriptions off

return

error:

 raiserror 5010 ''Failed to execute csp_conv_Document_CustomDocumentMedicationManagementNotes''
    

' 
END
GO
