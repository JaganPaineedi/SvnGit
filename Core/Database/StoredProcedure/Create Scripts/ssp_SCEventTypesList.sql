/****** Object:  StoredProcedure [dbo].[ssp_SCEventTypesList]    Script Date: 01/11/2018 12:38:04 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCEventTypesList]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCEventTypesList] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_SCEventTypesList]    Script Date: 01/11/2018 12:38:04 ******/ 


CREATE PROCEDURE [dbo].[ssp_SCEventTypesList] 
/*************************************************************/ 
/* Stored Procedure: dbo.[ssp_GetDropDownAssociateDocument ]   */ 
/* Creation Date:   3/12/2017                               */ 
/* Purpose:  To display the Recodes list page    */ 
/*  Date                  Author                 Purpose     */ 
/*  3/12/2017          Rajeshwari           Created     */ 
/* Task: Engineering Improvement Initiatives- NBL(I) #606 */ 
  /*************************************************************/ 
  @PageNumber               INT, 
  @PageSize                 INT, 
  @SortExpression           VARCHAR(100), 
  @EventName                VARCHAR(100), 
  @EventType                VARCHAR(100), 
  @AssociatedDocumentCodeId VARCHAR(100) 
AS 
  BEGIN 
      BEGIN try 
          SET @SortExpression = Rtrim(Ltrim(@SortExpression)) 

          IF Isnull(@SortExpression, '') = '' 
            SET @SortExpression = 'CategoryCode'; 

          WITH recodeslistresultset 
               AS (SELECT EventTypeId, 
                          D.DocumentName +' '+'(' 
                          + Cast(E.AssociatedDocumentCodeId AS VARCHAR(40)) 
                          + ')'                                       AS 
                          AssociatedDocumentCodeId, 
                          E.EventName, 
                          ( dbo.Csf_getglobalcodenamebyid(EventType) )AS 
                          EventType 
                          , 
                          Case WHEN (E.DisplayNextEventGroup  IS NULL ) THEN 'N'
                          else E.DisplayNextEventGroup
                           END as DisplayNextEventGroup  
                   FROM   eventtypes E 
                          JOIN DocumentCodes D 
                            ON D.DocumentCodeId = E.AssociatedDocumentCodeId 
                   WHERE ( Isnull(@EventName, '') = '' 
                            OR E.EventName LIKE '%' + @EventName + '%' ) 
                         AND ( Isnull(@EventType, '') = '' 
                                OR @EventType=E.EventType  ) 
                         AND ( Isnull(@AssociatedDocumentCodeId, '') = '' 
                                OR @AssociatedDocumentCodeId=E.AssociatedDocumentCodeId  
                             ) And  Isnull(E.RecordDeleted, 'N') = 'N' ), 
               counts 
               AS (SELECT Count(*) AS totalrows 
                   FROM   recodeslistresultset), 
               rankresultset 
               AS (SELECT EventTypeId, 
                          AssociatedDocumentCodeId, 
                          EventName, 
                          EventType, 
                          DisplayNextEventGroup, 
                          Count(*) 
                            OVER ( )  AS TotalCount, 
                          Rank() 
                            OVER ( 
                              ORDER BY CASE WHEN @SortExpression= 'EventTypeId' 
                            THEN 
                            EventTypeId 
                            END, CASE 
                            WHEN @SortExpression= 'EventTypeId DESC' THEN 
                            EventTypeId 
                            END 
                            DESC, 
                            CASE WHEN 
                            @SortExpression= 'AssociatedDocumentCodeId' THEN 
                            AssociatedDocumentCodeId END, 
                            CASE WHEN @SortExpression= 
                            'AssociatedDocumentCodeId DESC' 
                            THEN 
                            AssociatedDocumentCodeId END DESC, CASE WHEN 
                            @SortExpression= 
                            'EventName' THEN 
                            EventName END, CASE WHEN @SortExpression= 
                            'EventName DESC' 
                            THEN 
                            EventName END 
                            DESC, CASE WHEN @SortExpression= 'EventType' THEN 
                            EventType 
                            END, 
                            CASE 
                            WHEN 
                            @SortExpression= 'EventType DESC' THEN EventType END 
                            DESC, 
                            CASE 
                            WHEN 
                            @SortExpression= 'DisplayNextEventGroup' THEN 
                            DisplayNextEventGroup 
                            END, CASE 
                            WHEN @SortExpression= 'DisplayNextEventGroup DESC' 
                            THEN 
                            DisplayNextEventGroup 
                            END DESC) AS RowNumber 
                   FROM   recodeslistresultset) 
          SELECT TOP ( CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull( 
          totalrows, 
          0) 
          FROM counts 
          ) ELSE (@PageSize) END) EventTypeId, 
                                  AssociatedDocumentCodeId, 
                                  EventName, 
                                  EventType, 
                                  DisplayNextEventGroup, 
                                  TotalCount, 
                                  RowNumber 
          INTO   #finalresultset 
          FROM   rankresultset 
          WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 

          IF (SELECT Isnull(Count(*), 0) 
              FROM   #finalresultset) < 1 
            BEGIN 
                SELECT 0 AS PageNumber, 
                       0 AS NumberOfPages, 
                       0 NumberOfRows 
            END 
          ELSE 
            BEGIN 
                SELECT TOP 1 @PageNumber           AS PageNumber, 
                             CASE ( TotalCount % @PageSize ) 
                               WHEN 0 THEN Isnull(( TotalCount / @PageSize ), 0) 
                               ELSE Isnull(( TotalCount / @PageSize ), 0) + 1 
                             END                   AS NumberOfPages, 
                             Isnull(TotalCount, 0) AS NumberOfRows 
                FROM   #finalresultset 
            END 

          SELECT EventTypeId, 
                 AssociatedDocumentCodeId, 
                 EventName, 
                 EventType, 
                 DisplayNextEventGroup 
          FROM   #finalresultset 
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_SCWidgetList' 
                      ) 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error,-- Message text.                 
                      16,-- Severity.                 
                      1 -- State.                 
          ); 
      END catch 
  END 

go 