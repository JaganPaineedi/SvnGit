IF EXISTS (SELECT *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientNameForClassroomAssignments]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_GetClientNameForClassroomAssignments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [DBO].[ssp_GetClientNameForClassroomAssignments] (  
  @ClientNameSearch VARCHAR(50)    
 )  
 /********************************************************************/  
 /* Stored Procedure: dbo.ssp_GetClientNameForClassroomAssignments    */  
 /* Creation Date:  16 Apr,2018                                      */  
 /*                                                                  */  
 /* Purpose: get Client Names based on client name*/  
 /*                                                                  */  
 /* Input Parameters: @ClientName        */  
 /*                                                                  */  
 /* Output Parameters:            */  
 /*                                                                  */  
 /*  Date                  Author                 Purpose   */  
 /* 16/Apr/2018             Pradeep Y     Created - As per task PEP-Customization Task - #10005 */  
 /********************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  
  CREATE TABLE #ContactNoteClientsList  
  (  
  ClientId INT,  
  ClientName VARCHAR(200)  
  )  
    
  Insert into #ContactNoteClientsList  
  Select ClientId, LastName + ', ' + FirstName + ' (' + CAST(ClientId AS VARCHAR(50)) + ')' as ClientName FROM Clients WHERE Active='Y' AND ISNULL(RecordDeleted, 'N') = 'N'    
  
    
   DECLARE @Name VARCHAR(50)         
   SET @Name= '%'+ @ClientNameSearch + '%'        
   SELECT ClientId, ClientName FROM #ContactNoteClientsList WHERE ClientName like @Name   
  END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientNameForClassroomAssignments') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                                
    16  
    ,-- Severity.                     
    1 -- State.                                                            
    );  
 END CATCH  
END  