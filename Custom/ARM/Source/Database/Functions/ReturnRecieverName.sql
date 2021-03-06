/****** Object:  UserDefinedFunction [dbo].[ReturnRecieverName]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnRecieverName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ReturnRecieverName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReturnRecieverName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*********************************************************************/                    
/*Function: dbo.ReturnRecieverName                                   */                    
/* Copyright: 2005 Practice Management                               */                    
/* Creation Date:  29/19/2005                                        */                    
/*                                                                   */                    
/* Purpose: it will return RecieverName with concatation based om MessageId */                   
/*                                                                   */                  
/* Output Parameters:        RevieverName                             */                    
/*                                                                   */                    
/* Called By:                                                        */                    
/*                                                                   */                    
/* Calls:                                                            */                    
/*                                                                   */                    
/* Data Modifications:                                               */                    
/*                                                                   */                    
/* Updates:                                                          */                    
/*  Date          Author      Purpose                                    */                    
/* 11/29/2010      Pradeep      Created                                    */        
      
CREATE FUNCTION [dbo].[ReturnRecieverName]      
(      
 @MessageId int      
)      
Returns Varchar(200)AS      
BEGIN      
Declare @RecieverName as varchar(200)      
SET @RecieverName=''''      
--select @RecieverName=@RecieverName+(Case @RecieverName WHEN '''' THEN '''' ELSE ''; '' End)+ LastName + '', '' + FirstName FROM Staff inner join MessageRecepients on Staff.StaffId=MessageRecepients.staffId  WHERE MessageRecepients.MessageId=@MessageId    
select @RecieverName=@RecieverName+(Case @RecieverName WHEN '''' THEN '''' ELSE ''; '' End)+Case when a.SystemDatabaseId is Not null then a.SystemStaffName else (rtrim(staf.LastName) + '', '' + rtrim(staf.FirstName)) end FROM MessageRecepients a left join Messages Msg on a.MessageId=Msg.MessageId left join Staff staf on a.StaffId=staf.StaffId  
where a.MessageId=@MessageID      
    
      
return @RecieverName      
END' 
END
GO
