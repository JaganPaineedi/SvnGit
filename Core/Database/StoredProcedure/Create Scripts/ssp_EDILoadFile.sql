
/****** Object:  StoredProcedure [dbo].[ssp_EDILoadFile]    Script Date: 8/19/2015 4:49:33 PM ******/
IF OBJECT_ID('[ssp_EDILoadFile]') IS NOT NULL
DROP PROCEDURE [dbo].[ssp_EDILoadFile]
GO

/****** Object:  StoredProcedure [dbo].[ssp_EDILoadFile]    Script Date: 8/19/2015 4:49:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*****************************************************************************************************/                                                
/* Stored Procedure: dbo.[ssp_EDILoadFile]                                                           */                                                
/* Creation Date:   Sometime in August 2014                                                          */                                                
/*                                                                                                   */                                                
/* Purpose: Load text file into EDIFiles.FileText                                                    */  
/*      EXTRA SUPER SPECIAL NOTE:  The file path would be the file path FROM THE SERVER              */  
/*                                 not your local machine.                                           */                                            
/*                                                                                                   */                                                
/* Test Call:  


          Exec ssp_EDILoadFile 'c:\jay\sample2.txt', 'jwheeler'    
          Exec ssp_EDILoadFile 'c:\jay\sample.999', 'jwheeler'    
        update edifiles set filetext = replace(filetext, char(10),'')
        update edifiles set filetext = replace(filetext, char(13),'')
        
          Exec ssp_EDILoadFile 'c:\jay\test277.edi', 'jwheeler'    
          Exec ssp_EDIProcessFile 1 
        
        
        Declare @Delim Varchar(10) =      '~'                        
        Exec ssp_EDILoadFile 'D:\Streamline\LoadData\EDI Files\X12 Test Files\UHIN\Files received, 'jwheeler', @Delim                                  
        
                                                                                                     */                                                
/*                                                                                                   */                                                
/* Change Log:                                                                                       */                                                
/*                                                                                                   */                                                
/*                                                                                                   */   
/* David K    9/3/2015   Implementing Improved Error Handling                                        */                                             
/*****************************************************************************************************/                                             


CREATE PROCEDURE [dbo].[ssp_EDILoadFile]
    @InputFileName NVARCHAR(MAX)
   ,@CreatedByUserId NVARCHAR(MAX) = 'EDIFILELOAD'
   ,@EDIFileId INT OUTPUT
AS 
    BEGIN
        DECLARE @CreatedByTimeStamp DATETIME = GETDATE()
        DECLARE @FileText NVARCHAR(MAX)
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @UnknownFileTypeId INT
        DECLARE @MySQL NVARCHAR(MAX)
        
		DECLARE @SegmentSeparator NVARCHAR(5)
				,@ElementSeparator NVARCHAR(5)
				,@SubElementSeparator NVARCHAR(5)
				,@RepititionSeparator NVARCHAR(5)

        BEGIN TRY       
            SELECT  @UnknownFileTypeId = EFT.EDIFileTypeId
            FROM    EDIFileTypes EFT
            WHERE   EFT.FileTypeName = '???'
        
            IF @UnknownFileTypeId IS NULL 
                BEGIN
                    SET @ErrorMessage = 'Table EDIFileTypes is missing FileTypeName ''???'' for unknown files.'
                    RAISERROR (@ErrorMessage,16,1)        
                END

		  

            IF OBJECT_ID('Tempdb..#MyTable') IS NOT NULL 
                DROP TABLE #MyTable
            
            CREATE TABLE #MyTable (aFile NVARCHAR(MAX))


            SET @MySQL = 'BULK INSERT #MyTable FROM ''' + @InputFileName + ''' WITH (ROWTERMINATOR='''')'

            EXEC sp_executesql @MySQL  

			IF NOT EXISTS (SELECT 1 FROM #MyTable mt WHERE aFile IS NOT NULL)
				BEGIN
                    SET @ErrorMessage = 'File ' + @InputFileName + ' is missing or empty.'
                    RAISERROR (@ErrorMessage,16,1)        
                END
  

				
			-- Numbers per the implementation guide.
			-- Only one character for segment separator
			SELECT @SegmentSeparator = SUBSTRING(afile,106,1)
				,@ElementSeparator  = SUBSTRING(afile,4,1)
				,@SubElementSeparator = SUBSTRING(afile,105,1)
				,@RepititionSeparator = SUBSTRING(afile,83,1)
				
				FROM #MyTable mt 
            
            INSERT  INTO EDIFiles
                    (EDIFileTypeId
                    ,FileName
                    ,Filetext
                    ,SegmentSeparator
					,ElementSeparator
					,SubElementSeparator
					,RepetitionSeparator
                    ,CreatedBy
                    ,CreatedDate
                    ,ModifiedBy
                    ,ModifiedDate
                    )
                    SELECT  @UnknownFileTypeId
                           ,@InputFileName
                           ,aFile
                           ,@SegmentSeparator
						   ,@ElementSeparator
						   ,@SubElementSeparator
						   ,@RepititionSeparator
                           ,@CreatedByUserId
                           ,@CreatedByTimeStamp
                           ,@CreatedByUserId
                           ,@CreatedByTimeStamp
                    FROM    #mytable           
						
					
			SELECT @EDIFileId = SCOPE_IDENTITY()                             

            IF NOT EXISTS (SELECT 1 FROM #MyTable mt WHERE LEFT(aFile,3) = 'ISA')
				BEGIN
                    SET @ErrorMessage = 'File ' + @InputFileName + ' does not appear to be an EDI File. (File does not begin with an ISA segment)'
                    INSERT INTO dbo.EDIFileErrors
                            (
                             CreatedBy
                            ,CreatedDate
                            ,ModifiedBy
                            ,ModifiedDate
                            ,EDIFileId
                            ,ErrorCode
                            ,ErrorMessage
                            )
                    VALUES  (
                              @CreatedByUserId-- CreatedBy - type_CurrentUser
                            ,GETDATE()-- CreatedDate - type_CurrentDatetime
                            ,@CreatedByUserId-- ModifiedBy - type_CurrentUser
                            ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                            ,@EDIFileId -- EDIFileId - int
                            ,NULL-- ErrorCode - varchar(10)
                            ,@ErrorMessage-- ErrorMessage - type_Comment2
                            )
                    RAISERROR (@ErrorMessage,16,1)        
				END   

        END TRY

    
        BEGIN CATCH
            DECLARE @ThisProcedureName VARCHAR(255) = ISNULL(OBJECT_NAME(@@PROCID), 'Testing')
            DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(), @ThisProcedureName)) 
            DECLARE @ErrorLine VARCHAR(25) = ISNULL(ERROR_LINE(),0)                
            SET @ErrorMessage = @ThisProcedureName + ' Reports Error Thrown by: ' + @ErrorProc + CHAR(13)
            SET @ErrorMessage += ISNULL(CONVERT(VARCHAR(4000), ERROR_MESSAGE()), 'Unknown') + ' on Line: ' + @ErrorLine
                
                --+ CHAR(13) + @ThisProcedureName + ' Variable dump:' + CHAR(13) 
                --+ '@TableName:' + ISNULL(@TableName, 'Null') + CHAR(13) 
                --+ '@IdentityColumn:' + ISNULL(@IdentityColumn,'Null') + CHAR(13)
                --+ ISNULL(CAST(@DataStoreValues AS VARCHAR(MAX)), 'No ##DataStore') 

            RAISERROR (@ErrorMessage,16,1);      
        END CATCH

    END
    
    RETURN
    
    
    --select * from edifiles

GO


