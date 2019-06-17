/****** Object:  StoredProcedure [dbo].[CSP_GetMaxViewId]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CSP_GetMaxViewId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CSP_GetMaxViewId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CSP_GetMaxViewId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[CSP_GetMaxViewId]  
as  
begin  
select MAX(MultiStaffViewId) from MultiStaffViews  
end
' 
END
GO
