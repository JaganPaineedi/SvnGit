/* 
InsertScript_REPORTS_GOBHICrisisCallResponseTime
New Direction - Support Go Live Task #551
Create Reports table entry
mlightner - 04/13/2017
*/

declare	@ReportName varchar(250) = 'GOBHI Crisis Response Time';
	-- Also for Folder Name
declare	@IsFolder char(1) = 'N';
declare	@RDLName varchar(100) = 'RDLGOBHICrisisCallResponseTime';
declare	@ReportFolderName varchar(max) = isnull(( select	sck.Value
												  from		dbo.SystemConfigurationKeys sck
												  where		isnull(sck.RecordDeleted, 'N') = 'N'
															and sck.[Key] = 'ReportFolderName'
												), '');
declare	@ParentFolderName varchar(max) = 'GOBHI';
declare	@AssocWith varchar(max) = null;
		-- 'Client' Association, Other, or Null

/* State Reporting Folder */
if not exists ( select	*
				from	dbo.Reports
				where	Name = 'State Reporting'
						and IsFolder = 'Y'
						and isnull(RecordDeleted, 'N') = 'N' )
   begin
		 insert	into dbo.Reports
				( Name
				, Description
				, IsFolder
				, ParentFolderId )
		 values	( 'State Reporting'
				, 'State Reporting'
				, 'Y'
				, null );
		 declare @SRIdentity int = @@identity;
   end;
else
   begin
		 set @SRIdentity = ( select	ReportId
							 from	Reports
							 where	Name = 'State Reporting'
									and IsFolder = 'Y'
									and isnull(RecordDeleted, 'N') = 'N'
						   );
   end;

/* GOBHI */
if not exists ( select	*
				from	dbo.Reports
				where	Name = @ParentFolderName
						and IsFolder = 'Y'
						and isnull(RecordDeleted, 'N') = 'N' )
   begin
		 insert	into dbo.Reports
				( Name
				, Description
				, IsFolder
				, ParentFolderId )
		 values	( @ParentFolderName
				, @ParentFolderName
				, 'Y'
				, @SRIdentity );
		 declare @GOBHIIdentity int = @@identity;
   end;
else
   begin
		 set @GOBHIIdentity = ( select	ReportId
								from	dbo.Reports
								where	Name = @ParentFolderName
										and IsFolder = 'Y'
										and isnull(RecordDeleted, 'N') = 'N'
							  );
   end;

/* Report */
if not exists ( select	*
				from	dbo.Reports
				where	Name = @ReportName
						and isnull(RecordDeleted, 'N') = 'N'
						and IsFolder = @IsFolder )
   begin
		 insert	into dbo.Reports
				( Name
				, Description
				, IsFolder
				, ParentFolderId
				, AssociatedWith
				, ReportServerId
				, ReportServerPath )
		 values	( @ReportName
				, @ReportName
				, @IsFolder
				, @GOBHIIdentity
				, case @AssocWith
					when 'Client' then ( select	gc.GlobalCodeId
										 from	dbo.GlobalCodes gc
										 where	isnull(gc.RecordDeleted, 'N') = 'N'
												and gc.Category = 'REPORTASSOCIATEDWITH'
												and gc.CodeName = 'Client'
												and gc.Active = 'Y'
									   )
					else null
				  end
				, ( select top 1
							rs.ReportServerId
					from	dbo.ReportServers rs
					where	isnull(rs.RecordDeleted, 'N') = 'N'
					order by 1 desc
				  )
				, '/' + @ReportFolderName + '/' + @RDLName );
   end;
else
   begin
		 update	dbo.Reports
		 set	ModifiedBy = suser_name()
			  , ModifiedDate = getdate()
			  , ReportServerPath = '/' + @ReportFolderName + '/' + @RDLName
		 where	isnull(RecordDeleted, 'N') = 'N'
				and Name = @ReportName
				and isnull(IsFolder, 'N') = @IsFolder
				and ( ParentFolderId <> ( select	r.ReportId
										  from		dbo.Reports r
										  where		Name = @ParentFolderName
													and r.IsFolder = 'Y'
													and isnull(r.RecordDeleted, 'N') = 'N'
										)
					  or isnull(AssociatedWith, 0) <> case @AssocWith
														when 'Client' then ( select	gc.GlobalCodeId
																			 from	dbo.GlobalCodes gc
																			 where	isnull(gc.RecordDeleted, 'N') = 'N'
																					and gc.Category = 'REPORTASSOCIATEDWITH'
																					and gc.CodeName = 'Client'
																					and gc.Active = 'Y'
																		   )
														else 0
													  end
					  or ReportServerId <> ( select top 1
													rs.ReportServerId
											 from	dbo.ReportServers rs
											 where	isnull(rs.RecordDeleted, 'N') = 'N'
											 order by 1 desc
										   )
					  or ReportServerPath <> '/' + @ReportFolderName + '/' + @RDLName );
   end;

