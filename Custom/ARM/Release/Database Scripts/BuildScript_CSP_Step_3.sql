IF((EXISTS(select Billable FROM DiagnosisDSMDescriptions))) 
	BEGIN	
		UPDATE DiagnosisDSMDescriptions SET Billable='Y'
	END
	
		