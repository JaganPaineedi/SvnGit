BEGIN TRAN

--SELECT * FROM globalcodes WHERE category = 'maritalstatus'



IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'APPOINTMENTTYPE     '
				AND CodeName = 'Public Information'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'APPOINTMENTTYPE     ' , -- Category - char(20)
          'Public Information' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          1 -- SortOrder - int
        )

END

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'APPOINTMENTTYPE     '
				AND CodeName = 'Community Education'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'APPOINTMENTTYPE     ' , -- Category - char(20)
          'Community Education' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          1 -- SortOrder - int
        )

END

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'APPOINTMENTTYPE     '
				AND CodeName = 'Parent/Family Education'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'APPOINTMENTTYPE     ' , -- Category - char(20)
          'Parent/Family Education' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          1 -- SortOrder - int
        )

END

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'APPOINTMENTTYPE     '
				AND CodeName = 'Alternative Activities'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'APPOINTMENTTYPE     ' , -- Category - char(20)
          'Alternative Activities' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          1 -- SortOrder - int
        )

END

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'APPOINTMENTTYPE     '
				AND CodeName = 'Community Mobilization'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'APPOINTMENTTYPE     ' , -- Category - char(20)
          'Community Mobilization' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          1 -- SortOrder - int
        )

END

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'APPOINTMENTTYPE     '
				AND CodeName = 'Life Skills Development'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'APPOINTMENTTYPE     ' , -- Category - char(20)
          'Life Skills Development' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          1 -- SortOrder - int
        )

END

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'APPOINTMENTTYPE     '
				AND CodeName = 'Prevention Support Activities'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'APPOINTMENTTYPE     ' , -- Category - char(20)
          'Prevention Support Activities' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          1 -- SortOrder - int
        )

END

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'APPOINTMENTTYPE     '
				AND CodeName = 'Community Based Outreach'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'APPOINTMENTTYPE     ' , -- Category - char(20)
          'Community Based Outreach' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          1 -- SortOrder - int
        )

END

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'APPOINTMENTTYPE     '
				AND CodeName = 'Services Integration'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'APPOINTMENTTYPE     ' , -- Category - char(20)
          'Services Integration' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          1 -- SortOrder - int
        )

END

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'MARITALSTATUS       '
				AND CodeName = 'Living as Married'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'MARITALSTATUS       ' , -- Category - char(20)
          'Living as Married' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          7 -- SortOrder - int
        )

END

COMMIT TRAN
