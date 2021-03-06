/****** Object:  StoredProcedure [dbo].[csp_JobUpdateVerbalOrdersForNonStaff]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobUpdateVerbalOrdersForNonStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobUpdateVerbalOrdersForNonStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobUpdateVerbalOrdersForNonStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_JobUpdateVerbalOrdersForNonStaff]

as

/*
Modified By		Modified Date	Reason
avoss			06.17.2010		Created

*/
declare @GoDate datetime
select @GoDate = ''6/15/2010''--dateadd(dd,1,dbo.RemoveTimestamp(getdate()))


	update cms
	set cms.VerbalOrderApproved=''Y''
	from ClientMedicationScripts cms with (nolock)
	join clients c with (nolock) on c.ClientId = cms.ClientId
	join staff s with (nolock) on s.StaffId = cms.OrderingPrescriberID
	where cms.createdDate >= @GoDate
	and isnull(VerbalOrderApproved,''N'')=''N''
	and s.Usercode <> cms.CreatedBy
	and s.StaffID in ( 971, 991 )
' 
END
GO
