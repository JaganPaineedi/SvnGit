/*
Created Date  Created By			Purpose
08-Aug-2014	  Gautam/Revathi		What:Insert Script for HealthDataSubTemplates,HealthDataAttributes and HealthDataSubTemplateAttributes
												HealthDataTemplates,OrderFrequencies,OrderTemplateFrequencies,Orders
									Why:task #36 A Renewed Mind – Customizations,Lab Interface
*/
	
	Declare @UserCode varchar(200)
	Declare @FrequencyId Int
	Declare @OrderTemplateFrequencyId Int

	Select top 1 @UserCode=UserCode from Staff where  usercode='admin'
	If @UserCode is null
		Begin
			Select top 1 @UserCode=UserCode from Staff where Isnull(RecordDeleted,'N')='N'
		End
DECLARE @HealthDataAttributeId INT,@HealthDataSubTemplateId INT

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Amphetamines', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'AMP' AND LOINCCode= '19261-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'AMP','Amphetamines', NULL, NULL, NULL, NULL, NULL, NULL,'19261-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='AMP' AND LOINCCode= '19261-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Amphetamine' AND LOINCCode= '16234-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Amphetamine','Amphetamine', NULL, NULL, NULL, NULL, NULL, NULL,'16234-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Amphetamine' AND LOINCCode= '16234-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MDA' AND LOINCCode= '20545-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MDA','MDA', NULL, NULL, NULL, NULL, NULL, NULL,'20545-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MDA' AND LOINCCode= '20545-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MDEA' AND LOINCCode= '45143-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MDEA','MDEA', NULL, NULL, NULL, NULL, NULL, NULL,'45143-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MDEA' AND LOINCCode= '45143-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MDMA' AND LOINCCode= '18358-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MDMA','MDMA', NULL, NULL, NULL, NULL, NULL, NULL,'18358-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MDMA' AND LOINCCode= '18358-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methamphetamine' AND LOINCCode= '16235-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methamphetamine','Methamphetamine', NULL, NULL, NULL, NULL, NULL, NULL,'16235-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methamphetamine' AND LOINCCode= '16235-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Phentermine' AND LOINCCode= '20557-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Phentermine','Phentermine', NULL, NULL, NULL, NULL, NULL, NULL,'20557-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Phentermine' AND LOINCCode= '20557-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END
	-------------------
	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Amphetamines_00184LDTDi' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Amphetamines_00184LDTDi', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'AMP' AND LOINCCode= '19261-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'AMP','Amphetamines', NULL, NULL, NULL, NULL, NULL, NULL,'19261-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Amphetamines_00184LDTDi' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='AMP' AND LOINCCode= '19261-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END
	--------------------
	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Barbiturates' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Barbiturates', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Amobarbital' AND LOINCCode= '16239-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Amobarbital','Amobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16239-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Barbiturates' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Amobarbital' AND LOINCCode= '16239-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BAR' AND LOINCCode= '19270-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BAR','Barbiturates', NULL, NULL, NULL, NULL, NULL, NULL,'19270-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Barbiturates' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BAR' AND LOINCCode= '19270-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Butalbital' AND LOINCCode= '16237-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Butalbital','Butalbital', NULL, NULL, NULL, NULL, NULL, NULL,'16237-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Barbiturates' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Butalbital' AND LOINCCode= '16237-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pentobarbital' AND LOINCCode= '16240-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pentobarbital','Pentobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16240-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Barbiturates' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pentobarbital' AND LOINCCode= '16240-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Phenobarbital' AND LOINCCode= '16241-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Phenobarbital','Phenobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16241-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Barbiturates' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Phenobarbital' AND LOINCCode= '16241-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Secobarbital' AND LOINCCode= '16238-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Secobarbital','Secobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16238-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Barbiturates' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Secobarbital' AND LOINCCode= '16238-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Buprenorphine' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Buprenorphine', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BPNP' AND LOINCCode= '16208-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BPNP','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'16208-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Buprenorphine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BPNP' AND LOINCCode= '16208-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Buprenorphine' AND LOINCCode= '49752-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Buprenorphine','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49752-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Buprenorphine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Buprenorphine' AND LOINCCode= '49752-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norbuprenorphin' AND LOINCCode= '49751-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norbuprenorphin','Norbuprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49751-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Buprenorphine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norbuprenorphin' AND LOINCCode= '49751-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Cannabinoids', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Carboxy-THC' AND LOINCCode= '20521-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Carboxy-THC','Carboxy-THC', NULL, NULL, NULL, NULL, NULL, NULL,'20521-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Carboxy-THC' AND LOINCCode= '20521-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'THC' AND LOINCCode= '19415-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'THC','THC', NULL, NULL, NULL, NULL, NULL, NULL,'19415-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='THC' AND LOINCCode= '19415-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Cocaine' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Cocaine', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BZE' AND LOINCCode= '16226-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BZE','Benzoylecgonine (Cocaine)', NULL, NULL, NULL, NULL, NULL, NULL,'16226-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cocaine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BZE' AND LOINCCode= '16226-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'COC' AND LOINCCode= '19359-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'COC','Benzoylecgonine(Cocaine)', NULL, NULL, NULL, NULL, NULL, NULL,'19359-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cocaine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='COC' AND LOINCCode= '19359-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Compliance, Marinol DLY' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Compliance, Marinol DLY', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MARINOL' AND LOINCCode= '14313-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MARINOL','Marinol', NULL, NULL, NULL, NULL, NULL, NULL,'14313-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, Marinol DLY' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MARINOL' AND LOINCCode= '14313-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Compliance, NP (Urine)', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '19-NORANDRODION' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '19-NORANDRODION','19-Norandrostenedione', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='19-NORANDRODION' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '1-ANDRODIOL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '1-ANDRODIOL','1-Androstenediol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='1-ANDRODIOL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '1-ANDRODIONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '1-ANDRODIONE','1-Androstenedione', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='1-ANDRODIONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '1-TESTOSTERONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '1-TESTOSTERONE','1-Testosterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='1-TESTOSTERONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-TESTOSTERO' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-TESTOSTERO','4-Hydroxy Testosterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-TESTOSTERO' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ALPRAZOLAM' AND LOINCCode= '59615-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ALPRAZOLAM','Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'59615-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ALPRAZOLAM' AND LOINCCode= '59615-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'AMITRIPTYLINE' AND LOINCCode= '20515-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'AMITRIPTYLINE','Amitriptyline', NULL, NULL, NULL, NULL, NULL, NULL,'20515-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='AMITRIPTYLINE' AND LOINCCode= '20515-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'AMOBARBITAL' AND LOINCCode= '16239-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'AMOBARBITAL','Amobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16239-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='AMOBARBITAL' AND LOINCCode= '16239-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'AMPHETAMINE_D+L' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'AMPHETAMINE_D+L','Amphetamine', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='AMPHETAMINE_D+L' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'AMPHETAMINES' AND LOINCCode= '20410-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'AMPHETAMINES','Amphetamine', NULL, NULL, NULL, NULL, NULL, NULL,'20410-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='AMPHETAMINES' AND LOINCCode= '20410-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ANDRODIONE/6OXO' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ANDRODIONE/6OXO','Androstenedione/6OXO', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ANDRODIONE/6OXO' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ANDROSTERONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ANDROSTERONE','Androsterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ANDROSTERONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BENADRYL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BENADRYL','Diphenhydramine', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BENADRYL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BENZODIAZEPINES' AND LOINCCode= '20412-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BENZODIAZEPINES','Benzodiazepine Metabolites', NULL, NULL, NULL, NULL, NULL, NULL,'20412-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BENZODIAZEPINES' AND LOINCCode= '20412-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BOLANDIOL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BOLANDIOL','Bolandiol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BOLANDIOL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BOLASTERONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BOLASTERONE','Bolasterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BOLASTERONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BOLDENONE/QUINB' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BOLDENONE/QUINB','Boldenone/Quinbolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BOLDENONE/QUINB' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BOLDIONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BOLDIONE','Boldione', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BOLDIONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BUPRENORPHINE' AND LOINCCode= '49752-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BUPRENORPHINE','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49752-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BUPRENORPHINE' AND LOINCCode= '49752-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BUTALBITAL' AND LOINCCode= '16237-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BUTALBITAL','Butalbital', NULL, NULL, NULL, NULL, NULL, NULL,'16237-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BUTALBITAL' AND LOINCCode= '16237-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CALUSTERONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CALUSTERONE','Calusterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CALUSTERONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CARISO/MEPRO' AND LOINCCode= 'X00026'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CARISO/MEPRO','Carisoprodol/Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'X00026', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CARISO/MEPRO' AND LOINCCode= 'X00026' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CITAL/ESCITAL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CITAL/ESCITAL','Citalopram/Escitalopram', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CITAL/ESCITAL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CLENBUTEROL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CLENBUTEROL','Clenbuterol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CLENBUTEROL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CLOMIPRAMINE' AND LOINCCode= '3492-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CLOMIPRAMINE','Clomipramine', NULL, NULL, NULL, NULL, NULL, NULL,'3492-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CLOMIPRAMINE' AND LOINCCode= '3492-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CLONAZEPAM' AND LOINCCode= '16229-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CLONAZEPAM','Clonazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16229-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CLONAZEPAM' AND LOINCCode= '16229-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CLOSTEBOL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CLOSTEBOL','Clostebol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CLOSTEBOL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'COCAINE' AND LOINCCode= '20519-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'COCAINE','Cocaine', NULL, NULL, NULL, NULL, NULL, NULL,'20519-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='COCAINE' AND LOINCCode= '20519-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CODEINE' AND LOINCCode= '16250-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CODEINE','Codeine', NULL, NULL, NULL, NULL, NULL, NULL,'16250-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CODEINE' AND LOINCCode= '16250-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'COTININE' AND LOINCCode= '35642-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'COTININE','Cotinine', NULL, NULL, NULL, NULL, NULL, NULL,'35642-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='COTININE' AND LOINCCode= '35642-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CSYNTHETIC' AND LOINCCode= '72478-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CSYNTHETIC','Synthetic Cannabinoids Profile', NULL, NULL, NULL, NULL, NULL, NULL,'72478-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CSYNTHETIC' AND LOINCCode= '72478-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CYCLOBENZAPRINE' AND LOINCCode= '61410-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CYCLOBENZAPRINE','Cyclobenzaprine', NULL, NULL, NULL, NULL, NULL, NULL,'61410-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CYCLOBENZAPRINE' AND LOINCCode= '61410-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DANAZOL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DANAZOL','Danazol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DANAZOL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DESIPRAMINE' AND LOINCCode= '61413-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DESIPRAMINE','Desipramine', NULL, NULL, NULL, NULL, NULL, NULL,'61413-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DESIPRAMINE' AND LOINCCode= '61413-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DESVENLAFAXINE' AND LOINCCode= '72772-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DESVENLAFAXINE','Desvenlafaxine', NULL, NULL, NULL, NULL, NULL, NULL,'72772-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DESVENLAFAXINE' AND LOINCCode= '72772-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DEXTROMETHORPHA' AND LOINCCode= '21240-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DEXTROMETHORPHA','Dextromethorphan', NULL, NULL, NULL, NULL, NULL, NULL,'21240-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DEXTROMETHORPHA' AND LOINCCode= '21240-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DEXTROM-LEVORPH' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DEXTROM-LEVORPH','Dextromethorphan/Levorphanol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DEXTROM-LEVORPH' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DHCMT-PC' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DHCMT-PC','Dehydrochlormethyltestosterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DHCMT-PC' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DHEA-PC' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DHEA-PC','DHEA', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DHEA-PC' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DIHYDROCODEINE' AND LOINCCode= '19448-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DIHYDROCODEINE','Dihydrocodeine', NULL, NULL, NULL, NULL, NULL, NULL,'19448-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DIHYDROCODEINE' AND LOINCCode= '19448-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'D-METAMPHETPCT' AND LOINCCode= '13498-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'D-METAMPHETPCT','d-Methamphetamine', NULL, NULL, NULL, NULL, NULL, NULL,'13498-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='D-METAMPHETPCT' AND LOINCCode= '13498-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DOXEPIN' AND LOINCCode= '61416-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DOXEPIN','Doxepin', NULL, NULL, NULL, NULL, NULL, NULL,'61416-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DOXEPIN' AND LOINCCode= '61416-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DROSTANOLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DROSTANOLONE','Drostanolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DROSTANOLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DULOXETINE' AND LOINCCode= '72814-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DULOXETINE','Duloxetine', NULL, NULL, NULL, NULL, NULL, NULL,'72814-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DULOXETINE' AND LOINCCode= '72814-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ECSTACY' AND LOINCCode= '18358-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ECSTACY','Ecstasy (MDMA)', NULL, NULL, NULL, NULL, NULL, NULL,'18358-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ECSTACY' AND LOINCCode= '18358-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ETG+ETS' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ETG+ETS','EtG/EtS (alcohol metabolites)', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ETG+ETS' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ETHANOL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ETHANOL','Ethanol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ETHANOL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ETHYL GLUCURONI' AND LOINCCode= '58378-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ETHYL GLUCURONI','Ethyl Glucuronide', NULL, NULL, NULL, NULL, NULL, NULL,'58378-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ETHYL GLUCURONI' AND LOINCCode= '58378-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ETHYL SULFATE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ETHYL SULFATE','Ethyl Sulfate', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ETHYL SULFATE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ETHYLEST/NORETH' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ETHYLEST/NORETH','Ethylestrenol/Norethandrolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ETHYLEST/NORETH' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ETIOCHOLANOLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ETIOCHOLANOLONE','Etiocholanolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ETIOCHOLANOLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'FENTANYL' AND LOINCCode= '58381-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'FENTANYL','Fentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58381-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='FENTANYL' AND LOINCCode= '58381-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'FLUOXETINE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'FLUOXETINE','Fluoxetine', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='FLUOXETINE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'FLUOXYMESTERONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'FLUOXYMESTERONE','Fluoxymesterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='FLUOXYMESTERONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'FLURAZEPAM' AND LOINCCode= '16231-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'FLURAZEPAM','Flurazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16231-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='FLURAZEPAM' AND LOINCCode= '16231-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'FURAZABOL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'FURAZABOL','Furazabol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='FURAZABOL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'GABAPENTIN' AND LOINCCode= '72810-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'GABAPENTIN','Gabapentin (Neurontin)', NULL, NULL, NULL, NULL, NULL, NULL,'72810-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='GABAPENTIN' AND LOINCCode= '72810-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'HEROIN' AND LOINCCode= '16755-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'HEROIN','Heroin', NULL, NULL, NULL, NULL, NULL, NULL,'16755-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='HEROIN' AND LOINCCode= '16755-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'HYDROCODONE' AND LOINCCode= '16252-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'HYDROCODONE','Hydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'16252-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='HYDROCODONE' AND LOINCCode= '16252-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'HYDROMORPHONE' AND LOINCCode= '16998-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'HYDROMORPHONE','Hydromorphone', NULL, NULL, NULL, NULL, NULL, NULL,'16998-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='HYDROMORPHONE' AND LOINCCode= '16998-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'IMIPRAMINE' AND LOINCCode= '61419-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'IMIPRAMINE','Imipramine', NULL, NULL, NULL, NULL, NULL, NULL,'61419-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='IMIPRAMINE' AND LOINCCode= '61419-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'KETAMINE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'KETAMINE','Ketamine', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='KETAMINE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'LORAZEPAM' AND LOINCCode= '17088-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'LORAZEPAM','Lorazepam', NULL, NULL, NULL, NULL, NULL, NULL,'17088-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='LORAZEPAM' AND LOINCCode= '17088-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'LSD-PC-Call' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'LSD-PC-Call','Lysergic Acid Diethylamide-LSD', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='LSD-PC-Call' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MARIJUANA' AND LOINCCode= '20413-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MARIJUANA','Marijuana', NULL, NULL, NULL, NULL, NULL, NULL,'20413-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MARIJUANA' AND LOINCCode= '20413-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MDA-NP' AND LOINCCode= '20545-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MDA-NP','MDA', NULL, NULL, NULL, NULL, NULL, NULL,'20545-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MDA-NP' AND LOINCCode= '20545-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MDEA-NP' AND LOINCCode= '45143-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MDEA-NP','MDEA', NULL, NULL, NULL, NULL, NULL, NULL,'45143-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MDEA-NP' AND LOINCCode= '45143-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MEPERIDINE' AND LOINCCode= '16253-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MEPERIDINE','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16253-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MEPERIDINE' AND LOINCCode= '16253-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MESTANOLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MESTANOLONE','Mestanolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MESTANOLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MESTEROLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MESTEROLONE','Mesterolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MESTEROLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METAXALONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METAXALONE','Metaxalone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METAXALONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHADONE' AND LOINCCode= '16246-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHADONE','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16246-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHADONE' AND LOINCCode= '16246-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHAMPHET_D+L' AND LOINCCode= '16235-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHAMPHET_D+L','Methamphetamine', NULL, NULL, NULL, NULL, NULL, NULL,'16235-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHAMPHET_D+L' AND LOINCCode= '16235-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHAMPHETAMINE' AND LOINCCode= '16235-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHAMPHETAMINE','Methamphetamine', NULL, NULL, NULL, NULL, NULL, NULL,'16235-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHAMPHETAMINE' AND LOINCCode= '16235-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHANDIENONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHANDIENONE','Methandienone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHANDIENONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHANDRIOL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHANDRIOL','Methandriol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHANDRIOL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHENOLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHENOLONE','Methenolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHENOLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHYL-1-TESTOS' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHYL-1-TESTOS','Methyl-1-Testosterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHYL-1-TESTOS' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHYLDIENOLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHYLDIENOLONE','Methyldienolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHYLDIENOLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHYLNORTESTOS' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHYLNORTESTOS','Methylnortestosterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHYLNORTESTOS' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHYLPHENIDATE' AND LOINCCode= '20548-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHYLPHENIDATE','Methylphenidate', NULL, NULL, NULL, NULL, NULL, NULL,'20548-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHYLPHENIDATE' AND LOINCCode= '20548-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'METHYLTESTOSTER' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'METHYLTESTOSTER','Methyltestosterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='METHYLTESTOSTER' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MIBOLERONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MIBOLERONE','Mibolerone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MIBOLERONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MILNACIPRAN' AND LOINCCode= '59312-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MILNACIPRAN','Milnacipran', NULL, NULL, NULL, NULL, NULL, NULL,'59312-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MILNACIPRAN' AND LOINCCode= '59312-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MIRTAZEPINE' AND LOINCCode= '49690-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MIRTAZEPINE','Mirtazapine', NULL, NULL, NULL, NULL, NULL, NULL,'49690-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MIRTAZEPINE' AND LOINCCode= '49690-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MODAFINIL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MODAFINIL','Modafinil', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MODAFINIL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MORPHINE' AND LOINCCode= '16251-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MORPHINE','Morphine', NULL, NULL, NULL, NULL, NULL, NULL,'16251-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MORPHINE' AND LOINCCode= '16251-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NANDROLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NANDROLONE','Nandrolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NANDROLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NORBOLETHONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NORBOLETHONE','Norbolethone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NORBOLETHONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NORCLOSTEBOL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NORCLOSTEBOL','Norclostebol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NORCLOSTEBOL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NORETHINDRONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NORETHINDRONE','Norethindrone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NORETHINDRONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NORTRIPTYLINE' AND LOINCCode= '61428-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NORTRIPTYLINE','Nortriptyline', NULL, NULL, NULL, NULL, NULL, NULL,'61428-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NORTRIPTYLINE' AND LOINCCode= '61428-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NP' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NP','Not Prescribed', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NP' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'O-DESMETHYL TRA' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'O-DESMETHYL TRA','O-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='O-DESMETHYL TRA' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OXABOLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OXABOLONE','Oxabolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OXABOLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OXANDROLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OXANDROLONE','Oxandrolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OXANDROLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OXYCODONE' AND LOINCCode= '16249-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OXYCODONE','Oxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'16249-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OXYCODONE' AND LOINCCode= '16249-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OXYMESTERONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OXYMESTERONE','Oxymesterone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OXYMESTERONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OXYMETHOLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OXYMETHOLONE','Oxymetholone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OXYMETHOLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OXYMORPHONE' AND LOINCCode= '17395-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OXYMORPHONE','Oxymorphone', NULL, NULL, NULL, NULL, NULL, NULL,'17395-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OXYMORPHONE' AND LOINCCode= '17395-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PAROXETINE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PAROXETINE','Paroxetine', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PAROXETINE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PENTAZOCINE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PENTAZOCINE','Pentazocine', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PENTAZOCINE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PENTOBARBITAL' AND LOINCCode= '16240-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PENTOBARBITAL','Pentobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16240-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PENTOBARBITAL' AND LOINCCode= '16240-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PHENCYCLIDINE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PHENCYCLIDINE','Phencyclidine', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PHENCYCLIDINE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PHENOBARBITAL' AND LOINCCode= '16241-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PHENOBARBITAL','Phenobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16241-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PHENOBARBITAL' AND LOINCCode= '16241-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PHENTERMINE' AND LOINCCode= '20557-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PHENTERMINE','Phentermine', NULL, NULL, NULL, NULL, NULL, NULL,'20557-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PHENTERMINE' AND LOINCCode= '20557-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PREGABALIN' AND LOINCCode= '64125-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PREGABALIN','Pregabalin (Lyrica)', NULL, NULL, NULL, NULL, NULL, NULL,'64125-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PREGABALIN' AND LOINCCode= '64125-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PROBENECID' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PROBENECID','Probenecid', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PROBENECID' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PROMETHAZINE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PROMETHAZINE','Promethazine(Phenergan)', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PROMETHAZINE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PROPOXYPHENE' AND LOINCCode= '16242-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PROPOXYPHENE','Propoxyphene', NULL, NULL, NULL, NULL, NULL, NULL,'16242-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PROPOXYPHENE' AND LOINCCode= '16242-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PROTRIPTYLINE' AND LOINCCode= '26978-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PROTRIPTYLINE','Protriptyline', NULL, NULL, NULL, NULL, NULL, NULL,'26978-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PROTRIPTYLINE' AND LOINCCode= '26978-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SECOBARBITAL' AND LOINCCode= '16238-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SECOBARBITAL','Secobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16238-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SECOBARBITAL' AND LOINCCode= '16238-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SERTRALINE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SERTRALINE','Sertraline', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SERTRALINE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'STANOZOLOL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'STANOZOLOL','Stanozolol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='STANOZOLOL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'STENBOLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'STENBOLONE','Stenbolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='STENBOLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SYNTHCATH' AND LOINCCode= 'X00022'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SYNTHCATH','Synth. Cathinones (bath salts)', NULL, NULL, NULL, NULL, NULL, NULL,'X00022', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SYNTHCATH' AND LOINCCode= 'X00022' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TAPENTADOL' AND LOINCCode= '58402-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TAPENTADOL','Tapentadol', NULL, NULL, NULL, NULL, NULL, NULL,'58402-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TAPENTADOL' AND LOINCCode= '58402-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TIBOLONE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TIBOLONE','Tibolone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TIBOLONE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TOPIRAMATE' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TOPIRAMATE','Topiramate (Topamax)', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TOPIRAMATE' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TRAMADOL' AND LOINCCode= '20561-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TRAMADOL','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'20561-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TRAMADOL' AND LOINCCode= '20561-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TRAZODONE' AND LOINCCode= '27059-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TRAZODONE','Trazodone', NULL, NULL, NULL, NULL, NULL, NULL,'27059-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TRAZODONE' AND LOINCCode= '27059-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TRAZODONE-NEFAZ' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TRAZODONE-NEFAZ','Trazodone/Nefazodone', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TRAZODONE-NEFAZ' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TRIMIPRAMINE' AND LOINCCode= '12443-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TRIMIPRAMINE','Trimipramine', NULL, NULL, NULL, NULL, NULL, NULL,'12443-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TRIMIPRAMINE' AND LOINCCode= '12443-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'VENLAFAXINE' AND LOINCCode= '72774-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'VENLAFAXINE','Venlafaxine', NULL, NULL, NULL, NULL, NULL, NULL,'72774-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='VENLAFAXINE' AND LOINCCode= '72774-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'VENLAFAXINE/DES' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'VENLAFAXINE/DES','Venlafaxine/Desvenlafaxine', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='VENLAFAXINE/DES' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ZERANOL' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ZERANOL','Zeranol', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ZERANOL' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ZOLPIDEM' AND LOINCCode= '72770-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ZOLPIDEM','Zolpidem (Ambien)', NULL, NULL, NULL, NULL, NULL, NULL,'72770-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ZOLPIDEM' AND LOINCCode= '72770-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Cotinine' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Cotinine', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'COT' AND LOINCCode= '35642-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'COT','Cotinine', NULL, NULL, NULL, NULL, NULL, NULL,'35642-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cotinine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='COT' AND LOINCCode= '35642-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Cotinine' AND LOINCCode= '10366-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Cotinine','Cotinine', NULL, NULL, NULL, NULL, NULL, NULL,'10366-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cotinine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Cotinine' AND LOINCCode= '10366-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Cyclobenzaprine' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Cyclobenzaprine', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CYCL' AND LOINCCode= '61409-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CYCL','Cyclobenzaprine', NULL, NULL, NULL, NULL, NULL, NULL,'61409-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cyclobenzaprine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CYCL' AND LOINCCode= '61409-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Cyclobenzaprine' AND LOINCCode= '61410-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Cyclobenzaprine','Cyclobenzaprine', NULL, NULL, NULL, NULL, NULL, NULL,'61410-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cyclobenzaprine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Cyclobenzaprine' AND LOINCCode= '61410-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Dextromethorphan' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Dextromethorphan', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '3-MeO-Morphinan' AND LOINCCode= 'X00021'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '3-MeO-Morphinan','3-Methoxymorphinan', NULL, NULL, NULL, NULL, NULL, NULL,'X00021', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Dextromethorphan' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='3-MeO-Morphinan' AND LOINCCode= 'X00021' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '3-OH-Morphinan' AND LOINCCode= 'X00020'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '3-OH-Morphinan','3-Hydroxymorphinan', NULL, NULL, NULL, NULL, NULL, NULL,'X00020', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Dextromethorphan' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='3-OH-Morphinan' AND LOINCCode= 'X00020' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Dextromethorpha' AND LOINCCode= '21240-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Dextromethorpha','Dextromethorphan', NULL, NULL, NULL, NULL, NULL, NULL,'21240-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Dextromethorphan' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Dextromethorpha' AND LOINCCode= '21240-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Dextrorphan' AND LOINCCode= '73566-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Dextrorphan','Dextrorphan', NULL, NULL, NULL, NULL, NULL, NULL,'73566-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Dextromethorphan' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Dextrorphan' AND LOINCCode= '73566-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'DXMP' AND LOINCCode= '3539-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'DXMP','Dextromethorphan', NULL, NULL, NULL, NULL, NULL, NULL,'3539-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Dextromethorphan' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='DXMP' AND LOINCCode= '3539-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Ethyl Glucuronide' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Ethyl Glucuronide', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ALCM' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ALCM','Alcohol Metabolites', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Ethyl Glucuronide' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ALCM' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Ethyl Glucuroni' AND LOINCCode= '58378-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Ethyl Glucuroni','Ethyl Glucuronide', NULL, NULL, NULL, NULL, NULL, NULL,'58378-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Ethyl Glucuronide' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Ethyl Glucuroni' AND LOINCCode= '58378-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Ethyl Sulfate' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Ethyl Sulfate','Ethyl Sulfate', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Ethyl Glucuronide' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Ethyl Sulfate' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Methylphenidate' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Methylphenidate', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methylphenidate' AND LOINCCode= '20548-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methylphenidate','Methylphenidate', NULL, NULL, NULL, NULL, NULL, NULL,'20548-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Methylphenidate' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methylphenidate' AND LOINCCode= '20548-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MPHE' AND LOINCCode= '19578-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MPHE','Methylphenidate', NULL, NULL, NULL, NULL, NULL, NULL,'19578-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Methylphenidate' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MPHE' AND LOINCCode= '19578-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Ritalinic Acid' AND LOINCCode= '72790-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Ritalinic Acid','Ritalinic Acid', NULL, NULL, NULL, NULL, NULL, NULL,'72790-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Methylphenidate' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Ritalinic Acid' AND LOINCCode= '72790-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Mirtazapine' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Mirtazapine', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MIRT' AND LOINCCode= '47980-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MIRT','Mirtazapine', NULL, NULL, NULL, NULL, NULL, NULL,'47980-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Mirtazapine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MIRT' AND LOINCCode= '47980-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Mirtazapine' AND LOINCCode= '49690-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Mirtazapine','Mirtazapine', NULL, NULL, NULL, NULL, NULL, NULL,'49690-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Mirtazapine' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Mirtazapine' AND LOINCCode= '49690-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'PainComp All Tests Requested', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '2-OH-ET-Fluraze' AND LOINCCode= '20532-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '2-OH-ET-Fluraze','2-hydroxy-ethyl Flurazepam', NULL, NULL, NULL, NULL, NULL, NULL,'20532-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='2-OH-ET-Fluraze' AND LOINCCode= '20532-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '3-FMC' AND LOINCCode= 'X00022'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '3-FMC','3-FMC', NULL, NULL, NULL, NULL, NULL, NULL,'X00022', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='3-FMC' AND LOINCCode= 'X00022' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Butyl-073' AND LOINCCode= '72875-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Butyl-073','4-OH-Butyl-JWH-073', NULL, NULL, NULL, NULL, NULL, NULL,'72875-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Butyl-073' AND LOINCCode= '72875-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Penty-2201' AND LOINCCode= '72817-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Penty-2201','4-OH-Pentyl-AM-2201', NULL, NULL, NULL, NULL, NULL, NULL,'72817-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Penty-2201' AND LOINCCode= '72817-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Pentyl-018' AND LOINCCode= 'X00005'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Pentyl-018','4-OH-Pentyl-JWH-018', NULL, NULL, NULL, NULL, NULL, NULL,'X00005', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Pentyl-018' AND LOINCCode= 'X00005' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Pentyl-122' AND LOINCCode= 'X00003'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Pentyl-122','4-OH-Pentyl-JWH-122', NULL, NULL, NULL, NULL, NULL, NULL,'X00003', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Pentyl-122' AND LOINCCode= 'X00003' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Pentyl-144' AND LOINCCode= 'X00004'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Pentyl-144','4-OH-Pentyl-UR-144', NULL, NULL, NULL, NULL, NULL, NULL,'X00004', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Pentyl-144' AND LOINCCode= 'X00004' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Pentyl-210' AND LOINCCode= 'X00006'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Pentyl-210','4-OH-Pentyl-JWH-210', NULL, NULL, NULL, NULL, NULL, NULL,'X00006', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Pentyl-210' AND LOINCCode= 'X00006' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Pentyl-250' AND LOINCCode= 'X00007'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Pentyl-250','4-OH-Pentyl-JWH-250', NULL, NULL, NULL, NULL, NULL, NULL,'X00007', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Pentyl-250' AND LOINCCode= 'X00007' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-COOH-Pent-210' AND LOINCCode= 'X00008'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-COOH-Pent-210','5-COOH-Pentyl-JWH-210', NULL, NULL, NULL, NULL, NULL, NULL,'X00008', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-COOH-Pent-210' AND LOINCCode= 'X00008' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-COOH-Pent-250' AND LOINCCode= '72802-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-COOH-Pent-250','5-COOH-Pentyl-JWH-250', NULL, NULL, NULL, NULL, NULL, NULL,'72802-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-COOH-Pent-250' AND LOINCCode= '72802-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-018' AND LOINCCode= 'X00001'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-018','5-OH-Pentyl-JWH-018', NULL, NULL, NULL, NULL, NULL, NULL,'X00001', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-018' AND LOINCCode= 'X00001' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-081' AND LOINCCode= '72780-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-081','5-OH-Pentyl-JWH-081', NULL, NULL, NULL, NULL, NULL, NULL,'72780-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-081' AND LOINCCode= '72780-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-122' AND LOINCCode= 'X00002'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-122','5-OH-Pentyl-JWH-122', NULL, NULL, NULL, NULL, NULL, NULL,'X00002', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-122' AND LOINCCode= 'X00002' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-144' AND LOINCCode= 'X00010'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-144','5-OH-Pentyl-UR-144', NULL, NULL, NULL, NULL, NULL, NULL,'X00010', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-144' AND LOINCCode= 'X00010' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-210' AND LOINCCode= 'X00011'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-210','5-OH-Pentyl-JWH-210', NULL, NULL, NULL, NULL, NULL, NULL,'X00011', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-210' AND LOINCCode= 'X00011' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-250' AND LOINCCode= 'X00012'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-250','5-OH-Pentyl-JWH-250', NULL, NULL, NULL, NULL, NULL, NULL,'X00012', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-250' AND LOINCCode= 'X00012' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-398' AND LOINCCode= 'X00013'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-398','5-OH-Pentyl-JWH-398', NULL, NULL, NULL, NULL, NULL, NULL,'X00013', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-398' AND LOINCCode= 'X00013' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-Acetylcodeine' AND LOINCCode= '60514-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-Acetylcodeine','6-Acetylcodeine', NULL, NULL, NULL, NULL, NULL, NULL,'60514-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-Acetylcodeine' AND LOINCCode= '60514-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6MAM' AND LOINCCode= '19322-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6MAM','6-Monoacetylmorphine', NULL, NULL, NULL, NULL, NULL, NULL,'19322-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6MAM' AND LOINCCode= '19322-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-MAM' AND LOINCCode= '19593-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-MAM','6-monoacetylmorphine', NULL, NULL, NULL, NULL, NULL, NULL,'19593-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-MAM' AND LOINCCode= '19593-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-OH-Hexyl-019' AND LOINCCode= 'X00014'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-OH-Hexyl-019','6-OH-Hexyl-JWH-019', NULL, NULL, NULL, NULL, NULL, NULL,'X00014', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-OH-Hexyl-019' AND LOINCCode= 'X00014' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '7aClonazepam' AND LOINCCode= '51776-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '7aClonazepam','7-aminoclonazepam', NULL, NULL, NULL, NULL, NULL, NULL,'51776-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='7aClonazepam' AND LOINCCode= '51776-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ALCM' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ALCM','Alcohol Metabolites', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ALCM' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Alprazolam' AND LOINCCode= '59615-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Alprazolam','Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'59615-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Alprazolam' AND LOINCCode= '59615-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Amobarbital' AND LOINCCode= '16239-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Amobarbital','Amobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16239-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Amobarbital' AND LOINCCode= '16239-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'AMP' AND LOINCCode= '19261-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'AMP','Amphetamines', NULL, NULL, NULL, NULL, NULL, NULL,'19261-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='AMP' AND LOINCCode= '19261-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'a-OH-Alprazolam' AND LOINCCode= '16348-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'a-OH-Alprazolam','alpha-hydroxy-Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'16348-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='a-OH-Alprazolam' AND LOINCCode= '16348-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BAR' AND LOINCCode= '19270-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BAR','Barbiturates', NULL, NULL, NULL, NULL, NULL, NULL,'19270-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BAR' AND LOINCCode= '19270-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BEN' AND LOINCCode= '16195-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BEN','Benzodiazepines', NULL, NULL, NULL, NULL, NULL, NULL,'16195-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BEN' AND LOINCCode= '16195-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BPNP' AND LOINCCode= '16208-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BPNP','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'16208-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BPNP' AND LOINCCode= '16208-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Buprenorphine' AND LOINCCode= '49752-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Buprenorphine','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49752-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Buprenorphine' AND LOINCCode= '49752-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Butalbital' AND LOINCCode= '16237-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Butalbital','Butalbital', NULL, NULL, NULL, NULL, NULL, NULL,'16237-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Butalbital' AND LOINCCode= '16237-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ButanoicAcid073' AND LOINCCode= '72778-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ButanoicAcid073','Butanoic Acid-JWH-073', NULL, NULL, NULL, NULL, NULL, NULL,'72778-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ButanoicAcid073' AND LOINCCode= '72778-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Butylone' AND LOINCCode= 'X00023'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Butylone','Butylone', NULL, NULL, NULL, NULL, NULL, NULL,'X00023', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Butylone' AND LOINCCode= 'X00023' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BZE' AND LOINCCode= '16226-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BZE','Benzoylecgonine (Cocaine)', NULL, NULL, NULL, NULL, NULL, NULL,'16226-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BZE' AND LOINCCode= '16226-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Carboxy-THC' AND LOINCCode= '20521-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Carboxy-THC','Carboxy-THC', NULL, NULL, NULL, NULL, NULL, NULL,'20521-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Carboxy-THC' AND LOINCCode= '20521-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Carisoprodol' AND LOINCCode= '58427-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Carisoprodol','Carisoprodol', NULL, NULL, NULL, NULL, NULL, NULL,'58427-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Carisoprodol' AND LOINCCode= '58427-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CATH' AND LOINCCode= 'X00022'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CATH','Synthetic Cathinones', NULL, NULL, NULL, NULL, NULL, NULL,'X00022', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CATH' AND LOINCCode= 'X00022' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CHRM' AND LOINCCode= '33064-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CHRM','Chromate as Adulterant', NULL, NULL, NULL, NULL, NULL, NULL,'33064-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CHRM' AND LOINCCode= '33064-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'COC' AND LOINCCode= '19359-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'COC','Benzoylecgonine(Cocaine)', NULL, NULL, NULL, NULL, NULL, NULL,'19359-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='COC' AND LOINCCode= '19359-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Codeine' AND LOINCCode= '16250-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Codeine','Codeine', NULL, NULL, NULL, NULL, NULL, NULL,'16250-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Codeine' AND LOINCCode= '16250-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'COT' AND LOINCCode= '35642-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'COT','Cotinine', NULL, NULL, NULL, NULL, NULL, NULL,'35642-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='COT' AND LOINCCode= '35642-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Cotinine' AND LOINCCode= '10366-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Cotinine','Cotinine', NULL, NULL, NULL, NULL, NULL, NULL,'10366-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Cotinine' AND LOINCCode= '10366-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CRET' AND LOINCCode= '2161-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CRET','Creatinine', NULL, NULL, NULL, NULL, NULL, NULL,'2161-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CRET' AND LOINCCode= '2161-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Dihydrocodeine' AND LOINCCode= '19448-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Dihydrocodeine','Dihydrocodeine', NULL, NULL, NULL, NULL, NULL, NULL,'19448-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Dihydrocodeine' AND LOINCCode= '19448-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Ethyl Glucuroni' AND LOINCCode= '58378-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Ethyl Glucuroni','Ethyl Glucuronide', NULL, NULL, NULL, NULL, NULL, NULL,'58378-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Ethyl Glucuroni' AND LOINCCode= '58378-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Ethyl Sulfate' AND LOINCCode= ''  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Ethyl Sulfate','Ethyl Sulfate', NULL, NULL, NULL, NULL, NULL, NULL,'', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Ethyl Sulfate' AND LOINCCode= '' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Fentanyl' AND LOINCCode= '58381-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Fentanyl','Fentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58381-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Fentanyl' AND LOINCCode= '58381-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'FNTL' AND LOINCCode= '66129-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'FNTL','Fentanyl Analogues', NULL, NULL, NULL, NULL, NULL, NULL,'66129-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='FNTL' AND LOINCCode= '66129-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Gabapentin' AND LOINCCode= '72810-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Gabapentin','Gabapentin (Neurontin)', NULL, NULL, NULL, NULL, NULL, NULL,'72810-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Gabapentin' AND LOINCCode= '72810-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'GBPR' AND LOINCCode= 'X00018'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'GBPR','Gabapentin/Pregabalin', NULL, NULL, NULL, NULL, NULL, NULL,'X00018', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='GBPR' AND LOINCCode= 'X00018' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Heroin' AND LOINCCode= '16755-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Heroin','Heroin', NULL, NULL, NULL, NULL, NULL, NULL,'16755-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Heroin' AND LOINCCode= '16755-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Hydrocodone' AND LOINCCode= '16252-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Hydrocodone','Hydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'16252-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Hydrocodone' AND LOINCCode= '16252-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Hydromorphone' AND LOINCCode= '16998-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Hydromorphone','Hydromorphone', NULL, NULL, NULL, NULL, NULL, NULL,'16998-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Hydromorphone' AND LOINCCode= '16998-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Lorazepam' AND LOINCCode= '16228-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Lorazepam','Lorazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16228-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Lorazepam' AND LOINCCode= '16228-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MDPV' AND LOINCCode= '72797-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MDPV','MDPV', NULL, NULL, NULL, NULL, NULL, NULL,'72797-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MDPV' AND LOINCCode= '72797-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MEP' AND LOINCCode= '16207-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MEP','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16207-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MEP' AND LOINCCode= '16207-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Meperidine' AND LOINCCode= '16253-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Meperidine','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16253-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Meperidine' AND LOINCCode= '16253-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Mephedrone' AND LOINCCode= '72795-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Mephedrone','Mephedrone', NULL, NULL, NULL, NULL, NULL, NULL,'72795-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Mephedrone' AND LOINCCode= '72795-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Meprobamate' AND LOINCCode= '58374-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Meprobamate','Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'58374-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Meprobamate' AND LOINCCode= '58374-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methadone' AND LOINCCode= '16246-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methadone','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16246-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methadone' AND LOINCCode= '16246-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MethadoneMTB' AND LOINCCode= '58429-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MethadoneMTB','Methadone Metabolite', NULL, NULL, NULL, NULL, NULL, NULL,'58429-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MethadoneMTB' AND LOINCCode= '58429-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methedrone' AND LOINCCode= 'X00024'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methedrone','Methedrone', NULL, NULL, NULL, NULL, NULL, NULL,'X00024', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methedrone' AND LOINCCode= 'X00024' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methylone' AND LOINCCode= '72793-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methylone','Methylone', NULL, NULL, NULL, NULL, NULL, NULL,'72793-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methylone' AND LOINCCode= '72793-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Morphine' AND LOINCCode= '16251-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Morphine','Morphine', NULL, NULL, NULL, NULL, NULL, NULL,'16251-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Morphine' AND LOINCCode= '16251-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MRBA' AND LOINCCode= '58370-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MRBA','Carisoprodol/Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'58370-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MRBA' AND LOINCCode= '58370-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MTD' AND LOINCCode= '16199-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MTD','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16199-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MTD' AND LOINCCode= '16199-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Naphyrone' AND LOINCCode= 'X00025'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Naphyrone','Naphyrone', NULL, NULL, NULL, NULL, NULL, NULL,'X00025', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Naphyrone' AND LOINCCode= 'X00025' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'N-Desmethyl Tra' AND LOINCCode= 'X00019'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'N-Desmethyl Tra','N-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'X00019', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='N-Desmethyl Tra' AND LOINCCode= 'X00019' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NITR' AND LOINCCode= '2657-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NITR','Nitrites as Adulterant', NULL, NULL, NULL, NULL, NULL, NULL,'2657-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NITR' AND LOINCCode= '2657-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norbuprenorphin' AND LOINCCode= '49751-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norbuprenorphin','Norbuprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49751-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norbuprenorphin' AND LOINCCode= '49751-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norcodeine' AND LOINCCode= '49829-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norcodeine','Norcodeine', NULL, NULL, NULL, NULL, NULL, NULL,'49829-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norcodeine' AND LOINCCode= '49829-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Nordiazepam' AND LOINCCode= '16228-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Nordiazepam','Nordiazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16228-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Nordiazepam' AND LOINCCode= '16228-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norfentanyl' AND LOINCCode= '58383-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norfentanyl','Norfentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58383-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norfentanyl' AND LOINCCode= '58383-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norhydrocodone' AND LOINCCode= '61422-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norhydrocodone','Norhydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'61422-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norhydrocodone' AND LOINCCode= '61422-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Normeperidine' AND LOINCCode= '58389-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Normeperidine','Normeperidine', NULL, NULL, NULL, NULL, NULL, NULL,'58389-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Normeperidine' AND LOINCCode= '58389-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Noroxycodone' AND LOINCCode= '61425-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Noroxycodone','Noroxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'61425-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Noroxycodone' AND LOINCCode= '61425-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Nortapentadol' AND LOINCCode= '65808-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Nortapentadol','Nortapentadol', NULL, NULL, NULL, NULL, NULL, NULL,'65808-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Nortapentadol' AND LOINCCode= '65808-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'O-Desmethyl Tra' AND LOINCCode= '18338-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'O-Desmethyl Tra','O-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'18338-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='O-Desmethyl Tra' AND LOINCCode= '18338-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OPI' AND LOINCCode= '18390-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OPI','Opiates', NULL, NULL, NULL, NULL, NULL, NULL,'18390-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OPI' AND LOINCCode= '18390-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxazepam' AND LOINCCode= '16201-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxazepam','Oxazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16201-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxazepam' AND LOINCCode= '16201-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxycodone' AND LOINCCode= '16249-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxycodone','Oxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'16249-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxycodone' AND LOINCCode= '16249-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxymorphone' AND LOINCCode= '17395-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxymorphone','Oxymorphone', NULL, NULL, NULL, NULL, NULL, NULL,'17395-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxymorphone' AND LOINCCode= '17395-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PentanoiAcid018' AND LOINCCode= '72782-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PentanoiAcid018','Pentanoic Acid-JWH-018', NULL, NULL, NULL, NULL, NULL, NULL,'72782-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PentanoiAcid018' AND LOINCCode= '72782-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pentanoic 144' AND LOINCCode= 'X00015'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pentanoic 144','Pentanoic Acid-UR-144', NULL, NULL, NULL, NULL, NULL, NULL,'X00015', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pentanoic 144' AND LOINCCode= 'X00015' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pentanoic 2201' AND LOINCCode= 'X00016'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pentanoic 2201','Pentanoic Acid-MAM-2201', NULL, NULL, NULL, NULL, NULL, NULL,'X00016', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pentanoic 2201' AND LOINCCode= 'X00016' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pentobarbital' AND LOINCCode= '16240-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pentobarbital','Pentobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16240-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pentobarbital' AND LOINCCode= '16240-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PH' AND LOINCCode= '2756-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PH','pH', NULL, NULL, NULL, NULL, NULL, NULL,'2756-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PH' AND LOINCCode= '2756-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PH2' AND LOINCCode= '2756-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PH2','pH', NULL, NULL, NULL, NULL, NULL, NULL,'2756-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PH2' AND LOINCCode= '2756-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Phenobarbital' AND LOINCCode= '16241-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Phenobarbital','Phenobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16241-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Phenobarbital' AND LOINCCode= '16241-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pregabalin' AND LOINCCode= '64125-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pregabalin','Pregabalin (Lyrica)', NULL, NULL, NULL, NULL, NULL, NULL,'64125-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pregabalin' AND LOINCCode= '64125-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Secobarbital' AND LOINCCode= '16238-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Secobarbital','Secobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16238-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Secobarbital' AND LOINCCode= '16238-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SPGR' AND LOINCCode= '2965-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SPGR','Specific Gravity', NULL, NULL, NULL, NULL, NULL, NULL,'2965-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SPGR' AND LOINCCode= '2965-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SYCN' AND LOINCCode= '72379-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SYCN','Synthetic Cannabinoids', NULL, NULL, NULL, NULL, NULL, NULL,'72379-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SYCN' AND LOINCCode= '72379-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Tapentadol' AND LOINCCode= '58402-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Tapentadol','Tapentadol', NULL, NULL, NULL, NULL, NULL, NULL,'58402-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Tapentadol' AND LOINCCode= '58402-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Temazepam' AND LOINCCode= '20559-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Temazepam','Temazepam', NULL, NULL, NULL, NULL, NULL, NULL,'20559-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Temazepam' AND LOINCCode= '20559-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'THC' AND LOINCCode= '19415-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'THC','THC', NULL, NULL, NULL, NULL, NULL, NULL,'19415-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='THC' AND LOINCCode= '19415-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TPTD' AND LOINCCode= '58401-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TPTD','Tapentadol', NULL, NULL, NULL, NULL, NULL, NULL,'58401-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TPTD' AND LOINCCode= '58401-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Tramadol' AND LOINCCode= '20561-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Tramadol','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'20561-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Tramadol' AND LOINCCode= '20561-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TRMD' AND LOINCCode= '17718-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TRMD','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'17718-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TRMD' AND LOINCCode= '17718-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'QMP' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'QMP', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '2-OH-ET-Fluraze' AND LOINCCode= '20532-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '2-OH-ET-Fluraze','2-hydroxy-ethyl Flurazepam', NULL, NULL, NULL, NULL, NULL, NULL,'20532-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='2-OH-ET-Fluraze' AND LOINCCode= '20532-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-Acetylcodeine' AND LOINCCode= '60514-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-Acetylcodeine','6-Acetylcodeine', NULL, NULL, NULL, NULL, NULL, NULL,'60514-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-Acetylcodeine' AND LOINCCode= '60514-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6MAM' AND LOINCCode= '19322-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6MAM','6-Monoacetylmorphine', NULL, NULL, NULL, NULL, NULL, NULL,'19322-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6MAM' AND LOINCCode= '19322-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-MAM' AND LOINCCode= '19593-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-MAM','6-monoacetylmorphine', NULL, NULL, NULL, NULL, NULL, NULL,'19593-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-MAM' AND LOINCCode= '19593-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '7aClonazepam' AND LOINCCode= '51776-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '7aClonazepam','7-aminoclonazepam', NULL, NULL, NULL, NULL, NULL, NULL,'51776-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='7aClonazepam' AND LOINCCode= '51776-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Alprazolam' AND LOINCCode= '59615-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Alprazolam','Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'59615-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Alprazolam' AND LOINCCode= '59615-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'a-OH-Alprazolam' AND LOINCCode= '16348-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'a-OH-Alprazolam','alpha-hydroxy-Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'16348-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='a-OH-Alprazolam' AND LOINCCode= '16348-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BEN' AND LOINCCode= '16195-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BEN','Benzodiazepines', NULL, NULL, NULL, NULL, NULL, NULL,'16195-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BEN' AND LOINCCode= '16195-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BPNP' AND LOINCCode= '16208-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BPNP','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'16208-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BPNP' AND LOINCCode= '16208-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Buprenorphine' AND LOINCCode= '49752-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Buprenorphine','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49752-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Buprenorphine' AND LOINCCode= '49752-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Carisoprodol' AND LOINCCode= '58427-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Carisoprodol','Carisoprodol', NULL, NULL, NULL, NULL, NULL, NULL,'58427-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Carisoprodol' AND LOINCCode= '58427-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CHRM' AND LOINCCode= '33064-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CHRM','Chromate as Adulterant', NULL, NULL, NULL, NULL, NULL, NULL,'33064-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CHRM' AND LOINCCode= '33064-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Codeine' AND LOINCCode= '16250-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Codeine','Codeine', NULL, NULL, NULL, NULL, NULL, NULL,'16250-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Codeine' AND LOINCCode= '16250-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CRET' AND LOINCCode= '2161-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CRET','Creatinine', NULL, NULL, NULL, NULL, NULL, NULL,'2161-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CRET' AND LOINCCode= '2161-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Dihydrocodeine' AND LOINCCode= '19448-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Dihydrocodeine','Dihydrocodeine', NULL, NULL, NULL, NULL, NULL, NULL,'19448-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Dihydrocodeine' AND LOINCCode= '19448-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Fentanyl' AND LOINCCode= '58381-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Fentanyl','Fentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58381-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Fentanyl' AND LOINCCode= '58381-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'FNTL' AND LOINCCode= '66129-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'FNTL','Fentanyl Analogues', NULL, NULL, NULL, NULL, NULL, NULL,'66129-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='FNTL' AND LOINCCode= '66129-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Gabapentin' AND LOINCCode= '72810-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Gabapentin','Gabapentin (Neurontin)', NULL, NULL, NULL, NULL, NULL, NULL,'72810-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Gabapentin' AND LOINCCode= '72810-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'GBPR' AND LOINCCode= 'X00018'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'GBPR','Gabapentin/Pregabalin', NULL, NULL, NULL, NULL, NULL, NULL,'X00018', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='GBPR' AND LOINCCode= 'X00018' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Heroin' AND LOINCCode= '16755-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Heroin','Heroin', NULL, NULL, NULL, NULL, NULL, NULL,'16755-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Heroin' AND LOINCCode= '16755-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Hydrocodone' AND LOINCCode= '16252-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Hydrocodone','Hydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'16252-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Hydrocodone' AND LOINCCode= '16252-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Hydromorphone' AND LOINCCode= '16998-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Hydromorphone','Hydromorphone', NULL, NULL, NULL, NULL, NULL, NULL,'16998-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Hydromorphone' AND LOINCCode= '16998-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Lorazepam' AND LOINCCode= '16228-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Lorazepam','Lorazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16228-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Lorazepam' AND LOINCCode= '16228-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MEP' AND LOINCCode= '16207-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MEP','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16207-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MEP' AND LOINCCode= '16207-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Meperidine' AND LOINCCode= '16253-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Meperidine','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16253-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Meperidine' AND LOINCCode= '16253-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Meprobamate' AND LOINCCode= '58374-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Meprobamate','Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'58374-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Meprobamate' AND LOINCCode= '58374-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methadone' AND LOINCCode= '16246-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methadone','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16246-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methadone' AND LOINCCode= '16246-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MethadoneMTB' AND LOINCCode= '58429-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MethadoneMTB','Methadone Metabolite', NULL, NULL, NULL, NULL, NULL, NULL,'58429-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MethadoneMTB' AND LOINCCode= '58429-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Morphine' AND LOINCCode= '16251-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Morphine','Morphine', NULL, NULL, NULL, NULL, NULL, NULL,'16251-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Morphine' AND LOINCCode= '16251-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MRBA' AND LOINCCode= '58370-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MRBA','Carisoprodol/Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'58370-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MRBA' AND LOINCCode= '58370-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MTD' AND LOINCCode= '16199-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MTD','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16199-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MTD' AND LOINCCode= '16199-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'N-Desmethyl Tra' AND LOINCCode= 'X00019'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'N-Desmethyl Tra','N-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'X00019', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='N-Desmethyl Tra' AND LOINCCode= 'X00019' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NITR' AND LOINCCode= '2657-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NITR','Nitrites as Adulterant', NULL, NULL, NULL, NULL, NULL, NULL,'2657-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NITR' AND LOINCCode= '2657-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norbuprenorphin' AND LOINCCode= '49751-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norbuprenorphin','Norbuprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49751-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norbuprenorphin' AND LOINCCode= '49751-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norcodeine' AND LOINCCode= '49829-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norcodeine','Norcodeine', NULL, NULL, NULL, NULL, NULL, NULL,'49829-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norcodeine' AND LOINCCode= '49829-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Nordiazepam' AND LOINCCode= '16228-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Nordiazepam','Nordiazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16228-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Nordiazepam' AND LOINCCode= '16228-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norfentanyl' AND LOINCCode= '58383-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norfentanyl','Norfentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58383-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norfentanyl' AND LOINCCode= '58383-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norhydrocodone' AND LOINCCode= '61422-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norhydrocodone','Norhydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'61422-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norhydrocodone' AND LOINCCode= '61422-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Normeperidine' AND LOINCCode= '58389-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Normeperidine','Normeperidine', NULL, NULL, NULL, NULL, NULL, NULL,'58389-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Normeperidine' AND LOINCCode= '58389-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Noroxycodone' AND LOINCCode= '61425-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Noroxycodone','Noroxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'61425-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Noroxycodone' AND LOINCCode= '61425-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'O-Desmethyl Tra' AND LOINCCode= '18338-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'O-Desmethyl Tra','O-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'18338-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='O-Desmethyl Tra' AND LOINCCode= '18338-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OPI' AND LOINCCode= '18390-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OPI','Opiates', NULL, NULL, NULL, NULL, NULL, NULL,'18390-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OPI' AND LOINCCode= '18390-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxazepam' AND LOINCCode= '16201-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxazepam','Oxazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16201-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxazepam' AND LOINCCode= '16201-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxycodone' AND LOINCCode= '16249-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxycodone','Oxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'16249-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxycodone' AND LOINCCode= '16249-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxymorphone' AND LOINCCode= '17395-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxymorphone','Oxymorphone', NULL, NULL, NULL, NULL, NULL, NULL,'17395-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxymorphone' AND LOINCCode= '17395-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PH' AND LOINCCode= '2756-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PH','pH', NULL, NULL, NULL, NULL, NULL, NULL,'2756-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PH' AND LOINCCode= '2756-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PH2' AND LOINCCode= '2756-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PH2','pH', NULL, NULL, NULL, NULL, NULL, NULL,'2756-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PH2' AND LOINCCode= '2756-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pregabalin' AND LOINCCode= '64125-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pregabalin','Pregabalin (Lyrica)', NULL, NULL, NULL, NULL, NULL, NULL,'64125-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pregabalin' AND LOINCCode= '64125-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SPGR' AND LOINCCode= '2965-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SPGR','Specific Gravity', NULL, NULL, NULL, NULL, NULL, NULL,'2965-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SPGR' AND LOINCCode= '2965-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Temazepam' AND LOINCCode= '20559-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Temazepam','Temazepam', NULL, NULL, NULL, NULL, NULL, NULL,'20559-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Temazepam' AND LOINCCode= '20559-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Tramadol' AND LOINCCode= '20561-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Tramadol','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'20561-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Tramadol' AND LOINCCode= '20561-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TRMD' AND LOINCCode= '17718-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TRMD','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'17718-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TRMD' AND LOINCCode= '17718-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'QMP Plus', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '2-OH-ET-Fluraze' AND LOINCCode= '20532-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '2-OH-ET-Fluraze','2-hydroxy-ethyl Flurazepam', NULL, NULL, NULL, NULL, NULL, NULL,'20532-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='2-OH-ET-Fluraze' AND LOINCCode= '20532-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-Acetylcodeine' AND LOINCCode= '60514-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-Acetylcodeine','6-Acetylcodeine', NULL, NULL, NULL, NULL, NULL, NULL,'60514-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-Acetylcodeine' AND LOINCCode= '60514-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6MAM' AND LOINCCode= '19322-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6MAM','6-Monoacetylmorphine', NULL, NULL, NULL, NULL, NULL, NULL,'19322-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6MAM' AND LOINCCode= '19322-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-MAM' AND LOINCCode= '19593-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-MAM','6-monoacetylmorphine', NULL, NULL, NULL, NULL, NULL, NULL,'19593-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-MAM' AND LOINCCode= '19593-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '7aClonazepam' AND LOINCCode= '51776-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '7aClonazepam','7-aminoclonazepam', NULL, NULL, NULL, NULL, NULL, NULL,'51776-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='7aClonazepam' AND LOINCCode= '51776-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Alprazolam' AND LOINCCode= '59615-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Alprazolam','Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'59615-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Alprazolam' AND LOINCCode= '59615-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Amobarbital' AND LOINCCode= '16239-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Amobarbital','Amobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16239-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Amobarbital' AND LOINCCode= '16239-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'AMP' AND LOINCCode= '19261-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'AMP','Amphetamines', NULL, NULL, NULL, NULL, NULL, NULL,'19261-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='AMP' AND LOINCCode= '19261-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Amphetamine' AND LOINCCode= '16234-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Amphetamine','Amphetamine', NULL, NULL, NULL, NULL, NULL, NULL,'16234-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Amphetamine' AND LOINCCode= '16234-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'a-OH-Alprazolam' AND LOINCCode= '16348-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'a-OH-Alprazolam','alpha-hydroxy-Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'16348-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='a-OH-Alprazolam' AND LOINCCode= '16348-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BAR' AND LOINCCode= '19270-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BAR','Barbiturates', NULL, NULL, NULL, NULL, NULL, NULL,'19270-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BAR' AND LOINCCode= '19270-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BEN' AND LOINCCode= '16195-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BEN','Benzodiazepines', NULL, NULL, NULL, NULL, NULL, NULL,'16195-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BEN' AND LOINCCode= '16195-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BPNP' AND LOINCCode= '16208-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BPNP','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'16208-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BPNP' AND LOINCCode= '16208-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Buprenorphine' AND LOINCCode= '49752-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Buprenorphine','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49752-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Buprenorphine' AND LOINCCode= '49752-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Butalbital' AND LOINCCode= '16237-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Butalbital','Butalbital', NULL, NULL, NULL, NULL, NULL, NULL,'16237-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Butalbital' AND LOINCCode= '16237-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BZE' AND LOINCCode= '16226-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BZE','Benzoylecgonine (Cocaine)', NULL, NULL, NULL, NULL, NULL, NULL,'16226-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BZE' AND LOINCCode= '16226-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Carboxy-THC' AND LOINCCode= '20521-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Carboxy-THC','Carboxy-THC', NULL, NULL, NULL, NULL, NULL, NULL,'20521-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Carboxy-THC' AND LOINCCode= '20521-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Carisoprodol' AND LOINCCode= '58427-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Carisoprodol','Carisoprodol', NULL, NULL, NULL, NULL, NULL, NULL,'58427-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Carisoprodol' AND LOINCCode= '58427-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CHRM' AND LOINCCode= '33064-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CHRM','Chromate as Adulterant', NULL, NULL, NULL, NULL, NULL, NULL,'33064-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CHRM' AND LOINCCode= '33064-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'COC' AND LOINCCode= '19359-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'COC','Benzoylecgonine(Cocaine)', NULL, NULL, NULL, NULL, NULL, NULL,'19359-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='COC' AND LOINCCode= '19359-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Codeine' AND LOINCCode= '16250-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Codeine','Codeine', NULL, NULL, NULL, NULL, NULL, NULL,'16250-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Codeine' AND LOINCCode= '16250-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CRET' AND LOINCCode= '2161-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CRET','Creatinine', NULL, NULL, NULL, NULL, NULL, NULL,'2161-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CRET' AND LOINCCode= '2161-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Dihydrocodeine' AND LOINCCode= '19448-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Dihydrocodeine','Dihydrocodeine', NULL, NULL, NULL, NULL, NULL, NULL,'19448-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Dihydrocodeine' AND LOINCCode= '19448-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Fentanyl' AND LOINCCode= '58381-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Fentanyl','Fentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58381-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Fentanyl' AND LOINCCode= '58381-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'FNTL' AND LOINCCode= '66129-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'FNTL','Fentanyl Analogues', NULL, NULL, NULL, NULL, NULL, NULL,'66129-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='FNTL' AND LOINCCode= '66129-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Gabapentin' AND LOINCCode= '72810-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Gabapentin','Gabapentin (Neurontin)', NULL, NULL, NULL, NULL, NULL, NULL,'72810-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Gabapentin' AND LOINCCode= '72810-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'GBPR' AND LOINCCode= 'X00018'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'GBPR','Gabapentin/Pregabalin', NULL, NULL, NULL, NULL, NULL, NULL,'X00018', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='GBPR' AND LOINCCode= 'X00018' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Heroin' AND LOINCCode= '16755-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Heroin','Heroin', NULL, NULL, NULL, NULL, NULL, NULL,'16755-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Heroin' AND LOINCCode= '16755-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Hydrocodone' AND LOINCCode= '16252-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Hydrocodone','Hydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'16252-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Hydrocodone' AND LOINCCode= '16252-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Hydromorphone' AND LOINCCode= '16998-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Hydromorphone','Hydromorphone', NULL, NULL, NULL, NULL, NULL, NULL,'16998-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Hydromorphone' AND LOINCCode= '16998-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Lorazepam' AND LOINCCode= '16228-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Lorazepam','Lorazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16228-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Lorazepam' AND LOINCCode= '16228-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MDA' AND LOINCCode= '20545-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MDA','MDA', NULL, NULL, NULL, NULL, NULL, NULL,'20545-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MDA' AND LOINCCode= '20545-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MDEA' AND LOINCCode= '45143-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MDEA','MDEA', NULL, NULL, NULL, NULL, NULL, NULL,'45143-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MDEA' AND LOINCCode= '45143-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MDMA' AND LOINCCode= '18358-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MDMA','MDMA', NULL, NULL, NULL, NULL, NULL, NULL,'18358-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MDMA' AND LOINCCode= '18358-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MEP' AND LOINCCode= '16207-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MEP','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16207-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MEP' AND LOINCCode= '16207-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Meperidine' AND LOINCCode= '16253-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Meperidine','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16253-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Meperidine' AND LOINCCode= '16253-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Meprobamate' AND LOINCCode= '58374-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Meprobamate','Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'58374-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Meprobamate' AND LOINCCode= '58374-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methadone' AND LOINCCode= '16246-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methadone','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16246-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methadone' AND LOINCCode= '16246-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MethadoneMTB' AND LOINCCode= '58429-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MethadoneMTB','Methadone Metabolite', NULL, NULL, NULL, NULL, NULL, NULL,'58429-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MethadoneMTB' AND LOINCCode= '58429-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methamphetamine' AND LOINCCode= '16235-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methamphetamine','Methamphetamine', NULL, NULL, NULL, NULL, NULL, NULL,'16235-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methamphetamine' AND LOINCCode= '16235-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Morphine' AND LOINCCode= '16251-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Morphine','Morphine', NULL, NULL, NULL, NULL, NULL, NULL,'16251-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Morphine' AND LOINCCode= '16251-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MRBA' AND LOINCCode= '58370-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MRBA','Carisoprodol/Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'58370-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MRBA' AND LOINCCode= '58370-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MTD' AND LOINCCode= '16199-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MTD','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16199-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MTD' AND LOINCCode= '16199-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'N-Desmethyl Tra' AND LOINCCode= 'X00019'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'N-Desmethyl Tra','N-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'X00019', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='N-Desmethyl Tra' AND LOINCCode= 'X00019' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NITR' AND LOINCCode= '2657-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NITR','Nitrites as Adulterant', NULL, NULL, NULL, NULL, NULL, NULL,'2657-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NITR' AND LOINCCode= '2657-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norbuprenorphin' AND LOINCCode= '49751-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norbuprenorphin','Norbuprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49751-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norbuprenorphin' AND LOINCCode= '49751-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norcodeine' AND LOINCCode= '49829-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norcodeine','Norcodeine', NULL, NULL, NULL, NULL, NULL, NULL,'49829-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norcodeine' AND LOINCCode= '49829-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Nordiazepam' AND LOINCCode= '16228-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Nordiazepam','Nordiazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16228-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Nordiazepam' AND LOINCCode= '16228-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norfentanyl' AND LOINCCode= '58383-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norfentanyl','Norfentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58383-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norfentanyl' AND LOINCCode= '58383-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norhydrocodone' AND LOINCCode= '61422-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norhydrocodone','Norhydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'61422-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norhydrocodone' AND LOINCCode= '61422-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Normeperidine' AND LOINCCode= '58389-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Normeperidine','Normeperidine', NULL, NULL, NULL, NULL, NULL, NULL,'58389-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Normeperidine' AND LOINCCode= '58389-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Noroxycodone' AND LOINCCode= '61425-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Noroxycodone','Noroxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'61425-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Noroxycodone' AND LOINCCode= '61425-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'O-Desmethyl Tra' AND LOINCCode= '18338-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'O-Desmethyl Tra','O-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'18338-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='O-Desmethyl Tra' AND LOINCCode= '18338-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OPI' AND LOINCCode= '18390-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OPI','Opiates', NULL, NULL, NULL, NULL, NULL, NULL,'18390-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OPI' AND LOINCCode= '18390-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxazepam' AND LOINCCode= '16201-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxazepam','Oxazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16201-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxazepam' AND LOINCCode= '16201-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxycodone' AND LOINCCode= '16249-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxycodone','Oxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'16249-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxycodone' AND LOINCCode= '16249-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxymorphone' AND LOINCCode= '17395-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxymorphone','Oxymorphone', NULL, NULL, NULL, NULL, NULL, NULL,'17395-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxymorphone' AND LOINCCode= '17395-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pentobarbital' AND LOINCCode= '16240-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pentobarbital','Pentobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16240-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pentobarbital' AND LOINCCode= '16240-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PH' AND LOINCCode= '2756-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PH','pH', NULL, NULL, NULL, NULL, NULL, NULL,'2756-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PH' AND LOINCCode= '2756-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PH2' AND LOINCCode= '2756-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PH2','pH', NULL, NULL, NULL, NULL, NULL, NULL,'2756-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PH2' AND LOINCCode= '2756-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Phenobarbital' AND LOINCCode= '16241-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Phenobarbital','Phenobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16241-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Phenobarbital' AND LOINCCode= '16241-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Phentermine' AND LOINCCode= '20557-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Phentermine','Phentermine', NULL, NULL, NULL, NULL, NULL, NULL,'20557-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Phentermine' AND LOINCCode= '20557-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pregabalin' AND LOINCCode= '64125-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pregabalin','Pregabalin (Lyrica)', NULL, NULL, NULL, NULL, NULL, NULL,'64125-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pregabalin' AND LOINCCode= '64125-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Secobarbital' AND LOINCCode= '16238-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Secobarbital','Secobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16238-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Secobarbital' AND LOINCCode= '16238-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SPGR' AND LOINCCode= '2965-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SPGR','Specific Gravity', NULL, NULL, NULL, NULL, NULL, NULL,'2965-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SPGR' AND LOINCCode= '2965-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Temazepam' AND LOINCCode= '20559-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Temazepam','Temazepam', NULL, NULL, NULL, NULL, NULL, NULL,'20559-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Temazepam' AND LOINCCode= '20559-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'THC' AND LOINCCode= '19415-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'THC','THC', NULL, NULL, NULL, NULL, NULL, NULL,'19415-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='THC' AND LOINCCode= '19415-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Tramadol' AND LOINCCode= '20561-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Tramadol','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'20561-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Tramadol' AND LOINCCode= '20561-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TRMD' AND LOINCCode= '17718-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TRMD','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'17718-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TRMD' AND LOINCCode= '17718-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'QMP Plus D/L', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '2-OH-ET-Fluraze' AND LOINCCode= '20532-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '2-OH-ET-Fluraze','2-hydroxy-ethyl Flurazepam', NULL, NULL, NULL, NULL, NULL, NULL,'20532-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='2-OH-ET-Fluraze' AND LOINCCode= '20532-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-Acetylcodeine' AND LOINCCode= '60514-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-Acetylcodeine','6-Acetylcodeine', NULL, NULL, NULL, NULL, NULL, NULL,'60514-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-Acetylcodeine' AND LOINCCode= '60514-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6MAM' AND LOINCCode= '19322-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6MAM','6-Monoacetylmorphine', NULL, NULL, NULL, NULL, NULL, NULL,'19322-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6MAM' AND LOINCCode= '19322-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-MAM' AND LOINCCode= '19593-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-MAM','6-monoacetylmorphine', NULL, NULL, NULL, NULL, NULL, NULL,'19593-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-MAM' AND LOINCCode= '19593-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '7aClonazepam' AND LOINCCode= '51776-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '7aClonazepam','7-aminoclonazepam', NULL, NULL, NULL, NULL, NULL, NULL,'51776-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='7aClonazepam' AND LOINCCode= '51776-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Alprazolam' AND LOINCCode= '59615-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Alprazolam','Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'59615-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Alprazolam' AND LOINCCode= '59615-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Amobarbital' AND LOINCCode= '16239-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Amobarbital','Amobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16239-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Amobarbital' AND LOINCCode= '16239-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'AMP' AND LOINCCode= '19261-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'AMP','Amphetamines', NULL, NULL, NULL, NULL, NULL, NULL,'19261-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='AMP' AND LOINCCode= '19261-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'a-OH-Alprazolam' AND LOINCCode= '16348-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'a-OH-Alprazolam','alpha-hydroxy-Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'16348-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='a-OH-Alprazolam' AND LOINCCode= '16348-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BAR' AND LOINCCode= '19270-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BAR','Barbiturates', NULL, NULL, NULL, NULL, NULL, NULL,'19270-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BAR' AND LOINCCode= '19270-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BEN' AND LOINCCode= '16195-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BEN','Benzodiazepines', NULL, NULL, NULL, NULL, NULL, NULL,'16195-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BEN' AND LOINCCode= '16195-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BPNP' AND LOINCCode= '16208-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BPNP','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'16208-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BPNP' AND LOINCCode= '16208-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Buprenorphine' AND LOINCCode= '49752-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Buprenorphine','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49752-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Buprenorphine' AND LOINCCode= '49752-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Butalbital' AND LOINCCode= '16237-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Butalbital','Butalbital', NULL, NULL, NULL, NULL, NULL, NULL,'16237-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Butalbital' AND LOINCCode= '16237-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BZE' AND LOINCCode= '16226-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BZE','Benzoylecgonine (Cocaine)', NULL, NULL, NULL, NULL, NULL, NULL,'16226-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BZE' AND LOINCCode= '16226-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Carboxy-THC' AND LOINCCode= '20521-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Carboxy-THC','Carboxy-THC', NULL, NULL, NULL, NULL, NULL, NULL,'20521-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Carboxy-THC' AND LOINCCode= '20521-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Carisoprodol' AND LOINCCode= '58427-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Carisoprodol','Carisoprodol', NULL, NULL, NULL, NULL, NULL, NULL,'58427-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Carisoprodol' AND LOINCCode= '58427-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CHRM' AND LOINCCode= '33064-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CHRM','Chromate as Adulterant', NULL, NULL, NULL, NULL, NULL, NULL,'33064-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CHRM' AND LOINCCode= '33064-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'COC' AND LOINCCode= '19359-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'COC','Benzoylecgonine(Cocaine)', NULL, NULL, NULL, NULL, NULL, NULL,'19359-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='COC' AND LOINCCode= '19359-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Codeine' AND LOINCCode= '16250-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Codeine','Codeine', NULL, NULL, NULL, NULL, NULL, NULL,'16250-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Codeine' AND LOINCCode= '16250-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CRET' AND LOINCCode= '2161-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CRET','Creatinine', NULL, NULL, NULL, NULL, NULL, NULL,'2161-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CRET' AND LOINCCode= '2161-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Dihydrocodeine' AND LOINCCode= '19448-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Dihydrocodeine','Dihydrocodeine', NULL, NULL, NULL, NULL, NULL, NULL,'19448-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Dihydrocodeine' AND LOINCCode= '19448-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Fentanyl' AND LOINCCode= '58381-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Fentanyl','Fentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58381-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Fentanyl' AND LOINCCode= '58381-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'FNTL' AND LOINCCode= '66129-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'FNTL','Fentanyl Analogues', NULL, NULL, NULL, NULL, NULL, NULL,'66129-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='FNTL' AND LOINCCode= '66129-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Gabapentin' AND LOINCCode= '72810-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Gabapentin','Gabapentin (Neurontin)', NULL, NULL, NULL, NULL, NULL, NULL,'72810-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Gabapentin' AND LOINCCode= '72810-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'GBPR' AND LOINCCode= 'X00018'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'GBPR','Gabapentin/Pregabalin', NULL, NULL, NULL, NULL, NULL, NULL,'X00018', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='GBPR' AND LOINCCode= 'X00018' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Heroin' AND LOINCCode= '16755-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Heroin','Heroin', NULL, NULL, NULL, NULL, NULL, NULL,'16755-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Heroin' AND LOINCCode= '16755-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Hydrocodone' AND LOINCCode= '16252-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Hydrocodone','Hydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'16252-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Hydrocodone' AND LOINCCode= '16252-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Hydromorphone' AND LOINCCode= '16998-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Hydromorphone','Hydromorphone', NULL, NULL, NULL, NULL, NULL, NULL,'16998-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Hydromorphone' AND LOINCCode= '16998-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Lorazepam' AND LOINCCode= '16228-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Lorazepam','Lorazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16228-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Lorazepam' AND LOINCCode= '16228-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MEP' AND LOINCCode= '16207-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MEP','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16207-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MEP' AND LOINCCode= '16207-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Meperidine' AND LOINCCode= '16253-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Meperidine','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16253-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Meperidine' AND LOINCCode= '16253-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Meprobamate' AND LOINCCode= '58374-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Meprobamate','Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'58374-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Meprobamate' AND LOINCCode= '58374-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methadone' AND LOINCCode= '16246-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methadone','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16246-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methadone' AND LOINCCode= '16246-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MethadoneMTB' AND LOINCCode= '58429-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MethadoneMTB','Methadone Metabolite', NULL, NULL, NULL, NULL, NULL, NULL,'58429-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MethadoneMTB' AND LOINCCode= '58429-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Morphine' AND LOINCCode= '16251-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Morphine','Morphine', NULL, NULL, NULL, NULL, NULL, NULL,'16251-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Morphine' AND LOINCCode= '16251-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MRBA' AND LOINCCode= '58370-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MRBA','Carisoprodol/Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'58370-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MRBA' AND LOINCCode= '58370-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MTD' AND LOINCCode= '16199-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MTD','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16199-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MTD' AND LOINCCode= '16199-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'N-Desmethyl Tra' AND LOINCCode= 'X00019'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'N-Desmethyl Tra','N-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'X00019', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='N-Desmethyl Tra' AND LOINCCode= 'X00019' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NITR' AND LOINCCode= '2657-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NITR','Nitrites as Adulterant', NULL, NULL, NULL, NULL, NULL, NULL,'2657-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NITR' AND LOINCCode= '2657-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norbuprenorphin' AND LOINCCode= '49751-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norbuprenorphin','Norbuprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49751-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norbuprenorphin' AND LOINCCode= '49751-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norcodeine' AND LOINCCode= '49829-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norcodeine','Norcodeine', NULL, NULL, NULL, NULL, NULL, NULL,'49829-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norcodeine' AND LOINCCode= '49829-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Nordiazepam' AND LOINCCode= '16228-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Nordiazepam','Nordiazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16228-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Nordiazepam' AND LOINCCode= '16228-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norfentanyl' AND LOINCCode= '58383-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norfentanyl','Norfentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58383-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norfentanyl' AND LOINCCode= '58383-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norhydrocodone' AND LOINCCode= '61422-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norhydrocodone','Norhydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'61422-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norhydrocodone' AND LOINCCode= '61422-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Normeperidine' AND LOINCCode= '58389-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Normeperidine','Normeperidine', NULL, NULL, NULL, NULL, NULL, NULL,'58389-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Normeperidine' AND LOINCCode= '58389-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Noroxycodone' AND LOINCCode= '61425-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Noroxycodone','Noroxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'61425-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Noroxycodone' AND LOINCCode= '61425-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'O-Desmethyl Tra' AND LOINCCode= '18338-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'O-Desmethyl Tra','O-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'18338-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='O-Desmethyl Tra' AND LOINCCode= '18338-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OPI' AND LOINCCode= '18390-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OPI','Opiates', NULL, NULL, NULL, NULL, NULL, NULL,'18390-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OPI' AND LOINCCode= '18390-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxazepam' AND LOINCCode= '16201-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxazepam','Oxazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16201-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxazepam' AND LOINCCode= '16201-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxycodone' AND LOINCCode= '16249-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxycodone','Oxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'16249-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxycodone' AND LOINCCode= '16249-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxymorphone' AND LOINCCode= '17395-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxymorphone','Oxymorphone', NULL, NULL, NULL, NULL, NULL, NULL,'17395-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxymorphone' AND LOINCCode= '17395-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pentobarbital' AND LOINCCode= '16240-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pentobarbital','Pentobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16240-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pentobarbital' AND LOINCCode= '16240-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PH' AND LOINCCode= '2756-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PH','pH', NULL, NULL, NULL, NULL, NULL, NULL,'2756-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PH' AND LOINCCode= '2756-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PH2' AND LOINCCode= '2756-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PH2','pH', NULL, NULL, NULL, NULL, NULL, NULL,'2756-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PH2' AND LOINCCode= '2756-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Phenobarbital' AND LOINCCode= '16241-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Phenobarbital','Phenobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16241-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Phenobarbital' AND LOINCCode= '16241-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pregabalin' AND LOINCCode= '64125-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pregabalin','Pregabalin (Lyrica)', NULL, NULL, NULL, NULL, NULL, NULL,'64125-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pregabalin' AND LOINCCode= '64125-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Secobarbital' AND LOINCCode= '16238-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Secobarbital','Secobarbital', NULL, NULL, NULL, NULL, NULL, NULL,'16238-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Secobarbital' AND LOINCCode= '16238-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SPGR' AND LOINCCode= '2965-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SPGR','Specific Gravity', NULL, NULL, NULL, NULL, NULL, NULL,'2965-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SPGR' AND LOINCCode= '2965-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Temazepam' AND LOINCCode= '20559-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Temazepam','Temazepam', NULL, NULL, NULL, NULL, NULL, NULL,'20559-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Temazepam' AND LOINCCode= '20559-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'THC' AND LOINCCode= '19415-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'THC','THC', NULL, NULL, NULL, NULL, NULL, NULL,'19415-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='THC' AND LOINCCode= '19415-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Tramadol' AND LOINCCode= '20561-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Tramadol','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'20561-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Tramadol' AND LOINCCode= '20561-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TRMD' AND LOINCCode= '17718-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TRMD','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'17718-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TRMD' AND LOINCCode= '17718-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'QMP-SVT', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '2-OH-ET-Fluraze' AND LOINCCode= '20532-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '2-OH-ET-Fluraze','2-hydroxy-ethyl Flurazepam', NULL, NULL, NULL, NULL, NULL, NULL,'20532-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='2-OH-ET-Fluraze' AND LOINCCode= '20532-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-Acetylcodeine' AND LOINCCode= '60514-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-Acetylcodeine','6-Acetylcodeine', NULL, NULL, NULL, NULL, NULL, NULL,'60514-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-Acetylcodeine' AND LOINCCode= '60514-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6MAM' AND LOINCCode= '19322-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6MAM','6-Monoacetylmorphine', NULL, NULL, NULL, NULL, NULL, NULL,'19322-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6MAM' AND LOINCCode= '19322-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-MAM' AND LOINCCode= '19593-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-MAM','6-monoacetylmorphine', NULL, NULL, NULL, NULL, NULL, NULL,'19593-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-MAM' AND LOINCCode= '19593-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '7aClonazepam' AND LOINCCode= '51776-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '7aClonazepam','7-aminoclonazepam', NULL, NULL, NULL, NULL, NULL, NULL,'51776-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='7aClonazepam' AND LOINCCode= '51776-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Alprazolam' AND LOINCCode= '59615-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Alprazolam','Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'59615-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Alprazolam' AND LOINCCode= '59615-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'a-OH-Alprazolam' AND LOINCCode= '16348-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'a-OH-Alprazolam','alpha-hydroxy-Alprazolam', NULL, NULL, NULL, NULL, NULL, NULL,'16348-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='a-OH-Alprazolam' AND LOINCCode= '16348-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BEN' AND LOINCCode= '16195-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BEN','Benzodiazepines', NULL, NULL, NULL, NULL, NULL, NULL,'16195-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BEN' AND LOINCCode= '16195-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'BPNP' AND LOINCCode= '16208-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'BPNP','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'16208-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='BPNP' AND LOINCCode= '16208-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Buprenorphine' AND LOINCCode= '49752-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Buprenorphine','Buprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49752-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Buprenorphine' AND LOINCCode= '49752-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Carisoprodol' AND LOINCCode= '58427-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Carisoprodol','Carisoprodol', NULL, NULL, NULL, NULL, NULL, NULL,'58427-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Carisoprodol' AND LOINCCode= '58427-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CHRM' AND LOINCCode= '33064-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CHRM','Chromate as Adulterant', NULL, NULL, NULL, NULL, NULL, NULL,'33064-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CHRM' AND LOINCCode= '33064-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Codeine' AND LOINCCode= '16250-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Codeine','Codeine', NULL, NULL, NULL, NULL, NULL, NULL,'16250-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Codeine' AND LOINCCode= '16250-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Dihydrocodeine' AND LOINCCode= '19448-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Dihydrocodeine','Dihydrocodeine', NULL, NULL, NULL, NULL, NULL, NULL,'19448-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Dihydrocodeine' AND LOINCCode= '19448-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Fentanyl' AND LOINCCode= '58381-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Fentanyl','Fentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58381-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Fentanyl' AND LOINCCode= '58381-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'FNTL' AND LOINCCode= '66129-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'FNTL','Fentanyl Analogues', NULL, NULL, NULL, NULL, NULL, NULL,'66129-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='FNTL' AND LOINCCode= '66129-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Gabapentin' AND LOINCCode= '72810-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Gabapentin','Gabapentin (Neurontin)', NULL, NULL, NULL, NULL, NULL, NULL,'72810-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Gabapentin' AND LOINCCode= '72810-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'GBPR' AND LOINCCode= 'X00018'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'GBPR','Gabapentin/Pregabalin', NULL, NULL, NULL, NULL, NULL, NULL,'X00018', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='GBPR' AND LOINCCode= 'X00018' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Heroin' AND LOINCCode= '16755-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Heroin','Heroin', NULL, NULL, NULL, NULL, NULL, NULL,'16755-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Heroin' AND LOINCCode= '16755-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Hydrocodone' AND LOINCCode= '16252-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Hydrocodone','Hydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'16252-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Hydrocodone' AND LOINCCode= '16252-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Hydromorphone' AND LOINCCode= '16998-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Hydromorphone','Hydromorphone', NULL, NULL, NULL, NULL, NULL, NULL,'16998-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Hydromorphone' AND LOINCCode= '16998-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Lorazepam' AND LOINCCode= '16228-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Lorazepam','Lorazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16228-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Lorazepam' AND LOINCCode= '16228-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MEP' AND LOINCCode= '16207-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MEP','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16207-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MEP' AND LOINCCode= '16207-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Meperidine' AND LOINCCode= '16253-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Meperidine','Meperidine', NULL, NULL, NULL, NULL, NULL, NULL,'16253-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Meperidine' AND LOINCCode= '16253-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Meprobamate' AND LOINCCode= '58374-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Meprobamate','Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'58374-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Meprobamate' AND LOINCCode= '58374-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methadone' AND LOINCCode= '16246-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methadone','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16246-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methadone' AND LOINCCode= '16246-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MethadoneMTB' AND LOINCCode= '58429-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MethadoneMTB','Methadone Metabolite', NULL, NULL, NULL, NULL, NULL, NULL,'58429-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MethadoneMTB' AND LOINCCode= '58429-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Morphine' AND LOINCCode= '16251-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Morphine','Morphine', NULL, NULL, NULL, NULL, NULL, NULL,'16251-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Morphine' AND LOINCCode= '16251-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MRBA' AND LOINCCode= '58370-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MRBA','Carisoprodol/Meprobamate', NULL, NULL, NULL, NULL, NULL, NULL,'58370-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MRBA' AND LOINCCode= '58370-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MTD' AND LOINCCode= '16199-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MTD','Methadone', NULL, NULL, NULL, NULL, NULL, NULL,'16199-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MTD' AND LOINCCode= '16199-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'N-Desmethyl Tra' AND LOINCCode= 'X00019'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'N-Desmethyl Tra','N-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'X00019', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='N-Desmethyl Tra' AND LOINCCode= 'X00019' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'NITR' AND LOINCCode= '2657-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'NITR','Nitrites as Adulterant', NULL, NULL, NULL, NULL, NULL, NULL,'2657-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='NITR' AND LOINCCode= '2657-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norbuprenorphin' AND LOINCCode= '49751-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norbuprenorphin','Norbuprenorphine', NULL, NULL, NULL, NULL, NULL, NULL,'49751-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norbuprenorphin' AND LOINCCode= '49751-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norcodeine' AND LOINCCode= '49829-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norcodeine','Norcodeine', NULL, NULL, NULL, NULL, NULL, NULL,'49829-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norcodeine' AND LOINCCode= '49829-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Nordiazepam' AND LOINCCode= '16228-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Nordiazepam','Nordiazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16228-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Nordiazepam' AND LOINCCode= '16228-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norfentanyl' AND LOINCCode= '58383-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norfentanyl','Norfentanyl', NULL, NULL, NULL, NULL, NULL, NULL,'58383-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norfentanyl' AND LOINCCode= '58383-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Norhydrocodone' AND LOINCCode= '61422-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Norhydrocodone','Norhydrocodone', NULL, NULL, NULL, NULL, NULL, NULL,'61422-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Norhydrocodone' AND LOINCCode= '61422-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Normeperidine' AND LOINCCode= '58389-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Normeperidine','Normeperidine', NULL, NULL, NULL, NULL, NULL, NULL,'58389-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Normeperidine' AND LOINCCode= '58389-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Noroxycodone' AND LOINCCode= '61425-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Noroxycodone','Noroxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'61425-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Noroxycodone' AND LOINCCode= '61425-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'O-Desmethyl Tra' AND LOINCCode= '18338-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'O-Desmethyl Tra','O-Desmethyl Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'18338-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='O-Desmethyl Tra' AND LOINCCode= '18338-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'OPI' AND LOINCCode= '18390-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'OPI','Opiates', NULL, NULL, NULL, NULL, NULL, NULL,'18390-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='OPI' AND LOINCCode= '18390-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxazepam' AND LOINCCode= '16201-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxazepam','Oxazepam', NULL, NULL, NULL, NULL, NULL, NULL,'16201-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxazepam' AND LOINCCode= '16201-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxycodone' AND LOINCCode= '16249-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxycodone','Oxycodone', NULL, NULL, NULL, NULL, NULL, NULL,'16249-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxycodone' AND LOINCCode= '16249-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Oxymorphone' AND LOINCCode= '17395-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Oxymorphone','Oxymorphone', NULL, NULL, NULL, NULL, NULL, NULL,'17395-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Oxymorphone' AND LOINCCode= '17395-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pregabalin' AND LOINCCode= '64125-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pregabalin','Pregabalin (Lyrica)', NULL, NULL, NULL, NULL, NULL, NULL,'64125-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pregabalin' AND LOINCCode= '64125-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SPGR' AND LOINCCode= '2965-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SPGR','Specific Gravity', NULL, NULL, NULL, NULL, NULL, NULL,'2965-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SPGR' AND LOINCCode= '2965-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Temazepam' AND LOINCCode= '20559-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Temazepam','Temazepam', NULL, NULL, NULL, NULL, NULL, NULL,'20559-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Temazepam' AND LOINCCode= '20559-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Tramadol' AND LOINCCode= '20561-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Tramadol','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'20561-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Tramadol' AND LOINCCode= '20561-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TRMD' AND LOINCCode= '17718-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TRMD','Tramadol', NULL, NULL, NULL, NULL, NULL, NULL,'17718-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TRMD' AND LOINCCode= '17718-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'SNRI Profile' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'SNRI Profile', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-duloxetine' AND LOINCCode= 'X00027'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-duloxetine','4-hydroxy duloxetine', NULL, NULL, NULL, NULL, NULL, NULL,'X00027', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='SNRI Profile' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-duloxetine' AND LOINCCode= 'X00027' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Duloxetine' AND LOINCCode= '72814-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Duloxetine','Duloxetine', NULL, NULL, NULL, NULL, NULL, NULL,'72814-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='SNRI Profile' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Duloxetine' AND LOINCCode= '72814-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Milnacipran' AND LOINCCode= '59312-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Milnacipran','Milnacipran', NULL, NULL, NULL, NULL, NULL, NULL,'59312-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='SNRI Profile' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Milnacipran' AND LOINCCode= '59312-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'O-desmethylvenl' AND LOINCCode= '72772-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'O-desmethylvenl','O-desmethylvenlafaxine', NULL, NULL, NULL, NULL, NULL, NULL,'72772-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='SNRI Profile' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='O-desmethylvenl' AND LOINCCode= '72772-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SNRI' AND LOINCCode= 'X00028'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SNRI','SNRI Profile', NULL, NULL, NULL, NULL, NULL, NULL,'X00028', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='SNRI Profile' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SNRI' AND LOINCCode= 'X00028' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Venlafaxine' AND LOINCCode= '72774-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Venlafaxine','Venlafaxine', NULL, NULL, NULL, NULL, NULL, NULL,'72774-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='SNRI Profile' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Venlafaxine' AND LOINCCode= '72774-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Synthetic Cannabinoids', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Butyl-073' AND LOINCCode= '72875-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Butyl-073','4-OH-Butyl-JWH-073', NULL, NULL, NULL, NULL, NULL, NULL,'72875-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Butyl-073' AND LOINCCode= '72875-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Penty-2201' AND LOINCCode= '72817-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Penty-2201','4-OH-Pentyl-AM-2201', NULL, NULL, NULL, NULL, NULL, NULL,'72817-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Penty-2201' AND LOINCCode= '72817-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Pentyl-018' AND LOINCCode= 'X00005'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Pentyl-018','4-OH-Pentyl-JWH-018', NULL, NULL, NULL, NULL, NULL, NULL,'X00005', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Pentyl-018' AND LOINCCode= 'X00005' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Pentyl-122' AND LOINCCode= 'X00003'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Pentyl-122','4-OH-Pentyl-JWH-122', NULL, NULL, NULL, NULL, NULL, NULL,'X00003', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Pentyl-122' AND LOINCCode= 'X00003' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Pentyl-144' AND LOINCCode= 'X00004'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Pentyl-144','4-OH-Pentyl-UR-144', NULL, NULL, NULL, NULL, NULL, NULL,'X00004', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Pentyl-144' AND LOINCCode= 'X00004' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Pentyl-210' AND LOINCCode= 'X00006'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Pentyl-210','4-OH-Pentyl-JWH-210', NULL, NULL, NULL, NULL, NULL, NULL,'X00006', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Pentyl-210' AND LOINCCode= 'X00006' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '4-OH-Pentyl-250' AND LOINCCode= 'X00007'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '4-OH-Pentyl-250','4-OH-Pentyl-JWH-250', NULL, NULL, NULL, NULL, NULL, NULL,'X00007', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='4-OH-Pentyl-250' AND LOINCCode= 'X00007' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-COOH-Pent-210' AND LOINCCode= 'X00008'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-COOH-Pent-210','5-COOH-Pentyl-JWH-210', NULL, NULL, NULL, NULL, NULL, NULL,'X00008', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-COOH-Pent-210' AND LOINCCode= 'X00008' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-COOH-Pent-250' AND LOINCCode= '72802-2'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-COOH-Pent-250','5-COOH-Pentyl-JWH-250', NULL, NULL, NULL, NULL, NULL, NULL,'72802-2', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-COOH-Pent-250' AND LOINCCode= '72802-2' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-018' AND LOINCCode= 'X00001'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-018','5-OH-Pentyl-JWH-018', NULL, NULL, NULL, NULL, NULL, NULL,'X00001', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-018' AND LOINCCode= 'X00001' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-081' AND LOINCCode= '72780-0'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-081','5-OH-Pentyl-JWH-081', NULL, NULL, NULL, NULL, NULL, NULL,'72780-0', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-081' AND LOINCCode= '72780-0' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-122' AND LOINCCode= 'X00002'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-122','5-OH-Pentyl-JWH-122', NULL, NULL, NULL, NULL, NULL, NULL,'X00002', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-122' AND LOINCCode= 'X00002' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-144' AND LOINCCode= 'X00010'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-144','5-OH-Pentyl-UR-144', NULL, NULL, NULL, NULL, NULL, NULL,'X00010', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-144' AND LOINCCode= 'X00010' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-210' AND LOINCCode= 'X00011'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-210','5-OH-Pentyl-JWH-210', NULL, NULL, NULL, NULL, NULL, NULL,'X00011', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-210' AND LOINCCode= 'X00011' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-250' AND LOINCCode= 'X00012'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-250','5-OH-Pentyl-JWH-250', NULL, NULL, NULL, NULL, NULL, NULL,'X00012', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-250' AND LOINCCode= 'X00012' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '5-OH-Pentyl-398' AND LOINCCode= 'X00013'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '5-OH-Pentyl-398','5-OH-Pentyl-JWH-398', NULL, NULL, NULL, NULL, NULL, NULL,'X00013', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='5-OH-Pentyl-398' AND LOINCCode= 'X00013' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '6-OH-Hexyl-019' AND LOINCCode= 'X00014'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '6-OH-Hexyl-019','6-OH-Hexyl-JWH-019', NULL, NULL, NULL, NULL, NULL, NULL,'X00014', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='6-OH-Hexyl-019' AND LOINCCode= 'X00014' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ButanoicAcid073' AND LOINCCode= '72778-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ButanoicAcid073','Butanoic Acid-JWH-073', NULL, NULL, NULL, NULL, NULL, NULL,'72778-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ButanoicAcid073' AND LOINCCode= '72778-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'PentanoiAcid018' AND LOINCCode= '72782-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'PentanoiAcid018','Pentanoic Acid-JWH-018', NULL, NULL, NULL, NULL, NULL, NULL,'72782-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='PentanoiAcid018' AND LOINCCode= '72782-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pentanoic 144' AND LOINCCode= 'X00015'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pentanoic 144','Pentanoic Acid-UR-144', NULL, NULL, NULL, NULL, NULL, NULL,'X00015', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pentanoic 144' AND LOINCCode= 'X00015' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Pentanoic 2201' AND LOINCCode= 'X00016'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Pentanoic 2201','Pentanoic Acid-MAM-2201', NULL, NULL, NULL, NULL, NULL, NULL,'X00016', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Pentanoic 2201' AND LOINCCode= 'X00016' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'SYCN' AND LOINCCode= '72379-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'SYCN','Synthetic Cannabinoids', NULL, NULL, NULL, NULL, NULL, NULL,'72379-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='SYCN' AND LOINCCode= '72379-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Synthetic Cathinones', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= '3-FMC' AND LOINCCode= 'X00022'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, '3-FMC','3-FMC', NULL, NULL, NULL, NULL, NULL, NULL,'X00022', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='3-FMC' AND LOINCCode= 'X00022' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Butylone' AND LOINCCode= 'X00023'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Butylone','Butylone', NULL, NULL, NULL, NULL, NULL, NULL,'X00023', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Butylone' AND LOINCCode= 'X00023' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'CATH' AND LOINCCode= 'X00022'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'CATH','Synthetic Cathinones', NULL, NULL, NULL, NULL, NULL, NULL,'X00022', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='CATH' AND LOINCCode= 'X00022' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'MDPV' AND LOINCCode= '72797-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'MDPV','MDPV', NULL, NULL, NULL, NULL, NULL, NULL,'72797-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='MDPV' AND LOINCCode= '72797-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Mephedrone' AND LOINCCode= '72795-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Mephedrone','Mephedrone', NULL, NULL, NULL, NULL, NULL, NULL,'72795-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Mephedrone' AND LOINCCode= '72795-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methedrone' AND LOINCCode= 'X00024'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methedrone','Methedrone', NULL, NULL, NULL, NULL, NULL, NULL,'X00024', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methedrone' AND LOINCCode= 'X00024' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Methylone' AND LOINCCode= '72793-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Methylone','Methylone', NULL, NULL, NULL, NULL, NULL, NULL,'72793-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Methylone' AND LOINCCode= '72793-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Naphyrone' AND LOINCCode= 'X00025'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Naphyrone','Naphyrone', NULL, NULL, NULL, NULL, NULL, NULL,'X00025', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Naphyrone' AND LOINCCode= 'X00025' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Tapentadol' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Tapentadol', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Nortapentadol' AND LOINCCode= '65808-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Nortapentadol','Nortapentadol', NULL, NULL, NULL, NULL, NULL, NULL,'65808-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tapentadol' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Nortapentadol' AND LOINCCode= '65808-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Tapentadol' AND LOINCCode= '58402-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Tapentadol','Tapentadol', NULL, NULL, NULL, NULL, NULL, NULL,'58402-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tapentadol' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Tapentadol' AND LOINCCode= '58402-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TPTD' AND LOINCCode= '58401-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TPTD','Tapentadol', NULL, NULL, NULL, NULL, NULL, NULL,'58401-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tapentadol' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TPTD' AND LOINCCode= '58401-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Trazodone' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Trazodone', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'm-CPP' AND LOINCCode= 'X00017'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'm-CPP','m-CPP', NULL, NULL, NULL, NULL, NULL, NULL,'X00017', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Trazodone' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='m-CPP' AND LOINCCode= 'X00017' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Trazodone' AND LOINCCode= '27059-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Trazodone','Trazodone', NULL, NULL, NULL, NULL, NULL, NULL,'27059-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Trazodone' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Trazodone' AND LOINCCode= '27059-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TRZD' AND LOINCCode= '4065-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TRZD','Trazodone', NULL, NULL, NULL, NULL, NULL, NULL,'4065-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Trazodone' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TRZD' AND LOINCCode= '4065-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Tricyclic Antidepressants', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Amitriptyline' AND LOINCCode= '20515-3'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Amitriptyline','Amitriptyline', NULL, NULL, NULL, NULL, NULL, NULL,'20515-3', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Amitriptyline' AND LOINCCode= '20515-3' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Clomipramine' AND LOINCCode= '3492-6'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Clomipramine','Clomipramine', NULL, NULL, NULL, NULL, NULL, NULL,'3492-6', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Clomipramine' AND LOINCCode= '3492-6' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Cyclobenzaprine' AND LOINCCode= '61410-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Cyclobenzaprine','Cyclobenzaprine', NULL, NULL, NULL, NULL, NULL, NULL,'61410-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Cyclobenzaprine' AND LOINCCode= '61410-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Desipramine' AND LOINCCode= '61413-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Desipramine','Desipramine', NULL, NULL, NULL, NULL, NULL, NULL,'61413-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Desipramine' AND LOINCCode= '61413-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Desmethylclomip' AND LOINCCode= '18470-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Desmethylclomip','Desmethylclomipramine', NULL, NULL, NULL, NULL, NULL, NULL,'18470-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Desmethylclomip' AND LOINCCode= '18470-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Desmethyldoxepi' AND LOINCCode= '12386-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Desmethyldoxepi','Desmethyldoxepin', NULL, NULL, NULL, NULL, NULL, NULL,'12386-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Desmethyldoxepi' AND LOINCCode= '12386-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Doxepin' AND LOINCCode= '61416-4'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Doxepin','Doxepin', NULL, NULL, NULL, NULL, NULL, NULL,'61416-4', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Doxepin' AND LOINCCode= '61416-4' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Imipramine' AND LOINCCode= '61419-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Imipramine','Imipramine', NULL, NULL, NULL, NULL, NULL, NULL,'61419-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Imipramine' AND LOINCCode= '61419-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Mirtazapine' AND LOINCCode= '49690-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Mirtazapine','Mirtazapine', NULL, NULL, NULL, NULL, NULL, NULL,'49690-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Mirtazapine' AND LOINCCode= '49690-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Nortriptyline' AND LOINCCode= '61428-9'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Nortriptyline','Nortriptyline', NULL, NULL, NULL, NULL, NULL, NULL,'61428-9', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Nortriptyline' AND LOINCCode= '61428-9' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Protriptyline' AND LOINCCode= '26978-7'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Protriptyline','Protriptyline', NULL, NULL, NULL, NULL, NULL, NULL,'26978-7', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Protriptyline' AND LOINCCode= '26978-7' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'TCA' AND LOINCCode= '19315-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'TCA','Tricyclic Antidepressants', NULL, NULL, NULL, NULL, NULL, NULL,'19315-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='TCA' AND LOINCCode= '19315-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Trimipramine' AND LOINCCode= '12443-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Trimipramine','Trimipramine', NULL, NULL, NULL, NULL, NULL, NULL,'12443-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Trimipramine' AND LOINCCode= '12443-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplates  WHERE Name = 'Zolpidem' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataSubTemplates (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Name, Active, IsHeading)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),'Zolpidem', 'Y', NULL)
	END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Zol Met I' AND LOINCCode= '72768-5'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Zol Met I','Zolpidem Metabolite I', NULL, NULL, NULL, NULL, NULL, NULL,'72768-5', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Zolpidem' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Zol Met I' AND LOINCCode= '72768-5' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'ZOLP' AND LOINCCode= '53787-8'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'ZOLP','Zolpidem (Ambien)', NULL, NULL, NULL, NULL, NULL, NULL,'53787-8', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Zolpidem' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='ZOLP' AND LOINCCode= '53787-8' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1  FROM HealthDataAttributes  WHERE Name= 'Zolpidem' AND LOINCCode= '72770-1'  AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT INTO HealthDataAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category, DataType, Name, [Description], Units, NumberOfParameters, Formula, NumbersAfterDecimal, DropDownCategory, IsSingleLineTextBox, LOINCCode, AlternativeName1, AlternativeName2, AlternativeName3, AlternativeName4, AlternativeName5, AlternativeName6)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),8229, 8084, 'Zolpidem','Zolpidem', NULL, NULL, NULL, NULL, NULL, NULL,'72770-1', NULL, NULL, NULL, NULL, NULL, NULL)  
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Zolpidem' AND ISNULL(RecordDeleted, 'N') = 'N')

	SET @HealthDataAttributeId = (SELECT max(HealthDataAttributeId)  FROM HealthDataAttributes  WHERE Name ='Zolpidem' AND LOINCCode= '72770-1' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataSubTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataAttributeId =@HealthDataAttributeId)
	BEGIN
		INSERT INTO HealthDataSubTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataAttributeId, DisplayInFlowSheet, OrderInFlowSheet, IsSingleLineDisplay)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataAttributeId,'Y', 1, 'N')
	 END

	IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='XOrderFrequency' and ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInCareManagement)
		VALUES('XOrderFrequency','XOrderFrequency','Y','Y','Y','Y',NULL,'Y','N','Y') 
	END

	IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='XOrderFrequency' and CodeName='Once' and ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
		VALUES('XOrderFrequency','Once','Once','Once value for Order frequency','Y','Y',1,NULL,NULL,NULL,NULL,NULL) 
	END
	
	SELECT top 1 @FrequencyId= GlobalCodeId FROM GlobalCodes WHERE Category='XOrderFrequency' and CodeName='Once' and ISNULL(RecordDeleted,'N')='N'
	IF NOT EXISTS (SELECT 1 FROM OrderTemplateFrequencies WHERE [FrequencyId] = @FrequencyId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
	   INSERT INTO [OrderTemplateFrequencies] ([CreatedBy],[CreatedDate],[ModifiedBy],
				[ModifiedDate],[RecordDeleted],[DeletedDate],[DeletedBy],[TimesPerDay],[DispenseTime1],[DispenseTime2],
				[DispenseTime3],[DispenseTime4],[DispenseTime5],[DispenseTime6],[FrequencyId],[IsPRN],[DispenseTime7],
				[DispenseTime8],[RxFrequencyId])
		VALUES(@UserCode,GETDATE(),@UserCode,GETDATE(),NULL,NULL,NULL,
		1,NULL,NULL,NULL,NULL,NULL,NULL,@FrequencyId,'N',NULL,NULL,4861) 
		SET @OrderTemplateFrequencyId=(SELECT TOP 1 [OrderTemplateFrequencyId] FROM OrderTemplateFrequencies WHERE [FrequencyId] = @FrequencyId AND ISNULL(RecordDeleted, 'N') = 'N')
	END

	DECLARE @HealthDataTemplateId INT,  @OrderSetId INT, @FrequencyOrderId INT, @OrderId INT, @OrderCode nvarchar(510),
		 @OrderDesc nvarchar(510)

	IF NOT EXISTS (SELECT 1 FROM OrderSets WHERE DisplayName = 'ADHD' AND ISNULL(RecordDeleted, 'N') = 'N')
    BEGIN
        INSERT  INTO OrderSets (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  DisplayName,Active)
        VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'ADHD', 'Y')
    END

	SET @OrderSetId =(SELECT TOP 1 OrderSetId FROM OrderSets WHERE DisplayName = 'ADHD' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Synthetic Cannabinoids' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Synthetic Cannabinoids','Y',1,'Y',null,'00162LDTD')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Synthetic Cannabinoids' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Synthetic Cannabinoids', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Synthetic Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Synthetic Cathinones' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Synthetic Cathinones','Y',1,'Y',null,'00163')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Synthetic Cathinones' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Synthetic Cathinones', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Synthetic Cathinones' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'QMP' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'QMP','Y',1,'Y',null,'00168U')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='QMP' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'QMP' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'QMP', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='QMP' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'QMP-SVT' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'QMP-SVT','Y',1,'Y',null,'00168U-SVT')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='QMP-SVT' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'QMP-SVT', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='QMP-SVT' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Methylphenidate' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Methylphenidate','Y',1,'Y',null,'00180')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Methylphenidate' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Methylphenidate' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Methylphenidate' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Methylphenidate', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Methylphenidate' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Ethyl Glucuronide' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Ethyl Glucuronide','Y',1,'Y',null,'00181')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Ethyl Glucuronide' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Ethyl Glucuronide' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Ethyl Glucuronide' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Ethyl Glucuronide', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Ethyl Glucuronide' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Amphetamines' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Amphetamines','Y',1,'Y',null,'00184LDTD')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Amphetamines' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Amphetamines', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Amphetamines_00184LDTDi' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Amphetamines_00184LDTDi','Y',1,'Y',null,'00184LDTDi')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Amphetamines_00184LDTDi' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Amphetamines' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Amphetamines_00184LDTDi' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Amphetamines_00184LDTDi', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Amphetamines_00184LDTDi' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'SNRI Profile' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'SNRI Profile','Y',1,'Y',null,'00186')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='SNRI Profile' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='SNRI Profile' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'SNRI Profile' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'SNRI Profile', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='SNRI Profile' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'QMP Plus D/L' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'QMP Plus D/L','Y',1,'Y',null,'00197iU')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='QMP Plus D/L' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'QMP Plus D/L', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='QMP Plus D/L' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'QMP Plus' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'QMP Plus','Y',1,'Y',null,'00197U')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='QMP Plus' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'QMP Plus', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='QMP Plus' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'PainComp All Tests Requested' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'PainComp All Tests Requested','Y',1,'Y',null,'00199U')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='PainComp All Tests Requested' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'PainComp All Tests Requested', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='PainComp All Tests Requested' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Cyclobenzaprine' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Cyclobenzaprine','Y',1,'Y',null,'01220U')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Cyclobenzaprine' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cyclobenzaprine' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Cyclobenzaprine' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Cyclobenzaprine', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Cyclobenzaprine' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Dextromethorphan' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Dextromethorphan','Y',1,'Y',null,'01240')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Dextromethorphan' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Dextromethorphan' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Dextromethorphan' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Dextromethorphan', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Dextromethorphan' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Mirtazapine' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Mirtazapine','Y',1,'Y',null,'01630U')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Mirtazapine' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Mirtazapine' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Mirtazapine' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Mirtazapine', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Mirtazapine' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Trazodone' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Trazodone','Y',1,'Y',null,'02127')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Trazodone' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Trazodone' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Trazodone' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Trazodone', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Trazodone' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Zolpidem' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Zolpidem','Y',1,'Y',null,'02210')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Zolpidem' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Zolpidem' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Zolpidem' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Zolpidem', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Zolpidem' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Barbiturates' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Barbiturates','Y',1,'Y',null,'04420')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Barbiturates' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Barbiturates' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Barbiturates' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Barbiturates', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Barbiturates' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Cannabinoids' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Cannabinoids','Y',1,'Y',null,'04440')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Cannabinoids' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Cannabinoids', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Cannabinoids' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Cocaine' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Cocaine','Y',1,'Y',null,'04450')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Cocaine' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cocaine' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Cocaine' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Cocaine', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Cocaine' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Tapentadol' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Tapentadol','Y',1,'Y',null,'04465')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Tapentadol' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tapentadol' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Tapentadol' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Tapentadol', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Tapentadol' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Tricyclic Antidepressants' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Tricyclic Antidepressants','Y',1,'Y',null,'04490')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Tricyclic Antidepressants' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Tricyclic Antidepressants', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Tricyclic Antidepressants' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Buprenorphine' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Buprenorphine','Y',1,'Y',null,'04496')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Buprenorphine' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Buprenorphine' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Buprenorphine' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Buprenorphine', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Buprenorphine' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Cotinine' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Cotinine','Y',1,'Y',null,'04497')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Cotinine' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Cotinine' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Cotinine' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Cotinine', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Cotinine' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Compliance, NP (Urine)' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Compliance, NP (Urine)','Y',1,'Y',null,'30011Nu')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Compliance, NP (Urine)' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Compliance, NP (Urine)', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Compliance, NP (Urine)' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END

	IF NOT EXISTS(SELECT 1 FROM HealthDataTemplates WHERE TemplateName= 'Compliance, Marinol DLY' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO HealthDataTemplates(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TemplateName,
										Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode) 
			  VALUES     (@UserCode, GETDATE(),@UserCode, GETDATE(),'Compliance, Marinol DLY','Y',1,'Y',null,'31520Du')
			  SET @HealthDataTemplateId=(SELECT MAX(HealthDataTemplateId) FROM   HealthDataTemplates)                  
	END
	ELSE
	BEGIN
		SET @HealthDataTemplateId=(SELECT TOP 1 HealthDataTemplateId FROM HealthDataTemplates WHERE TemplateName='Compliance, Marinol DLY' AND ISNULL(RecordDeleted,'N')='N')
	END

	SET @HealthDataSubTemplateId =  (SELECT max(HealthDataSubTemplateId) FROM HealthDataSubTemplates WHERE Name ='Compliance, Marinol DLY' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1  FROM HealthDataTemplateAttributes  WHERE HealthDataSubTemplateId =@HealthDataSubTemplateId AND HealthDataTemplateId =@HealthDataTemplateId)
	BEGIN
		INSERT INTO HealthDataTemplateAttributes (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,HealthDataSubTemplateId, HealthDataTemplateId, HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox)
		VALUES (@UserCode, GETDATE(), @UserCode, GETDATE(),@HealthDataSubTemplateId,@HealthDataTemplateId,0, 1, 'N')
	 END

	IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderName = 'Compliance, Marinol DLY' AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO Orders (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,  OrderName, OrderType, CanBeCompleted, CanBePended, HasRationale, HasComments, Active, MedicationNameId, ProcedureCodeId, ShowOnWhiteBoard, NeedsDiagnosis, LabId, AlternateOrderName1, AlternateOrderName2, DualSignRequired, OrderLevelRequired, LegalStatusRequired, IsSelfAdministered, AdhocOrder)
		VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), 'Compliance, Marinol DLY', 6481, 'N', 'N', 'N', 'N', 'Y', NULL, NULL, 'N', 'Y', @HealthDataTemplateId, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
	END

	SET @OrderId=(SELECT TOP 1 OrderId FROM Orders WHERE OrderName='Compliance, Marinol DLY' AND ISNULL(RecordDeleted, 'N') = 'N')

	IF NOT EXISTS (SELECT 1 FROM OrderFrequencies WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderFrequencies (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, OrderTemplateFrequencyId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, @OrderTemplateFrequencyId, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderPriorities WHERE OrderId = @OrderId AND PriorityId=8510 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderPriorities (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, PriorityId, IsDefault)
		VALUES  (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8510, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSchedules WHERE OrderId = @OrderId and ScheduleId=8512 AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSchedules (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, OrderId, ScheduleId, IsDefault)
			VALUES             (@UserCode, GETDATE(), @UserCode, GETDATE(), @OrderId, 8512, 'Y')
	END

	IF NOT EXISTS (SELECT 1 FROM OrderSetAttributes WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
		INSERT  INTO OrderSetAttributes (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,OrderSetId, OrderId, DisplayOrder)
		VALUES                      (@UserCode, GETDATE(), @UserCode, GETDATE(),@OrderSetId, @OrderId,1)
	END
