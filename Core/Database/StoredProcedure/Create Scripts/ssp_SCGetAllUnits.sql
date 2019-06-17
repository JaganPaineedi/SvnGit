/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllUnits]    Script Date: 05/04/2016 14:21:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ssp_SCGetAllUnits]
AS /****************************************************************************/                                                      
/* Stored Procedure: ssp_SCGetAllUnites                                     */                                             
/* Copyright: 2006 Streamlin Healthcare Solutions                           */           
/* Author: Damanpreet Kaur                                                  */                                                     
/* Creation Date:  July 26,2010                                             */                                                      
/* Purpose: Get All Units for bind the dropdown filter                      */                                                     
/* Input Parameters:                                                        */                                                    
/* Output Parameters:None                                                   */                                                      
/* Return:                                                                  */                                                      
/* Calls:                                                                   */          
/* Called From:                                                             */                                                      
/* Data Modifications:                                                      */                                                      
/*                                                                          */  
/*-------------Modification History--------------------------               */  
/*-------Date----Author-------Purpose---------------------------------------*/   
/*13-01-2013    Akwinass      Implemented Order By Clause                   */
/*26 May 2015    Veena         Added ShowOnBedBoard,ShowOnBedCensus,ShowOnWhiteBoard columns Philhaven Development #248**/
/*05/04/2016	 NJain		   Updated to get DisplayAS field in the Unit Name. This is what gets displayed on the UI*/
/*05/04/2016	 NJain		   Reverted back */
/****************************************************************************/  
  
    BEGIN        
        
        SELECT  [UnitId] ,
                [DisplayAs] AS UnitDisplayAs ,
                [UnitName] AS UnitName  ,
  --Added by Veena for  ShowOnBedBoard,ShowOnBedCensus,ShowOnWhiteBoard columns for filtering the units in the list page Philhaven Development #248
                ShowOnBedBoard ,
                ShowOnBedCensus ,
                ShowOnWhiteBoard
        FROM    Units
        WHERE   ( Units.Active = 'Y' )
                AND ( ISNULL(Units.RecordDeleted, 'N') = 'N' )
        ORDER BY DisplayAs ASC
          
            
        IF ( @@error != 0 )
            BEGIN
                RAISERROR  20006  'ssp_SCGetAllUnites: An Error Occured'
                RETURN
            END          
          
    END  

GO
