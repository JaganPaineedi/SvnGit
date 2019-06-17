---------------------------------------------------------
--Author : K. Soujanya
--Date   : 11/11/2018
--Purpose: To insert screen permission controls for Claim Line Under Review.Ref :#591 SWMBH - Enhancements.
---------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM screenpermissioncontrols
		WHERE screenid = 1010
			AND ControlName = 'CheckBox_ClaimLines_ClaimLineUnderReview'
		)
BEGIN
	INSERT INTO screenpermissioncontrols (
		screenid
		,controlname
		,displayas
		,active
		)
	VALUES (
		1010
		,'CheckBox_ClaimLines_ClaimLineUnderReview'
		,'Claim Line Under Review'
		,'Y'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM screenpermissioncontrols
		WHERE screenid = 1010
			AND ControlName = 'CheckBox_ClaimLines_FinalStatus'
		)
BEGIN
	INSERT INTO screenpermissioncontrols (
		screenid
		,controlname
		,displayas
		,active
		)
	VALUES (
		1010
		,'CheckBox_ClaimLines_FinalStatus'
		,'Final Status'
		,'Y'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM screenpermissioncontrols
		WHERE screenid = 1010
			AND ControlName = 'ButtonClaimLineManualPend'
		)
BEGIN
	INSERT INTO screenpermissioncontrols (
		screenid
		,controlname
		,displayas
		,active
		)
	VALUES (
		1010
		,'ButtonClaimLineManualPend'
		,'Manual Pend'
		,'Y'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM screenpermissioncontrols
		WHERE screenid = 1001
			AND ControlName = 'ButtonClaimLineManualPend'
		)
BEGIN
	INSERT INTO screenpermissioncontrols (
		screenid
		,controlname
		,displayas
		,active
		)
	VALUES (
		1001
		,'ButtonClaimLineManualPend'
		,'Manual Pend'
		,'Y'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM screenpermissioncontrols
		WHERE screenid = 1001
			AND ControlName = 'ButtonClaimLineVoid'
		)
BEGIN
	INSERT INTO screenpermissioncontrols (
		screenid
		,controlname
		,displayas
		,active
		)
	VALUES (
		1001
		,'ButtonClaimLineVoid'
		,'Void'
		,'Y'
		)
END
