IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnSplitWithIndex]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnSplitWithIndex]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[fnSplitWithIndex]
    (
      @sInputList varchar(max) -- List of delimited items
    , @sDelimiter varchar(2)-- delimiter that separates items

    )
returns @List table
    (
      [index] int
    , item nvarchar(255)
    )
/****************************************************************************
** Author:		Wasif Butt
** Create date: Novemeber, 08 2013
** Description:	Function to split the string separated by delimiter returns position index and list
**	
**	Modifications:
**		Date			Author			Description
**	--------------	------------------	------------------------------------
**	10 Oct 2018			Vithobha		Changed varchar(8000) to varchar(max)
****************************************************************************/
    begin

        declare @sItem varchar(max)
        declare @pos int = 0

        while charindex(@sDelimiter, @sInputList, 0) <> 0 
            begin

                select  @sItem = rtrim(ltrim(substring(@sInputList, 1,
                                                       charindex(@sDelimiter,
                                                              @sInputList, 0)
                                                       - 1)))
                      , @sInputList = rtrim(ltrim(substring(@sInputList,
                                                            charindex(@sDelimiter,
                                                              @sInputList, 0)
                                                            + len(@sDelimiter),
                                                            len(@sInputList))))

                if len(@sItem) > 0 
                    insert  into @List
                            select  @pos
                                  , @sItem
                set @pos = @pos + 1
            end

        if len(@sInputList) > 0 
            insert  into @List
                    select  @pos
                          , @sInputList -- Put the last item in
        set @pos = @pos + 1

        return

    end

--select * from [dbo].fnSplitWithIndex('h,e,l,l,o',',')

GO


