if object_id('ssp_RecodesCategoryCreateUpdate', 'P') is not null
	drop procedure ssp_RecodesCategoryCreateUpdate
go

create procedure ssp_RecodesCategoryCreateUpdate @CategoryCode varchar(100) 
,                                                @CategoryName varchar(100) 
,                                                @Description varchar(max)  
,                                                @MappingEntity varchar(100)
,                                                @RecodeType type_GlobalCode = 8401
,                                                @RangeType type_GlobalCode  = null
/*------------------------------------------------------------------------------------------*/
/* Procedure: ssp_RecodesCategoryCreateUpdate									  */
/*																		  */
/* Purpose: Create or update a Recode Category in a way that allows the proc to be used	  */
/*		  in installation scripts.  If no recode category with the category code exists	  */
/*		  a new recode category is created.  Otherwise, the existing category is updated  */
/*		  with all other incoming parameters.									  */
/* Parameters:																  */
/*		  @CategoryCode varchar(100) - Recode category code to insert/update.			  */
/*		  @CategoryName varchar(100) - Recode Category name.						  */
/*		  @Description varchar(max)  - Description of the recode categories.			  */
/*		  @MappingEntity varchar(100)- Table which contains the mapped values for recodes.*/
/*		  @RecodeType type_GlobalCode- DOMAIN or TRANSLATE type.					  */
/*								 Defaults to DOMAIN (8401)					  */
/*		  @RangeType type_GlobalCode - If "translate" type, then the range type for the	  */
/*								 global code.								  */
/*																		  */
/* Returns: int (0 on success)	 											  */
/*																		  */
/* Revision History:														  */
/*	   2016-06-27 - T.Remisoski - Created.										  */
/*------------------------------------------------------------------------------------------*/


as

	declare @RecodeCategoryId int

	select @RecodeCategoryId = RecodeCategoryId
	from RecodeCategories
	where CategoryCode = @CategoryCode and isnull(RecordDeleted, 'N') = 'N'

	if @RecodeCategoryId is not null
	begin
		update RecodeCategories
		set CategoryName  = @CategoryName
		,   Description   = @Description
		,   MappingEntity = @MappingEntity
		,   RecodeType    = @RecodeType
		,   RangeType     = @RangeType
		where RecodeCategoryId = @RecodeCategoryId
	end
	else
	begin

		insert into RecodeCategories ( CategoryCode,  CategoryName,  Description,  MappingEntity,  RecodeType,  RangeType  )
		values                       ( @CategoryCode, @CategoryName, @Description, @MappingEntity, @RecodeType, @RangeType )


	end

	return 0
go