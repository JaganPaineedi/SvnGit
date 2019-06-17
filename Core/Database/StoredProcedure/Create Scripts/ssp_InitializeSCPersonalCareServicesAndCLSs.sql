IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitializeSCPersonalCareServicesAndCLSs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitializeSCPersonalCareServicesAndCLSs]
GO

CREATE PROCEDURE [dbo].[ssp_InitializeSCPersonalCareServicesAndCLSs]                                                                                                                            
(                                                                                                                                               
                                                                                                                                                  
 @ClientID int,                                                    
 @StaffID int,                                                  
 @CustomParameters xml)                                                                                                                                                        
As                                                                                                                                      
/*********************************************************************/                                                                                                                                          
/* Stored Procedure: ssp_InitializeSCPersonalCareServicesAndCLSs          */                                                                                                                                          
/* Purpose:   To Initialize*/                                                                                                                                          
/*                                                                   */                                                                                                                                          
/* Input Parameters:   @ClientID :-Id of the client*/                                                                                                                                          
/*                                                                   */                                                                                                                                          
/* Output Parameters:   None                                         */                                                                                                                                          
/*                                                                   */                                                                                                                                          
/* Return:                   */                                                                                                                                          
/*                                                                   */                                                                                                                                          
/* Called By:                  */                                                                                                                                          
/*                                                                   */                                                                                                                                          
/* Calls:                                                            */                                                                                                                                          
/*                                                                   */                                                                                                                                          
/* Data Modifications:                                               */                             
/*                                                                   */                        
/* Updates:    */                           
/*   Date         Author      Purpose                       */                                            
/*  sept/14/2012             Atul Pandey   Created                                              
 
/*********************************************************************/  */                                                                
BEGIN                                                                               
                          
begin try
     DECLARE @GlobalCodeIdMonth int;
     DECLARE @GlobalCodeIdStatus int; 
           

    SELECT @GlobalCodeIdMonth=GlobalCodeId FROM GlobalCodes WHERE Category='PCARECLSMONTH' AND Code= MONTH(getdate())
     SELECT @GlobalCodeIdStatus=GlobalCodeId FROM GlobalCodes  WHERE GlobalCodeId=8166
    SELECT
        Placeholder.TableName
      ,-1 as [PersonalCareServicesAndCLSId]
      ,PCS.[CreatedBy]
      ,PCS.[CreatedDate]
      ,PCS.[ModifiedBy]
      ,PCS.[ModifiedDate]
      ,PCS.[RecordDeleted]
      ,PCS.[DeletedDate]
      ,PCS.[DeletedBy]
      ,@ClientID As ClientId
      ,@GlobalCodeIdMonth as [Month]
      ,year(getdate()) as [Year]
      ,[ProviderId]
      ,[SiteId]
      ,[Summary]
      ,[FeedBack]
      ,@GlobalCodeIdStatus as [Status]
      ,[CompletedBy]
      ,[CompletedDate]
      ,ISNULL(S.LastName + ', ', '') + S.FirstName AS CompletedByName
      FROM (SELECT 'PersonalCareServicesAndCLSs' AS TableName) AS Placeholder  
		LEFT JOIN [PersonalCareServicesAndCLSs] PCS
		LEFT JOIN Staff S on PCS.CompletedBy = S.StaffId
   ON [PersonalCareServicesAndCLSId]=-1
   
   
;With PcareActivities As(
        select PersonalCareAndCLSActivityId,ActivityType from PersonalCareAndCLSActivities 
   ),Pcareshifts AS
  (
   select globalcodeid as Shift, CodeName as ShiftName from globalcodes where Category = 'PCARECLSSHIFT' --order by SortOrder asc
   ),PcareDays As
  ( 
	select cast(item as int) as [Days] from [dbo].fnSplit('1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31',',')
	),CTEPersonalCareAndCLSActivityShiftDayDetails As
	(
	Select 
		 PersonalCareAndCLSActivityId
		 ,ActivityType	
		 ,Shift	
		 ,ShiftName	
		 ,[Days]
	from  PcareActivities cross join Pcareshifts    cross join PcareDays
   )

select 
      'PersonalCareAndCLSActivityShiftDayDetails' as TableName
    ,CAST(-ROW_NUMBER()  over(order by PersonalCareAndCLSActivityShiftDayDetailId) as int) as PersonalCareAndCLSActivityShiftDayDetailId
     ,CreatedBy	
     ,CreatedDate	
     ,ModifiedBy	
     ,ModifiedDate	
     ,RecordDeleted	
     ,DeletedBy	
     ,DeletedDate	
     ,-1 as PersonalCareServicesAndCLSId	
     ,CTEPCADD.PersonalCareAndCLSActivityId
     ,CTEPCADD.Shift	
     ,CTEPCADD.Days
     ,RefusedByResidentLegend	
     ,AwayforPartoftheDayLegend	
     ,LeaveOfAbsenceLegend	
     ,OtherLegend	
     ,SleepLegend	
     ,IndependentLegend	
     ,RemindingLegend	
     ,ObservingMonitoringLegend	
     ,ModelingLegend	
     ,VerbalPromptsGuidingLegend	
     ,PhysicalAssistanceLegend	
     ,TrainingLegend	
     ,OtherinterventionLegend	
     ,NotApplicableLegend
     ,ActivityType	
     ,ShiftName 	
     ,reverse(stuff(reverse(Case when ISNULL(RefusedByResidentLegend,'N')='Y' THEN 'R,'+CHAR(10)  ELSE '' END 
     + Case when ISNULL(AwayforPartoftheDayLegend,'N')='Y' THEN 'APD,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(LeaveOfAbsenceLegend,'N')='Y' THEN 'LOA,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(OtherLegend,'N')='Y' THEN 'O,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(SleepLegend,'N')='Y' THEN 'S,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(IndependentLegend,'N')='Y' THEN 'I,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(RemindingLegend,'N')='Y' THEN 'REM,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(ObservingMonitoringLegend,'N')='Y' THEN 'O/M,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(ModelingLegend,'N')='Y' THEN 'M,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(VerbalPromptsGuidingLegend,'N')='Y' THEN 'VP,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(PhysicalAssistanceLegend,'N')='Y' THEN 'P,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(TrainingLegend,'N')='Y' THEN 'T,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(OtherinterventionLegend,'N')='Y' THEN 'OI,'+CHAR(10)  ELSE '' END
     + Case when ISNULL(NotApplicableLegend,'N')='Y' THEN 'N/A,'+CHAR(10)  ELSE '' END), 1, 2, ''))  As Legends   
   FROM CTEPersonalCareAndCLSActivityShiftDayDetails CTEPCADD 
Left Join PersonalCareAndCLSActivityShiftDayDetails PCADD on (PersonalCareAndCLSActivityShiftDayDetailId=-1)

 select 
         Placeholder.TableName
         ,CAST(ROW_NUMBER()  over(order by PersonalCareAndCLSActivityId) as int) as SNo
         ,PersonalCareAndCLSActivityId
        ,ActivityName,ActivityType,GlobalCodeId as Shift,CodeName as ShiftName
 FROM (SELECT 'PersonalCareActivities' AS TableName) AS Placeholder       
cross join
 PersonalCareAndCLSActivities
 cross join globalcodes where category='PCARECLSSHIFT'
  order by ActivityType,PersonalCareAndCLSActivityId,GlobalCodeId
 




                    
end try                                              
begin catch  
DECLARE @Error varchar(8000)                                                       
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InitializeSCPersonalCareServicesAndCLSs')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                  
  RAISERROR                                                                                     
  (                                                       
   @Error, -- Message text.                                                                                    
   16, -- Severity.                                                                                    
   1 -- State.                                                                                    
   );                                                    
end catch 
END
