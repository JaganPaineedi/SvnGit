DECLARE @Environment VARCHAR(5) = CASE 
		WHEN (
				SELECT TOP 1 NAME
				FROM ReportServers
				) LIKE '%Test%'
			THEN 'Test'
		WHEN (
				SELECT TOP 1 NAME
				FROM ReportServers
				) LIKE '%Train%'
			THEN 'Train'
		ELSE 'Prod'
		END

DECLARE @ReportServerId INT = (
		SELECT TOP 1 ReportServerId
		FROM ReportServers
		)

IF NOT EXISTS (
		SELECT 1
		FROM Reports
		WHERE NAME = 'Active Clients With No Primary Clinician'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
INSERT INTO dbo.Reports
        ( Name ,
          Description ,
          IsFolder ,
          ReportServerId ,
          ReportServerPath 

        )
VALUES  ( 'Active Clients With No Primary Clinician' , -- Name - varchar(250)
          'Standard Report' , -- Description - varchar(max)
          'N' , -- IsFolder - type_YOrN
          @ReportServerId , -- ReportServerId - int
          '/ARM' + @Environment + 'SCDocuments/Active Clients With No Primary Clinician'  -- ReportServerPath - varchar(500)
        )
END

IF NOT EXISTS (
		SELECT 1
		FROM Reports
		WHERE NAME = 'Active Clients Without Diagnosis'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
INSERT INTO dbo.Reports
        ( Name ,
          Description ,
          IsFolder ,
          ReportServerId ,
          ReportServerPath 

        )
VALUES  ( 'Active Clients Without Diagnosis' , -- Name - varchar(250)
          'Standard Report' , -- Description - varchar(max)
          'N' , -- IsFolder - type_YOrN
          @ReportServerId , -- ReportServerId - int
          '/ARM' + @Environment + 'SCDocuments/Active Clients Without Diagnosis'  -- ReportServerPath - varchar(500)
        )
END

IF NOT EXISTS (
		SELECT 1
		FROM Reports
		WHERE NAME = 'Payment By Payer'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
INSERT INTO dbo.Reports
        ( Name ,
          Description ,
          IsFolder ,
          ReportServerId ,
          ReportServerPath 

        )
VALUES  ( 'Payment By Payer' , -- Name - varchar(250)
          'Standard Report' , -- Description - varchar(max)
          'N' , -- IsFolder - type_YOrN
          @ReportServerId , -- ReportServerId - int
          '/ARM' + @Environment + 'SCDocuments/Payment By Payer'  -- ReportServerPath - varchar(500)
        )
END

IF NOT EXISTS (
		SELECT 1
		FROM Reports
		WHERE NAME = 'Unposted Client Payments to Apply'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
INSERT INTO dbo.Reports
        ( Name ,
          Description ,
          IsFolder ,
          ReportServerId ,
          ReportServerPath 

        )
VALUES  ( 'Unposted Client Payments to Apply' , -- Name - varchar(250)
          'Standard Report' , -- Description - varchar(max)
          'N' , -- IsFolder - type_YOrN
          @ReportServerId , -- ReportServerId - int
          '/ARM' + @Environment + 'SCDocuments/Unposted Client Payments to Apply'  -- ReportServerPath - varchar(500)
        )
END
