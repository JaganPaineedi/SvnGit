
/****** Object:  StoredProcedure [dbo].[ssp_GetMeasureSubType]    Script Date: 09/12/2014 11:12:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMeasureSubType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMeasureSubType]
GO



/****** Object:  StoredProcedure [dbo].[ssp_GetMeasureSubType]    Script Date: 09/12/2014 11:12:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetMeasureSubType]
@Stage INT ,
@MeasureType INT,
@MeasureSubType INT
	/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetMeasureSubType]      
--   
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date				Author			Purpose    
-- 10-Sept-2014		Vithobha		What:Get MeasureSubType, Target from MeaningfulUseMeasureTargets based on Stage ,MeasureType and MeasureSubType           
--									Why:task #25 MeaningFul Use
-- 11-Jan-2016	    Gautam			What : Change the code for Stage 9373 'Stage2 - Modified' requirement
									why : Meaningful Use, Task	#66 - Stage 2 - Modified  	
*********************************************************************************/
AS
BEGIN
	 BEGIN TRY  
		
SELECT MUD.MeasureSubType,MUD.Stage, GS.SubCodeName from MeaningfulUseMeasureTargets MUD 
		--LEFT JOIN GlobalCodes GC ON (  
		--MUD.MeasureType = GC.GlobalCodeId AND ISNULL(GC.RecordDeleted, 'N') = 'N' ) 
		LEFT JOIN GlobalSubCodes GS ON (  
		MUD.MeasureSubType = GS.GlobalSubCodeId AND ISNULL(GS.RecordDeleted, 'N') = 'N' ) 
		where MUD.MeasureType=@MeasureType and MUD.Stage=@Stage and (ISNULL(MUD.RecordDeleted, 'N') = 'N') and MUD.MeasureSubType is not null  order by GS.SubCodeName 

if(@MeasureSubType = -1)
	begin
		SELECT  top 1 @MeasureSubType = MUD.MeasureSubType from MeaningfulUseMeasureTargets MUD 
		inner JOIN GlobalSubCodes GS ON (  
		MUD.MeasureSubType = GS.GlobalSubCodeId AND ISNULL(GS.RecordDeleted, 'N') = 'N' ) 
		where MUD.MeasureType=@MeasureType and MUD.Stage=@Stage and (ISNULL(MUD.RecordDeleted, 'N') = 'N') and MUD.MeasureSubType is not null
	end

--if @MeasureSubType is not null
SELECT  case when @MeasureType=8697 and @MeasureSubType=6212 and @Stage= 9373  then 'N/A' else cast(MUD.Target as varchar(10)) end as 'Target' from MeaningfulUseMeasureTargets MUD 
--LEFT JOIN GlobalCodes GC ON (  
--		MUD.MeasureType = GC.GlobalCodeId AND ISNULL(GC.RecordDeleted, 'N') = 'N' ) 
		left join GlobalSubCodes GS ON (  
		MUD.MeasureSubType = GS.GlobalSubCodeId AND ISNULL(GS.RecordDeleted, 'N') = 'N' ) 
		where MUD.MeasureType=@MeasureType and MUD.Stage=@Stage and (ISNULL(MUD.RecordDeleted, 'N') = 'N') and (@MeasureSubType = -1 or @MeasureSubType is  null or MUD.MeasureSubType=@MeasureSubType)    
		
	 END TRY  
	  BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetMeasureSubType') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(
VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())  
  
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