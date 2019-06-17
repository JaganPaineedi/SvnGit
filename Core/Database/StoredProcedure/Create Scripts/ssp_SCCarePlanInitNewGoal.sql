IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCCarePlanInitNewGoal')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCCarePlanInitNewGoal;
    END;
GO

CREATE PROCEDURE ssp_SCCarePlanInitNewGoal
@UserId int,
@ClientId int,
@DocumentVersionId int,
@EffectiveDate Datetime
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCCarePlanInitNewGoal
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
**		Date: 9/25/2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**        9/25/2018          jcarlson             created
*******************************************************************************/
    BEGIN TRY
    IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'scsp_SCCarePlanInitNewGoal')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        exec scsp_SCCarePlanInitNewGoal @UserId,@ClientId,@DocumentVersionId,@EffectiveDate;
    END;
	   
        RETURN;


    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCarePlanInitNewGoal') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR 	(		@Error,		16,		1 	);

    END CATCH;