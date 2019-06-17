  
  
  IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GETCLIENTAGE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_GETCLIENTAGE]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [DBO].[SSP_GETCLIENTAGE]   
/*********************************************************************************/      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: Customization support for Reception list page depending on the custom filter selection.      
--      
-- Author:  Vaibhav khare      
-- Date:    20 May 2011      
--      
-- *****History****      
/* 2012-09-21   Vaibhav khare  Created          */     
/* New two parameters added by Deej. As per the discussion with Wasif*/   
/*********************************************************************************/      
      
     
 @ClientId INT  ,  
 @DocumentId INT ,  
 @EffectiveDate DATETIME  
  
     
       
AS      
BEGIN       
 DECLARE @return_value int,  
  @age varchar(50)     
    
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
   Set @age = @age + ' month old'       
  End      
   End        
  Else        
  Begin        
   Set @age = @age + ' year old'        
  End     
    
 SELECT  @age as '@age'  
      
END   
  