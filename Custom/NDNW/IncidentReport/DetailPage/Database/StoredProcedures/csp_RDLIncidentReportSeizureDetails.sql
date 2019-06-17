IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentReportSeizureDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIncidentReportSeizureDetails]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLIncidentReportSeizureDetails]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLIncidentReportSeizureDetails]  
(                                                                                                                                                                                        
  @PrimaryKey int                                                                                                                                                        
)                                                     
AS 

/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.[csp_RDLIncidentReportSeizureDetails]                */                                                                                                                                      
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                      
/* Creation Date:   06-May-2015                                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Purpose:  Get Data for CustomIncidentReportSeizureDetails Pages */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Input Parameters:  @IncidentReportFallAdministratorReviewId           */                                                                                                                                    
/*                                                                   */                                                                                                                                      
/* Output Parameters:   None                   */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Return:  0=success, otherwise an error number                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Called By:                                                        */                                                                                                                                      
/*                                                                   */                  
/* Calls:                        */                       
/* */                                         
/* Data Modifications:   */                                          
/*      */                                                                                     
/* Updates:                                          
 Date			Author			Purpose       
 ----------		---------		--------------------------------------                                                                               
 07-May-2015	Ravichandra		what:Use For Rdl Report  
								why:task #818 Woods – Customizations                                    
*/                                                                                                           
/*********************************************************************/                                                                                                                              
                                                                                                                                                                                                                                 
BEGIN
BEGIN TRY  
		
		SELECT
		     IncidentReportSeizureDetailId
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsSweating) AS Sweating
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsUrinaryFecalIncontinence) AS UrinaryFecalIncontinence
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsTonicStiffnessOfArms)AS TonicStiffnessOfArms
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsTonicStiffnessOfLegs)AS TonicStiffnessOfLegs
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsClonicTwitchingOfArms)AS ClonicTwitchingOfArms
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsClonicTwitchingOfLegs) AS ClonicTwitchingOfLegs
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsPupilsDilated) AS PupilsDilated
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsAnyAbnormalEyeMovements) AS AnyAbnormalEyeMovements
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsPostictalPeriod) AS PostictalPeriod
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsVagalNerveStimulator) AS VagalNerveStimulator
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsSwipedMagnet) AS SwipedMagnet
			,SeizureDetailsNumberOfSwipes AS NumberOfSwipes
			,SeizureDetailsPulseRate AS PulseRate
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsBreathing) AS Breathing
			,dbo.csf_GetGlobalCodeNameById(SeizureDetailsColor) AS Color
			,SeizureDetailsTurnClientsHeadSide AS TurnClientsHeadSide
			,SeizureDetailsClientSuctioned AS ClientSuctioned
			,SeizureDetailsClothingLoosended AS ClothingLoosended
			,SeizureDetailsAirwayCleared AS AirwayCleared
			
			,SeizureDetailsPlacedClientOnTheFloor AS PlacedClientOnTheFloor
			,SeizureDetailsPutClientToBed AS PutClientToBed
			,SeizureDetailsNotescomments AS Notescomments
			,SeizureDetailsAreaCleared AS AreaCleared
			,IncidentReportId
			FROM CustomIncidentReportSeizureDetails
			WHERE IncidentReportId = @PrimaryKey AND isnull(RecordDeleted, 'N') = 'N'  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentReportSeizureDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END 