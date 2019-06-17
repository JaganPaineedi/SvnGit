
IF EXISTS ( SELECT  *
            FROM    sys.Objects
            WHERE   Object_Id = OBJECT_ID(N'dbo.csp_RDLClientsWithNoServicesinLast12Months')
                    AND Type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE dbo.csp_RDLClientsWithNoServicesinLast12Months
Go

CREATE PROCEDURE [dbo].[csp_RDLClientsWithNoServicesinLast12Months]
    @LastName VARCHAR(30) ,
    @FirstName VARCHAR(30) ,
    @DateOfServiceStart DATETIME ,
    @DateOfServiceEnd DATETIME
AS 
    BEGIN
        BEGIN TRY
            BEGIN TRAN 
			  DECLARE @RelationshipId INT = ( SELECT  globalcodeid
                                            FROM    globalcodes
                                            WHERE   Category LIKE 'RELATIONSHIP'
                                                    AND CodeName LIKE 'Primary Physician'
                                                    AND ISNULL(RecordDeleted,
                                                              'N') <> 'Y'         )
    SELECT DISTINCT
            c.LastName + ',' + ' ' + c.FirstName + '('
            + CONVERT(VARCHAR(15), s.ClientId) + ')' AS ClientName ,
            ( SELECT    COUNT(*)
              FROM      services s
              WHERE     ISNULL(s.RecordDeleted, 'N') = 'N'
                        AND DATEDIFF(month, s.dateofservice, GETDATE()) > 12
						 AND ( s.dateofservice BETWEEN @DateOfServiceStart
                              AND     @DateOfServiceEnd )
							  AND s.Status IN (70,71,75)
            ) AS NumberfServicesProvided ,
                 ( SELECT    TOP 1 ce.registrationdate FROM dbo.ClientEpisodes ce
                      WHERE     ce.clientid = c.clientid 
					     AND ce.RegistrationDate BETWEEN @DateOfServiceStart
                                            AND     @DateOfServiceEnd
					  AND ISNULL(ce.RecordDeleted,'N') <> 'Y'
                    ) AS RegistrationDate ,
            ( SELECT    MAX(CONVERT(DATE, ISNULL(s.dateofservice, '12/31/2199')))
              FROM      services s
              WHERE     DATEDIFF(month, s.dateofservice, GETDATE()) > 12
                        AND ISNULL(s.RecordDeleted, 'N') = 'N'
                        AND s.clientid = c.clientid
						 AND ( s.dateofservice BETWEEN @DateOfServiceStart
                              AND     @DateOfServiceEnd )
							  AND s.Status IN (70,71,75)
              GROUP BY  s.clientid
            ) AS RecentDateofService ,
        	 ( SELECT   TOP 1  cc.ListAs FROM dbo.ClientContacts cc 
              WHERE     cc.relationship = @RelationshipId
                        AND cc.clientid = c.clientid AND ISNULL(cc.RecordDeleted,'N') <> 'Y'
            ) AS PCPhysician ,
      	   ( SELECT   TOP 1  gc.codename FROM dbo.ClientEpisodes ce
			LEFT JOIN globalcodes gc ON gc.GlobalCodeId = ce.ReferralReason1 AND ISNULL(gc.RecordDeleted,'N') <> 'Y'
              WHERE  ce.referralreason1 IN ( 6676, 6677, 6678 ) AND ce.ClientId = c.ClientId
			  AND ISNULL(ce.RecordDeleted,'N') <>'Y' 
            ) AS ReferralReason
    FROM    services s
            JOIN clients c ON c.clientid = s.clientid
            --JOIN clientcontacts cc ON cc.clientid = c.clientid
           -- JOIN clientepisodes ce ON ce.clientid = c.clientid
           -- LEFT JOIN globalcodes gc ON gc.globalcodeid = ce.referralreason1
    WHERE   DATEDIFF(month, s.dateofservice, GETDATE()) > 12
            AND ISNULL(s.RecordDeleted, 'N') = 'N'
            AND ISNULL(c.RecordDeleted, 'N') = 'N'
            --AND ISNULL(ce.RecordDeleted, 'N') = 'N'
           -- AND ISNULL(cc.RecordDeleted, 'N') = 'N'
           -- AND ISNULL(gc.RecordDeleted, 'N') = 'N'
            AND ( s.dateofservice BETWEEN @DateOfServiceStart
                                  AND     @DateOfServiceEnd )
        
            AND ( @LastName = 'All Last Names'
                  OR @LastName = c.lastname
                )
            AND ( @FirstName = 'All First Names'
                  OR @FirstName = c.firstname
                )
  COMMIT TRAN
        END TRY

        BEGIN CATCH
            IF @@TRANCOUNT > 0 
                ROLLBACK TRAN      
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'csp_RDLClientsWithNoServicesinLast12Months') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
        END CATCH






    END


	--exec csp_RDLClientsWithNoServicesinLast12Months 'All Last Names','All First Names','2015-01-01','2015-05-01'



