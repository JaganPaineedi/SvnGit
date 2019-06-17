/****** Object:  StoredProcedure [dbo].[ssp_CMCreateNextEvent]    Script Date: 06/24/2014 17:19:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMCreateNextEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMCreateNextEvent]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMCreateNextEvent]    Script Date: 06/24/2014 17:19:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
                  
                                      
create PROCEDURE [dbo].[ssp_CMCreateNextEvent]    --67,154641,'11/17/2010 12:00:00 AM',103,'TER',164,2,0                                  
                            
  --Commented by SweetyK                                    
 --@UserId int,                                        
 @ClientId int,                                        
 @EventId int,                                        
 @NextEventDateTime datetime,                                        
 @NextEventTypeId int,                                        
 @UserCode varchar(100) ,                                      
 @StaffId int ,                        
 @NextInsurerId int,                        
 @NextProviderId int                                      
                                         
AS                                        
                                      
                                      
/*********************************************************************/                                                      
/* Stored Procedure: [dbo].[ssp_CMCreateNextEvent]            */                                                      
/* Copyright: 2005 Provider Claim Management System             */                                                      
/* Creation Date:  19 April 2010                                 */                                                      
/*                                                                   */                                                      
/* Purpose: Inserts Data into Custom Tables of SU-Discharge and ASAM Documents    */                                                     
/*                                                                   */                                                    
/* Input Parameters:    @UserId int,                                        
      @ClientId int,                                        
      @EventId int,                                        
      @NextEventDateTime datetime,                                        
      @NextEventTypeId int,                                        
      @UserCode varchar(100) ,                                      
      @StaffId int                                      */                                                    
/*                                                                   */                                                      
/* Output Parameters:                                */                                                      
/*                                                                   */                                                      
/* Return:    */                                                      
/*                                                                   */                                                      
/* Called By:                                                        */                                                      
/*                                                                   */                                                      
/* Calls:                                                            */                                                      
/*                                                                   */                                                      
/* Data Modifications:                                               */                                                      
/*                                                                   */                                                      
/* Updates:                                                          */                                                      
/*  Date               Author                        Purpose                         */                                                      
/* 19 April 2010       Ashwani Kumar Angrish         Created             */   
/* 29 Oct 2010         Sweety Kamboj                 Modified             */                     
/*1st April 2011       Priya                         Modified   Delete the insertion in Custom Tables */  
/* 24 Nov 2014         Shruthi.S                     Modified   Updated CurrentVersionStatus to avoid error on opening next event.Ref#107 Care Management to SmartCare Env. Issues Tracking.*/                       
/* 31 Dec 2014         Arjun K R					 Modified   InProgressDocumentVersionId value is inserted to Documents table . Ref#323 CM to SC Env Issues Tracking */
-- 25.Feb.2015			Rohith Uppin				 Record was not inserting into DocumentSignatures whenever new Event(document) is created as it is supposed to. Task#828 SWMBH Support.
/*********************************************************************/                                          
                                      
BEGIN                                      
                                      
Declare @NexteventID int                        
Declare @DocumentCodeId int                                      
Declare @DocumentId int                                      
Declare @DocumentVersionId int                                
BEGIN TRY                                        
   if(@NextProviderId <= 0)                    
   BEGIN                    
  set @NextProviderId=null                    
   END    
   --added By Priya  
   if(@NextInsurerId <= 0)                    
   BEGIN                    
  set @NextInsurerId=null                    
   END    
                     
                                      
--------------EVENTS---------------------------------------------------------------------------                                      
  Insert into Events (StaffId,ClientId,EventTypeId,EventDateTime,[Status],ProviderId,InsurerId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                      
  values                      (@StaffId,@ClientId,@NextEventTypeId,@NextEventDateTime,2061,@NextProviderId,@NextInsurerId,@UserCode,GETDATE(),@UserCode,GETDATE());                                      
                                        
set @NexteventID=@@IDENTITY;                                      
                                      
 select  @DocumentCodeId=AssociatedDocumentCodeId from EventTypes where EventTypeId=@NextEventTypeId;                         
                       
  -- Check if already has next event                      
declare @followupEventId int                      
set @followupEventId=0                      
set @followupEventId=(select FollowUpEventId from Events where EventId=@EventId)                       
if(@followupEventId > 0)                      
BEGIN                      
  -- Delete record which was previously saved as next event                       
 update Events set RecordDeleted='Y',DeletedBy=@UserCode,DeletedDate=GETDATE() where EventId=@followupEventId                      
 update Documents set RecordDeleted='Y',DeletedBy=@UserCode,DeletedDate=GETDATE() where EventId=@followupEventId                  
 update DocumentVersions set RecordDeleted='Y',DeletedBy=@UserCode,DeletedDate=GETDATE() where DocumentId in (select DocumentId from Documents where EventId=@followupEventId)                        
                     
                        
                    
 END                       
                       
                       
 -- update Events for FollowupEventId                      
 update Events set FollowUpEventId= @NexteventID where EventId=@EventId                       
                       
                         
                                      
                                                        
--------------DOCUMENTS---------------------------------------------------------------------------                                      
Insert into Documents (ClientId,EventId,DocumentCodeId,EffectiveDate,[Status],AuthorId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                      
values                                      
(@ClientId,@NexteventID,@DocumentCodeId,@NextEventDateTime,20,@StaffId,@UserCode,GETDATE(),@UserCode,GETDATE());                                      
                                      
set @DocumentId=@@IDENTITY;                                      
                                      
--------------DOCUMENT VERSIONS---------------------------------------------------------------------------                                      
/*select top 10 * from DocumentVersions order by 1 desc*/                                  
                                      
Insert into DocumentVersions (DocumentId,[Version],CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                      
values                                      
(@DocumentId,1,@UserCode,GETDATE(),@UserCode,GETDATE());                          
                                      
set @DocumentVersionId=@@IDENTITY;                                      
                                      
----Insert current generated DocumentVersionId into CurrentDocumentVersionId of Documents table-----------------------------------------------------------------------------------------------------                                      
Update Documents set CurrentDocumentVersionId=@DocumentVersionId,CurrentVersionStatus=20,InProgressDocumentVersionId=@DocumentVersionId where DocumentId=@DocumentId;                                      
                   
-- DocumentSignatures needs records to be inserted whenever new document is created.
INSERT INTO dbo.DocumentSignatures 
                    ( DocumentId ,  
                      StaffId ,
                      SignatureOrder ,
                      CreatedBy ,  
                      CreatedDate ,  
                      ModifiedBy ,  
                      ModifiedDate 
                    )  
            VALUES  ( @DocumentId , -- DocumentId - int
                      @StaffId , -- StaffId - int
                      1 , -- SignatureOrder - int
                      @UserCode , -- CreatedBy - type_CurrentUser  
					  GETDATE() , -- CreatedDate - type_CurrentDatetime  
                      @UserCode , -- ModifiedBy - type_CurrentUser  
                      GETDATE()  -- ModifiedDate - type_CurrentDatetime 
                    )                   
                             
-----INSERT IN SU-DISCHARGE                                       
--IF @NextEventTypeId=1006             
--Begin                                      
                                      
-- Insert into CustomSUDischarges (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                      
-- values                                      
-- (@DocumentVersionId,@UserCode,GETDATE(),@UserCode,GETDATE())                                    
                                  
-- CustomSUDischargeDrugs                      
 --Insert into CustomSUDischargeDrugs (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                  
 --values                                      
 --(@DocumentVersionId,@UserCode,GETDATE(),@UserCode,GETDATE())                                   
                                  
 --------END INSERT SU-DISCHARGE                                   
                                    
                                      
--END                                       
                                      
------Insert in ASAM                    
--ELSE IF @NextEventTypeId=1003                                       
--BEGIN                                      
                                      
--Insert into  CustomASAMPlacements (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                      
--values                                      
--(@DocumentVersionId,@UserCode,GETDATE(),@UserCode,GETDATE());                                      
-- END                                    
--------END INSERT ASAM                                   
                                  
-------------------------------------CUSTOM CONTACT EVENT                                  
--ELSE IF @NextEventTypeId=104                                    
--BEGIN                                    
                                    
--insert into CustomContactEvents (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                    
--END                                    
                                    
 ---------------------------------------END CUSTOM CONTACT EVENT                                  
                                   
                                   
                                  
 -------------------------------------PRESCREEN                                  
-- ELSE IF @NextEventTypeId=101                                    
--BEGIN                                   
--insert into CustomAcuteServicesPrescreens (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                               
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                    
                                  
--insert into CustomMedicationHistory (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(          
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                    
                                  
                                  
--insert into CustomSUSubstances (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                            
--getdate()                                    
--);                                    
                                  
                                  
-----Not to be Entered because of parent child relation                                    
--insert into DiagnosesIAndII (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                    
                                  
                              
--insert into DiagnosesIII (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                    
                                  
                                  
                                  
--insert into DiagnosesIV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                    
                                  
                                  
--insert into DiagnosesV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                    
                                  
--END                                    
                                  
-------------------------------------------------END PRESCREEN                                     
                                    
                                    
  ------------------------------------------CONCURRENT REVIEWS                                  
                                    
--ELSE IF @NextEventTypeId=102                                    
--BEGIN         
                                  
-- insert into CustomConcurrentReviews (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                             
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                  
                                  
                                  
-- insert into DiagnosesIII (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                  
                                  
                                  
                                  
--insert into DiagnosesIV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                   
--@UserCode,                                    
--getdate()                                    
--);                                    
                                  
                                  
--insert into DiagnosesV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                
--);                                    
                                  
--END                                  
  ------------------------------------------------END CONCURRENT REVIEWS                                  
                                    
 ---------------------------------------------DISCHARGE EVENTS                                  
                                   
 --ELSE IF  @NextEventTypeId=103                                   
 --BEGIN                                  
                                   
                                   
--------Commented Temporarily need to be discussed for "PreScreenDocumentId" in CustomDischargeEvents                                  
-- insert into CustomDischargeEvents (DocumentVersionId,PreScreenDocumentId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                   
--@PreScreenDocumentId,                                   
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                  
                                   
                                   
--insert into CustomDischargeEvents (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                  
                                  
                               
--insert into DiagnosesIII (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                       
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                  
                                  
                                
                                  
--insert into DiagnosesIV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                           
--@UserCode,                                    
--getdate()                                    
--);                                    
                                  
                               
--insert into DiagnosesV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                  
       
-- END                                  
                                   
 -------------------------------------------------END DISCHARGE EVENTS                                   
                                    
                                    
  -----------AUTHORIZATION                                   
 --ELSE IF  @NextEventTypeId=105                                  
 --BEGIN                                  
                                   
 --END                                  
 ----------END AUTHORIZATION                                                     
                                     
  -----------------------------------------------DIAGNOSIS                                   
-- ELSE IF  @NextEventTypeId=106                                  
-- BEGIN                                  
-- insert into DiagnosesIII (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                     
--getdate()                                    
--);                                  
                                  
                                  
                                  
--insert into DiagnosesIV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                    
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                    
                                  
                                  
--insert into DiagnosesV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--values(                                    
--@DocumentVersionId,                                  
--@UserCode,                                    
--getdate(),                                    
--@UserCode,                                    
--getdate()                                    
--);                                    
-- END                                  
 ------------------------------------------------------------END DIAGNOSIS                                  
                                   
  
   ---------SU-AUTHORIZATION                                   
 --ELSE IF  @NextEventTypeId=107                                  
 --BEGIN                                  
                                   
 --END                                  
 ----------END SU-AUTHORIZATION                                  
                                   
                                   
                                  
  -----------------------------------------------    SUSCREEN    ------------------------------------------                                  
  ---Commented Temporarily becuase of parameters "Complete,InitialCallDateTime,IntakeStaff,FirstName,LastName"                                  
  ------- which are not nullable                                  
-- ELSE IF  @NextEventTypeId=1000                                  
-- BEGIN                                  
--  insert into CustomSUScreens (DocumentVersionId,Complete,InitialCallDateTime,IntakeStaff,FirstName,LastName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--  values(                                    
--  @DocumentVersionId,                                   
--  @Complete,                                  
--  @InitialCallDateTime,                                  
--  @IntakeStaff,                                  
--  @FirstName,                                  
--  @LastName,                                   
--  @UserCode,                                    
--  getdate(),                                    
--  @UserCode,                                    
--  getdate()                                    
--);                                    
-- END                                  
 ----------------------------------------------------END  SUSCREEN                                  
                                  
-----------------------------------------------------SARF AND ADMISSION                                  
--ELSE IF  @NextEventTypeId=1008 OR @NextEventTypeId=1010                                   
-- BEGIN                                  
                                   
--  insert into CustomSURegistrations (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--  values(                                    
--  @DocumentVersionId,                                   
--  @UserCode,                             
--  getdate(),                                    
--  @UserCode,                                    
--  getdate()                                    
--  );                                    
                                    
                                    
                                     
  --insert into CustomSUAssessments (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
  --values(                                    
  --@DocumentVersionId,                                   
  --@UserCode,                                    
  --getdate(),                                    
  --@UserCode,                                    
  --getdate()         
  --);                                  
                                     
                                     
                                   
 --insert into CustomSUAssessmentServices (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
 -- values(                                    
 -- @DocumentVersionId,                                   
 -- @UserCode,                                    
 -- getdate(),                    
 -- @UserCode,                                    
 -- getdate()                                    
 -- );                                  
                                    
                                    
   --insert into DiagnosesIII (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
   --values(                                    
   --@DocumentVersionId,                                    
   --@UserCode,                                    
   --getdate(),                                    
   --@UserCode,                                    
   --getdate()                                    
   --);                                  
                                  
                                  
                                  
  --insert into DiagnosesIV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
  --values(                                    
  --@DocumentVersionId,                                    
  --@UserCode,                                    
  --getdate(),                                    
  --@UserCode,                                    
  --getdate()                                    
  --);                                    
                                  
                                  
  --insert into DiagnosesV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                      
  --values(                                    
  --@DocumentVersionId,                                    
  --@UserCode,                                    
  --getdate(),                                    
  --@UserCode,                                    
  --getdate()                         
  --);                                    
                                    
                                    
 --END                                  
                                 
-----------------------------------------END SARF AND ADMISSION                                  
                                  
                                  
----------------------------------EVENT-----------------------                                  
--ELSE IF  @NextEventTypeId=1015                                  
--BEGIN                                  
                                  
-- insert into Notes (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                        
--  values(                                    
--  @DocumentVersionId,                                    
--  @UserCode,                                    
--  getdate(),                                    
--  @UserCode,                                    
--  getdate()                                    
--  );                                    
                                  
                                  
--  insert into MentalStatus (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                                    
--  values(                                    
--  @DocumentVersionId,                                    
--  @UserCode,                                    
--  getdate(),                                    
--  @UserCode,                                    
--  getdate()                                    
--  );                                    
                                  
--END                                  
----------------------------------END EVENT-----------------------                                  
END TRY                                      
BEGIN CATCH                                      
                                      
If (@@error!=0)                                                  
 Begin                                                  
        RAISERROR  20002  'ssp_CMCreateNextEvent: An Error Occured'                                                  
                                                       
 End                                      
END CATCH                                      
                                         
END 