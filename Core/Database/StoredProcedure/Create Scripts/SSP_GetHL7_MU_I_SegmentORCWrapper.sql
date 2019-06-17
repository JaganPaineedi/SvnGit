/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentORCWrapper]    Script Date: 06/10/2016 01:33:51 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_I_SegmentORCWrapper]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentORCWrapper]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentORCWrapper]    Script Date: 06/10/2016 01:33:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentORCWrapper] @VendorId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@ClientID INT
	,@ClientImmunizationIds NVARCHAR(250)
	,@ORCWrapperSegmentRaw NVARCHAR(Max) OUTPUT
AS
-- ================================================================  
-- Stored Procedure: SSP_GetHL7_MU_I_SegmentORCWrapper  
-- Purpose : Generates RXA Segment  
-- Script :  
/*   
 Declare @ORCSegmentRaw nVarchar(max)  
 EXEC SSP_GetHL7_MU_I_SegmentORCWrapper 4,'|^~\&',127687,2,@ORCSegmentRaw Output  
 Select @ORCSegmentRaw   
*/
-- Created By : Varun
-- ================================================================  
-- History --  
-- ================================================================  
BEGIN
	BEGIN TRY
		DECLARE @ORCSegment VARCHAR(max)
		DECLARE @ORCResult VARCHAR(max)
		-- pull out encoding characters  
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @pos INT
		DECLARE @len INT
		DECLARE @ClientImmunizationId INT
		---Variable declare for Message
		SET @ORCResult=''
		
		DECLARE TableClientImmunizationIds CURSOR LOCAL FAST_FORWARD    
	   FOR 
	    
	    SELECT Token AS ClientImmunizationId FROM [dbo].[SplitString] (@ClientImmunizationIds,',') S
		JOIN ClientImmunizations CI ON S.Token=CI.ClientImmunizationId
	    ORDER BY CI.VaccineStatus, CI.ClientImmunizationId DESC

	    
	   OPEN TableClientImmunizationIds    
	    
	   FETCH NEXT    
	   FROM TableClientImmunizationIds    
	   INTO @ClientImmunizationId    
	    
	   WHILE @@FETCH_STATUS = 0    
	   BEGIN   
	    
		EXEC SSP_GetHL7_MU_I_SegmentORC @VendorId
			,@HL7EncodingChars
			,@ClientID
			,@ClientImmunizationId
			,@ORCSegment OUTPUT

			SET @ORCResult+=@ORCSegment
	   FETCH NEXT    
	   FROM TableClientImmunizationIds    
	   INTO @ClientImmunizationId    
	   END    
	    
	   -- ==============================================     
	   CLOSE TableClientImmunizationIds    
	    
	   DEALLOCATE TableClientImmunizationIds  
		
		SET @ORCWrapperSegmentRaw = @ORCResult
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_I_SegmentORCWrapper') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		INSERT INTO ErrorLog (
			ErrorMessage
			,VerboseInfo
			,DataSetInfo
			,ErrorType
			,CreatedBy
			,CreatedDate
			)
		VALUES (
			@Error
			,NULL
			,NULL
			,'HL7 Procedure Error'
			,'SmartCare'
			,GETDATE()
			)

		RAISERROR (
				@Error
				,-- Message text.                                                                        
				16
				,-- Severity.                                                                        
				1 -- State.                                                                        
				);
	END CATCH
END
