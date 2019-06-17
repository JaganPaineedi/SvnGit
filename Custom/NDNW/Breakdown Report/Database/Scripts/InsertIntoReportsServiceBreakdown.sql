



IF NOT EXISTS (SELECT * FROM reports WHERE Name LIKE 'Client Services Breakdown Report' AND ISNULL(RecordDeleted,'N') <> 'Y')
Insert Into Reports
(Name,IsFolder--,ParentFolderId,
,AssociatedWith,ReportServerId,ReportServerPath,RowIdentifier,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select 'Client Services Breakdown Report' As Name
,'N' As IsFolder
--,12 As ParentFolderId
,5831 As AssociatedWith
,2 As ReportServerId
,'/NDNW/ProdDocuments/Client Services Breakdown Report' As ReportServerPath
,NEWID() As RowIdentifier
,'SA' As CreatedBy
,GetDate() As CreatedDate
,'SA' As ModifiedBy
,GetDate() As ModifiedDate







