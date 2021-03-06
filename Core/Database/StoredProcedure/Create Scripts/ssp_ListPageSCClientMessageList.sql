/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCClientMessageList]    Script Date: 11/18/2011 16:25:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCClientMessageList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCClientMessageList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_ListPageSCClientMessageList]
@SessionId varchar(30),
@InstanceId int,
@PageNumber int,
@PageSize int,
@SortExpression varchar(100),
@StaffId int,
@ClientId int,
@FromDate datetime,
@ToDate datetime,
@OtherFilter int


/********************************************************************************
-- Stored Procedure: ssp_ListPageSCClientMessageList
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: used by  Client Message List Page
--
-- Updates:
-- Date					Author				Purpose
-- 03.1.2011			Priya				Created.
--28 Mar, 2012			By Rakesh-II		Task 592
--4 Feb 2013			Saurav Pande		Done w.r.t task #457 in Centrawellness-Bugs/Features put the ISNUll Check for a.SenderCopy
--22 April 2013			AmitSr				#99, Interact Support, Message, Go to message banner-- add a staff and add client-- uncheck the client box--make message and send. Log in as the staff--click on message and open and notice the client name is there and sent to client. This should not send to client. What & Why --Open Comment for Client Message is a.PartOfClientRecord='Y'
-- 5/18/2015			NJain				Added condition: AND ISNULL(ToStaffName, '') <> ''
-- 20/06/2016			Ravichandra			Removed the physical table ListPageClientMessages from SP
--											Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
--						 					108 - Do NOT use list page tables for remaining list pages (refer #107)	
-- 06/11/2016         Pradeep Kumar Yadav  What - Modify SP given alias name for column FromSystemDatabaseID
--                                          Why - For Task #1039 Harbor-Support
*********************************************************************************/
AS
BEGIN
BEGIN TRY

-- Min & Max range is 1753 to 9999 in SQL Server 2008
IF(ISNULL(@FromDate,'')= '')BEGIN  SET @FromDate = '1953-12-12 00:00:00.000' END
IF(ISNULL(@ToDate,'') = '')BEGIN  SET @ToDate = '9999-12-12 00:00:00.000' END


CREATE TABLE #ResultSet(
			MessageId int,
			[Status] varchar(50),
			FromStaffId int,
			FromStaffName varchar(100),
			ToStaffName    varchar(max),
			[Message] varchar(max),
			DateReceived datetime,
			ClientId int,
			ClientName  varchar(100),
			[Subject] varchar(700),
			Priority varchar(50),
			ReferenceId int,
			ReferenceName varchar(100),
			ReferenceScreenId int,
			ReferenceScreenType varchar(150),
			ReferenceDocumentCodeId int,
			RecordDeleted char(1),
			FromSystemStaffID int,
			FromSystemDatabaseID int,
			FromSystemStaffName varchar(50),
			ReferenceType int,
			ReferenceSystemDatabaseId int ,
			OtherRecipients varchar(2000)
			)


INSERT INTO #ResultSet(
			MessageId ,
			[Status],
			FromStaffId,
			FromStaffName ,
			[Message],
			DateReceived,
			ClientId ,
			ClientName ,
			[Subject] ,
			Priority,
			ReferenceId,
			ReferenceName,
			ReferenceScreenId,
			ReferenceScreenType,
			ReferenceDocumentCodeId,
			RecordDeleted,
			FromSystemStaffID ,
			FromSystemDatabaseID ,
			FromSystemStaffName,
			ReferenceType,
			ReferenceSystemDatabaseId,
			OtherRecipients,
			ToStaffName
		)
	SELECT
		a.MessageId,
		case when a.Unread='Y' then 'Not Read'  when a.Unread='N' then 'Read' end as [Status],
		case when a.FromStaffId IS not null then a.FromStaffId else a.FromSystemStaffId end as FromStaffId,
		case when a.FromStaffId IS not null then rtrim(c.LastName) + ', ' + rtrim(c.FirstName) else a.FromSystemStaffName end as FromStaffName,
		a.Message,
		a.DateReceived,
		a.ClientId,
		CASE WHEN ISNULL (a.ClientId,0) <> 0 THEN rtrim(e.LastName)+ ', ' +rtrim(e.FirstName) ELSE '' END as ClientName,
		a.Subject,
		f.CodeName as Priority ,
		a.ReferenceId,
		a.Reference as ReferenceName,
		CASE WHEN a.ReferenceType  = '5606' THEN '44' --Authorization Document
		When a.ReferenceType = '5603' and dCodes.ServiceNote='Y' then '29'
		WHEN a.ReferenceType='5602' then '75'   --Appeals Reference
		WHEN a.ReferenceType='5601' and a.Reference='Grievances' then '71' --Grievances
		WHEN a.ReferenceType='5601' and a.Reference='Inquiry' then '73' -- Inquiry
		WHEN a.ReferenceType='5607' then '77' --SecondOpinion Reference
		else Screens.ScreenId END AS ReferenceScreenId,
		CASE WHEN a.ReferenceType  = '5606' THEN '5761' --Andy type of Document Screen
		WHEN a.ReferenceType = '5603' THEN Screens.ScreenType
		WHEN a.ReferenceType='5602' then '5761'
		WHEN a.ReferenceType='5601' then '5761'
		WHEN a.ReferenceType='5607' then '5761'
		 else Screens.ScreenType END AS ReferenceScreenType,
		doc.DocumentId  as ReferenceDocumentCodeId,
		a.RecordDeleted ,
		a.FromSystemStaffId,
		a.FromSystemDatabaseId,
		a.FromSystemStaffName,

		a.ReferenceType,
		a.ReferenceSystemDatabaseId ,
		a.OtherRecipients,
		dbo.fn_FetchReceipientsName(a.MessageId)    as 'ToStaffName'
FROM Messages a
		left join Staff c on a.FromStaffId = c.StaffId and IsNull(c.RecordDeleted,'N')= 'N'
		--join Staff d on a.ToStaffId = d.StaffId and IsNull(d.RecordDeleted,'N')='N'
		LEft join Clients e on a.ClientId = e.ClientId and IsNull(e.RecordDeleted,'N')= 'N'
		left join GlobalCodes f on a.Priority = f.GlobalCodeId
		left join Documents doc on   doc.DocumentId= a.ReferenceId
		left join Screens on Screens.DocumentCodeId=doc.DocumentCodeId and ISNULL(screens.RecordDeleted, 'N') <> 'Y'
		left join DocumentCodes dCodes on dCodes.DocumentCodeId=Screens.DocumentCodeId
WHERE
		a.ClientId=@ClientId and IsNull(a.SenderCopy,'Y')= 'Y' --Added by saurav Pande w.r.t task #457
		--a.SenderCopy='Y'
		and (cast(convert(varchar(10),a.DateReceived,101) as datetime) >=@FromDate 
			 and cast(convert(varchar(10),a.DateReceived,101) as datetime) <=@ToDate
			)  
		--and (a.ToStaffId=@StaffId )
		and
		IsNull(a.RecordDeleted,'N') <> 'Y'
		--Open Comment for Client Message is a.PartOfClientRecord='Y'
		and a.PartOfClientRecord='Y'
		----Comment Below condition. By Rakesh-II , Task 592
		----and a.PartOfClientRecord='Y'
		AND ISNULL(dbo.fn_FetchReceipientsName(a.MessageId),'')<>'' -- Added 5/18/2015
		order by a.DateReceived Desc


;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT MessageId ,
					[Status],
					FromStaffId,
					FromStaffName ,
					[Message],
					DateReceived,
					ClientId ,
					ClientName ,
					[Subject] ,
					Priority,
					ReferenceId,
					ReferenceName,
					ReferenceScreenId,
					ReferenceScreenType,
					ReferenceDocumentCodeId,
					RecordDeleted,
					FromSystemStaffID ,
					FromSystemDatabaseID ,
					FromSystemStaffName,
					ReferenceType,
					ReferenceSystemDatabaseId,
					OtherRecipients,
					ToStaffName 
					,Count(*) OVER () AS TotalCount
					,row_number() over (order by case when @SortExpression= 'Status' then [Status] end,
                                                case when @SortExpression= 'Status desc' then [Status] end desc,
                                                case when @SortExpression= 'FromStaffName ' then FromStaffName end,
                                                case when @SortExpression= 'FromStaffName desc' then FromStaffName end desc,
                                                case when @SortExpression= 'DateReceived' then DateReceived end ,
                                                case when @SortExpression= 'DateReceived desc' then DateReceived end desc,


                                                case when @SortExpression= 'Subject' then [Subject] end ,
                                                case when @SortExpression= 'Subject desc' then [Subject] end desc,
                                                case when @SortExpression= 'Priority' then Priority end ,
                                                case when @SortExpression= 'Priority desc' then Priority end desc,
                                                case when @SortExpression= 'ReferenceName' then ReferenceName end ,
                                                case when @SortExpression= 'ReferenceName desc' then ReferenceName end desc,
												MessageId
												) as RowNumber        
							FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
			)		MessageId ,
					[Status],
					FromStaffId,
					FromStaffName ,
					[Message],
					DateReceived,
					ClientId ,
					ClientName ,
					[Subject] ,
					Priority,
					ReferenceId,
					ReferenceName,
					ReferenceScreenId,
					ReferenceScreenType,
					ReferenceDocumentCodeId,
					RecordDeleted,
					FromSystemStaffID ,
					FromSystemDatabaseID ,
					FromSystemStaffName,
					ReferenceType,
					ReferenceSystemDatabaseId,
					OtherRecipients,
					ToStaffName 
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT ISNULL(Count(*), 0)	FROM #FinalResultSet) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

			SELECT MessageId ,
					[Status],
					[Message],
					DateReceived,
					FromStaffId,
					FromStaffName ,
					ToStaffName ,
					ClientId ,
					ClientName ,
					[Subject] ,
					Priority,
					ReferenceId,
					ReferenceName,
					ReferenceScreenId,
					ReferenceScreenType,
					ReferenceDocumentCodeId,
					RecordDeleted,
					FromSystemStaffID ,
					FromSystemDatabaseID As FromSystemDatabaseId,
					FromSystemStaffName,
					ReferenceType,
					ReferenceSystemDatabaseId,
					OtherRecipients					
		FROM #FinalResultSet
		ORDER BY RowNumber	
	

END TRY

	BEGIN CATCH
		DECLARE @Error varchar(8000)
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())
			+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCClientMessageList')
			+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())
			+ '*****' + Convert(varchar,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16, -- Severity.
			1 -- State.
		);
	END CATCH                                                    
END 


