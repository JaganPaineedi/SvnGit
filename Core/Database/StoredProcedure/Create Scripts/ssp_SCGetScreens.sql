IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCGetScreens')
	BEGIN
		DROP  Procedure  ssp_SCGetScreens
	END

GO

CREATE Procedure ssp_SCGetScreens
/******************************************************************************                                              
**  File: Shared Tables (SmartCare - Web)                                              
**  Name:                             
**  Desc:                              
**  Return values:                                              
**  Called by: [ssp_SCGetScreens]                                               
**  Parameters:                                              
**  Input    Output                           
**                        
**                        
**                                           
**  Auth:  Sonia Dhamija                      
                                     
*******************************************************************************                                              
**  Change History                                              
*******************************************************************************                                              
**  Date:       Author:    Description:                                              
**  --------  --------    ----------------------------------------------------                                              
**  21st July 2009 Sonia Dhamija  To get the screens Data in Application Shared Tables             
**  Modification Details :            
   14 July,2010 Mahesh S Rename the column name UpdateStoredProcedure to PostUpdateStoredProcedure as per changes on table            
   08 Aug, 2011 Shifali Purpose - Added column WarningStoredProcedureComplete 
 31 Oct 2011    Pradeep   Made changes to get Screens.MessageReferenceType,Screens.PrimaryKeyName     
 06 Dec 2011	Devi Dayal Add KeyPhraseCategory Column to show/hide icon of key Phrases  
  20 Mar 2012 Maninder Added ScreenParamters 
  28 March 2012  Sudhir Singh  colomn added for Warnings on Uodate ssp
  24 April 2012 Maninder Added WarningStoreProcedureUpdate  */
  /*11 May 2012 Added By Rahul Aneja Help URL Parameter */    
  /*01/02/2018 Animesh Gaurav      Added Code column to Screen #625*/
/*******************************************************************************/     
AS                                       
BEGIN                                        
BEGIN TRY                                        
                 
    SELECT [ScreenId]                  
      ,[ScreenName]                  
      ,[ScreenType]                  
      ,[ScreenURL]                  
      ,[InitializationStoredProcedure]                  
      ,ValidationStoredProcedureComplete    
      ,WarningStoredProcedureComplete        
      ,ValidationStoredProcedureUpdate          
      ,[DocumentCodeId]                 
      ,PostUpdateStoredProcedure--old column name ,UpdateStoredProcedure                 
      ,RefreshPermissionsAfterUpdate        
      ,ScreenToolbarURL         
      ,[TabId]      
      ,[CustomFieldFormId]  
      ,MessageReferenceType  
      ,PrimaryKeyName
      ,KeyPhraseCategory      
      ,ScreenParamters  
      ,WarningStoreProcedureUpdate --Added By Maninder Singh as per new requirement for Warning on Update on date 24 April 2012  
      ,ISNULL(HelpURL,'') AS 'HelpURL'
      ,ISNULL(code,'') as 'Code'  --01/02/2018 Animesh Gaurav
      from Screens                       
      where isnull(RecordDeleted,'N')<>'Y'                  
        
                        
END TRY                                          
                                        
BEGIN CATCH            
  -- RAISERROR  20006  'ssp_SCGetScreens An Error Occured'   
   RAISERROR ('ssp_SCGetScreens An Error Occured',16,1)                
   Return                
 END CATCH                                        
END 
