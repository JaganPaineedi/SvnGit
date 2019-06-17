
/****** Object:  StoredProcedure [dbo].[smsp_GetServiceClinicians]    Script Date: 8/30/2016 5:06:40 PM ******/

IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetServiceClinicians]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[smsp_GetServiceClinicians];
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetServiceClinicians]    Script Date: 8/30/2016 5:06:40 PM ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[smsp_GetServiceClinicians] @StaffId INT
AS -- =============================================      
-- Author:  Pradeep      
-- Create date: 14-06-2016
-- Description: Get StaffProcedureCodes
/*      
 Author			Modified Date			Reason      
   
      
*/

-- =============================================      
         BEGIN
             BEGIN TRY
                 ;WITH StaffProgram
                      AS (
                      SELECT DISTINCT
                             Sp.ProgramId
                      FROM StaffPrograms Sp
                           JOIN Programs P ON P.ProgramId = Sp.ProgramId
                      WHERE Sp.StaffId = @StaffId
                            AND p.Mobile = 'Y'
                            AND ISNULL(sp.RecordDeleted, 'N') = 'N'
                            AND ISNULL(P.RecordDeleted, 'N') = 'N'),
                      ServiceClinicians
                      AS (
                      SELECT Sp.StaffProgramId,
				         Sp.StaffId,
                             S.DisplayAs,
                             Sp.ProgramId
                      FROM StaffPrograms SP
                           JOIN StaffProgram SPP ON SPP.ProgramId = Sp.ProgramId
                           JOIN staff S ON S.StaffId = sp.StaffId
                                           WHERE S.AllowMobileAccess = 'Y' AND ISNULL(SP.RecordDeleted,'N') = 'N' AND ISNULL(S.RecordDeleted,'N') = 'N')
                      SELECT DISTINCT
					    StaffProgramId,
                             StaffId AS ClinicianId,
                             DisplayAs AS ClinicianName,
                             ProgramId As ProgramId
                      FROM ServiceClinicians;
             END TRY
             BEGIN CATCH
                 DECLARE @Error VARCHAR(8000);
                 SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetServiceClinicians')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
                 RAISERROR(@Error, -- Message text.                                                                     
                 16, -- Severity.                                                            
                 1 -- State.                                                         
                 );
             END CATCH;
         END;
GO


