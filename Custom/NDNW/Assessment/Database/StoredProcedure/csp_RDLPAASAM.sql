/****** Object:  StoredProcedure [dbo].[csp_RDLPAASAM]    Script Date: 02/11/2015 15:10:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLPAASAM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLPAASAM]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLPAASAM]    Script Date: 02/11/2015 15:10:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
        
           
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
           
/****************************************************************************/                                             
          
CREATE Procedure [dbo].[csp_RDLPAASAM]           
 --@EventId int     -- Modified by  Jitender on 11 Oct 2010           
 @DocumentVersionId int                        
AS          
          
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
    (Select LevelOfCareName from CustomASAMLevelOfCares where isnull(RecordDeleted,'N')='N' and ASAMLevelOfCareId =          
    isnull(FinalPlacement,0)) as FinalPlacement,FinalPlacementComment,          
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


