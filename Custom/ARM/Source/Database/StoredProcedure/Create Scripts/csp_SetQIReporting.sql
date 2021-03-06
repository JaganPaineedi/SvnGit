/****** Object:  StoredProcedure [dbo].[csp_SetQIReporting]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SetQIReporting]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SetQIReporting]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SetQIReporting]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_SetQIReporting]
/********************************************************************************
-- Stored Procedure: dbo.csp_SetQIReporting  
--
-- Copyright: 2009 Streamline Healthcate Solutions
--
-- Purpose: used set QI reporting fields
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 08.05.2009  SFarber     Created.      
*********************************************************************************/
as

insert into CustomStateReporting (ClientId)
select c.ClientId
  from Clients c
 where isnull(c.RecordDeleted, ''N'') = ''N''
   and (c.Active = ''Y'' or 
        exists(select * 
                 from Services s
                where s.ClientId = c.ClientId
                  and s.Status <> 76
                  and s.DateOfService >= ''10/1/2008''
                  and isnull(s.RecordDeleted, ''N'') = ''N''))
   and not exists(select *
                    from CustomStateReporting r
                   where r.ClientId = c.ClientId
                     and isnull(r.RecordDeleted, ''N'') = ''N'')

-- If a client is an adult, these fields should be defaulted to No
update r
   set ChildFIAAbuse = ''N'',
       ChildFIAOther = ''N'',
       EarlyOnProgram = ''N'',
       WrapAround = ''N''
  from CustomStateReporting r
       join Clients c on c.ClientId = r.ClientId
 where dbo.GetAge(c.DOB, getdate()) >= 18
   and isnull(r.RecordDeleted, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N''
   and (isnull(r.ChildFIAAbuse, ''Y'') = ''Y'' or isnull(r.ChildFIAOther, ''Y'') = ''Y'' or
        isnull(r.EarlyOnProgram, ''Y'') = ''Y'' or isnull(r.WrapAround, ''Y'') = ''Y'')
' 
END
GO
