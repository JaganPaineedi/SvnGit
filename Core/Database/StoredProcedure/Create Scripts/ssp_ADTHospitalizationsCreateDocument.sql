/****** Object:  StoredProcedure [dbo].[ssp_ADTHospitalizationsCreateDocument]    Script Date: 05/31/2017 20:00:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ADTHospitalizationsCreateDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ADTHospitalizationsCreateDocument]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ADTHospitalizationsCreateDocument]    Script Date: 05/31/2017 20:00:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ADTHospitalizationsCreateDocument]
@ADTHospitalizationId INT,       
@ViewImage image,   
@ClientId INT,
@StaffId INT,
@CurrentUser VARCHAR (50)
AS  
/**********************************************************************/  
/* Stored Procedure:  ssp_ADTHospitalizationsCreateDocument  */  
/* Creation Date:  31/May/2017                                    */  
/* Purpose: To create document from ADT Hospitalizations detail screen            */  
/* Input Parameters:   @ADTHospitalizationId ,@ViewImage, @ClientId, @StaffId, @CurrentUser      */  
/* Output Parameters:                 */  
--exec [ssp_ADTHospitalizationsCreateDocument]   
/* Return:                 */  
/* Called By:      */  
/* Calls:                                                            */  
/*                                                                   */  
/* Data Modifications:                                               */  
/* Updates:                                                          */  
/* Date            Author           Purpose           */  
          
/*********************************************************************/  
BEGIN  
    BEGIN TRY  
    
  DECLARE @DocumentCodeID INT = 1641
   ,@DocumentId INT  
   ,@DocumentVersionId INT 
   ,@Version INT
   
	DECLARE @ServerName NVARCHAR(100)
	DECLARE @DBNAME NVARCHAR(100)
	DECLARE @TEMPLATE NVARCHAR(MAX)

	EXEC SSP_ParseConnectionString @ServerName OUTPUT,@DBNAME OUTPUT
  
   SELECT @DocumentId = DocumentId
       FROM Documents  
       WHERE DocumentCodeId = @DocumentCodeId  
        AND ClientId = @ClientId  
        AND ISNULL(RecordDeleted, 'N') = 'N' 
  
    IF ( @DocumentId IS NOT NULL )  
     BEGIN  
		SELECT TOP 1 @Version = DV.Version FROM DocumentVersions DV 
		JOIN Documents D ON D.DocumentId =  DV.DocumentId 
		WHERE ISNULL(D.RecordDeleted, 'N') = 'N' AND D.DocumentCodeId = @DocumentCodeId  
        AND ClientId = @ClientId  AND ISNULL(DV.RecordDeleted, 'N') = 'N'  
        ORDER BY DV.Version DESC
        
        INSERT INTO DocumentVersions (  
		DocumentId  
       ,Version  
       ,CreatedBy  
       ,CreatedDate  
       ,ModifiedBy  
       ,ModifiedDate  
       )  
      VALUES (  
       @DocumentId  
       ,@Version + 1  
       ,@CurrentUser  
       ,GETDATE()  
       ,@CurrentUser  
       ,GETDATE()  
       )  
       
       SET @DocumentVersionId = Scope_Identity()  
     END  
     ELSE  
     BEGIN  
      INSERT INTO Documents (  
       ClientId  
       ,DocumentCodeId  
       ,EffectiveDate  
       ,STATUS  
       ,AuthorId  
       ,DocumentShared  
       ,SignedByAuthor  
       ,SignedByAll  
       ,ToSign  
       ,CurrentVersionStatus  
       ,CreatedBy  
       ,CreatedDate  
       ,ModifiedBy  
       ,ModifiedDate  
       )  
      VALUES (  
       @ClientId  
       ,@DocumentCodeID  
       ,GETDATE()  
       ,22  
       ,@StaffId  
       ,'N'  
       ,'N'  
       ,'N'  
       ,NULL  
       ,22  
       ,@CurrentUser 
       ,GETDATE()  
       ,@CurrentUser  
       ,GETDATE()  
       )  
  
      SET @DocumentId = Scope_Identity()  
  
      -- Insert new document version  
      INSERT INTO DocumentVersions (  
       DocumentId  
       ,Version  
       ,CreatedBy  
       ,CreatedDate  
       ,ModifiedBy  
       ,ModifiedDate  
       )  
      VALUES (  
       @DocumentId  
       ,1  
       ,@CurrentUser 
       ,GETDATE()  
       ,@CurrentUser  
       ,GETDATE()  
       )  
  
      SET @DocumentVersionId = Scope_Identity()  
  
      -- Set document current and in progress document version id to newly created document version id  
      
	END
    
    UPDATE d  
      SET CurrentDocumentVersionId = @DocumentVersionId  
       ,InProgressDocumentVersionId = @DocumentVersionId  
      FROM Documents d  
      WHERE d.DocumentId = @DocumentId
    
    CREATE TABLE [dbo].[#TempDocumentVersionViews](
	[DocumentVersionId] [int]  NULL,
	[ViewImage] [image]  NULL,
	[CreatedBy] VARCHAR(100)  NULL,
	[CreatedDate] Datetime  NULL,
	[ModifiedBy] VARCHAR(100)  NULL,
	[ModifiedDate] Datetime  NULL
	)
	
	INSERT INTO [#TempDocumentVersionViews]
	SELECT @DocumentVersionId, @ViewImage, @CurrentUser, GETDATE(), @CurrentUser, GETDATE()
   
	 SET @TEMPLATE = 'INSERT INTO ['+@DBNAME+'].dbo.DocumentVersionViews (  
		 DocumentVersionId 
		 ,ViewImage    
		 ,CreatedBy  
		 ,CreatedDate  
		 ,ModifiedBy  
		 ,ModifiedDate 
		 )  
		SELECT DocumentVersionId, ViewImage, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate FROM #TempDocumentVersionViews'
	    
	 EXECUTE sp_executesql @TEMPLATE
					
	INSERT INTO ADTHospitalizationDocumentVersions(
		CreatedBy
		,CreatedDate
		,ModifiedBy	
		,ModifiedDate
		,ADTHospitalizationId
		,DocumentVersionId
		)
	  VALUES(
	   @CurrentUser 
       ,GETDATE()  
       ,@CurrentUser  
       ,GETDATE()
       ,@ADTHospitalizationId
       ,@DocumentVersionId
       )
    
    END TRY  
    BEGIN CATCH  
        DECLARE @Error AS VARCHAR (MAX);  
        SET @Error = CONVERT (VARCHAR, ERROR_NUMBER()) + '*****'   
        + CONVERT (VARCHAR (4000), ERROR_MESSAGE()) + '*****'   
        + isnull(CONVERT (VARCHAR, ERROR_PROCEDURE()),  
         'ssp_ADTHospitalizationsCreateDocument') + '*****'   
         + CONVERT (VARCHAR, ERROR_LINE()) + '*****'   
         + CONVERT (VARCHAR, ERROR_SEVERITY()) + '*****'   
         + CONVERT (VARCHAR, ERROR_STATE());  
        RAISERROR (@Error, 16, 1); -- Message text.   Severity.  State.                                                                                  
    END CATCH  
END  

GO


