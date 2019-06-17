IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCCreateUpdateClientAddress')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCCreateUpdateClientAddress;
    END;
GO

CREATE PROCEDURE ssp_SCCreateUpdateClientAddress
    @CurrentUser VARCHAR(30)
  , @CurrentDate DATETIME
AS /******************************************************************************
**		File: 
**		Name: ssp_SCCreateUpdateClientAddress
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
**		Date: 2/13/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      2/13/2017          jcarlson             created
*******************************************************************************/
    BEGIN TRY
       
            BEGIN TRAN;

   /*     This table needs to be created and populated in the calling stored procedure
   
   CREATE TABLE #ClientAddresses (
              ClientId INT NOT NULL
            , AddressType INT NOT NULL
            , [Address] VARCHAR(150) NOT NULL
            , City VARCHAR(50) NOT NULL
            , [State] VARCHAR(2) NOT NULL
            , Zip VARCHAR(25) NOT NULL
            , Billing CHAR(1) NOT NULL
            , CurrentUser VARCHAR(30) NOT NULL
            , CurrentDate DATETIME NOT NULL
            );
*/
        CREATE TABLE #ClientHistoryUpdate (
              ClientAddressId INT
            , ClientId INT
            , AddressType INT
            , StartDate DATETIME
            , ModifiedBy VARCHAR(30)
            , ModifiedDate DATETIME
            );

			--This section will only run if the sp is not being called by the client information post update sp.. as we do not need to create any records just update the previous history record
    

                IF EXISTS ( SELECT  COUNT(a.ClientId) AS ClientIdCount
                            FROM    #ClientAddresses AS a
                            WHERE   a.Billing = 'Y'
                            GROUP BY a.ClientId
                            HAVING  COUNT(a.ClientId) > 1 )
                    BEGIN
                
                        RAISERROR('You can only have 1 Billing address per client.',16,1);

                    END;
	
                IF EXISTS ( SELECT  COUNT(a.ClientId) AS ClientIdCount
                            FROM    #ClientAddresses AS a
                            GROUP BY a.ClientId, a.AddressType
                            HAVING  COUNT(a.ClientId) > 1 )
                    BEGIN
                
                        RAISERROR('You can only have 1 address type per client.',16,1);

                    END;
                CREATE TABLE #ExistingOutput ( ClientAddressId INT );
        --if any coming in are billable, update the other billable record to not billable and create a history record
	CREATE TABLE #billingupdate  ( ClientAddressId INT );
		IF EXISTS ( SELECT 1
					FROM #ClientAddresses AS a
					WHERE a.Billing = 'Y'
					)
					BEGIN
                    UPDATE a 
					SET a.Billing = 'N',
					a.ModifiedBy = @CurrentUser,
					a.ModifiedDate = @CurrentDate
					OUTPUT Inserted.ClientAddressId INTO #billingupdate (ClientAddressId)
					FROM dbo.ClientAddresses AS a 
					JOIN #ClientAddresses AS b ON a.ClientId = b.ClientId
					WHERE a.Billing = 'Y'

					
				INSERT  INTO dbo.ClientAddressHistory ( ClientId, AddressType, Address, City, State, Zip, Display, Billing, CreatedBy, CreatedDate, ModifiedBy,
                                                        ModifiedDate, RecordDeleted, StartDate )
                OUTPUT  Inserted.ClientAddressId, Inserted.ClientId, Inserted.AddressType, Inserted.StartDate, Inserted.ModifiedBy, Inserted.ModifiedDate
                        INTO #ClientHistoryUpdate ( ClientAddressId, ClientId, AddressType, StartDate, ModifiedBy, ModifiedDate )
                SELECT  a.ClientId, a.AddressType, a.Address, a.City, a.State, a.Zip, a.Display, 'N', a.ModifiedBy, a.ModifiedDate, a.ModifiedBy,
                        a.ModifiedDate, 'N', CONVERT(DATE, GETDATE())
                FROM    dbo.ClientAddresses AS a
                JOIN    #billingupdate AS b ON b.ClientAddressId = a.ClientAddressId
				
					END
		--Update Existing Records
                UPDATE  a
                SET     a.ModifiedBy = b.CurrentUser, a.ModifiedDate = b.CurrentDate, a.[Address] = b.[Address], a.City = b.City, a.[State] = b.[State], a.Zip = b.Zip,
                        a.Billing = ISNULL(b.Billing, 'N'),
                        a.Display = ISNULL(b.[Address], '') + ' ' + ISNULL(b.City, '') + ', ' + ISNULL(b.[State], '') + ' ' + ISNULL(b.Zip, '')
                OUTPUT  Inserted.ClientAddressId
                        INTO #ExistingOutput ( ClientAddressId )
                FROM    dbo.ClientAddresses AS a
                JOIN    #ClientAddresses AS b ON b.AddressType = a.AddressType
                                                 AND b.ClientId = a.ClientId
                WHERE   ISNULL(a.RecordDeleted, 'N') = 'N';

                CREATE TABLE #NewOutput ( ClientAddressId INT );

	            --create new records
                INSERT  INTO dbo.ClientAddresses ( ClientId, AddressType, Address, City, State, Zip, Display, Billing, CreatedBy, CreatedDate, ModifiedBy,
                                                   ModifiedDate )
                OUTPUT  Inserted.ClientAddressId
                        INTO #NewOutput ( ClientAddressId )
                SELECT  b.ClientId, b.AddressType, b.Address, b.City, b.State, b.Zip,
                        ISNULL(b.Address, '') + ' ' + ISNULL(b.City, '') + ', ' + ISNULL(b.State, '') + ' ' + ISNULL(b.Zip, ''), ISNULL(b.Billing, ''),
                        b.CurrentUser, b.CurrentDate, b.CurrentUser, b.CurrentDate
                FROM    #ClientAddresses AS b
                WHERE   NOT EXISTS ( SELECT 1
                                     FROM   #ExistingOutput AS a
                                     JOIN   dbo.ClientAddresses AS c ON c.ClientAddressId = a.ClientAddressId
                                                                        AND b.ClientId = c.ClientId
                                                                        AND b.AddressType = c.AddressType );

	            --create client history records
                INSERT  INTO dbo.ClientAddressHistory ( ClientId, AddressType, Address, City, State, Zip, Display, Billing, CreatedBy, CreatedDate, ModifiedBy,
                                                        ModifiedDate, RecordDeleted, StartDate )
                OUTPUT  Inserted.ClientAddressId, Inserted.ClientId, Inserted.AddressType, Inserted.StartDate, Inserted.ModifiedBy, Inserted.ModifiedDate
                        INTO #ClientHistoryUpdate ( ClientAddressId, ClientId, AddressType, StartDate, ModifiedBy, ModifiedDate )
                SELECT  a.ClientId, a.AddressType, a.Address, a.City, a.State, a.Zip, a.Display, a.Billing, a.ModifiedBy, a.ModifiedDate, a.ModifiedBy,
                        a.ModifiedDate, 'N', CONVERT(DATE, GETDATE())
                FROM    dbo.ClientAddresses AS a
                JOIN    #ExistingOutput AS b ON b.ClientAddressId = a.ClientAddressId;

                INSERT  INTO dbo.ClientAddressHistory ( ClientId, AddressType, Address, City, State, Zip, Display, Billing, CreatedBy, CreatedDate, ModifiedBy,
                                                        ModifiedDate, RecordDeleted, StartDate )
                OUTPUT  Inserted.ClientAddressId, Inserted.ClientId, Inserted.AddressType, Inserted.StartDate, Inserted.ModifiedBy, Inserted.ModifiedDate
                        INTO #ClientHistoryUpdate ( ClientAddressId, ClientId, AddressType, StartDate, ModifiedBy, ModifiedDate )
                SELECT  a.ClientId, a.AddressType, a.Address, a.City, a.State, a.Zip, a.Display, a.Billing, a.ModifiedBy, a.ModifiedDate, a.ModifiedBy,
                        a.ModifiedDate, 'N', CONVERT(DATE, GETDATE())
                FROM    dbo.ClientAddresses AS a
                JOIN    #NewOutput AS b ON b.ClientAddressId = a.ClientAddressId;

		--		SELECT * FROM #ClientHistoryUpdate
  --         SELECT *
		--    FROM    dbo.ClientAddressHistory AS cah
  --      JOIN    #ClientHistoryUpdate AS a ON a.ClientId = cah.ClientId
  --                                           AND a.AddressType = cah.AddressType
  --                                           AND cah.ClientAddressId <> a.ClientAddressId
  --      WHERE   ISNULL(cah.RecordDeleted, 'N') = 'N'
		--AND cah.StartDate IS NOT NULL
  --              AND NOT EXISTS ( SELECT 1
  --                               FROM   dbo.ClientAddressHistory AS aa
  --                               WHERE  cah.ClientId = aa.ClientId
  --                                      AND ISNULL(aa.RecordDeleted, 'N') = 'N'
  --                                      AND cah.AddressType = aa.AddressType
		--								AND a.ClientAddressId <> aa.ClientAddressId
		--								--AND aa.StartDate IS NOT NULL
  --                                      AND ( CONVERT(DATE, aa.StartDate) > CONVERT(DATE, cah.StartDate)
  --                                            OR ( CONVERT(DATE, cah.StartDate) = CONVERT(DATE, aa.StartDate)
  --                                                 AND aa.ClientAddressId > cah.ClientAddressId
  --                                               )
  --                                          ) );
	    --end date previous history records
        UPDATE  cah
        SET     ModifiedBy = a.ModifiedBy, ModifiedDate = a.ModifiedDate, StartDate = CASE WHEN DATEDIFF(DAY, cah.StartDate, a.StartDate) = 0 THEN NULL
                                                                                           ELSE cah.StartDate
                                                                                      END,
                EndDate = CASE WHEN DATEDIFF(DAY, cah.StartDate, a.StartDate) = 0 THEN NULL
                               WHEN cah.StartDate IS NULL THEN NULL
                               ELSE CONVERT(DATE, DATEADD(DAY, -1, a.StartDate))
                          END
        FROM    dbo.ClientAddressHistory AS cah
        JOIN    #ClientHistoryUpdate AS a ON a.ClientId = cah.ClientId
                                             AND a.AddressType = cah.AddressType
                                             AND cah.ClientAddressId <> a.ClientAddressId
        WHERE   ISNULL(cah.RecordDeleted, 'N') = 'N'
		AND cah.StartDate IS NOT  NULL
                AND NOT EXISTS ( SELECT 1
                                 FROM   dbo.ClientAddressHistory AS aa
                                 WHERE  cah.ClientId = aa.ClientId
                                        AND ISNULL(aa.RecordDeleted, 'N') = 'N'
                                        AND cah.AddressType = aa.AddressType
										AND a.ClientAddressId <> aa.ClientAddressId
										AND aa.StartDate IS NOT NULL
                                        AND ( CONVERT(DATE, aa.StartDate) > CONVERT(DATE, cah.StartDate)
                                              OR ( CONVERT(DATE, cah.StartDate) = CONVERT(DATE, aa.StartDate)
                                                   AND aa.ClientAddressId > cah.ClientAddressId
                                                 )
                                            ) );


	--validate the dates
        IF EXISTS ( SELECT  *
                    FROM    dbo.ClientAddressHistory AS a
                    JOIN    #ClientHistoryUpdate AS cahu ON cahu.ClientId = a.ClientId
                    WHERE   ISNULL(a.RecordDeleted, 'N') = 'N'
                            AND EXISTS ( SELECT 1
                                         FROM   dbo.ClientAddressHistory AS b
                                         WHERE  ISNULL(b.RecordDeleted, 'N') = 'N'
                                                AND b.ClientId = a.ClientId
                                                AND b.AddressType = a.AddressType
                                                AND DATEDIFF(DAY, a.StartDate, ISNULL(b.EndDate, '01/01/1990')) >= 0
                                                AND DATEDIFF(DAY, ISNULL(a.EndDate, '01/01/2100'), b.StartDate) <= 0
                                                AND b.StartDate IS NOT NULL
                                                AND a.ClientAddressId <> b.ClientAddressId )
                            AND a.StartDate IS NOT NULL )
            BEGIN
                RAISERROR('You cannot have overlapping effective dates for the same address type.',16,1);

            END;
			
      

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
       
                IF @@TRANCOUNT > 0
                    BEGIN
                        ROLLBACK TRAN;

                    END;
       
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreateUpdateClientAddress') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;