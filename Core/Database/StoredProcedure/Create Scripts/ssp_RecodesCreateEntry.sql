if object_id('ssp_RecodesCreateEntry', 'P') is not null
	drop procedure ssp_RecodesCreateEntry
go

create procedure ssp_RecodesCreateEntry @RecodeCategoryCode varchar(100)      
,                                       @IntegerCodeId int                    
,                                       @CharacterCodeId varchar(100)         
,                                       @CodeName varchar(100)                
,                                       @FromDate datetime                    
,                                       @ToDate datetime                       = null
,                                       @IntegerRangeValueStart int            = null
,                                       @IntegerRangeValueEnd int              = null
,                                       @DecimalRangeValueStart decimal(19,6)  = null
,                                       @DecimalRangeValueEnd decimal(19,6)    = null
,                                       @CharacterRangeValueStart varchar(255) = null
,                                       @CharacterRangeValueEnd varchar(255)   = null
,                                       @UseForNonMatchedEntry char(1)         = null
,                                       @TranslationValue1 varchar(255)        = null
,                                       @TranslationValue2 varchar(255)        = null
/*------------------------------------------------------------------------------------------------------*/
/* Procedure: ssp_RecodesCreateEntry		   											    */
/*																				    */
/* Purpose: Create or update an entry in the Recodes table for a specific category.				    */
/* Parameters:																		    */
/*		  @RecodeCategoryCode varchar(100) - Category code associated to the recode.			    */      
/*		  @IntegerCodeId int - Integer code value for recode.								    */      
/*		  @CharacterCodeId varchar(100) - Character code value for recode.					    */      
/*		  @CodeName varchar(100) - CodeName for recode									    */           
/*		  @FromDate datetime  - recode effective from date								    */                  
/*		  @ToDate datetime - recode effective to date									    */
/*		  @IntegerRangeValueStart int - for range based recodes, beginning of range			    */
/*		  @IntegerRangeValueEnd int -  for range based recodes, end of range					    */
/*		  @DecimalRangeValueStart decimal(19,6)  - for range based recodes, beginning of range	    */
/*		  @DecimalRangeValueEnd decimal(19,6) - for ranged based recodes, end of range			    */
/*		  @CharacterRangeValueStart varchar(255) - for range based recodes, beginning of range	    */
/*		  @CharacterRangeValueEnd varchar(255) - for range based recodes, beginning of range		    */
/*		  @UseForNonMatchedEntry char(1) - If 'Y', use this recode for a non matched range entry.	    */
/*		  @TranslationValue1 varchar(255) - translation value 1							    */
/*		  @TranslationValue2 varchar(255) - translation value 2							    */
/*																				    */
/* Returns: 0 on success, -1 on falure.													    */
/*																				    */
/* Revision History:																    */
/*	   2016-06-27 - T.Remisoski - Created.												    */
/*------------------------------------------------------------------------------------------------------*/
as


	declare @RecodeCategoryId int

	select @RecodeCategoryId = RecodeCategoryId
	from RecodeCategories
	where CategoryCode = @RecodeCategoryCode and isnull(RecordDeleted, 'N') = 'N'

	if @RecodeCategoryId is null
	begin
		raiserror('ssp_RecodesCreateUpdate: Recode category code does not exist', 16, 1)
		return -1
	end

	if exists (
		select *
		from Recodes as rc
		where rc.RecodeCategoryId = @RecodeCategoryId
			and ((@IntegerCodeId is null and rc.IntegerCodeId is null) or (@IntegerCodeId = rc.IntegerCodeId))
			and ((@CharacterCodeId is null and rc.CharacterCodeId is null) or (@CharacterCodeId = rc.CharacterCodeId))
			and ((@FromDate is null and rc.FromDate is null) or (@FromDate = rc.FromDate))
			and isnull(rc.RecordDeleted, 'N') = 'N'
		)
	begin
		update rc
		set IntegerCodeId            = @IntegerCodeId
		,   CharacterCodeId          = @CharacterCodeId
		,   CodeName                 = @CodeName
		,   FromDate                 = @FromDate
		,   ToDate                   = @ToDate
		,   RecodeCategoryId         = @RecodeCategoryId
		,   IntegerRangeValueStart   = @IntegerRangeValueStart
		,   IntegerRangeValueEnd     = @IntegerRangeValueEnd
		,   DecimalRangeValueStart   = @DecimalRangeValueStart
		,   DecimalRangeValueEnd     = @DecimalRangeValueEnd
		,   CharacterRangeValueStart = @CharacterRangeValueStart
		,   CharacterRangeValueEnd   = @CharacterRangeValueEnd
		,   UseForNonMatchedEntry    = @UseForNonMatchedEntry
		,   TranslationValue1        = @TranslationValue1
		,   TranslationValue2        = @TranslationValue2
		from Recodes as rc
		where rc.RecodeCategoryId = @RecodeCategoryId
			and ((@IntegerCodeId is null and rc.IntegerCodeId is null) or (@IntegerCodeId = rc.IntegerCodeId))
			and ((@CharacterCodeId is null and rc.CharacterCodeId is null) or (@CharacterCodeId = rc.CharacterCodeId))
			and ((@FromDate is null and rc.FromDate is null) or (@FromDate = rc.FromDate))
			and isnull(rc.RecordDeleted, 'N') = 'N'

	end
	else
	begin

		insert into Recodes ( IntegerCodeId,  CharacterCodeId,  CodeName,  FromDate,  ToDate,  RecodeCategoryId,  IntegerRangeValueStart,  IntegerRangeValueEnd,  DecimalRangeValueStart,  DecimalRangeValueEnd,  CharacterRangeValueStart,  CharacterRangeValueEnd,  UseForNonMatchedEntry,  TranslationValue1,  TranslationValue2  )
		values              ( @IntegerCodeId, @CharacterCodeId, @CodeName, @FromDate, @ToDate, @RecodeCategoryId, @IntegerRangeValueStart, @IntegerRangeValueEnd, @DecimalRangeValueStart, @DecimalRangeValueEnd, @CharacterRangeValueStart, @CharacterRangeValueEnd, @UseForNonMatchedEntry, @TranslationValue1, @TranslationValue2 )
	end

	return 0
go