
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCListPageClientMedicationData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCListPageClientMedicationData]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_SCListPageClientMedicationData]  
(  
 @ClientId INT   
,@PrescriberId INT
,@RxStart DATETIME
,@RxEnd DATETIME      
,@OtherFilter INT
,@MedicationStatus INT
)  
 
/********************************************************************************    
-- Stored Procedure: dbo.scsp_SCListPageClientMedicationData      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 20-may-2014	 Revathi		What:Used in Client Medication List Page.          
--								Why:task #20 MeaningFul Use
-- 01/29/2016    Vichee Humane  Added  @MedicationStatus to check the status of Medication
								CEI - Support Go Live #100
*********************************************************************************/   
AS
BEGIN  
SELECT  null as ClientMedicationId  
END
GO
