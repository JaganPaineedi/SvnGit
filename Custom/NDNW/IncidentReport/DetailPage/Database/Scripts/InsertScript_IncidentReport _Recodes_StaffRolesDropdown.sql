-- To Get StaffRole Id below is the Query 
--SELECT *
--FROM GlobalCodes
--WHERE Category = 'STAFFROLE'
-- Admin
DECLARE @recodecategoryid INT

IF NOT EXISTS (
		SELECT CategoryCode
		FROM RecodeCategories
		WHERE CategoryCode = 'XAdministratorNotified'
		)
BEGIN
	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		)
	VALUES (
		'XAdministratorNotified'
		,'XAdministratorNotified'
		,'Role Id for Admin'
		,'RoleId'
		)

	SET @recodecategoryid = @@IDENTITY
END
ELSE
BEGIN
	SELECT TOP 1 @recodecategoryid = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryCode = 'XAdministratorNotified'
END
--INSERT INTO recodes (
--	IntegerCodeId
--	,CodeName
--	,recodecategoryid
--	)
--VALUES (
--	Admin  RoleId(Globalcode Id for Code name as Admin) Role Ids will display in All Administrator Dropdowns
--	,'Admin'
--	,@recodecategoryid
--	)
 --Supervisor
IF NOT EXISTS (
		SELECT CategoryCode
		FROM RecodeCategories
		WHERE CategoryCode = 'XSUPERVISORFLAGGED'
		)
BEGIN
	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		)
	VALUES (
		'XSUPERVISORFLAGGED'
		,'XSUPERVISORFLAGGED'
		,'Role Id for Supervisor'
		,'RoleId'
		)

	SET @recodecategoryid = @@IDENTITY
END
ELSE
BEGIN
	SELECT TOP 1 @recodecategoryid = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryCode = 'XSUPERVISORFLAGGED'
END

--INSERT INTO recodes (
--	IntegerCodeId
--	,CodeName
--	,recodecategoryid
--	)
--VALUES (
--	supervisor  RoleId(Globalcode Id for Code name as Supervisor) 
--	,'SUPERVISOR'
--	,@recodecategoryid
--	)
--Nurse
IF NOT EXISTS (
		SELECT CategoryCode
		FROM RecodeCategories
		WHERE CategoryCode = 'XNURSESTAFF'
		)
BEGIN
	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		)
	VALUES (
		'XNURSESTAFF'
		,'XNURSESTAFF'
		,'Staff Role Id for Nurse'
		,'StaffRoleId'
		)

	SET @recodecategoryid = @@IDENTITY
END
ELSE
BEGIN
	SELECT TOP 1 @recodecategoryid = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryCode = 'XNURSESTAFF'
END

--INSERT INTO recodes (
--	IntegerCodeId
--	,CodeName
--	,recodecategoryid
--	)
--VALUES (
--	Nurse Staff RoleId(Globalcode Id for Code name as Nurse) 
--	,'Nurse'
--	,@recodecategoryid
--	)
--Behaviroist
IF NOT EXISTS (
		SELECT CategoryCode
		FROM RecodeCategories
		WHERE CategoryCode = 'XBEHAVIORISTSTAFF'
		)
BEGIN
	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		)
	VALUES (
		'XBEHAVIORISTSTAFF'
		,'XBEHAVIORISTSTAFF'
		,'Staff Role Id for BEHAVIORIST'
		,'StaffRoleId'
		)

	SET @recodecategoryid = @@IDENTITY
END
ELSE
BEGIN
	SELECT TOP 1 @recodecategoryid = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryCode = 'XBEHAVIORISTSTAFF'
END

--INSERT INTO recodes (
--	IntegerCodeId
--	,CodeName
--	,recodecategoryid
--	)
--VALUES (
--	BEHAVIORIST Staff RoleId(Globalcode Id for Code name as BEHAVIORIST) 
--	,'Behaviorist'
--	,@recodecategoryid
--	)
--Incident Follow Up
IF NOT EXISTS (
		SELECT CategoryCode
		FROM RecodeCategories
		WHERE CategoryCode = 'XNOTIFIEDINJURY'
		)
BEGIN
	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		)
	VALUES (
		'XNOTIFIEDINJURY'
		,'XNOTIFIEDINJURY'
		,'Staff Role Id for INCIDENTFOLLOWUP'
		,'StaffRoleId'
		)

	SET @recodecategoryid = @@IDENTITY
END
ELSE
BEGIN
	SELECT TOP 1 @recodecategoryid = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryCode = 'XNOTIFIEDINJURY'
END
		--INSERT INTO recodes (
		--	IntegerCodeId
		--	,CodeName
		--	,recodecategoryid
		--	)
		--VALUES (
		--	INCIDENTFOLLOWUP Staff RoleId(Globalcode Id for Code name as INCIDENTFOLLOWUP) 
		--	,'IncidentFollowup'
		--	,@recodecategoryid
		--	)
		


