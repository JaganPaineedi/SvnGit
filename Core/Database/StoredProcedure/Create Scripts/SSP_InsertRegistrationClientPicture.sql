/****** Object:  StoredProcedure [dbo].[SSP_InsertRegistrationClientPicture]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_InsertRegistrationClientPicture]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_InsertRegistrationClientPicture]
GO

/****** Object:  StoredProcedure [dbo].[SSP_InsertRegistrationClientPicture]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_InsertRegistrationClientPicture] @DocumentVersionId INT      
 ,@uploadedOn DATETIME      
 ,@uploadedBy INT      
 ,@PictureFileName VARCHAR(100)      
 ,@picture IMAGE      
 ,@active CHAR(1)      
AS      
   
/*********************************************************************/ 
/* Stored Procedure: [SSP_InsertRegistrationClientPicture]        */ 
/* Creation Date:  16/Jan/2018                                         */ 
/* Purpose: Updates all the Active Client Pictures to Inactive and Insert Client Picture                  */ 
/* Data Modifications:                                                */ 
/*Updates:                                                            */ 
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */ 
/*********************************************************************/ 
BEGIN TRY      
 BEGIN      
  IF EXISTS (      
    SELECT 1      
    FROM DocumentRegistrationClientPictures      
    WHERE DocumentVersionId = @DocumentVersionId AND Active='Y'      
    )      
   UPDATE DocumentRegistrationClientPictures      
   SET Active = 'N'      
   WHERE DocumentVersionId = @DocumentVersionId AND Active='Y'       
      
  INSERT INTO DocumentRegistrationClientPictures (      
    DocumentVersionId      
   ,UploadedOn      
   ,UploadedBy      
   ,PictureFileName      
   ,Picture      
   ,Active      
   )      
  VALUES (      
   @DocumentVersionId      
   ,@uploadedOn      
   ,@uploadedBy      
   ,@PictureFileName      
   ,@picture      
   ,@active      
   );      
      
  --SELECT @@IDENTITY     
  SELECT SCOPE_IDENTITY()
  
 END      
END TRY      
      
BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)      
      
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_InsertRegistrationClientPicture') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
 RAISERROR (      
   @Error      
   ,-- Message text.             
   16      
   ,-- Severity.             
   1 -- State.                                                               
   );      
END CATCH 