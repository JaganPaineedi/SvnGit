/****** Object:  UserDefinedFunction [dbo].[GetGroupStatus]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetGroupStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetGroupStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetGroupStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE function [dbo].[GetGroupStatus]  
(      
@GroupServiceId int      
)      
returns varchar(500)            
Begin      
Declare                     
@Status varchar(50),        
@GroupStatus varchar(50),                  
@ShowStatusFound int,                     
@CanceledStatusFound int,                    
@NoShowStatusFound int,                     
@CompleteStatusFound int,        
@SheduledStatusFound int                    
                    
                    
Declare GroupServiceStatus cursor for                    
                    
Select GlobalCodes.CodeName                    
from Services,Globalcodes                    
where Services.Status=GlobalCodes.GlobalCodeId                    
and Isnull(Services.RecordDeleted,''N'') <> ''Y''  -- By Vikas Vyas Perform Isnull Check                  
and Services.GroupServiceId=@GroupServiceId                    
                    
open GroupServiceStatus                    
Fetch GroupServiceStatus into @Status                    
                    
Set @CanceledStatusFound=0                    
set @ShowStatusFound=0                    
set @NoShowStatusFound=0                    
set @CompleteStatusFound=0        
set @SheduledStatusFound=0                    
                    
WHILE @@Fetch_Status = 0                     
BEGIN         
 -- print @Status                    
-- set @GroupStatus=@Status                    
 if @Status=''Scheduled''                    
 begin                    
  set @GroupStatus=''Scheduled''        
         
  set @SheduledStatusFound=1        
                 
  break                    
 end                    
 else if @Status =''Cancel''or @Status=''Canceled'' or @Status =''Cancelled''                    
 begin                    
  set @CanceledStatusFound=1         
                    
 end                    
 else if @Status=''Show''                    
 begin                    
  set @ShowStatusFound=1        
                 
 end                    
 else if @Status=''No Show''                    
 begin                    
  set @NoShowStatusFound=1         
                     
 end                      
 else if @Status=''Complete''                    
 begin                    
  set @CompleteStatusFound=1         
                     
 end                    
                     
 Fetch GroupServiceStatus into @Status                     
END                    
if @SheduledStatusFound=1        
BEGIN        
  set @GroupStatus=''Scheduled''        
END                    
else if @CanceledStatusFound=1 OR @NoShowStatusFound =1                    
begin                    
 set @GroupStatus=''Cancel''        
end                    
else if @CanceledStatusFound=1 and @NoShowStatusFound =1 and @CompleteStatusFound=1                    
begin                    
 set @GroupStatus=''Complete''                    
end                    
else if @CanceledStatusFound=1 and @NoShowStatusFound =1 and @CompleteStatusFound=1 and @ShowStatusFound=1                    
begin                    
 set @GroupStatus=''Show''                    
end                    
                    
--select @GroupStatus                    
              
close GroupServiceStatus                    
Deallocate GroupServiceStatus                    
              
          
return @GroupStatus      
End' 
END
GO
