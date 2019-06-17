--Added globalcodes : feet, knees, ankles, hands, shoulders in   Category = 'PAINLOCATION' for flowsheet

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'PAINLOCATION'
				AND CodeName = 'Feet'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'PAINLOCATION' , -- Category - char(20)
          'Feet' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          7-- SortOrder - int
        )

END

IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'PAINLOCATION'
				AND CodeName = 'Knees'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'PAINLOCATION' , -- Category - char(20)
          'Knees' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          7 -- SortOrder - int
        )

END
IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'PAINLOCATION'
				AND CodeName = 'Ankles'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'PAINLOCATION' , -- Category - char(20)
          'Ankles' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
           7-- SortOrder - int
        )

END
IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'PAINLOCATION'
				AND CodeName = 'Hands'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'PAINLOCATION' , -- Category - char(20)
          'Hands' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          7 -- SortOrder - int
        )

END
IF NOT EXISTS (
				SELECT 1
				FROM dbo.GlobalCodes
				WHERE Category = 'PAINLOCATION'
				AND CodeName = 'Shoulders'
				)
BEGIN

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder
        )
VALUES  ( 'PAINLOCATION' , -- Category - char(20)
          'Shoulders' , -- CodeName - varchar(250)
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          7 -- SortOrder - int
        )

END
 