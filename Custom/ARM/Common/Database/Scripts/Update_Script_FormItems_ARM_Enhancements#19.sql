-- Script to add new field to Custom Staff form

UPDATE FormItems
SET ItemLabel = 'MH Billing Degree After BH Redesign'
WHERE ItemColumnName = 'BillingDegreeAfterBHRedesign'

IF NOT EXISTS (SELECT 1 FROM FormItems WHERE ItemColumnName = 'BillingDegreeAfterBHRedesignSUD' AND Isnull(RecordDeleted,'N') = 'N')
BEGIN

DECLARE @FormSectionId INT, @FormSectionGroupId INT

SELECT @FormSectionId = FormSectionId,
@FormSectionGroupId = FormSectionGroupId
FROM FormItems
WHERE ItemColumnName = 'BillingDegreeAfterBHRedesign'

INSERT INTO FormItems
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
VALUES  ( 'SA Task 19.06' , -- CreatedBy - type_CurrentUser
          GETDATE() , -- CreatedDate - type_CurrentDatetime
          'SA Task 19.06' , -- ModifiedBy - type_CurrentUser
          GETDATE() , -- ModifiedDate - type_CurrentDatetime
          NULL , -- RecordDeleted - type_YOrN
          NULL , -- DeletedDate - datetime
          NULL , -- DeletedBy - type_UserId
          @FormSectionId , -- FormSectionId - int
          @FormSectionGroupId , -- FormSectionGroupId - int
          5372 , -- ItemType - type_GlobalCode
          'SUD Billing Degree After BH Redesign' , -- ItemLabel - varchar(1000)
          62 , -- SortOrder - int
          'Y' , -- Active - type_Active
          NULL , -- GlobalCodeCategory - char(20)
          'BillingDegreeAfterBHRedesignSUD' , -- ItemColumnName - varchar(100)
          'N' , -- ItemRequiresComment - type_YOrN
          NULL , -- ItemCommentColumnName - varchar(100)
          200 , -- ItemWidth - int
          NULL , -- MaximumLength - int
          'S' , -- DropdownType - char(1)
          NULL , -- SharedTableName - varchar(100)
          'csp_LicensesForStaff' , -- StoredProcedureName - varchar(100)
          'StaffLicenseDegreeId' , -- ValueField - varchar(100)
          'TextField' , -- TextField - varchar(100)
          NULL , -- MultilineEditFieldHeight - int
          NULL , -- EachRadioButtonOnNewLine - type_YOrN
          NULL , -- InformationIcon - type_YOrN
          NULL , -- InformationIconStoredProcedure - varchar(100)
          NULL , -- ExcludeFromPencilIcon - type_YOrN
          'Y'  -- HasStoredProcedureParameter - type_YOrN
        )
END
