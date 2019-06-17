IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCDocumentGetPreviousNextDate')
	BEGIN
		DROP  Procedure  ssp_SCDocumentGetPreviousNextDate
	END

GO

CREATE  PROC [dbo].[ssp_SCDocumentGetPreviousNextDate](@DocumentID int,@ClientID int, @DocumentCodeId int,@AuthorID int)                                      
as                                    
/*********************************************************************/                                      
/* Stored Procedure: dbo.ssp_DocumentGetPreviousNextDate                         */                                      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                      
/* Creation Date:    8/22/05                                         */                                      
/*                                                                   */                                      
/* Purpose: it will return the Next and Previous effective Date for the documents      */                                      
/*                                                                   */                                    
/* Input Parameters: @DocumentID ,@ClientID, @DocumentCodeId,  @AuthorID              */                                    
/*                                                                   */                                      
/* Output Parameters:   None                           */                                      
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
/*   Date     Author       Purpose                                    */                                      
/*  8/22/05   Vikas    Created          */                                     
/* Nov 11,2008 Vikas Vyas Modified Perform check as per task #2602 */                           
/* July 20,2009 Sahil Bhagat remove Print statement as per task #3738 */                                 
/* Add Check of DocumentCodeID=99                  */                            
/* 24 Nov 2010    Vikas Monga    Modified        
                                 Restrict other staff to open in progress document if document is not shared     */        
/*17th Jan 2012   Davinder Kumar Record Deleted check added with reference to 541 in sc web other billable projects*/
/*25th March-2013 Rakesh Garg    Ref. to task 2817 in thresholds Documents - Arrow Issues
								 order by EffectiveDate,DocumentId instead of order by EffectiveDate,ModifiedDate And Optimize query using exists operator */                                  
/*30/10/2013      Bernardin      Condition added to check service deleted and document deleted(Threshold Support Task# 160)*/
/*02/01/2018      Lakshmi        What: There is an issue with viewing the previous signed document
								 Why: As per the previous code the document is not order by descending and  it was causing the issue so we added a condition to display documents by descending based on DocumnetID. 
									 Kalamazoo Build Cycle Tasks #57*/
/*********************************************************************/                                       
  Begin                                                        
              
 Begin try                                    
DECLARE @PreviousDocumentID int                                      
DECLARE @NextDocumentID int                                      
DECLARE @PreviousDate datetime                                      
DECLARE @NextDate datetime                                    
Declare @DocumentType int                                    
                                
DECLARE @NextAuthorID int                                 
DECLARE @NextDocCodeID int                                 
DECLARE @PreviousAuthorID int                                 
DECLARE @PreviousDocCodeID int                                 
                                

-- Create Temp Table                                                                    
create table #Temp(rid int IDENTITY, EffectiveDate datetime,DocumentID int,AuthorID int,DocCodeID int,ModifiedDate Datetime)                                    
                                                               
--Check for authorId exists or not                                    
IF ISNULL(@AuthorID,0)=0                           
	BEGIN                                                                                                        
		IF @DocumentCodeId=0                                     
			BEGIN                                
				INSERT into #Temp                                    
				SELECT EffectiveDate,DocumentID,AuthorId,DocumentCodeId,ModifiedDate  
				FROM Documents 
				WHERE (EXISTS (SELECT 1 FROM DocumentCodes dc WHERE dc.ServiceNote = 'Y' and ISNULL(dc.RecordDeleted,'N')='N' and dc.DocumentCodeId = Documents.DocumentCodeId)
				 --WHERE documentCodeID in (Select DocumentCodeID from DocumentCodes where (ServiceNote = 'Y' and ISNULL(RecordDeleted,'N')='N' )                               
					AND ISNULL(RecordDeleted,'N')='N' AND ClientID=@ClientID         
					AND (AuthorId = @AuthorId or -- Current clinician is an author                              
				  ProxyId = @AuthorId or  -- Current clinician is a proxy 
				  EXISTS (SELECT 1 FROM  StaffProxies SP  WHERE SP.StaffId = @AuthorId   and isnull(SP.RecordDeleted, 'N') = 'N' 
						and Documents.AuthorId = SP.ProxyForStaffId)           
				 --AuthorId in (select ProxyForStaffId  from StaffProxies   where StaffId = @AuthorId  and isnull(RecordDeleted, 'N') = 'N') 
				  OR -- Current staff is a proxy for an author  
				  [Status] in (22, 23) or -- Document is in the final status: Signed or Cancelled                              
				  DocumentShared = 'Y' and [Status] <> 20 )
				) 
				OR DocumentID=@DocumentID  AND Documents.[STATUS] <> 20                  
				 --order by EffectiveDate,ModifiedDate   
				 ORDER BY EffectiveDate,Documents.DocumentId                                  
			END                                                                                
		ELSE                                                                       
			Begin                                    
				INSERT into #Temp                                    
				SELECT EffectiveDate,DocumentID,AuthorId,DocumentCodeId,Documents.ModifiedDate   
				FROM Documents          
				WHERE (documentCodeID=@DocumentCodeId and                                    
				ISNULL(RecordDeleted,'N')='N' AND ClientID=@ClientID               
				AND (AuthorId = @AuthorId or -- Current clinician is an author                              
				ProxyId = @AuthorId or  -- Current clinician is a proxy 
				exists (Select 1 from  StaffProxies SP  where SP.StaffId = @AuthorId   and isnull(SP.RecordDeleted, 'N') = 'N' 
						and Documents.AuthorId = SP.ProxyForStaffId)                               
				   --AuthorId in (select ProxyForStaffId  from StaffProxies   where StaffId = @AuthorId and isnull(RecordDeleted, 'N') = 'N') 
				  or -- Current staff is a proxy for an author  
				  [Status] in (22, 23) or -- Document is in the final status: Signed or Cancelled                              
				  DocumentShared = 'Y'  and Status <> 20)          
				) 
				OR DocumentID=@DocumentID AND Documents.[Status] <> 20                  
				--order by EffectiveDAte,Documents.ModifiedDate                                    
				order by EffectiveDate,Documents.DocumentId 
			End                                    
	END                                                           
ELSE                                    
	BEGIN                                                                                                    
		IF @DocumentCodeId=0                                     
			BEGIN                                    
				INSERT into #Temp                                    
				SELECT EffectiveDate,DocumentID,AuthorId,DocumentCodeId,Documents.ModifiedDate  
				FROM Documents 
				WHERE (EXISTS (Select 1 from DocumentCodes dc where dc.ServiceNote = 'Y' and ISNULL(dc.RecordDeleted,'N')='N' and dc.DocumentCodeId = Documents.DocumentCodeId)
				-- WHERE documentCodeID in (Select DocumentCodeID from DocumentCodes where ( ServiceNote = 'Y' and ISNULL(RecordDeleted,'N')='N' ) 
				and ISNULL(RecordDeleted,'N')='N' AND  ClientID=@ClientID         
				--AND AuthorID=@AuthorID         
				AND (AuthorId = @AuthorId or -- Current clinician is an author                              
				ProxyId = @AuthorId or  -- Current clinician is a proxy
				exists (Select 1 from  StaffProxies SP  where SP.StaffId = @AuthorId   and isnull(SP.RecordDeleted, 'N') = 'N' 
						and Documents.AuthorId = SP.ProxyForStaffId)                              
				  --AuthorId in (select ProxyForStaffId   from StaffProxies where StaffId = @AuthorId  and isnull(RecordDeleted, 'N') = 'N')                             
				  or -- Current staff is a proxy for an author                               
				  [Status] in (22, 23) or -- Document is in the final status: Signed or Cancelled                              
				  DocumentShared = 'Y' and Status <> 20 ))
				  OR DocumentID=@DocumentID 
				  AND STATUS <> 20      
				--order by EffectiveDAte,Documents.ModifiedDate                                    
				order by EffectiveDate,Documents.DocumentId 
			END                                    

		ELSE                                     
			Begin                                    
				INSERT into #Temp                                    
				select EffectiveDate,DocumentID,AuthorId,DocumentCodeId,Documents.ModifiedDate 
				FROM Documents WHERE    
				(documentCodeID=@DocumentCodeId and                                    
				ISNULL(RecordDeleted,'N')='N' AND ClientID=@ClientID         
				AND (AuthorId = @AuthorId or -- Current clinician is an author                              
				ProxyId = @AuthorId or -- Current clinician is a proxy                              
				--AuthorId in (select ProxyForStaffId   from StaffProxies  where StaffId = @AuthorId   and isnull(RecordDeleted, 'N') = 'N') 
				exists (Select 1 from  StaffProxies SP  where Sp.StaffId = @AuthorId   and isnull(SP.RecordDeleted, 'N') = 'N' and Documents.AuthorId = SP.ProxyForStaffId)
				   or -- Current staff is a proxy for an author  
				  [Status] in (22, 23) or -- Document is in the final status: Signed or Cancelled                              
				  DocumentShared = 'Y'  and Status <> 20)              
				--AND AuthorID=@AuthorID 
				 )          
				 OR DocumentID=@DocumentID   
				AND STATUS <> 20     
				--order by EffectiveDAte,DocumentID,Documents.ModifiedDate            
				order by EffectiveDate,Documents.DocumentId 
                          
			End         
      
                  
	END                                    
                           
                                          
                                    
DECLARE @CurrentID int                                    
select @CurrentID=rid from #Temp where DocumentID=@DocumentID                   
                                 
                                    
IF @DocumentID>0                                      
 BEGIN                                      
  select @PreviousDocumentID=DocumentID,@PreviousDate=EffectiveDate,@PreviousAuthorID=AuthorID,                                
  @PreviousDocCodeID=DocCodeID from #Temp where rid=@CurrentID-1                             
  select @NextDocumentID=DocumentID,@NextDate=EffectiveDate,@NextAuthorID=AuthorID,                                
  @NextDocCodeID=DocCodeID from #Temp where rid=@CurrentID+1                                    
 END                                    
 ELSE                                    
 BEGIN                                    
  IF ISNULL(@AuthorID,0)=0  --if documentid is 0   then get the Most Recent document's Dates                                    
  begin                                    
   if @DocumentCodeId=0                                     
   begin                                    
     select top 1 @PreviousDocumentID=DocumentID,@PreviousDate=EffectiveDate,@PreviousAuthorID=AuthorId,                                
      @PreviousDocCodeID=DocumentCodeId     from                                       
      Documents where clientID=@ClientID and                                       
     --documentCodeID in (Select DocumentCodeID from DocumentCodes where ServiceNote = 'Y' and ISNULL(RecordDeleted,'N')='N' )                                    
      exists (Select 1 from DocumentCodes dc where dc.ServiceNote = 'Y' and ISNULL(dc.RecordDeleted,'N')='N' and dc.DocumentCodeId = Documents.DocumentCodeId)
      -- Changed for Threshold Support Task# 160
      and exists (Select 1 from Services s where  ISNULL(s.RecordDeleted,'N')='N' and s.ServiceId = Documents.ServiceId)
      and ISNULL(Documents.RecordDeleted,'N') = 'N'
      -- End
     AND ISNULL(RecordDeleted,'N')='N' AND status <> 20 order by DocumentID desc                                     
   end                                    
                                        
   else                                    
                                      
   begin                                    
     select top 1 @PreviousDocumentID=DocumentID,@PreviousDate=EffectiveDate,@PreviousAuthorID=AuthorId,@PreviousDocCodeID=DocumentCodeId  from                                       
      Documents where clientID=@ClientID and                                       
      DocumentCodeID=@DocumentCodeId AND ISNULL(RecordDeleted,'N')='N' AND Status <> 20 order by DocumentID desc                                     
   end                                    
  end                                    
                             
  ELSE                                    
  Begin                                    
   if @DocumentCodeId=0                                     
   Begin                                    
     select top 1 @PreviousDocumentID=DocumentID,@PreviousDate=EffectiveDate,@PreviousAuthorID=AuthorId,                                
      @PreviousDocCodeID=DocumentCodeId from                    
      Documents where clientID=@ClientID and                                       
     -- DocumentCodeID in (Select DocumentCodeID from DocumentCodes where ServiceNote = 'Y' and ISNULL(RecordDeleted,'N')='N' )
     exists (Select 1 from DocumentCodes dc where dc.ServiceNote = 'Y' and ISNULL(dc.RecordDeleted,'N')='N' and dc.DocumentCodeId = Documents.DocumentCodeId)
       -- Changed for Threshold Support Task# 160
      and exists (Select 1 from Services s where  ISNULL(s.RecordDeleted,'N')='N' and s.ServiceId = Documents.ServiceId)
      and ISNULL(Documents.RecordDeleted,'N') = 'N'
      --End
      AND status <> 20 order by DocumentID desc                                     
   end                                    
                                      
   else                                    
                                      
   begin                                    
     select top 1 @PreviousDocumentID=DocumentID,@PreviousDate=EffectiveDate,@PreviousAuthorID=AuthorId                                
     ,@PreviousDocCodeID=DocumentCodeId from                                       
      Documents where     
      (clientID=@ClientID and               
      DocumentCodeID=@DocumentCodeId AND ISNULL(RecordDeleted,'N')='N'      
            
       AND (AuthorId = @AuthorId or -- Current clinician is an author                              
          ProxyId = @AuthorId or  -- Current clinician is a proxy                              
          AuthorId in (select ProxyForStaffId  
                                      from StaffProxies   
                                     where StaffId = @AuthorId  
                                       and isnull(RecordDeleted, 'N') = 'N') or -- Current staff is a proxy for an author  
          [Status] in (22, 23) or -- Document is in the final status: Signed or Cancelled                              
          DocumentShared = 'Y' and Status <> 20)        
             
      -- AND AuthorID=@AuthorID       
          )or(DocumentID=@DocumentID) 
          AND status <> 20      
    order by Documents.DocumentID desc   --Modified by Lakshmi on 02/01/2018     
           
                                          
   end                       
  End                                    
                                     
 END                                    
                                    
    declare @PreviousAuthorName char(51)                                
    declare @NextAuthorName char(51)                                
    declare @PreviousDocumentName char(100)                                
    declare @NextDocumentName char(100)                                
                                    
    select @PreviousAuthorName=  FirstName + ' ' +LastName     from Staff where StaffId=@PreviousAuthorID                                
    select @NextAuthorName= FirstName + ' ' + LastName    from Staff where StaffId=@NextAuthorID                                 
                                    
    select @PreviousDocumentName=DocumentName  from DocumentCodes where DocumentCodeId= @PreviousDocCodeID                                   
    select @NextDocumentName =DocumentName  from DocumentCodes where DocumentCodeId= @NextDocCodeID                                 
                                    
                                    
drop table #Temp                                    
select @PreviousDocumentID PreviousDocumentID,@PreviousDate PreviousDate,@NextDocumentID NextDocumentID,@NextDate NextDate,   @PreviousAuthorName PreviousAuthorName ,@NextAuthorName NextAuthorName,@PreviousDocumentName                                 
 PreviousDocumentName,@NextDocumentName NextDocumentName ,@PreviousDocCodeID as PreviousDocCodeID ,@NextDocCodeID as NextDocCodeID 
 
 end try                                                        
                                                                                        
BEGIN CATCH            
          
DECLARE @Error varchar(8000)                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCDocumentGetPreviousNextDate') 
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