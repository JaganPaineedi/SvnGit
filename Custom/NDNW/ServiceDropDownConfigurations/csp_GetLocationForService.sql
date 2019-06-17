/****** Object:  StoredProcedure [dbo].[csp_GetLocationForService]    Script Date: 11/9/2015 9:37:01 PM ******/
DROP PROCEDURE [dbo].[csp_GetLocationForService]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetLocationForService]    Script Date: 11/9/2015 9:37:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create procedure [dbo].[csp_GetLocationForService]           
 -- Add the parameters for the stored procedure here          
    @ClientId int,
    @DateOfService datetime = null,
    @ProgramId int,
    @AttendingId int,
    @ProcedureCodeId int,
    @LocationId int,
    @PlaceOfServiceId int,
    @ClinicianId int
as 
begin         
/*********************************************************************/                                                                                
 /* Stored Procedure: [csp_GetLocationForService]                         */                                                                       
 /* Creation Date:  2/August/2011                                     */                                                                                
 /* Purpose: To get The Data In Location Table For Service            */                                                                              
 /* Input Parameters:@ClientId, @DateOfService, @ProgramId, @ClinicianId,         
      @ProcedureCodeId, @LocationId, @PlaceOfServiceId  */          
  /* Output Parameters:   Returns The Table of Location  with Columns         
         LocationName and LocationId          */                                                                                
 /* Called By:                                                       */                                                                      
 /* Data Modifications:                                              */                                                                                
 /*   Updates:                                                       */                                                                                
 /*   Date              Author                                       */                                                                                
 /*   2/August/2011     Minakshi    Created                       */            
 /*   19/August/2011     Damanpreet    Modified                   */     
 /* 2/23/2015         TRyan			Modified - NDNW Custom     */                                                                                
 /********************************************************************/             
    begin try          
        begin          
	
            select  -1 as AttendingId,
                    '' as AttendingName,
                    -1 as ProgramId,
                    '' as ProgramName,
                    L.LocationId,
                    L.LocationCode as LocationName,
                    -1 as ProcedureCodeId,
                    '' as ProcedureCodeName,
                    -1 as ClinicianId,
                    '' as ClinicianName
            from    dbo.Locations as L
            where   (
                     L.Active = 'Y'
                     and ISNULL(L.RecordDeleted, 'N') <> 'Y'
                     and (
							exists ( select    *
                                      from      dbo.ProgramLocations as sl
                                      where     sl.ProgramId = @ProgramId
                                                and sl.LocationId = L.LocationId
                                                and ISNULL(sl.RecordDeleted,
                                                           'N') <> 'Y' 
							)
							)

                    )
                    or (L.LocationId = @LocationId)
	
        end        
    end try          
    begin catch                                                                                     
              
        declare @Error varchar(8000)                                                         
        set @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
            + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
                     'csp_GetLocationForServiceDummy') + '*****'
            + CONVERT(varchar, ERROR_LINE()) + '*****'
            + CONVERT(varchar, ERROR_SEVERITY()) + '*****'
            + CONVERT(varchar, ERROR_STATE())                                                                                      
        raiserror                                                                                       
 (                                                         
  @Error, -- Message text.                                                                                      
  16, -- Severity.                                                                                      
  1 -- State.       
 ) ;                                 
    end catch            
end 

GO


