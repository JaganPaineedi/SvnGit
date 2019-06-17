/*********************************************************************                                                                                          
	File Name:			InsertScript_Forms_GOBHIAccessTimes.sql
	Creation Date:		07/05/2017
	Created By:			mlightner
	Purpose:			Create Dynamic Forms for maintaining AppointmentRequestedDate
							and AppointmentFirstOfferedDate
	Customer:			New Directions Northwest

	Input Parameters:	
	Output Parameters:	
	Return:				
	
	Called By:			
	Calls:				
 
	Modifications:
	Date		Author          Description of Modifications
	==========	==============	======================================
	07/05/2017	mlightner		Created - New Directions-Enhancements: Task 552.1
*********************************************************************/

declare	@FormId int;
declare	@FormCollectionId int;
declare	@FormSectionId int;
declare	@FormSectionGroupId int;
declare	@FormItem1Id int;
declare	@FormItem2Id int;
declare	@FormItem3Id int;
declare	@FormItem4Id int;
declare	@Active char(1) = 'Y';
declare	@DBName varchar(max) = db_name();

declare	@FormItemTypeDate int = ( select	gc.GlobalCodeId
								  from		dbo.GlobalCodes gc
								  where		isnull(gc.RecordDeleted, 'N') = 'N'
											and gc.Active = 'Y'
											and gc.Category = 'FORMFIELDTYPE'
											and CodeName = 'Date'
								);
declare	@FormItemTypeTime int = ( select	gc.GlobalCodeId
								  from		dbo.GlobalCodes gc
								  where		isnull(gc.RecordDeleted, 'N') = 'N'
											and gc.Active = 'Y'
											and gc.Category = 'FORMFIELDTYPE'
											and CodeName = 'Time'
								);
declare	@FormItemColumnNameRequestDate varchar(100) = 'AppointmentRequestedDate';
declare	@FormItemColumnNameOfferedDate varchar(100) = 'AppointmentFirstOfferedDate';

/* Forms */
if not exists ( select	*
				from	dbo.Forms
				where	FormName = 'CustomClientPrograms'
						and isnull(RecordDeleted, 'N') = 'N' )
   begin
		 
		 insert	into dbo.Forms
				( FormName
				, TableName
				, TotalNumberOfColumns
				, Active
				, RetrieveStoredProcedure )
		 values	( 'CustomClientPrograms'
				, 'CustomClientPrograms'
				, 1
				, @Active
				, 'csp_GetCustomClientPrograms' );

		 set @FormId = @@identity;

   end;
else
   begin
		 select	@FormId = f.FormId
		 from	dbo.Forms f
		 where	isnull(f.RecordDeleted, 'N') = 'N'
				and f.FormName = 'CustomClientPrograms';
   end;

/* Form Sections */
if not exists ( select	*
				from	dbo.FormSections
				where	FormId = @FormId
						and isnull(RecordDeleted, 'N') = 'N' )
   begin
		 insert	into dbo.FormSections
				( FormId
				, SortOrder
				, PlaceOnTopOfPage
				, SectionLabel
				, Active
				, NumberOfColumns )
		 values	( @FormId
				, 1
				, 'Y'
				, 'Appointments'
				, @Active
				, 2 );
	
		 set @FormSectionId = @@identity;
   end;
else
   begin
		 select	@FormSectionId = fs.FormSectionId
		 from	dbo.FormSections fs
		 where	isnull(fs.RecordDeleted, 'N') = 'N'
				and fs.FormId = @FormId;
   end;

/* Form Section Groups */
if not exists ( select	*
				from	dbo.FormSectionGroups
				where	FormSectionId = @FormSectionId
						and isnull(RecordDeleted, 'N') = 'N' )
   begin
		 insert	into dbo.FormSectionGroups
				( GroupName
				, FormSectionId
				, SortOrder
				, Active
				, GroupEnableCheckBox
				, NumberOfItemsInRow )
		 values	( 'GOBHI Access'
				, @FormSectionId
				, 1
				, @Active
				, 'N'
				, 2 );
	
		 set @FormSectionGroupId = @@identity;
   end;
else
   begin
		 select	@FormSectionGroupId = fsg.FormSectionGroupId
		 from	dbo.FormSectionGroups fsg
		 where	isnull(fsg.RecordDeleted, 'N') = 'N'
				and fsg.FormSectionId = @FormSectionId;
   end;

/* Form Items - AppointmentRequestedDate - Date Item*/
if not exists ( select	*
				from	dbo.FormItems
				where	FormSectionId = @FormSectionId
						and FormSectionGroupId = @FormSectionGroupId
						and ItemColumnName = @FormItemColumnNameRequestDate
						and ItemType = @FormItemTypeDate
						and isnull(RecordDeleted, 'N') = 'N' )
   begin
		 insert	into dbo.FormItems
				( FormSectionId
				, FormSectionGroupId
				, ItemType
				, ItemLabel
				, SortOrder
				, Active
				, ItemColumnName
				, ItemRequiresComment )
		 values	( @FormSectionId
				, @FormSectionGroupId
				, @FormItemTypeDate
				, 'Appointment Requested Date'
				, 1
				, @Active
				, @FormItemColumnNameRequestDate
				, 'N' );
		 set @FormItem1Id = @@identity;
   end;
else
   begin
		 select	@FormItem1Id = fi.FormItemId
		 from	dbo.FormItems fi
		 where	fi.FormSectionId = @FormSectionId
				and fi.FormSectionGroupId = @FormSectionGroupId
				and fi.ItemColumnName = @FormItemColumnNameRequestDate
				and fi.ItemType = @FormItemTypeDate
				and isnull(fi.RecordDeleted, 'N') = 'N';
   end;

/* Form Items - AppointmentRequestedDate - Time Item*/
if not exists ( select	*
				from	dbo.FormItems
				where	FormSectionId = @FormSectionId
						and FormSectionGroupId = @FormSectionGroupId
						and ItemColumnName = @FormItemColumnNameRequestDate
						and ItemType = @FormItemTypeTime
						and isnull(RecordDeleted, 'N') = 'N' )
   begin
		 insert	into dbo.FormItems
				( FormSectionId
				, FormSectionGroupId
				, ItemType
				, ItemLabel
				, SortOrder
				, Active
				, ItemColumnName
				, ItemRequiresComment )
		 values	( @FormSectionId
				, @FormSectionGroupId
				, @FormItemTypeTime
				, 'Time (HH:MM AM/PM)'
				, 2
				, @Active
				, @FormItemColumnNameRequestDate
				, 'N' );
		 set @FormItem2Id = @@identity;
   end;
else
   begin
		 select	@FormItem2Id = fi.FormItemId
		 from	dbo.FormItems fi
		 where	fi.FormSectionId = @FormSectionId
				and fi.FormSectionGroupId = @FormSectionGroupId
				and fi.ItemColumnName = @FormItemColumnNameRequestDate
				and fi.ItemType = @FormItemTypeTime
				and isnull(fi.RecordDeleted, 'N') = 'N';
   end;

/* Form Items - AppointmentFirstOfferedDate - Date Item*/
if not exists ( select	*
				from	dbo.FormItems
				where	FormSectionId = @FormSectionId
						and FormSectionGroupId = @FormSectionGroupId
						and ItemColumnName = @FormItemColumnNameOfferedDate
						and ItemType = @FormItemTypeDate
						and isnull(RecordDeleted, 'N') = 'N' )
   begin
		 insert	into dbo.FormItems
				( FormSectionId
				, FormSectionGroupId
				, ItemType
				, ItemLabel
				, SortOrder
				, Active
				, ItemColumnName
				, ItemRequiresComment )
		 values	( @FormSectionId
				, @FormSectionGroupId
				, @FormItemTypeDate
				, 'Appointment First Offered Date'
				, 3
				, @Active
				, @FormItemColumnNameOfferedDate
				, 'N' );
		 set @FormItem3Id = @@identity;
   end;
else
   begin
		 select	@FormItem3Id = fi.FormItemId
		 from	dbo.FormItems fi
		 where	fi.FormSectionId = @FormSectionId
				and fi.FormSectionGroupId = @FormSectionGroupId
				and fi.ItemColumnName = @FormItemColumnNameOfferedDate
				and fi.ItemType = @FormItemTypeDate
				and isnull(fi.RecordDeleted, 'N') = 'N';
   end;

/* Form Items - AppointmentFirstOfferedDate - Time Item*/
if not exists ( select	*
				from	dbo.FormItems
				where	FormSectionId = @FormSectionId
						and FormSectionGroupId = @FormSectionGroupId
						and ItemColumnName = @FormItemColumnNameOfferedDate
						and ItemType = @FormItemTypeTime
						and isnull(RecordDeleted, 'N') = 'N' )
   begin
		 insert	into dbo.FormItems
				( FormSectionId
				, FormSectionGroupId
				, ItemType
				, ItemLabel
				, SortOrder
				, Active
				, ItemColumnName
				, ItemRequiresComment )
		 values	( @FormSectionId
				, @FormSectionGroupId
				, @FormItemTypeTime
				, 'Time (HH:MM AM/PM)'
				, 4
				, @Active
				, @FormItemColumnNameOfferedDate
				, 'N' );
		 set @FormItem4Id = @@identity;
   end;
else
   begin
		 select	@FormItem4Id = fi.FormItemId
		 from	dbo.FormItems fi
		 where	fi.FormSectionId = @FormSectionId
				and fi.FormSectionGroupId = @FormSectionGroupId
				and fi.ItemColumnName = @FormItemColumnNameOfferedDate
				and fi.ItemType = @FormItemTypeTime
				and isnull(fi.RecordDeleted, 'N') = 'N';
   end;

/* Update Forms with HTML with Key Field Values and Current Database references */
declare	@FormHTML type_Comment2 = '<table cellpadding=''0'' cellspacing=''0'' width=''830px''  border=''0''><tr><td><table cellpadding=''0'' cellspacing=''0'' width=''100%'' border=0><tr><td valign=''top'' width=200%><table cellpadding=''0'' cellspacing=''0'' width=''100%'' border=0><tr><td valign=''top'' ><table cellpadding=''0'' cellspacing=''0'' width=''100%'' id=''Section'
		+ cast(isnull(@FormSectionId, '') as varchar)
		+ ''' border=0><tr><td ><table cellpadding=''2'' cellspacing=''0'' border=''0'' width=''100%''><tr><td class=''content_tab_left'' align=''left'' nowrap=''nowrap'' style=''padding-left:13px''><span style=''display:block'' class=''form_span_dfa'' id=''SectionLabel_'
		+ cast(isnull(@FormSectionId, '') as varchar) + '_' + cast(isnull(@FormId, '') as varchar)
		+ ''' >Appointments&#160;</span></td><td width=''17''><img style=''vertical-align: top'' src=''/' + isnull(@DBName, '')
		+ '/App_Themes/Includes/Images/content_tab_sep.gif'' alt='''' height=''26'' width=''17''/></td><td class=''content_tab_top'' width=''100%''></td><td width=''7''><img style=''vertical-align: top'' src=''/'
		+ isnull(@DBName, '')
		+ '/App_Themes/Includes/Images/content_tab_right.gif'' alt='''' height=''26'' width=''7''/></td></tr></table></td></tr><tr><td class=''content_tab_bg'' style="padding-left:10px"><table style=''margin-left:0px'' width=''98%'' cellpadding=''0'' border = 0 cellspacing=''0'' id=''SectionGroup'
		+ cast(isnull(@FormSectionId, '') as varchar)
		+ '''><tr valign=''bottom'' ><td valign=''bottom'' ><table><tr><td></td></tr></table></td></tr><tr><td><table cellpadding=''2'' cellspacing=''3''  border=''0''  ><tr><td style =''align:left;vertical-align:middle;''><table border=''0'' cellpadding=''0'' cellspacing=''0''><tr><td><span style=''display:block'' class=''form_span_dfa'' id=''Label_'
		+ cast(isnull(@FormSectionGroupId, '') as varchar) + '_' + cast(isnull(@FormSectionId, '') as varchar) + '_' + cast(isnull(@FormItem1Id, '') as varchar)
		+ ''' >Appointment Requested Date&#160;</span></td><td><table border=''0'' cellpadding=''0'' cellspacing=''0'' width=''108px'' ><tr    class=''date_Container''  > <td><input type =''text''  datatype=''Date'' class=''date_text''  id=''TextBox_CustomClientPrograms_AppointmentRequestedDate'' name=''TextBox_CustomClientPrograms_AppointmentRequestedDate'' /></td><td>&nbsp;</td><td><img class=''cursor_default'' style=''cursor: default;vertical-align: text-bottom;''  id=''img_CustomClientPrograms_AppointmentRequestedDate''src=''/'
		+ isnull(@DBName, '')
		+ '/App_Themes/Includes/Images/calender_grey.gif'' onclick=''return showCalendar("TextBox_CustomClientPrograms_AppointmentRequestedDate" ,"%m/%d/%Y");''/> </td></tr></table></td></tr></table></td><td style =''align:left;vertical-align:middle;''><table><tr><td><span style=''display:block'' class=''form_span_dfa'' id=''Label_'
		+ cast(isnull(@FormSectionGroupId, '') as varchar) + '_' + cast(isnull(@FormSectionId, '') as varchar) + '_' + cast(isnull(@FormItem2Id, '') as varchar)
		+ ''' >Time (HH:MM AM/PM)&#160;</span></td><td><input type =''text'' datatype =''Time''  class=''date_text'' id=''TextBoxTime_CustomClientPrograms_AppointmentRequestedDate''  maxlength=''9'' name=''TextBoxTime_CustomClientPrograms_AppointmentRequestedDate'' /></td></tr></table></td></tr><tr><td style =''align:left;vertical-align:middle;''><table border=''0'' cellpadding=''0'' cellspacing=''0''><tr><td><span style=''display:block'' class=''form_span_dfa'' id=''Label_'
		+ cast(isnull(@FormSectionGroupId, '') as varchar) + '_' + cast(isnull(@FormSectionId, '') as varchar) + '_' + cast(isnull(@FormItem3Id, '') as varchar)
		+ ''' >Appointment First Offered Date&#160;</span></td><td><table border=''0'' cellpadding=''0'' cellspacing=''0'' width=''108px'' ><tr    class=''date_Container''  > <td><input type =''text''  datatype=''Date'' class=''date_text''  id=''TextBox_CustomClientPrograms_AppointmentFirstOfferedDate'' name=''TextBox_CustomClientPrograms_AppointmentFirstOfferedDate'' /></td><td>&nbsp;</td><td><img class=''cursor_default'' style=''cursor: default;vertical-align: text-bottom;''  id=''img_CustomClientPrograms_AppointmentFirstOfferedDate''src=''/'
		+ isnull(@DBName, '')
		+ '/App_Themes/Includes/Images/calender_grey.gif'' onclick=''return showCalendar("TextBox_CustomClientPrograms_AppointmentFirstOfferedDate" ,"%m/%d/%Y");''/> </td></tr></table></td></tr></table></td><td style =''align:left;vertical-align:middle;''><table><tr><td><span style=''display:block'' class=''form_span_dfa'' id=''Label_'
		+ cast(isnull(@FormSectionGroupId, '') as varchar) + '_' + cast(isnull(@FormSectionId, '') as varchar) + '_' + cast(isnull(@FormItem4Id, '') as varchar)
		+ ''' >Time (HH:MM AM/PM)&#160;</span></td><td><input type =''text'' datatype =''Time''  class=''date_text'' id=''TextBoxTime_CustomClientPrograms_AppointmentFirstOfferedDate''  maxlength=''9'' name=''TextBoxTime_CustomClientPrograms_AppointmentFirstOfferedDate'' /></td></tr></table></td></tr></table></td></tr></table></td></tr><tr><td><table cellpadding=''0'' cellspacing=''0'' border=''0'' width=''100%''><tr><td class=''right_bottom_cont_bottom_bg'' align=''left'' width=''2''><img style=''vertical-align: top'' src=''/'
		+ isnull(@DBName, '')
		+ '/App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif'' alt='''' height=''7''/></td><td class =''right_bottom_cont_bottom_bg'' width=''100%''></td><td class=''right_bottom_cont_bottom_bg'' align=''right'' width=''2''><img style=''vertical-align: top'' src=''/'
		+ isnull(@DBName, '')
		+ '/App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif'' alt='''' height=''7''/></td></tr></table></td></tr><tr><td height=''10px''></td></tr></table></td></tr></table></td></tr></table></td></tr></table>';

update	dbo.Forms
set		FormHTML = @FormHTML
where	FormId = @FormId
		and isnull(RecordDeleted, 'N') = 'N'
		and FormHTML is null;