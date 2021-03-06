/****** Object:  StoredProcedure [dbo].[ssp_ValidateEpisodeCarePlan]    Script Date: 08/10/2015 11:54:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateEpisodeCarePlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ValidateEpisodeCarePlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************/
/* Stored Procedure: [ssp_ValidateEpisodeCarePlan]   */
/*       Date              Author                  Purpose                   */
/*      07-08-2015		 Venkatesh               When opening the Care Plan - verify that there is an open episode. */
/*********************************************************************/    
    

Create PROCEDURE [dbo].[ssp_ValidateEpisodeCarePlan]  --550,16,60300  
 @StaffId int,    
 @ClientId int,    
 @DocumentCodeId int    
AS    
BEGIN     
    IF NOT EXISTS(SELECT 1 FROM   ClientEpisodes CE WHERE CE.ClientId= @ClientId AND Status IN(101,100) AND ISNULL(RecordDeleted,'N')='N')
    BEGIN     
		SELECT 'This client does not have a current open episode. Please register the client before creating a Care Plan.' as ValidationMessage, 'E' as WarningOrError
    END
    ELSE
    BEGIN
		SELECT '' as ValidationMessage, '' as WarningOrError WHERE 1=2
    END
END 