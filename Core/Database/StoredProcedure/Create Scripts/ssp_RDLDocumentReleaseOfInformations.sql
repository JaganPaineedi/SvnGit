IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_RDLDocumentReleaseOfInformations]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[ssp_RDLDocumentReleaseOfInformations] 
  END 

go 

/********************************************************************************                                                     
-- Stored Procedure: ssp_RDLDocumentReleaseOfInformations  655     
--       
-- Copyright: Streamline Healthcare Solutions       
--       
-- Purpose: RDL for Custom RDLRevokeReleaseofInformation.       
--       
-- Author:  Alok Kumar 
-- Date:    22/Nov/2017  
-- Ref:		Task#2013 Spring River - Customizations

Modified Date            Name           Description 
22/Nov/2017         Alok Kumar          Created 
*********************************************************************************/ 
CREATE PROCEDURE [dbo].[ssp_RDLDocumentReleaseOfInformations] (@DocumentVersionId INT) 
AS 
  BEGIN try 

      DECLARE @AdmitDate VARCHAR(10) 
      SET @AdmitDate='' 
      --To get the AdmitDate for Footer 
      SELECT TOP 1 @AdmitDate = CONVERT(VARCHAR(10), CE.registrationdate, 101) 
      FROM   documents DS 
             JOIN clientepisodes CE 
               ON DS.clientid = CE.clientid 
      WHERE  inprogressdocumentversionid = @DocumentVersionId 
             AND Isnull(CE.recorddeleted, 'N') = 'N' 
             AND Isnull(CE.recorddeleted, 'N') = 'N' 
      ORDER  BY CE.episodenumber DESC 


      SELECT TOP 1 (SELECT TOP 1 agencyname  FROM   agency)  AS AgencyName, 
                   C.clientid, 
                   Isnull(C.lastname, '') + ', '
                   + Isnull(C.firstname, '') 
                   AS ClientName, 
                   CONVERT(VARCHAR(10), C.dob, 101) AS DOB, 
                   CONVERT(VARCHAR(10), D.effectivedate, 101)  AS EffectiveDate, 
                   @AdmitDate  AS AdmitDate, 
                   Isnull(C.lastname + ', ', '') + C.firstname + ' (' + CONVERT(VARCHAR(10), C.clientid) + ')'  AS ClientNameF, 
                   RROI.DocumentVersionId,
					RROI.ProgramId,
					RROI.ReleaseToFromContactId,
					--CONVERT(VARCHAR(10), RROI.UsedOrDisclosedStartDate, 101) AS UsedOrDisclosedStartDate,
					--CONVERT(VARCHAR(10), RROI.UsedOrDisclosedEndDate, 101) AS UsedOrDisclosedEndDate,
					dbo.ssf_GetGlobalCodeNameById(RROI.ROIType) AS ROIType,
					RROI.OtherPurposeOfDisclosure,
					CONVERT(VARCHAR(10), RROI.ExpirationStartDate, 101) AS ExpirationStartDate,
					CONVERT(VARCHAR(10), RROI.ExpirationEndDate, 101) AS ExpirationEndDate,
					RROI.OtherInformationTobeUsedText,
					(SELECT TOP 1 [Value] FROM SystemConfigurationKeys WHERE [KEY] = 'DISPLAYROITERMSTEXT' AND ISNULL(RecordDeleted, 'N') = 'N') as DISPLAYROITERMSTEXT,
					(SELECT TOP 1 [Value] FROM SystemConfigurationKeys WHERE [KEY] = 'DISPLAYROINOTICETOCLIENT' AND ISNULL(RecordDeleted, 'N') = 'N') as DISPLAYROINOTICETOCLIENT,
					(SELECT TOP 1 [Value] FROM SystemConfigurationKeys WHERE [KEY] = 'DISPLAYROIACCESSTOREC' AND ISNULL(RecordDeleted, 'N') = 'N') as DISPLAYROIACCESSTOREC,
					RROI.NoticeToClient,
					RROI.AccessToMyRecord,
					RROI.Attention,
					RROI.ContactAddress,
					RROI.ContactCity,
					(SELECT Top 1 StateName from States where StateAbbreviation = RROI.ContactState)  AS ContactState,
					RROI.ContactPhoneNumber,
					RROI.ContactZip,
					RROI.ContactFax,
					RROI.CopyGivenToClient,
					RROI.AgencyStaff,
					RROI.Restrictions,
					RROI.AlcoholDrugAbuse,
					RROI.AIDSRelatedComplex,
					ps.ProgramName,
					CONVERT(VARCHAR(10), RROI.RecordsStartDate, 101) AS RecordsStartDate,
					CONVERT(VARCHAR(10), RROI.RecordsEndDate, 101) AS RecordsEndDate
      FROM   [dbo].DocumentReleaseOfInformations RROI 
             INNER JOIN documentversions DV  ON dv.documentversionid = RROI.documentversionid 
             INNER JOIN documents D  ON D.documentid = Dv.documentid 
             INNER JOIN clients C  ON D.clientid = C.clientid 
             left join Programs ps on RROI.ProgramId = ps.ProgramId  AND Isnull(ps.recorddeleted, 'N') = 'N' 
      WHERE  RROI.[documentversionid] = @DocumentVersionId 
             AND Isnull(RROI.recorddeleted, 'N') = 'N' 
             AND Isnull(DV.recorddeleted, 'N') = 'N' 
             AND Isnull(D.recorddeleted, 'N') = 'N' 
             AND Isnull(C.recorddeleted, 'N') = 'N' 

  END try 

  BEGIN catch 
      DECLARE @Error VARCHAR(8000) 

      SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                   + CONVERT(VARCHAR(4000), Error_message()) 
                   + '*****' 
                   + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                   'ssp_RDLDocumentReleaseOfInformations') 
                   + '*****' + CONVERT(VARCHAR, Error_line()) 
                   + '*****ERROR_SEVERITY=' 
                   + CONVERT(VARCHAR, Error_severity()) 
                   + '*****ERROR_STATE=' 
                   + CONVERT(VARCHAR, Error_state()) 

      RAISERROR (@Error /* Message text*/,16 /*Severity*/,1 /*State*/) 
  END catch 