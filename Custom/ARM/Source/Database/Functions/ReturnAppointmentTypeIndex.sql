/****** Object:  UserDefinedFunction [dbo].[ReturnAppointmentTypeIndex]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnAppointmentTypeIndex]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ReturnAppointmentTypeIndex]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnAppointmentTypeIndex]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ReturnAppointmentTypeIndex](@AppointmentTypeId bigint)
returns  bigint
as
begin
declare @APTID bigint
select @APTID= t.row from
(
select ROW_NUMBER()over(order by codename) as row,globalcodeid from GlobalCodes where Category=''APPOINTMENTTYPE'' and active=''Y'' and RecordDeleted<>''Y'' 
)as t where t.globalcodeid=@AppointmentTypeId
return @APTID
end
' 
END
GO
