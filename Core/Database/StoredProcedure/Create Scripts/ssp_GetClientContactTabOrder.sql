/****** Object:  StoredProcedure [dbo].[ssp_GetClientContactTabOrder]    Script Date: 16/11/2018 12:13:44 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetClientContactTabOrder]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetClientContactTabOrder] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_GetClientContactTabOrder]    Script Date: 16/11/2018 12:13:44 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_GetClientContactTabOrder] @StaffId INT 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_GetClientContactTabOrder                */ 
/* Copyright: 2014  valley                                           */ 
/* Creation Date:  18 oct 2014                                       */ 
/*                                                                   */ 
/* Purpose: It will retun tab order of client contact                */ 
/*                                                                   */ 
/* Output Parameters:                                                */ 
/*                                                                   */ 
/* Called By:                                                        */ 
/*                                                                   */ 
/* Calls:                                                            */ 
/*                                                                   */ 
/* Data Modifications:                                               */ 
/*                                                                   */ 
/* Updates:                                                          */ 
/*  Date          Author        Purpose                              */ 
/*  14 Aug 2015   Chita Ranjan  Created                              */ 
/*********************************************************************/ 
AS 
    DECLARE @Roles TABLE 
      ( 
         RoleId INT 
      ) 
    DECLARE @PermissionStatus CHAR(1) = NULL 
    DECLARE @TempPermissionCheck TABLE 
      ( 
         PermissionTemplateType     INT, 
         PermissionTemplateTypeName VARCHAR(100), 
         PermissionItemId           INT, 
         PermissionItemName         VARCHAR(250), 
         ParentId                   INT, 
         ParentName                 VARCHAR(100), 
         Denied                     CHAR(1), 
         DeniedByRole               CHAR(1), 
         Granted                    CHAR(1), 
         GrantedByRole              CHAR(1), 
         StaffPermissionExceptionId INT, 
         RowNum                     INT 
      ) 
    DECLARE @Screen TABLE 
      ( 
         ID      INT IDENTITY(1, 1), 
         Tabname VARCHAR(100) 
      ) 

    INSERT INTO @Roles 
                (RoleId) 
    SELECT RoleId 
    FROM   StaffRoles SR 
           JOIN Globalcodes GC 
             ON GC.GlobalCodeId = SR.RoleId 
    WHERE  StaffId = @StaffId 
           AND ISNULL(SR.RecordDeleted, 'N') <> 'Y' 
           AND ISNULL(GC.RecordDeleted, 'N') <> 'Y' 
           AND ISNULL(GC.ACTIVE, 'N') = 'Y' 

    -- Get all available permission items         
    INSERT INTO @TempPermissionCheck 
                (PermissionTemplateType, 
                 PermissionTemplateTypeName, 
                 PermissionItemId, 
                 PermissionItemName, 
                 ParentId, 
                 ParentName) 
    SELECT gc.GlobalCodeId, 
           gc.CodeName, 
           c.TabOrder, 
           c.TabName, 
           c.ScreenId, 
           s.ScreenName 
    FROM   ClientInformationTabConfigurations c 
           INNER JOIN GlobalCodes gc 
                   ON gc.GlobalCodeId = 5922 
           INNER JOIN Screens s 
                   ON s.ScreenId = c.ScreenId 
    WHERE  gc.GlobalCodeId = 5922 
           AND isnull(c.RecordDeleted, 'N') = 'N' 
    ORDER  BY taborder 

    -- Everything is denied by default         
    UPDATE @TempPermissionCheck 
    SET    GrantedByRole = 'N', 
           Granted = 'N', 
           DeniedByRole = 'Y', 
           Denied = 'Y' 

    -- Apply role permissions         
    UPDATE pit 
    SET    GrantedByRole = 'Y', 
           Granted = 'Y', 
           DeniedByRole = 'N', 
           Denied = 'N' 
    FROM   @TempPermissionCheck pit 
    WHERE  EXISTS(SELECT * 
                  FROM   PermissionTemplates pt 
                         JOIN @Roles r 
                           ON r.RoleId = pt.RoleId 
                         JOIN PermissionTemplateItems pti 
                           ON pti.PermissionTemplateId = pt.PermissionTemplateId 
                  WHERE  pt.PermissionTemplateType = pit.PermissionTemplateType 
                         AND pti.PermissionItemId = pit.PermissionItemId 
                         AND isnull(pt.RecordDeleted, 'N') = 'N' 
                         AND isnull(pti.RecordDeleted, 'N') = 'N') 

    -- Apply exceptions         
    UPDATE pit 
    SET    Granted = spe.Allow, 
           Denied = CASE spe.Allow 
                      WHEN 'Y' THEN 'N' 
                      ELSE 'Y' 
                    END, 
           StaffPermissionExceptionId = spe.StaffPermissionExceptionId 
    FROM   @TempPermissionCheck pit 
           JOIN StaffPermissionExceptions spe 
             ON spe.StaffId = @StaffId 
                AND spe.PermissionTemplateType = pit.PermissionTemplateType 
                AND spe.PermissionItemId = pit.PermissionItemId 
    WHERE  isnull(spe.RecordDeleted, 'N') = 'N' 

    DELETE FROM @TempPermissionCheck 
    WHERE  Granted = 'N' 

    INSERT INTO @Screen 
    SELECT PermissionItemName 
    FROM   @TempPermissionCheck 

    SELECT ID 
    FROM   @Screen 
    WHERE  Tabname LIKE '%Contacts' 

    IF ( @@error != 0 ) 
      BEGIN 
          RAISERROR ('ssp_GetClientContactTabOrder: An Error Occured',16,1) 

          RETURN 
      END 

go 