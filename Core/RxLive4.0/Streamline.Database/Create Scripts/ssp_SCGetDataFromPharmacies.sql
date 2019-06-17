          
CREATE  PROCEDURE  [dbo].[ssp_SCGetDataFromPharmacies]  
  (@ClientId int)            
As              
                      
Begin                      
/*********************************************************************/                        
/* Stored Procedure: dbo.ssp_SCGetDataFromPharmacies                */               
              
/* Copyright: 2005 Provider Claim Management System             */                        
              
/* Creation Date:  30/10/2006                                    */                        
/*                                                                   */                        
/* Purpose: Gets Data From Pharamacies Table  */                       
/*                                                                   */                      
/* Input Parameters: None */                      
/*                                                                   */                         
/* Output Parameters:                                */                        
/*                                                                   */                        
/* Return:   */                        
/*                                                                   */                        
/* Called By: getPharmacies() Method in MSDE Class Of DataService  in "Always Online Application"  */              
/*      */              
              
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/*   Updates:                                                          */                        
              
/*       Date              Author                  Purpose                                    */                        
/*  30/10/2006    Piyush Gajrani           Created                
/* 12/02/2009    Loveena     Modified (as per task#188 to display Pharmacies in alphabetical order)*/           
/* 26/02/2009    Loveena     Modified (as per task#92 drop-down to display all active pharmacies)*/           
/* 02/03/2009  Loveena  Modified (as per task#155 To Remove Select * Statements from Stored Procedures */
/* 22Oct2009   Loveena  Modified ( as ref to Task#2589 To Sort Pharmacies according to Sequence Number*/                                */                        
/*********************************************************************/                         
                    
  --Commented by Loveena in ref to Task#155 on 2-March-2009 to remove Select * Statements.          
  --select * from dbo.Pharmacies where ISNULL(RecordDeleted,'N')='N'          
  --Added Select Statement by Loveena in ref to Task#155 on 2-March-2009 to remove Select * Statements         
  --Commented by Loveena in ref to Task#2589       
 -- select Pharmacies.PharmacyId,PharmacyName,Active,PhoneNumber,FaxNumber,Address,City,State,          
 -- ZipCode,AddressDisplay,Pharmacies.RowIdentifier,Pharmacies.ExternalReferenceId,Pharmacies.CreatedBy, Pharmacies.CreatedDate, Pharmacies.ModifiedBy, Pharmacies.ModifiedDate,         
 -- Pharmacies.RecordDeleted, Pharmacies.DeletedDate, Pharmacies.DeletedBy        
 -- from dbo.Pharmacies         
 --  where ISNULL(Pharmacies.RecordDeleted,'N')='N'          
 --And isnull(Active,'Y')<>'N' order by PharmacyName       
       
 if (@ClientId is not null )  
 Begin   
 create table #temp(PharmacyId int,PharmacyName varchar(100),Active char,PhoneNumber varchar(50),FaxNumber varchar(50),Address varchar(100),City varchar(30),State varchar(30),          
  ZipCode varchar(12),AddressDisplay varchar(150),SequenceNumber int)      
  insert into #temp      
  select Pharmacies.PharmacyId,PharmacyName,Active,PhoneNumber,FaxNumber,Address,City,State,          
  ZipCode,AddressDisplay,SequenceNumber from Pharmacies inner join ClientPharmacies on ClientPharmacies.PharmacyId = Pharmacies.PharmacyId      
 where ISNULL(Pharmacies.RecordDeleted,'N')='N' and ISNULL(ClientPharmacies.RecordDeleted,'N')='N' and    
 isnull(Active,'Y')<>'N' and Clientid=@ClientId      
       
select P.PharmacyId,P.PharmacyName,P.Active,P.PhoneNumber,P.FaxNumber,P.Address,P.City,P.State,          
  P.ZipCode,P.AddressDisplay,P.RowIdentifier,P.ExternalReferenceId,P.CreatedBy, P.CreatedDate, P.ModifiedBy, P.ModifiedDate,         
  P.RecordDeleted, P.DeletedDate, P.DeletedBy, SequenceNumber         
  from dbo.Pharmacies P       
  left join #temp on #temp.PharmacyId = P.PharmacyId      
   where ISNULL(P.RecordDeleted,'N')='N'   and       
  isnull(P.Active,'Y')<>'N' order by P.PharmacyName       
       
 drop table #temp     
 end  
 else  
select PharmacyId,PharmacyName,Active,PhoneNumber,FaxNumber,Address,City,State,      
  ZipCode,AddressDisplay,RowIdentifier,ExternalReferenceId,CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,     
  RecordDeleted, DeletedDate, DeletedBy   from dbo.Pharmacies where ISNULL(RecordDeleted,'N')='N'      
 And isnull(Active,'Y')<>'N'  order by PharmacyName        
              
  --Checking For Errors              
  If (@@error!=0)              
  Begin              
   RAISERROR  20006   'ssp_SCGetDataFromPharmacies: An Error Occured'               
   Return              
   End                       
                      
              
End 