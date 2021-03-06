/****** Object:  StoredProcedure [dbo].[csp_RDLSearchClientByFullSSN]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSearchClientByFullSSN]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSearchClientByFullSSN]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSearchClientByFullSSN]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_RDLSearchClientByFullSSN]
/*
Procedure: csp_RDLSearchClientByFullSSN
Purpose: Simple report to search for SSN match on client.  Returns rows where any part of the SSN matches the input parameter.
Created: 2012.11.20 - t. remisoski
Modifications:
*/
	@SearchSSN varchar(20)
as

select c.ClientId, c.LastName, c.FirstName, c.DOB, c.Sex, c.SSN, c.Active
from dbo.Clients as c
where c.SSN like ''%'' + REPLACE(replace(RTRIM(LTRIM(@SearchSSN)), '' '', ''''), ''-'', '''') + ''%''
and ISNULL(c.RecordDeleted, ''N'') <> ''Y''
order by LastName, FirstName, DOB, ClientId

' 
END
GO
