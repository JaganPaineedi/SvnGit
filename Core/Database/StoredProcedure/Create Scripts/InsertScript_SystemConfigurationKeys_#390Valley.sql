----------------------------------------
--Author :Veena S Mani
--Date : 05/04/2016
--Purpose : To set the Care Plan review changes configurable.
-----------------------------------------

IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [key] = 'SetReviewInCarePlan'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,[Value]
		)
	VALUES (
		'SetReviewInCarePlan'
		,'N'
		)	
		
END
ELSE
UPDATE SystemConfigurationKeys SET Value='N' WHERE [Key] = 'SetReviewInCarePlan'