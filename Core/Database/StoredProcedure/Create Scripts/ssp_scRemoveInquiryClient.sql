/****** Object:  StoredProcedure [dbo].[ssp_scRemoveInquiryClient]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_scRemoveInquiryClient]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_scRemoveInquiryClient]
GO

/****** Object:  StoredProcedure [dbo].[ssp_scRemoveInquiryClient]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[ssp_scRemoveInquiryClient]        
 @ScreenKeyId INT,        
 @StaffId INT,        
 @CurrentUser VARCHAR(30)         
/******************************************************************************        
**  File:   
**  Created by :   RK     
**  Name: ssp_scRemoveInquiryClient        
**  Desc: Delete the inquiry documents and events, if user remove client form the inquiry page.        
**          
**  Parameters:        
**  Input        
 @ScreenKeyId INT,        
 @StaffId INT,        
 @CurrentUser VARCHAR(30)        
**  Output     ----------       -----------         
**         
**  Auth: RK,  Pralyankar Kumar Singh        
**  Date:  Jan 6, 2012        
*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:  Author:  Description:        
**  -------- --------    -------------------------------------------         
** 3/21/2012 Pralyankar Commented Code for Removing CareManagementId and Inquiry EventId        
/*19 Aug 2013 katta sharath kumar Pull this sp from Newaygo database from 3.5xMerged with task #3 in Ionia County CMH - Customizations*/            
*******************************************************************************/        
        
AS        
   BEGIN                   
    BEGIN try         
        
  DECLARE @InquiryEventId INT, @CareManagementId INT        
        
  SELECT @InquiryEventId = InquiryEventId , @CareManagementId = CareManagementId        
  FROM Inquiries CI LEFT OUTER JOIN Clients C ON C.ClientId = CI.CLientID        
  WHERE CI.InquiryId = @ScreenKeyId        
         
  /*  >>--------> Get PCM Master DB Name <--------<< */        
  DECLARE  @DBName VARCHAR(50)         
  SET @DBName = [dbo].[fn_GetPCMMasterDBName]()        
  -- >>>>>>>------------------------------------------------------->        
        
  ---- Execute dynamic query in PCM Master Database ----        
  DECLARE @DynamicQuery VARCHAR(MAX)        
  SET @DynamicQuery = '[' + @DBName + '].[dbo].ssp_scRemoveInquiryEvents ''' + @CurrentUser + ''','         
     + cast(isnull(@CareManagementId,0) as varchar(10)) + ','         
     + cast(isnull(@InquiryEventId,0) as varchar(10)) + ''        
  EXEC(@DynamicQuery)        
  ------------------------------------------------------        
        
  --UPDATE Inquiries        
  --SET InquiryEventId = NULL         
  --WHERE InquiryId = @ScreenKeyId        
        
  --Update Clients        
  --SET CareManagementId = NULL        
  --WHERE CareManagementId = @CareManagementId          
     END try                   
                  
    BEGIN catch                   
        DECLARE @Error VARCHAR(8000)                   
                  
        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****'                   
                    + CONVERT(VARCHAR(4000), Error_message())                   
                    + '*****'                   
                    + Isnull(CONVERT(VARCHAR, Error_procedure()),                   
                    'ssp_scRemoveInquiryClient' )                   
                    + '*****' + CONVERT(VARCHAR, Error_line())                   
                    + '*****' + CONVERT(VARCHAR, Error_severity())                   
                    + '*****' + CONVERT(VARCHAR, Error_state())                   
                  
        RAISERROR ( @Error,-- Message text.                                               
                    16,-- Severity.                                               
                    1 -- State.    
        );                   
    END catch                   
END  