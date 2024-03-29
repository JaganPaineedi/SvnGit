/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentDischargeGoals]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentDischargeGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentDischargeGoals]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentDischargeGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_RDLCustomDocumentDischargeGoals]
	@DocumentVersionId int
/****************************************************************************/
 --Stored Procedure: dbo.csp_RDLCustomDocumentDischargeGoals
 --Copyright: 2007-2012 Streamline Healthcare Solutions,  LLC
 --Creation Date: 2012.01.18

 --Purpose:  Sub stored procedure for the Harbor discharge RDL.

 --Output Parameters: None

 --Return:   data tables:
 
 --Called By: SmartCare

 --Calls:

 --Data Modifications: None

 --Updates:
 --  Date			Author			Purpose
 --  2012.01.18		T. Remisoski	Created.
 /****************************************************************************/
as
select
	GoalNumber,
	GoalText,
	case GoalRatingProgress 
		when ''D'' then ''Deterioration''
		when ''N'' then ''No change''
		when ''S'' then ''Some improvement''
		when ''M'' then ''Moderate immprovement''
		when ''A'' then ''Achieved''
	end as GoalRatingProgress
from dbo.CustomDocumentDischargeGoals as dg
where dg.DocumentVersionId = @DocumentVersionId
and ISNULL(dg.RecordDeleted, ''N'') <> ''Y''
order by dg.GoalNumber


' 
END
GO
