
/****** Object:  StoredProcedure [dbo].[Smsp_GetProgramClinicians]    Script Date: 06/18/2018 1:20:30 PM ******/

IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Smsp_GetProgramClinicians]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[Smsp_GetProgramClinicians];
GO

/****** Object:  StoredProcedure [dbo].[Smsp_GetProgramClinicians]    Script Date: 06/18/2018 1:20:30 PM ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[Smsp_GetProgramClinicians]
(@ClientId   INT,
 @JsonResult VARCHAR(MAX) OUTPUT
)
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: June 18, 2018      
-- Description:   Returns Program clinician    
/*      

 Author			Modified Date			Reason      
   
      
*/

-- =============================================      
     BEGIN
         WITH ClientProgramCTE
              AS (
              SELECT DISTINCT
                     Cp.ProgramId
              FROM ClientPrograms CP
                   JOIN Programs P ON P.ProgramId = Cp.ProgramId
              WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
                    AND P.Mobile = 'Y'
                    AND P.Active = 'Y'
                    AND CP.ClientId = @ClientId
                    AND CP.Status IN(1, 4)),
              StaffCTE
              AS (
              SELECT DISTINCT
                     SPS.StaffId AS ClinicianId,
                     S.DisplayAs AS ClinicianName
              FROM StaffPrograms SPS
                   JOIN ClientProgramCTE Cp ON SPS.ProgramId = Cp.ProgramId
                   JOIN Staff S ON S.StaffId = SPS.StaffId
                                   AND S.AllowMobileAccess = 'Y'
                                   AND ISNULL(SPS.RecordDeleted, 'N') = 'N'
                                   AND ISNULL(S.RecordDeleted, 'N') = 'N')
              SELECT @JsonResult = dbo.smsf_FlattenedJSON
(
(
    SELECT ClinicianId,
           ClinicianName
    FROM StaffCTE FOR XML PATH, ROOT
)
);
     END;  