/****** Object:  StoredProcedure [dbo].[csp_JobInsertNewStaffWidgets]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobInsertNewStaffWidgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobInsertNewStaffWidgets]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobInsertNewStaffWidgets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE  [dbo].[csp_JobInsertNewStaffWidgets]   
AS

/* Setup StaffWidgets For all Active Staff where the widgets do not exist */

--
-- Find all staff missing widgets
--
DECLARE @Staff Table (StaffId int)
INSERT into @Staff
Select StaffId from Staff
Where StaffId not in (Select StaffId From StaffWidgets)
and Active = ''Y'' and ISNULL(RecordDeleted,''N'')=''N''


--
-- Insert StaffWidgets
--
BEGIN TRAN

	INSERT into CustomBugTracking (Description, CreatedDate)
	Select ''Inserted New Staff Widgets: ''+ LEFT(st.FirstName,1)+''.''+st.LastName+'' (''+CONVERT(varchar(20),st.StaffId)+'')''
	, GETDATE()
	FROM @Staff s
	Join Staff st on st.StaffId = s.StaffId


	INSERT into StaffWidgets (StaffId, WidgetId, ScreenId, WidgetOrder, OpenInMinimumSize, OpenInMaximumSize)
	Select st.StaffId, 7, 1, 1, ''N'', ''N'' From @Staff st  
	UNION
	Select st.StaffId, 4, 1, 2, ''N'', ''N'' From @Staff st 
	UNION
	Select st.StaffId, 3, 1, 3, ''N'', ''N'' From @Staff st
	UNION
	Select st.StaffId, 8, 1, 4, ''N'', ''N'' From @Staff st 
	UNION
	Select st.StaffId, 6, 1, 5, ''N'', ''N'' From @Staff st
	UNION
	Select st.StaffId, 5, 1, 6, ''N'', ''N'' From @Staff st
	UNION
	Select st.StaffId, 9, 40, 1, ''N'', ''N'' From @Staff st
	UNION
	Select st.StaffId, 10, 40, 2, ''N'', ''N'' From @Staff st 
	UNION
	Select st.StaffId, 11, 40, 3, ''N'', ''N'' From @Staff st  
	

COMMIT
' 
END
GO
