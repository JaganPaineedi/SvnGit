/*********************************************************************************             
**  File: Custom Form Field Script.sql 
**  Name: Custom Form Field Script 
**  Desc: Creates Food Stamp custom fields for the Food Stamp Reports.
**                   
**  Created By:  Paul Ongwela 
**  Date:		 August 4, 2015 
**
...............................................................................                  
..  Change History                   
...............................................................................                  
..  Date:		Author:				Description:                   
..  --------	--------			-------------------------------------------    
..  08/4/2015  Paul Ongwela        Created.
..
..
**********************************************************************************/
-- Use NDNWTestSmartcare
Begin TRY 
Begin Tran

Declare @FormId Int = (Select FormId From Forms Where FormName = 'CustomClients' And IsNull(RecordDeleted,'N')='N'),
	@FormSectionId Int,
	@ForMSectionGroupId Int,
	@FormItemId Int

If Object_Id('tempdb..#SortOrder') Is Not Null Drop Table #SortOrder
Create Table #SortOrder  (SortOrder Int) Insert Into #SortOrder
Select IsNull(Max(SortOrder)+1,1) From FormSections Where FormId = @FormId And IsNull(RecordDeleted,'N')='N'
 
--Form
Exec csp_DFACreateForm 
	@FormName = 'CustomClients',
	@TableName = 'CustomClients',
	@TotalNumberOfColumns = 1,
	@Active = 'Y',
	@RetrieveStoredProcedure = Null,
	@JavascriptFilePath = Null,
	@FormId = @FormId Output,
	@abortIfExists = 'N'
 
--FormSection 1
Declare @SortOrder Int = (Select SortOrder From #SortOrder)
Exec csp_DFACreateFormSection
	@FormId = @FormId,
	@SortOrder = @SortOrder,
	@PlaceOnTopOfPage = 'N',
	@SectionLabel = 'Food Stamps',
	@Active = 'Y',
	@SectionEnableCheckBox = 'N', --If a section-enabling checkbox is present
	@SectionEnableCheckBoxText = Null, --Label of section-enabling check box
	@SectionEnableCheckBoxColumnName = Null, --The Type_YOrN field that enables/disables the checkbox if Y
	@NumberOfColumns = 4,
	@ShowPencilIcon = Null,
	@FormSectionId = @FormSectionId Output,
	@abortIfExists = 'N'

	If Object_Id('tempdb..#SortOrder') Is Not Null Drop Table #SortOrder
 
--FormSectionGroup 1
Exec csp_DFACreateFormSectionGroup
	@FormSectionId = @FormSectionId,
	@GroupName = Null,
	@SortOrder = 1,
	@GroupLabel = Null,
	@Active = 'Y',
	@GroupEnableCheckBox = 'N', --If a sectiongroup-enabling checkbox is present
	@GroupEnableCheckBoxText = Null, --Label of sectiongroup-enabling check box
	@GroupEnableCheckBoxColumnName = Null, --The Type_YOrN custom field that enables/disables the checkbox if Y
	@NumberOfItemsInRow = 3,
	@ShowPencilIcon = Null,
	@FormSectionGroupId = @FormSectionGroupId Output
	,@abortIfExists = 'N'

-- This is the Label
Exec csp_DFACreateFormItem
	@FormSectionId = @FormSectionId,
	@FormSectionGroupId = @FormSectionGroupId,
	@ItemType = 5367, -- Date
	@ItemLabel = 'Admission Date: ',
	@SortOrder = 1,
	@Active = 'Y',
	@GlobalCodeCategory	= Null,
	@ItemColumnName	= 'FoodStampsAdmissionDate', --CustomFields column
	@ItemRequiresComment = 'N',
	@ItemCommentColumnName = Null,
	@ItemWidth = Null, --px?
	@MaximumLength = Null,
	@DropdownType = Null,
	@SharedTableName = Null,
	@StoredProcedureName = Null,
	@ValueField = Null,
	@TextField = Null,
	@MultilineEditFieldHeight= Null,
	@EachRadioButtonOnNewLine = 'N',
	@InformationIcon = 'N',
	@InformationIconStoredProcedure = Null,
	@ExcludeFromPencilIcon = 'Y',
	@FormItemId = @FormItemId Output
	,@abortIfExists = 'N'

-- This is the Drop Down
Exec csp_DFACreateFormItem
	@FormSectionId = @FormSectionId,
	@FormSectionGroupId = @FormSectionGroupId,
	@ItemType = 5367, -- Date
	@ItemLabel = 'Date Submitted: ',
	@SortOrder = 2,
	@Active = 'Y',
	@GlobalCodeCategory	= Null,
	@ItemColumnName	= 'FoodStampsSubmittedDate', --CustomFields column
	@ItemRequiresComment = 'N',
	@ItemCommentColumnName = Null,
	@ItemWidth = Null, --px?
	@MaximumLength = Null,
	@DropdownType = Null,
	@SharedTableName = Null,
	@StoredProcedureName = Null,
	@ValueField = Null,
	@TextField = Null,
	@MultilineEditFieldHeight= Null,
	@EachRadioButtonOnNewLine = 'N',
	@InformationIcon = 'N',
	@InformationIconStoredProcedure = Null,
	@ExcludeFromPencilIcon = 'Y',
	@FormItemId = @FormItemId Output
	,@abortIfExists = 'N'

-- This is the Drop Down
Exec csp_DFACreateFormItem
	@FormSectionId = @FormSectionId,
	@FormSectionGroupId = @FormSectionGroupId,
	@ItemType = 5367, -- Date
	@ItemLabel = 'Approval Date: ',
	@SortOrder = 3,
	@Active = 'Y',
	@GlobalCodeCategory	= Null,
	@ItemColumnName	= 'FoodStampsApprovalDate', --CustomFields column
	@ItemRequiresComment = 'N',
	@ItemCommentColumnName = Null,
	@ItemWidth = Null, --px?
	@MaximumLength = Null,
	@DropdownType = Null,
	@SharedTableName = Null,
	@StoredProcedureName = Null,
	@ValueField = Null,
	@TextField = Null,
	@MultilineEditFieldHeight= Null,
	@EachRadioButtonOnNewLine = 'N',
	@InformationIcon = 'N',
	@InformationIconStoredProcedure = Null,
	@ExcludeFromPencilIcon = 'Y',
	@FormItemId = @FormItemId Output
	,@abortIfExists = 'N'

-- This is the Drop Down
Exec csp_DFACreateFormItem
	@FormSectionId = @FormSectionId,
	@FormSectionGroupId = @FormSectionGroupId,
	@ItemType = 5367, -- Date
	@ItemLabel = 'Date Client Leave Reported: ',
	@SortOrder = 4,
	@Active = 'Y',
	@GlobalCodeCategory	= Null,
	@ItemColumnName	= 'FoodStampsClientLeaveDate', --CustomFields column
	@ItemRequiresComment = 'N',
	@ItemCommentColumnName = Null,
	@ItemWidth = Null, --px?
	@MaximumLength = Null,
	@DropdownType = Null,
	@SharedTableName = Null,
	@StoredProcedureName = Null,
	@ValueField = Null,
	@TextField = Null,
	@MultilineEditFieldHeight= Null,
	@EachRadioButtonOnNewLine = 'N',
	@InformationIcon = 'N',
	@InformationIconStoredProcedure = Null,
	@ExcludeFromPencilIcon = 'Y',
	@FormItemId = @FormItemId Output
	,@abortIfExists = 'N'

-- This is the Drop Down
Exec csp_DFACreateFormItem
	@FormSectionId = @FormSectionId,
	@FormSectionGroupId = @FormSectionGroupId,
	@ItemType = 5369, -- Time
	@ItemLabel = 'Time Client Leave Reported: ',
	@SortOrder = 5,
	@Active = 'Y',
	@GlobalCodeCategory	= Null,
	@ItemColumnName	= 'FoodStampsClientLeaveTime', --CustomFields column
	@ItemRequiresComment = 'N',
	@ItemCommentColumnName = Null,
	@ItemWidth = Null, --px?
	@MaximumLength = Null,
	@DropdownType = Null,
	@SharedTableName = Null,
	@StoredProcedureName = Null,
	@ValueField = Null,
	@TextField = Null,
	@MultilineEditFieldHeight= Null,
	@EachRadioButtonOnNewLine = 'N',
	@InformationIcon = 'N',
	@InformationIconStoredProcedure = Null,
	@ExcludeFromPencilIcon = 'Y',
	@FormItemId = @FormItemId Output
	,@abortIfExists = 'N'

--Update Screens
--Set CustomFieldFormId = @FormId
--Where ScreenUrl = '/ActivityPages/Client/Detail/PMClientGeneralInformation.ascx'
 
Commit Tran
End	Try
Begin Catch
 
IF @@TranCount > 0 RollBack Tran
 
Declare @errorMessage NVarChar(4000) 
Set @errorMessage = Error_Message()
 
RaisError(@errorMessage, 16, 1)
 
End Catch