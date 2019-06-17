Create ProcedURE [dbo].[SSP_SCGetPrimaryStaffClients]     
(                    
@StaffId varchar(150)                   
)                    
As                    
/*********************************************************************/                    
/* Stored Procedure: dbo.Alerts_DelProc                */                    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                    
/* Creation Date:    8/1/05                                         */                    
/*                                                                   */                    
/* Purpose:  It will return the clients   Primary clients for the staff id and Clients which he see in the last six months*/                   
/*                                                                   */                  
/* Input Parameters: @StaffId                 */                  
/*                                                                   */                    
/* Output Parameters:   None                               */                    
/*                                                                   */                    
/* Return:  0=success, otherwise an error number                     */                    
/*                                                                   */                    
/* Called By:                                                        */                    
/*                                                                   */                    
/* Calls:                                                            */                    
/*                                                                   */                    
/* Data Modifications:                                               */                    
/*                                                                   */                    
/* Updates:                                                          */                    
/*  Date     Author       Purpose                                    */                    
/* 8/1/05   Vikas     Created                                    */                    
/*********************************************************************/                     
                   
BEGIN                  
              
          
                                     
              
create table #temp1              
(ClientId  int not null)            
          
Declare  @UsePrimaryProgramForCaseload char(1), @PrimaryProgramId int            
select  @UsePrimaryProgramForCaseload = UsePrimaryProgramForCaseload,            
@PrimaryProgramId = PrimaryProgramId            
FROM  Staff where StaffId=@StaffId            
          
-- Get a list of My clients             
-- These are clients for whom the user is the clinicain is the clinician in ClientPrograms            
-- Or the user is the clinician on an Service.            
-- Union will automatically make sure that you get distinct records            
      
            
 -- Only get clients enrolled in the program            
 insert into #temp1(ClientId)            
select distinct A.ClientId     
from Clients a        
-- Modified Inner Join to left join by Dinesh on 30-Sep-06        
JOIN ClientPrograms c ON (a.ClientId = c.ClientId)        
where a.active = 'Y'        
and (    
--RJN 1/29/2007 Select only clients where primaryClinician is staff,    
-- or is primarily assigned to the same program as staff if usePrimaryProgramForCaseload is designated.    
 ( a.PrimaryClinicianID = @StaffId)    
 OR    
 (isnull(@UsePrimaryProgramForCaseload,'N') = 'Y'    
 and c.ProgramId = @PrimaryProgramId    
 and c.PrimaryAssignment = 'Y')    
    )    
and c.status <> 5 and isnull(c.recordDeleted,'N')<>'Y'    
and IsNull(a.RecordDeleted,'N')<>'Y'      
    
              
Declare  @PrimaryClient char(1)              
select @PrimaryClient =  DisplayPrimaryClients from Staff where StaffId=@StaffId and isnull(RecordDeleted,'N')='N'    
  
  
-- check Added for Displaying only Primary Clients on 4th April 2007    
if (@PrimaryClient = 'N')    
BEGIN    
    
 insert into #temp1              
 (ClientId)              
 select distinct a.ClientId              
 from Clients a              
 JOIN ClientEpisodes b ON (a.ClientId = b.ClientId              
 and a.CurrentEpisodeNumber = b.EpisodeNumber              
 -- Look at Active Episodes              
               
 -- Commented By Gursharan Singh              
 -- and  b.Active = 'Y'              
 )              
 JOIN Services c ON (b.ClientId = c.ClientId)              
 -- User is the clinician on the Service              
 where c.ClinicianId = @StaffId              
 -- Service was done in the last 6 months              
 and  c.DateOfService >= DATEADD(month, -3, convert(datetime, convert(varchar,getdate(),101)) )              
 -- Do not include records where the Encounter status is ERROR              
 and Isnull(a.RecordDeleted,'') <> 'Y'               
 and Isnull(b.RecordDeleted,'') <> 'Y'              
 and Isnull(c.RecordDeleted,'') <> 'Y'              
 and c.status not in (72, 73)              
 and  not exists              
 (select * from #temp1 p              
 where a.ClientId = p.ClientId)    
END    
              
if @@error <> 0 return              
              
         
--get the clients where clinician is Primary one                  
 select a.ClientId, a.LastName, a.FirstName, ltrim(rtrim(a.LastName))+', '+a.FirstName as "Name",a.RowIdentifier, 1 as Status   , PrimaryProgramId , PrimaryClinicianId            
 from Clients a              
 JOIN #temp1 b ON (a.ClientId = b.ClientId) and a.Active='Y'              
              
    IF (@@error!=0)                  
    BEGIN                  
        RAISERROR  20002 'SSP_SCGetPrimaryStaffClients: An Error Occured'                  
        RETURN(1)                  
                      
    END                  
                  
    RETURN(0)                  
END    
    
