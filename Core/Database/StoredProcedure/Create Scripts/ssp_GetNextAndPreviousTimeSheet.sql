IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetNextAndPreviousTimeSheet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetNextAndPreviousTimeSheet]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.ssp_GetNextAndPreviousTimeSheet       
@TimeSheetDay datetime = NULL     
,@StaffId INT       
AS    
-- =============================================    
-- Author      : Rajesh S
-- Date        : 22/12/2015
-- Purpose     : Get Timesheet data 
-- =============================================        
BEGIN         
BEGIN TRY           
   
 DECLARE @PreviousTimeSheet DATETIME,@NextTimeSheet DATETIME  
   
 SELECT TOP 1 @PreviousTimeSheet = TimeSheetDay FROM StaffTimeSheetEntries   
 WHERE   
  TimeSheetDay < @TimeSheetDay AND StaffId = @StaffId  
  AND ISNULL(RecordDeleted,'N')='N' 
 ORDER BY TimeSheetDay DESC  
   
 SELECT TOP 1 @NextTimeSheet = TimeSheetDay FROM StaffTimeSheetEntries   
 WHERE   
  TimeSheetDay > @TimeSheetDay AND StaffId = @StaffId   
  AND ISNULL(RecordDeleted,'N')='N' 
 ORDER BY TimeSheetDay  
        
    SELECT ISNULL(CONVERT(NVARCHAR(11),@PreviousTimeSheet,101),'')  PreviousTimeSheet  
  ,ISNULL(CONVERT(NVARCHAR(11),@NextTimeSheet,101),'') NextTimeSheet  
      
       
 END TRY        
        
 BEGIN CATCH        
  DECLARE @Error VARCHAR(8000)        
        
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_GetNextAndPreviousTimeSheet]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert
(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())        
        
  RAISERROR (        
    @Error        
    ,-- Message text.                                                                                
    16        
    ,-- Severity.                                                                                
    1 -- State.                                                                                
    );        
 END CATCH        
end 