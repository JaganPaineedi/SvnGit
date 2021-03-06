/****** Object:  StoredProcedure [dbo].[csp_conversionTimeline]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conversionTimeline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conversionTimeline]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conversionTimeline]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
create procedure [dbo].[csp_conversionTimeline]
@activity varchar(200),  
@status  int  
AS  
  
insert into cstm_conversionTimeline  (Activity,  Status,  EventTime)  
select  @activity,
        case when @status = 1 then ''Start''  
             when @status = 2 then ''Stop''  
             else null  
        end,  
        getdate()  
  
if @@error <> 0 goto error  
  
return  
  
error:  
Raiserror 50000 ''csp_conversionTimeline failed''  
  

' 
END
GO
