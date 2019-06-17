IF OBJECT_ID('ssp_SCGetStaffLocations') IS NOT NULL 
BEGIN 
	DROP PROC ssp_SCGetStaffLocations	
END 


/****** Object:  StoredProcedure [dbo].[ssp_SCGetStaffLocations]    Script Date: 03/01/2012 14:57:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
    
    
CREATE PROCEDURE [dbo].[ssp_SCGetStaffLocations]
AS 
    BEGIN                  
/*********************************************************************/                    
/* Stored Procedure: dbo.ssp_SCGetStaffLocations                     */           
/*                                                                   */           
/* Copyright: 2005 Streamline Smart Care                             */                    
/*                                                                   */          
/* Creation Date:  25/08/2007                                        */                    
/*                                                                   */                    
/* Purpose: Gets Data For  Staff Locations                           */                   
/*                                                                   */                  
/* Input Parameters: None            */                  
/*                                                                   */                     
/* Output Parameters:                                     */                    
/*                                                                   */      
/* Return:                */                    
/*                                                                   */                    
/* Called By: getStaffLocations(int StaffId)DataService.MSDE Class   */          
/*                                                                   */      
/*                                                                   */          
/*                                                                   */                    
/* Calls:                                                            */                    
/*                                                                   */                    
/* Data Modifications:                                               */                    
/*                                                                   */                    
/*   Updates:                                                        */                    
/*                                                                   */          
/*       Date              Author           Purpose                  */                    
/*  25/08/2006    Rohit Verma                Created                 */     
/*  21/08/2008    Vikas Vyas                Perform locationActive Check in ref to task #273                                                                */                   
/*  March 1, 2012 Kneale Alpers   added the column PrescriptionPrinterLocationId */
/*  Oct-27-2016  Deej			  added the column ChartCopyPrinterDeviceLocationId 
   Key Point - Support Go Live #679*/
/*********************************************************************/                     
                
        SELECT  stp.StaffId ,
                loc.LocationId ,
                RTRIM(loc.LocationCode) AS LocationCode ,
                RTRIM(loc.LocationCode) AS LocationName,
                PrescriptionPrinterLocationId,
				ChartCopyPrinterDeviceLocationId
        FROM    StaffLocations stp
                JOIN Locations loc ON stp.LocationId = loc.LocationID
        WHERE   ISNULL(stp.RecordDeleted, 'N') <> 'Y'
                AND loc.Active <> 'N'
        ORDER BY LocationName          
          
  --Checking For Errors          
        IF ( @@error != 0 ) 
            BEGIN          
                RAISERROR  20006   'ssp_SCGetStaffLocations: An Error Occured'           
                RETURN          
            END                   
                  
          
    END          
          
GO


