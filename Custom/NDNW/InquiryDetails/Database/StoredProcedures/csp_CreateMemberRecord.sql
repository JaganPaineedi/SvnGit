IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateMemberRecord]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_CreateMemberRecord]
GO


CREATE proc [dbo].[csp_CreateMemberRecord]              
@Active char(1),      
@LastName varchar(50),      
@FirstName varchar(30),      
@SSN varchar(25),      
@DOB datetime,      
@FinanciallyResponsible char(1),      
@DoesNotSpeakEnglish char(1),      
@StaffId int,  
@LoggedInUserCode varchar(30)      
as              
/*********************************************************************/                                                                        
/* Stored Procedure: dbo.csp_CreateMemberRecord               */                                                                        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                        
/* Creation Date:    22/Sep/2011                                         */                                                                        
/*                                                                   */                                                                        
/* Purpose:  Used in creating new Member Record for Member Inquiry Detail Page  */                                                                       
/*                                                                   */                                                                      
/* Input Parameters:  @Active   */                                                                      
/*       @LastName */      
/*       @FirstName */      
/*       @SSN  */      
/*       @DOB  */      
/*       @FinanciallyResponsible */      
/*       @DoesNotSpeakEnglish */             
/*                                                      */                                                                        
/* Output Parameters:   Dataset of Newly added Member's Details                */                                                                        
/*                                                                   */                                                                       
/*                                                                   */                                                                        
/*  Date    Author     Purpose                             */                                                                        
/*  22/Sep/2011   Minakshi Varma   Created       */        
/* 03/May/2012   Sonia     Modified to create Active client as in Kalamazoo this is requirment       */     
/* 04-07-2012   Rakesh Garg    Comment the code for Insert in StaffClients table as values in this table will be inserted through trigger TriggerInsert_Clients w.rf to task 1663 in Kalamazoo Go Live Project*/                                               
/* 20-March-2013  Swapan Mohan   Added If not exists check to avoid duplicate clients not being created and Pass @LoggedInUserCode for inserting in Clients Table                 
  24-May-2013   Pselvan     Insert Rows into StaffClients table, it gives permission for the staff to access the client.   */  
  /*19 Aug 2013 katta sharath kumar Pull this sp from Newaygo database from 3.5xMerged with task #3 in Ionia County CMH - Customizations*/    
   /*18 Nov 2015 Vichee Humane  Added MasterRecord in Clients table as 'Y' for insertion CEI - Support Go Live #46 */ 

/************3*******************************************************************************************************************************************/                                                                             
BEGIN                                                         
 BEGIN TRY  
  DECLARE @ClientId int  
  IF not exists (SELECT 1 FROM Clients WHERE  [LastName] =  @LastName and FirstName = @FirstName and SSN = @SSN and DOB =  @DOB and ISNULL(RecordDeleted,'N') = 'N')  
   BEGIN                
    INSERT INTO [Clients]([Active],[LastName],[FirstName],[SSN],[DOB],[FinanciallyResponsible],[DoesNotSpeakEnglish],[MasterRecord])  
    VALUES('Y',@LastName,@FirstName,@SSN,@DOB,@FinanciallyResponsible,@DoesNotSpeakEnglish,'Y')      
    set @ClientId=@@IDENTITY      
      
    -- Added by Ponnnin Starts Here  
    insert into StaffClients (StaffId, ClientId)  
            select     VSP.StaffId,@ClientId from ViewStaffPermissions as VSP INNER JOIN  
                   Staff as s on VSP.StaffId = s.StaffId where VSP.PermissionTemplateType = 5705 and VSP.PermissionItemId = 5741  
                      and not exists(select * from StaffClients SC  where SC.StaffId = VSP.StaffId and ClientId = @ClientId) and ( s.RecordDeleted IS NULL OR s.RecordDeleted = 'N')   
                       -- Added by Ponnnin Ends Here  
   END  
  ELSE  
  BEGIN  
   SET @ClientId = (SELECT ClientId  FROM Clients WHERE  [LastName] =  @LastName and FirstName = @FirstName and SSN = @SSN and DOB =  @DOB and ISNULL(RecordDeleted,'N') = 'N')  
  END      
 --INSERT INTO [StaffClients]      
 --           ([StaffId]      
 --           ,[ClientId])      
 --     VALUES      
 --           (@StaffId      
 --           ,@ClientId)      
                  
  SELECT ClientId,LastName,FirstName,SSN,DOB      
  FROM Clients      
  WHERE ClientId=@ClientId     
 END TRY                                            
 BEGIN CATCH                         
 DECLARE @Error varchar(8000)                                                                          
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                    
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_CreateMemberRecord')                                                
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                                                          
                                                        
    RAISERROR                                                                           
    (                                         
  @Error, -- Message text.                                                                          
  16, -- Severity.                                                                          
  1 -- State.                                                                          
    );                                                           
 End CATCH                                                                                                                 
                                                     
End   