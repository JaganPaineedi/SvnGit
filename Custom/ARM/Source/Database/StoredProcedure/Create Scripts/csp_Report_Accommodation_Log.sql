/****** Object:  StoredProcedure [dbo].[csp_Report_Accommodation_Log]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Accommodation_Log]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Accommodation_Log]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Accommodation_Log]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Accommodation_Log]
@startdate datetime,
@enddate datetime
AS
--*/	
	  --select * from CustomClients where AccommodationRequested is not null
	  --select * from Clients where ClientId=123810
--/*
--declare @startdate datetime,
--@enddate datetime

----record deleted
--select @startdate=''2013-1-28'',
--@enddate = ''2013-3-09''
--*/	
-- =============================================
-- Author:		<Ryan Mapes>
-- Create date: <03/27/13>
-- Description:	<For WO: 28027. Pulls the accomidation log from customclients by date.>
-- =============================================


SELECT c.LastName + '', '' + c.FirstName as ''Client Name''
		,cc.[ClientId]
      ,[AccommodationRequested]
      ,[AccDateRequested]
      ,CASE when cc.RequestAccommodated = ''N''
      then ''No''
      
      when cc.RequestAccommodated = ''Y''
      then ''Yes''
     
     when cc.RequestAccommodated is NULL
     then ''None Selected''

     end as ''Request Accommodated''
      
    ,CASE when cc.AccommodationType = ''P''
    then ''Permanent''

    when cc.AccommodationType = ''T''
    then ''Temporary''

    when cc.AccommodationType IS NULL
    then ''None Selected''

    end as ''Accommodation Type''
    
      ,[AccDateBegun]
      ,cc.StaffResponsible
      ,s.LastName + '', '' + s.FirstName + '' '' + ISNULL(s.SigningSuffix,'''') as ''Staff Name''FROM [HarborStreamlineProd].[dbo].[CustomClients] cc
  
join clients c
on c.ClientId = cc.ClientId
and ISNULL(c.RecordDeleted,''N'')<>''Y''

join Staff s
on s.StaffId = cc.StaffResponsible
and ISNULL(s.RecordDeleted,''N'')<>''Y''

where @startdate < cc.AccDateRequested
AND dateadd(dd, 1, @enddate) >= cc.AccDateRequested
and ISNULL(cc.RecordDeleted,''N'')<>''Y''
and c.Active like ''Y''

order by [AccDateRequested]
' 
END
GO
