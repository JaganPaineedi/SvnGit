/****** Object:  StoredProcedure [dbo].[csp_SCGetAllGroups]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetAllGroups]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetAllGroups]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetAllGroups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[csp_SCGetAllGroups]  
as  
begin  
 Select	GroupId,
		GroupName,
		GroupCode 
 from	Groups 
 where	isnull(RecordDeleted,''n'')=''n''  
		and Active=''Y''
end

' 
END
GO
