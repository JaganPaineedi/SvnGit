/****** Object:  StoredProcedure [dbo].[csp_PAInitCustomASAMStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAInitCustomASAMStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PAInitCustomASAMStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAInitCustomASAMStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


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
    --                                and IsNull(C.RecordDeleted,''N'')=''N'' 
    --                                and IsNull(D.RecordDeleted,''N'')=''N'' 
    --                                order by D.EffectiveDate desc,D.ModifiedDate desc)

    SELECT Placeholder.TableName
    ,ISNULL(CDEI.[DocumentVersionId],-1) AS ''DocumentVersionId''
    ,CDEI.[CreatedBy]
    ,CDEI.[CreatedDate]
    ,CDEI.[ModifiedBy]
    ,CDEI.[ModifiedDate]
    ,CDEI.[RecordDeleted]
    ,CDEI.[DeletedDate]
    ,CDEI.[DeletedBy]
    ,CDEI.[EventDateTime]
    ,CDEI.[InsurerId]
    FROM (SELECT ''CustomDocumentEventInformations'' AS TableName) AS Placeholder  
    LEFT JOIN DocumentVersions DV ON (DV.DocumentVersionId = @DocumentVersionId AND ISNULL(DV.RecordDeleted,''N'')=''N'')
    LEFT JOIN CustomDocumentEventInformations CDEI ON (DV.DocumentVersionId = CDEI.DocumentVersionId AND ISNULL(CDEI.RecordDeleted,''N'')=''N'') 
    
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
    FROM (SELECT ''CustomASAMPlacements'' AS TableName) AS Placeholder
    LEFT JOIN documentversions a ON (a.DocumentVersionId = @DocumentVersionId AND ISNULL(a.RecordDeleted,''N'') <> ''Y'')
    LEFT JOIN dbo.CustomASAMPlacements b ON ( a.DocumentVersionId = b.DocumentVersionId AND ISNULL(b.RecordDeleted,''N'') <> ''Y'')
END 


' 
END
GO
