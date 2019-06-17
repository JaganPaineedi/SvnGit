 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientMedicationScriptHistory]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE ssp_SCGetClientMedicationScriptHistory
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientMedicationScriptHistory]    Script Date: 2/20/2014 10:53:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientMedicationScriptHistory] (
	@ClientId INT
	,@ClientMedicationId INT
	,@ClientMedicationScriptId INT
	)
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetClientMedicationScriptHistory                */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    27/Nov/2007                                         */
/*                                                                   */
/* Purpose:  To Get Client Medication's Scripts  Data */
/*                                                                   */
/* Input Parameters: none        @ClientId,@ClientMedicationId */
/*                                                                   */
/* Output Parameters:   None                           */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:Order Details Page of Medication Mgt                                                              
       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date			Author				Purpose                                    */
/*  27/Nov/2007		Sonia Dhamija		Created                                    */
/* 4th April 2008	Sonia Dhamija		Altered (as per DataModel Changes*/
/* 26th May 2008	Sonia				Altered(To retrive Script History based on scriptId also*/
/* 25 Nov 2008		Loveena				Altered(To display Reprint Reason in Script History)*/
/* 12 Feb 2009		Loveena				Altered(To display Locations in Script History in Order Details Page)*/
/* Jun 26 2013		Chuck Blaine		Added cases for electronic ordering method */
/* January 14,2014	Kalpers				wrapped a common table around the query to allow for alternative sort and added an additional select to retrieve printed and faxed discontinued medications */
/* January 23 2014	Kalpers				Copied the logic from the outbound prescripts sproc and made changes to match the original sproc */
/* Feb 20,    2014	Kalpers				Removed the join to Clientmedicationscriptdrugstengths and added the where @ClientMedicationId into the join on MedicationId 
										Added a check for deleted pending records that were also cancel or discontinued to show the message that they were canceled by user */
/* June 22, 2015	Gautam				What : Added code to display delivery methoad for old data where record is not available in table ClientMedicationScriptActivitiesPending 
										Why : KCMHSAS 3.5 Implementation: #302 3.5Rx: Delivery method not showing history*/
/* 20/Oct/2015		Revathi				What:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
										Why:task #609, Network180 Customization  */
/* 16/Oct/2016		Anto 		        What:Modified the logic to pull the StatusDescription from ClientMedicationScriptActivities table and added a case Elec which is missing in DeliveryMethod.          
									    Why:Task #608, KCMHSAS - Support  */		
/*04/April/2018    PranayBodhu               Added logic to show discontinued medications which are send via Print,Fax,None w.r.t AspenPointe - Support Go Live Task#581.1*/																											
/*********************************************************************/
	

WITH outbound
AS (
	SELECT CASE 
			WHEN scr.createddate IS NOT NULL
				THEN scr.createddate
			ELSE cmsa.CreatedDate
			END AS createddate
		,CASE 
			WHEN scr.createdby IS NOT NULL
				THEN scr.createdby
			ELSE cmsa.createdby
			END AS createdby
		,CASE 
			WHEN cmsa.Method = 'E'
				AND scr.SurescriptsOutgoingMessageId IS NOT NULL
				THEN 'Elec-' + CASE 
						WHEN scr.ChangeOfPrescriptionStatusFlag = 'C'
							THEN 'Cancel'
						ELSE 'Discontinued'
						END
			WHEN cmsa.Method = 'E'
				AND scr.SurescriptsOutgoingMessageId IS NULL
				THEN 'Elec.'
			WHEN cmsa.Method = 'P'
				THEN 'Print'
			WHEN cmsa.Method = 'F'
				THEN 'Fax'
			END AS Method
		,CASE 
			WHEN ISNULL(cmsap.RecordDeleted, 'N') = 'Y'
				AND cmsa.STATUS = 5562
				THEN 'Pending-CancelByUser'
			WHEN cmsa.STATUS = 5564
				THEN 'Failed'
			WHEN cmsa.STATUS = 5561
				THEN 'Queued'
			WHEN cmsa.STATUS = 5541
				THEN 'Waiting'
			WHEN cmsa.STATUS = 5562
				THEN 'Pending'
			WHEN cmsa.STATUS = 5563
				THEN 'Successful'
			END AS STATUS
		,cmsa.StatusDescription
		,cms.OrderingPrescriberName
		,cms.ClientId
		-- Modified by Revathi 20/Oct/2015
        ,case when  ISNULL(C.ClientType,'I')='I' then ( ISNULL(c.LastName,'') + ', ' + ISNULL(c.FirstName,'')) else ISNULL(C.OrganizationName,'') end  AS PatientName 
		,md.MedicationName
		,cmsa.PharmacyId
		,cm.ClientMedicationId
		,cmsap.ClientMedicationScriptActivityId
		,cms.ClientMedicationScriptId
		,p.PharmacyName
		,loc.LocationName
		,ISNULL(gc.CodeName, '') AS Reason
	FROM ClientMedicationScriptActivitiesPending cmsap
	INNER JOIN ClientMedicationScriptActivities cmsa ON cmsa.ClientMedicationScriptActivityId = cmsap.ClientMedicationScriptActivityId
	INNER JOIN ClientMedicationScripts cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
	INNER JOIN Clients c ON c.ClientId = cms.ClientId
	INNER JOIN ClientMedications cm ON cm.ClientMedicationId = @ClientMedicationId --cmsds.ClientMedicationId
	INNER JOIN MDMedicationNames md ON md.MedicationNameId = cm.MedicationNameId
	INNER JOIN Staff s ON s.StaffId = cms.OrderingPrescriberId
	LEFT JOIN Pharmacies p ON p.PharmacyId = cmsa.PharmacyId
	LEFT JOIN dbo.SurescriptsCancelRequests scr ON (scr.SurescriptsOutgoingMessageId = cmsa.SureScriptsOutgoingMessageId)
	LEFT JOIN GlobalCodes gc ON (gc.GlobalCodeID = CMSA.Reason)
	LEFT JOIN Locations loc ON (
			loc.LocationId = CMS.LocationId
			AND (ISNULL(loc.RecordDeleted, 'N') <> 'Y')
			)
	WHERE CMS.clientid = @ClientId
		AND CMS.ClientMedicationScriptId = @ClientMedicationScriptId
		AND ISNULL(cms.WaitingPrescriberApproval, 'N') <> 'Y'
		AND (
			ISNULL(cmsap.RecordDeleted, 'N') <> 'Y'
			OR scr.SurescriptsOutgoingMessageId IS NOT NULL
			)
		AND ISNULL(cmsa.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(cms.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
		--AND ISNULL(cmsds.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(md.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
	
	UNION ALL
	
	SELECT scr.ModifiedDate
		,scr.ModifiedBy AS createdby
		,CASE 
			WHEN cmsa.Method = 'E'
				AND scr.SurescriptsOutgoingMessageId IS NOT NULL
				THEN 'Elec-' + CASE 
						WHEN scr.ChangeOfPrescriptionStatusFlag = 'C'
							THEN 'Cancel-Response'
						ELSE 'Discontinued-Response'
						END
			WHEN cmsa.Method = 'E'
				AND scr.SurescriptsOutgoingMessageId IS NULL
				THEN 'Elec.'
			WHEN cmsa.Method = 'P'
				THEN 'Print'
			WHEN cmsa.Method = 'F'
				THEN 'Fax'
			END AS Method
		,CASE 
			WHEN ISNULL(cmsap.RecordDeleted, 'N') = 'Y'
				AND cmsa.STATUS = 5562
				THEN 'Pending-CancelByUser'
			WHEN cmsa.STATUS = 5564
				THEN 'Failed'
			WHEN cmsa.STATUS = 5561
				THEN 'Queued'
			WHEN cmsa.STATUS = 5541
				THEN 'Waiting'
			WHEN cmsa.STATUS = 5562
				THEN 'Pending'
			WHEN cmsa.STATUS = 5563
				THEN 'Received'
			END AS STATUS
		,scr.CancelRxResponse AS StatusDescription
		,cms.OrderingPrescriberName
		,cms.ClientId
		-- Modified by Revathi 20/Oct/2015
         , case when  ISNULL(C.ClientType,'I')='I' then ( ISNULL(c.LastName,'') + ', ' + ISNULL(c.FirstName,'') ) else ISNULL(C.OrganizationName,'') end AS PatientName 
		,md.MedicationName
		,cmsa.PharmacyId
		,cm.ClientMedicationId
		,cmsap.ClientMedicationScriptActivityId
		,cms.ClientMedicationScriptId
		,p.PharmacyName
		,'' AS LocationName
		,'' AS Reason
	FROM ClientMedicationScriptActivitiesPending cmsap
	INNER JOIN ClientMedicationScriptActivities cmsa ON cmsa.ClientMedicationScriptActivityId = cmsap.ClientMedicationScriptActivityId
	INNER JOIN ClientMedicationScripts cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
	INNER JOIN Clients c ON c.ClientId = cms.ClientId
	INNER JOIN ClientMedications cm ON cm.ClientMedicationId = @ClientMedicationId --cmsds.ClientMedicationId
	INNER JOIN MDMedicationNames md ON md.MedicationNameId = cm.MedicationNameId
	INNER JOIN Staff s ON s.StaffId = cms.OrderingPrescriberId
	LEFT JOIN Pharmacies p ON p.PharmacyId = cmsa.PharmacyId
	INNER JOIN dbo.SurescriptsCancelRequests scr ON (
			scr.SurescriptsOutgoingMessageId = cmsa.SureScriptsOutgoingMessageId
			AND scr.CancelRxResponse IS NOT NULL
			)
	WHERE CMS.clientid = @ClientId
		AND CMS.ClientMedicationScriptId = @ClientMedicationScriptId
		AND cm.ClientMedicationId = @ClientMedicationId
		AND ISNULL(cms.WaitingPrescriberApproval, 'N') <> 'Y'
		AND (
			ISNULL(cmsap.RecordDeleted, 'N') <> 'Y'
			OR scr.SurescriptsOutgoingMessageId IS NOT NULL
			)
		AND ISNULL(cmsa.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(cms.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(md.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(s.RecordDeleted, 'N') <> 'Y'

		UNION ALL 
      -- Added by pranay for showing discontined status.
        SELECT  cm.ModifiedDate ,
                cm.ModifiedBy AS createdby ,
                CASE WHEN cm.DiscontinuedMethod = 'F' THEN 'Fax-Discontined'
                     WHEN cm.DiscontinuedMethod = 'P' THEN 'Print-Discontined'
                     WHEN cm.DiscontinuedMethod = 'N' THEN 'Discontined'
                     ELSE ''
                END AS Method ,
                CASE WHEN ISNULL(cmfa.FaxStatus, '') = ''
                          AND cm.DiscontinuedMethod = 'P' THEN 'Printed'
                     WHEN ISNULL(cmfa.FaxStatus, '') = ''
                          AND cm.DiscontinuedMethod = 'N' THEN 'No Action'
                     WHEN ISNULL(cmfa.FaxStatus, '') != ''
                          AND cm.DiscontinuedMethod = 'F' THEN cmfa.FaxStatus
                END AS [Status] ,
                CASE WHEN ISNULL(cmfa.FaxStatus, '') = ''
                          AND cm.DiscontinuedMethod = 'P' THEN 'Printed'
                     WHEN ISNULL(cmfa.FaxStatus, '') = ''
                          AND cm.DiscontinuedMethod = 'N' THEN 'No Action'
                     WHEN ISNULL(cmfa.FaxStatus, '') != ''
                          AND cm.DiscontinuedMethod = 'F' THEN cmfa.FaxStatus
                END AS StatusDescription ,
                cm.ModifiedBy ,
                '' ,
                '' ,
                '' ,
                '' ,
                '' ,
                '' ,
                '' ,
                p.PharmacyName ,
                CASE WHEN ( cm.DiscontinuedMethod = 'P'
                            OR cm.DiscontinuedMethod = 'N'
                          ) THEN ''
                     ELSE p.[Address] + p.City
                END AS locationname ,
                '' Reason
        FROM    dbo.ClientMedications cm
                LEFT JOIN dbo.ClientMedicationFaxActivities cmfa ON cm.ClientMedicationId = cmfa.ClientMedicationId
                LEFT JOIN dbo.Pharmacies p ON p.PharmacyId = cm.PharmacyId
        WHERE   cm.ClientMedicationId = @ClientMedicationId
                AND cm.DiscontinuedMethod != 'E'
                AND cm.Discontinued = 'Y' AND ISNULL(cm.RecordDeleted,'N')='N'
	)
SELECT o.ClientMedicationScriptActivityId
	,o.ClientMedicationScriptId
	,o.OrderingPrescriberName
	,o.locationname
	,o.ClientId
	,o.PatientName
	,o.CreatedDate AS ScriptCreationDate
	,o.createdby
	,o.ClientMedicationId
	,o.MedicationName
	,o.PharmacyName
	,o.Method AS DeliveryMethod
	,o.Method AS OrderingMethod
	,o.[Status]
	,o.StatusDescription
	,o.reason
FROM outbound o
--June 22, 2015	Gautam
UNION

SELECT '' AS ClientMedicationScriptActivityId
	,CMSA.ClientMedicationScriptId
	,'' AS OrderingPrescriberName
	,'' AS locationname
	,'' AS ClientId
	,'' AS PatientName
	,CMSA.CreatedDate AS ScriptCreationDate
	,CMSA.CreatedBy
	,'' AS ClientMedicationId
	,'' AS MedicationName
	,PharmacyName
	,CASE 
		WHEN CMSA.Method IS NULL
			THEN ''
		WHEN CMSA.Method = 'F'
			THEN 'Fax'
		WHEN CMSA.Method = 'P'
			THEN 'Print'
		WHEN CMSA.Method = 'C'
			THEN 'Chart Copy'
		WHEN CMSA.Method = 'E'  
			THEN 'Elec.'   
		ELSE ''  
		END AS DeliveryMethod
	,CASE 
		WHEN CMS.OrderingMethod IS NULL
			THEN ''
		WHEN CMS.OrderingMethod = 'F'
			THEN 'Fax'
		WHEN CMS.OrderingMethod = 'P'
			THEN 'Print'
		ELSE ''
		END AS OrderingMethod
	,'' AS [Status]
	,cmsa.StatusDescription 
	,GlobalCodes.CodeName AS Reason                           
FROM ClientMedicationScripts CMS
INNER JOIN ClientMedicationScriptActivities CMSA ON (
		CMSA.ClientMedicationScriptId = CMS.ClientMedicationScriptId
		AND (ISNULL(CMSA.RecordDeleted, 'N') <> 'Y')
		)
INNER JOIN ClientMedicationScriptDrugs CMSD ON (
		CMSD.ClientMedicationScriptId = CMS.ClientMedicationScriptId
		AND (ISNULL(CMSD.RecordDeleted, 'N') <> 'Y')
		)
--Following Join Added By Loveena in Ref to Task#83 to display Reprint Reason in Script History      
LEFT JOIN GlobalCodes ON (
		GlobalCodes.GlobalCodeID = CMSA.Reason
		AND (ISNULL(GlobalCodes.RecordDeleted, 'N') <> 'Y')
		)
--Following Join Added by Loveena in Ref to Task#83 to display Location in Script History.      
INNER JOIN Locations ON (
		Locations.LocationId = CMS.LocationId
		AND (ISNULL(Locations.RecordDeleted, 'N') <> 'Y')
		)
LEFT JOIN Pharmacies P ON (
		CMSA.PharmacyId = P.PharmacyId
		AND (ISNULL(P.RecordDeleted, 'N') <> 'Y')
		AND (ISNULL(P.Active, 'N') = 'Y')
		)
WHERE CMS.clientid = @ClientId
	AND
	--Follwoing condition added by sonia        
	CMS.ClientMedicationScriptId = @ClientMedicationScriptId
	AND
	--Condition added by sonia        
	(ISNULL(CMS.RecordDeleted, 'N') <> 'Y')
	AND EXISTS (
		SELECT ClientMedicationInstructionId
		FROM ClientMedicationInstructions CMI
		WHERE CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
			AND ClientMedicationId = @ClientMedicationId
		)
	AND NOT EXISTS (
		SELECT ClientMedicationScriptActivityId
		FROM ClientMedicationScriptActivitiesPending cmsap
		WHERE cmsa.ClientMedicationScriptActivityId = cmsap.ClientMedicationScriptActivityId
			AND ISNULL(cmsap.RecordDeleted, 'N') <> 'Y'
		)
GROUP BY CMSA.ClientMedicationScriptId
	,PharmacyName
	,CMSA.CreatedDate
	,CMS.LocationId
	,CMSA.Method
	,CMS.OrderingMethod
	,CMSA.CreatedBy
	,CMSA.ClientMedicationScriptActivityId
	,GlobalCodes.CodeName
	,Locations.LocationName
	,CMSA.StatusDescription
ORDER BY ScriptCreationDate

IF (@@error != 0)
BEGIN
	RAISERROR 20002 'ssp_SCGetClientMedicationScriptHistory : An error  occured'

	RETURN (1)
END
GO



