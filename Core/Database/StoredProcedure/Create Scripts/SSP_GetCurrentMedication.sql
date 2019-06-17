 IF OBJECT_ID('ssp_GetCurrentMedication','P') IS NOT NULL
DROP PROCEDURE [dbo].[ssp_GetCurrentMedication]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE [dbo].[ssp_GetCurrentMedication]     
 /*********************************************************************************/    
 -- Copyright: Streamline Healthcate Solutions            
 --            
 -- Purpose: Customization support for Reception list page depending on the custom filter selection.            
 --            
 -- Author:  Vaibhav khare            
 -- Date:    20 May 2011            
 --            
 -- *****History****            
 /* 2012-09-21   Vaibhav khare  Created          */    
 /* 2013-03-19   Jay Wheeler altered to cast dates for correct comparison */    
 /* 2013-03-21    New two parameters added by Deej. As per the discussion with Wasif*/    
 /* 2014-12-14   Added  new filter for Discontinued Medication*/    
     
 /*  2014-12-14   Checking is null for cmi.Active */    
 /* JAN-23-2015   dharvey  Revised logic to include us of the DocumentEffective date unless initialized */    
 /* May-04-2015   wbutt    Adding rx start date for each instruction */    
 /* May-30-2018   vsinha   Created CTC 'LatestClientMedications' to show the current medications instead of all for task Allegan - Support #1387  */ 
 /*********************************************************************************/    
    @ClientId INT ,    
    @DocumentId INT ,    
    @EffectiveDate DATETIME    
AS     
BEGIN    
    BEGIN TRY     
	  DECLARE @AuthorId INT     
	      
	  IF ISNULL(@DocumentId,0) > 0    
	   BEGIN    
		SELECT @AuthorId = AuthorId    
		FROM Documents     
		WHERE DocumentId = @DocumentId    
	   END    
	        
	        
			DECLARE @CurrentMedications VARCHAR(MAX)    
	            
	            
			SET @EffectiveDate = ISNULL(@EffectiveDate,GETDATE())    
	    
			CREATE TABLE #MedicationResults    
				(    
				  MedicationDetails VARCHAR(MAX) NULL ,-- these were defined as fixed length [varchar(50)].  This was causing an overflow error    
				  MedicationType VARCHAR(MAX) NULL    
				)    
	    
	 --Declare @count int           
	 --Declare @Totalcount int          
	 --Select @Totalcount= COUNT(*)from #tempResult           
	 --set @count=1          
	 --  DECLARE @temp VARCHAR(max)  
	 
		  ;with LatestClientMedications as(
			select cm.ClientId,cm.MedicationNameId,M.MedicationName, cmi.ClientMedicationInstructionId, cmsd.StartDate, cmsd.EndDate,cm.PrescriberId
			,ROW_NUMBER() OVER ( 
			PARTITION BY cm.ClientId,cm.MedicationNameId
			ORDER BY cmsd.StartDate desc,  ISNULL(cmsd.EndDate,'12/31/2099') desc
			) as RRank
			FROM    MDMedicationNames M  
                        INNER JOIN ClientMedications CM ON CM.MedicationNameId = m.MedicationNameId  
                        LEFT JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationId = cm.ClientMedicationId  
                                                                             AND ISNULL(cmi.RecordDeleted, 'N') = 'N'  
                                                                             AND ISNULL(cmi.Active, 'Y') = 'Y'  
                        LEFT JOIN ClientMedicationScriptDrugs as cmsd ON ( cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId  
                                                                             AND ISNULL(cmsd.RecordDeleted, 'N') = 'N' )      
                WHERE   CM.ClientId = @ClientId  
                        AND ISNULL(CM.Discontinued, 'N') = 'N'  
                        AND ISNULL(CM.RecordDeleted, 'N') = 'N' --and IsNull(App.RecordDeleted,'N')='N'          
                        AND ISNULL(M.RecordDeleted, 'N') = 'N'   
                        AND DATEDIFF(dd,CM.MedicationStartDate,@EffectiveDate) >= 0  
                        AND DATEDIFF(dd,CM.MedicationEndDate,@EffectiveDate) <= 0  
                        AND ISNULL(CM.RecordDeleted, 'N') = 'N'   
                        AND CM.ClientMedicationId NOT IN (SELECT CM2.ClientMedicationId   
														   FROM dbo.ClientMedications CM2  
														   WHERE CM2.ClientId = CM.ClientId  
														   AND CM2.PrescriberId = @AuthorId   
														   AND DATEDIFF(dd, CM2.ModifiedDate, @EffectiveDate) = 0  
														   AND ISNULL(CM2.RecordDeleted,'N')='N'  
														   )  
					group by cm.ClientId,cm.MedicationNameId,M.MedicationName, cmi.ClientMedicationInstructionId, cmsd.StartDate, cmsd.EndDate,cm.PrescriberId
					)  
			    
			INSERT  INTO #MedicationResults    
					( MedicationDetails ,    
					  MedicationType    
			  )    
					SELECT  ( ISNULL(lcm.MedicationName + '&nbsp;&nbsp;&nbsp;&nbsp;', '') + '      '     
		  + ISNULL(dbo.csf_GetMedicationInstruction(lcm.ClientMedicationInstructionId), '') + '  ' )     
		  + ' (' + isnull(convert(varchar(10), lcm.StartDate, 101), '')      
		  + isnull( ' - ' + convert(varchar(10), lcm.EndDate, 101), '') + ')'     
		  --+ ISNULL(' - [Prescriber: ' + RTRIM(cm.PrescriberName) + ']','')     
		  ,    
							CASE WHEN lcm.PrescriberId IS NULL THEN 'OTHER'    
								 ELSE 'Medications'    
							END    
					FROM    LatestClientMedications lcm  
					Where RRank=1
					ORDER BY lcm.MedicationName, lcm.StartDate    
	    
			DECLARE @head1 VARCHAR(MAX)    
	    
			SET @head1 = '<b>Current Medications</b><br> '    
	    
			SELECT  @CurrentMedications = COALESCE(@CurrentMedications + '<br>', '') + MedicationDetails    
			FROM    #MedicationResults    
			WHERE   MedicationType = 'Medications'    
	    
			SET @head1 += ISNULL(@CurrentMedications, 'None') + '<br><br><b>Other Medications</b><br>'    
	    
			DECLARE @CurrentMedications1 VARCHAR(MAX)    
	    
			SELECT  @CurrentMedications1 = COALESCE(@CurrentMedications1 + '<br> ', '') + MedicationDetails    
			FROM    #MedicationResults    
			WHERE   MedicationType = 'OTHER'    
	    
			SET @head1 += ISNULL(@CurrentMedications1, 'None<br>')    
	    
			SELECT  '<span style=''color:black''>' + @head1 + '</span>' 
	END TRY 
	BEGIN CATCH
	 DECLARE @Error VARCHAR(8000)
		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetCurrentMedication') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
		RAISERROR (
				@Error
				,-- Message text.              
				16
				,-- Severity.              
				1 -- State.              
				);
	END CATCH  
END    
 -- exec [ssp_GetCurrentMedication] 516658,972548,'05/22/2018'