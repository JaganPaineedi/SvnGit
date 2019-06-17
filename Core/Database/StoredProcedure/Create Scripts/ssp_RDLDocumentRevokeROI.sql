IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_RDLDocumentRevokeROI]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[ssp_RDLDocumentRevokeROI] 
  END 

go 

/********************************************************************************                                                     
-- Stored Procedure: ssp_RDLDocumentRevokeROI  655     
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
CREATE PROCEDURE [dbo].[ssp_RDLDocumentRevokeROI] (@DocumentVersionId INT) 
AS 
  BEGIN try 
      DECLARE @Address   VARCHAR(250), 
              @MainPhone VARCHAR(50), 
              @FaxNumber VARCHAR(50) 

      SELECT TOP 1 @Address = addressdisplay, 
                   @MainPhone = mainphone, 
                   @FaxNumber = faxnumber 
      FROM   agency 

      DECLARE @AddressString VARCHAR(max) 

      SET @AddressString = '' 

      IF @Address IS NOT NULL 
         AND @Address <> '' 
        BEGIN 
            SET @AddressString += '(' + @Address + ')' 
        END 

      IF @MainPhone IS NOT NULL 
         AND @MainPhone <> '' 
        BEGIN 
            SET @AddressString += '(' + @MainPhone + ')' 
        END 

      IF @FaxNumber IS NOT NULL 
         AND @FaxNumber <> '' 
        BEGIN 
            SET @AddressString += '(' + @FaxNumber + ')' 
        END 

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

      SELECT TOP 1 (SELECT TOP 1 agencyname 
                    FROM   agency) 
                   AS AgencyName, 
                   @AddressString 
                   AS AgencyAddressPhoneFax, 
                   C.clientid, 
                   Isnull(C.firstname, '') + ' ' 
                   + Isnull(C.lastname, '') 
                   AS ClientName, 
                   CONVERT(VARCHAR, C.dob, 101) 
                   AS DOB, 
                   CASE 
                     WHEN ( CIR.releasetoid IS NULL ) THEN 'O' 
                     ELSE ( 'C' ) 
                   END 
                   AS ContactType, 
                   CIR.releasetoname 
                   AS OrganizationName, 
                   Isnull(CC.firstname, '') + ' ' 
                   + Isnull(CC.lastname, '') 
                   ClientContactName, 
                   Ltrim(Rtrim(Substring(cir.comment, 0, Charindex('|', 
                   cir.comment))))        AS 
                   OrganizationAddress, 
                   Ltrim(Rtrim(Substring(cir.comment, 
                               Charindex('|', cir.comment) 
                               + 1, 
                               8000))) AS 
                   OrganizationPhoneNumber, 
                   CCA.display 
                   AS ClientContactAddress, 
                   CASE 
                     WHEN Ltrim(Rtrim(Substring(cir.comment, 0, 
                                      Charindex('|', cir.comment)))) IS 
                          NOT NULL 
                           OR cca.display IS NOT NULL THEN 'Y' 
                     ELSE 'N' 
                   END 
                   IsClientContactAddressExists, 
                   CCP.phonenumber 
                   AS ClientContactPhoneNumber, 
                   CASE 
                     WHEN Ltrim(Rtrim(Substring(cir.comment, 
                                      Charindex('|', cir.comment) + 1, 8000) 
                                )) IS 
                          NOT NULL 
                           OR CCP.phonenumber IS NOT NULL THEN 'Y' 
                     ELSE 'N' 
                   END 
                   IsPhoneNumberExists, 
                   CONVERT(VARCHAR, CIR.startdate, 101) 
                   AS StartDate, 
                   CONVERT(VARCHAR, CIR.enddate, 101) 
                   AS EndDate, 
                   RROI.[documentversionid], 
                   RROI.[createdby], 
                   RROI.[createddate], 
                   RROI.[modifiedby], 
                   RROI.[modifieddate], 
                   RROI.[recorddeleted], 
                   RROI.[deleteddate], 
                   RROI.[deletedby], 
                   RROI.[clientinformationreleaseid], 
                   --RROI.[StaffId], 
                   RROI.[revokeenddate], 
                   --RROI.[VerbalRevocation], 
                   ClientWrittenConsent,
                   CONVERT(VARCHAR, Getdate(), 101) 
                   AS RevokeDate, 
                   CONVERT(VARCHAR(10), D.effectivedate, 101) 
                   AS EffectiveDate, 
                   @AdmitDate 
                   AS AdmitDate, 
                   Isnull(C.lastname + ', ', '') + C.firstname 
                   + ' (' + CONVERT(VARCHAR(10), C.clientid) + ')' 
                   AS ClientNameF ,
                   (SELECT TOP 1 [Description] FROM SystemConfigurationKeys WHERE [KEY] = 'DISPLAYROIREVOKETEXT' AND ISNULL(RecordDeleted, 'N') = 'N') as DISPLAYROIREVOKETEXT
      FROM   [dbo].DocumentRevokeReleaseOfInformations RROI 
             INNER JOIN clientinformationreleases CIR 
                     ON RROI.clientinformationreleaseid = 
                        CIR.clientinformationreleaseid 
             LEFT JOIN clientcontacts CC 
                    ON CIR.releasetoid = CC.clientcontactid 
             --AS  ReleaseToId stores the ClientContactId for Documents which are released to any entity or organization.  
             INNER JOIN documentversions DV 
                     ON dv.documentversionid = RROI.documentversionid 
             INNER JOIN documents D 
                     ON D.documentid = Dv.documentid 
             INNER JOIN clients C 
                     ON D.clientid = C.clientid 
             LEFT JOIN clientcontactaddresses CCA 
                    ON CCA.clientcontactid = CC.clientcontactid 
             LEFT JOIN clientcontactphones CCP 
                    ON CCP.clientcontactid = CC.clientcontactid 
      WHERE  RROI.[documentversionid] = @DocumentVersionId 
             AND Isnull(RROI.recorddeleted, 'N') = 'N' 
             AND Isnull(CIR.recorddeleted, 'N') = 'N' 
             AND Isnull(CC.recorddeleted, 'N') = 'N' 
             AND Isnull(DV.recorddeleted, 'N') = 'N' 
             AND Isnull(D.recorddeleted, 'N') = 'N' 
             AND Isnull(C.recorddeleted, 'N') = 'N' 
             AND Isnull(CCA.recorddeleted, 'N') = 'N' 
             AND Isnull(CCP.recorddeleted, 'N') = 'N' 
  /* and CIR.ReleaseToId is not null  */ 
  /*Releasetoold is null when no contact is selected from  'Releaseto' dropdown in tab 'Release of Information Log'    
                                         ,the release to name is typed into the dropdown */ 
  END try 

  BEGIN catch 
      DECLARE @Error VARCHAR(8000) 

      SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                   + CONVERT(VARCHAR(4000), Error_message()) 
                   + '*****' 
                   + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                   'ssp_RDLDocumentRevokeROI') 
                   + '*****' + CONVERT(VARCHAR, Error_line()) 
                   + '*****ERROR_SEVERITY=' 
                   + CONVERT(VARCHAR, Error_severity()) 
                   + '*****ERROR_STATE=' 
                   + CONVERT(VARCHAR, Error_state()) 

      RAISERROR (@Error /* Message text*/,16 /*Severity*/,1 /*State*/) 
  END catch 