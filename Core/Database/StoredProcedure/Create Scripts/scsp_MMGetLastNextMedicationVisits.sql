/****** Object:  StoredProcedure [dbo].[csp_MMGetLastNextMedicationVisits]    Script Date: 5/31/2013 1:04:57 PM ******/
IF EXISTS ( SELECT	 *
			FROM	 sys.objects
			WHERE	 object_id = OBJECT_ID(N'[dbo].[scsp_MMGetLastNextMedicationVisits]')
					 AND type IN (N'P', N'PC') ) 
   DROP PROCEDURE [dbo].[scsp_MMGetLastNextMedicationVisits]
GO

/****** Object:  StoredProcedure [dbo].[csp_MMGetLastNextMedicationVisits]    Script Date: 5/31/2013 1:04:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


    
CREATE PROCEDURE [dbo].[scsp_MMGetLastNextMedicationVisits]    
/********************************************************************************************
 * Procedure: scsp_MMGetLastNextMedicationVisits           
 *                      
 * Purpose: called by scsp_SCClientMedicationClientInformation to determine the most
 *  recent and next medication visits.            
 *                      
 * Created by: TER                   
 * Created Dt: 3/10/2009                 
 * Change History:																			
 ********************************************************************************************
 *	Date		Author		Purpose
 ********************************************************************************************
 *	9/11/2013	dknewtson	Conversion to scsp and implementing recodes tables.
 ********************************************************************************************/
   @ClientId INT
  ,@LastMedicationVisit VARCHAR(1000) OUTPUT
  ,@NextmedicationVisit VARCHAR(1000) OUTPUT
AS -- logic for Summit Pointe    
    
   SELECT	@LastMedicationVisit = CASE	WHEN DATEPART(month, s.DateOfService) < 10 THEN '0'
										ELSE ''
								   END + CAST(DATEPART(month, s.DateOfService) AS VARCHAR) + '/' + CASE	WHEN DATEPART(day, s.DateOfService) < 10 THEN '0'
																										ELSE ''
																								   END + CAST(DATEPART(day, s.DateOfService) AS VARCHAR) + '/' + CAST(DATEPART(year, s.DateOfService) AS VARCHAR)
   FROM		Services AS s
			JOIN dbo.ssf_RecodeValuesCurrent('MEDICATIONVISITPROCEDURES') AS medprocids ON s.ProcedureCodeId = medprocids.IntegerCodeId
   WHERE	s.ClientId = @ClientId
			AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
            --AND s.ProgramId IN ( 9, 10, 11 )
			AND s.status IN (71, 75)
			AND NOT EXISTS ( SELECT	*
							 FROM	Services AS s2
									JOIN dbo.ssf_RecodeValuesCurrent('MEDICATIONVISITPROCEDURES') AS medprocids2 ON s2.ProcedureCodeId = medprocids2.IntegerCodeId
							 WHERE	s2.ClientId = @ClientId
									AND ISNULL(s2.RecordDeleted, 'N') <> 'Y'
                                    --AND s2.ProgramId IN ( 9, 10, 11 )
									AND s2.status IN (71, 75)
									AND DATEDIFF(day, s2.DateOfService, s.DateOfService) < 0 )    
    
   SELECT	@NextMedicationVisit = CASE	WHEN DATEPART(month, s.DateOfService) < 10 THEN '0'
										ELSE ''
								   END + CAST(DATEPART(month, s.DateOfService) AS VARCHAR) + '/' + CASE	WHEN DATEPART(day, s.DateOfService) < 10 THEN '0'
																										ELSE ''
																								   END + CAST(DATEPART(day, s.DateOfService) AS VARCHAR) + '/' + CAST(DATEPART(year, s.DateOfService) AS VARCHAR)
   FROM		Services AS s
			JOIN dbo.ssf_RecodeValuesCurrent('MEDICATIONVISITPROCEDURES') AS medprocids ON s.ProcedureCodeId = medprocids.IntegerCodeId
   WHERE	s.ClientId = @ClientId
			AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
            --AND s.ProgramId IN ( 9, 10, 11 )
			AND s.status = 70
			AND NOT EXISTS ( SELECT	*
							 FROM	Services AS s2
									JOIN dbo.ssf_RecodeValuesCurrent('MEDICATIONVISITPROCEDURES') AS medprocids2 ON s2.ProcedureCodeId = medprocids2.IntegerCodeId
							 WHERE	s2.ClientId = @ClientId
									AND ISNULL(s2.RecordDeleted, 'N') <> 'Y'
                                    --AND s2.ProgramId IN ( 9, 10, 11 )
									AND s2.status = 70
									AND DATEDIFF(day, s2.DateOfService, s.DateOfService) > 0 )    

GO


