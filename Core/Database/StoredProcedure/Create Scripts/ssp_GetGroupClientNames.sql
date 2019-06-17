 /****** Object:  StoredProcedure [dbo].[ssp_GetGroupClientNames]    Script Date: 01/12/2015 15:36:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetGroupClientNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetGroupClientNames]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetGroupClientNames]    Script Date: 01/12/2015 15:36:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
 
 CREATE PROCEDURE [dbo].[ssp_GetGroupClientNames] (  
  @ClientName VARCHAR(100),
  @From VARCHAR(15)  
 )  
 /********************************************************************/  
 /* Stored Procedure: dbo.ssp_GetGroupClientNames    */  
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
	  SET @Name= '%'+ @ClientName + '%' 
	  
	  CREATE TABLE #GroupNoteClientsList  
	  (  
	  ClientId INT,  
	  ClientName VARCHAR(200)  
	  )
	  
	  Insert into #GroupNoteClientsList  
	  Select ClientId, LastName + ', ' + FirstName  as ClientName FROM Clients WHERE Active='Y' AND ISNULL(RecordDeleted, 'N') = 'N'   

  IF(@From = 'ClientName')
  BEGIN
	  SELECT Top 10 ClientId, ClientName FROM #GroupNoteClientsList WHERE ClientName like @Name   
  END   
  ELSE
  BEGIN
	 SET @Name= @ClientName + '%' 
	  SELECT Top 10 ClientId, ClientName FROM #GroupNoteClientsList WHERE ClientId like @Name   
  END
  END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetGroupClientNames') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                                
    16  
    ,-- Severity.                     
    1 -- State.                                                            
    );  
 END CATCH  
END  