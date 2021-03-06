IF OBJECT_ID('ssp_GetSHQTStaffList', 'P') IS NOT NULL
  DROP PROCEDURE dbo.ssp_GetSHQTStaffList
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetSHQTStaffList]

AS
/*********************************************************************/
/* Stored Procedure:ssp_GetSHQTStaffList  1   */
/* Copyright: 2018 Streamline Healthcare Solutions,  LLC             */
/* Creation Date: 12May2018                                      */
/*                                                                   */
/* Purpose: This procedure will be used to Get theList of         */
/* Staff who are HighlyQualifiedTeachers                                */
/*                                                                   */
/* Output Parameters:   None                                         */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date        Author   Purpose                              */
/*  12May2018   Abhishek  Created                              */
/*  15/10/2018   Kavya.N  Modified the logic by removing StaffHighlyQualifiedTeachers staff condition - PEP_Customization#1005.7 */
/*********************************************************************/
BEGIN
  BEGIN TRY


    SELECT
      s.StaffId,
      s.FirstName,
      s.LastName,
      s.DisplayAs
    FROM Staff s
    WHERE ISNULL(s.RecordDeleted, 'N') = 'N'
    GROUP BY s.FirstName,
             s.LastName,
             s.StaffId,
             s.DisplayAs


  --Checking For Errors              
  END TRY
  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_GetSHQTStaffList')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())
    RAISERROR
    (
    @Error, -- Message text.                                                                                                            
    16, -- Severity.                                                                                                            
    1 -- State.                                                                                                            
    );
  END CATCH
END