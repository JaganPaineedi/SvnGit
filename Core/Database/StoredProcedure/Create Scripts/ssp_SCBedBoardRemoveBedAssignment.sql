IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCBedBoardRemoveBedAssignment]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_SCBedBoardRemoveBedAssignment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
**		File: ssp_SCBedBoardRemoveBedAssignment.sql
**		Name: ssp_SCBedBoardRemoveBedAssignment
**		Desc: Removes bed assignment record
**
**		This template can be customized:
**		Return values:
** 
**		Called by:   SHS.DataServices.BedCensus.cs (RemoveBedAssignment)
**              
**		Parameters:
**		Input							Output
**      BedAssignmentId					-----------
**
**		Auth: Chuck Blaine
**		Date: Mar 12 2013
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**      22-08-2013   Veena               Copied from Bed Census
**      30-08-2013   Akwinass            Modified the script for Manage Discharge data
**      13-09-2013   Akwinass            Modified the script for Update Discharge Date in ClientInpatientVisits
**      17-09-2013   Akwinass            Modified the script to get Updated Details from in ClientInpatientVisits
**      06-12-2013   Akwinass            Modified the script to check the bedassignment has one or more regards to update ClientInpatientVisits
**      24-01-2014   Akwinass            Modified the script to revert record from discharged to Occupied
**      17-11-2015   Bernardin           Added update statments to update RecordDeleted,DeletedDate and DeletedBy Columns in BedAttendances and Services tables. Core Bugs Task# 1943
**		29-07-2016	 NJain				 Core Bugs #2156 Do not delete Services if the Status is Complete or Error
*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_SCBedBoardRemoveBedAssignment] @BedAssignmentId INT,@UserCode varchar(100)
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        BEGIN TRY
            DECLARE @disposition INT
            DECLARE @Status INT
            DECLARE @bedassignid INT
            DECLARE @Result VARCHAR(10) = 'True'

            SELECT  @Status = Status ,
                    @disposition = Disposition
            FROM    BedAssignments
            WHERE   BedAssignmentId = @BedAssignmentId

            IF @disposition = 5205
                BEGIN
                    UPDATE  A
                    SET     A.DischargedDate = NULL ,
                            A.[Status] = 4982 ,
                            A.ModifiedDate = CURRENT_TIMESTAMP ,
                            A.ModifiedBy = @UserCode
                    FROM    clientinpatientvisits A
                            JOIN BedAssignments B ON B.ClientInpatientVisitId = A.ClientInpatientVisitId
                                                     AND B.BedAssignmentId = @BedAssignmentId

                    UPDATE  dbo.BedAssignments
                    SET     Disposition = NULL ,
                            NextBedAssignmentId = NULL ,
                            EndDate = NULL
                    WHERE   BedAssignmentId = @BedAssignmentId

                    SET @Result = 'False'
                END
            ELSE
                BEGIN
                    IF NOT EXISTS ( SELECT  1
                                    FROM    BedAssignments
                                    WHERE   NextBedAssignmentId = @BedAssignmentId )
                        BEGIN
                            UPDATE  A
                            SET     A.DischargedDate = GETDATE() ,
                                    A.[Status] = 4984 ,
                                    A.ModifiedDate = CURRENT_TIMESTAMP ,
                                    A.ModifiedBy = @UserCode,
                                    A.RecordDeleted = 'Y' ,
                                    A.DeletedBy = @UserCode ,
                                    A.DeletedDate = CURRENT_TIMESTAMP
                            FROM    clientinpatientvisits A
                                    JOIN BedAssignments B ON B.ClientInpatientVisitId = A.ClientInpatientVisitId
                                                             AND B.BedAssignmentId = @BedAssignmentId
                                                             AND Disposition IS NULL

                            UPDATE  dbo.BedAssignments
                            SET     RecordDeleted = 'Y' ,
                                    DeletedBy = @UserCode ,
                                    DeletedDate = CURRENT_TIMESTAMP
                            WHERE   BedAssignmentId = @BedAssignmentId

                            SET @Result = 'Close'
                        END
                    ELSE
                        BEGIN
                            SELECT  @bedassignid = BedAssignmentId ,
                                    @Status = Status ,
                                    @disposition = Disposition
                            FROM    BedAssignments
                            WHERE   NextBedAssignmentId = @BedAssignmentId

                            UPDATE  dbo.BedAssignments
                            SET     RecordDeleted = 'Y' ,
                                    DeletedBy = @UserCode ,
                                    DeletedDate = CURRENT_TIMESTAMP
                            WHERE   BedAssignmentId = @BedAssignmentId

                            SET @Result = 'True'

                            DECLARE @dichargedisposition INT
                            DECLARE @dischargeStatus INT

                            SELECT  @dischargeStatus = Status ,
                                    @dichargedisposition = Disposition
                            FROM    BedAssignments
                            WHERE   NextBedAssignmentId = @BedAssignmentId

                            IF @dischargeStatus = 5002
                                BEGIN
                                    DECLARE @ClientInpatientVisitId INT

                                    SELECT  @ClientInpatientVisitId = ClientInpatientVisitId
                                    FROM    BedAssignments
                                    WHERE   BedAssignmentId = @BedAssignmentId

                                    IF ( SELECT COUNT(BedAssignmentId)
                                         FROM   BedAssignments
                                         WHERE  ISNULL(RecordDeleted, 'N') = 'N'
                                                AND ClientInpatientVisitId = @ClientInpatientVisitId
                                       ) > 1
                                        BEGIN
                                            UPDATE  ClientInpatientVisits
                                            SET     Status = 4982 ,
                                                    DischargedDate = NULL ,
                                                    ModifiedDate = CURRENT_TIMESTAMP ,
                                                    ModifiedBy = @UserCode
                                            WHERE   ClientInpatientVisitId = @ClientInpatientVisitId
                                        END
                                END

                            IF ( @Status = @disposition )
                                OR ( @dischargeStatus = 5002
                                     AND @dichargedisposition = 5205
                                   )
                                BEGIN
                                    UPDATE  dbo.BedAssignments
                                    SET     NextBedAssignmentId = NULL
                                    WHERE   NextBedAssignmentId = @BedAssignmentId
                                END
                            ELSE
                                BEGIN
                                    UPDATE  dbo.BedAssignments
                                    SET     Disposition = NULL ,
                                            NextBedAssignmentId = NULL ,
                                            EndDate = NULL
                                    WHERE   NextBedAssignmentId = @BedAssignmentId
                                END
                        END
                END
		
		-- Added by Bernardin for Core Bugs Task# 1943
            UPDATE  BedAttendances
            SET     RecordDeleted = 'Y' ,
                    DeletedBy = @UserCode ,
                    DeletedDate = CURRENT_TIMESTAMP
            WHERE   BedAssignmentId = @BedAssignmentId
		
            UPDATE  Services
            SET     RecordDeleted = 'Y' ,
                    DeletedBy = @UserCode ,
                    DeletedDate = CURRENT_TIMESTAMP
            FROM    Services S
                    INNER JOIN BedAttendances BA ON S.ServiceId = BA.ServiceId
            WHERE   BA.BedAssignmentId = @BedAssignmentId
                    AND s.Status NOT IN ( 75, 76 )
        -- Changes Ends
         
            SELECT  @Result
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCBedBoardRemoveBedAssignment') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
        END CATCH
    END

