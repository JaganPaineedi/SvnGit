/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateReportDetail]    Script Date: 11/9/2017 4:17:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if object_id('ssp_PostUpdateReportDetail', 'P') is not null
	drop procedure ssp_PostUpdateReportDetail
go

create PROCEDURE [dbo].[ssp_PostUpdateReportDetail]                      
    (
      @ScreenKeyId INT ,
      @StaffId INT ,
      @CurrentUser VARCHAR(30) ,
      @CustomParameters XML
    )
AS 
/****************************************************************************************************/ 
/* Stored Procedure: [ssp_PostUpdateReportDetail]											        */ 
/* Creation Date:  3-Nov-2016																		*/ 
/* Author:  Arjun K R  																			     */ 
/* Purpose: To update AddAsBanner column after save.Task #449 Aspen Pointe Customizations.          */ 
/* Change Log:																						*/
/*		2017.11.09	- T.Remisoski - Change selection of @ParentBannerId so only one is selected.	*/
/*****************************************************************************************************/ 
    BEGIN 
        BEGIN TRY 
             DECLARE @ReportName varchar(max)
             DECLARE @AddAsBanner char(1)
             DECLARE @ParentBannerId INT
             
             DECLARE @URL varchar(max)
             
             SET @URL = @CustomParameters.value('(/Root/Parameters/@URL)[1]', 'varchar(500)')
             
             SET @AddAsBanner=(SELECT TOP 1 AddAsBanner FROM Reports WHERE ReportId=@ScreenKeyId)         
             SET @ReportName=(SELECT TOP 1 Name FROM Reports WHERE ReportId=@ScreenKeyId)
             SET @ParentBannerId=(SELECT TOP 1 BannerId FROM Banners WHERE ScreenId=107 AND ISNULL(RecordDeleted,'N')='N' ORDER BY BannerId asc)
                        
			 IF(@ReportName IS NOT NULL)
					BEGIN
					  IF(ISNULL(@AddAsBanner,'N')='Y')
						BEGIN
							IF NOT EXISTS (SELECT 1 FROM Banners WHERE BannerName=@ReportName AND ISNULL(RecordDeleted,'N')='N')
							 BEGIN
								 INSERT INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,TabId,Custom,ScreenId,ParentBannerId,ScreenParameters)
								 VALUES(@ReportName,@ReportName,'Y',1,1,'N',130,@ParentBannerId,@URL)
							 END
						 END
						 ELSE
							BEGIN
							 IF EXISTS (SELECT 1 FROM Banners WHERE BannerName=@ReportName AND ISNULL(RecordDeleted,'N')='N')
								BEGIN
									DELETE Banners WHERE BannerName=@ReportName AND ScreenId=130 AND ParentBannerId=@ParentBannerId
								END
							END
					
					END		
        END TRY 
   
        BEGIN CATCH 
            DECLARE @Error VARCHAR(8000) 

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostUpdateReportDetail') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

            RAISERROR ( @Error, 
                      -- Message text.                                                                    
                      16, 
                      -- Severity.                                                           
                      1 
          -- State.                                                        
          ); 
        END CATCH 
    END 
 

