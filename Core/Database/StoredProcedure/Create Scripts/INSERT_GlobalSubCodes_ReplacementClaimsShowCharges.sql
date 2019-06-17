DELETE  FROM dbo.GlobalSubCodes
WHERE   GlobalSubCodeId IN ( 589, 590, 591, 592, 593 ) 

SET IDENTITY_INSERT dbo.GlobalSubCodes ON 

INSERT  INTO dbo.GlobalSubCodes
        ( GlobalSubCodeId
        , GlobalCodeId
        , SubCodeName
        , Code
        , Description
        , Active
        , CannotModifyNameOrDelete
        , SortOrder
        , RowIdentifier
        , CreatedBy
        , CreatedDate
        , ModifiedBy
        , ModifiedDate
        )
        SELECT valtable.GlobalSubCodeId
			  , valtable.GlobalCodeId   -- GlobalCodeId - int
              , valtable.Codename-- SubCodeName - varchar(250)
              , valtable.Codename-- Code - varchar(100)
              , NULL-- Description - type_Comment
              , 'Y'-- Active - type_Active
              , 'Y'-- CannotModifyNameOrDelete - type_YOrN
              , valtable.SortOrder-- SortOrder - int
              , NEWID()-- RowIdentifier - type_GUID
              , 'dknewtson'-- CreatedBy - type_CurrentUser
              , GETDATE()-- CreatedDate - type_CurrentDatetime
              , 'dknewtson'-- ModifiedBy - type_CurrentUser
              , GETDATE()-- ModifiedDate - type_CurrentDatetime
        FROM    ( VALUES ( 589, 6255, 'Show replacement charges', 'Y', 'N', 11                            )
, ( 590, 6255, 'Show unbilled and replacement charges', 'Y', 'N', 12                )
, ( 591, 6255, 'Show rebill and replacement charges', 'Y', 'N', 13                    )
, ( 592, 6255, 'show unbilled, rebill, and replacement charges', 'Y', 'N', 14        )
, ( 593, 6255, 'show unbilled, rebill, replacement and void charges.', 'Y', 'N', 15) ) AS valtable ( GlobalSubCodeId, GlobalCodeId, Codename, Active, CannotModifyNameOrDelete, SortOrder ) 

SET IDENTITY_INSERT dbo.GlobalSubCodes off