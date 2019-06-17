
/****** Object:  StoredProcedure [dbo].[ssp_InitCourseDetails]    Script Date: 03/14/2018 12:59:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitCourseDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitCourseDetails]
GO



/****** Object:  StoredProcedure [dbo].[ssp_InitCourseDetails]    Script Date: 03/14/2018 12:59:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_InitCourseDetails]       
 (        
  @ClientID INT        
 ,@StaffID INT        
 ,@CustomParameters XML        
 )        
AS        
/*********************************************************************/        
/* Stored Procedure: [ssp_InitCourseDetails] '','',''           */    
/* Author:Chita Ranjan                            */  
/* Creation Date:  08/March/2018                                    */        
/* Purpose: To Initialize */        
/* Input Parameters:   @ClientID,@StaffID ,@CustomParameters*/        
--exec [ssp_InitCourseDetails]       
/*********************************************************************/        
BEGIN        
 BEGIN TRY        
  SELECT 'Courses' AS TableName        
   ,- 1 AS CourseId   
   ,'' AS CreatedBy        
   ,getdate() AS CreatedDate        
   ,'' AS ModifiedBy        
   ,getdate() AS ModifiedDate     
   ,'N' AS RecordDeleted       
  FROM systemconfigurations s        
  LEFT OUTER JOIN Courses ON s.Databaseversion = - 1        
 END TRY        
        
 BEGIN CATCH        
  DECLARE @Error VARCHAR(8000)        
        
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_InitClientFees]') + '*****' + Convert(VARCHAR, ERROR_LINE())+ '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())        
        
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


