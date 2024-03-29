/****** Object:  UserDefinedFunction [dbo].[GetAge]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAge]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetAge]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAge]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create function [dbo].[GetAge]  (@DOB datetime, @EventDate datetime)
returns int
as
begin
  declare @Age int

  set @Age =  case when convert(int, convert(char(4), DatePart(yy, @EventDate)) +
                                Right(''0'' + convert(varchar(2), DatePart(mm, @DOB)), 2) + 
                                Right(''0'' + convert(varchar(2), DatePart(dd, @DOB)), 2)) > 
                   convert(int, convert(char(8), @EventDate, 112))
              then -1
              else 0 
              end + DateDiff(yy, @DOB, @EventDate)

   return(@Age)
end



' 
END
GO
