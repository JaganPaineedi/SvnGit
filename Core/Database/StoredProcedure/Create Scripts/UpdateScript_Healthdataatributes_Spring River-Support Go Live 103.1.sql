--Added By prem 26/12/2017 to updating the 	AbdominalGirth datatype numeric to Decimal
-- Task Spring River-Support Go Live: #103.1	
		
		IF EXISTS (
		SELECT *
		FROM healthdataattributes
		WHERE HealthdataAttributeid = 117
		)
   Begin
   Update healthdataattributes 
   Set datatype=8082,
       numbersafterdecimal=2 
   WHERE NAME = 'AbdominalGirth'
		AND HealthdataAttributeid = 117
	End	
