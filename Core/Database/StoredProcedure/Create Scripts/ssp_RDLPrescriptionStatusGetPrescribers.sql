IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_RDLPrescriptionStatusGetPrescribers')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_RDLPrescriptionStatusGetPrescribers;
    END;
GO

CREATE PROCEDURE ssp_RDLPrescriptionStatusGetPrescribers
AS /******************************************************************************
**		File: Core\RDL\Core\Modules\PrescriptionStatus\Database\StoredProcedures
**		Name: ssp_RDLPrescriptionStatusGetPrescribers
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
**		Date: 4/3/2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      4/3/2018          jcarlson				created
*******************************************************************************/
    BEGIN TRY
        SELECT  -1 AS StaffId ,
                'All Prescribers' AS DisplayAs
        UNION ALL
        SELECT  st.StaffId ,
                st.DisplayAs
        FROM    Staff AS st
        WHERE   ISNULL(st.RecordDeleted, 'N') = 'N'
                AND ISNULL(st.Prescriber, 'N') = 'Y';

    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        DECLARE @ErrorDate DATETIME = GETDATE();
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'ssp_RDLPrescriptionStatusGetPrescribers') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE());		
        EXEC dbo.ssp_SCLogError @ErrorMessage = @Error, -- text
            @VerboseInfo = 'ssp_RDLPrescriptionStatusGetPrescribers', -- text
            @ErrorType = 'Report Error', -- varchar(50)
            @CreatedBy = 'RDLPrescriptionStatus', -- varchar(30)
            @CreatedDate = @ErrorDate, -- datetime
            @DatasetInfo = 'ssp_RDLPrescriptionStatusGetPrescribers'; -- text
				
        RAISERROR(@Error,		16,1 );

    END CATCH;