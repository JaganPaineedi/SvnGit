
/****** Object:  StoredProcedure [dbo].[ssp_ListSCOrders]    Script Date: 08/12/2013 16:56:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListSCOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListSCOrders]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ListSCOrders]    Script Date: 08/12/2013 16:56:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 
CREATE PROCEDURE [dbo].[ssp_ListSCOrders] @PageNumber     INT, 
                                     @PageSize       INT, 
                                     @SortExpression VARCHAR(100), 
                                     @OrderType      INT, 
                                     @Active         INT, 
                                     @OrderName      VARCHAR(100), 
                                     @OtherFilter    INT,
                                     @IncludeAdhocOrder BIT = 0 ,
                                     @FromDate DATETIME = NULL ,
									 @ToDate DATETIME = NULL ,
									 @LaboratoryId INT = null
AS 
  -- =============================================      
  -- Author: Vithobha    
  -- Create date:14/06/2013     
  -- Description: Return the Orders data for List page based on the filter.     
  -- exec  ssp_ListSCOrders -1,100,'OrderName',-1,-1,null,-1    
  -- Dec 03 2015	Pradeep.A	Changed join to Left join with Staff
  -- Jun 22 2016	Pradeep.A 	If CreatedBy is NULL, set 'SYSTEM' for the Orders which are created by backend Service.
  -- July 18 2018   Neha        Added Date filter to Orders List Page w.r.t Engineering Improvement Initiatives NBL(I) #694.
  /* 20-SEPT-2018  Neha         Added a new filter called @LaboratoryId w.r.t Task EII 716.  */       

  -- =============================================       
  BEGIN 
      BEGIN try 
          CREATE TABLE #customfilters 
            ( 
               orderid INT NOT NULL 
            ) 

          DECLARE @ApplyFilterClicked CHAR(1) 
          DECLARE @CustomFilterApplied CHAR(1) 

          SET @SortExpression=Rtrim(Ltrim(@SortExpression)) 

          IF Isnull(@SortExpression, '') = '' 
            BEGIN 
                SET @SortExpression='OrderName' 
            END 

          SET @ApplyFilterClicked= 'Y' 
          SET @CustomFilterApplied= 'N' 

          IF @OtherFilter > 10000 
            BEGIN 
                SET @CustomFilterApplied= 'Y' 

                INSERT INTO #customfilters 
                            (orderid) 
                EXEC Scsp_ListSCOrders
                  @OrderType =@OrderType, 
                  @OrderName=@OrderName, 
                  @Active =@Active, 
                  @OtherFilter =@OtherFilter 
            END; 

          WITH listpmorders 
               AS (SELECT O.OrderId, 
                          O.OrderName, 
                          CASE ISNULL(o.AdhocOrder,'N') WHEN 'Y' THEN 'Yes' ELSE 'No' 
                                  END AS AdhocOrder,
                          S.LastName +', '+s.FirstName As CreatedBy,
                          G.CodeName AS [OrderType], 
                          Active= CASE Isnull(O.Active, 'Y') 
                                    WHEN 'Y' THEN 'Yes' 
                                    ELSE 'No' 
                                  END ,
                          L.LaboratoryName as Laboratory
                   FROM   orders AS O 
                          JOIN globalcodes AS G 
                            ON G.GlobalCodeId = O.OrderType 
                          LEFT JoIN Staff As S
                            ON S.UserCode=O.CreatedBy AND ISNULL(S.RecordDeleted, 'N') = 'N' 
                          LEFT JoIN OrderLabs OL 
                            ON O.OrderId = OL.OrderId 
                          LEFT JOIN Laboratories L 
                            ON OL.LaboratoryId = L.LaboratoryId
                          
                   WHERE  ( 
                    ((@IncludeAdhocOrder=0 AND ISNULL(AdhocOrder,'N')<>'Y') OR (@IncludeAdhocOrder=1))
                    AND (  
					CAST(ISNULL(@FromDate, O.CreatedDate) AS DATE) <= CAST(O.CreatedDate AS DATE) -- ignoring time  
					AND CAST(O.CreatedDate AS DATE)  <=  CAST(ISNULL(@ToDate, O.CreatedDate) AS DATE)
					)  
                     AND  Isnull(O.RecordDeleted, 'N') = 'N' 
                            AND ( ( @CustomFilterApplied = 'Y' 
                                    AND EXISTS(SELECT * 
                                               FROM   #customfilters CF 
                                               WHERE  CF.orderid = O.OrderId) ) 
                                   OR ( @CustomFilterApplied = 'N' 
                                        AND ( Isnull(@OrderType, -1) = -1 
                                               OR O.OrderType = @OrderType ) 
                                        AND ( @Active = -1 
                                               OR ( @Active = 1 
                                                    AND Isnull(O.Active, 'Y') = 
                                                        'Y' ) 
                                               OR ( @Active = 2 
                                                    AND Isnull(O.Active, 'N') = 
                                                        'N' ) 
                                            ) 
                                        AND ( @OrderName IS NULL 
                                               OR O.OrderName LIKE '%' + 
                                                  @OrderName + 
                                                                   '%' 
                                            )
                                        AND ( Isnull(@LaboratoryId, -1) = -1 
                                               OR L.LaboratoryId = @LaboratoryId )  ) ) 
                          )), 
               counts 
               AS (SELECT Count(*) AS TotalRows 
                   FROM   listpmorders), 
               rankresultset 
               AS (SELECT OrderId, 
                          OrderName,
                          AdhocOrder,
                          CreatedBy, 
                          [OrderType], 
                          Active, 
                          Laboratory,
                          Count(*) 
                            OVER ( )    AS TotalCount, 
                          Rank() 
                            OVER( 
                              ORDER BY CASE WHEN @SortExpression= 'OrderName' 
                            THEN 
                            OrderName 
                            END, 
                            CASE 
                            WHEN @SortExpression= 'OrderName DESC' THEN 
                            OrderName 
                            END 
                            DESC 
                            , 
                            CASE 
                            WHEN 
                            @SortExpression= 'OrderType' THEN OrderType END, 
                            CASE 
                            WHEN 
                            @SortExpression= 
                            'OrderType DESC' THEN OrderType END DESC, 
                            CASE WHEN @SortExpression = 'Active' 
                            THEN Active END, CASE WHEN @SortExpression= 
                            'Active DESC' THEN  Active END DESC 
                            , 
                            CASE WHEN @SortExpression = 'AdhocOrder' 
                            THEN AdhocOrder END, CASE WHEN @SortExpression= 
                            'AdhocOrder DESC' THEN  AdhocOrder END DESC 
                            , 
                            CASE WHEN @SortExpression = 'CreatedBy' 
                            THEN CreatedBy END, CASE WHEN @SortExpression= 
                            'CreatedBy DESC' THEN  CreatedBy END DESC 
                            , 
                            CASE WHEN @SortExpression = 'Laboratory' 
                            THEN Laboratory END, CASE WHEN @SortExpression= 
                            'Laboratory DESC' THEN  Laboratory END DESC 
                            , 
                            orderid ) AS RowNumber 
                   FROM   listpmorders) 
          SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(totalrows 
          , 
          0) 
          FROM counts) 
          ELSE (@PageSize) END) OrderId, 
								OrderName, 
								AdhocOrder,
                                CreatedBy, 
								[OrderType], 
								 Active, 
								 Laboratory, 
                                totalcount, 
                                rownumber 
          INTO   #finalresultset 
          FROM   rankresultset 
          WHERE  rownumber > ( ( @PageNumber - 1 ) * @PageSize ) 

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
                             CASE ( totalcount % @PageSize ) 
                               WHEN 0 THEN Isnull(( totalcount / @PageSize ), 0) 
                               ELSE Isnull(( totalcount / @PageSize ), 0) + 1 
                             END                   AS NumberOfPages, 
                             Isnull(totalcount, 0) AS NumberOfRows 
                FROM   #finalresultset 
            END 

          SELECT OrderId, 
                          OrderName, 
                          AdhocOrder,
                          ISNULL(CreatedBy,'SYSTEM') AS CreatedBy, 
                          [OrderType], 
                          Active ,
                          Laboratory
          FROM   #finalresultset 
          ORDER  BY rownumber 

          DROP TABLE #customfilters 
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_ListSCOrders' 
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

GO


