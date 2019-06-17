IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSystemTreatmentEpisodeList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCSystemTreatmentEpisodeList] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCSystemTreatmentEpisodeList] (       
 @PageNumber int
,@PageSize int
,@SortExpression  varchar(100)
,@RegistrationDateFrom varchar(15)
,@RegistrationDateTo varchar(15)
,@RequestDateFrom varchar(15)
,@RequestDateTo varchar(15)
,@DischargeDateFrom varchar(15)
,@DischargeDateTo varchar(15)
,@TreatmentEpisodeType int
,@TreatmentEpisodeSubType int
,@TreatmentEpisodeStatus int
,@StaffAssociatedId varchar(150)
,@ServiceAreaId int
,@ClientId   int
 )      
AS      
/************************************************************************************************                              
**  File:                                                 
**  Name: 
ssp_SCSystemTreatmentEpisodeList   35,55,  null, '04/19/2017',  '04/19/2017',  '04/19/2017',   '04/19/2017', null,  null,
 54851,  11246,54853, 1,  3, 3   
  ssp_SCSystemTreatmentEpisodeList   0,100,  'RegistrationDate', null,  null, null,  null, null,  null,
 0,  0,0, 'Aaron',  0, 0      
                                       
**  Desc: This storeProcedure is for getting the list of Treatment Episode List.      
**      
**  Parameters:       
**  @PageNumber int
,@PageSize int
,@SortExpression  varchar(100)
,@RegistrationDateFrom varchar(15)
,@RegistrationDateTo varchar(15)
,@RequestDateFrom varchar(15)
,@RequestDateTo varchar(15)
,@DischargeDateFrom varchar(15)
,@DischargeDateTo varchar(15)
,@TreatmentEpisodeType int
,@TreatmentEpisodeSubType int
,@TreatmentEpisodeStatus int
,@StaffAssociatedId int
,@ServiceAreaId int
,@ClientId   int    
**  Output     ----------       -----------       
**        
**  Author:  Sunil.D   
**  Date:    04/13/2017      
*************************************************************************************************      
**  Change History       
**  Date:    Author:   Description:       
**  --------   --------  -------------------------------------------------------------      
**  20-11-2017  Pavani   What :Modified Date format  from European date format ‘DD/MM/YYYY’(103) to American style ‘MM/DD/YYYY’(101)
                         Why :Thresholds - Support #1093
*************************************************************************************************/      
BEGIN      
 BEGIN TRY      
    
   
 Declare @TotalCount int
     CREATE Table #ResultSet ( 
				TotalCount int,       
				TreatmentEpisodeId int, 
				ClientId Int,                
				ClientName varchar(100),        
				ServiceAreaName  varchar(100),        
				StaffAssociatedid  varchar(100),          
				TreatmentEpisodeType varchar(100),                            
				TreatmentEpisodeSubType  varchar(100),            
				TreatmentEpisodeStatus varchar(100),            
				RegistrationDate  Varchar(15),        
				DischargeDate  Varchar(15), 
				RequestDate Varchar(15)       
 )  
 INSERT #ResultSet(
			 TotalCount, 
			 TreatmentEpisodeId , 
			 ClientId,                
			 ClientName,    
			 ServiceAreaName ,    
			 StaffAssociatedid ,      
			 TreatmentEpisodeType,                        
			 TreatmentEpisodeSubType ,        
			 TreatmentEpisodeStatus,        
			 RegistrationDate  ,        
			 DischargeDate  , 
			 RequestDate )
   select	Count(*)  OVER (), 
			TE.TreatmentEpisodeId ,
			TE.ClientId
			,CONVERT(VARCHAR(100),P.LastName+', '+P.FirstName) AS ClientName
			,SA.ServiceAreaName AS ServiceAreaName
			,CONVERT(VARCHAR(100),(S.LastName+', '+S.FirstName) )AS StaffAssociatedid
			,dbo.ssf_GetGlobalCodeNameById(TE.TreatmentEpisodeType) AS TreatmentEpisodeType
			,GS.SubCodeName  AS TreatmentEpisodeSubType
			,dbo.ssf_GetGlobalCodeNameById(TE.TreatmentEpisodeStatus) AS TreatmentEpisodeStatus
			-- Pavani 20-11-2017
			,CONVERT(VARCHAR(10), TE.RegistrationDate, 101) AS RegistrationDate 
			,CONVERT(VARCHAR(10), TE.DischargeDate, 101) AS DischargeDate 
			,CONVERT(VARCHAR(10), TE.RequestDate, 101) AS RequestDate  
            --End			
		    FROM TreatmentEpisodes TE 
			left JOIN Clients P ON (P.ClientId = TE.ClientId) 
		    left JOIN ServiceAreas SA ON (SA.ServiceAreaId = TE.ServiceAreaId) 
		    left JOIN Staff S ON (S.StaffId = TE.StaffAssociatedId) 
		    left JOIN GlobalSubCodes GS ON (GS.GlobalSubCodeId = TE.TreatmentEpisodeSubType) 
		    where ISNULL(TE.RecordDeleted,'N') <> 'Y' 
		    AND (ISNULL(@ClientId,'')='' OR TE.ClientId=@ClientId)  
		    AND (ISNULL(@ServiceAreaId,'')='' OR TE.ServiceAreaId=@ServiceAreaId)   
		   -- AND (ISNULL(@StaffAssociatedId,'')='' OR TE.StaffAssociatedId=@StaffAssociatedId)  
			AND (ISNULL(@TreatmentEpisodeStatus,'')='' OR TE.TreatmentEpisodeStatus=@TreatmentEpisodeStatus)  
			AND (ISNULL(@TreatmentEpisodeSubType,'')='' OR TE.TreatmentEpisodeSubType=@TreatmentEpisodeSubType) 
			AND (ISNULL(@TreatmentEpisodeType,'')='' OR TE.TreatmentEpisodeType=@TreatmentEpisodeType) 
		    AND ( @RegistrationDateFrom IS NULL OR TE.RegistrationDate >= @RegistrationDateFrom ) 
		    AND ( @RegistrationDateTo IS NULL OR TE.RegistrationDate <= @RegistrationDateTo ) 
		    AND ( @RequestDateFrom IS NULL OR TE.RequestDate >= @RequestDateFrom )  
		    AND ( @RequestDateTo IS NULL OR TE.RequestDate <= @RequestDateTo ) 
		    AND ( @DischargeDateFrom IS NULL OR TE.DischargeDate >= @DischargeDateFrom ) 
		    AND ( @DischargeDateTo IS NULL OR TE.DischargeDate <= @DischargeDateTo ) 
		    
		     ORDER BY            
                    CASE WHEN @SortExpression = 'ClientName' THEN TE.ClientId END,          
                    CASE WHEN @SortExpression = 'ClientName DESC' THEN TE.ClientId END DESC,           
                    CASE WHEN @SortExpression = 'ServiceArea' THEN  ServiceAreaName END,           
                    CASE WHEN @SortExpression = 'ServiceArea DESC' THEN ServiceAreaName END DESC ,  
                    CASE WHEN @SortExpression = 'StaffAssociated' THEN  StaffAssociatedid END,           
                    CASE WHEN @SortExpression = 'StaffAssociated DESC' THEN StaffAssociatedid END DESC,      
                    CASE WHEN @SortExpression = 'DischargeDate' THEN  DischargeDate END,           
                    CASE WHEN @SortExpression = 'DischargeDate DESC' THEN DischargeDate END DESC, 
                    CASE WHEN @SortExpression = 'Status' THEN  TreatmentEpisodeStatus END,           
                    CASE WHEN @SortExpression = 'Status DESC' THEN TreatmentEpisodeStatus END DESC , 
                    CASE WHEN @SortExpression = 'RequestDate' THEN  RequestDate END,           
                    CASE WHEN @SortExpression = 'RequestDate DESC' THEN RequestDate END DESC , 
                    CASE WHEN @SortExpression = 'RegistrationDate' THEN  RegistrationDate END,           
                    CASE WHEN @SortExpression = 'RegistrationDate DESC' THEN RegistrationDate END DESC ,
                    CASE WHEN @SortExpression = 'SubType' THEN  TreatmentEpisodeSubType END,           
                    CASE WHEN @SortExpression = 'SubType DESC' THEN TreatmentEpisodeSubType END DESC , 
					CASE WHEN @SortExpression = 'Type' THEN  TreatmentEpisodeType END,           
                    CASE WHEN @SortExpression = 'Type DESC' THEN TreatmentEpisodeType END DESC 
		    IF (SELECT Isnull(Count(*), 0)  FROM   #ResultSet) < 1           
            BEGIN           
                SELECT 0 AS PageNumber,           
					   0 AS NumberOfPages,           
                       0 AS NumberOfRows;           
            END           
          ELSE           
            BEGIN           
                SELECT TOP 1 @PageNumber           AS PageNumber,           
                             CASE ( TotalCount % @PageSize )           
                               WHEN 0 THEN Isnull(( TotalCount / @PageSize ), 0)           
                               ELSE Isnull((totalcount / @PageSize), 0) + 1           
                             END                   AS NumberOfPages,           
                             Isnull(TotalCount, 0) AS NumberOfRows           
                FROM   #ResultSet;           
            END  
            
            if  (@StaffAssociatedId is not null )
            begin 
					select
					TreatmentEpisodeId,
					ClientId,
					TreatmentEpisodeType,                        
					TreatmentEpisodeSubType ,
					RegistrationDate  ,
					RequestDate , 
					TreatmentEpisodeStatus,   
					DischargeDate  , 
					StaffAssociatedid , 
					ServiceAreaName ,  
					ClientName   
					from #ResultSet   where StaffAssociatedid like '%'+@StaffAssociatedId+'%'
				end
				else
				begin	
					select
					TreatmentEpisodeId,
					ClientId,
					TreatmentEpisodeType,                        
					TreatmentEpisodeSubType ,
					RegistrationDate  ,
					RequestDate , 
					TreatmentEpisodeStatus,   
					DischargeDate  , 
					StaffAssociatedid , 
					ServiceAreaName ,  
					ClientName   
					from #ResultSet   
					
					end
		  drop table #ResultSet 
 END TRY      
      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
      
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCSystemTreatmentEpisodeList') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert  
    
(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
  RAISERROR (      
    @Error      
    ,-- Message text.                                                                                          
    16      
    ,-- Severity.                                                                                          
    1 -- State.                                              
    );      
 END CATCH      
END      