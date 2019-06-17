IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[csp_CalculateAgeRegistrations]' 
                              ) 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_CalculateAgeRegistrations] 

GO 

CREATE PROCEDURE [dbo].[csp_CalculateAgeRegistrations] (@DocumentVersionId INT 
                                                        , 
@age              VARCHAR(50) OUTPUT) 
AS 
/*********************************************************************/ 
/* Stored Procedure: [csp_CalculateAgeRegistrations]               */ 
/* Creation Date:  08 Sept 2014                                    */ 
/* Author:  Malathi Shiva                     */ 
/* Purpose: To generate age based on the DOB of a client */ 
/* Data Modifications:                   */ 
/*  Modified By    Modified Date    Purpose        */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN 
      DECLARE @later DATETIME 

      SET @later = Getdate() 

      IF( @DocumentVersionId < 0 ) 
        BEGIN 
            SELECT @age = Cast(Datediff(YY, DOB, @later) - CASE 
                                                             WHEN 
                               @later >= Dateadd(YY 
                                         , 
                                         Datediff(YY, 
                                         DOB 
                                         , 
                                         @later), DOB 
                                         ) 
                                                           THEN 
                                                             0 
                                                             ELSE 1 
                                                           END AS VARCHAR(10)) 
            FROM   Clients C 
            WHERE  IsNull(C.RecordDeleted, 'N') = 'N' 

            IF( @age = '0' ) 
              BEGIN 
                  SELECT @age = Cast(Datediff(MM, DOB, @later) - CASE 
                                                                   WHEN 
                                     @later >= Dateadd(MM 
                                               , 
                                               Datediff(MM, 
                                               DOB 
                                               , 
                                               @later), DOB 
                                               ) 
                                                                 THEN 
                                                                   0 
                                                                   ELSE 1 
                                                                 END AS 
                                     VARCHAR(10)) 
                  FROM   Clients C 
                  WHERE  IsNull(C.RecordDeleted, 'N') = 'N' 

                  IF( @age = '0' ) 
                    BEGIN 
                        SELECT @age = Cast(Datediff(DD, DOB, @later) - CASE 
                                                                         WHEN 
                                           @later >= Dateadd(DD 
                                                     , 
                                                     Datediff(DD, 
                                                     DOB 
                                                     , 
                                                     @later), DOB 
                                                     ) 
                                                                       THEN 
                                                                         0 
                                                                         ELSE 1 
                                                                       END AS 
                                           VARCHAR(10)) 
                        FROM   Clients C 
                        WHERE  IsNull(C.RecordDeleted, 'N') = 'N' 

                        SET @age = Cast(Cast(@age AS INT) - 1 AS VARCHAR) 
                                   + ' Days' 
                    END 
                  ELSE 
                    BEGIN 
                        SET @age = @age + ' Months' 
                    END 
              END 
            ELSE 
              BEGIN 
                  SET @age = @age + ' Years' 
              END 
        END 
      ELSE 
        BEGIN 
            SELECT @age = Cast(Datediff(YY, DateOfBirth, @later) - CASE 
                                                                     WHEN 
                               @later >= Dateadd(YY, 
                                         Datediff( 
                                         YY, 
                                         DateOfBirth, 
                                         @later), 
                                         DateOfBirth) 
                                                                   THEN 0 
                                                                     ELSE 1 
                                                                   END AS 
                               VARCHAR( 
                               10)) 
            FROM   CustomDocumentRegistrations C 
            WHERE  IsNull(C.RecordDeleted, 'N') = 'N' 

            IF( @age = '0' ) 
              BEGIN 
                  SELECT @age = Cast(Datediff(MM, DateOfBirth, @later) - CASE 
                                                                           WHEN 
                                     @later >= Dateadd(MM, 
                                               Datediff( 
                                               MM, 
                                               DateOfBirth, 
                                               @later), 
                                               DateOfBirth) 
                                                                         THEN 0 
                                                                           ELSE 
                                     1 
                                                                         END AS 
                                     VARCHAR( 
                                     10)) 
                  FROM   CustomDocumentRegistrations C 
                  WHERE  IsNull(C.RecordDeleted, 'N') = 'N' 

                  IF( @age = '0' ) 
                    BEGIN 
                        SELECT @age = Cast(Datediff(DD, DateOfBirth, @later) 
                                           - CASE 
                                               WHEN 
                                           @later >= Dateadd(DD, 
                                                     Datediff( 
                                                     DD, 
                                                     DateOfBirth, 
                                                     @later), 
                                                     DateOfBirth) 
                                             THEN 0 
                                               ELSE 
                                           1 
                                             END 
                                           AS 
                                           VARCHAR( 
                                           10)) 
                        FROM   CustomDocumentRegistrations C 
                        WHERE  IsNull(C.RecordDeleted, 'N') = 'N' 

                        SET @age = Cast(Cast(@age AS INT) - 1 AS VARCHAR) 
                                   + ' Days' 
                    END 
                  ELSE 
                    BEGIN 
                        SET @age = @age + ' Months' 
                    END 
              END 
            ELSE 
              BEGIN 
                  SET @age = @age + ' Years' 
              END 
        END 
  END 

GO 