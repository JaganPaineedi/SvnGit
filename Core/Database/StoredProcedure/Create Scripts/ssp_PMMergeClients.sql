IF OBJECT_ID('dbo.ssp_PMMergeClients') IS NOT NULL
    DROP PROCEDURE dbo.ssp_PMMergeClients
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMMergeClients]
    @Client1Id INT ,
    @Client2Id INT ,
    @UserId INT                
/*********************************************************************                    
-- Stored Procedure: dbo.ssp_PMMergeClients                    
--                    
-- Copyright: 2010 Streamline Healthcare Solutions                    
--                    
-- Purpose:  Merge two selected clients               
--                    
-- Updates:                     
--	Date        Author      Purpose          
--	05.27.2010  Shifali		Created. 
--	08.05.2011	dharvey		Modified to include the remaining merge tables  
--  04.13.2015  SFarber     Added CM tables
--  08.13.2015	RQuigley	Move Service merge above DOcuments merge to
--							Handle documents trigger
-- 21.10.2015   SuryaBalan  Added join with ContractRateSites, since we are not going use SiteId of COntractRates table, as per task #618 N180 Customizations
--                          Before it was Single selection of Sites in COntract Rates Detail Page, now it is multiple selection, 
                            so whereever we are using ContractRates-SiteId, we need to join with ContractRateSites-SiteId
--  11.25.2015	MD Hussain	Replace Null value of Clients.MasterRecord with 'Y' instead of 'N' because existing data has Null values for MasterRecord column which is created through Inquiry screen 
							and it is preventing user to merge clients. Ref: Task #46 CEI - Support Go Live and task #382 Newaygo Support    
-- 12.04.2015	NJain		Added scsp_PMMergeClients for adding custom logic
-- 01.13.2015   Jayashree   Added logic for merging Contact Notes w.r.t Valley - Support Go Live # 204
-- 03.23.2016   Himmat      Added logic for merging ClientContact  Woodlands - Support # 272							
-- 27.06.2016    Shilpa      Added logic for merging ClientPrograms core bugs -# 2245
-- 20.12.2016   Neelima     Added RecordDeleted = 'Y',DeletedDate = GETDATE(),DeletedBy = @UserCode for ClientAddresses and ClientPhones table for the merged client address and client phones AspenPointe - Support Go Live -# 88
-- 17.07.2017	NJain		Updated to also Merge ClientInpatientVisits. Core Bugs #2395
-- 09.01.2017	Himmat		Primary Physician and Primary Clinician are not merging to Merged Client Core Bugs#2485
-- 03.28.2018	jstedman	Added ClientMedications, ClientMedicationScripts, ClientAllergies, ClientPharmacies, SurescriptsRefillRequests,
							SureScriptsMedicationHistoryResponse, SureScriptsRefillRequestsArchive, SureScriptsEligibilityResponse to Merge
							AspenPointe SGL 536

**********************************************************************

Text From SystemConfigurations.MergeClientsProcess
--------------------------------------------------------
	Running the Merge process will merge Client 1 with Client 2. 
	After the merge process, Client 1 will no longer exist in PracticeManagement or SmartCare. 
	To view information about Client 1, please see Client 2.  

	The following information from Client 1 will be added to Client 2: 
		* Authorizations 
		* Coverage Plans (If they do not exist) 
		* Documents 
		* Services 
		* Charges 
		* Client Payments 
		* Client Notes (Icons) 
		* Client Id Card Images 
		* Client Statement History  
		* Conact Notes
		* ClientContacts
		* ClientAddresses
		* ClientPhones

	The following information that now exists for Client 1 will be based on Client 2's information: 
		* Client Demographic Information 
		* Client Episode Information 
		* Program Enrollment 
		* Client Coverage History
         
**********************************************************************/
AS
    BEGIN TRY

        CREATE TABLE #PrimaryKeys
            (
              PrimaryKey INT ,
              TableName VARCHAR(250)
            )    
    
        DECLARE @UserCode VARCHAR(20)   
        DECLARE @ProviderId INT  

        SELECT  @UserCode = UserCode
        FROM    Staff
        WHERE   StaffId = @UserId    
    
  --
  -- Validate IDs
  -- 
        IF EXISTS ( SELECT  '*'
                    FROM    Clients c
                    WHERE   c.ClientId IN ( @Client1Id, @Client2Id )
               --Modified by MD Hussain on 11/25/2015 to replace Null value of Clients.MasterRecord with 'Y' instead of 'N'
                            AND ISNULL(c.MasterRecord, 'Y') = 'N' )
            AND EXISTS ( SELECT *
                         FROM   Clients c
                         WHERE  c.ClientId IN ( @Client1Id, @Client2Id )
                                AND c.MasterRecord = 'Y' )
            BEGIN
                RAISERROR ( 'Master client record cannot be merged with non-master record.',16,1)
            END
  
        SELECT TOP 1
                @ProviderId = pc.ProviderId
        FROM    ProviderClients pc
        WHERE   pc.ClientId = @Client1Id
                AND pc.ClientId <> pc.MasterClientId
                AND ISNULL(pc.RecordDeleted, 'N') = 'N'

        IF @ProviderId IS NOT NULL
            AND EXISTS ( SELECT *
                         FROM   ProviderClients pc
                         WHERE  pc.ClientId = @Client2Id
                                AND pc.ProviderId <> @ProviderId
                                AND ISNULL(pc.RecordDeleted, 'N') = 'N' )
            BEGIN
                RAISERROR ( 'Client records cannot be merged because they belong to different providers.',16,1)
            END

  --    
  -- Merge Client Coverage Plans    
  --  
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ClientCoveragePlanId ,
                'ClientCoveragePlans'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientCoveragePlans a
        WHERE   a.ClientId = @Client1Id
                AND NOT EXISTS ( SELECT 1
                                 FROM   ClientCoveragePlans ccp
                                 WHERE  ccp.ClientId = @Client2Id
                                        AND ccp.CoveragePlanId = a.CoveragePlanId
                                        AND ISNULL(ccp.InsuredId, '') = ISNULL(a.InsuredId, '')
                                        AND ISNULL(RecordDeleted, 'N') = 'N' )  

  --    
  -- Merge Services    
  --    
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ServiceId ,
                'Services'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    Services a
        WHERE   a.ClientId = @Client1Id   

  --    
  -- Merge Documents    
  --    
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.DocumentId ,
                'Documents'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    Documents a
        WHERE   a.ClientId = @Client1Id    

        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.SignatureId ,
                'DocumentSignatures'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    dbo.DocumentSignatures a
        WHERE   a.ClientId = @Client1Id    

  --    
  -- Merge Events    
  --    
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.EventId ,
                'Events'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    Events a
        WHERE   a.ClientId = @Client1Id    

 

  --
  -- Merge Charges
  --
        UPDATE  a
        SET     ClientCoveragePlanId = ccp2.ClientCoveragePlanId
        OUTPUT  inserted.ChargeId ,
                'Charges'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    Charges a
                JOIN ClientCoveragePlans ccp1 ON ccp1.ClientCoveragePlanId = a.ClientCoveragePlanId
                JOIN dbo.ClientCoveragePlans ccp2 ON ccp2.ClientId = @Client2Id
                                                     AND ccp2.CoveragePlanId = ccp1.CoveragePlanId
                                                     AND ISNULL(ccp2.InsuredId, '') = ISNULL(ccp1.InsuredId, '')
        WHERE   ccp1.ClientId = @Client1Id
                AND ISNULL(ccp2.RecordDeleted, 'N') = 'N'
      	    
  --    
  -- Merge AR Ledger  
  --    
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ARLedgerId ,
                'ARLedger'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ARLedger a
        WHERE   a.ClientId = @Client1Id    

  --
  -- Merge Client Payments
  --   
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.PaymentId ,
                'Payments'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    Payments a
        WHERE   a.ClientId = @Client1Id    
	    
  --    
  -- Merge Financial Activities    
  --    
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.FinancialActivityId ,
                'FinancialActivities'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    FinancialActivities a
        WHERE   a.ClientId = @Client1Id    
	    
	    
  --    
  -- Merge Client Notes    
  --    
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ClientNoteId ,
                'ClientNotes'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientNotes a
        WHERE   a.ClientId = @Client1Id    
	    

  --    
  -- Merge Image Records    
  --    
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ImageRecordId ,
                'ImageRecords'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ImageRecords a
        WHERE   a.ClientId = @Client1Id    
	    
  --    
  -- Merge Client ID Card Images    
  --    
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ClientScanId ,
                'ClientScans'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientScans a
        WHERE   a.ClientId = @Client1Id    
	    
	    
  --    
  -- Merge Client Statements   
  --    
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ClientStatementId ,
                'ClientStatements'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientStatements a
        WHERE   a.ClientId = @Client1Id    

  -- start AspenPointe SGL 536
  --
  -- Merge Client Medications
  --
		UPDATE	a
		SET		ClientId = @Client2Id
		OUTPUT	inserted.ClientMedicationId,
				'ClientMedications'
				INTO #PrimaryKeys ( PrimaryKey, TableName )
		--DECLARE @Client1Id INT = 5; SELECT *
		FROM	ClientMedications a
		WHERE	a.ClientId = @Client1Id
				AND ISNULL(a.RecordDeleted, 'N') = 'N'

  --
  -- Merge Client Medication Scripts
  --
		UPDATE	a
		SET		ClientId = @Client2Id
		OUTPUT	inserted.ClientMedicationScriptId,
				'ClientMedicationScripts'
				INTO #PrimaryKeys ( PrimaryKey, TableName )
		--DECLARE @Client1Id INT = 5; SELECT TOP 100 *
		FROM	ClientMedicationScripts a
		WHERE	a.ClientId = @Client1Id
				AND ISNULL(a.RecordDeleted, 'N') = 'N'

  --
  -- Merge Client Allergies
  --
		UPDATE	a
		SET		ClientId = @Client2Id
		OUTPUT	inserted.ClientAllergyId,
				'ClientAllergies'
				INTO #PrimaryKeys ( PrimaryKey, TableName )
		--DECLARE @Client1Id INT = 16068, @Client2Id INT = 10004956; SELECT TOP 100 *
		FROM	ClientAllergies a
		WHERE	a.ClientId = @Client1Id
				AND ISNULL(a.RecordDeleted, 'N') = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM ClientAllergies a1
					WHERE a1.ClientId = @Client2Id
							AND ISNULL(a1.RecordDeleted, 'N') = 'N'
							AND a1.AllergenConceptId = a.AllergenConceptId
				)

  --
  -- Merge Client Pharmacies
  --
		UPDATE	a
		SET		ClientId = @Client2Id
		OUTPUT	inserted.ClientPharmacyId,
				'ClientPharmacies'
				INTO #PrimaryKeys ( PrimaryKey, TableName )
		--DECLARE @Client1Id INT = 10005186, @Client2Id INT = 5; SELECT TOP 100 *
		FROM	ClientPharmacies a
		WHERE	a.ClientId = @Client1Id
				AND ISNULL(a.RecordDeleted, 'N') = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM ClientPharmacies a1
					WHERE a1.ClientId = @Client2Id
							AND ISNULL(a1.RecordDeleted, 'N') = 'N'
							AND a1.PharmacyId = a.PharmacyId
				)

  --
  -- Merge Client SurescriptsRefillRequests
  --
		UPDATE	a
		SET		ClientId = @Client2Id
		OUTPUT	inserted.SurescriptsRefillRequestId,
				'SurescriptsRefillRequests'
				INTO #PrimaryKeys ( PrimaryKey, TableName )
		--DECLARE @Client1Id INT = 10010786; SELECT TOP 100 *
		FROM	SurescriptsRefillRequests a
		WHERE	a.ClientId = @Client1Id
				AND ISNULL(a.RecordDeleted, 'N') = 'N'

  --
  -- Merge Client SureScriptsMedicationHistoryResponse
  --
		UPDATE	a
		SET		ClientId = @Client2Id
		OUTPUT	inserted.SureScriptsMedicationHistoryResponseId,
				'SureScriptsMedicationHistoryResponse'
				INTO #PrimaryKeys ( PrimaryKey, TableName )
		--DECLARE @Client1Id INT = 5; SELECT TOP 100 *
		FROM	SureScriptsMedicationHistoryResponse a
		WHERE	a.ClientId = @Client1Id
				AND ISNULL(a.RecordDeleted, 'N') = 'N'

  --
  -- Merge Client SureScriptsRefillRequestsArchive
  --
		UPDATE	a
		SET		ClientId = @Client2Id
		OUTPUT	inserted.SureScriptsRefillRequestsArchiveId,
				'SureScriptsRefillRequestsArchive'
				INTO #PrimaryKeys ( PrimaryKey, TableName )
		--DECLARE @Client1Id INT = 5; SELECT TOP 100 *
		FROM	SureScriptsRefillRequestsArchive a
		WHERE	a.ClientId = @Client1Id
				AND ISNULL(a.RecordDeleted, 'N') = 'N'

  --
  -- Merge Client SureScriptsEligibilityResponse
  --
		UPDATE	a
		SET		ClientId = @Client2Id
		OUTPUT	inserted.SureScriptsEligibilityResponseId,
				'SureScriptsEligibilityResponse'
				INTO #PrimaryKeys ( PrimaryKey, TableName )
		--DECLARE @Client1Id INT = 10005737; SELECT TOP 100 *
		FROM	SureScriptsEligibilityResponse a
		WHERE	a.ClientId = @Client1Id
				AND ISNULL(a.RecordDeleted, 'N') = 'N'

  -- End AspenPointe SGL 536

  --    
  -- Merge Client Aliases    
  --    
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ClientAliasId ,
                'ClientAliases'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientAliases a
        WHERE   a.ClientId = @Client1Id    
	    
  --
  -- Merge Alerts and Messages
  --   
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.AlertId ,
                'Alerts'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    Alerts a
        WHERE   a.ClientId = @Client1Id


        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.MessageId ,
                'Messages'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    Messages a
        WHERE   a.ClientId = @Client1Id

  -- 
  -- Merge Claims
  -- 
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ClaimId ,
                'Claims'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    Claims a
        WHERE   a.ClientId = @Client1Id 
  
  --
  -- Merge Provider Authorizations  
  -- 
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ProviderAuthorizationDocumentId ,
                'ProviderAuthorizationDocuments'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ProviderAuthorizationDocuments a
        WHERE   a.ClientId = @Client1Id 
  
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ProviderAuthorizationId ,
                'ProviderAuthorizations'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ProviderAuthorizations a
        WHERE   a.ClientId = @Client1Id

        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ProviderAuthorizationHistoryId ,
                'ProviderAuthorizationsHistory'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ProviderAuthorizationsHistory a
        WHERE   a.ClientId = @Client1Id


  --
  -- Merge Contract rates
  --
        UPDATE  a
        SET     ClientId = @Client2Id
        FROM    ContractRates a
        WHERE   a.ClientId = @Client1Id
                AND NOT EXISTS ( SELECT *
                                 FROM   dbo.ContractRates cr2
                                        LEFT JOIN ContractRateSites CRS ON cr2.ContractRateId = CRS.ContractRateId
                                                                           AND ISNULL(CRS.RecordDeleted, 'N') = 'N'
                                 WHERE  cr2.ContractId = a.ContractId
                                        AND cr2.ClientId = @Client2Id
                                        AND cr2.BillingCodeId = a.BillingCodeId
                                        AND ISNULL(cr2.Modifier1, '') = ISNULL(a.Modifier1, '')
                                        AND ISNULL(cr2.Modifier2, '') = ISNULL(a.Modifier2, '')
                                        AND ISNULL(cr2.Modifier3, '') = ISNULL(a.Modifier3, '')
                                        AND ISNULL(cr2.Modifier4, '') = ISNULL(a.Modifier4, '')
                                        AND ISNULL(CRS.SiteId, -1) = ISNULL(a.SiteId, -1)
                                        AND ISNULL(cr2.RecordDeleted, 'N') = 'N'
                                        AND ISNULL(CRS.RecordDeleted, 'N') = 'N' )
                                  
  --
  -- Merge Provider Clients
  --
        UPDATE  a
        SET     RecordDeleted = 'Y' ,
                DeletedBy = @UserCode ,
                DeletedDate = GETDATE()
        OUTPUT  inserted.ProviderClientId ,
                'ProviderClients'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ProviderClients a
        WHERE   a.ClientId = @Client1Id
                AND ISNULL(a.RecordDeleted, 'N') = 'N'
		  
        UPDATE  a
        SET     MasterClientId = @Client2Id
        OUTPUT  inserted.ProviderClientId ,
                'ProviderClients'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ProviderClients a
        WHERE   a.MasterClientId = @Client1Id
                AND ISNULL(a.RecordDeleted, 'N') = 'N'
                
  --Merge  PrimaryClinicianId,PrimaryPhysicianId
                    
   UPDATE  a      
        set PrimaryClinicianId = (select PrimaryClinicianId from ClientS where ClientId=@Client1Id and ISNULL(RecordDeleted, 'N') = 'N' ),  
         PrimaryPhysicianId = (select PrimaryPhysicianId from ClientS where ClientId=@Client1Id  and ISNULL(RecordDeleted, 'N') = 'N' )  
        OUTPUT  inserted.ClientId ,      
                'Clients'      
                INTO #PrimaryKeys ( PrimaryKey, TableName )      
        FROM    Clients a      
        WHERE   a.ClientId = @Client2Id  
               AND ISNULL(a.RecordDeleted, 'N') = 'N'            


-- 01.13.2015    Jayashree
-- Merge Conact Notes
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ClientContactNoteId ,
                'ClientContactNotes'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientContactNotes a
        WHERE   a.ClientId = @Client1Id  
	    
 --03.23.2016    Himmat  
 --Merge ClientContacts  
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.ClientContactId ,
                'ClientContacts'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientContacts a
        WHERE   a.ClientId = @Client1Id       
	    
-----Merge ClientAddresses 

        UPDATE  a
        SET     RecordDeleted = 'Y' ,
                DeletedDate = GETDATE() ,
                DeletedBy = @UserCode
        OUTPUT  inserted.ClientAddressId ,
                'ClientAddresses'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientAddresses a
        WHERE   a.ClientId = @Client1Id  
  
--  ---Merge ClientPhones
        UPDATE  a
        SET     RecordDeleted = 'Y' ,
                DeletedDate = GETDATE() ,
                DeletedBy = @UserCode
        OUTPUT  inserted.ClientPhoneId ,
                'ClientPhones'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientPhones a
        WHERE   a.ClientId = @Client1Id  	    
	    
   --Merge ClientPrograms
        UPDATE  a
        SET     ClientId = @Client2Id ,
                PrimaryAssignment = 'N'
        OUTPUT  inserted.ClientProgramId ,
                'ClientPrograms'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientPrograms a
        WHERE   a.ClientId = @Client1Id  
  
  
  -- Merge ClientInpatientVisits	
        UPDATE  a
        SET     ClientId = @Client2Id
        OUTPUT  inserted.CLientInpatientVisitId ,
                'ClientInpatientVisits'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    dbo.ClientInpatientVisits a
        WHERE   a.ClientId = @Client1Id
 
     
  -- Delete Client 1 From Client Table    
  --    
        UPDATE  a
        SET     RecordDeleted = 'Y' ,
                DeletedDate = GETDATE() ,
                DeletedBy = @UserCode
        OUTPUT  inserted.ClientId ,
                'Clients'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    Clients a
        WHERE   a.ClientId = @Client1Id
                AND ISNULL(a.RecordDeleted, 'N') = 'N'
                
  
  --    
  -- Delete Client 1 From ClientEpisodes Table    
  --    
        UPDATE  a
        SET     RecordDeleted = 'Y' ,
                DeletedDate = GETDATE() ,
                DeletedBy = @UserCode
        OUTPUT  inserted.ClientEpisodeId ,
                'ClientEpisodes'
                INTO #PrimaryKeys ( PrimaryKey, TableName )
        FROM    ClientEpisodes a
        WHERE   a.ClientId = @Client1Id
                AND ISNULL(a.RecordDeleted, 'N') = 'N'
 
   
  --
  -- Populate merge log
  -- 	    
        INSERT  INTO MergedClientsLog
                ( FromClientId ,
                  ToClientId ,
                  TableName ,
                  PrimaryKey ,
                  CreatedBy ,
                  CreatedDate ,
                  ModifiedBy ,
                  ModifiedDate
                )
                SELECT  @Client1Id ,
                        @Client2Id ,
                        TableName ,
                        PrimaryKey ,
                        @UserCode ,
                        GETDATE() ,
                        @UserCode ,
                        GETDATE()
                FROM    #PrimaryKeys
                ORDER BY TableName ,
                        PrimaryKey 
	    
	    
        IF EXISTS ( SELECT  *
                    FROM    sys.procedures
                    WHERE   name = 'scsp_PMMergeClients' )
            BEGIN
	
                EXEC scsp_PMMergeClients @Client1Id, @Client2Id, @UserId
	
            END	
	    
        SELECT  0

    END TRY                                                        
    BEGIN CATCH   

        DECLARE @ErrorMessage VARCHAR(MAX)
        DECLARE @ErrorNumber INT
        DECLARE @ErrorSeverity INT
        DECLARE @ErrorState INT
        DECLARE @ErrorLine INT
        DECLARE @ErrorProcedure VARCHAR(200)
         
        SELECT  @ErrorNumber = ERROR_NUMBER() ,
                @ErrorSeverity = ERROR_SEVERITY() ,
                @ErrorState = ERROR_STATE() ,
                @ErrorLine = ERROR_LINE() ,
                @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-')

        SELECT  @ErrorMessage = 'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 'Message: ' + ERROR_MESSAGE()
 

       -- RAISERROR(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine)

    RAISERROR (
    @ErrorMessage
    ,16
    ,1
    );
         
        SELECT  -1
                                                                               
    END CATCH      

GO
