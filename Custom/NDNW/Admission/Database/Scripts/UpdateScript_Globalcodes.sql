IF EXISTS (Select 1 FROM GlobalCodes where GlobalCodeId=1)
BEGIN
UPDATE GlobalCodes SET CodeName = 'Requested' where GlobalCodeId=1
END
