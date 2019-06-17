

/****** Object:  StoredProcedure [dbo].[csp_PAGetDataForASAM]    Script Date: 05/03/2013 11:22:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAGetDataForASAM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PAGetDataForASAM]
GO


/****** Object:  StoredProcedure [dbo].[csp_PAGetDataForASAM]    Script Date: 05/03/2013 11:22:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE  [dbo].[csp_PAGetDataForASAM]                      
(                                
  @DocumentVersionId int                                 
)                                
                                
As                                
                                        
Begin                                        
/*********************************************************************/                                          
/* Stored Procedure: dbo.csp_PAGetDataForASAM                */                                 
                                
/* Copyright: 2009 Streamline Healthcare Solutions           */                                          
                                
/* Creation Date:  04 Feb 2010                                   */                                          
/*                                                                   */               
/*  Author: Jitender Kumar                                                                 */               
/*                                                                   */                                          
/* Purpose: Gets Data for ASAM Multi Tab Document      */                                         
/*                                                                   */                                        
/* Input Parameters: @DocumentVersionId*/                                        
/*                                                                   */                                           
/* Output Parameters:                                */                                          
/*                                                                   */                                          
/* Return:   */                                          
/*                                                                   */                                          
/* Called By:  Method in Documents Class Of DataService  in "Always Online Application"    */                                          
                                
                                       
                                      
 BEGIN TRY                                                     
  -----For CustomDocumentEventInformation-----
----------Added By SWAPAN MOHAN-------------
----------ADDED ON 28 dec 2012--------------
 SELECT [DocumentVersionId]
  ,[CreatedBy]
  ,[CreatedDate]
  ,[ModifiedBy]
  ,[ModifiedDate]
  ,[RecordDeleted]
  ,[DeletedDate]
  ,[DeletedBy]
  ,[EventDateTime]
  ,[InsurerId]
 FROM CustomDocumentEventInformations
 WHERE [DocumentVersionId]=@DocumentVersionId
 AND ISNULL(RecordDeleted,'N')='N'
              
 /*CustomASAMPlacements Table*/              
 SELECT [DocumentVersionId],         
  [Dimension1LevelOfCare],           
  [Dimension1Need],              
  [Dimension2LevelOfCare],              
  [Dimension2Need],                              
  [Dimension3LevelOfCare],               
  [Dimension3Need],              
  [Dimension4LevelOfCare],              
  [Dimension4Need],                 
  [Dimension5LevelOfCare],              
  [Dimension5Need],              
  [Dimension6LevelOfCare],              
  [Dimension6Need],              
  [SuggestedPlacement],              
  [FinalPlacement],              
  [FinalPlacementComment],              
  [RowIdentifier],                              
  [CreatedBy],                              
  [CreatedDate],                              
  [ModifiedBy],                              
  [ModifiedDate],                              
  [RecordDeleted],                              
  [DeletedDate],                     
  [DeletedBy],          
            
  isnull((select top 1 LevelOfCareName from CustomASAMLevelOfCares  A ,CustomASAMPlacements B             
 where  (ASAMLevelOfcareId =    Dimension1LevelOfCare or                 
 ASAMLevelOfcareId = Dimension2LevelOfCare or ASAMLevelOfcareId = Dimension3LevelOfCare ) and                 
 isnull(A.RecordDeleted,'N')='N' and isnull(B.RecordDeleted,'N')='N' and DocumentVersionId=@DocumentVersionId order by LevelNumber  desc),'')  AS SuggestedPlacementName,        
         
 (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,'N')='N'             
  and ASAMLevelOfCareId = isnull(Dimension1LevelOfCare,'') ) as Dimension1LevelOfCareName,        
  (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,'N')='N'             
  and ASAMLevelOfCareId = isnull(Dimension2LevelOfCare,'') ) as Dimension2LevelOfCareName,        
  (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,'N')='N'             
  and ASAMLevelOfCareId = isnull(Dimension3LevelOfCare,'') ) as Dimension3LevelOfCareName,        
  (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,'N')='N'             
  and ASAMLevelOfCareId = isnull(Dimension4LevelOfCare,'') ) as Dimension4LevelOfCareName,        
  (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,'N')='N'             
  and ASAMLevelOfCareId = isnull(Dimension5LevelOfCare,'') ) as Dimension5LevelOfCareName,        
  (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,'N')='N'             
  and ASAMLevelOfCareId = isnull(Dimension6LevelOfCare,'') ) as Dimension6LevelOfCareName                              
                    
 FROM [CustomASAMPlacements]                        
    WHERE ISNull(RecordDeleted,'N')='N' and DocumentVersionId=@DocumentVersionId                
                     
                         
  END TRY                              
                                
  BEGIN CATCH                                                    
  DECLARE @Error varchar(8000)                                                                                       
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                      
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_PAGetDataForASAM')                                                                                       
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
  + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())             
  RAISERROR                                                                                       
  (                                                 
  @Error, -- Message text.                                                                                       
  16, -- Severity.                                                                                       
  1 -- State.                                                                                       
  )                                    
 END CATCH                              
End 

GO


---------------------------------1-----------------------------------------------------


/****** Object:  StoredProcedure [dbo].[csp_PAGetSuggestedPlacement]    Script Date: 05/03/2013 11:28:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAGetSuggestedPlacement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PAGetSuggestedPlacement]
GO


/****** Object:  StoredProcedure [dbo].[csp_PAGetSuggestedPlacement]    Script Date: 05/03/2013 11:28:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [dbo].[csp_PAGetSuggestedPlacement]                         
(                           
  @Dimension1LevelOfCare int,  
  @Dimension2LevelOfCare int,  
  @Dimension3LevelOfCare int                               
)                              
                              
As                              
                                      
Begin                                      
/*********************************************************************/                                        
/* Stored Procedure: dbo.[csp_PAGetSuggestedPlacement]                */                               
                              
/* Copyright: 2009 Streamline Healthcare Solutions           */                                        
                              
/* Creation Date:  20 Mar 2010                                   */                                        
/*                                                                   */             
/*  Author: Jitender Kumar                                                                 */             
/*                                                                   */                                        
/* Purpose: Get Suggested Placement for ASAM Document      */                                       
/*                                                                   */                                      
/* Input Parameters: @Dimension1LevelOfCare, @Dimension2LevelOfCare, @Dimension3LevelOfCare*/                                      
/*                                                                   */                                         
/* Output Parameters:                                */                                        
/*                                                                   */                                        
/* Return:   */                                        
/*                                                                   */                                        
/* Called By:  Method in Documents Class Of DataService  in "Always Online Application"    */                                        
                              
                                     
                                    
 BEGIN TRY                                                   
             
 /*CustomASAMPlacements Table*/            
 select top 1 isnull(LevelOfCareName,'') as SuggestedPlacementName, isnull(ASAMLevelOfCareId,'') as SuggestedPlacement from CustomASAMLevelOfCares   
 where  (ASAMLevelOfcareId = @Dimension1LevelOfCare or               
 ASAMLevelOfcareId = @Dimension2LevelOfCare or ASAMLevelOfcareId = @Dimension3LevelOfCare)                       
 and ISNull(RecordDeleted,'N')='N'   
                     
  END TRY                            
                              
  BEGIN CATCH                                                  
  DECLARE @Error varchar(8000)                                                                                     
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                    
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_PAGetSuggestedPlacement')                                                                                     
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                    
  + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())           
  RAISERROR                                                                                     
  (                                               
  @Error, -- Message text.                                                                                     
  16, -- Severity.                                                                                     
  1 -- State.                                              
  )                                  
 END CATCH                            
End 

GO


---------------------------------2-----------------------------------------------------


/****** Object:  StoredProcedure [dbo].[csp_PAInitCustomASAMStandardInitialization]    Script Date: 05/03/2013 11:21:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAInitCustomASAMStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PAInitCustomASAMStandardInitialization]
GO

/****** Object:  StoredProcedure [dbo].[csp_PAInitCustomASAMStandardInitialization]    Script Date: 05/03/2013 11:21:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_PAInitCustomASAMStandardInitialization]
    (
      @ClientID INT ,
      @StaffID INT ,
      @CustomParameters XML                                                  
    )
AS
/***********************************************************************/                                                                                    
/* Stored Procedure: [csp_PAInitCustomASAMStandardInitialization]		*/                                                                           

/* Copyright: 2006 Streamline SmartCare									*/                                                                                    
                                                                           
/* Creation Date:  11/Feb/2010											*/                                                                                    
/*																		*/                                                                                    
/* Purpose: To Initialize												*/                                                                                   
/*																		*/                                                                                  
/* Input Parameters:													*/                                                                                  
/*																		*/                                                                                     
/* Output Parameters:													*/                                                                                    
/*																		*/                                                                                    
/* Return:																*/                                                                                    
/*																		*/                                                                                    
/* Called By:CustomDocuments Class Of DataService						*/                                                                          
/*																		*/                                                                                    
/* Calls:																*/                                                                                    
/*																		*/                                                                                    
/* Data Modifications:													*/                                                                                    
/*																		*/                                                                                    
/*   Updates:															*/                                                                                    
                                                                           
/*       Date              Author                   Purpose				*/                                                                                    
/* Priya Modified  so that it does not pull forward any detail from the previous ASAM*/
/*	Aug 22 2011			RJN					Rewritten to not use systemConfigurations table.*/
/************************************************************************/                                    
                 
BEGIN
-----For CustomDocumentEventInformation-----
----------Added By SWAPAN MOHAN-------------
----------ADDED ON 28 dec 2012--------------
    --DECLARE @LatestDocumentVersionID int,@LatestAdmissionDocumentVersionID int   
    DECLARE @DocumentVersionId INT
    SELECT  @DocumentVersionId = 0             
    --set @LatestDocumentVersionID=(  Select top 1 DocumentVersionId 
    --                                from CustomASAMPlacements C,Documents D                                 
    --                                where C.DocumentVersionId=D.CurrentDocumentVersionId 
    --                                and D.ClientId=@ClientID                                                                
    --                                and D.Status=22 
    --                                and IsNull(C.RecordDeleted,'N')='N' 
    --                                and IsNull(D.RecordDeleted,'N')='N' 
    --                                order by D.EffectiveDate desc,D.ModifiedDate desc)

    SELECT Placeholder.TableName
    ,ISNULL(CDEI.[DocumentVersionId],-1) AS 'DocumentVersionId'
    ,CDEI.[CreatedBy]
    ,CDEI.[CreatedDate]
    ,CDEI.[ModifiedBy]
    ,CDEI.[ModifiedDate]
    ,CDEI.[RecordDeleted]
    ,CDEI.[DeletedDate]
    ,CDEI.[DeletedBy]
    ,CDEI.[EventDateTime]
    ,CDEI.[InsurerId]
    FROM (SELECT 'CustomDocumentEventInformations' AS TableName) AS Placeholder  
    LEFT JOIN DocumentVersions DV ON (DV.DocumentVersionId = @DocumentVersionId AND ISNULL(DV.RecordDeleted,'N')='N')
    LEFT JOIN CustomDocumentEventInformations CDEI ON (DV.DocumentVersionId = CDEI.DocumentVersionId AND ISNULL(CDEI.RecordDeleted,'N')='N') 
    
    SELECT  Placeholder.TableName ,
        ISNULL(a.DocumentVersionId, -1) AS DocumentVersionId,
        b.Dimension1LevelOfCare ,
        b.Dimension1Need ,
        b.Dimension2LevelOfCare ,
        b.Dimension2Need ,
        b.Dimension3LevelOfCare ,
        b.Dimension3Need ,
        b.Dimension4LevelOfCare ,
        b.Dimension4Need ,
        b.Dimension5LevelOfCare ,
        b.Dimension5Need ,
        b.Dimension6LevelOfCare ,
        b.Dimension6Need ,
        b.SuggestedPlacement ,
        b.FinalPlacement ,
        b.FinalPlacementComment ,
        b.RowIdentifier ,
        b.RecordDeleted ,
        b.DeletedDate ,
        b.DeletedBy
    FROM (SELECT 'CustomASAMPlacements' AS TableName) AS Placeholder
    LEFT JOIN documentversions a ON (a.DocumentVersionId = @DocumentVersionId AND ISNULL(a.RecordDeleted,'N') <> 'Y')
    LEFT JOIN dbo.CustomASAMPlacements b ON ( a.DocumentVersionId = b.DocumentVersionId AND ISNULL(b.RecordDeleted,'N') <> 'Y')
END 


GO


---------------------------------3-----------------------------------------------------



/****** Object:  StoredProcedure [dbo].[csp_PAValidateCustomASAMPlacements]    Script Date: 05/03/2013 11:23:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAValidateCustomASAMPlacements]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PAValidateCustomASAMPlacements]
GO



/****** Object:  StoredProcedure [dbo].[csp_PAValidateCustomASAMPlacements]    Script Date: 05/03/2013 11:23:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


      
CREATE PROCEDURE [dbo].[csp_PAValidateCustomASAMPlacements]               
@DocumentVersionId INT       
as               
/******************************************************************************                                      
**  File: csp_PAValidateCustomASAMPlacements                                  
**  Name: csp_PAValidateCustomASAMPlacements              
**  Desc: For Validation  on CustomASAMPlacements document(For Prototype purpose, Need modification)              
**  Return values: Resultset having validation messages                                      
**  Called by:                                       
**  Parameters:                  
**  Auth:  Jitender Kumar Kamboj                    
**  Date:  March 12 2010                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date         Author             Description
	08/29/2011   Sonia Dhamija      Add the validation On CustomASAMPlacements for Dimensions field
	01/Sept/2011   Shifali			amendments for 'Note' text with TabName and Insertion of PageIndex field                                       
    *******************************************************************************/                                    
      
BEGIN                                                    
          
	 BEGIN TRY      
		 --*TABLE CREATE*--               
		CREATE TABLE #CustomASAMPlacements (                
		DocumentVersionId INT,              
		Dimension1LevelOfCare INT,                 
		Dimension2LevelOfCare INT,  
		Dimension3LevelOfCare INT,  
		Dimension4LevelOfCare INT,  
		Dimension5LevelOfCare INT,  
		Dimension6LevelOfCare INT  
		    
		)                 
		--*INSERT LIST*--               
		INSERT INTO #CustomASAMPlacements (                
		DocumentVersionId,                 
		Dimension1LevelOfCare,                 
		Dimension2LevelOfCare,  
		Dimension3LevelOfCare,  
		Dimension4LevelOfCare,  
		Dimension5LevelOfCare,  
		Dimension6LevelOfCare              
		)                 
		--*Select LIST*--               
		SELECT DocumentVersionId,                 
		Dimension1LevelOfCare,                 
		Dimension2LevelOfCare,  
		Dimension3LevelOfCare,  
		Dimension4LevelOfCare,  
		Dimension5LevelOfCare,  
		Dimension6LevelOfCare                  
		FROM CustomASAMPlacements WHERE DocumentVersionId = @DocumentVersionId                
		               
		               
		INSERT INTO #validationReturnTable (  TableName, ColumnName, ErrorMessage,PageIndex )                
		SELECT 'CustomASAMPlacements', 'Dimension1LevelOfCare', 'ASAM One - Please choose any one level from Dimension1.',0 FROM #CustomASAMPlacements WHERE isnull(Dimension1LevelOfCare,'')=''                
		UNION              
		SELECT 'CustomASAMPlacements', 'Dimension2LevelOfCare', 'ASAM One - Please choose any one level from Dimension2.',0 FROM #CustomASAMPlacements WHERE isnull(Dimension2LevelOfCare,'')=''     
		UNION              
		SELECT 'CustomASAMPlacements', 'Dimension3LevelOfCare', 'ASAM Two - Please choose any one level from Dimension3.',1 FROM #CustomASAMPlacements WHERE isnull(Dimension3LevelOfCare,'')=''     
		UNION              
		SELECT 'CustomASAMPlacements', 'Dimension4LevelOfCare', 'ASAM Two - Please choose any one level from Dimension4.',1 FROM #CustomASAMPlacements WHERE isnull(Dimension4LevelOfCare,'')=''     
		UNION              
		SELECT 'CustomASAMPlacements', 'Dimension5LevelOfCare', 'ASAM Three - Please choose any one level from Dimension5.',2 FROM #CustomASAMPlacements WHERE isnull(Dimension5LevelOfCare,'')=''     
		UNION              
		SELECT 'CustomASAMPlacements', 'Dimension6LevelOfCare', 'ASAM Three - Please choose any one level from Dimension6.',2 FROM #CustomASAMPlacements WHERE isnull(Dimension6LevelOfCare,'')=''     
		    
	END TRY                                                                                      
	BEGIN CATCH        
		DECLARE @Error varchar(8000)                                                     
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
			+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_PAValidateCustomASAMPlacements')                                                                                   
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

GO


---------------------------------4-----------------------------------------------------



/****** Object:  StoredProcedure [dbo].[csp_RDLPAASAM]    Script Date: 05/03/2013 11:24:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLPAASAM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLPAASAM]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLPAASAM]    Script Date: 05/03/2013 11:24:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[csp_RDLPAASAM]           
 --@EventId int     -- Modified by  Jitender on 11 Oct 2010           
 @DocumentVersionId int                        
AS          
/********************************************************************  */                          
/* Stored Procedure: dbo.csp_RDLPAASAM      */                          
/* Copyright: 2007 Provider Access Application        */                          
/* Creation Date:  16th-Nov-2007            */                          
/*                   */                          
/* Purpose: This is the Retrieve Stored Procedure and is used for Report of ASAM Wizard */                         
/*                    */                        
/* Input Parameters: @DocumentVersionId */                          
/* Output Parameters:              */                          
/*                   */                          
/* Return:                 */                          
/*                      */                          
/* Called By:                */                          
/*                      */                          
/* Calls:                    */                          
/*                      */                          
/* Data Modifications:                                                      */                          
/*                      */                          
/*  Updates:                   */                          
/*  Date     Author     Purpose                      */                          
/*  16th-Nov-2007     Pratap Singh    Retrive Values for ASAM Wizard Report */                         
/*  3rd-Dec-2007     Ankesh Bharti    Retrive Value for FinalPlacement field instead of their Id's */           
/*  25th-Dec-2007    Ankesh Bharti    To add select statement for fetching eventid,eventname */             
/*  11-Oct-2010      Jitender Kumar Kamboj      Changed table names from EventASAM, ASAMLevelOfCares          
 11-Oct-2010      Jitender Kumar Kamboj   Commented one select statement and Added joining with Documents, DocumentVersions, Events, Clients tables to fetch records in one query only          
 11-Oct-2010      Jitender Kumar Kamboj   and Added @DocumentVersionId parameter           
*/             
/****************************************************************************/          
BEGIN TRY          
 BEGIN          
          
 SELECT  CAP.DocumentVersionId, (select LevelOfCareName from CustomASAMLevelOfCares where isnull(RecordDeleted,'N')='N'           
 and ASAMLevelOfCareId = isnull(Dimension1LevelOfCare,0) )as Dimension1LevelOfCare ,Dimension1Need ,               
 (select LevelOfCareName from CustomASAMLevelOfCares where isnull(RecordDeleted,'N')='N' and ASAMLevelOfCareId =               
 isnull(Dimension2LevelOfCare,0)) as Dimension2LevelOfCare , Dimension2Need ,             
 (select LevelOfCareName from CustomASAMLevelOfCares where isnull(RecordDeleted,'N')='N' and ASAMLevelOfCareId =               
 isnull(Dimension3LevelOfCare,0)) as Dimension3LevelOfCare ,  Dimension3Need ,             
 (select LevelOfCareName from CustomASAMLevelOfCares where isnull(RecordDeleted,'N')='N' and ASAMLevelOfCareId =               
 isnull(Dimension4LevelOfCare,0)) as Dimension4LevelOfCare ,   Dimension4Need ,             
 (select LevelOfCareName from CustomASAMLevelOfCares where isnull(RecordDeleted,'N')='N' and ASAMLevelOfCareId =              
 isnull(Dimension5LevelOfCare,0)) as Dimension5LevelOfCare , Dimension5Need ,            
 (select LevelOfCareName from CustomASAMLevelOfCares where isnull(RecordDeleted,'N')='N' and ASAMLevelOfCareId =           
    isnull(Dimension6LevelOfCare,0)) as Dimension6LevelOfCare  ,Dimension6Need ,          
    dbo.csf_GetGlobalCodeNameById(CAP.[FinalPlacement]) as FinalPlacement,FinalPlacementComment,          
 isnull((select top 1 LevelOfCareName from CustomASAMLevelOfCares A, CustomASAMPlacements B where (ASAMLevelOfcareId =          
 Dimension1LevelOfCare or ASAMLevelOfcareId = Dimension2LevelOfCare or ASAMLevelOfcareId = Dimension3LevelOfCare)          
 and isnull(A.RecordDeleted,'N')='N' and isnull(B.RecordDeleted,'N')='N'  and  DocumentVersionId=@DocumentVersionId           
 order by LevelNumber desc),'') AS SuggestedPlacement,        
 D.ClientID,(clt.LastName +', '+ clt.FirstName)as ClientName,  -- Added by Jitender          
 Convert(varchar(10),D.EffectiveDate,101) as EffectiveDate     
 --(Convert(varchar,EventDateTime,101)+' '+RIGHT(CONVERT(varchar,EventDateTime,100),8)) as EventDateTime            
 --FROM EventASAM           
 FROM CustomASAMPlacements CAP        
  --Added by Jitender on 11 Oct 2010          
 inner join DocumentVersions dv on dv.DocumentVersionId = CAP.DocumentVersionId          
 join Documents D on D.DocumentId = dv.DocumentId          
 --join Events evt on evt.EventId=D.EventId          
 join Clients clt on clt.ClientId=D.ClientId           
 --End--          
 --WHERE isnull(RecordDeleted,'N')='N' and EventId=@EventId           
 WHERE CAP.DocumentVersionId=@DocumentVersionId           
 and ISNULL(CAP.RecordDeleted,'N')='N'           
 and ISNULL(D.RecordDeleted,'N')='N'          
 and ISNULL(dv.RecordDeleted,'N')='N'          
           
          
 --- ***********************************************************************************************************          
 --SELECT           
 ----- Common Step to fetch ClientID,ClientName,EventDateTime          
 --evt.ClientID,(LastName+', '+FirstName)as ClientName,          
 --(Convert(varchar,EventDateTime,101)+' '+RIGHT(CONVERT(varchar,EventDateTime,100),8)) as EventDateTime          
 --FROM Events evt          
 --inner join Clients clt on clt.clientid=evt.clientid          
 --WHERE EventId = @EventId and ISNULL(evt.RecordDeleted,'N')='N'            
          
END          
END TRY          
          
BEGIN CATCH                          
 declare @Error varchar(8000)                          
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                           
 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLPAASAM')                           
 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                            
 + '*****' + Convert(varchar,ERROR_STATE())                     
                    
 RAISERROR                           
 (                          
  @Error, -- Message text.                          
  16, -- Severity.                          
  1 -- State.                          
 );                          
                            
END CATCH   

GO


---------------------------------5-----------------------------------------------------



/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportInteractSCEventDetail]    Script Date: 05/03/2013 11:27:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportInteractSCEventDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportInteractSCEventDetail]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportInteractSCEventDetail]    Script Date: 05/03/2013 11:27:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[csp_RDLSubReportInteractSCEventDetail]
(
    @DocumentVersionId int 
)
/**************************************************************************************/                              
/*  Stored Procedure: csp_RDLSubReportInteractSCEventDetail                                */                       
/*  Creation Date:  3 Jan 2013                                                        */                                     
/*  Purpose:    To retrieve Event detail data                                      */                                    
/*  Input Parameters: @DocumentVersionId                                              */                               
/*  Updates:                                                                          */
/*  Date            :   03/Jan/2013                                                   */
/*  Author          :   SWAPAN MOHAN                                                  */ 
/*  Purpose         :   Created                                                       */
/*  Description     :                                                                 */
/**************************************************************************************/   
AS
BEGIN
    BEGIN TRY
		SELECT 
			CDEI.DocumentVersionId,
			--CONVERT(varchar(12),CDEI.EventDateTime,110) AS 'EventDate',            
			CDEI.EventDateTime AS 'EventDate', 
			CDEI.EventDateTime AS 'EventTime',
			CDEI.InsurerId,
			GC.CodeName AS 'InsurerName'	
		FROM CustomDocumentEventInformations CDEI
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId=CDEI.InsurerId
		INNER JOIN DocumentVersions DV ON DV.DocumentVersionId=CDEI.DocumentVersionId
		WHERE CDEI.DocumentVersionId=@DocumentVersionId
    END TRY
    BEGIN CATCH
        declare @Error varchar(8000)                            
		set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                             
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLSubReportInteractSCEventDetail')                             
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                              
		+ '*****' + Convert(varchar,ERROR_STATE())                                                   
		RAISERROR(@Error,16,1); 
    END CATCH
END


GO


---------------------------------6-----------------------------------------------------


/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportSCDocumentFooter]    Script Date: 05/03/2013 11:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportSCDocumentFooter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportSCDocumentFooter]
GO


/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportSCDocumentFooter]    Script Date: 05/03/2013 11:27:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE  [dbo].[csp_RdlSubReportSCDocumentFooter]   
(
	@DocumentVersionId  int                                     
) 
/**************************************************************************************/                              
/*  Stored Procedure: csp_RdlSubReportSCDocumentFooter                                */                       
/*  Creation Date:  3 Jan 2013                                                        */                                     
/*  Purpose:    To retrieve Document Footer data                                      */                                    
/*  Input Parameters: @DocumentVersionId                                              */                               
/*  Updates:                                                                          */
/*  Date            :   03/Jan/2013                                                   */
/*  Author          :   SWAPAN MOHAN                                                  */ 
/*  Purpose         :   Created                                                       */
/*  Description     :                                                                 */
/**************************************************************************************/                                          
AS
BEGIN
	BEGIN TRY
		select 
		    d.DocumentId,
		    ds.SignatureId,
		    dv.Version,
		    ds.SignerName,
		    ds.PhysicalSignature,
		    ds.SignatureDate
		from Documents as d
		join documentVersions as dv on dv.DocumentId = d.DocumentId 
		    and isnull(dv.RecordDeleted,'N')<>'Y'  
		join documentSignatures as ds on ds.DocumentId = d.DocumentId 
		    and isnull(ds.RecordDeleted,'N')<>'Y'
		where dv.DocumentVersionId = @DocumentVersionId
		and isnull(d.RecordDeleted,'N')<>'Y'
		and d.Status=22
		Order by ds.SignatureOrder
	END TRY
	BEGIN CATCH
		declare @Error varchar(8000)                            
		set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                             
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RdlSubReportSCDocumentFooter')                             
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                              
		+ '*****' + Convert(varchar,ERROR_STATE())                                                   
		RAISERROR(@Error,16,1); 
    END CATCH
END


GO


---------------------------------7-----------------------------------------------------


/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportSCDocumentHeader]    Script Date: 05/03/2013 11:25:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportSCDocumentHeader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportSCDocumentHeader]
GO


/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportSCDocumentHeader]    Script Date: 05/03/2013 11:25:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_RdlSubReportSCDocumentHeader]    
(            
    @DocumentVersionId int
)
/**************************************************************************************/                              
/*  Stored Procedure: csp_RdlSubReportSCDocumentHeader                                */                       
/*  Creation Date:  3 Jan 2013                                                        */                                     
/*  Purpose:    To retrieve Document Header data                                      */                                    
/*  Input Parameters: @DocumentVersionId                                              */                               
/*  Updates:                                                                          */
/*  Date            :   03/Jan/2013                                                   */
/*  Author          :   SWAPAN MOHAN                                                  */ 
/*  Purpose         :   Created                                                       */
/*  Description     :                                                                 */
/**************************************************************************************/                          
AS  
BEGIN               
    BEGIN TRY
        SELECT 
            top 1 DC.DocumentName,
            Doc.DocumentId,              
            (select OrganizationName from SystemConfigurations ) as OrganizationName,              
            ISNULL(client.FirstName, '') + ' ' + ISNULL(client.LastName, '') AS ClientName,
            client.ClientId as ClientId,  
            --isnull(pc.MasterClientId,Clients.ClientId) as ClientId,    
            GC.CodeName AS Status,               
            ISNULL(st.FirstName, '') + ' ' + ISNULL(st.LastName, '') AS StaffName,               
            CONVERT(varchar(12),Doc.EffectiveDate,101) as EffectiveDate,            
            --RIGHT(CONVERT(VARCHAR,Doc.EffectiveDate, 100),7) as EffectiveTime
            Doc.EffectiveDate  as EffectiveTime
        FROM  Documents Doc             
        INNER JOIN Clients client ON Doc.ClientId = client.ClientId             
        Inner join DocumentCodes DC on DC.DocumentCodeid= Doc.DocumentCodeId                
        INNER JOIN Staff st ON Doc.AuthorId = st.StaffId               
        INNER JOIN DocumentVersions DV ON Doc.DocumentId=DV.DocumentId
        INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = Doc.[Status]
        Where DV.DocumentVersionId = @DocumentVersionID
        AND ISNULL(Doc.RecordDeleted,'N')='N'
        AND ISNULL(client.RecordDeleted,'N')='N'
        AND ISNULL(DC.RecordDeleted,'N')='N'
        AND ISNULL(st.RecordDeleted,'N')='N'
        AND ISNULL(DV.RecordDeleted,'N')='N'
        AND ISNULL(GC.RecordDeleted,'N')='N'
    END TRY
    BEGIN CATCH
		declare @Error varchar(8000)                            
		set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                             
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RdlSubReportSCDocumentHeader')                             
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                              
		+ '*****' + Convert(varchar,ERROR_STATE())                                                   
		RAISERROR(@Error,16,1); 
    END CATCH
END


GO


---------------------------------8-----------------------------------------------------


/****** Object:  StoredProcedure [dbo].[ssp_SCGetCustomASAMLevelOfCares]    Script Date: 05/06/2013 09:29:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCustomASAMLevelOfCares]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetCustomASAMLevelOfCares]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetCustomASAMLevelOfCares]    Script Date: 05/06/2013 09:29:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE  [dbo].[ssp_SCGetCustomASAMLevelOfCares]                     
As                               
Begin                              
/*********************************************************************/                                
/* Stored Procedure: dbo.ssp_SCGetCustomASAMLevelOfCares                */                       
                      
/* Copyright: 2005 SmartCare Always online             */                                
                      
/* Creation Date:  23/02/2010                                    */                                
/*                                                                   */                                
/* Purpose: Get data from CustomASAMLevelOfCares          */                               
/*                                                                   */                              
/* Input Parameters:      */                              
/*                                                                   */                                 
/* Output Parameters:                                    */                                
/*                                                                   */                                
/* Return:   */                                
/*                                                                   */                                
/* Called By:         */                    
/*                                                                   */                                
/* Calls:                                                            */                                
/*                                                                   */                                
/* Data Modifications:                                               */                                
/*                                                                   */                                
/*   Updates:                                                          */                                
                      
/*       Date              Author- Jitender                  Purpose -                                   */                                
/*          */                    
/*********************************************************************/                                 
 --IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCGetCustomASAMLevelOfCares]') AND type in (N'P', N'PC'))
 --begin
 --exec scsp_SCGetCustomASAMLevelOfCares
 --end
 --else
 --begin                           
 SELECT ASAMLevelOfCareId, LevelOfCareName, Dimension1Description, Dimension2Description, Dimension3Description, Dimension4Description,             
        Dimension5Description, Dimension6Description  FROM  CustomASAMLevelOfCares where ISNULL(RecordDeleted,'N')='N'                 
 --end                   
    --Checking For Errors                      
    If (@@error!=0)                      
     Begin                      
      RAISERROR  20006   'ssp_SCGetCustomASAMLevelOfCares: An Error Occured'                       
     Return                      
     End                           
                         
                         
                      
End


GO



---------------------------------9-----------------------------------------------------
