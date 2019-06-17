
/****** Object:  StoredProcedure [dbo].[csp_ProcessUnProcessed835Files]    Script Date: 06/09/2016 09:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if object_id('csp_ProcessUnProcessed835Files', 'P') is not null
	drop procedure csp_ProcessUnProcessed835Files
go

create PROCEDURE [dbo].[csp_ProcessUnProcessed835Files]
-- Nightly process for 835 file processing.
AS
    BEGIN


        DECLARE @I INT

        DECLARE @J INT

        DECLARE @Counter INT = 1
		
        DECLARE @ProcessingDate DATETIME 
		
		
        SELECT  @ProcessingDate = GETDATE()
			
        SELECT  @I = MIN(ERFileId)
        FROM    dbo.ERFiles
        WHERE   ISNULL(Processed, 'N') = 'N'
				AND isnull(Processing, 'N') = 'N'
                AND ISNULL(RecordDeleted, 'N') = 'N'
                --AND CAST(ImportDate AS DATE) >= CAST(@ProcessingDate AS DATE)
                AND ISNULL(DoNotProcess, 'N') = 'N'


        WHILE @I <= ( SELECT    MAX(ERFileId)
                      FROM      dbo.ERFiles
                      WHERE     ISNULL(Processed, 'N') = 'N'
                                AND ISNULL(RecordDeleted, 'N') = 'N'
                                --AND CAST(ImportDate AS DATE) >= CAST(@ProcessingDate AS DATE)
                                AND ISNULL(DoNotProcess, 'N') = 'N'
                    )
--        WHILE @Counter <= 5
            BEGIN

		
                EXEC dbo.ssp_PMElectronicProcessERFile @ERFileId = @I, @UserId = 550 
		
        --PRINT @J
                PRINT @I
                PRINT 'next file'
		

                SELECT  @J = @I
        		
		
                SELECT  @I = MIN(ERFileId)
                FROM    dbo.ERFiles
                WHERE   ISNULL(Processed, 'N') = 'N'
                        AND ISNULL(RecordDeleted, 'N') = 'N'
                        --AND CAST(ImportDate AS DATE) >= CAST(@ProcessingDate AS DATE)
                        AND ISNULL(DoNotProcess, 'N') = 'N'
                        AND ERFileId > @J
		
		
                SELECT  @Counter = @Counter + 1                
		                

            END
    
    END
GO
