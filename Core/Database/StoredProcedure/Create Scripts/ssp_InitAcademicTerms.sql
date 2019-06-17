/****** Object:  StoredProcedure [dbo].[ssp_InitAcademicTerms]    Script Date: 09/04/2018 12:59:48 ******/
IF EXISTS (SELECT *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitAcademicTerms]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_InitAcademicTerms]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitCourseDetails]    Script Date: 09/04/2018 12:59:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_InitAcademicTerms] (@ClientID int
, @StaffID int
, @CustomParameters xml)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_InitAcademicTerms] '','',''           */
/* Author:Chita Ranjan                             */
/* Creation Date:  09/April/2018                                    */
/* Purpose: To Initialize Academic Terms Detail Page*/
/* Input Parameters:   @ClientID,@StaffID ,@CustomParameters*/
/*********************************************************************/
BEGIN
  BEGIN TRY
    SELECT
      'AcademicTerms' AS TableName,
      -1 AS AcademicTermId,
      'Y' AS Active,
      '' AS CreatedBy,
      GETDATE() AS CreatedDate,
      '' AS ModifiedBy,
      GETDATE() AS ModifiedDate,
      'N' AS RecordDeleted
    FROM systemconfigurations s
    LEFT OUTER JOIN AcademicTerms
      ON s.Databaseversion = -1
  END TRY

  BEGIN CATCH
    DECLARE @Error varchar(8000)

    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), '[ssp_InitAcademicTerms]') + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (
    @Error
    ,-- Message text.                                                                                                                
    16
    ,-- Severity.                                                                                                                
    1 -- State.                                                                                                                
    );
  END CATCH
END