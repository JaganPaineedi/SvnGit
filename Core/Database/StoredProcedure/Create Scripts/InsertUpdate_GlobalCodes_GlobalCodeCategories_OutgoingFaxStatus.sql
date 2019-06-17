
IF NOT EXISTS (
  SELECT *
  FROM globalcodes
  WHERE GlobalCodeId = 6864
  )
BEGIN
 SET IDENTITY_INSERT dbo.GlobalCodes ON

 INSERT INTO globalcodes (
  GlobalCodeId
  ,Category
  ,CodeName
  ,Code
  ,Description
  ,Active
  ,CannotModifyNameOrDelete
  )
 VALUES (
  6864
  ,'OUTGOINGFAXSTATUS'
  ,'Success'
  ,'Success'
  ,'Success'
  ,'Y'
  ,'N'
  )
 
   SET IDENTITY_INSERT dbo.GlobalCodes OFF
END

IF  EXISTS (
  SELECT *
  FROM globalcodes
  WHERE GlobalCodeId = 6861 AND Category='OUTGOINGFAXSTATUS'   
  )

BEGIN 
UPDATE dbo.GlobalCodes SET CodeName='Queued',Code='Queued',Description='Queued' WHERE GlobalCodeId=6861

END

IF  EXISTS (
  SELECT *
  FROM globalcodes
  WHERE GlobalCodeId = 6862 AND Category='OUTGOINGFAXSTATUS'   
  )

BEGIN 
UPDATE dbo.GlobalCodes SET CodeName='Sent',Code='Sent',Description='Sent' WHERE GlobalCodeId=6862

END


IF  EXISTS (
  SELECT *
  FROM globalcodes
  WHERE GlobalCodeId = 6863 AND Category='OUTGOINGFAXSTATUS'   
  )

BEGIN 
UPDATE dbo.GlobalCodes SET CodeName='Failed',Code='Failed',Description='Failed' WHERE GlobalCodeId=6863

END