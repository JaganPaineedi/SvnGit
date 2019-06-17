/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllRooms]    Script Date: 11/6/2012 10:24:09 AM ******/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_SCHEMA = 'dbo'
                    AND SPECIFIC_NAME = 'ssp_SCGetAllRooms' ) 
    DROP PROCEDURE [dbo].[ssp_SCGetAllRooms]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllRooms]    Script Date: 11/6/2012 10:24:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCGetAllRooms]
AS /****************************************************************************/                                                      
/* Stored Procedure: ssp_SCGetAllRooms                                    */                                             
/* Copyright: 2006 Streamlin Healthcare Solutions                           */           
/* Author: Damanpreet Kaur                                                  */                                                     
/* Creation Date:  July 26,2010                                             */                                                      
/* Purpose: Get All Rooms for bind the dropdown filter                      */                                                     
/* Input Parameters:                                                        */                                                    
/* Output Parameters:None                                                   */                                                      
/* Return:                                                                  */                                                      
/* Calls:                                                                   */          
/* Called From:                                                             */                                                      
/* Data Modifications:                                                      */                                                      
/*                                                                          */  
/*-------------Modification History--------------------------               */  
/*-------Date------------Author----------Purpose---------------------------------------*/   
/*----2012-06-21------Chuck Blaine-----Added in [UnitId] to selection so Bed Census filters can cascade*/
/*----2015-05-28      Veena             Added Unitcolumns which is added for Philhaven DEvelopment #248   */

/****************************************************************************/  
  
    BEGIN        
        
        SELECT  R.[UnitId] ,
                [RoomId] ,
                [RoomName],
                ShowOnBedBoard,
				ShowOnBedCensus,
				ShowOnWhiteBoard
        FROM    Rooms R
        JOIN UNITS U on U.UnitId=R.UnitId
        WHERE   ISNULL(R.Active, 'Y') = 'Y'
                AND ( ISNULL(R.RecordDeleted, 'N') = 'N' )
                AND ( ISNULL(U.RecordDeleted, 'N') = 'N' )
		ORDER BY RoomName
          
            
        IF ( @@ERROR != 0 ) 
            BEGIN
                RAISERROR  20006  'ssp_SCGetAllRooms: An Error Occured'
                RETURN
            END
          
    END

GO


