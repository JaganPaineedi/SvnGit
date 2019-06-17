IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPlaceOfServiceByProgram]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetPlaceOfServiceByProgram]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetPlaceOfServiceByProgram]      
 @ProgramId int     
AS      
BEGIN      
 
 
 select l.LocationId, l.LocationCode      
 from Locations l
 where isnull(RecordDeleted,'N') = 'N' and 
       Active = 'Y' and
       PlaceOfService is not null and -- Only show services linked to Place of Service
       exists ( select 1
                from ProgramLocations pl
                where pl.LocationId = l.LocationId and
                      ( pl.ProgramId = @ProgramId or
                        @ProgramId = -1 ) and
                      ISNULL(pl.RecordDeleted,'N') = 'N' )
       
END 
GO

