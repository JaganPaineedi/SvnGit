 
/********************************************************************************                                                        
-- Stored Procedure: csp_CalculateAge          
--          
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: To calculate the ClientAge in care connection document.          
--          
-- Author: K.Soujanya      
-- Date:    20 Jan 2017          
*********************************************************************************/  

IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[csp_CalculateAge]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[csp_CalculateAge] 
  END 
  GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE  [dbo].[csp_CalculateAge]                                                                                                                                                                
(               
 @ClientID int,  
 @age varchar(50) output  
)  
As  
Begin  
 Declare @later datetime  
 --Declare @age varchar(10)  
 Set @later = getdate()  
  
  Select @age = Cast(DateDIFF(yy,DOB,@later) - CASE WHEN @later>=DateAdd(yy,DateDIFF(yy,DOB,@later), DOB) THEN 0 ELSE 1 END as varchar(10)) from Clients C                                         
  where C.ClientId=@ClientID and IsNull(C.RecordDeleted,'N')='N'  
  if(@age = '0')  
   Begin  
    Select @age = Cast(DateDIFF(MM,DOB,@later) - CASE WHEN @later>=DateAdd(MM,DateDIFF(MM,DOB,@later), DOB) THEN 0 ELSE 1 END as varchar(10)) from Clients C                                         
    where C.ClientId=@ClientID and IsNull(C.RecordDeleted,'N')='N'  
    if(@age = '0')
		Begin
			Select @age = Cast(DateDIFF(DD,DOB,@later) - CASE WHEN @later>=DateAdd(DD,DateDIFF(DD,DOB,@later), DOB) THEN 0 ELSE 1 END as varchar(10)) from Clients C                                         
			where C.ClientId=@ClientID and IsNull(C.RecordDeleted,'N')='N' 
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
End


