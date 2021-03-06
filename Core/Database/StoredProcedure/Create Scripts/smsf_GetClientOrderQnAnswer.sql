/****** Object:  UserDefinedFunction [dbo].[smsf_GetClientOrderQnAnswer]    Script Date: 2/5/2018 12:49:02 AM ******/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[smsf_GetClientOrderQnAnswer]')
                    AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
    DROP FUNCTION [smsf_GetClientOrderQnAnswer];
GO
/****** Object:  UserDefinedFunction [dbo].[smsf_GetClientOrderQnAnswer]    Script Date: 2/5/2018 12:49:02 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE FUNCTION [dbo].[smsf_GetClientOrderQnAnswer] (
      @QuestionCode VARCHAR(300)
    , @ClientOrderId INT
    )
RETURNS VARCHAR(MAX)
    BEGIN
        DECLARE @Answer VARCHAR(MAX);
        DECLARE @dropdownValue VARCHAR(100);

        SELECT  @Answer = CASE ISNULL(COA.AnswerType, '')
                            WHEN 8537 THEN ISNULL(COA.AnswerText, '')
                            WHEN 8538 THEN GC.Code
                            WHEN 8541 THEN dbo.[GetDateFormatForLabSoft](COA.AnswerDateTime, '|^~\&')
                          END
        FROM    ClientOrders CO
        JOIN    ClientOrderQnAnswers COA ON COA.ClientOrderId = CO.ClientOrderId
        JOIN    OrderQuestions OQ ON OQ.QuestionId = COA.QuestionId
        LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = COA.AnswerValue
        WHERE   CO.ClientOrderId = @ClientOrderId
                AND OQ.Question = @QuestionCode
                AND CO.ClientOrderId = @ClientOrderId
                AND ISNULL(CO.RecordDeleted, 'N') = 'N'
                AND ISNULL(COA.RecordDeleted, 'N') = 'N'
                AND ISNULL(OQ.RecordDeleted, 'N') = 'N';

        RETURN ISNULL(@Answer,'');

    END;


GO
