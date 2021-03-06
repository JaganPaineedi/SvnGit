/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataForGroups]    Script Date: 11/18/2011 16:25:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataForGroups]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataForGroups]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                           
CREATE PROCEDURE [dbo].[ssp_SCGetDataForGroups]           
(                                         
 @ActiveStatus VARCHAR(50),                  
 @StaffsId INT,                  
 @ProgramsId INT,                  
 @LocationsId INT                  
)                                      
                                        
/******************************************************************************                                              
**File: Group List Page                                              
** Name:                             
**Desc:Used to list all groups                              
**                                              
** Return values:                                              
**                                               
**  Called by:Groups.cs                                     
**                                                            
**  Parameters:                                              
**  Input       Output                                              
**  @GroupId INT                               
**                                        
**                                          
**                                        
**  Auth:  Pradeep                                      
**  Date:  6 March                                             
*******************************************************************************                                              
**  Change History                                              
*******************************************************************************                                              
**  Date:         Author:       Description:                       
**  6 March       Pradeep       Created   
**  1 March 2017  vsinha		What:  Length of "Display As" to handle procedure code display as increasing to 75     
								Why :  Keystone Customizations 69  	                                       
**  --------  --------    ----------------------------------------------------                                              
                                         
*******************************************************************************/                  
AS                  
 BEGIN                                            
  DECLARE @Active1 Varchar(10)                  
  DECLARE @Active2 VARCHAR(10)                   
  IF(@ActiveStatus='' or @ActiveStatus='All')                  
    BEGIN                  
     SET @Active1='Y'                  
     SET @Active2='N'                  
    END                  
   ELSE IF(@ActiveStatus='Active')                  
    BEGIN                  
     SET @Active1='Y'                  
     SET @Active2='Y'                  
    END                  
   ELSE IF(@ActiveStatus='Inactive')                  
    BEGIN                  
     SET @Active1='N'                  
     SET @Active2='N'                  
    END                    
  BEGIN TRY                  
                      
        Declare @GroupIds int,                                
              @GroupCode varchar(50),        
              @GroupName varchar(250),                                   
              @Active Varchar(10),                                
              @programid int,                                
              @ProgramCode varchar(50),                                    
              @locationid int,                                
              @LocationCode varchar(50),                                    
              @procedurecodeid int,                                
              @DisplayAs varchar(75),             --1 March 2017  vsinha                       
              @Staffid int,                                
              @StaffName varchar(500),                                  
              @tempGroupId int,                                
              @Counter int                  
              Declare Staff cursor for                                    
                                
     select Groups.GroupId,Groups.GroupCode,Groups.GroupName, Groups.Active,      
     Programs.ProgramId,Programs.ProgramCode,                                
     Locations.LocationId,Locations.LocationCode,              
     Procedurecodes.ProcedureCodeId, ProcedureCodes.DisplayAs ,                                
     Staff.StaffId,                                
   CASE              
   WHEN Staff.DEGREE is NULL then Staff.LastName + ', ' + Staff.FirstName                                
   else Staff.LastName + ', ' + Staff.FirstName + '  ' + GC.CodeName                                 
   end                                
   as StaffName                                 
                               
                                
   from Groups                                
   left outer join GroupStaff on GroupStaff.GroupId=Groups.GroupId                                
   left outer join Programs on Groups.ProgramId = Programs.ProgramId                 
   left outer join Locations on groups.LocationId = Locations.LocationId                                    
   left outer join Procedurecodes on Groups.ProcedureCodeId = ProcedureCodes.ProcedureCodeId                                    
   left outer join Staff on GroupStaff.StaffId =Staff.StaffId                                  
   left outer join GlobalCodes GC on Staff.Degree=GC.GlobalCodeId                                
   where ISNULL(Groups.RecordDeleted,'N')='N'                  
   AND ISNULL(Programs.RecordDeleted,'N')='N'                  
   AND ISNULL(Locations.RecordDeleted,'N')='N'                  
   AND ISNULL(Procedurecodes.RecordDeleted,'N')='N'                  
   AND ISNULL(Staff.RecordDeleted,'N')='N'                  
   AND ISNULL(GC.RecordDeleted,'N')='N'   
   AND ISNULL(GroupStaff.RecordDeleted,'N')='N'                 
   AND (Groups.Active=@Active1 OR Groups.Active=@Active2)                  
   AND (Programs.ProgramId=@ProgramsId OR @ProgramsId=-1)                  
   AND (Staff.StaffId=@StaffsId OR @StaffsId=-1)                  
   AND (Locations.LocationId=@LocationsId OR @LocationsId=-1)                                   
                                 
   order by groups.groupid                   
   open Staff                                   
                                    
   Fetch Staff into @GroupIds,                                
   @GroupCode,@GroupName, @Active,@programid, @ProgramCode, @locationid, @LocationCode, @procedurecodeid ,                                
   @DisplayAs, @Staffid , @StaffName                                
                                   
                                    
   set @Counter=0                                        
   create table #temp1                                    
   (                                    
    GroupIds int,                                
    GroupCode varchar(50),        
    GroupName varchar(250),                                   
    Active varchar(10),                                
    programid int,                                
    ProgramCode varchar(50),                                    
    LocationId int,                                
    LocationCode varchar(50),                                    
    ProcedureCodeId int,                                
    DisplayAs varchar(75),      --1 March 2017  vsinha                               
    StaffId int,                                
    Staff1  varchar(500),                                    
    Staff2 varchar(500),                                    
    Staff3 varchar(500),                                    
    Staff4 varchar(500)                                
                     
   )                  
   WHILE @@Fetch_Status = 0                
    Begin                                  
      print @StaffName                                  
     set @Counter=@Counter + 1                                        
     if @Counter=1                                    
     BEGIN                                    
      insert into #temp1(GroupIds,GroupCode,GroupName,Active,programid,ProgramCode,locationid,LocationCode,procedurecodeid,DisplayAs,Staffid,Staff1,Staff2,Staff3,Staff4)                                     
      values(@GroupIds,@GroupCode,@GroupName,@Active,@programid,@ProgramCode,@locationid,@LocationCode,@procedurecodeid,@DisplayAs,@Staffid,@StaffName,'','','')          
          
     END                                    
                                        
     ELSE if @Counter=2                                    
     BEGIN                                    
      update #temp1 set Staff2=@StaffName   where GroupIds=@GroupIds                                 
     END                                    
     Else if @Counter=3                                    
     BEGIN                                    
      update #temp1 set Staff3=@StaffName    where GroupIds=@GroupIds                                
     END                                    
     Else if @Counter=4                              
     Begin                                    
      update #temp1 set Staff4=@StaffName    where GroupIds=@GroupIds                                
     End                                    
      set  @tempGroupId = @GroupIds                                
    Fetch Staff into @GroupIds,                                
    @GroupCode,@GroupName, @Active, @programid, @ProgramCode, @locationid,                                
    @LocationCode, @procedurecodeid , @DisplayAs, @Staffid ,                                
    @StaffName           
                                  
       if @tempGroupId!=@GroupIds                                
       BEGIN                                
                                    
       set @Counter=0                             
                                   
       END                                   
    End                                    
    close Staff                                        
    DEALLOCATE Staff                                        
                                        
    Select * from #temp1                                    
    drop table #temp1                                  
                      
  END TRY                  
  BEGIN CATCH                  
   DECLARE @Error varchar(8000)                                            
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetDataForGroups')                                        
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