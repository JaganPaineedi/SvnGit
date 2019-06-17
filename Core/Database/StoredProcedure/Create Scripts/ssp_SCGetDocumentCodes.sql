IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDocumentCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDocumentCodes]
GO

CREATE PROCEDURE  [dbo].[ssp_SCGetDocumentCodes]                              
                              
As                            
Begin                                      
/*********************************************************************/                                        
/* Stored Procedure: dbo.ssp_SCGetDocumentCodes                */                               
                              
/* Copyright: 2005 Provider Claim Management System             */                                        
                              
/* Creation Date:  23/10/2006                                    */                                        
/*                                                                   */                                        
/* Purpose: Returns the Details for Document Codes     */                                       
/*                                                                   */                                      
/* Input Parameters: */                                      
/*                                                                   */                                         
/* Output Parameters:                                */                                        
/*                                                                   */                                        
/* Return:   */                                        
/*                                                                   */                                        
/* Called By: DocumentCodes.cs    */                                        
/*                                                                   */                                        
/* Calls:                                                            */                                        
/*                                                                   */                                        
/* Data Modifications:                                               */                                        
/*                                                                   */                                        
/*   Updates:                                                        */                                        
                              
/*       Date           Author             Purpose                 */                                        
/* 23/10/2006      Kaushal Rathore         Created                         
/* 6/04/2009        Sonia Dhamija          Modified                 */                                        
/* Ref Task #691 SmartCare EHR - Customization*/                    
/* 08/06/2009  Ankesh Bharti   Modified */                    
/* Ref Task #3758 adding field (Table List) in select query */                    
/* 27Feb2010      Vikas Monga  Add new column "StoredProcedure" */                  
/* 18 March 2010  Vikas Vyas   Add New Column IsEvent as well perform join with EventType table" */                  
/* March 23,2010  Sahil Bhagat Join with screen table to get screenId and screenType in ref of Task #11.   */        
/* May 06 2011 Rahul Aneja Add the Column MetaDataId to get the Metadata Tab*/                                
/* Aug27 2011 Added Column RequiresLicensedSignature*/       
/* Oct 31 2011 Added By Rohit Katoch , New Columns FormCollectionid */    
/* 30 Nov 2011	Modified	Added two columns "AllowEditingByNonAuthors","EnableEditValidationStoredProcedure"	*/
/* Jan 5 2012 Added By Maninder column NewValidationStoredProcedure */ 
/* 23 jan 2012 Modified By Karan Added one column "MultipleCredentials" */
/* 28May2012  Modified	Shifali		Added one column RecreatePDFOnClientSignature */
/* 10/24/2013  John Sudhakar Added functionality to set SignatureDate as EffectiveDate when a flag in DocumentCodes table is set.*/
/* 2/7/2014    Shruthi.S     Added recordeleted check for screens table.#806 St.Joe-Support.*/
/*25-Feb-2013 Deej Included RegenerateRDLOnCoSignature on select statement*/
/*26-Feb-2013 Deej Included OnlyAvailableOnline on select statement*/
   09/22/2014  Venkatesh MR		  Added CoSignerRDL column for Task 78 in Engineering Improvement Initiatives
   10/10/2014  Anto Added ShareDocumentOnSave column for Task 131 in Engineering Improvement Initiatives
   09/03/2015  Bernadin         Added "DiagnosisDocument" Column for Certification 2014 Task# 68
   11-Jan-2016 Deej  Added DSMV column in the select query.
   09/13/2016  Nandita		      Added mobile column to DocumentCodes table
   14/Feb/2017 Arjun K R          Added AllowClientPortalUserAsAuthor column to DocumentCodes table.
      08/30/2017  Pabitra            Added ClientOrder column to DocumentCodes Texas Customizations #104
      01/02/2018 Animesh Gaurav      Added Code column to DocumentCodes #625      
    18- May - 2018  Sachin      What : Added new column AllowVersionAuthorToSign to fetch the column value AllowVersionAuthorToSign='Y' .
                                Why  : Bradford - Support Go Live #632
/*********************************************************************/   */                                      
                                    
                              
  Select dc.DocumentCodeID,ISNULL(s.ScreenId,0) as ScreenId,ISNULL(s.ScreenType,0) as ScreenType, DocumentName,DocumentDescription,DocumentType,isnull(OnlyAvailableOnline,'N') as OnlyAvailableOnline  ,Active,RequiresSignature,isnull(ServiceNote,'N')      
 
  as ServiceNote,ViewDocumentUrl,DocumentUrl,ToBeInitialized,TableList,StoredProcedure,InitializationProcess,ISNULL(MetadataFormId,0) as MetadataFormId,  ISNULL(ReviewFormId,0) as ReviewFormId,   
    
  CASE WHEN et.EventTypeId Is null   THEN 'N'                
 else 'Y'                
END                
as IsEvent,RequiresLicensedSignature ,FormCollectionid  ,       
  
ISNULL(AllowEditingByNonAuthors,'N') as AllowEditingByNonAuthors, EnableEditValidationStoredProcedure ,
NewValidationStoredProcedure        ,ISNULL(MultipleCredentials,'N') as MultipleCredentials
,RecreatePDFOnClientSignature, dc.SignatureDateAsEffectiveDate   as SignatureDateAsEffectiveDate,
dc.CreatedBy, dc.CreatedDate, dc.ModifiedBy, dc.ModifiedDate,dc.RegenerateRDLOnCoSignature,dc.OnlyAvailableOnline
,dc.CoSignerRDL --Added with ref task 78 in Engineering Improvement Initiatives
,dc.ShareDocumentOnSave
,dc.DiagnosisDocument
,dc.DSMV
,dc.Mobile
 ,dc.AllowClientPortalUserAsAuthor  --14/Feb/2017 Arjun K R
  ,ClientOrder -- 22/06/2017  Pabitra 
  , dc.Code --01/02/2018 Animesh Gaurav
  ,dc.AllowVersionAuthorToSign -- Added By Sachin 18-May-2018
from  DocumentCodes dc                 
left join EventTypes et on et.AssociatedDocumentCodeId=dc.DocumentCodeId   left join Screens s on dc.documentCodeId = s.documentCodeId               
 and Isnull(et.RecordDeleted,'N')<>'Y'                
where       
--Active='Y' and       
 isNull(dc.RecordDeleted,'N')<>'Y'     
and isNull(s.RecordDeleted,'N')<>'Y'               
              
            
                  
                
                
               
                 
                 
                  
                              
  --Checking For Errors                              
  If (@@error!=0)                              
  Begin                              
   RAISERROR ('ssp_SCGetDocumentCodes: An Error Occured',16,1);                             
   Return                              
   End                
                                      
                              
End 
