IF NOT EXISTS (SELECT
    *
  FROM [MobileOrigins]
  WHERE [Name] = 'KPIReporting'
  AND Active = 'Y')
BEGIN
  INSERT INTO MobileOrigins (OriginSecret, Name, ApplicationType, Active, RefreshTokenLifeTime, AllowedOrigin,
  RefreshTokenLifeTimeType)
    VALUES ('TEST', 'KPIReporting', 0, 'Y', 30, 'https://blrqasrv.smartcarenet.com/AuroraAPI', (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'REFRESHTOKENTIMETYPE' AND Code = 'TOKENLIFETIMEMINUTE'))
END
ELSE
BEGIN
  DECLARE @RefreshTokenLifeTimeType int
  SELECT
    @RefreshTokenLifeTimeType = GlobalCodeId
  FROM GlobalCodes
  WHERE Category = 'REFRESHTOKENTIMETYPE'
  AND Code = 'TOKENLIFETIMEMINUTE'
  UPDATE [MobileOrigins]
  SET [OriginSecret] = 'TEST',
      [ApplicationType] = 0,
      [Active] = 'Y',
      [RefreshTokenLifeTime] = 30,
      [AllowedOrigin] = 'https://blrqasrv.smartcarenet.com/AuroraAPI',
      [RefreshTokenLifeTimeType] = @RefreshTokenLifeTimeType
  WHERE [MobileOrigins].[Name] = 'KPIReporting'
END