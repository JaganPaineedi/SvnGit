-- Insert script for SystemConfigurationKeys ShowSearchResultsInGoBoxStartingWithActiveTab     (#718 in Engineering Improvement Initiatives)
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowSearchResultsInGoBoxStartingWithActiveTab'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		,AllowEdit
		,Modules
		,Screens
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'ShowSearchResultsInGoBoxStartingWithActiveTab'
		,'No'
		,'Yes/No'
		,'Read Key As - Show Search Results In Go Box Starting With Active Tab. Setting the value of the key to ''Yes'' will display ‘search results’ in ‘Go’ box in a particular manner. Here is how it works. Based on the search word, Go box will first show items matching ‘search’ criteria starting from current active tab followed by showing matches from remaining tabs. For instance, if the current tab is ‘My Office’, the search results will first show matches from ‘My Office’ tab followed by other tabs (like ‘Client’ tab, ‘Administration’ tab).'
		,'Y'
		,'GO search box'
		,NULL
		)
END

