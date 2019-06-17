/********************************************************************************************
Author      :  Alok Kumar
CreatedDate :  22/Nov/2016
Purpose     :  Update script for GlobalCodes for LOCUS Document
*********************************************************************************************/

--Update [GlobalCodes] Category 'LOCUSProgram'
IF EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level Two - Case Management+'
		)

BEGIN
	UPDATE GlobalCodes SET CodeName = 'Level Two - Case Management', Code = 'Level Two - Case Management' WHERE Category = 'LOCUSProgram' AND CodeName = 'Level Two - Case Management+'
END



--Update [GlobalCodes] Category 'LOCUSReasonVariance'
IF EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSReasonVariance'
			AND CodeName = '09Other – See Evaluation Notes'
		)

BEGIN
	UPDATE GlobalCodes SET CodeName = 'Other – See Evaluation Notes', Code = 'Other – See Evaluation Notes' WHERE Category = 'LOCUSReasonVariance' AND CodeName = '09Other – See Evaluation Notes'
END

GO