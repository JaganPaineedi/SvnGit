IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCPostUpdateClientInformation')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCPostUpdateClientInformation;
    END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ssp_SCPostUpdateClientInformation
    @ScreenKeyId INT
  , @StaffId INT
  , @CurrentUser VARCHAR(30)
  , @CustomParameters VARCHAR(MAX)
AS /******************************************************************************
**		File: 
**		Name: ssp_SCPostUpdateClientInformation
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
**		Date: 2/8/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      2/7/2017          jcarlson             created
**      13/08/2018        Rajeshwari S         We have added sp 'scsp_SCPostUpdateClientInformation' to correct the Primary Clinician for ROI To Do Document. Task : MHP-Support Go Live # 681
*******************************************************************************/
    BEGIN TRY
        DECLARE @locCustomParameters XML = CONVERT(XML, @CustomParameters);
	--grab all the client address ids that have been modified
        CREATE TABLE #CorePostUpdate ( ClientAddressId INT );
        INSERT  INTO #CorePostUpdate ( ClientAddressId )
        SELECT  CONVERT(INT, item)
        FROM    dbo.fnSplit(( SELECT    a.value('@ModifiedClientAddresses', 'varchar(max)')
                              FROM      @locCustomParameters.nodes('/Root/Parameters') AS XTable ( a )
                            ), ','); 

--if the client address id is < 0 remove it from the temp table
-- a negative primary key means that this is a new record and we have no history that we need to end date
        DELETE  FROM a
        FROM    #CorePostUpdate AS a
        WHERE   a.ClientAddressId < 0;
        
        IF EXISTS (SELECT *     
				   FROM   sys.Objects     
				   WHERE  object_id = Object_id(N'[dbo].[scsp_SCPostUpdateClientInformation]')     
                   AND type IN ( N'P', N'PC' ))      
        BEGIN     
        EXEC scsp_SCPostUpdateClientInformation @ScreenKeyId,@StaffId,@CurrentUser,@CustomParameters    
        END  
	
        IF NOT EXISTS ( SELECT  1
                        FROM    #CorePostUpdate )
            BEGIN
                
                RETURN;
            END;
        
        DECLARE @ClientAddressHistoryId INT
          , @StartDate DATETIME;
		  --contains the history record that was just created
        CREATE TABLE #Max (
              ClientAddressId INT
            , AddressType INT
            );
        INSERT  INTO #Max ( ClientAddressId, AddressType )
        SELECT  MAX(a.ClientAddressId), a.AddressType
        FROM    dbo.ClientAddressHistory AS a
        JOIN    dbo.ClientAddresses AS b ON b.AddressType = a.AddressType
                                            AND b.ClientId = a.ClientId
        JOIN    #CorePostUpdate AS c ON c.ClientAddressId = b.ClientAddressId
        WHERE   ISNULL(a.RecordDeleted, 'N') = 'N'
                AND a.ClientId = @ScreenKeyId
        GROUP BY a.AddressType;
		--contains the info related to the history record that was just created
        CREATE TABLE #ClientAddressInfo (
              ClientAddressId INT
            , AddressType INT
            , StartDate DATETIME
            );
        INSERT  INTO #ClientAddressInfo ( ClientAddressId, AddressType, StartDate )
        SELECT  ca.ClientAddressId, ca.AddressType, ca.StartDate
        FROM    dbo.ClientAddressHistory AS ca
        JOIN    #Max AS b ON b.ClientAddressId = ca.ClientAddressId;


        DECLARE address_Cursor CURSOR LOCAL STATIC
        FOR
            --this will be the most recent history record by start date before the record that was just created
            SELECT  c.ClientAddressId, b.StartDate
            FROM    dbo.ClientAddresses AS a
            JOIN    #ClientAddressInfo AS b ON a.AddressType = b.AddressType
            JOIN    dbo.ClientAddressHistory AS c ON c.AddressType = a.AddressType
                                                     AND a.ClientId = c.ClientId
                                                     AND ISNULL(c.RecordDeleted, 'N') = 'N'
                                                     AND NOT EXISTS ( SELECT    1
                                                                      FROM      #Max AS m
                                                                      WHERE     m.ClientAddressId = c.ClientAddressId )
            WHERE   NOT EXISTS ( SELECT 1
                                 FROM   dbo.ClientAddressHistory AS d
                                 WHERE  c.ClientId = d.ClientId
                                        AND c.AddressType = d.AddressType
                                        AND d.StartDate IS NOT NULL
                                        AND NOT EXISTS ( SELECT 1
                                                         FROM   #Max AS m
                                                         WHERE  m.ClientAddressId = d.ClientAddressId )
                                        AND ISNULL(d.RecordDeleted, 'N') = 'N'
                                        AND ( ( CONVERT(DATE, d.StartDate) > CONVERT(DATE, c.StartDate) )
                                              OR ( CONVERT(DATE, d.StartDate) = CONVERT(DATE, c.StartDate)
                                                   AND d.ClientAddressId > c.ClientAddressId
                                                 )
                                            ) );
        OPEN address_Cursor;
        FETCH NEXT FROM address_Cursor INTO @ClientAddressHistoryId, @StartDate;
        WHILE @@FETCH_STATUS = 0
            BEGIN
	    --end date the previous history record
                IF EXISTS ( SELECT  1
                            FROM    dbo.ClientAddressHistory AS a
                            WHERE   a.ClientAddressId = @ClientAddressHistoryId
                                    AND a.EndDate IS NULL
                                    AND a.StartDate IS NOT NULL )
                    BEGIN
	 
                        UPDATE  dbo.ClientAddressHistory
                        SET     ModifiedBy = @CurrentUser, ModifiedDate = GETDATE(), 
                                EndDate = CASE 
									   WHEN CONVERT(DATE, DATEADD(DAY, -1, @StartDate)) < StartDate THEN StartDate 
									   ELSE CONVERT(DATE, DATEADD(DAY, -1, @StartDate))
								  END
                        WHERE   ClientAddressId = @ClientAddressHistoryId;
                    END;

                FETCH NEXT FROM address_Cursor INTO @ClientAddressHistoryId, @StartDate;
            END;

        CLOSE address_Cursor;
        DEALLOCATE address_Cursor;
        
        RETURN;

		
    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCPostUpdateClientInformation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;