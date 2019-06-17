------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------BMI Intervention------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @EducationHealthDataAttributeId INT,
@ReferralHealthDataAttributeId INT,
@PharmacologicalHealthDataAttributeId INT,
@DietaryHealthDataAttributeId INT,
@ExerciseHealthDataAttributeId INT,
@NutritionHealthDataAttributeId INT,
@BMICommentsHealthDataAttributeId INT,

@BMIInterventionHealthDataSubTemplateId INT


------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataAttributes--------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Education' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8085, 'Education','Education')  
	
	Set @EducationHealthDataAttributeId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN 
		SELECT @EducationHealthDataAttributeId = HealthDataAttributeId  FROM HealthDataAttributes  WHERE Name= 'Education' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END


IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Referral' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8085, 'Referral','Referral')  

	Set @ReferralHealthDataAttributeId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN 
		SELECT @ReferralHealthDataAttributeId = HealthDataAttributeId  FROM HealthDataAttributes  WHERE Name= 'Referral' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END


IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pharmacological Intervention' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8085, 'Pharmacological Intervention','Pharmacological Intervention') 

	Set @PharmacologicalHealthDataAttributeId = SCOPE_IDENTITY() 
	END
	ELSE
	BEGIN
		SELECT @PharmacologicalHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Pharmacological Intervention' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Dietary Supplements' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8085, 'Dietary Supplements','Dietary Supplements')  

	Set @DietaryHealthDataAttributeId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @DietaryHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Dietary Supplements' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Exercise/Physical Activity Counseling' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8085, 'Exercise/Physical Activity Counseling','Exercise/Physical Activity Counseling')  

	Set @ExerciseHealthDataAttributeId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @ExerciseHealthDataAttributeId = HealthDataAttributeId  FROM HealthDataAttributes  WHERE Name= 'Exercise/Physical Activity Counseling' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Nutrition Counseling' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8085, 'Nutrition Counseling','Nutrition Counseling')  

	Set @NutritionHealthDataAttributeId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @NutritionHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Nutrition Counseling' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BMI Comments' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8084, 'BMI Comments','BMI Comments')  

	Set @BMICommentsHealthDataAttributeId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @BMICommentsHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'BMI Comments' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataSubTemplates------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'BMI Intervention' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (Name, Active)
		VALUES ('BMI Intervention', 'Y')

	Set @BMIInterventionHealthDataSubTemplateId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @BMIInterventionHealthDataSubTemplateId = HealthDataSubTemplateId  FROM HealthDataSubTemplates  WHERE Name = 'BMI Intervention' AND ISNULL(RecordDeleted, 'N') = 'N'
	END

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataSubTemplateAttributes---------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @BMIInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @EducationHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@BMIInterventionHealthDataSubTemplateId,@EducationHealthDataAttributeId,'Y', 1, 'N')
	 END


IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @BMIInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @ReferralHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@BMIInterventionHealthDataSubTemplateId,@ReferralHealthDataAttributeId,'Y', 2, 'N')
	 END


IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @BMIInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @PharmacologicalHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@BMIInterventionHealthDataSubTemplateId,@PharmacologicalHealthDataAttributeId,'Y', 3, 'N')
	 END


IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @BMIInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @DietaryHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@BMIInterventionHealthDataSubTemplateId,@DietaryHealthDataAttributeId,'Y', 4, 'N')
	 END


IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @BMIInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @ExerciseHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@BMIInterventionHealthDataSubTemplateId,@ExerciseHealthDataAttributeId,'Y', 5, 'N')
	 END


IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @BMIInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @NutritionHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@BMIInterventionHealthDataSubTemplateId,@NutritionHealthDataAttributeId,'Y', 6, 'N')
	 END


IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @BMIInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @BMICommentsHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@BMIInterventionHealthDataSubTemplateId,@BMICommentsHealthDataAttributeId,'Y', 7, 'N')
	 END


------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------						----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------Tobacco Use Intervention----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @CessationHealthDataAttributeId INT,
@PharmacotherapyHealthDataAttributeId INT,
@TobaccoUseCommentsHealthDataAttributeId INT,

@TobaccoUseInterventionHealthDataSubTemplateId INT

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataAttributes--------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Tobacco Use Cessation Couseling' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8085, 'Tobacco Use Cessation Couseling','Tobacco Use Cessation Couseling') 

	Set @CessationHealthDataAttributeId = SCOPE_IDENTITY() 
	END
	ELSE
	BEGIN
		SELECT @CessationHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Tobacco Use Cessation Couseling' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Tobacco Use Pharmacotherapy' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8085, 'Tobacco Use Pharmacotherapy','Tobacco Use Pharmacotherapy') 

	Set @PharmacotherapyHealthDataAttributeId = SCOPE_IDENTITY() 
	END
	ELSE
	BEGIN
		SELECT @PharmacotherapyHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Tobacco Use Pharmacotherapy' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Tobacco Use Comments' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8084, 'Tobacco Use Comments','Tobacco Use Comments')  

	Set @TobaccoUseCommentsHealthDataAttributeId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @TobaccoUseCommentsHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Tobacco Use Comments' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataSubTemplates------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Tobacco Use Intervention' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (Name, Active)
		VALUES ('Tobacco Use Intervention', 'Y')

	Set @TobaccoUseInterventionHealthDataSubTemplateId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @TobaccoUseInterventionHealthDataSubTemplateId = HealthDataSubTemplateId FROM HealthDataSubTemplates  WHERE Name = 'Tobacco Use Intervention' AND ISNULL(RecordDeleted, 'N') = 'N'
	END

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataSubTemplateAttributes---------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @TobaccoUseInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @CessationHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@TobaccoUseInterventionHealthDataSubTemplateId,@CessationHealthDataAttributeId,'Y', 1, 'N')
	 END

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @TobaccoUseInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @PharmacotherapyHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@TobaccoUseInterventionHealthDataSubTemplateId,@PharmacotherapyHealthDataAttributeId,'Y', 2, 'N')
	 END

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @TobaccoUseInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @TobaccoUseCommentsHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@TobaccoUseInterventionHealthDataSubTemplateId,@TobaccoUseCommentsHealthDataAttributeId,'Y', 3, 'N')
	 END
	 

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------						----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------Fall Risk-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @PastYearHealthDataAttributeId INT,
@FrequencyHealthDataAttributeId INT,
@ContextHealthDataAttributeId INT,
@CharacteristicsHealthDataAttributeId INT,
@BalanceHealthDataAttributeId INT,

@FallRiskInterventionHealthDataSubTemplateId INT,

@GlobalCodeCategoryId INT

Select @GlobalCodeCategoryId= GlobalCodeCategoryId from GlobalCodeCategories where Category= 'RADIOYN'

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataAttributes--------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Have you fallen in past year' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description],DropDownCategory)
		VALUES (8226, 8081, 'Have you fallen in past year','Have you fallen in past year',@GlobalCodeCategoryId) 

	Set @PastYearHealthDataAttributeId = SCOPE_IDENTITY() 
	END
	ELSE
	BEGIN
		SELECT @PastYearHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Have you fallen in past year' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Frequency of Falls' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8083, 'Frequency of Falls','Frequency of Falls')  

	Set @FrequencyHealthDataAttributeId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @FrequencyHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Frequency of Falls' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Context of Fall' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8084, 'Context of Fall','Context of Fall')  

	Set @ContextHealthDataAttributeId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @ContextHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Context of Fall' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Characteristics of Fall' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description])
		VALUES (8226, 8084, 'Characteristics of Fall','Characteristics of Fall') 

	Set @CharacteristicsHealthDataAttributeId = SCOPE_IDENTITY() 
	END
	ELSE
	BEGIN
		SELECT @CharacteristicsHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Characteristics of Fall' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Balance and Gait observed' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (Category, DataType, Name, [Description],DropDownCategory)
		VALUES (8226, 8081, 'Balance and Gait observed','Balance and Gait observed',@GlobalCodeCategoryId)  

	Set @BalanceHealthDataAttributeId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @BalanceHealthDataAttributeId = HealthDataAttributeId FROM HealthDataAttributes  WHERE Name= 'Balance and Gait observed' AND Category = 8226 AND ISNULL(RecordDeleted, 'N') = 'N'
	END

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataSubTemplates------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Fall Risk' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (Name, Active)
		VALUES ('Fall Risk', 'Y')

	Set @FallRiskInterventionHealthDataSubTemplateId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT @FallRiskInterventionHealthDataSubTemplateId = HealthDataSubTemplateId FROM HealthDataSubTemplates  WHERE Name = 'Fall Risk' AND ISNULL(RecordDeleted, 'N') = 'N'
	END

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataSubTemplateAttributes---------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @FallRiskInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @PastYearHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@FallRiskInterventionHealthDataSubTemplateId,@PastYearHealthDataAttributeId,'Y', 1, 'N')
	 END

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @FallRiskInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @FrequencyHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@FallRiskInterventionHealthDataSubTemplateId,@FrequencyHealthDataAttributeId,'Y', 2, 'N')
	 END

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @FallRiskInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @ContextHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@FallRiskInterventionHealthDataSubTemplateId,@ContextHealthDataAttributeId,'Y', 3, 'N')
	 END

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @FallRiskInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @CharacteristicsHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@FallRiskInterventionHealthDataSubTemplateId,@CharacteristicsHealthDataAttributeId,'Y', 4, 'N')
	 END

IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId = @FallRiskInterventionHealthDataSubTemplateId AND HealthDataAttributeId = @BalanceHealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@FallRiskInterventionHealthDataSubTemplateId,@BalanceHealthDataAttributeId,'Y', 5, 'N')
	 END
	 	 
------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------						----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataTemplateAttributes------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @HealthDataTemplateId INT = 110

IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@BMIInterventionHealthDataSubTemplateId AND HealthDataTemplateId = @HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@BMIInterventionHealthDataSubTemplateId,@HealthDataTemplateId,0, 2, 'N')
	 END

IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@TobaccoUseInterventionHealthDataSubTemplateId AND HealthDataTemplateId = @HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@TobaccoUseInterventionHealthDataSubTemplateId,@HealthDataTemplateId,0, 9, 'N')
	 END

IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@FallRiskInterventionHealthDataSubTemplateId AND HealthDataTemplateId = @HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@FallRiskInterventionHealthDataSubTemplateId,@HealthDataTemplateId,0, 12, 'N')
	 END
	 
------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------						----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------HealthDataTemplateAttributes------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

UPDATE HDTA SET HDTA.EntryDisplayOrder = 3 
FROM HealthDataTemplateAttributes HDTA 
JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId 
AND HDST.Name = 'Blood Pressure' AND ISNULL(HDST.RecordDeleted, 'N') = 'N'
WHERE HealthDataTemplateId = @HealthDataTemplateId

UPDATE HDTA SET HDTA.EntryDisplayOrder = 4 
FROM HealthDataTemplateAttributes HDTA 
JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId 
AND HDST.Name = 'Pulse' AND ISNULL(HDST.RecordDeleted, 'N') = 'N'
WHERE HealthDataTemplateId = @HealthDataTemplateId

UPDATE HDTA SET HDTA.EntryDisplayOrder = 5 
FROM HealthDataTemplateAttributes HDTA 
JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId 
AND HDST.Name = 'Respiratory' AND ISNULL(HDST.RecordDeleted, 'N') = 'N'
WHERE HealthDataTemplateId = @HealthDataTemplateId

UPDATE HDTA SET HDTA.EntryDisplayOrder = 6 
FROM HealthDataTemplateAttributes HDTA 
JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId 
AND HDST.Name = 'Abdominal Girth' AND ISNULL(HDST.RecordDeleted, 'N') = 'N'
WHERE HealthDataTemplateId = @HealthDataTemplateId

UPDATE HDTA SET HDTA.EntryDisplayOrder = 7 
FROM HealthDataTemplateAttributes HDTA 
JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId 
AND HDST.Name = 'Temperature' AND ISNULL(HDST.RecordDeleted, 'N') = 'N'
WHERE HealthDataTemplateId = @HealthDataTemplateId

UPDATE HDTA SET HDTA.EntryDisplayOrder = 8 
FROM HealthDataTemplateAttributes HDTA 
JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId 
AND HDST.Name = 'Smoking Status' AND ISNULL(HDST.RecordDeleted, 'N') = 'N'
WHERE HealthDataTemplateId = @HealthDataTemplateId

UPDATE HDTA SET HDTA.EntryDisplayOrder = 10 
FROM HealthDataTemplateAttributes HDTA 
JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId 
AND HDST.Name = 'Pain' AND ISNULL(HDST.RecordDeleted, 'N') = 'N'
WHERE HealthDataTemplateId = @HealthDataTemplateId

UPDATE HDTA SET HDTA.EntryDisplayOrder = 11 
FROM HealthDataTemplateAttributes HDTA 
JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId 
AND HDST.Name = 'Medication list reconciled' AND ISNULL(HDST.RecordDeleted, 'N') = 'N'
WHERE HealthDataTemplateId = @HealthDataTemplateId