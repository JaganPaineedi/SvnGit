IF EXISTS (SELECT *
             FROM sys.objects
            WHERE object_id = OBJECT_ID(N'ssp_SCGetConcurrentUserRanges')
              AND type IN ( N'P', N'PC' ))
BEGIN
    DROP PROCEDURE ssp_SCGetConcurrentUserRanges;
END;
GO

CREATE PROCEDURE ssp_SCGetConcurrentUserRanges
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCGetConcurrentUserRanges
**		Desc: 
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 8/9/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      8/9/2017          jcarlson             created
*******************************************************************************/
BEGIN TRY

    SELECT b.GlobalCodeId,
           b.CodeName
      FROM GlobalCodes AS b
     WHERE b.Category                   = 'ConcurrentUserRange'
       AND ISNULL(b.RecordDeleted, 'N') = 'N';


END TRY
BEGIN CATCH
    DECLARE @Error VARCHAR(8000);
    SELECT @Error
        = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
          + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetConcurrentUserRanges') + '*****'
          + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
          + CONVERT(VARCHAR, ERROR_STATE());
    RAISERROR(@Error, 16, 1);

END CATCH;