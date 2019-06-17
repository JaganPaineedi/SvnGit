/****** Object:  StoredProcedure [dbo].[ssp_QueOnProgramDischargeEvent]    Script Date: 07/26/2018 16:23:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_QueOnProgramDischargeEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_QueOnProgramDischargeEvent]
GO

/****** Object:  StoredProcedure [dbo].[ssp_QueOnProgramDischargeEvent]    Script Date: 07/26/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_QueOnProgramDischargeEvent (@ScreenKeyId INT)
AS
/******************************************************************************                                  
**  File: ssp_QueOnProgramDischargeEvent.sql                
**  Name: ssp_QueOnProgramDischargeEvent           
**  Desc:                 
**                                  
**  Return values: <Return Values>                                 
**                                   
**  Called by: <Post update in Client  Program Assignment Screen>                                    
**                                                
**  Parameters:    @ScreenKeyId                            
**  Input   Output                                  
**  ---      -----------                                  
**                                  
**  Created By: Ravi                
**  Date:  Aug 06 2018                
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:			Author:    Description: 
	Aug 06 2018		Ravi		inserting records  into SystemEvents
								Engineering Improvement Initiatives- NBL(I) > Tasks #590> Client Tracking 	                                 
**  --------  --------    -------------------------------------------                 
                              
*******************************************************************************/
BEGIN
	BEGIN TRY
					INSERT INTO SystemEvents (
						SystemEventConfigurationId
						,EventKeyId
						,EventStatus
						)
					SELECT SystemEventConfigurationId
						,@ScreenKeyId
						,NULL
					FROM SystemEventConfigurations
					WHERE EventTypeCode = 'ProgramDischarge'
						

		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_QueOnProgramDischargeEvent') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
