IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_RDLPrescriptionStatus')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_RDLPrescriptionStatus;
    END;
GO

CREATE PROCEDURE ssp_RDLPrescriptionStatus
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @Prescriber INT ,
    @Client INT ,
    @ExecutedByStaffId INT
AS /******************************************************************************
**		File: Core\RDL\Core\Modules\PrescriptionStatus\Database\StoredProcedures
**		Name: ssp_RDLPrescriptionStatus
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
**	   Date:		    Author:			   Description:
**	   ---------	    --------			   ------------------------------------------
**      4/03/2018       jcarlson			   created
**	   4/04/2018	    jcarlson			   Switched StaffClientAccess to StaffClients...
**     04/20/2018		Rajeshwari S		   Added condition to dispaly sent date is blank when ResponseDateTime is null #573 MHP-Support Go Live

*******************************************************************************/
    BEGIN TRY
	        
        SELECT  dbo.GetMedicationName(cm.MedicationNameId) AS MedicationName ,
                st.DisplayAs + ' ('
                + CONVERT(VARCHAR(MAX), cs.OrderingPrescriberId) + ')' AS PrescriberName ,
                csa.CreatedDate AS DatePrescribed ,
                ISNULL(convert(varchar(30),som.ResponseDateTime, 120),'') SentDate,  -- Rajeshwari S 04/20/2018
                DATEDIFF(MINUTE, csa.CreatedDate,
                         ISNULL(som.ResponseDateTime, csa.CreatedDate)) AS diffMinutes ,
                CASE WHEN som.ResponseDateTime IS NULL THEN 'N'
                     ELSE 'Y'
                END AS Processed ,
                c.LastName + ', ' + c.FirstName + ' ('
                + CONVERT(VARCHAR(MAX), c.ClientId) + ')' AS ClientName ,
                csa.StatusDescription
        FROM    dbo.ClientMedicationScriptActivities csa
                JOIN dbo.ClientMedicationScripts cs ON cs.ClientMedicationScriptId = csa.ClientMedicationScriptId
                JOIN dbo.SureScriptsOutgoingMessages som ON som.ClientMedicationScriptId = cs.ClientMedicationScriptId
                JOIN dbo.ClientMedicationScriptDrugs csd ON csd.ClientMedicationScriptId = cs.ClientMedicationScriptId
                JOIN dbo.ClientMedicationInstructions cim ON cim.ClientMedicationInstructionId = csd.ClientMedicationInstructionId
                JOIN dbo.ClientMedications cm ON cm.ClientMedicationId = cim.ClientMedicationId
                JOIN Clients AS c ON cs.ClientId = c.ClientId
                JOIN Staff AS st ON st.StaffId = cs.OrderingPrescriberId
        WHERE   csa.Method = 'E'
                AND CONVERT(DATE, csa.CreatedDate) >= CONVERT(DATE, @StartDate)
                AND CONVERT(DATE, csa.CreatedDate) <= CONVERT(DATE, @EndDate)
                AND ( c.ClientId = @Client
                      OR NULLIF(LTRIM(RTRIM(@Client)), '') IS NULL
                    )
                AND ( st.StaffId = @Prescriber
                      OR @Prescriber = -1
                    )
                AND ISNULL(csa.RecordDeleted, 'N') = 'N'
                AND ISNULL(cs.RecordDeleted, 'N') = 'N'
                AND EXISTS ( SELECT 1
                             FROM   dbo.StaffClients AS sca
                             WHERE  sca.ClientId = cs.ClientId
                                    AND sca.StaffId = @ExecutedByStaffId )
        ORDER BY csa.CreatedDate DESC;


    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        DECLARE @ErrorDate DATETIME = GETDATE();
        DECLARE @VerboseInfo VARCHAR(MAX);

        SELECT  @VerboseInfo = 'Report Parameters:' + CHAR(10) + CHAR(13)
                + '@StartDate = ' + CONVERT(VARCHAR(MAX), @StartDate, 101)
                + CHAR(10) + CHAR(13) + '@EndDate = '
                + CONVERT(VARCHAR(MAX), @EndDate, 101) + CHAR(10) + CHAR(13)
                + '@Prescriber = ' + CONVERT(VARCHAR(MAX), @Prescriber)
                + CHAR(10) + CHAR(13) + '@Client = '
                + CONVERT(VARCHAR(MAX), @Client) + CHAR(10) + CHAR(13)
                + '@ExecutedByStaffId = '
                + CONVERT(VARCHAR(MAX), @ExecutedByStaffId) + CHAR(10)
                + CHAR(13) + ' exec ssp_RDLPrescriptionStatus '''
                + CONVERT(VARCHAR(MAX), @StartDate, 101) + ''', '''
                + CONVERT(VARCHAR(MAX), @EndDate, 101) + ''', '
                + CONVERT(VARCHAR(MAX), @Prescriber) + ', '
                + CONVERT(VARCHAR(MAX), @Client) + ', '
                + CONVERT(VARCHAR(MAX), @ExecutedByStaffId);

        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'ssp_RDLPrescriptionStatus') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE());	
				
        EXEC dbo.ssp_SCLogError @ErrorMessage = @Error, -- text
            @VerboseInfo = @VerboseInfo, -- text
            @ErrorType = 'Report Error', -- varchar(50)
            @CreatedBy = 'RDLPrescriptionStatus', -- varchar(30)
            @CreatedDate = @ErrorDate, -- datetime
            @DatasetInfo = 'ssp_RDLPrescriptionStatus'; -- text	
        RAISERROR(@Error,		16,1 );

    END CATCH;