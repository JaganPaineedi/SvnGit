IF EXISTS (SELECT * 
           FROM   SYS.Objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_BatchSignatureDropdownValues]' 
                  ) 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_BatchSignatureDropdownValues] 

GO 

CREATE PROCEDURE [dbo].[ssp_BatchSignatureDropdownValues] (@LoggedInStaffId INT) 
AS 
/*************************************************************************/ 
/* Stored Procedure: [ssp_BatchSignatureDropdownValues]  550             */ 
/* Creation Date:    10/June/2017										 */ 
/* Creation By:		 Malathi Shiva										 */ 
/*																		 */ 
/* Purpose: To Initialize												 */ 
/*************************************************************************/ 

  BEGIN 
      BEGIN TRY 
          SELECT CASE Code 
                   WHEN 'TOCOSIGN'      THEN 'TOCOSIGN'
                   WHEN 'TOSIGN'        THEN 'TOSIGN' 
                   WHEN 'INPROGRESS'    THEN 'INPROGRESS' 
                   WHEN 'TOBEREVIEWED'  THEN 'TOBEREVIEWED' 
                   WHEN 'TOACKNOWLEDGE' THEN 'TOACKNOWLEDGE' 
                   ELSE NULL 
                 END AS [GlobalCodeId] 
                 ,GS.Category 
                 ,GS.CodeName 
                 ,GS.Code 
                 ,GS.[Description] 
                 ,GS.Active 
                 ,GS.CannotModifyNameOrDelete 
                 ,GS.SortOrder 
          FROM   Globalcodes GS 
                 LEFT JOIN Recodes R 
                        ON R.IntegerCodeId = GS.GlobalCodeId 
                 LEFT JOIN Recodecategories RC 
                        ON RC.RecodeCategoryId = R.RecodeCategoryId 
                           AND RC.CategoryCode = 'STATUSALLOWFORBATCHSIGNING' 
          WHERE  GS.Category = 'BatchSignatureStatus' 
                 AND ISNULL(RC.RecordDeleted, 'N') = 'N' 
                 AND ISNULL(R.RecordDeleted, 'N') = 'N' 
                 AND ISNULL(GS.Active, 'N') = 'Y' order by GS.SortOrder 

          EXEC dbo.ssp_GetStaffPermissionItems 
            @LoggedInStaffId, 
            5920, 
            913, 
            'G' 
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                       + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                       + '*****' 
                       + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                       'ssp_BatchSignatureDropdownValues') 
                       + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                       + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                       + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                        
                      16, 
                      -- Severity.                                                                                        
                      1 
          -- State.                                                                                        
          ); 
      END CATCH 
  END 