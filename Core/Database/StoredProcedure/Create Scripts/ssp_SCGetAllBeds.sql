/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllBeds]    Script Date: 11/6/2012 10:22:15 AM ******/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_SCHEMA = 'dbo'
                    AND SPECIFIC_NAME = 'ssp_SCGetAllBeds' ) 
    DROP PROCEDURE [dbo].[ssp_SCGetAllBeds]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllBeds]    Script Date: 11/6/2012 10:22:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetAllBeds]
AS /****************************************************************************/                                                      
/* Stored Procedure: ssp_SCGetAllBeds                                    */                                             
/* Copyright: 2006 Streamlin Healthcare Solutions                           */           
/* Author: Damanpreet Kaur                                                  */                                                     
/* Creation Date:  July 26,2010                                             */                                                      
/* Purpose: Get All Beds for bind the dropdown filter                      */                                                     
/* Input Parameters:                                                        */                                                    
/* Output Parameters:None                                                   */                                                      
/* Return:                                                                  */                                                      
/* Calls:                                                                   */          
/* Called From:                                                             */                                                      
/* Data Modifications:                                                      */                                                      
/*                                                                          */  
/*-------------Modification History--------------------------               */  
/*-------Date------------Author----------Purpose---------------------------------------*/   
/*----2012-06-21------Chuck Blaine-----Added in [RoomId] to selection so Bed Census filters can cascade*/
/*----2015-05-28      Veena             Added Unitcolumns which is added for Philhaven DEvelopment #248   */
/****************************************************************************/  
  
    BEGIN        
        
        SELECT  dbo.Rooms.[UnitId] ,
                dbo.Beds.[RoomId] ,
                dbo.Beds.[BedId] ,
                dbo.Beds.[BedName] ,
                dbo.Beds.[DisplayAs] AS BedDisplayAs,
                ShowOnBedBoard,
				ShowOnBedCensus,
				ShowOnWhiteBoard
        FROM    Beds
                JOIN dbo.Rooms ON dbo.Rooms.RoomId = dbo.Beds.RoomId
                JOIN UNITS U on U.UnitId=dbo.Rooms.UnitId
        WHERE   ( dbo.Beds.Active = 'Y' )
                AND ( ISNULL(dbo.Beds.RecordDeleted, 'N') = 'N' )
		ORDER BY dbo.Beds.DisplayAs
          
          
        IF ( @@error != 0 ) 
            BEGIN
                RAISERROR  20006  'ssp_SCGetAllBeds: An Error Occured'
                RETURN
            END          
          
    END


GO


