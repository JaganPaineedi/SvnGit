/****** Object:  StoredProcedure [dbo].[ssp_GetContactOrganizations]    Script Date: 01 JAN 2017   ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetContactOrganizations]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetContactOrganizations] 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_GetContactOrganizations] (@ClientId INT, 
                                                      @StaffId  INT) 
AS 
  /**************************************************************    
  Created By   : Ajay K Bangar [ssp_GetContactOrganizations] 0, 550  
  Created Date : 01 JAN 2017   
  Description  : To get the ClientContactNotes for staff spacific If @IsPermissionContactReason is ='Y'. 
  Called From  : Contact Note List page seachable text box.   
  /*  Date        Author          Description */  
    
  **************************************************************/ 
  BEGIN 
      BEGIN try 
          DECLARE @IsPermissionContactReason CHAR(1) 

          SET @IsPermissionContactReason = 
          (SELECT TOP 1 Value 
           FROM   SystemConfigurationKeys 
           WHERE  [Key] = 'SHOWPERMISSIONEDCONTACTREASONS'
           AND ISNULL(RecordDeleted,'N')='N'
           ) 

          SELECT DISTINCT CCN.IndividualOrganization 
          FROM   ClientContactNotes CCN 
          WHERE  (ISNULL(CCN.ClientId,0) = @ClientId 
                      OR
                    ISNULL(@ClientId,0) =  0
                    )
          
          
                 AND ( ( @IsPermissionContactReason = 'Y' 
                         AND EXISTS(SELECT * 
                                    FROM   ViewStaffPermissions 
                                    WHERE  CCN.ContactReason = PermissionItemId 
                                           AND StaffId = @StaffId 
                                           AND PermissionTemplateType = 5925) ) 
                        OR ( Isnull(@IsPermissionContactReason, 'N') = 'N' ) ) 
                 AND Isnull(CCN.IndividualOrganization, '') <> '' 
                 AND Isnull(RecordDeleted, 'N') = 'N' 
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                       + CONVERT(VARCHAR(4000), Error_message()) 
                       + '*****' 
                       + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                       'ssp_GetContactOrganizations') 
                       + '*****' + CONVERT(VARCHAR, Error_line()) 
                       + '*****' + CONVERT(VARCHAR, Error_severity()) 
                       + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error,-- Message text.  
                      16,-- Severity.  
                      1 -- State.  
          ); 
      END catch 
  END 

go 