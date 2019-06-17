/****** Object:  StoredProcedure [dbo].[csp_GetProgramForService]    Script Date: 11/9/2015 9:21:26 PM ******/
DROP PROCEDURE [dbo].[csp_GetProgramForService]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetProgramForService]    Script Date: 11/9/2015 9:21:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




  
CREATE PROCEDURE [dbo].[csp_GetProgramForService]             
 -- Add the parameters for the stored procedure here            
 @ClientId int,           
 @DateOfService DateTime = null,           
 @ProgramId int,           
 @AttendingId int,           
 @ProcedureCodeId int,           
 @LocationId int,           
 @PlaceOfServiceId int,
 @ClinicianId int           
AS            
BEGIN           
/*********************************************************************/                                                                                    
 /* Stored Procedure: [csp_GetProgramForService]                         */                                                                           
 /* Creation Date:  2/August/2011                                     */                                                                                    
 /* Purpose: To get The Data  For Service            */                                                                                  
 /* Input Parameters:@ClientId, @DateOfService, @ProgramId, @ClinicianId,             
      @ProcedureCodeId, @LocationId, @PlaceOfServiceId  */              
  /* Output Parameters:   Returns The Table of Program */                                                                                    
 /* Called By:                                                       */                                                                          
 /* Data Modifications:                                              */                                                                                    
 /*   Updates:                                                       */                                                                                    
 /*   Date              Author                                       */                                                                                    
 /*   3/August/2011     Minakshi    Created                       */      
 /*   19/August/2011     Damanpreet    Modified                        */   
 /*   09/November/2015	T.Remisoski		New Directions wants only client-enrolled programs. */                                                                             
 /********************************************************************/             
BEGIN TRY            
  BEGIN           

 select  
  -1 AS AttendingId, '' AS AttendingName,    
  P.ProgramId,P.ProgramName,    
 -1 AS LocationId,'' AS LocationName,     
 -1 as ProcedureCodeId, 
 '' AS ProcedureCodeName, -1 AS ClinicianId, '' AS ClinicianName 
 from  Programs P
 where 
	(
		P.Active = 'Y'
		and ISNULL(P.RecordDeleted, 'N') <> 'Y'
		and (
			exists (select * from dbo.ClientPrograms as cp
			where cp.ClientId = @ClientId
			and cp.ProgramId = P.ProgramId
			and (
				(cp.Status = 4)
				or (
					datediff(day, cp.EnrolledDate, @DateOfService) >= 0
					and ((datediff(day, cp.DischargedDate, @DateOfService) <= 0) or (cp.DischargedDate is null))
				)
			) -- Enrolled or enrolled at time of service
			and ISNULL(cp.RecordDeleted, 'N') <> 'Y')
		)
	)
	or (P.ProgramId = @ProgramId)
	  
 END          
 END TRY            
BEGIN CATCH                                                                                       
DECLARE @Error varchar(8000)                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetProgramForService')                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                                                                        
 RAISERROR                                                                                         
 (                                                           
  @Error, -- Message text.                                                                                        
  16, -- Severity.                                                                                        
  1 -- State.                                                                                        
 );                                                                                        
END CATCH              
END



GO


