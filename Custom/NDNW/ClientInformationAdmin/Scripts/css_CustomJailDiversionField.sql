/*********************************************************************************             
**  File: css_CustomJailDiversionField.sql 
**  Name: Custom Jail Diversion Field Script 
**  Desc: Creates Jail Diversion custom field for the Jail Diversion Reports.
**                   
**  Created By:  Paul Ongwela 
**  Date:		 June 22, 2015 
**
...............................................................................                  
..  Change History                   
...............................................................................                  
..  Date:		Author:				Description:                   
..  --------	--------			-------------------------------------------    
..  06/22/2015  Paul Ongwela        Created.
..
..
**********************************************************************************/
Begin TRY 
Begin Tran
 
Declare @FormId Int = (Select FormId From Forms Where FormName = 'CustomClients' And IsNull(RecordDeleted,'N')='N'),
	@FormSectionId Int,
	@ForMSectionGroupId Int,
	@FormItemId Int
 
If Object_Id('tempdb..#SortOrder') Is Not Null Drop Table #SortOrder
Create Table #SortOrder  (SortOrder Int) Insert Into #SortOrder
Select IsNull(Max(SortOrder)+1,1) From FormItems Where FormSectionGroupId = 2000 And IsNull(RecordDeleted,'N')='N'

--Form
Exec csp_DFACreateForm 
	@FormName = 'CustomClients',
	@TableName = 'CustomClients',
	@TotalNumberOfColumns = 1,
	@Active = 'Y',
	@RetrieveStoredProcedure = Null,
	@JavascriptFilePath = Null,
	@FormId = @FormId Output
	,@abortIfExists = 'N'
 
--FormSection 1
Exec csp_DFACreateFormSection
	@FormId = @FormId,
	@SortOrder = 5,
	@PlaceOnTopOfPage = NULL,
	@SectionLabel = 'Basic Demographics',
	@Active = 'Y',
	@SectionEnableCheckBox = 'N', --If a section-enabling checkbox is present
	@SectionEnableCheckBoxText = Null, --Label of section-enabling check box
	@SectionEnableCheckBoxColumnName = Null, --The Type_YOrN field that enables/disables the checkbox if Y
	@NumberOfColumns = 4,
	@ShowPencilIcon = Null,
	@FormSectionId = @FormSectionId Output
	,@abortIfExists = 'N'
 
--FormSectionGroup 1
Exec csp_DFACreateFormSectionGroup
	@FormSectionId = @FormSectionId,
	@GroupName = Null,
	@SortOrder = 1,
	@GroupLabel = Null,
	@Active = 'Y',
	@GroupEnableCheckBox = Null, --If a sectiongroup-enabling checkbox is present
	@GroupEnableCheckBoxText = Null, --Label of sectiongroup-enabling check box
	@GroupEnableCheckBoxColumnName = Null, --The Type_YOrN custom field that enables/disables the checkbox if Y
	@NumberOfItemsInRow = 2,
	@ShowPencilIcon = Null,
	@FormSectionGroupId = @FormSectionGroupId Output
	,@abortIfExists = 'N'

Declare @SortOrder Int = (Select SortOrder From #SortOrder)
Exec csp_DFACreateFormItem
	@FormSectionId = @FormSectionId,
	@FormSectionGroupId = @FormSectionGroupId,
	@ItemType = 5372, --GlobalCode
	@ItemLabel = 'Jail Diversion Status:',
	@SortOrder = @SortOrder,
	@Active = 'Y',
	@GlobalCodeCategory	= 'XJAILDIVERSIONSTATUS',
	@ItemColumnName	= 'JailDiversionStatus', --CustomFields column
	@ItemRequiresComment = 'N',
	@ItemCommentColumnName = 'N',
	@ItemWidth = 200, --px?
	@MaximumLength = 0,
	@DropdownType = 'G',
	@SharedTableName = Null,
	@StoredProcedureName = Null,
	@ValueField = Null,
	@TextField = Null,
	@MultilineEditFieldHeight= Null,
	@EachRadioButtonOnNewLine = 'N',
	@InformationIcon = 'N',
	@InformationIconStoredProcedure = Null,
	@ExcludeFromPencilIcon = 'N',
	@FormItemId = @FormItemId Output
	,@abortIfExists = 'N'

If Object_Id('tempdb..#SortOrder') Is Not Null Drop Table #SortOrder

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