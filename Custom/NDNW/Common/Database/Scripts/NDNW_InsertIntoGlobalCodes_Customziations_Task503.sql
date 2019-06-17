BEGIN TRAN

IF NOT EXISTS (
				SELECT 1 
				FROM dbo.GlobalCodes
				WHERE category = 'XINQUIRYSTATUS      '
				AND CodeName = 'Waitlist'
			)

BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Code ,
          Active ,
          CannotModifyNameOrDelete 
        )
VALUES  ( 'XINQUIRYSTATUS      ' , -- Category - char(20)
          'Waitlist' , -- CodeName - varchar(250)
          'WAITLIST' , -- Code - varchar(100)
          'Y' , -- Active - type_Active
          'N' 
        )
        
END

IF NOT EXISTS (
				SELECT 1 
				FROM dbo.GlobalCodes
				WHERE category = 'XINQUIRYSTATUS      '
				AND CodeName = 'No Show'
			)

BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Code ,
          Active ,
          CannotModifyNameOrDelete 
        )
VALUES  ( 'XINQUIRYSTATUS      ' , -- Category - char(20)
          'No Show' , -- CodeName - varchar(250)
          'NOSHOW' , -- Code - varchar(100)
          'Y' , -- Active - type_Active
          'N' 
        )
        
END

IF NOT EXISTS (
				SELECT 1 
				FROM dbo.GlobalCodes
				WHERE category = 'XINQUIRYSTATUS      '
				AND CodeName = 'Referred Out'
			)

BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Code ,
          Active ,
          CannotModifyNameOrDelete 
        )
VALUES  ( 'XINQUIRYSTATUS      ' , -- Category - char(20)
          'Referred Out' , -- CodeName - varchar(250)
          'REFERREDOUT' , -- Code - varchar(100)
          'Y' , -- Active - type_Active
          'N' 
        )
        
END

IF NOT EXISTS (
				SELECT 1 
				FROM dbo.GlobalCodes
				WHERE category = 'XINQUIRYSTATUS      '
				AND CodeName = 'Denied Services'
			)

BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Code ,
          Active ,
          CannotModifyNameOrDelete 
        )
VALUES  ( 'XINQUIRYSTATUS      ' , -- Category - char(20)
          'Denied Services' , -- CodeName - varchar(250)
          'DENIEDSERVICES' , -- Code - varchar(100)
          'Y' , -- Active - type_Active
          'N' 
        )
        
END

IF NOT EXISTS (
				SELECT 1 
				FROM dbo.GlobalCodes
				WHERE category = 'XINQUIRYSTATUS      '
				AND CodeName = 'Pending Further Review'
			)

BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Code ,
          Active ,
          CannotModifyNameOrDelete 
        )
VALUES  ( 'XINQUIRYSTATUS      ' , -- Category - char(20)
          'Pending Further Review' , -- CodeName - varchar(250)
          'PENDINGFURTHERREVIEW' , -- Code - varchar(100)
          'Y' , -- Active - type_Active
          'N' 
        )
        
END

IF NOT EXISTS (
				SELECT 1 
				FROM dbo.GlobalCodes
				WHERE category = 'XINQUIRYSTATUS      '
				AND CodeName = 'Admitted'
			)

BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Code ,
          Active ,
          CannotModifyNameOrDelete 
        )
VALUES  ( 'XINQUIRYSTATUS      ' , -- Category - char(20)
          'Admitted' , -- CodeName - varchar(250)
          'ADMITTED' , -- Code - varchar(100)
          'Y' , -- Active - type_Active
          'N' 
        )
        
END

COMMIT TRAN