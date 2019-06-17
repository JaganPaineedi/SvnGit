IF EXISTS (		SELECT *	FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSystemImplantableDevicesDataList]')		AND type IN (N'P',N'PC'	)		)
	DROP PROCEDURE [dbo].[ssp_SCSystemImplantableDevicesDataList] 
GO 
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO 
CREATE PROCEDURE [dbo].[ssp_SCSystemImplantableDevicesDataList] (       
 @PageNumber int
,@PageSize int
,@SortExpression  varchar(100)
,@ImplantDate varchar(15)
,@GlobalUDI varchar(500)
,@SerialNumber varchar(500)
,@Active varchar(200)
,@InactiveReason varchar(200) 
 )      
AS      
/************************************************************************************************                              
**  File:  ImplantabeDevices                                               
**  Name:  ssp_SCSystemImplantableDevicesDataList
  ssp_SCSystemImplantableDevicesDataList   0,200,  'Status DESC', null,  null, null,0,0  
**  Desc: This storeProcedure is for getting the list of Treatment Episode List.      
**      
**  Parameters:       
**  @PageNumber int 
**  Output     ----------       -----------       
**        
**  Author:  Sunil.D   
**  Date:    10/07/2017   
Purpose :To get List page data for #24 Meaningful use.  
*************************************************************************************************      
**  Change History       
**  Date:    Author:   Description:       
**  --------   --------  -------------------------------------------------------------      
  
*************************************************************************************************/      
BEGIN      
 BEGIN TRY   
 Declare @TotalCount int
     CREATE Table #ResultSet ( 
			TotalCount int,           
			ImplantableDeviceId int,          
			GlobalUDI varchar(500),  
			ClientId int,                          
			SerialNumber  varchar(500),            
			Descrpition varchar(max),            
			ImplantDate  Varchar(15),        
			Active  Varchar(100), 
			InactiveReason Varchar(200)       
 )  
 INSERT #ResultSet(
			 TotalCount, 
			 ImplantableDeviceId , 
			 GlobalUDI,  
			 ClientId,              
			 SerialNumber,    
			 Descrpition ,    
			 ImplantDate ,      
			 Active,                        
			 InactiveReason   )
   select	Count(*)  OVER (), 
			 ID.ImplantableDeviceId 
			,ID.GlobalUDI  
			,ID.ClientId
			,ID.SerialNumber 
			,ID.Descrpition 
			,CONVERT(VARCHAR(10), ID.ImplantDate, 103) AS  ImplantDate
			,dbo.ssf_GetGlobalCodeNameById(ID.Active)as Active
			,G.CodeName as InactiveReason 
		    FROM ImplantableDevices ID  
		    left join GlobalCodes G on g.GlobalCodeId=ID.InactiveReason 
		    where   ISNULL(ID.RecordDeleted,'N') <> 'Y' 
					AND ( @ImplantDate IS NULL OR ID.ImplantDate = @ImplantDate )
					AND (ISNULL(@GlobalUDI,'')='' OR ID.GlobalUDI=@GlobalUDI)  
					AND (ISNULL(@SerialNumber,'')='' OR ID.SerialNumber=@SerialNumber)   
					AND (ISNULL(@Active,'0')='0' OR ID.Active=@Active)  
					AND (ISNULL(@InactiveReason,'0')='0' OR ID.InactiveReason=@InactiveReason) 
		     ORDER BY            
                    CASE WHEN @SortExpression = 'ImplantDate' THEN  ImplantDate END,           
                    CASE WHEN @SortExpression = 'ImplantDate DESC' THEN ImplantDate END DESC,  
                    CASE WHEN @SortExpression = 'GlobalUDI' THEN  GlobalUDI END,           
                    CASE WHEN @SortExpression = 'GlobalUDI DESC' THEN GlobalUDI END DESC ,  
                    CASE WHEN @SortExpression = 'SerialNumber' THEN  SerialNumber END,           
                    CASE WHEN @SortExpression = 'SerialNumber DESC' THEN SerialNumber END DESC,    
                    CASE WHEN @SortExpression = 'Status' THEN  ID.Active END,           
                    CASE WHEN @SortExpression = 'Status DESC' THEN ID.Active END DESC ,  
                    CASE WHEN @SortExpression = 'InactiveReason' THEN  InactiveReason END,           
                    CASE WHEN @SortExpression = 'InactiveReason DESC' THEN InactiveReason END DESC , 
					CASE WHEN @SortExpression = 'Descrpition' THEN  Descrpition END,           
                    CASE WHEN @SortExpression = 'Descrpition DESC' THEN Descrpition END DESC 
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
	select
			TotalCount, 
			ImplantableDeviceId , 
			GlobalUDI, 
			ClientId,               
			SerialNumber,    
			Descrpition ,    
			ImplantDate ,      
			Active,                        
			InactiveReason   
	from #ResultSet    
		  drop table #ResultSet 
 END TRY     
 BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)   
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCSystemImplantableDevicesDataList') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert   
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