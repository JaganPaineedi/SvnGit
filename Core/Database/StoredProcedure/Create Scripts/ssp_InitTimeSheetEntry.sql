

/****** Object:  StoredProcedure [dbo].[ssp_InitTimeSheetEntry]    Script Date: 07/05/2016 17:13:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitTimeSheetEntry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitTimeSheetEntry]
GO


/****** Object:  StoredProcedure [dbo].[ssp_InitTimeSheetEntry]    Script Date: 07/05/2016 17:13:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_InitTimeSheetEntry] (      
 @ClientID INT      
 ,@StaffID INT      
 ,@CustomParameters XML      
 )      
AS      
/*********************************************************************/      
/* Stored Procedure: [ssp_InitTimeSheetEntry]               */      
/* Creation Date:  25/November/2015                                    */      
/* Purpose: To Initialize */      
/* Input Parameters:   @ClientID,@StaffID ,@CustomParameters*/   
/* ModifiedDate		ModifiedBy		Purpose
   04 July 2016	    Shaik.Irfan		DECLARED Variable @DAYSNOTWORKEDNO and modified the logic to 
								  	initialize the value of DAYSNOTWORKED for Bear River - Environment Issues Tracking - Task : #152									*/
/*********************************************************************/      
BEGIN      
 BEGIN TRY      
  --DECLARE @ClientFeeId INT      
      
  --SET @ClientFeeId = (      
  --  SELECT TOP 1 @ClientFeeId      
  --  FROM ClientFees CCF      
  --  INNER JOIN Clients C ON C.ClientId = CCF.ClientId      
  --  WHERE C.ClientId = @ClientID      
  --   AND ISNULL(C.RecordDeleted, 'N') = 'N'      
  --   AND ISNULL(CCF.RecordDeleted, 'N') = 'N'      
  --  ORDER BY CCF.ClientFeeId DESC      
  --  )      
  --SET @ClientFeeId = ISNULL(@ClientFeeId, - 1)      
  
  --04 July 2016	    Shaik.Irfan	    
  DECLARE @DAYSNOTWORKEDNO INT
  SELECT @DAYSNOTWORKEDNO=GlobalcodeId From Globalcodes 
  Where Category = 'DAYSNOTWORKED' and Code='DAYSNOTWORKEDNO'
  AND ISNULL(RecordDeleted,'N')='N' AND Active='Y'
  ------
  SELECT     
 'StaffTimeSheetEntries' AS TableName    
 ,@DAYSNOTWORKEDNO AS DaysNotWorked  --04 July 2016	    Shaik.Irfan	
 ,'' AS CreatedBy      
 ,getdate() AS CreatedDate      
 ,'' AS ModifiedBy      
 ,getdate() AS ModifiedDate      
  FROM     
 SystemConfigurations S      
 LEFT OUTER JOIN StaffTimeSheetEntries ON S.Databaseversion = - 1    
      
 END TRY      
      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
      
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_InitTimeSheetEntry]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR,
  
 ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
  RAISERROR (      
    @Error      
    ,-- Message text.                                                                                                            
    16      
    ,-- Severity.                                                                                                            
    1 -- State.                                                                                                            
    );      
 END CATCH      
END 
GO


