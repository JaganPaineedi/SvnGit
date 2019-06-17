
DECLARE @FormSectionId int
declare @FormSectionGroupId int
Select @FormSectionId=FormSectionId,@FormSectionGroupId=FormSectionGroupId from FormItems Where ItemColumnName = 'DaysDocumentEditableAfterSignature'
IF NOT EXISTS (
		SELECT *
		FROM FormItems
		WHERE FormSectionId = @FormSectionId and FormSectionGroupId=@FormSectionGroupId and ItemLabel = '<span style="margin-left:43px">Disclosure Print Order'
		)

BEGIN
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
          GETDATE() , -- CreatedDate - type_CurrentDatetime
          'shstest' , -- ModifiedBy - type_CurrentUser
          GETDATE() , -- ModifiedDate - type_CurrentDatetime
          NULL , -- RecordDeleted - type_YOrN
          NULL , -- DeletedDate - datetime
          NULL , -- DeletedBy - type_UserId
          @FormSectionId , -- FormSectionId - int
          @FormSectionGroupId , -- FormSectionGroupId - int
          5374 , -- ItemType - type_GlobalCode
         '<span style="margin-left:43px">Disclosure Print Order', -- ItemLabel - varchar(1000)
          41 , -- SortOrder - int
          'Y' , -- Active - type_Active
          NULL , -- GlobalCodeCategory - char(20)
          NULL , -- ItemColumnName - varchar(100)
          'N' , -- ItemRequiresComment - type_YOrN
          NULL , -- ItemCommentColumnName - varchar(100)
          NULL , -- ItemWidth - int
          NULL , -- MaximumLength - int
          NULL , -- DropdownType - char(1)
          NULL , -- SharedTableName - varchar(100)
          NULL , -- StoredProcedureName - varchar(100)
          NULL , -- ValueField - varchar(100)
          NULL , -- TextField - varchar(100)
          NULL , -- MultilineEditFieldHeight - int
          NULL , -- EachRadioButtonOnNewLine - type_YOrN
          NULL , -- InformationIcon - type_YOrN
          NULL , -- InformationIconStoredProcedure - varchar(100)
          NULL , -- ExcludeFromPencilIcon - type_YOrN
          NULL  -- HasStoredProcedureParameter - type_YOrN
        )
END
ELSE 
  BEGIN 
      UPDATE [FormItems] 
      SET
          ModifiedBy ='shstest' , -- ModifiedBy - type_CurrentUser
          ModifiedDate =GETDATE() , -- ModifiedDate - type_CurrentDatetime
          RecordDeleted = NULL , -- RecordDeleted - type_YOrN
          DeletedDate = NULL , -- DeletedDate - datetime
          DeletedBy =NULL , -- DeletedBy - type_UserId
         -- FormSectionId =@FormSectionId , -- FormSectionId - int
         -- FormSectionGroupId =999 , -- FormSectionGroupId - int
          ItemType =5374 , -- ItemType - type_GlobalCode
          ItemLabel ='<span style="margin-left:43px">Disclosure Print Order' , -- ItemLabel - varchar(1000)
          SortOrder =41 , -- SortOrder - int
          Active = 'Y' , -- Active - type_Active
          GlobalCodeCategory = NULL , -- GlobalCodeCategory - char(20)
          ItemColumnName =NULL , -- ItemColumnName - varchar(100)
          ItemRequiresComment ='N' , -- ItemRequiresComment - type_YOrN
          ItemCommentColumnName =NULL , -- ItemCommentColumnName - varchar(100)
          ItemWidth =NULL , -- ItemWidth - int
          MaximumLength =NULL , -- MaximumLength - int
          DropdownType =NULL , -- DropdownType - char(1)
          SharedTableName =NULL , -- SharedTableName - varchar(100)
          StoredProcedureName =NULL , -- StoredProcedureName - varchar(100)
          ValueField =NULL , -- ValueField - varchar(100)
          TextField =NULL , -- TextField - varchar(100)
          MultilineEditFieldHeight =NULL , -- MultilineEditFieldHeight - int
          EachRadioButtonOnNewLine =NULL , -- EachRadioButtonOnNewLine - type_YOrN
          InformationIcon =NULL , -- InformationIcon - type_YOrN
          InformationIconStoredProcedure = NULL , -- InformationIconStoredProcedure - varchar(100)
          ExcludeFromPencilIcon =NULL , -- ExcludeFromPencilIcon - type_YOrN
          HasStoredProcedureParameter=NULL  -- HasStoredProcedureParameter - type_YOrN
          WHERE FormSectionId = @FormSectionId and FormSectionGroupId=@FormSectionGroupId and ItemLabel = '<span style="margin-left:43px">Disclosure Print Order'
          END 
          
          
          
          
          
          
          
IF NOT EXISTS (
		SELECT *
		FROM FormItems
		WHERE FormSectionId = @FormSectionId and FormSectionGroupId=@FormSectionGroupId and ItemColumnName='PrintOrder'
		)
BEGIN

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
          GETDATE() , -- CreatedDate - type_CurrentDatetime
          'shstest' , -- ModifiedBy - type_CurrentUser
          GETDATE() , -- ModifiedDate - type_CurrentDatetime
          NULL , -- RecordDeleted - type_YOrN
          NULL , -- DeletedDate - datetime
          NULL , -- DeletedBy - type_UserId
          @FormSectionId , -- FormSectionId - int
          @FormSectionGroupId , -- FormSectionGroupId - int
          5361 , -- ItemType - type_GlobalCode
          '<span style="margin-left:16px"></span>' , -- ItemLabel - varchar(1000)
          42 , -- SortOrder - int
          'Y' , -- Active - type_Active
          NULL, -- GlobalCodeCategory - char(20)
          'PrintOrder' , -- ItemColumnName - varchar(100)
          'N' , -- ItemRequiresComment - type_YOrN
          NULL , -- ItemCommentColumnName - varchar(100)
          NULL , -- ItemWidth - int
          NULL , -- MaximumLength - int
          NULL , -- DropdownType - char(1)
          NULL , -- SharedTableName - varchar(100)
          NULL , -- StoredProcedureName - varchar(100)
          NULL , -- ValueField - varchar(100)
          NULL , -- TextField - varchar(100)
          NULL , -- MultilineEditFieldHeight - int
          NULL , -- EachRadioButtonOnNewLine - type_YOrN
          NULL , -- InformationIcon - type_YOrN
          NULL , -- InformationIconStoredProcedure - varchar(100)
          NULL , -- ExcludeFromPencilIcon - type_YOrN
          NULL  -- HasStoredProcedureParameter - type_YOrN
        )
		
END
ELSE 
  BEGIN 
      UPDATE [FormItems] 
      SET 
          ModifiedBy ='shstest' , -- ModifiedBy - type_CurrentUser
          ModifiedDate =GETDATE() , -- ModifiedDate - type_CurrentDatetime
          RecordDeleted = NULL , -- RecordDeleted - type_YOrN
          DeletedDate = NULL , -- DeletedDate - datetime
          DeletedBy =NULL , -- DeletedBy - type_UserId
         -- FormSectionId =@FormSectionId , -- FormSectionId - int
         -- FormSectionGroupId =999 , -- FormSectionGroupId - int
          ItemType =5361 , -- ItemType - type_GlobalCode
          ItemLabel ='<span style="margin-left:16px"></span>' , -- ItemLabel - varchar(1000)
          SortOrder =42 , -- SortOrder - int
          Active = 'Y' , -- Active - type_Active
          GlobalCodeCategory = NULL , -- GlobalCodeCategory - char(20)
          ItemColumnName ='PrintOrder' , -- ItemColumnName - varchar(100)
          ItemRequiresComment ='N' , -- ItemRequiresComment - type_YOrN
          ItemCommentColumnName =NULL , -- ItemCommentColumnName - varchar(100)
          ItemWidth =NULL , -- ItemWidth - int
          MaximumLength =NULL, -- MaximumLength - int
          DropdownType =NULL, -- DropdownType - char(1)
          SharedTableName =NULL , -- SharedTableName - varchar(100)
          StoredProcedureName =NULL , -- StoredProcedureName - varchar(100)
          ValueField =NULL , -- ValueField - varchar(100)
          TextField =NULL , -- TextField - varchar(100)
          MultilineEditFieldHeight =NULL , -- MultilineEditFieldHeight - int
          EachRadioButtonOnNewLine =NULL , -- EachRadioButtonOnNewLine - type_YOrN
          InformationIcon =NULL , -- InformationIcon - type_YOrN
          InformationIconStoredProcedure = NULL , -- InformationIconStoredProcedure - varchar(100)
          ExcludeFromPencilIcon =NULL , -- ExcludeFromPencilIcon - type_YOrN
          HasStoredProcedureParameter=NULL  -- HasStoredProcedureParameter - type_YOrN
          WHERE FormSectionId = @FormSectionId and FormSectionGroupId=@FormSectionGroupId and ItemColumnName='PrintOrder'
          END 
          
          
          
          
          
         



IF NOT EXISTS (
		SELECT *
		FROM FormItems
		WHERE FormSectionId = @FormSectionId and FormSectionGroupId=@FormSectionGroupId and ItemLabel = 'Disclosure Print Order By Effective date'
		)

BEGIN
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
          GETDATE() , -- CreatedDate - type_CurrentDatetime
          'shstest' , -- ModifiedBy - type_CurrentUser
          GETDATE() , -- ModifiedDate - type_CurrentDatetime
          NULL , -- RecordDeleted - type_YOrN
          NULL , -- DeletedDate - datetime
          NULL , -- DeletedBy - type_UserId
          @FormSectionId , -- FormSectionId - int
          @FormSectionGroupId , -- FormSectionGroupId - int
          5374 , -- ItemType - type_GlobalCode
         'Disclosure Print Order By Effective date', -- ItemLabel - varchar(1000)
          43 , -- SortOrder - int
          'Y' , -- Active - type_Active
          NULL , -- GlobalCodeCategory - char(20)
          NULL , -- ItemColumnName - varchar(100)
          'N' , -- ItemRequiresComment - type_YOrN
          NULL , -- ItemCommentColumnName - varchar(100)
          NULL , -- ItemWidth - int
          NULL , -- MaximumLength - int
          NULL , -- DropdownType - char(1)
          NULL , -- SharedTableName - varchar(100)
          NULL , -- StoredProcedureName - varchar(100)
          NULL , -- ValueField - varchar(100)
          NULL , -- TextField - varchar(100)
          NULL , -- MultilineEditFieldHeight - int
          NULL , -- EachRadioButtonOnNewLine - type_YOrN
          NULL , -- InformationIcon - type_YOrN
          NULL , -- InformationIconStoredProcedure - varchar(100)
          NULL , -- ExcludeFromPencilIcon - type_YOrN
          NULL  -- HasStoredProcedureParameter - type_YOrN
        )
END
ELSE 
  BEGIN 
      UPDATE [FormItems] 
      SET
          ModifiedBy ='shstest' , -- ModifiedBy - type_CurrentUser
          ModifiedDate =GETDATE() , -- ModifiedDate - type_CurrentDatetime
          RecordDeleted = NULL , -- RecordDeleted - type_YOrN
          DeletedDate = NULL , -- DeletedDate - datetime
          DeletedBy =NULL , -- DeletedBy - type_UserId
         -- FormSectionId =@FormSectionId , -- FormSectionId - int
         -- FormSectionGroupId =999 , -- FormSectionGroupId - int
          ItemType =5374 , -- ItemType - type_GlobalCode
          ItemLabel ='Disclosure Print Order By Effective date' , -- ItemLabel - varchar(1000)
          SortOrder =43 , -- SortOrder - int
          Active = 'Y' , -- Active - type_Active
          GlobalCodeCategory = NULL , -- GlobalCodeCategory - char(20)
          ItemColumnName =NULL , -- ItemColumnName - varchar(100)
          ItemRequiresComment ='N' , -- ItemRequiresComment - type_YOrN
          ItemCommentColumnName =NULL , -- ItemCommentColumnName - varchar(100)
          ItemWidth =NULL , -- ItemWidth - int
          MaximumLength =NULL , -- MaximumLength - int
          DropdownType =NULL , -- DropdownType - char(1)
          SharedTableName =NULL , -- SharedTableName - varchar(100)
          StoredProcedureName =NULL , -- StoredProcedureName - varchar(100)
          ValueField =NULL , -- ValueField - varchar(100)
          TextField =NULL , -- TextField - varchar(100)
          MultilineEditFieldHeight =NULL , -- MultilineEditFieldHeight - int
          EachRadioButtonOnNewLine =NULL , -- EachRadioButtonOnNewLine - type_YOrN
          InformationIcon =NULL , -- InformationIcon - type_YOrN
          InformationIconStoredProcedure = NULL , -- InformationIconStoredProcedure - varchar(100)
          ExcludeFromPencilIcon =NULL , -- ExcludeFromPencilIcon - type_YOrN
          HasStoredProcedureParameter=NULL  -- HasStoredProcedureParameter - type_YOrN
          WHERE FormSectionId = @FormSectionId and FormSectionGroupId=@FormSectionGroupId and ItemLabel = 'Disclosure Print Order By Effective date'
          END 
          
          
  
  
   IF NOT EXISTS (
		SELECT *
		FROM FormItems
		WHERE FormSectionId = @FormSectionId and FormSectionGroupId=@FormSectionGroupId and ItemColumnName='DisclosurePrintOrder'
		)
BEGIN

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
          GETDATE() , -- CreatedDate - type_CurrentDatetime
          'shstest' , -- ModifiedBy - type_CurrentUser
          GETDATE() , -- ModifiedDate - type_CurrentDatetime
          NULL , -- RecordDeleted - type_YOrN
          NULL , -- DeletedDate - datetime
          NULL , -- DeletedBy - type_UserId
          @FormSectionId , -- FormSectionId - int
          @FormSectionGroupId , -- FormSectionGroupId - int
          5365 , -- ItemType - type_GlobalCode
          '<span style="margin-left:16px"></span>' , -- ItemLabel - varchar(1000)
          44 , -- SortOrder - int
          'Y' , -- Active - type_Active
          'PRINTORDER' , -- GlobalCodeCategory - char(20)
          'DisclosurePrintOrder' , -- ItemColumnName - varchar(100)
          'N' , -- ItemRequiresComment - type_YOrN
          NULL , -- ItemCommentColumnName - varchar(100)
          NULL , -- ItemWidth - int
          NULL , -- MaximumLength - int
          'G' , -- DropdownType - char(1)
          NULL , -- SharedTableName - varchar(100)
          NULL , -- StoredProcedureName - varchar(100)
          NULL , -- ValueField - varchar(100)
          NULL , -- TextField - varchar(100)
          NULL , -- MultilineEditFieldHeight - int
          NULL , -- EachRadioButtonOnNewLine - type_YOrN
          NULL , -- InformationIcon - type_YOrN
          NULL , -- InformationIconStoredProcedure - varchar(100)
          NULL , -- ExcludeFromPencilIcon - type_YOrN
          NULL  -- HasStoredProcedureParameter - type_YOrN
        )
		
END
ELSE 
  BEGIN 
      UPDATE [FormItems] 
      SET 
          ModifiedBy ='shstest' , -- ModifiedBy - type_CurrentUser
          ModifiedDate =GETDATE() , -- ModifiedDate - type_CurrentDatetime
          RecordDeleted = NULL , -- RecordDeleted - type_YOrN
          DeletedDate = NULL , -- DeletedDate - datetime
          DeletedBy =NULL , -- DeletedBy - type_UserId
         -- FormSectionId =@FormSectionId , -- FormSectionId - int
         -- FormSectionGroupId =999 , -- FormSectionGroupId - int
          ItemType =5365 , -- ItemType - type_GlobalCode
          ItemLabel ='<span style="margin-left:16px"></span>' , -- ItemLabel - varchar(1000)
          SortOrder =44 , -- SortOrder - int
          Active = 'Y' , -- Active - type_Active
          GlobalCodeCategory = 'PRINTORDER' , -- GlobalCodeCategory - char(20)
          ItemColumnName ='DisclosurePrintOrder' , -- ItemColumnName - varchar(100)
          ItemRequiresComment ='N' , -- ItemRequiresComment - type_YOrN
          ItemCommentColumnName =NULL , -- ItemCommentColumnName - varchar(100)
          ItemWidth =NULL , -- ItemWidth - int
          MaximumLength =NULL, -- MaximumLength - int
          DropdownType ='G' , -- DropdownType - char(1)
          SharedTableName =NULL , -- SharedTableName - varchar(100)
          StoredProcedureName =NULL , -- StoredProcedureName - varchar(100)
          ValueField =NULL , -- ValueField - varchar(100)
          TextField =NULL , -- TextField - varchar(100)
          MultilineEditFieldHeight =NULL , -- MultilineEditFieldHeight - int
          EachRadioButtonOnNewLine =NULL , -- EachRadioButtonOnNewLine - type_YOrN
          InformationIcon =NULL , -- InformationIcon - type_YOrN
          InformationIconStoredProcedure = NULL , -- InformationIconStoredProcedure - varchar(100)
          ExcludeFromPencilIcon =NULL , -- ExcludeFromPencilIcon - type_YOrN
          HasStoredProcedureParameter=NULL  -- HasStoredProcedureParameter - type_YOrN
          WHERE FormSectionId = @FormSectionId and FormSectionGroupId=@FormSectionGroupId and ItemColumnName='DisclosurePrintOrder'
          END        