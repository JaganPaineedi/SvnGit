IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCBedBoardRemoveBedAssignmentLeaves]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_SCBedBoardRemoveBedAssignmentLeaves]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
**		File: ssp_SCBedBoardRemoveBedAssignmentLeaves.sql
**		Name: ssp_SCBedBoardRemoveBedAssignmentLeaves
**		Desc: Removes bed assignment Leaves
** 
**		Called by:   AjaxBedBoard (RemoveLeaves)
**
**		Author: Vithobha
**		Date  : June 20 2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:

*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_SCBedBoardRemoveBedAssignmentLeaves] (
 @CurrentbedAssignmentId INT,
 @NextBedAssignmentId INT)
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        BEGIN TRY

            DECLARE @Result VARCHAR(10) = 'False'
            DECLARE @PrevBedAssignmentId INT, @NexttoNextBedAssignmentId INT
            DECLARE @StartDate Datetime

            SELECT  @PrevBedAssignmentId = BedAssignmentId 
            FROM    BedAssignments
            WHERE   NextBedAssignmentId = @CurrentbedAssignmentId
            
            SELECT  @NexttoNextBedAssignmentId = NextBedAssignmentId
            FROM    BedAssignments
            WHERE   BedAssignmentId = @NextBedAssignmentId
            
            SELECT  @StartDate =  StartDate
            FROM    BedAssignments
            WHERE   BedAssignmentId = @NexttoNextBedAssignmentId
            
            UPDATE  dbo.BedAssignments
            SET     RecordDeleted = 'Y' ,
                    DeletedBy = SYSTEM_USER ,
                    DeletedDate = CURRENT_TIMESTAMP
            WHERE   BedAssignmentId in( @CurrentbedAssignmentId, @NextBedAssignmentId)

            Update	dbo.BedAssignments
			SET		EndDate = @StartDate,
					NextBedAssignmentId = @NexttoNextBedAssignmentId
			WHERE	BedAssignmentId = @PrevBedAssignmentId
			
			SET @Result = 'True'
		
		-- Added by Bernardin for Core Bugs Task# 1943
            UPDATE  BedAttendances
            SET     RecordDeleted = 'Y' ,
                    DeletedBy = SYSTEM_USER ,
                    DeletedDate = CURRENT_TIMESTAMP
            WHERE   BedAssignmentId in( @CurrentbedAssignmentId, @NextBedAssignmentId)
		
            UPDATE  Services
            SET     RecordDeleted = 'Y' ,
                    DeletedBy = SYSTEM_USER ,
                    DeletedDate = CURRENT_TIMESTAMP
            FROM    Services S
                    INNER JOIN BedAttendances BA ON S.ServiceId = BA.ServiceId
            WHERE   BA.BedAssignmentId in( @CurrentbedAssignmentId, @NextBedAssignmentId)
                    AND s.Status NOT IN ( 75, 76 )
        -- Changes Ends
         
            SELECT  @Result
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCBedBoardRemoveBedAssignmentLeaves') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
        END CATCH
    END

