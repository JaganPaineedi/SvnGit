/****** Object:  StoredProcedure [dbo].[csp_conv_Document_MedicationManagement]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_MedicationManagement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_MedicationManagement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_MedicationManagement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
CREATE PROCEDURE [dbo].[csp_conv_Document_MedicationManagement]
AS 
    INSERT  INTO MedicationManagement
            ( DocumentVersionId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              Action ,
              PrescriptionDate ,
              ClinicianID ,
              Status ,
              DrugName ,
              DrugStrength ,
              DrugStrengthUnitCD ,
              DosageFormCD ,
              Medication ,
              Dose ,
              DosageUnitCD ,
              Dosage ,
              DosageFrequencyCD ,
              DrugAdministrationMethodCD ,
              SIG ,
              Quantity ,
              DaysSupply ,
              Refills ,
              ExpirationDate ,
              PsychMediaction ,
              TSPPrescriptionID ,
              TSPEpiosodeId ,
              TSPNewPrescriptionID
            )
            SELECT  dvm.DocumentVersionId ,
                    d.orig_user_id ,
                    d.orig_entry_chron ,
                    d.user_id ,
                    d.entry_chron ,
                    d.action ,
                    d.prescription_date ,
                    d.clinician_id ,
                    d.status ,
                    d.drug_name ,
                    d.drug_strength ,
                    d.drug_strength_unit_cd ,
                    d.dosage_form_cd ,
                    d.medication ,
                    d.dose ,
                    d.dose_unit_cd ,
                    d.dosage ,
                    d.dose_freq_cd ,
                    d.drug_admin_method_cd ,
                    d.sig ,
                    d.quantity ,
                    d.days_supply ,
                    d.refills ,
                    d.expiration_date ,
                    d.psych_med ,
                    d.tsp_prescription_id ,
                    d.tsp_episode_id ,
                    d.tsp_new_prescription_id
            FROM    Psych..Doc_Rx d
                    left JOIN Cstm_Conv_Map_DocumentVersions dvm ON dvm.doc_session_no = d.doc_session_no
                                                              AND dvm.version_no = d.doc_version_no
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   MedicationManagement c
                                 WHERE  c.DocumentVersionId = ISNULL(dvm.DocumentVersionId,
                                                              -1) )      

       
    IF @@error <> 0 
        GOTO error

    RETURN

    error:

    RAISERROR 5010 ''Failed to execute csp_conv_Document_MedicationManagement''

' 
END
GO
