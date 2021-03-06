/****** Object:  StoredProcedure [dbo].[csp_JobCustomBugTrackingSummaryEmail]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCustomBugTrackingSummaryEmail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobCustomBugTrackingSummaryEmail]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCustomBugTrackingSummaryEmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_JobCustomBugTrackingSummaryEmail]

as


Declare @RunDate datetime

set @RunDate = convert(varchar(20), dateadd(dd, -1, getdate() ), 101)



Create Table #BugTrackingDetail
(TempId  int identity,
 ErrorMessage varchar(max),
 ErrorDate datetime
)

Create Table #BugTrackingSummary
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



Insert into #BugTrackingDetail
(ErrorMessage ,
 ErrorDate 
)

select  ''Count: '' +  convert(char(15), COUNT(*)) +   
 substring(Description, 1, 50) ,
 CONVERT(varchar(20), CreatedDate, 101)

from CustomBugTracking
where createddate >= @RunDate
and CreatedDate <= DATEADD(dd, 1, @RunDate)
group by  substring(Description, 1, 50),  CONVERT(varchar(20), CreatedDate, 101)
order by  COUNT(*)  desc, substring(Description, 1, 50)




            --Find Diangosis in temp table for while loop
            Set @MaxTempId = (Select Max(TempId) From #BugTrackingDetail)

            --Begin Loop to create Allergy List
            While @TempId <= @MaxTempId
            Begin
                  Set @TempList = isnull(@TempList, '''') + 
                        case when @TempId <> 1 then CHAR(10) + CHAR(13)  
                         else '''' end + 
                        (select isnull(ErrorMessage, '''')
                        From #BugTrackingDetail t
                        Where t.TempId = @TempId)
                  Set @TempId = @TempId + 1
            --End Loop
             End            

			Insert Into #BugTrackingSummary
			(ErrorDate,
			 MessageText
			 )
			values
			(@RunDate, @TempList) 
			 
			


			set @TempList = NULL



			

If exists (Select 1 from #BugTrackingSummary
			where isnull(ErrorDate, ''1/1/1900'') = @RunDate
			and MessageText is not null
			)
	Begin


	Insert Into CustomEmailMessages
	( FromAddress, ToAddress, SubjectLine, MessageBody)

	select
	''BugTrackingSummary@summitpointe.org'',
	 ''djh@summitpointe.org'',
	''RWD - Bug Tracking Summary '' + CONVERT(varchar(20), @RunDate, 101),
	''Bug tracking summary: '' + 
	char(10) + char(13) + char(10) + char(13) + 
	MessageText
	From #BugTrackingSummary




	End




			drop table #BugTrackingDetail
			drop table #BugTrackingSummary
' 
END
GO
