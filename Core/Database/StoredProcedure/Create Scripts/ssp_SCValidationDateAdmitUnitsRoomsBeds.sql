/****** Object:  StoredProcedure [dbo].[ssp_SCValidationDateAdmitUnitsRoomsBeds]    Script Date: 10/27/2015 11:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
     
ALTER PROCEDURE [dbo].[ssp_SCValidationDateAdmitUnitsRoomsBeds]
    @KeyId INT ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @Flag CHAR(2)
AS /*********************************************************************/                  
/* Stored Procedure:ssp_SCValidationDateAdmitUnitsRoomsBeds          */                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                  
/* Creation Date: 27June2012                                         */                  
/*                                                                   */                  
/* Purpose: This procedure will be used to Validate For 		     */                  
/* Units/Rooms/Beds Beds Assignment StartDate & Enddate              */                
/* Input Parameters: @BedId,StartDate,EndDate				         */                
/*                                                                   */                  
/* Output Parameters:   None                                         */                  
/*                                                                   */                  
/* Return:  0=success, otherwise an error number                     */                  
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/* Date        Author			Purpose                              */                  
/* 28June2012   Vikas Kashyap  Created                               */   
/* 10/27/2015	NJain		   Added SET @EndDate = 12/31/2199 then its blank
   11/10/2015	NJain		   Replace @EndDate < EndDate in the Bed validation with EndDate IS NULL OR DATEDIFF(dd, @EndDate, EndDate) > 1 */ 
/* 11/24/2015 Vamsi     What: Added condition to check Disposition and BedNotAvailable 
                        Why: Woods - Environment Issues Tracking# 64 */
/*********************************************************************/          
    BEGIN 
        BEGIN TRY  
			
            SELECT  @EndDate = CASE WHEN ISNULL(@EndDate, '') = '' THEN '12/31/2199'
                                    ELSE @EndDate
                               END
			
            DECLARE @DateExist NVARCHAR(10)= 'FALSE';

            IF ( @Flag = 'B' )
                BEGIN
                    IF EXISTS ( SELECT  BedAssignmentId
                                FROM    BedAssignments
                                WHERE   BedId = @KeyId
                                        AND ISNULL(RecordDeleted, 'N') = 'N'
                                        AND @StartDate >= StartDate
                                        AND @StartDate <= ISNULL(EndDate, '12/31/2199')
                                         -- Added By Vamsi on 24th November 2015
                                        AND Isnull(Disposition,0) <> 5204 
                                        AND ISNULL(BedNotAvailable,'N')='N'   
                                        AND ( EndDate IS NULL
                                              OR DATEDIFF(dd, @EndDate, EndDate) > 1
                                            ) )
                        BEGIN
                            SET @DateExist = 'TRUE';
                        END
                END
            ELSE
                IF ( @Flag = 'R' )
                    BEGIN
                        IF EXISTS ( SELECT DISTINCT
                                            BA.BedId
                                    FROM    Rooms AS R
                                            INNER JOIN Beds AS B ON R.RoomId = B.RoomId
                                            INNER JOIN BedAssignments AS BA ON BA.BedId = B.BedId
                                    WHERE   B.RoomId = @KeyId
                                            AND ISNULL(R.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(B.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(BA.RecordDeleted, 'N') = 'N'
                                            AND @StartDate >= BA.StartDate
                                            AND @StartDate <= ISNULL(BA.EndDate, '12/31/2199')
                                            AND ( BA.EndDate IS NULL
                                                  OR DATEDIFF(dd, @EndDate, BA.EndDate) > 1
                                                ) )
                            BEGIN
                                SET @DateExist = 'TRUE';
                            END
                    END
                ELSE
                    IF ( @Flag = 'U' )
                        BEGIN
                            IF EXISTS ( SELECT DISTINCT
                                                BA.BedId
                                        FROM    Units AS U
                                                INNER JOIN Rooms AS R ON R.UnitId = U.UnitId
                                                INNER JOIN Beds AS B ON R.RoomId = B.RoomId
                                                INNER JOIN BedAssignments AS BA ON BA.BedId = B.BedId
                                        WHERE   R.UnitId = @KeyId
                                                AND ISNULL(R.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(B.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(BA.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(U.RecordDeleted, 'N') = 'N'
                                                AND @StartDate >= BA.StartDate
                                                AND @StartDate <= ISNULL(BA.EndDate, '12/31/2199')
                                                AND ( BA.EndDate IS NULL
                                                      OR DATEDIFF(dd, @EndDate, BA.EndDate) > 1
                                                    ) )
                                BEGIN
                                    SET @DateExist = 'TRUE';
                                END
                        END

            SELECT  @DateExist;
         
        END TRY                                                                          
        BEGIN CATCH                              
            DECLARE @Error VARCHAR(8000)                                                                           
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCValidationDateAdmitUnitsRoomsBeds') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                      
            RAISERROR                                                                                                         
 (                                                                           
  @Error, -- Message text.                                                                                                        
  16, -- Severity.                                                                                                        
  1 -- State.                                                                                                        
 );                                                                                                      
        END CATCH                                                     
    END


GO
