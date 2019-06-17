IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCWhiteBoardBedStatusActions')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCWhiteBoardBedStatusActions;
    END;
GO

CREATE PROCEDURE ssp_SCWhiteBoardBedStatusActions
@BedId INT,
@CensusDate DATETIME
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCWhiteBoardBedStatusActions
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
**		Date: 5/1/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      5/1/2017          jcarlson             created
*******************************************************************************/
    BEGIN TRY

	SELECT b.BedId,b.DisplayAs AS BedName,@CensusDate AS StartDate, b.RoomId,r.DisplayAs AS RoomName, u.UnitId,u.UnitName,bah.ProgramId, p.ProgramCode AS ProgramName
	, (SELECT a.DropdownOptions FROM dbo.BedBoardStatusChangeDropdowns AS a
	WHERE ISNULL(a.RecordDeleted,'N')='N'
	AND ( ( a.BedAssignmentStatus IS NULL AND bb.BlockBedId IS NULL ) OR ( bb.BlockBedId IS NOT NULL AND a.BedAssignmentStatus = 5009 ) ) ) AS DropDownOptions,
	p.BedAdmissionRequiresOrder,
	CASE WHEN bb.BlockBedId IS NULL THEN 'Open' ELSE 'Blocked' END AS 'BedStatus'
	FROM Beds AS b 
	LEFT JOIN dbo.BedAvailabilityHistory AS bah ON bah.BedId = b.BedId
			AND ( ( CONVERT(DATE,bah.StartDate) <= CONVERT(DATE,@CensusDate) OR bah.StartDate IS NULL ) AND ( CONVERT(DATE,bah.EndDate) >= CONVERT(DATE,@CensusDate) OR bah.EndDate IS NULL ) )
	JOIN Rooms AS r ON r.RoomId = b.RoomId
	JOIN Units AS u ON u.UnitId = r.UnitId
	LEFT JOIN Programs AS p ON p.ProgramId = bah.ProgramId
	LEFT JOIN dbo.BlockBeds AS bb ON bb.BedId = b.BedId
			AND ( ( CONVERT(DATE,bb.StartDate) <= CONVERT(DATE,@CensusDate) OR bb.StartDate IS NULL ) AND ( CONVERT(DATE,bb.EndDate) >= CONVERT(DATE,@CensusDate) OR bb.EndDate IS NULL) )
			AND ISNULL(bb.RecordDeleted,'N')='N'
	WHERE b.BedId = @BedId
	AND ISNULL(bah.RecordDeleted,'N')='N'

    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWhiteBoardBedStatusActions') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;