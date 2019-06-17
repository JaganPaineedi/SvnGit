IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCPostSignatureUpdateReleaseOfInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCPostSignatureUpdateReleaseOfInformation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


   
CREATE Procedure [dbo].[csp_SCPostSignatureUpdateReleaseOfInformation]
(
@ScreenKeyId int,                      
@StaffId int,                      
@CurrentUser varchar(30),                      
@CustomParameters xml
 )
AS    
/************************************************************************************/        
/* Stored Procedure: dbo.[csp_SCPostSignatureUpdateReleaseOfInformation] 331485,1,'ADMIN',''       */        
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */        
/* Creation Date:   23/jan/2013            */             
/* Purpose:To create No. of documents of 'Release of Information' document as created in CustomDocumentReleaseOfInformations   */       
/*                     */      
/* Input Parameters:  @ScreenKeyId int,@StaffId,@CurrentUse,@CustomParameters       */      
/*                     */        
/* Output Parameters:   None              */        
/*                     */        
/* Return:  0=success, otherwise an error number         */        
/*                     */        
/* Called By:                  */        
/*                     */        
/* Calls:                   */        
/*                     */        
/* Data Modifications:                */        
/*                     */        
/* Updates:                   */        
/*  Date           Author             Purpose            */        
/* 23/jan/2013   Atul Pandey          To create No. of documents of 'Release of Information' document as created in CustomDocumentReleaseOfInformations w.r.t task #2 of project Newaygo Customizations  */  
/* 05/Feb/2013   Sanjay Bhardwaj      Modified wrt to task#2 in Project Newaygo Customization. 
                                      1. Client Release of Information log created on Client Signature only
                                      2. use @authorid instead of @staffid for creating new document and document version entries
                                      3. Commenting before each step according to SRS 2.3 attached at #2*/
/*08/Apr/2013	 Sanjay Bhardwaj	  Modified wrt Task#2 Newaygo Customizations
									  What & Why : add RecordDeleted Checks*/                                      
/************************************************************************************/   
Begin
Begin Try
 
declare    @CurrentDocumentVersionId  int      
			,@CurrentVersionstatus  int      
			,@clientid int    
			,@ClientSignatureId int  
			,@SignatureType varchar(1)  
			,@documentcodeid int   
			,@authorid  int 
      
    
declare @documents table (DocumentId int not null)    
declare @documentversions table (id int identity,DocumentVersionId int not null, NewDocumentid int not null)  
declare @ClientInformationReleases table (NewClientInformationReleaseId int not null)    
  
  
select     
       @CurrentDocumentVersionId=CurrentDocumentVersionId    
      ,@CurrentVersionstatus=currentversionstatus    
      ,@clientid=ClientId    
      ,@documentcodeid=DocumentCodeId  
      ,@authorid=AuthorId  
from Documents where documentId=@ScreenKeyId and ISNULL(RecordDeleted,'N')='N'   

/*Add by sanjayb 5/feb/2013 #2*/     
SELECT @ClientSignatureId = @CustomParameters.value('Root[1]/Parameters[1]/@SignerId','bigint')        
SELECT @SignatureType = @CustomParameters.value('Root[1]/Parameters[1]/@SignerType','varchar(1)')        
/*End#2*/       

   insert  into @documentversions    
     select @CurrentDocumentVersionId,@ScreenKeyId
 
Update CustomDocumentReleaseOfInformations set OldDocumentVersionId=@CurrentDocumentVersionId where DocumentVersionId=@CurrentDocumentVersionId  and OldDocumentVersionId is null

/*Add by sanjayb 5/feb/2013 #2*/     
 --@authorid instead of @staffid for document and document version
 --Commenting before each statement done according to SRS 2.3 attached at #2
 --IF(ISNULL(@CurrentVersionstatus,-1)=22 and ISNULL(@authorid,-1)=@StaffId)    
 --Check Signed Document status i.e 22(signed) and Checking that Document ClientId is equal to SignatureId
 IF(ISNULL(@CurrentVersionstatus,-1)=22 and ISNULL(@ClientSignatureId,-1)=@clientid)    
   BEGIN    
-------Creating Documents entry here
     insert into documents(createdby,  createddate, modifiedby,  modifieddate, ClientId, DocumentCodeId, status,authorid,signedbyauthor,signedbyall,currentversionstatus,EffectiveDate,tosign)    
     output inserted.DocumentId   into @documents    
     select @CurrentUser,getdate(),  @CurrentUser,getdate(),    @clientid,@documentcodeid, 22,   @authorid, 'Y',            'Y'      ,22,cast(convert(varchar(10), getdate(),101) as datetime),null    
     from CustomDocumentReleaseOfInformations where DocumentVersionId=@CurrentDocumentVersionId  and   ReleaseOfInformationOrder>1
          and  ISNULL(RecordDeleted,'N')='N' --add by sanjayb as per task#2 requested by Katie H
-------Creating Document Version entry here        
     insert into documentversions(createdby,createddate,modifiedby,modifieddate,documentid,version,authorid,revisionnumber)    
     output inserted.DocumentVersionId ,inserted.DocumentId    into @documentversions    
     select @CurrentUser,getdate(),@CurrentUser,getdate(),d.DocumentId,1,@authorid,1    
     from @documents d    
-------Update Documents's CurrentDocumentVersion and InprogressDocumentVersion column
     update  d    
     set d.currentdocumentversionid=dv.DocumentVersionId,    
     inprogressdocumentversionid=dv.DocumentVersionId    
     from documents d inner join @DocumentVersions dv  
     on d.DocumentId=dv.NewDocumentid  
-------Selecting Custom Document Release of Information for the purpose of Creating Client Release of Information Log entry here              
       SELECT   @clientid AS ClientId,    
              case when (CDR.ReleaseContactType='C') then ReleaseToReceiveFrom
				else null
				end as ReleaseToId    
              ,case when (CDR.ReleaseContactType='C') then ISNULL( CO.LastName,'') +', '+ISNULL( CO.FirstName,'')
					else(CDR.ReleaseName) 
				end As ReleaseToName    
              ,convert(varchar(10), D.EffectiveDate,101)  as StartDate    
              ,ReleaseEndDate   as EndDate
              ,cdr.ReleaseAddress + '|' + cdr.ReleasePhoneNumber as Comment
              ,@CurrentUser as CreatedBy         
              ,getdate() as CreatedDate    
     INTO #VARCustomDocumentReleaseOfInformations     
     FROM CustomDocumentReleaseOfInformations CDR     
       inner join DocumentVersions DV on dv.DocumentVersionId=CDR.DocumentVersionId       
    inner join Documents D on D.DocumentId=Dv.DocumentId       
    inner join Clients C on D.ClientId=C.ClientId      
    left  join ClientContacts CO on co.ClientContactId=cdr.ReleaseToReceiveFrom  
     WHERE D.DocumentId=@ScreenKeyId     
     AND ISNULL(ReleaseInformationFrom,'N')='Y'   
     AND ISNULL(CDR.recorddeleted,'N')='N' 
     AND ISNULL(DV.recorddeleted,'N')='N' 
     AND ISNULL(D.recorddeleted,'N')='N'
     AND ISNULL(C.recorddeleted,'N')='N'
     AND ISNULL(CO.recorddeleted,'N')='N'
-------Creating Client Release of Information Log entry here              
    INSERT INTO ClientInformationReleases  
                (    
                   [ClientId]    
				  ,[ReleaseToId]    
				  ,[ReleaseToName]    
				  ,[StartDate]    
				  ,[EndDate]    
				  ,[Comment]    
				  --,[DocumentAttached]    
				  --,[Remind]    
				  --,[DaysBeforeEndDate]    
				  ,[Locked]    
				  ,[LockedBy]    
				  ,[LockedDate]    
				 -- ,[RowIdentifier]    
				  ,[CreatedBy]    
				  ,[CreatedDate]    
               )    
            --  output inserted.ClientInformationReleaseId   into @ClientInformationReleases    
				  SELECT      
				   ClientId    
				  ,ReleaseToId    
				  ,ReleaseToName    
				  ,StartDate    
				  ,EndDate 
				  ,Comment 
				  ,'Y'
				  ,@CurrentUser
				  ,GETDATE() 
				  ,CreatedBy    
				  ,CreatedDate    
				  FROM  #VARCustomDocumentReleaseOfInformations    
-------Updating Custom Document Release of Information's DocumentVersionId with newly created DocumentVersions.DocumentVersionId
    update CDRI  
       set CDRI.DocumentVersionId=DV.DocumentVersionId  
      FROM   
      @documentversions dv  
     inner JOIN  CustomDocumentReleaseOfInformations CDRI ON  CDRI.ReleaseOfInformationOrder=dv.id
     where CDRI.OldDocumentVersionId = @CurrentDocumentVersionId
-------Dropping Temprorary Table
DROP TABLE #VARCustomDocumentReleaseOfInformations                  
   END    

 End Try                            
  Begin Catch                              
  declare @Error varchar(8000)                                            
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCPostSignatureUpdateReleaseOfInformation')                                             
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                              
  + '*****' + Convert(varchar,ERROR_STATE())                                                            
  End Catch                              

 End            
      
      




