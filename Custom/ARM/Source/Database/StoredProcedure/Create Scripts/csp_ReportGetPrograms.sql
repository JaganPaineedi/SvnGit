/****** Object:  StoredProcedure [dbo].[csp_ReportGetPrograms]    Script Date: 02/16/2013 12:23:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetPrograms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGetPrograms]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportGetPrograms]    Script Date: 02/22/2013 12:23:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create    procedure [dbo].[csp_ReportGetPrograms]
AS
/********************************************************************
Purpose:	Procedure to display all active programs. Written to use in Reports
         
    Modified By        Modified Date      Reason     
    ----------------------------------------------------------------     
    Gautam				02/16/2013        created     
         
     
    EXEC csp_ReportGetPrograms   
    **********************************************************************/ 
    
select NULL as ProgramId, '<All Programs>' as ProgramName
Union 
Select p.ProgramId, p.ProgramName as ProgramName
From Programs p 
Where isnull(p.RecordDeleted, 'N') ='N' and isnull(p.Active, 'N')= 'Y'
order by ProgramName, ProgramId

GO


