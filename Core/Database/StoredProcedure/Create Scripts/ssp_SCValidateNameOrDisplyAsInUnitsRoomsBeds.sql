IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateNameOrDisplyAsInUnitsRoomsBeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCValidateNameOrDisplyAsInUnitsRoomsBeds]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
             
 CREATE PROCEDURE [dbo].[ssp_SCValidateNameOrDisplyAsInUnitsRoomsBeds]         
 @KeyId Int,        
 @KeyName Varchar(100),        
 @Flag Char(2),      
 @Units Int   =null    
AS          
/*********************************************************************/                          
/* Stored Procedure:ssp_SCValidateNameOrDisplyAsInUnitsRoomsBeds     */                          
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                          
/* Creation Date: 27June2012                                      */                          
/*                                                                   */                          
/* Purpose: This procedure will be used to Validate For        */                          
/* Units/Rooms/Beds Name And DisplayAs                               */                        
/* Input Parameters: @KeyId,@KeyName,@KeyDisplayAs,@Flag          */                        
/*                                                                   */                          
/* Output Parameters:   None                                         */                          
/*                                                                   */                          
/* Return:  0=success, otherwise an error number                     */                          
/*                                                                   */                          
/* Called By:                                                        */                          
/*                                                                   */                          
/* Calls:                                                            */                          
/*                                                                   */                          
/* Data Modifications:                                               */                          
/*                                                                   */                          
/* Updates:                                                          */                          
/*   Date        Author   Purpose                              */                          
/*  27June2012   Vikas Kashyap  Created                              */      
/*  27 July 2018 Himmat     
                 What:-  if a room with any name exist in the table room  and associated with some  units then system should allow to create the room with same name  associating with different unit.          
                         so added one extra parameter @Units to check Room Name with Unit combination    
                 Why :- Comprehensive-Environment Issues Tracking#527*/    
/*********************************************************************/                  
BEGIN         
 Begin TRY          
 DECLARE @NameExists nvarchar(10)= 'FALSE';        
         
 /*@Flag Notation: U=Units,UH=Units_DiplayAs,R=Rooms,RH=Rooms_DisplayAs,B=Beds,BH=Beds_DisplayAs*/        
 /*Name & DisplayAs Check Both Active/Inactive cases*/        
         
 IF(@Flag='U')        
 BEGIN        
 IF Exists(Select UnitId From Units Where UnitName=@KeyName AND @KeyId>0 AND UnitId=@KeyId AND ISNULL(RecordDeleted, 'N') = 'N' )        
 BEGIN          
  SET @NameExists = 'FALSE';          
 END        
 ELSE IF Exists(Select UnitId From Units Where UnitName=@KeyName AND ISNULL(RecordDeleted, 'N') = 'N' )        
  BEGIN          
  SET @NameExists = 'TRUE';          
 END        
 END        
   
   
 ELSE IF(@Flag='R')     
 BEGIN        
  IF Exists(Select RoomId From Rooms Where RoomName=@KeyName AND @KeyId>0 AND RoomId!=@KeyId AND unitid=@Units AND ISNULL(RecordDeleted, 'N') = 'N' )        
 BEGIN          
  SET @NameExists = 'TRUE';          
 END        
 ELSE IF Exists(Select RoomId From Rooms Where RoomName=@KeyName AND unitid=@Units AND @KeyId<0 AND ISNULL(RecordDeleted, 'N') = 'N' )        
  BEGIN          
  SET @NameExists = 'TRUE';        
     END      
 ELSE   
  BEGIN          
  SET @NameExists = 'FALSE';          
     END       
       
 END        
   
   
 ELSE IF(@Flag='B')        
 BEGIN        
   IF Exists(Select BedId From Beds Where BedName=@KeyName AND @KeyId>0 AND BedId=@KeyId AND ISNULL(RecordDeleted, 'N') = 'N' )        
 BEGIN          
  SET @NameExists = 'FALSE';          
 END        
 ELSE IF Exists(Select BedId From Beds Where BedName=@KeyName AND ISNULL(RecordDeleted, 'N') = 'N' )        
  BEGIN          
  SET @NameExists = 'TRUE';          
     END        
 END        
ELSE IF(@Flag='UH')        
BEGIN        
  IF Exists(Select UnitId From Units Where  DisplayAs=@KeyName AND @KeyId>0 AND UnitId=@KeyId AND ISNULL(RecordDeleted, 'N') = 'N')        
  BEGIN          
   SET @NameExists = 'FALSE';          
  END        
  ELSE IF Exists(Select UnitId From Units Where DisplayAs=@KeyName AND ISNULL(RecordDeleted, 'N') = 'N' )        
  BEGIN          
   SET @NameExists = 'TRUE';          
     END        
END        

ELSE IF(@Flag='RH')     
 BEGIN        
  IF Exists(Select RoomId From Rooms Where DisplayAs=@KeyName AND @KeyId>0 AND RoomId!=@KeyId AND unitid=@Units AND ISNULL(RecordDeleted, 'N') = 'N' )        
 BEGIN          
  SET @NameExists = 'TRUE';          
 END        
 ELSE IF Exists(Select RoomId From Rooms Where DisplayAs=@KeyName AND unitid=@Units AND @KeyId<0 AND ISNULL(RecordDeleted, 'N') = 'N' )        
  BEGIN          
  SET @NameExists = 'TRUE';        
     END      
 ELSE   
  BEGIN          
  SET @NameExists = 'FALSE';          
     END       
       
 END  
 -- ELSE IF(@Flag='RH')        
 --BEGIN        
 -- IF Exists(Select RoomId From Rooms Where  DisplayAs=@KeyName AND @KeyId>0 AND RoomId=@KeyId AND ISNULL(RecordDeleted, 'N') = 'N')        
 -- BEGIN          
 --  SET @NameExists = 'FALSE';          
 -- END        
 -- ELSE IF Exists(Select RoomId From Rooms Where DisplayAs=@KeyName  AND  ISNULL(RecordDeleted, 'N') = 'N' )        
 -- BEGIN          
 --  SET @NameExists = 'TRUE';          
 --    END        
 -- END
 
         
  ELSE IF(@Flag='BH')        
 BEGIN        
  IF Exists(Select BedId From Beds Where  DisplayAs=@KeyName AND @KeyId>0 AND BedId=@KeyId AND ISNULL(RecordDeleted, 'N') = 'N')        
  BEGIN          
   SET @NameExists = 'FALSE';          
  END        
  ELSE IF Exists(Select BedId From Beds Where DisplayAs=@KeyName AND ISNULL(RecordDeleted, 'N') = 'N' )        
  BEGIN          
   SET @NameExists = 'TRUE';          
  END        
 END        
         
 SELECT @NameExists;        
          
--Checking For Errors                  
END TRY                                                                                  
BEGIN CATCH                                      
DECLARE @Error varchar(8000)                                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                             
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCValidateNameOrDisplyAsInUnitsRoomsBeds')                                                                                                                 
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                  
    + '*****' + Convert(varchar,ERROR_STATE())                                                              
 RAISERROR                                                                                                                 
 (                                                                                   
  @Error, -- Message text.                                                                                                                
  16, -- Severity.                                                                                                                
  1 -- State.                                                                                                                
 );                                                                                                              
END CATCH                                                             
END 