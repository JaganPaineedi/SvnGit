IF NOT EXISTS (
		SELECT *
		FROM FormItems
		WHERE FormSectionId = 390 and FormSectionGroupId=999 AND SortOrder=37
		)

BEGIN
	SET IDENTITY_INSERT [SCREENS] ON

INSERT INTO dbo.FormItems 
        ( CreatedBy ,
          CreatedDate ,
          ModifiedBy ,
          ModifiedDate ,
          RecordDeleted ,
          DeletedDate ,
          DeletedBy ,
          FormSectionId ,
          FormSectionGroupId ,
          ItemType ,
          ItemLabel ,
          SortOrder ,
          Active ,
          GlobalCodeCategory ,
          ItemColumnName ,
          ItemRequiresComment ,
          ItemCommentColumnName ,
          ItemWidth ,
          MaximumLength ,
          DropdownType ,
          SharedTableName ,
          StoredProcedureName ,
          ValueField ,
          TextField ,
          MultilineEditFieldHeight ,
          EachRadioButtonOnNewLine ,
          InformationIcon ,
          InformationIconStoredProcedure ,
          ExcludeFromPencilIcon ,
          HasStoredProcedureParameter
        )
VALUES  ( 'shstest' , -- CreatedBy - type_CurrentUser
          '2013-09-08' , -- CreatedDate - type_CurrentDatetime
          'shstest' , -- ModifiedBy - type_CurrentUser
          '2013-09-08' , -- ModifiedDate - type_CurrentDatetime
          NULL , -- RecordDeleted - type_YOrN
          NULL , -- DeletedDate - datetime
          NULL , -- DeletedBy - type_UserId
          390 , -- FormSectionId - int
          999 , -- FormSectionGroupId - int
          5374 , -- ItemType - type_GlobalCode
          'Mobile' , -- ItemLabel - varchar(1000)
          37 , -- SortOrder - int
          'Y' , -- Active - type_Active
          NULL , -- GlobalCodeCategory - char(20)
          NULL , -- ItemColumnName - varchar(100)
          'N' , -- ItemRequiresComment - type_YOrN
          '' , -- ItemCommentColumnName - varchar(100)
          0 , -- ItemWidth - int
          0 , -- MaximumLength - int
          NULL , -- DropdownType - char(1)
          '' , -- SharedTableName - varchar(100)
          '' , -- StoredProcedureName - varchar(100)
          '' , -- ValueField - varchar(100)
          '' , -- TextField - varchar(100)
          0 , -- MultilineEditFieldHeight - int
          NULL , -- EachRadioButtonOnNewLine - type_YOrN
          NULL , -- InformationIcon - type_YOrN
          '' , -- InformationIconStoredProcedure - varchar(100)
          NULL , -- ExcludeFromPencilIcon - type_YOrN
          NULL  -- HasStoredProcedureParameter - type_YOrN
        )
SET IDENTITY_INSERT [SCREENS] OFF
END
GO


IF NOT EXISTS (
		SELECT *
		FROM FormItems
		WHERE FormSectionId = 390 and FormSectionGroupId=999 AND SortOrder=38
		)
BEGIN
	SET IDENTITY_INSERT [SCREENS] ON

		INSERT INTO dbo.FormItems 
        ( CreatedBy ,
          CreatedDate ,
          ModifiedBy ,
          ModifiedDate ,
          RecordDeleted ,
          DeletedDate ,
          DeletedBy ,
          FormSectionId ,
          FormSectionGroupId ,
          ItemType ,
          ItemLabel ,
          SortOrder ,
          Active ,
          GlobalCodeCategory ,
          ItemColumnName ,
          ItemRequiresComment ,
          ItemCommentColumnName ,
          ItemWidth ,
          MaximumLength ,
          DropdownType ,
          SharedTableName ,
          StoredProcedureName ,
          ValueField ,
          TextField ,
          MultilineEditFieldHeight ,
          EachRadioButtonOnNewLine ,
          InformationIcon ,
          InformationIconStoredProcedure ,
          ExcludeFromPencilIcon ,
          HasStoredProcedureParameter
        )
VALUES  ( 'shstest' , -- CreatedBy - type_CurrentUser
          '2013-09-08' , -- CreatedDate - type_CurrentDatetime
          'shstest' , -- ModifiedBy - type_CurrentUser
          '2013-09-08' , -- ModifiedDate - type_CurrentDatetime
          NULL , -- RecordDeleted - type_YOrN
          NULL , -- DeletedDate - datetime
          NULL , -- DeletedBy - type_UserId
          390 , -- FormSectionId - int
          999 , -- FormSectionGroupId - int
          5365 , -- ItemType - type_GlobalCode
          '<span style="margin-left:16px"></span>' , -- ItemLabel - varchar(1000)
          38 , -- SortOrder - int
          'Y' , -- Active - type_Active
          'RADIOYN' , -- GlobalCodeCategory - char(20)
          'Mobile' , -- ItemColumnName - varchar(100)
          'N' , -- ItemRequiresComment - type_YOrN
          '' , -- ItemCommentColumnName - varchar(100)
          0 , -- ItemWidth - int
          0 , -- MaximumLength - int
          'G' , -- DropdownType - char(1)
          '' , -- SharedTableName - varchar(100)
          '' , -- StoredProcedureName - varchar(100)
          '' , -- ValueField - varchar(100)
          '' , -- TextField - varchar(100)
          0 , -- MultilineEditFieldHeight - int
          NULL , -- EachRadioButtonOnNewLine - type_YOrN
          NULL , -- InformationIcon - type_YOrN
          '' , -- InformationIconStoredProcedure - varchar(100)
          NULL , -- ExcludeFromPencilIcon - type_YOrN
          NULL  -- HasStoredProcedureParameter - type_YOrN
        )
		
		SET IDENTITY_INSERT [SCREENS] OFF
END
GO