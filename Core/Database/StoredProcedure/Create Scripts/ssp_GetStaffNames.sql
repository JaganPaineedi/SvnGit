 /****** Object:  StoredProcedure [dbo].[ssp_GetStaffNames]    Script Date: 01/12/2015 15:36:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetStaffNames]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetStaffNames]    Script Date: 01/12/2015 15:36:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
 
 CREATE PROCEDURE [dbo].[ssp_GetStaffNames] (  
  @StaffName VARCHAR(50)    
 )  
 /********************************************************************/  
 /* Stored Procedure: dbo.ssp_GetStaffNames    */  
 /* Creation Date:  05 Aug,2011                                      */  
 /*                                                                  */  
 /* Purpose: get Client Names based on client name*/  
 /*                                                                  */  
 /* Input Parameters: @ClientName        */  
 /*                                                                  */  
 /* Output Parameters:            */  
 /*                                                                  */  
 /*  Date                  Author                 Purpose   */  
 /* 22/12/2016             Venkatesh     Created - As per task Texas Customization 44 */  
 /********************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  
	  DECLARE @Name VARCHAR(50)         
	  SET @Name= '%'+ @StaffName + '%' 
	  
	  CREATE TABLE #GroupNoteStaffList  
	  (  
	  StaffId INT,  
	  StaffName VARCHAR(200)  
	  )
	  
	  Insert into #GroupNoteStaffList  
	  Select StaffId, LastName + ', ' + FirstName  as ClientName FROM Staff WHERE Active='Y' AND ISNULL(RecordDeleted, 'N') = 'N'   
	  SELECT Top 10 StaffId, StaffName FROM #GroupNoteStaffList WHERE StaffName like @Name   

  END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetStaffNames') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                                
    16  
    ,-- Severity.                     
    1 -- State.                                                            
    );  
 END CATCH  
END  