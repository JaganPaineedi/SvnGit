IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetLabsoft_SegmentIDS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentIDS]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentIDS]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentIDS]
	@OrganizationId Int,
	@EncodingChars nVarchar(5) ,
	@IDSSegmentRaw nVarchar(max) Output
AS
-- ================================================================
-- Stored Procedure: SSP_SCGetLabsoft_SegmentIDS
-- Create Date : Sep 10, 2015
-- Purpose : Generates IDS Segment for LabSoft
-- Script :
/* 
declare @IDSSegmentRaw nVarchar(max)
exec SSP_SCGetLabsoft_SegmentIDS '|^~\&' ,@IDSSegmentRaw Output
select @IDSSegmentRaw
*/
-- Created By : Gautam
-- ================================================================
-- History --
-- ================================================================
BEGIN
	BEGIN TRY		
		DECLARE @SegmentName nVarchar(3)
		DECLARE @IDSSegment nVarchar(200)	
		DECLARE @EMRKey nVarchar(50)
		DECLARE @CustomerID nVarchar(50)
		
		SELECT  Top 1 @EMRKey= EMRKey,@CustomerID=LabSoftCustomerId  FROM [LabSoftOrganizationConfigurations]  
				Where LabSoftOrganizationId=@OrganizationId AND ISNULL(RecordDeleted,'N')='N'
			

		SET @SegmentName='IDS'
		
		-- pull out encoding characters
		DECLARE @FieldChar char 
		DECLARE @CompChar char
		DECLARE @RepeatChar char
		DECLARE @EscChar char
		DECLARE @SubCompChar char
		EXEC SSP_SCGetLabSoft_EncChars @EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output
			

		SET @IDSSegment= @FieldChar+@CustomerID+@FieldChar+@EMRKey+@FieldChar
			
		SET @IDSSegmentRaw= @SegmentName+@IDSSegment
	END TRY
	BEGIN CATCH
		DECLARE @Error varchar(8000)                                                                      
		 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
		 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCGetLabsoft_SegmentIDS')                                            
		 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                        
		 + '*****' + Convert(varchar,ERROR_STATE())                                                                      
		                                                                
		 Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)
		 values(@Error,NULL,NULL,'LabSoft Procedure Error','SmartCare',GetDate())    
		                                                                         
		 RAISERROR                                                                       
		 (                                                            
		 @Error, -- Message text.                                                                      
		 16, -- Severity.                                                                      
		 1 -- State.                                                                      
		 );  
	END CATCH
END

GO


