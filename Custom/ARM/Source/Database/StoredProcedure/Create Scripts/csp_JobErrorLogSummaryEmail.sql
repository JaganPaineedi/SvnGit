/****** Object:  StoredProcedure [dbo].[csp_JobErrorLogSummaryEmail]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobErrorLogSummaryEmail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobErrorLogSummaryEmail]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobErrorLogSummaryEmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_JobErrorLogSummaryEmail]

as


Declare @RunDate datetime

set @RunDate = convert(varchar(20), dateadd(dd, -1, getdate() ), 101)



Create Table #ErrorLogDetail
(TempId  int identity,
 ErrorMessage varchar(max),
 ErrorDate datetime
)

Create Table #ErrorLogSummary
(ErrorDate datetime,
 MessageText varchar(max)
)


--
--Declare Variables for Loops
--
            Declare @TempList Varchar(7900)
            Declare @TempId   int
            Declare @MaxTempId int

--
-- Find Error List
--
Set @TempList = NULL
Set @TempId = 0
set @MaxTempId = NULL



Insert into #ErrorLogDetail
(ErrorMessage ,
 ErrorDate 
)

select  ''Count: '' +  convert(char(15), COUNT(*)) +   
 substring(CONVERT(varchar(max), errormessage), PATINDEX(''%message%'', CONVERT(varchar(max), errormessage)), 10000 ) ,
 CONVERT(varchar(20), CreatedDate, 101)

from errorlog
where createddate >= @RunDate
and CreatedDate <= DATEADD(dd, 1, @RunDate)
group by substring(CONVERT(varchar(max), errormessage), PATINDEX(''%message%'', CONVERT(varchar(max), errormessage)), 10000 ),  CONVERT(varchar(20), CreatedDate, 101)
order by  COUNT(*)  desc




            --Find Diangosis in temp table for while loop
            Set @MaxTempId = (Select Max(TempId) From #ErrorLogDetail)

            --Begin Loop to create Allergy List
            While @TempId <= @MaxTempId
            Begin
                  Set @TempList = isnull(@TempList, '''') + 
                        case when @TempId <> 1 then CHAR(10) + CHAR(13) + 
                        ''_______________________________________''
                        +CHAR(10) + CHAR(13) else '''' end + 
                        (select isnull(ErrorMessage, '''')
                        From #ErrorLogDetail t
                        Where t.TempId = @TempId)
                  Set @TempId = @TempId + 1
            --End Loop
             End            

			Insert Into #ErrorLogSummary
			(ErrorDate,
			 MessageText
			 )
			values
			(@RunDate, @TempList) 
			 
			


			set @TempList = NULL



			

If exists
(Select 1 from #ErrorLogSummary
 where isnull(ErrorDate, ''1/1/1900'') = @RunDate
)
Begin


Insert Into CustomEmailMessages
( FromAddress, ToAddress, SubjectLine, MessageBody)

select
''ErrorLogSummary@summitpointe.org'',
 ''djh@summitpointe.org'',
''RWD - Error Log Summary '' + CONVERT(varchar(20), @RunDate, 101),
''Error log summary: '' + 
char(10) + char(13) + char(10) + char(13) + 
MessageText
From #ErrorLogSummary




End




			drop table #ErrorLogDetail
			drop table #ErrorLogSummary
' 
END
GO
