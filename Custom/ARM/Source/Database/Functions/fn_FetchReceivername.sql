/****** Object:  UserDefinedFunction [dbo].[fn_FetchReceivername]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_FetchReceivername]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_FetchReceivername]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_FetchReceivername]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create FUNCTION [dbo].[fn_FetchReceivername]
(
	@OtherRecepients varchar(max),
	@CurrentRecord int
)
RETURNS varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @OtherRecepientValue varchar(max)
	Declare @RecordSelected int
	set @OtherRecepientValue=''''
	set @RecordSelected = -1
	
	Declare @Index int
	set @Index=1
	while @Index!= 0        
    begin   
		set @RecordSelected=@RecordSelected+1   
        set @Index = charindex('';'',@OtherRecepients)
        if(@RecordSelected=@CurrentRecord)
        Begin        
        if @Index!=0        
            set @OtherRecepientValue =@OtherRecepientValue+ left(@OtherRecepients,@Index - 1)  +'';''     
        else        
            set @OtherRecepientValue = @OtherRecepientValue + @OtherRecepients     
        End
        set @OtherRecepients= Right(@OtherRecepients,len(@OtherRecepients)-@Index)
        
    End
	if (SUBSTRING(@OtherRecepientValue,len(@OtherRecepientValue),1)='';'')
	set @OtherRecepientValue=SUBSTRING(@OtherRecepientValue,1,LEN(@OtherRecepientValue)-1)

	return @OtherRecepientValue 

END
' 
END
GO
