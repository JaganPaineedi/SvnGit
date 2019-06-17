
/****** Object:  StoredProcedure [dbo].[ssp_RdlCarePlanDates]    Script Date: 03/15/2017 18:11:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RdlCarePlanDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RdlCarePlanDates]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RdlCarePlanDates]    Script Date: 03/15/2017 18:11:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
                          
CREATE PROCEDURE [dbo].[ssp_RdlCarePlanDates] --1373483 
 (  
  @DocumentVersionId INT  
 )   
  /*************************************************************************************************************************/                                                            
/* Stored Procedure: ssp_RdlCarePlanDates                                                         */                                                   
/*                                                                      */                                                            
/* Creation Date:  4Jan2011                                                             */                                                            
/*                                                                   */                                                            
/* Purpose: Gets Data for ssp_RdlCarePlanDates                                                        */                                                           
/* Input Parameters: DocumentVersionId                                                          */                                                          
/* Output Parameters:                                                              */                                                            
/* Purpose: Use For Rdl Report                                                            */                                                  
/* Calls:                                                                 */                                                            
/*                                                                   */                                                            
/* Author: Rohit Katoch                                                              */  
/* Date   Author    Purpose                                                                */  
/* 27Jan2012 Vikas Kashyap      Change Date Formate BeginDate,End Date                                               */   
/* 8/22/2012    Jeff Riley   Changed End Date to be Effective Date + 6 Months                                     */  
/* 03/22/2013 Gayathri Naik  Added case to return the CarePlanType column                                         */  
/* 19/04/2013   Bernardin           CarePlan End date should be always 6 month difference                                 */  
/* 4/24/2013    Jeff Riley          End date should not be pushed out 6 months if it is an addendum                       */  
/* 04/30/2013   Bernardin           End date should be original care plan if it is an addendum                            */  
/* 2013.05.03 Joe Neylon   Removed @ClientId parameter                                                         */  
/* 2014.02.25 John Pinkster  The sub query logic wasn't correct. Pulled it out to a JOIN and it is working again.   */  
  
/* 26 Dec 2014  Aravind             Modified As part for Core CarePlan  Module- Task #915 -Ability to CRUD Treatment Plans  
                Valley - Customizations                                                                */  
/* 2016.05.11    Veena S Mani       Review changes Valley Support Go live #390               */  
/*01 July 2016 Vithobha   Added @ScreenName to get the screen name dynamically instead of hard code, Bradford - Support Go Live: #134  */  
/*16 Mar  2017 Pradeep Y  Introduce Configuration key for Tx Plan End Date As part of task #340 Pathway - Support Go Live                                                                                                      */

/*06 Sept 2017 Vandana Ojha  Added logic for End date hide/show on PDF Valley-Enhancements #390.4                                                                                                  */
/*07 Sep 2018  Vijeta Sinha  Modified the logic to update the end date for Addendum Treatment Plan,	Task:Spring River-Support Go Live #298   */
/*13 DEC 2018  Sanjay Patra  Added scsp to customize the TreatmentPlanEndDate ,	Task:Porter Starke-Implementation#16   */
/*******************************************************************************************************************************/   
AS  
BEGIN   
--Declare @EffectiveDate AS Date        
BEGIN  TRY  

--16 Mar  2017 Pradeep Y
DECLARE @TreatmentPlanEndDate int
Select @TreatmentPlanEndDate= Cast(Value As int) from SystemConfigurationKeys
where [Key]='SetDurationForCoreCarePlanEndDate'
  
DECLARE @ClientId INT   
DECLARE @ScreenName varchar(100)  
Select @ScreenName=Screenname From Screens Where ScreenId=1077    
Print @ScreenName
  
SELECT @ClientId = d.ClientId  
FROM DocumentVersions dv  
JOIN Documents d ON d.DocumentId = dv.DocumentId  
WHERE dv.DocumentVersionId = @DocumentVersionId   
  
--SELECT TOP 1 @EffectiveDate=DC.EffectiveDate    
--FROM [DocumentCarePlans] CSLD   
--INNER JOIN Documents DC ON DC.CurrentDocumentVersionId=CSLD.[DocumentVersionId]  
--WHERE [Status]=22 AND  (CSLD.CarePlanType='IN' OR CSLD.CarePlanType='AN')   
--AND ISNull(CSLD.RecordDeleted,'N')='N'  
--AND  ISNull(DC.RecordDeleted,'N')='N'  
--ORDER BY DC.EffectiveDate  DESC  
   
DECLARE @EffectiveDate DATETIME 
DECLARE @EffectiveEndDateForAddendumCarePlan int  
Select @EffectiveEndDateForAddendumCarePlan= ISNULL(Cast(Value As int) ,180)from SystemConfigurationKeys  
where [Key]='SetNumberValueToCalculateEndDateForAddendumCarePlan'  
SELECT TOP 1 @EffectiveDate = CONVERT(VARCHAR(10), DATEADD(DAY, @EffectiveEndDateForAddendumCarePlan, Doc.EffectiveDate),101)     
	   FROM Documents Doc    
	   INNER JOIN DocumentCarePlans DCP ON DCP.DocumentVersionId = doc.CurrentDocumentVersionId  
	   inner join Clients C on C.ClientId=Doc.ClientId  
	   inner join ClientEpisodes CE on CE.ClientId=C.ClientId and CONVERT(DATE,DOC.EffectiveDate)>=CONVERT(DATE,CE.RegistrationDate)   
	     
	   WHERE (DCP.CarePlanType='IN' OR DCP.CarePlanType = 'AN') AND ISNULL(DCP.RecordDeleted,'N')='N'  
	   --AND Doc.ClientId=@ClientID AND DocumentCodeId IN (1501,1502) AND Doc.Status = 22   
	   AND Doc.ClientId=@ClientID AND DocumentCodeId IN (1620) AND Doc.Status = 22   
	   AND DATEDIFF(DAY,Doc.EffectiveDate,GETDATE())  <= @EffectiveEndDateForAddendumCarePlan  
	   AND ISNULL(Doc.RecordDeleted,'N')='N'  
	   AND CONVERT(DATE,DOC.EffectiveDate) <= CONVERT(DATE,GETDATE())   
	   ORDER BY Doc.EffectiveDate DESC, Doc.ModifiedDate DESC 
   
  
  IF EXISTS (SELECT *
	FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[scsp_RdlCarePlanDates]') AND type in (N'P', N'PC'))
	BEGIN
	
	DECLARE @EndDate Datetime
	Exec scsp_RdlCarePlanDates @DocumentVersionId,@ScreenName,@EndDate OUTPUT
	
	END
 
 
 ELSE
 
 BEGIN
     
 Select               
 CSLD.[DocumentVersionId],    
 CONVERT(VARCHAR,DC.EffectiveDate,101) AS BeginDate,              
 CASE CSLD.[CarePlanType]                       
 WHEN 'AD' THEN 'Addendum'      
--Added by Veena on 05/11/16 for CarePlan Review changes Valley Support Go live #390    
 WHEN 'RE' THEN 'Review'    
 ELSE @ScreenName      
 END AS [CarePlanType],    
 --   CASE CSLD.[CarePlanType]               
 --WHEN 'IN' THEN CONVERT(VARCHAR,DATEADD(M,6,DC.EffectiveDate),101)            
 --WHEN 'AN' THEN CONVERT(VARCHAR,DATEADD("yyyy",1,DC.EffectiveDate),101)              
 --WHEN 'AD' THEN CONVERT(VARCHAR,DATEADD("yyyy",1,@EffectiveDate),101)               
 --WHEN 'RE' THEN CONVERT(VARCHAR,DATEADD("yyyy",1,@EffectiveDate),101)    
 --ELSE CONVERT(VARCHAR,DC.EffectiveDate,101)        
 --END AS [EndDate]    
   
  --Added By vandana for End date hide/show on PDF Valley-Enhancements #390.4   
  
case when @TreatmentPlanEndDate =0 then ''  
else        
 CASE CSLD.CarePlanType    
 WHEN 'AD' THEN CONVERT(VARCHAR,@EffectiveDate,101)    
 ELSE CONVERT(VARCHAR,DATEADD(D,@TreatmentPlanEndDate,DC.EffectiveDate),101) --16 Mar  2017 Pradeep Y    
 END   
 end AS [EndDate],  
 @ScreenName as ScreenName    
 FROM [DocumentCarePlans] CSLD     
 INNER JOIN Documents DC ON DC.CurrentDocumentVersionId=CSLD.[DocumentVersionId]                  
 WHERE ISNull(CSLD.RecordDeleted,'N')='N'    
 AND  ISNull(DC.RecordDeleted,'N')='N'    
 AND CSLD.DocumentVersionId=@DocumentVersionId 
 
 END           
     

 
     
END TRY  
 BEGIN CATCH                                  
  DECLARE @Error VARCHAR(8000)  
  
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RdlCarePlanDates') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
 RAISERROR (  
   @Error  
   ,-- Message text.         
   16  
   ,-- Severity.         
   1 -- State.                                                           
   );                                    
 END CATCH       
  
END  
GO


