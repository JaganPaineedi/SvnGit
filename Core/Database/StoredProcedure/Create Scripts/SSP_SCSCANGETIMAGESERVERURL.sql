IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCSCANGETIMAGESERVERURL]') AND type in (N'P', N'PC'))
DROP PROCEDURE SSP_SCSCANGETIMAGESERVERURL
GO


/****** Object:  StoredProcedure [dbo].[SSP_SCSCANGETIMAGESERVERURL]    Script Date: 12/3/2013 4:35:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [DBO].[SSP_SCSCANGETIMAGESERVERURL]   
 @StaffId int                    
as                    
/******************************************************************************                                
                            
**  Name: [ssp_SCScanGetImageServerURL]                                
**  Desc: Get ImageServerURL for getting scanned as well as Upload Images                 
**                                
**  This template can be customized:                                
**                                              
**  Return values:                                
**                                 
**  Called by:                                   
**                                              
**  Parameters:                                
**  Input       Output                                
**     ----------       -----------                                
**                                
**  Auth: Ashwani Kumar Angrish                         
**  Date: 16 July 2010                                
*******************************************************************************                                
**  Change History                                
*******************************************************************************                                
**  Date:  Author:    Description:                                
**  --------  --------    -------------------------------------------                                
**                                    
*******************************************************************************/                      
 declare @ImageServerId int         
Begin TRY                 
DECLARE @NonStaffUser VARCHAR(1)

SELECT @NonStaffUser = NonStaffUser FROM Staff where StaffId=@StaffId
IF (  @NonStaffUser= 'Y')
BEGIN 
	 select @ImageServerId=CAST(value AS Integer) from SystemConfigurationKeys where [Key]='ImageServerForNonStaffUsers' 
END
ELSE
BEGIN
	set @ImageServerId=(select DefaultImageServerId from Staff where StaffId=@StaffId) 
END    
          
Select rtrim(lTRIM(ImageServerUrl)) as ImageServerUrl from ImageServers where ImageServerId=@ImageServerId              
and ISNULL(RecordDeleted,'N')<>'Y'          
                
END TRY              
              
Begin catch              
IF (@@error!=0)                    
     BEGIN                    
         RAISERROR  ('ssp_SCScanGetImageServerURL: An Error Occured',16,1)                       
 END                 
end catch  