/****** Object:  StoredProcedure [dbo].[ssp_SCBedCensusSearch]    Script Date: 11/18/2011 16:25:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCBedCensusSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCBedCensusSearch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCBedCensusSearch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  procedure [dbo].[ssp_SCBedCensusSearch]     
     /* Param List */      
  @Activity int    
 ,@FromDate  Datetime    
 ,@ProgramId int    
 ,@UnitId int    
 ,@RoomId int    
 ,@BedId int    
                                              
as                        
                      
/*********************************************************************/                                            
/* Stored Procedure: dbo.ssp_SCBedCensusSearch                              */                                            
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC      */                                            
/* Creation Date:    06/04/09                                         */                                            
/*                                                                   */                                            
/* Purpose:   Populate the BedCensus Page in the application        */                                            
/*                                                                   */ /* Input Parameters:@Activity,@ProgramId,@UnitId ,@RoomId,@BedId- */                                            
/*                                                                   */                                            
/* Output Parameters:   None                                         */                                            
/*                                                                   */                                            
/* Return:  0=success, otherwise an error number                 */                                            
/*                                                                   */                                            
/* Called By:                  */                                            
/*                                                                   */                                            
/* Calls:                                                            */                                            
/*                                                                   */                                            
/* Data Modifications:                                               */                                            
/*                                                                   */                                            
/* Updates:                                                          */                                            
/*   Date     Author       Purpose                                  */                                            
/*  06/04/09   Anuj        Created          */                                           
                                                    
 /* TO FETCH Searched record FROM BedAssignments    */                                      
 /* 20 Oct 2015		   Revathi				   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.*/             
/*													why:task #609, Network180 Customization   */ 
            
/*********************************************************************/                                            
                
BEGIN              
    
BEGIN TRY      
Select    Clients.ClientId, 
		-- Modified by Revathi 20 Oct 2015
		 case when  ISNULL(Clients.ClientType,''I'')=''I'' then (ISNULL(Clients.FirstName,'''') + '', '' + ISNULL(Clients.LastName,'''')) else ISNULL(Clients.OrganizationName,'''') end   as ClientName, 
		  GlobalCodes.CodeName,CONVERT(varchar(10),ClientInpatientVisits.AdmitDate,103)as AdmitDate,    
          CONVERT(varchar(10),ClientInpatientVisits.DischargedDate,103)as DischargedDate,Beds.BedName,Beds.DisplayAs,Programs.ProgramCode,Programs.ProgramName,    
          BedAssignments.Comment from BedAssignments as  BedAssignments    
          Inner join ClientInpatientVisits as ClientInpatientVisits on     
          BedAssignments.ClientInpatientVisitId=ClientInpatientVisits.ClientInpatientVisitId    
          Inner join Clients as  Clients    
          on Clients.ClientId=ClientInpatientVisits.ClientId     
          Inner join Beds as Beds on Beds.BedId=BedAssignments.BedId    
          Inner join Programs as Programs on Programs.ProgramID=BedAssignments.ProgramID    
          Inner join Rooms as Rooms on Rooms.RoomId=Beds.RoomId    
          Inner join Units as Units on Units.UnitId=Rooms.UnitId    
          Inner join GlobalCodes as GlobalCodes on GlobalCodes.GlobalCodeId= BedAssignments.[Status]  where    
          IsNull(BedAssignments.RecordDeleted,''N'')<> ''Y''    
          And IsNull(Programs.RecordDeleted,''N'')<> ''Y''    
          And IsNull(Beds.RecordDeleted,''N'')<> ''Y''    
          And (BedAssignments.[Type]= @Activity OR @Activity= 0)    
          --And (BedAssignments.StartDate= ''2009-06-07'')    
          And (BedAssignments.StartDate= @FromDate OR @FromDate is null and @FromDate is not null )    
          And (BedAssignments.ProgramID= @ProgramId OR @ProgramId =0)    
          And (BedAssignments.BedId= @BedId OR @BedId =0)    
          And (Rooms.RoomId= @RoomId OR @RoomId =0)    
          And (Units.UnitId= @UnitId OR @UnitId =0) order by ClientName asc  
End Try    
BEGIN CATCH      
DECLARE @Error varchar(8000)                        
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                         
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCBedCensusSearch'')                         
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                          
   + ''*****'' + Convert(varchar,ERROR_STATE())                        
                      
   RAISERROR                         
   (                        
    @Error, -- Message text.                        
    16, -- Severity.                        
    1 -- State.                        
   );         
End CATCH                                                                   
--IF (@@error!=0)                                          
--    BEGIN                                          
--        RAISERROR  20002 ''ssp_SCBedCensusSearch: An error  occured''                                          
--        RETURN(1)                                          
--    END                                          
                                          
--drop table #Document                                                                                
--RETURN(0)    
End  ' 
END
GO
