
If not exists (select * from dbo.Reports as r where r.Name='Control Substance Incident Report' and r.ReportServerPath='/EPCS/RDLControlSubstanceIncidentReport')
begin

INSERT INTO [Reports]
                        ([Name]
			,[Description]
			,[IsFolder]
			,[ParentFolderId]
			,[AssociatedWith]
			,[ReportServerId]
			,[ReportServerPath]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy])
       
 VALUES('Control Substance Incident Report',
        'Control Substance Incident Report',
		'N',
		NULL,
		NULL,
		5,
		'/EPCS/RDLControlSubstanceIncidentReport',
		'Admin',
		GETDATE(),
		'Admin',
		 GETDATE(),
		 NULL,
		 NULL,
		 NULL)

END