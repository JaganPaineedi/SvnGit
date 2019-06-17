

/****** Object:  UserDefinedFunction [dbo].[GetClientAgeByDOB]    Script Date: 04/25/2018 12:31:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetClientAgeByDOB]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetClientAgeByDOB]
GO


/****** Object:  UserDefinedFunction [dbo].[GetClientAgeByDOB]    Script Date: 04/25/2018 12:31:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************                                     
**  File: [GetClientAgeByDOB]                                              
**  Name: [GetClientAgeByDOB]                          
**  Desc: To get the client age based on DOB.
**  Called by:                                                   
**  Parameters:                              
**  Auth:  Shruthi.S                              
**  Date:  22/12/2015     
*******************************************************************************                                                  
**  Change History                                            
*******************************************************************************                                            
**  Date:       Author:       Description:                                      
*******************************************************************************/    
  
                                    
CREATE function  [dbo].[GetClientAgeByDOB]-- 956  --953                                                                 
(                                                                                                                                                             
  @DOB datetime ,
  @ClientId int                                                                           
)                                                                                
 returns varchar(1000) as                                                                             

   ----Initializing CustomDocumentWraparoundNeedsSummaryContacts table from client contacts
  BEGIN
   
   
  
 Declare @age varchar(max)
 --Declare @age varchar(10)
    
  Select @age = Cast(DateDIFF(yy,@DOB,GETDATE()) - CASE WHEN GETDATE()>=DateAdd(yy,DateDIFF(yy,@DOB,GETDATE()), @DOB) THEN 0 ELSE 1 END as varchar(10))                                         

  if(@age = '0')    
   Begin    
    Select @age = Cast(DateDIFF(MM,@DOB,GETDATE()) - CASE WHEN GETDATE()>=DateAdd(MM,DateDIFF(MM,@DOB,GETDATE()), @DOB) THEN 0 ELSE 1 END as varchar(10))                                         
  
    if(@age = '0')  
  Begin  
   Select @age = Cast(DateDIFF(DD,@DOB,GETDATE()) - CASE WHEN GETDATE()>=DateAdd(DD,DateDIFF(DD,@DOB,GETDATE()), @DOB) THEN 0 ELSE 1 END as varchar(10))                                         
     
   Set @age = Cast(Cast(@age as int) - 1 as varchar) + ' Days'  
  End  
 Else  
  Begin   
   Set @age = @age + ' Months'   
  End  
   End    
  Else    
  Begin    
   Set @age = @age + ' Years'    
  End      
  return @age
 
END
    

  
GO


