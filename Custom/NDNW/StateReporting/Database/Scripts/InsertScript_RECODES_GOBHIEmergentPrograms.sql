declare	@RecodeCategoryId int
declare	@CategoryCode varchar(100)			= 'GOBHIEmergentPrograms'		-- [New Category Code]
declare @CategoryDescription varchar(max)	= 'Oregon State Reporting for GOBHI: Programs for related Emergent care'	-- [Category Description]
declare	@EffectiveDate datetime				= '10/1/2015'					-- [Effective Date]
declare	@EndDate datetime					= null 							-- [End Date]
declare	@SourceTable varchar(100)			= 'Programs'					-- [Table referenced by Recode IDs]
declare	@SourceTableKeyColumn varchar(100)	= 'ProgramId'					-- [Key Column in referenced table]
declare	@RecodeType int = ( select	GlobalCodeId
							from	dbo.GlobalCodes
							where	isnull(RecordDeleted, 'N') = 'N'
									and Category = 'RECODECATTYPE'
									and CodeName = 'domain' )
				-- ['DOMAIN' or 'RANGE']	Domain is for a single value (default, null), Range is for multiple, contiguous values.
declare	@RangeType int = ( select	GlobalCodeId
						   from		dbo.GlobalCodes
						   where	isnull(RecordDeleted, 'N') = 'N'
									and Category = 'RECODERANGETYPE'
									and CodeName = 'integer' )
				-- ['INTEGER' or 'DECIMAL' or 'CHARACTER']		To determine which set of columns in the Recodes table to find the range.

--	Recode Values
if object_id('tempdb..#RecodeValues') is not null 
	drop table [#RecodeValues]

create table #RecodeValues ( [IntegerCodeId] [int] null
						   , [CharacterCodeId] [varchar](100) null
						   , [CodeName] [varchar](100) null
						   , [IntegerRangeValueStart] [int] null
						   , [IntegerRangeValueEnd] [int] null
						   , [DecimalRangeValueStart] [decimal](19, 6) null
						   , [DecimalRangeValueEnd] [decimal](19, 6) null
						   , [CharacterRangeValueStart] [varchar](255) null
						   , [CharacterRangeValueEnd] [varchar](255) null
						   , [UseForNonMatchedEntry] [char](1) null
						   , [TranslationValue1] [varchar](255) null
						   , [TranslationValue2] [varchar](255) null )

insert	into #RecodeValues
		( IntegerCodeId
		, CharacterCodeId
		, CodeName
		, IntegerRangeValueStart
		, IntegerRangeValueEnd
		, DecimalRangeValueStart
		, DecimalRangeValueEnd
		, CharacterRangeValueStart
		, CharacterRangeValueEnd
		, UseForNonMatchedEntry
		, TranslationValue1
		, TranslationValue2 
		)
select p.ProgramId, null, p.ProgramCode, null, null, null, null, null, null, null, null, null 
from dbo.Programs p
where isnull(p.RecordDeleted, 'N') = 'N' and p.ProgramCode like ( '%crisis%' )
order by p.ProgramCode

if exists ( select	*
			from	dbo.RecodeCategories
			where	CategoryCode = @CategoryCode ) 
	begin
		select	@RecodeCategoryId = RecodeCategoryId
		from	dbo.RecodeCategories
		where	CategoryCode = @CategoryCode
		print 'RecodeCategory ' + @CategoryCode + ' already exists.'
	end
else 
	begin
		insert	into dbo.RecodeCategories
				( CategoryCode
				, CategoryName
				, Description
				, MappingEntity
				, RecodeType
				, RangeType
				)
		values	( @CategoryCode													-- CategoryCode
				, @CategoryCode													-- CategoryName
				, @CategoryDescription											-- Description
				, @SourceTable + '/' + @SourceTableKeyColumn					-- MappingEntity
				, @RecodeType													-- RecodeType
				, case @RecodeType
					when ( select	GlobalCodeId
						   from		dbo.GlobalCodes
						   where	isnull(RecordDeleted, 'N') = 'N'
									and Category = 'RECODECATTYPE'
									and CodeName = 'range' ) then @RangeType
					else null
				  end															-- RangeType
				)
		set @RecodeCategoryId = @@IDENTITY
		print 'Recode Category ' + @CategoryCode + ', ( ' + cast(@RecodeCategoryId as varchar(max)) + ' ) created.'
		
	end

if exists ( select	1
			from	dbo.Recodes
			where	RecodeCategoryId = @RecodeCategoryId ) 
	begin
		print 'Recodes for category ' + @CategoryCode + ' already exist. select * from dbo.Recodes where isnull(RecordDeleted, ''N'') = ''N'' and RecodeCategoryId = ' + cast(@RecodeCategoryId as varchar(max))
	end
else 
	begin
	
		insert	into dbo.Recodes
				( IntegerCodeId
				, CharacterCodeId
				, CodeName
				, FromDate
				, ToDate
				, RecodeCategoryId
				, IntegerRangeValueStart
				, IntegerRangeValueEnd
				, DecimalRangeValueStart
				, DecimalRangeValueEnd
				, CharacterRangeValueStart
				, CharacterRangeValueEnd
				, UseForNonMatchedEntry
				, TranslationValue1
				, TranslationValue2
				)
				select	IntegerCodeId
					  , CharacterCodeId
					  , CodeName
					  , @EffectiveDate
					  , @EndDate
					  , @RecodeCategoryId
					  , IntegerRangeValueStart
					  , IntegerRangeValueEnd
					  , DecimalRangeValueStart
					  , DecimalRangeValueEnd
					  , CharacterRangeValueStart
					  , CharacterRangeValueEnd
					  , UseForNonMatchedEntry
					  , TranslationValue1
					  , TranslationValue2
				from	#RecodeValues rv
		
		print 'Recodes for Category ' + @CategoryCode + ', ( ' + cast(@RecodeCategoryId as varchar(max)) + ' ) created.'

	end
