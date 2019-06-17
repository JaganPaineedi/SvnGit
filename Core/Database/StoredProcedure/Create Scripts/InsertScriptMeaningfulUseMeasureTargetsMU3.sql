-- MeaningfulUseMeasureTargets script for Stage3
-- why : Meaningful Use Stage3, Task	# ,   
--	Gautam		6th Oct 2017
IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8683
			AND MeasureSubType = 6266
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8683
		,6266
		,8768
		,60
		,'e-Prescribing'
		)
END

--IF NOT EXISTS (
--		SELECT *
--		FROM MeaningfulUseMeasureTargets
--		WHERE MeasureType = 8683
--			AND MeasureSubType = 6267
--			AND Stage = 8768
--			AND isnull(RecordDeleted, 'N') = 'N'
--		)
--BEGIN
--	INSERT INTO MeaningfulUseMeasureTargets (
--		MeasureType
--		,MeasureSubType
--		,Stage
--		,[Target]
--		,DisplayWidgetNameAs
--		)
--	VALUES (
--		8683
--		,6266
--		,8768
--		,60
--		,'e-Prescribing'
--		)
--END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8683
			AND MeasureSubType = 6266
			AND Stage = 9476
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8683
		,6266
		,9476
		,60
		,'e-Prescribing'
		)
END

--IF NOT EXISTS (
--		SELECT *
--		FROM MeaningfulUseMeasureTargets
--		WHERE MeasureType = 8683
--			AND MeasureSubType = 6267
--			AND Stage = 9476
--			AND isnull(RecordDeleted, 'N') = 'N'
--		)
--BEGIN
--	INSERT INTO MeaningfulUseMeasureTargets (
--		MeasureType
--		,MeasureSubType
--		,Stage
--		,[Target]
--		,DisplayWidgetNameAs
--		)
--	VALUES (
--		8683
--		,6266
--		,9476
--		,60
--		,'e-Prescribing'
--		)
--END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8683
			AND MeasureSubType = 6266
			AND Stage = 9477
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8683
		,6266
		,9477
		,60
		,'e-Prescribing'
		)
END

--IF NOT EXISTS (
--		SELECT *
--		FROM MeaningfulUseMeasureTargets
--		WHERE MeasureType = 8683
--			AND MeasureSubType = 6267
--			AND Stage = 9477
--			AND isnull(RecordDeleted, 'N') = 'N'
--		)
--BEGIN
--	INSERT INTO MeaningfulUseMeasureTargets (
--		MeasureType
--		,MeasureSubType
--		,Stage
--		,[Target]
--		,DisplayWidgetNameAs
--		)
--	VALUES (
--		8683
--		,6266
--		,9477
--		,60
--		,'e-Prescribing'
--		)
--END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8683
			AND MeasureSubType = 6266
			AND Stage = 9480
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8683
		,6266
		,9480
		,60
		,'e-Prescribing'
		)
END



IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8683
			AND MeasureSubType = 6266
			AND Stage = 9481
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8683
		,6266
		,9481
		,60
		,'e-Prescribing'
		)
END


IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8680
			AND MeasureSubType = 6177
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8680
		,6177
		,8768
		,60
		,'CPOE'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8680
			AND MeasureSubType = 6178
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8680
		,6178
		,8768
		,60
		,'CPOE'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8680
			AND MeasureSubType = 6179
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8680
		,6179
		,8768
		,60
		,'CPOE'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8698
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8698
		,NULL
		,8768
		,35
		,'Patient Education'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8698
			AND Stage = 9476
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8698
		,NULL
		,9476
		,10
		,'Patient Education'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8698
			AND Stage = 9477
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8698
		,NULL
		,9477
		,10
		,'Patient Education'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8698
			AND Stage = 9480
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8698
		,NULL
		,9480
		,10
		,'Patient Education'
		)
END


IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8698
			AND Stage = 9481
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8698
		,NULL
		,9481
		,10
		,'Patient Education'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8697
			AND MeasureSubType = 6261
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8697
		,6261
		,8768
		,80
		,'Patient Portal'
		)
END


IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8697
			AND MeasureSubType = 6261
			AND Stage = 9480
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8697
		,6261
		,9480
		,80
		,'Patient Portal'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8697
			AND MeasureSubType = 6212
			AND Stage = 9480
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8697
		,6212
		,9480
		,35
		,'Patient Portal'
		)
END


IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8697
			AND MeasureSubType = 6261
			AND Stage = 9481
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8697
		,6261
		,9481
		,80
		,'Patient Portal'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8697
			AND MeasureSubType = 6212
			AND Stage = 9481
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8697
		,6212
		,9481
		,35
		,'Patient Portal'
		)
END

UPDATE MeaningfulUseMeasureTargets
SET [Target]=50
WHERE Stage=9373 and MeasureSubType=6261 and MeasureType=8697


--IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8697  and MeasureSubType=6212 and 
--					Stage=8768 and isnull(RecordDeleted,'N')='N') 
--  BEGIN 
--      INSERT INTO MeaningfulUseMeasureTargets 
--                  (MeasureType,
--					MeasureSubType ,
--					Stage,
--					[Target],
--					DisplayWidgetNameAs) 
--      VALUES     (8697,6212,8768,35,'Patient Portal') 
--  END 
IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8697
			AND MeasureSubType = 6261
			AND Stage = 9476
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8697
		,6261
		,9476
		,80
		,'Patient Portal'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8697
			AND MeasureSubType = 6212
			AND Stage = 9476
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8697
		,6212
		,9476
		,35
		,'Patient Portal'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8697
			AND MeasureSubType = 6261
			AND Stage = 9477
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8697
		,6261
		,9477
		,80
		,'Patient Portal'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8697
			AND MeasureSubType = 6212
			AND Stage = 9477
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8697
		,6212
		,9477
		,35
		,'Patient Portal'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8703
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8703
		,NULL
		,8768
		,5
		,'Secure Messages'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8703
			AND Stage = 9476
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8703
		,NULL
		,9476
		,5
		,'Secure Messages'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8703
			AND Stage = 9477
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8703
		,NULL
		,9477
		,5
		,'Secure Messages'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8703
			AND Stage = 9481
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8703
		,NULL
		,9481
		,5
		,'Secure Messages'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8703
			AND Stage = 9480
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8703
		,NULL
		,9480
		,5
		,'Secure Messages'
		)
END


IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8699
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8699
		,NULL
		,8768
		,50
		,'Reconciliation'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8699
			AND Stage = 9476
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8699
		,NULL
		,9476
		,50
		,'Reconciliation'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8699
			AND Stage = 9477
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8699
		,NULL
		,9477
		,50
		,'Reconciliation'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8699
			AND Stage = 9480
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8699
		,NULL
		,9480
		,50
		,'Reconciliation'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8699
			AND Stage = 9481
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8699
		,NULL
		,9481
		,50
		,'Reconciliation'
		)
END

---
UPDATE MeaningfulUseMeasureTargets
SET DisplayWidgetNameAs = 'Reconciliation'
WHERE MeasureType = 8699
	AND Stage IN (
		8766
		,8767
		,9373
		)

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8700
			AND MeasureSubType = 6213
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8700
		,6213
		,8768
		,50
		,'Health Information Exchange'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8700
			AND MeasureSubType = 6213
			AND Stage = 9476
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8700
		,6213
		,9476
		,50
		,'Health Information Exchange'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8700
			AND MeasureSubType = 6213
			AND Stage = 9477
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8700
		,6213
		,9477
		,50
		,'Health Information Exchange'
		)
END


IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8700
			AND MeasureSubType = 6213
			AND Stage = 9480
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8700
		,6213
		,9480
		,50
		,'Health Information Exchange'
		)
END



IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8700
			AND MeasureSubType = 6213
			AND Stage = 9481
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8700
		,6213
		,9481
		,50
		,'Health Information Exchange'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8710
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8710
		,NULL
		,8768
		,50
		,'View, Download, Transmit'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8710
			AND Stage = 9476
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8710
		,NULL
		,9476
		,1
		,'View, Download, Transmit'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8710
			AND Stage = 9477
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8710
		,NULL
		,9477
		,1
		,'View, Download, Transmit'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8710
			AND Stage = 9481
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8710
		,NULL
		,9481
		,1
		,'View, Download, Transmit'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8710
			AND Stage = 9480
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8710
		,NULL
		,9480
		,1
		,'View, Download, Transmit'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 9478
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		9478
		,NULL
		,8768
		,5
		,'Patient Generated Health Data'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 9478
			AND Stage = 9476
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		9478
		,NULL
		,9476
		,5
		,'Patient Generated Health Data'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 9478
			AND Stage = 9477
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		9478
		,NULL
		,9477
		,5
		,'Patient Generated Health Data'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 9478
			AND Stage = 9481
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		9478
		,NULL
		,9481
		,5
		,'Patient Generated Health Data'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 9478
			AND Stage = 9480
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		9478
		,NULL
		,9480
		,5
		,'Patient Generated Health Data'
		)
END


IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 9479
			AND Stage = 8768
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		9479
		,NULL
		,8768
		,40
		,'Receive and Incorporate'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 9479
			AND Stage = 9476
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		9479
		,NULL
		,9476
		,40
		,'Receive and Incorporate'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 9479
			AND Stage = 9477
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		9479
		,NULL
		,9477
		,40
		,'Receive and Incorporate'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 9479
			AND Stage = 9481
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		9479
		,NULL
		,9481
		,40
		,'Receive and Incorporate'
		)
END


IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 9479
			AND Stage = 9480
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		9479
		,NULL
		,9480
		,40
		,'Receive and Incorporate'
		)
END


IF NOT EXISTS (
		SELECT *
		FROM MeaningfulUseMeasureTargets
		WHERE MeasureType = 8710
			AND Stage = 9373
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO MeaningfulUseMeasureTargets (
		MeasureType
		,MeasureSubType
		,Stage
		,[Target]
		,DisplayWidgetNameAs
		)
	VALUES (
		8710
		,NULL
		,9373
		,5
		,'View, Download, Transmit'
		)
END
