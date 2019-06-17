IF EXISTS (SELECT *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAllRooms]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_GetAllRooms]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetAllRooms]    Script Date: 09/04/2018 12:59:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
CREATE PROCEDURE ssp_GetAllRooms  
As	
 /********************************************************************************                                                
-- Stored Procedure: ssp_GetAllRooms                                                
--                                                
-- Copyright: Streamline Healthcare Solutions                                                
--                                                
-- Purpose: Used By Classroom Assignments List page for filling the rooms dropdown                                              
--                                                
-- Updates:                                                                                                       
-- Date         Author                  Purpose                                                
-- 15.03.2018   Pradeep Kumar Yadav     CREATED.      
                 
*********************************************************************************/  
Begin
	Begin Try 
  Select  RoomId  
    ,CreatedBy  
    ,CreatedDate  
    ,ModifiedBy  
    ,ModifiedDate  
    ,RecordDeleted  
    ,DeletedDate  
    ,DeletedBy  
    ,UnitId  
    ,RoomName  
    ,DisplayAs  
    ,[Active]  
    ,Comment  
    ,InactiveReason  
    ,Classroom
    ,ProgramId
    From Rooms  
    Where [Active]='Y'  
    AND Classroom='Y'
    AND IsNull(RecordDeleted,'N')='N'  
      END TRY  
  BEGIN CATCH  
    DECLARE @Error varchar(8000)  
  
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), '[ssp_GetAllRooms]') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (  
    @Error  
    ,-- Message text.                                                                                                                
    16  
    ,-- Severity.                                                                                                                
    1 -- State.                                                                                                                
    );  
  END CATCH  
END
  