IF EXISTS ( SELECT  *
            FROM    sys.Objects
            WHERE   Object_Id = OBJECT_ID(N'dbo.csp_RDLClientsWithNoServices')
                    AND Type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE dbo.csp_RDLClientsWithNoServices
Go

CREATE PROCEDURE [dbo].[csp_RDLClientsWithNoServices]
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
                                                              'N') <> 'Y'   )
            SELECT DISTINCT
                    c.LastName + ',' + ' ' + c.FirstName + '('
                    + CONVERT(VARCHAR(15), c.ClientId) + ')' AS ClientName ,
                    ( SELECT    COUNT(*)
                      FROM      clients c
                      WHERE     ISNULL(c.RecordDeleted, 'N') = 'N'
                                AND NOT EXISTS ( SELECT 1
                                                 FROM   services s
                                                 WHERE  s.ClientId = c.clientid )
                    ) AS NumberfServicesProvided ,
                    ( SELECT    TOP 1 ce.registrationdate FROM dbo.ClientEpisodes ce
                      WHERE     ce.clientid = c.clientid 
					     AND ce.RegistrationDate BETWEEN @DateOfServiceStart
                                            AND     @DateOfServiceEnd
					  AND ISNULL(ce.RecordDeleted,'N') <> 'Y'
                    ) AS RegistrationDate ,
                
					--( SELECT    cc.ListAs
            --  WHERE     cc.relationship = @RelationshipId
            --            AND cc.clientid = c.clientid
            --) AS PCPhysician ,
			 ( SELECT   TOP 1  cc.ListAs FROM dbo.ClientContacts cc 
              WHERE     cc.relationship = @RelationshipId
                        AND cc.clientid = c.clientid AND ISNULL(cc.RecordDeleted,'N') <> 'Y'
            ) AS PCPhysician ,
         ( SELECT   TOP 1  gc.codename FROM dbo.ClientEpisodes ce
			LEFT JOIN globalcodes gc ON gc.GlobalCodeId = ce.ReferralReason1 AND ISNULL(gc.RecordDeleted,'N') <> 'Y'
              WHERE  ce.referralreason1 IN ( 6676, 6677, 6678 ) AND ce.ClientId = c.ClientId
			  AND ISNULL(ce.RecordDeleted,'N') <>'Y' 
            ) AS ReferralReason
            FROM    clients c --join services s on s.clientid = c.clientid
                    --JOIN clientcontacts cc ON cc.clientid = c.clientid
                   -- JOIN clientepisodes ce ON ce.clientid = c.clientid
                   -- LEFT JOIN globalcodes gc ON gc.globalcodeid = ce.referralreason1
            WHERE   NOT EXISTS ( SELECT 1
                                 FROM   services s
                                 WHERE  s.ClientId = c.clientid )
                 
                    AND ISNULL(c.RecordDeleted, 'N') = 'N'
                   -- AND ISNULL(ce.RecordDeleted, 'N') = 'N'
                   -- AND ISNULL(cc.RecordDeleted, 'N') = 'N'
                   -- AND ISNULL(gc.RecordDeleted, 'N') = 'N'


--AND (s.dateofservice between @DateOfServiceStart AND @DateOfServiceEnd)
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
                         'csp_RDLClientsWithNoServices') + '*****'
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








--exec csp_RDLClientsWithNoServices 'All Last Names','All First Names','2015-01-01','2017-01-01'

