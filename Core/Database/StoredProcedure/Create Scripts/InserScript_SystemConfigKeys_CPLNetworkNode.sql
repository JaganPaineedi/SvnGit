-- SysetmConfigurationKeys 'CPLNetworkNode' .
-- Gulf Bend Enhancements #211
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'CPLNetworkNode'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		,AllowEdit
		,Modules
		,Screens
		)
	SELECT suser_sname()
		,GETDATE()
		,suser_sname()
		,GETDATE()
		,NULL
		,NULL
		,NULL
		,'CPLNetworkNode'
		,'CPLOIRO2'
		,'Network Node'
		,'Reads as --- "CPL Network Node". Customer going to set up Network Node for Client Order Electronic Requisition to display in Client Order PDF(RDL)'
		,'Y'
		,'ClientOrders'
		,NULL
END
