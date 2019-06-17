IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_SCGetAuthorizationStatusCodefromRecodes]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetAuthorizationStatusCodefromRecodes] 

GO 

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAuthorizationStatusCodefromRecodes]    Script Date: 05/27/2015 12:27:35 ******/ 
SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE PROCEDURE [dbo].[ssp_SCGetAuthorizationStatusCodefromRecodes] 
AS 
/*********************************************************************/ 
/* Stored Procedure: ssp_SCGetAuthorizationStatusCodefromRecodes               */ 
/* Copyright: 2007 Streamline SmartCare*/ 
/* Creation Date:  27/May/2015                                    */ 
/*                                                                   */ 
/* Purpose: Get Infromation related to Authorization Status */ 
/*                                                                   */ 
/* Input Parameters:   */ 
/*                                                                   */ 
/* Output Parameters:                                */ 
/*                                                                   */ 
/* Return:   */ 
/*                                                                   */ 
/* Called By:   */ 
/*      */ 
/*                                                                   */ 
/* Calls:                                                            */ 
/*                                                                   */ 
/* Data Modifications:                                               */ 
/*                                                                   */ 
/*   Updates:                                                          */ 
/*       Date                Author                  Purpose                                    */
/*      05/27/2015     Md Hussain Khusro		     Created w.r.t task #1765 Core Bugs*/
  /***********************************************************************************************/
  BEGIN 
      BEGIN TRY 
          SELECT r.RecodeId, 
                 rc.CategoryCode, 
                 r.IntegerCodeId 
          FROM   Recodes r 
                 INNER JOIN RecodeCategories rc 
                        ON r.RecodeCategoryId = rc.RecodeCategoryId 
                           AND ISNULL(rc.RecordDeleted, 'N') = 'N' 
          WHERE  r.RecodeCategoryId IN (SELECT RecodeCategoryId 
                                        FROM   RecodeCategories rcs
                                        WHERE ISNULL(rcs.RecordDeleted, 'N') = 'N' 
                 AND rcs.CategoryCode IN ( 'REQUESTEDAUTHORIZATION', 
                                           'APPROVEDAUTHORIZATION' ) 
                                          ) 
                 AND ISNULL(r.RecordDeleted, 'N') = 'N' 
      END try 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCGetAuthorizationStatusCodefromRecodes') 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                                
                      16, 
                      -- Severity.                                                                                                
                      1 -- State.            
          ); 
      END CATCH 
  END 