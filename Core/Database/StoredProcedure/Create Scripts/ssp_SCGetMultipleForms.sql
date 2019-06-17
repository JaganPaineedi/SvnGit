IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCGetMultipleForms')
	BEGIN
		DROP  Procedure  ssp_SCGetMultipleForms
	END

GO

CREATE Procedure [ssp_SCGetMultipleForms]
(

@FormId INT

)
AS
/************************************************************************************************                        
**  File:                                           
**  Name: ssp_SCGetMultipleForms                                          
**  Desc: This Store Procedure Get All The Records From FormCollections and FormCollectionFormS
**
**  Parameters: 
**  Input  	@FormId INT
**  Output     ----------       ----------- 
**  
**  Author:  Atul Pandey
**  Date:  May 29, 2012
*************************************************************************************************
**  Change History  
************************************************************************************************* 
**  Date:			Author:			Description: 
**  11 jan 2013		Rahul Aneja    Comment lines for task 111 in summit pointe.
									Foreign key constraint error occur while deleting record and
									-1 formid is generating everytime while deleting record
								    Concurrency issue while trying to save	
** 4 March 2013		Swapan Mohan	Task #87 DFA Multiform Editor: Exception message displayed(Interact Bugs/Features)
**									Added inner join on FormCollectionForms Table with FormCollections So as to filter 
**									out FormCollection's RecordDeleted data from FormCollectionForms table; As it is throwing Error when there is a 
**									record in FromCollection as RecordDeleted. 
** 12-26-2017	Rajesh		Added new column collectiontype,formcollectionname added	 EII579- DFA Detail Page
*************************************************************************************************/

BEGIN

  BEGIN TRY


--FormCollections
--IF NOT EXISTS(SELECT 1 FROM [FORMCOLLECTIONS] WHERE ISNULL(RECORDDELETED,'N')<>'Y' )
--BEGIN
--SELECT -1 AS [FormCollectionId]
       
  --    ,0 AS [NumberOfForms]
 --END
-- ELSE
-- BEGIN
SELECT [FormCollectionId]      
      ,FC.[CreatedBy]      
      ,FC.[CreatedDate]      
      ,FC.[ModifiedBy]      
      ,FC.[ModifiedDate]      
      ,FC.[RecordDeleted]      
      ,FC.[DeletedDate]      
      ,FC.[DeletedBy]      
      ,FC.[NumberOfForms]     
      ,FC.CollectionType    
      ,GC.CodeName AS CollectionName   
      ,FC.FormCollectionName   
  FROM [FormCollections] FC    
  LEFT JOIN GlobalCodes GC ON FC.CollectionType = GC.GlobalCodeId    
      
   where isnull(FC.RecordDeleted,'N')<>'Y'       
   AND isnull(GC.RecordDeleted,'N')<>'Y'   
 --END

--FormCollectionFormS
--if NOT EXISTS (SELECT 1 FROM [FormCollectionForms] fcf inner join Forms f on f.FormId=fcf.FormId ) 
--BEGIN
  --SELECT -1 AS [FormCollectionFormId]
     
     -- ,-1 AS [FormCollectionId]
    --  ,-1 AS  [FormId]
     -- ,'' AS  [Active]
     -- ,-1 AS [FormOrder]
    --  ,'' AS FormName
     
 --END
--ELSE
--BEGIN
--Modified By	:	Swapan Mohan
--Purpose		:	Task #87 DFA Multiform Editor: Exception message displayed(Interact Bugs/Features)
--Modified Date	:	4 March 2013
SELECT fcf.[FormCollectionFormId]      
      ,fcf.[CreatedBy]      
      ,fcf.[CreatedDate]      
      ,fcf.[ModifiedBy]      
      ,fcf.[ModifiedDate]      
      ,fcf.[RecordDeleted]      
      ,fcf.[DeletedDate]      
      ,fcf.[DeletedBy]      
      ,fcf.[FormCollectionId]      
      ,fcf.[FormId]      
      ,fcf.[Active]      
      ,[FormOrder]      
      ,f.FormName      
           
  FROM [FormCollectionForms] fcf       
  inner join Forms f on f.FormId=fcf.FormId       
  inner Join FormCollections FC on FC.FormCollectionId=fcf.FormCollectionId      
  where isnull(f.RecordDeleted,'N')<>'Y'       
  and isnull(fcf.RecordDeleted,'N')<>'Y'       
  and isnull(FC.RecordDeleted,'N')='N'   
 --END 
  END TRY
  
  BEGIN CATCH        
 DECLARE @Error varchar(8000)                                                       
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetMultipleForms')                                                                                     
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