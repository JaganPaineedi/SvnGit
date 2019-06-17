/******************************************************************************
 *	Author: dknewtson
 *	Created: 10/4/2013
 *	Description: A tool for deploying standard reports to an environment's Reports table.
 *	Usage: Modify the relevant variables at the top of the script, and add or comment out any reports in the UNION SELECT statements.
 ******************************************************************************
 * Change History
 ******************************************************************************
 * Author		Date		Purpose
 * dknewtson	10/4/2013	Creation
 * wherman		11/15/2013	commented out reports that are not to be included just yet
 * tryan		11/14/2014  Merged dknewston and mlightner's changes - removed from Scripts\3.5x\Standard
 							It sits in the Standard Reports directory.
 ******************************************************************************/

DECLARE @ReportFolder varchar(500) = '/NDNW/TrainDocuments'
	,@StandardReportsReportsFolderName varchar(250) = 'TrainDocuments'
	,@StandardReportsReportsFolderDescription varchar(MAX)
	,@StandardReportsFolderReportId int
	,@CurrentUser type_CurrentUser = CURRENT_USER
	,@CurrentDate DATETIME = CURRENT_TIMESTAMP
	-- will only insert if Environment like '%' + StandardReports.Environment + '%'
    ,@Environment VARCHAR(10) = 'SC'

DECLARE @StandardReports TABLE (
	ReportName VARCHAR(250),
	ReportDescription VARCHAR(500),
	ReportPath VARCHAR(500),
	Environment CHAR(2)
	)

DECLARE @ReportServerId INT = (
						SELECT TOP 1 ReportServerId 
						FROM ReportServers rs 
						WHERE ISNULL(RecordDeleted,'N')<> 'Y'
						) 

DECLARE @AssociatedWithGlobalCodeId INT = (
									SELECT GlobalCodeId 
									FROM GlobalCodes 
									WHERE Category = 'ReportAssociatedWith' 
										AND CodeName = 'Client' 
										AND Active = 'Y' 
										AND ISNULL(RecordDeleted,'N') <> 'Y')

INSERT INTO @StandardReports (
		 ReportName,
	     ReportDescription,
	     ReportPath,
	     Environment
		)
--SELECT 'Active Clients With No Primary Clinician',
--		NULL,
--		'Active Clients With No Primary Clinician',
--		'SC'
--UNION 
--SELECT 'Active Clients With No Primary Program',
--		NULL,
--		'Active Clients With No Primary Program',
--		'SC'
--UNION 
--SELECT 'Active Clients Without Diagnosis',
--	    NULL,
--		'Active Clients Without Diagnosis',
--		'SC'
--UNION 
--SELECT 'Active Pharmacy List',
--		NULL,
--		'Active Pharmacy List',
--		'SC'
--UNION 
--SELECT 'Authorization Code to Procedure Code Map', 
--		NULL, 
--		'Authorization Code to Procedure Code Map',
--		'SC'		
--UNION 
--SELECT 'Auths Missing Coverage Plan',
--		NULL,
--		'Auths Missing Coverage Plan',
--		'SC'
--UNION 
--SELECT 'Client Assessment List With DLA Details',
--		NULL,
--		'Client Assessment List With DLA Details',
--		'SC'
--UNION 
--SELECT 'Client Demographic Breakdown',
--		NULL,
--		'Client Demographic BreakdownSC',
--		'SC'
----UNION 
----SELECT 'Billable Clinicians By Coverage Plan',
--		--NULL,
--		--'Billable Clinicians By Coverage Plan',
--		--'SC'
--UNION 
--SELECT 'Client Medications by Program',
--		NULL,
--		'Client Medications by Program',
--		'Rx'
--UNION 
--SELECT 'Client Statements',
--		NULL,
--		'Client Statements',
--		'SC'
----UNION 
----SELECT 'Client Contacts Address History',
--		--NULL,
--		--'ClientContactsAddressHistory',
--		--'SC'
--UNION 
--SELECT 'Client Served By Program',
--		NULL,
--		'Client Served By Program And Age SC',
--		'SC'
----UNION 
----SELECT 'Clients with Invalid DSM-IV TR Current Diagnosis',
--		--NULL,
--		--'Clients with Invalid DSM IV TR Current Diagnosis',
--		--'SC'
----UNION 
----SELECT 'Co-Occurring UNCOPE',
--		--NULL,
--		--'Co-Occurring UNCOPE',
--		--'SC'
----UNION 
----SELECT 'Collection Rate by Clinician',
--		--NULL,
--		--'Collection Rate by Clinician',
--		--'SC'
----UNION 
----SELECT 'DD Customers By Clinician',
--		--NULL,
--		--'DD Customers By Clinician',
--		--'SC'
----UNION 
----SELECT 'Customers Not Seen in XX Days',
--		--NULL,
--		--'Discharge Report',
--		--'SC'
--UNION 
--SELECT 'Discharge Report',
--		NULL,
--		'Discharge Report',
--		'SC'
--UNION 
--SELECT 'Discharged Clients With Active Coverage',
--		NULL,
--		'Discharged Clients With Active Coverage',
--		'SC'
--UNION 
--SELECT 'Document Timeliness',
--		NULL,
--		'Document Timeliness',
--		'SC'
--UNION 
--SELECT 'Document Timeliness With Detail',
--		NULL,
--		'Document Timeliness With Detail',
--		'SC'
--UNION 
--SELECT 'Documentation Due Dates by Caseload',
--		NULL,
--		'Documentation Due Dates by Caseload',
--		'SC'
----UNION 
----SELECT 'DSM Codes to be Removed and Added',
--		--NULL,
--		--'DSM Codes to be Removed and Added',
--		--'SC'
--UNION 
--SELECT 'DSM IV To ICD9 Map',
--		NULL,
--		'DSM IV To ICD9 Map',
--		'SC'
--UNION 
--SELECT 'ER File List',
--		NULL,
--		'RDLGetERFileList',
--		'SC'
--UNION 
--SELECT 'ER File Detail',
--		NULL,
--		'RDLGetERFileDetails',
--		'SC'		
----UNION 
----SELECT 'Fax Transmission Status Report',
--		--NULL,
--		--'Fax Transmission Status Report',
--		--'Rx'
--UNION 
--SELECT 'Hospitalization Length Of Stay',
--		NULL,
--		'Hospitalization Length Of Stay',
--		'SC'
----UNION 
----SELECT 'Initial Intake Summary',
--		--NULL,
--		--'Initial Intake Summary',
--		--'SC'
----UNION 
----SELECT 'Length Of Stay',
--		--NULL,
--		--'Length Of Stay',
--		--'SC'
--UNION 
--SELECT 'Mailing Labels',
--		NULL,
--		'Mailing Labels',
--		'SC'
----UNION 
----SELECT 'Medication Management - Fax Success Rate',
--		--NULL,
--		--'Medication Management - Fax Success Rate',
--		--'Rx'
--UNION 
--SELECT 'Most Recent Diagnosis Document By Caseload',
--		NULL,
--		'Most Recent Diagnosis Document By Caseload',
--		'SC'
----UNION 
----SELECT 'New OP Customer Count',
--		--NULL,
--		--'New OP Customer Count',
--		--'SC'
----UNION 
----SELECT 'Non-Completed by Program Type',
--		--NULL,
--		--'Non-Completed by Program Type',
--		--'SC'
--UNION 
--SELECT 'No Shows',
--		NULL,
--		'No Shows',
--		'SC'
----UNION 
----SELECT 'Outpatient Admissions',
--		--NULL,
--		--'Outpatient Admissions',
--		--'SC'
--UNION 
--SELECT 'Payment By Payer',
--		NULL,
--		'Payment By Payer',
--		'SC'
--UNION 
--SELECT 'Procedure Code Rates',
--		NULL,
--		'Procedure Code Rates',
--		'SC'
----UNION 
----SELECT 'Productivity Details Report',
--		--NULL,
--		--'Productivity Details Report',
--		--'SC'
----UNION 
SELECT 'Revenue Report',
		NULL,
		'RDLRevenueReport',
		'SC'
--UNION 
--SELECT 'Reminder Call List',
--		NULL,
--		'Reminder Call List',
--		'SC'
----UNION 
----SELECT 'Required Authorizations By Coverage Plan',
--		--NULL,
--		--'Required Authorizations By Coverage Plan',
--		--'SC'
--UNION 
--SELECT 'Scheduled Services By Caseload',
--		NULL,
--		'Scheduled Services By Caseload',
--		'SC'
--UNION
--SELECT 'Service Information Report',
--		NULL,
--		'RDLClientServiceReport',
--		'SC'
--UNION 
--SELECT 'Service Utilization',
--		NULL,
--		'Service Utilization',
--		'SC'
--UNION 
--SELECT 'Staff Caseload with Address and Phone Number',
--		NULL,
--		'Staff Caseload with Address and Phone No.',
--		'SC'
--UNION 
--SELECT 'Staff Client Access Tracking',
--		NULL,
--		'Staff Client Access Tracking',
--		'SC'
--UNION 
--SELECT 'Staff Roles and Permissions',
--		NULL,
--		'Staff Roles and Permissions',
--		'SC'
--UNION 
--SELECT 'Staff Procedures',
--		NULL,
--		'Staff Procedures',
--		'SC'
--UNION 
--SELECT 'Treatment Plan Addendums With No Original Plan in EHR',
--		NULL,
--		'Treatment Plan Addendums With No Original Plan in EHR',
--		'SC'
----UNION
----SELECT 'Unduplicated Clients Served By Date',
--		--NULL,
--		--'Unduplicated Clients Served By Date',
--		--'DW'
----UNION
----SELECT 'Unposted Client Payments To Apply',
--		--NULL,
--		--'Unposted Client Payments To Apply',
--		--'SC'
----UNION 
----SELECT 'Upcoming Birthdays',
--		--NULL,
--		--'Upcoming Birthdays',
--		--'SC'
----UNION 
----SELECT 'ER File Summary',
--		--NULL,
--		--'RDLERFileSummary',
--		--'SC'
----UNION 
----SELECT 'ER Unposted Lines',
--		--NULL,
--		--'RDLERUnpostedLines',
--		--'SC'
--UNION 
--SELECT 'Retroactive Reallocation Log',
--		NULL,
--		'RetroactiveReallocationLog',
--		'SC'

/******************************************************************************
 *	folder first
 ******************************************************************************/
 IF NOT EXISTS (SELECT ReportId 
 				FROM Reports r 
 				WHERE Name = @StandardReportsReportsFolderName 
 				AND ISNULL(RecordDeleted,'N')<> 'Y')
	INSERT INTO Reports
			(Name
		   , Description
		   , IsFolder
		   , ParentFolderId
		   , AssociatedWith
		   , ReportServerId
		   , ReportServerPath
		   --, RowIdentifier
		   --, CreatedBy
		   --, CreatedDate
		   --, ModifiedBy
		   --, ModifiedDate
		   --, RecordDeleted
		   --, DeletedDate
		   --, DeletedBy
			)
		VALUES
			(@StandardReportsReportsFolderName -- Name - varchar(250)
			,@StandardReportsReportsFolderDescription-- Description - varchar(max)
			,'Y'-- IsFolder - type_YOrN
			,NULL-- ParentFolderId - int
			,@AssociatedWithGlobalCodeId-- AssociatedWith - type_GlobalCode
			,@ReportServerId-- ReportServerId - int
			,NULL-- ReportServerPath - varchar(500)
			--,NEWID()-- RowIdentifier - type_GUID
			--,@CurrentUser-- CreatedBy - type_CurrentUser
			--,@CurrentDate-- CreatedDate - type_CurrentDatetime
			--,@CurrentUser-- ModifiedBy - type_CurrentUser
			--,@CurrentDate-- ModifiedDate - type_CurrentDatetime
			--,NULL -- RecordDeleted - type_YOrN
			--,NULL -- DeletedDate - datetime
			--,NULL -- DeletedBy - type_UserId
			)

SET @StandardReportsFolderReportId = (SELECT ReportId 
									  FROM Reports r 
									  WHERE Name = @StandardReportsReportsFolderName 
									  AND ISNULL(RecordDeleted,'N')<> 'Y')

UPDATE r
	SET	
		Description = sr.ReportDescription
	  , ReportServerPath = @ReportFolder + '/' + sr.ReportPath
	  , ReportServerId = @ReportServerId
	  , ParentFolderId = @StandardReportsFolderReportId
	  , ModifiedBy = @CurrentUser
	  , ModifiedDate = @CurrentDate
	FROM
		Reports r
		JOIN @StandardReports sr
			ON r.Name = sr.ReportName
		AND @Environment LIKE '%' + sr.Environment + '%'
	
INSERT INTO Reports
		(Name
	   , Description
	   , IsFolder
	   , ParentFolderId
	   , AssociatedWith
	   , ReportServerId
	   , ReportServerPath
	   --, RowIdentifier
	   --, CreatedBy
	   --, CreatedDate
	   --, ModifiedBy
	   --, ModifiedDate
	   --, RecordDeleted
	   --, DeletedDate
	   --, DeletedBy
		)
		SELECT
				sr.ReportName -- Name - varchar(250)
			  , sr.ReportDescription-- Description - varchar(max)
			  , 'N'-- IsFolder - type_YOrN
			  , @StandardReportsFolderReportId-- ParentFolderId - int
			  , @AssociatedWithGlobalCodeId-- AssociatedWith - type_GlobalCode
			  , @ReportServerId-- ReportServerId - int
			  , @ReportFolder + '/' + sr.ReportPath-- ReportServerPath - varchar(500)
			  --, NEWID()-- RowIdentifier - type_GUID
			  --, @CurrentUser-- CreatedBy - type_CurrentUser
			  --, @CurrentDate-- CreatedDate - type_CurrentDatetime
			  --, @CurrentUser-- ModifiedBy - type_CurrentUser
			  --, @CurrentDate-- ModifiedDate - type_CurrentDatetime
			  --, NULL-- RecordDeleted - type_YOrN
			  --, NULL-- DeletedDate - datetime
			  --, NULL-- DeletedBy - type_UserId
			FROM
				@StandardReports sr
				LEFT JOIN Reports r
					ON sr.ReportName = r.Name
			WHERE
				r.ReportId IS NULL
			AND @Environment LIKE '%' + sr.Environment + '%'