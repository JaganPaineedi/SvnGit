/****** Object:  StoredProcedure [dbo].[ssp_CMPreviousEvents]    Script Date: 11/18/2011 16:25:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMPreviousEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMPreviousEvents]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMPreviousEvents]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE [dbo].[ssp_CMPreviousEvents]
(    
	@ClientID  int    ,
	@EventId int	,
	@EventDateTime varchar(40)	,
	@CallingScreen Varchar(30)
)    
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_PreviousEvents             */                
/* Copyright: 2006 Provider Claim Management System   UM          */                
/* Creation Date: 24/03/2006                                   */                
/*                                                                   */                
/* Purpose: Checks whether Provider exists in Claims, Authorizations, ProviderRefunds, Contracts before deletion   */               
/*                                                                   */              
/* Input Parameters: @ClientID int,   @EventId int        */              
/*                                                                   */                
/* Output Parameters:                                */                
/*                                                                   */                
/* Return: */
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/* Updates:                                                          */                
/*  Date         Author             Purpose                                    */                
/*  24/03/2006   Atul     Created                                    */                
/*********************************************************************/     
 AS
Begin
	Declare @PreeScreenId int
	Declare @PreScreenEventDateTime varchar(40)
	Declare @SecondPreeScreenId int
	Declare @SecondPreScreenEventDateTime varchar(40)
	Declare @NextEventId int
	Declare @EventTypeID int
	Declare @EventName varchar(100)

	Declare @FirstLastName varchar(60)
	Declare @EventDate Datetime
	Declare @Comment varchar(8000)
	Declare @ContractDate varchar(40)

	Set @SecondPreeScreenId = 0
	Set @SecondPreScreenEventDateTime = ''1/1/1900''
	Set @ContractDate = @EventDateTime
	Declare @StrAuthorizationComment  Varchar(2000)
	Declare @AuthorizationId int
	Declare @ClientName Varchar(200)

	Declare @size int
 	DECLARE @ptrval binary(16)
	Declare @ptrtoadd binary(16)
	Declare @StringBillCodeProvider Varchar(500)
	Declare @StringLineToAdd Varchar(500)
	Declare @AuthoCommentLength int 

			Select @ClientName =   IsNull(LastName,'''') + '' '' +   IsNull(FirstName,'''')    From Clients Where ClientId = @ClientID And isnull(RecordDeleted,''N'')=''N''

			--Checking For Errors
				If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End    

	if ( @EventId = -1)
		begin
			Select @PreeScreenId = PreScreens.EventId ,@PreScreenEventDateTime = EventDateTime from Events,PreScreens 
				Where  Events.EventId = PreScreens.EventId  And ClientId= @ClientID  And HospitalizationStatus = 2181 And isnull(PreScreens.RecordDeleted,''N'')=''N''
		end
	else
		begin
			Select @PreScreenEventDateTime =  Events.EventDateTime,  @PreeScreenId = Events.EventId From Events Where 
			EventId = ( SELECT    ConcurrentReviews.PreScreenEventId
			FROM         Events INNER JOIN    ConcurrentReviews ON Events.EventId = ConcurrentReviews.EventId
			WHERE     (dbo.Events.ClientId = @ClientID) AND (dbo.ConcurrentReviews.EventId = @EventId) AND (ISNULL(dbo.Events.RecordDeleted, ''N'') = ''N'')
			 AND (ISNULL(dbo.ConcurrentReviews.RecordDeleted, ''N'') = ''N'')  )
		end

	Declare @StrCondition Varchar(2000)
	Declare @StrConditionSecond Varchar(2000)

	Set @StrCondition = ''   And EventId >= '' + Cast( @PreeScreenId As Varchar(10))
	if ( @CallingScreen = ''ConcurrentReview'' )
	Begin
		if ( @EventId = -1)
			Begin
				SELECT  Top 1 @SecondPreScreenEventDateTime = EventDateTime,@SecondPreeScreenId = Events.EventId 
				FROM Events, ConcurrentReviews
				Where Events.EventId = ConcurrentReviews.EventId And 
				ClientID = @ClientID --And ConcurrentReviews.EventId > @PreeScreenId 
				And ConcurrentReviews.PreScreenEventId = @PreeScreenId   
				And Events.EventTypeId = 102  And  IsNull(Events.RecordDeleted,''N'')=''N''  And  IsNull(ConcurrentReviews.RecordDeleted,''N'')=''N''  
				Order By Events.EventId Desc
			End
		else
			Begin
				Set @SecondPreeScreenId =  @EventId
				Set @SecondPreScreenEventDateTime = @EventDateTime
			End

			--Checking For Errors
			If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End        
		if ( @SecondPreeScreenId = 0)
			Begin 
				Set @SecondPreeScreenId =  @EventId
				Set @SecondPreScreenEventDateTime = @EventDateTime			
			End
		if  ( @SecondPreeScreenId != 0 )
			Begin 
				if (@SecondPreeScreenId = -1)
					Set @StrCondition = ''  And EventId >= ''  +  Cast(@PreeScreenId As Varchar(10))	
				else				
					Set @StrCondition = ''  And EventId >= ''  +  Cast(@PreeScreenId As Varchar(10))	+  ''  And EventId  < ''  +  Cast(@SecondPreeScreenId As Varchar(10))
									
				--Set  @StrConditionSecond =  ''  And convert(datetime,Events.EventDateTime,101)  >= ''''''  + @PreScreenEventDateTime +  ''''''  And convert(datetime,Events.EventDateTime,101)  <=''''''  + @ContractDate  + ''''''''			
				-- Changed on 07/03/2006 (Bhupinder Bajwa)
				if (@EventId = -1)
					Set  @StrConditionSecond =  '' And convert(datetime,Events.EventDateTime,101)  >= ''''''  + @PreScreenEventDateTime +  ''''''  And convert(datetime,Events.EventDateTime,101)  <=''''''  + @ContractDate  + ''''''''			
				else					
					Set  @StrConditionSecond =  '' And EventId <> '' + Cast(@SecondPreeScreenId As Varchar(10)) + '' And convert(datetime,Events.EventDateTime,101)  >= ''''''  + @PreScreenEventDateTime +  ''''''  And convert(datetime,Events.EventDateTime,101)  <=''''''  + @ContractDate  + ''''''''			
			End
	End

		--Checking For Errors
		If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End                                   	
	
	Create Table #PreviousEvents (EventId int,  FirstLastName Varchar(60), EventName Varchar(500), EventDate DateTime,Comment text ,CreatedBy int , Status int , EventTypeId int )

		--Checking For Errors
		If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End                                   	

	Declare @SqlString nvarchar(4000)
	Set  @SqlString  = ''Select  EventId, Events.EventTypeID, EventTypes.EventName  From Events ,EventTypes Where  Events.EventTypeId in (101,102,103)   And Events.EventTypeId = EventTypes.EventTypeId And  IsNull(EventTypes.RecordDeleted,''''N'''')=''''N''''  And  IsNull(Events.RecordDeleted,''''N'''')=''''N''''  And  ClientID = ''

		if ( @CallingScreen = ''ConcurrentReview'' )
			Begin
				-- Changed on 07/03/2006 (Bhupinder Bajwa)
				--Set @SqlString = ''insert into #tab  '' + @SqlString + ''  '' +  Cast(@ClientID As Varchar(10))  + ''   '' +  @StrCondition  +  ''  Order By EventDateTime''
				Set @SqlString = ''insert into #tab  '' + @SqlString + ''  '' +  Cast(@ClientID As Varchar(10))  + ''   '' +  @StrConditionSecond  +  ''  Order By EventDateTime''
			end
		else
			Begin
				Set @SqlString = ''insert into #tab  '' + @SqlString + ''  '' +  Cast(@ClientID As Varchar(10))  + ''  '' + +  ''  Order By EventDateTime''
			end
		
			If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End   
	create table #tab (EventId int, EventTypeID int, EventName varchar(5000))

				exec  SP_EXECUTESQL @SqlString 
				
	Set  @SqlString  = ''Select  EventId, Events.EventTypeID, EventTypes.EventName  From Events ,EventTypes Where  ( Events.EventTypeId = 104  Or Events.EventTypeId = 105 )  And Events.EventTypeId = EventTypes.EventTypeId And  IsNull(EventTypes.RecordDeleted,''''N'''')=''''N''''  And  IsNull(Events.RecordDeleted,''''N'''')=''''N''''  And  ClientID = ''

		
		if ( @CallingScreen = ''ConcurrentReview'' )
			Begin
				--Set @SqlString = ''insert into #tab  '' + @SqlString + ''  '' +  Cast(@ClientID As Varchar(10))  + ''   '' + @StrConditionSecond + ''  Order By EventDateTime''
				-- Changed on 07/03/2006 (Bhupinder Bajwa)
				Set @SqlString = ''insert into #tab  '' + @SqlString + ''  '' +  Cast(@ClientID As Varchar(10))  + ''   '' +  '' and convert(datetime,Events.EventDateTime,101)  <= ''''''  + @ContractDate  + '''''''' +  ''  Order By EventDateTime''
			end
		else
			Begin
				Set @SqlString = ''insert into #tab  '' + @SqlString + ''  '' +  Cast(@ClientID As Varchar(10))  + ''  '' + +  ''  Order By EventDateTime''
			end
				exec  SP_EXECUTESQL @SqlString 
	Declare TotalEvents Cursor for select   * from #tab 
		--Checking For Errors
		If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End                                  	
	Open TotalEvents
		--Checking For Errors
		If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End                                  	
	Fetch Next from TotalEvents into @NextEventId,@EventTypeID,@EventName
		--Checking For Errors
		If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End                                   	

	While (@@Fetch_Status = 0) 
	Begin
		If(@EventTypeID = 101 )
			Begin

				insert into #PreviousEvents Select Events.EventId, IsNull(PreScreenerFirstName,'''') + '' '' + IsNull(PreScreenerLastName,'''') ,@EventName ,  EventDateTime ,   PresentingProblem ,  Users.UserId, Events.Status,101
					From PreScreens,Events,Users  Where PreScreens.EventId = Events.EventId And isnull(PreScreens.RecordDeleted,''N'')=''N''
					And isnull(Events.RecordDeleted,''N'')=''N''   And PreScreens.EventId =  @NextEventId And  Users.UserCode = Events.CreatedBy 
				--Checking For Errors
				If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End                                   	
			End
		If(@EventTypeID = 102 )
			Begin

				insert into #PreviousEvents Select Events.EventId,  IsNull(ReviewerFirstName,'''') + '' '' + IsNull(ReviewerLastName,'''') , ''Review'' , EventDateTime ,   ClinicalUpdate , Users.UserId, Events.Status,102
					From ConcurrentReviews, Events,Users  Where ConcurrentReviews.EventId = Events.EventId And isnull(ConcurrentReviews.RecordDeleted,''N'')=''N''
					And isnull(Events.RecordDeleted,''N'')=''N'' And ConcurrentReviews.EventId =  @NextEventId  And  Users.UserCode = Events.CreatedBy 
				--Checking For Errors
				If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End                                   	
			End
		If(@EventTypeID = 103 )
			Begin         	

				insert into #PreviousEvents  Select Events.EventId, IsNull(ContactFirstName,'''') + '' '' + IsNull(ContactLastName,'''') , @EventName , EventDateTime ,   DischargeComment , Users.UserId, Events.Status,103
					From DischargeEvents,Events,Users Where DischargeEvents.EventId = Events.EventId And isnull(DischargeEvents.RecordDeleted,''N'')=''N''
					And isnull(Events.RecordDeleted,''N'')=''N'' And DischargeEvents.EventId =  @NextEventId   And  Users.UserCode = Events.CreatedBy 
				--Checking For Errors
				If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End                                   	
			End
		If(@EventTypeID = 104 )
			Begin             	
				insert into #PreviousEvents  Select Events.EventId,  IsNull(ContactEvents.FirstName,'''') + '' '' + IsNull(ContactEvents.LastName,'''') , @EventName, EventDateTime ,   ContactNote , Users.UserId, Events.Status,104
					From ContactEvents,Events,Users Where ContactEvents.EventId = Events.EventId And isnull(ContactEvents.RecordDeleted,''N'')=''N''
					And isnull(Events.RecordDeleted,''N'')=''N'' And ContactEvents.EventId =  @NextEventId    And  Users.UserCode = Events.CreatedBy 
				--Checking For Errors
				If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End                                   		
			End
		If(@EventTypeID = 105 )
			Begin    
				Set @StringBillCodeProvider = '''' 
				insert into #PreviousEvents  Select Events.EventId, @ClientName , ''Authorization'', EventDateTime ,  '' '' , Users.UserId, Events.Status,105
					From  Events,Users Where Events.EventId = @NextEventId And isnull(Events.RecordDeleted,''N'')=''N''     And  Users.UserCode = Events.CreatedBy 
				Declare @AutoEve int
				Set  @AutoEve = 0
				Select @AutoEve = EventId From EventAuthorizations Where EventId = @NextEventId And isnull(RecordDeleted,''N'')=''N''
			if (@AutoEve >0)
			Begin

				Set @StrAuthorizationComment = '' ''
					Set @AuthoCommentLength = 0
					Set @size = 0
					SELECT @size = datalength(Comment) from #PreviousEvents where EventId = @NextEventId
					if (@size  > 0)
					Print @size
					Begin
						SELECT @ptrtoadd = TEXTPTR(Note) from EventAuthorizations where EventId = @NextEventId And isnull(RecordDeleted,''N'')=''N''
						SELECT @ptrval = textptr(Comment) from #PreviousEvents where EventId = @NextEventId
						UPDATETEXT #PreviousEvents.Comment @ptrval @size 0 EventAuthorizations.Note  @ptrtoadd
						UPDATETEXT #PreviousEvents.Comment @ptrval @size 0 '' ''
					End
				Declare AuthorizationCommentCursor  Cursor for select  pa.ProviderAuthorizationId from ProviderAuthorizations pa inner join ProviderAuthorizationDocuments pad on pa.ProviderAuthorizationDocumentId=pad.ProviderAuthorizationDocumentId  Where isnull(pa.RecordDeleted,''N'')=''N'' And isnull(pad.RecordDeleted,''N'')=''N''
				Open AuthorizationCommentCursor
				Fetch Next from AuthorizationCommentCursor into @AuthorizationId
				While (@@Fetch_Status = 0) 
				Begin
					 Set @AuthoCommentLength = 0
					Set @size = 0
					SELECT @size = datalength(Comment) from #PreviousEvents where EventId = @NextEventId
					SELECT @AuthoCommentLength = 1 from ProviderAuthorizations where ProviderAuthorizationId = @AuthorizationId And Comment Is Not Null And isnull(RecordDeleted,''N'')=''N''
					if (@AuthoCommentLength  = 1)
					Begin
						SELECT @ptrtoadd = TEXTPTR(Comment) from ProviderAuthorizations where ProviderAuthorizationId = @AuthorizationId And isnull(RecordDeleted,''N'')=''N''
						SELECT @ptrval = textptr(Comment) from #PreviousEvents where EventId = @NextEventId
						UPDATETEXT #PreviousEvents.Comment @ptrval @size 0 ProviderAuthorizations.Comment  @ptrtoadd
						UPDATETEXT #PreviousEvents.Comment @ptrval @size 0 '' ''
					End
					SELECT  @StringLineToAdd = ISNULL(BillingCodes.BillingCode,'''') + '' '' + ISNULL(convert(Varchar(10),(case when ProviderAuthorizations.Status=2041 then convert(int,ProviderAuthorizations.UnitsRequested) else convert(int,ProviderAuthorizations.UnitsApproved) end )),'''') + '' '' + ISNULL(Providers.ProviderName,'''') + '' '' + 
						ISNULL(convert(Varchar(10),(case when ProviderAuthorizations.Status=2041 then ProviderAuthorizations.StartDateRequested else ProviderAuthorizations.StartDate end),101),'''') + '' '' + 
						ISNULL(convert(Varchar(10),(case when ProviderAuthorizations.Status=2041 then ProviderAuthorizations.EndDateRequested else ProviderAuthorizations.EndDate end),101),'''') 
						FROM ProviderAuthorizations INNER JOIN BillingCodes ON ProviderAuthorizations.BillingCodeId = BillingCodes.BillingCodeId INNER JOIN
						Providers ON ProviderAuthorizations.ProviderId = Providers.ProviderId And ProviderAuthorizations.ProviderAuthorizationId = @AuthorizationId And isnull(ProviderAuthorizations.RecordDeleted,''N'')=''N''  
						And isnull(BillingCodes.RecordDeleted,''N'')=''N'' And isnull(Providers.RecordDeleted,''N'')=''N''
					Set @StrAuthorizationComment = @StrAuthorizationComment + Char(10) + @StringLineToAdd
					Fetch Next from AuthorizationCommentCursor into @AuthorizationId 		
				End	

				Set @size = 0 
				SELECT @size = datalength(Comment) from #PreviousEvents where EventId = @NextEventId
				-- For changing Line after comment & adding BullingCode+ Provider +.........
				if ( @size >= 1)
				Begin
					Set @StringLineToAdd = '' '' + Char(10) + ''''
					SELECT @ptrval = textptr(Comment) from #PreviousEvents where EventId = @NextEventId
					UPDATETEXT #PreviousEvents.Comment @ptrval @size 0 @StringLineToAdd
					SELECT @ptrval = textptr(Comment) from #PreviousEvents where EventId = @NextEventId
					SELECT @size = datalength(Comment) from #PreviousEvents where EventId = @NextEventId
					UPDATETEXT #PreviousEvents.Comment @ptrval @size 0 @StrAuthorizationComment
				End
				Close AuthorizationCommentCursor
				Deallocate AuthorizationCommentCursor
			    End
			End		
		Fetch Next from TotalEvents into @NextEventId,@EventTypeID,@EventName		              	                       	
	End 
	Close TotalEvents
	Deallocate TotalEvents
	
		if ( @CallingScreen = ''ConcurrentReview'' )
			Begin
				Select  Top 20 EventDate as aaa, *  from #PreviousEvents Order By EventDate DESC
					--Checking For Errors
						If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End       
			end
		else
			Begin
				Select * from #PreviousEvents Order By EventDate DESC
					--Checking For Errors
						If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End       
			end

	--Checking For Errors
	If (@@error!=0)  Begin  RAISERROR  20006 ''ssp_PreviousEvents  : An Error Occured''   Return  End                                   	

End
' 
END
GO
