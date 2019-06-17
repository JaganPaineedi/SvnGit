DECLARE @PatientPortalRoleId INT

SELECT @PatientPortalRoleId = GlobalCodeId
FROM GlobalCodes
WHERE Category = 'STAFFROLE'
 AND CodeName = 'PATIENTPORTALUSER'
 AND ISNULL(RecordDeleted, 'N') = 'N'

IF EXISTS (
  SELECT 1
  FROM StaffRoles
  WHERE RoleId = @PatientPortalRoleId
  )
BEGIN
 DELETE StaffRoles
 FROM StaffRoles SR
 JOIN Staff AS S ON SR.StaffId = S.StaffId
 WHERE SR.RoleId = @PatientPortalRoleId
  AND ISNULL(S.NonStaffUser, 'N') = 'N'
  AND S.TempClientId IS NULL
END