
/****** Object:  StoredProcedure [dbo].[ssp_GetMedReconciliationInformation]    Script Date: 06/08/2015 10:35:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMedReconciliationInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMedReconciliationInformation]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetMedReconciliationInformation]    Script Date: 06/08/2015 10:35:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create procedure [dbo].[ssp_GetMedReconciliationInformation]
    @DocumentVersionId int
  , @ReconciliationTypeId int
  , @ClientId int
  , @StaffId int
as 
    begin
 IF object_id('dbo.csp_GetMedReconciliationInformation', 'P') IS NOT NULL    
 BEGIN    
  EXEC csp_GetMedReconciliationInformation @DocumentVersionId = @DocumentVersionId    
   ,@ReconciliationTypeId = @ReconciliationTypeId    
   ,@ClientId = @ClientId    
   ,@StaffId = @StaffId    
 END    
 ELSE    
 BEGIN    
        if @DocumentVersionId = 0
            and @ReconciliationTypeId = 0 
            begin
                select top 10
                        a.ClientMedicationReconciliationId
                      , a.ReconciliationDate as DateandTime
                      , ( select    CodeName
                          from      GlobalCodes
                          where     GlobalCodeId = a.ReconciliationReasonId
                        ) as Reason
                      , c.UserCode as Users
                      , ( select    CodeName
                          from      GlobalCodes
                          where     GlobalCodeId = a.ReconciliationTypeId
                        ) as ReconciliationType
                from    ClientMedicationReconciliations a
                      , Staff c
                where   a.StaffId = c.StaffId
                        and a.ClientId = @ClientId
						and ReconciliationTypeId in (8793,8794) --Rx Meds and Allergies only
                order by DateandTime desc
            end

        if @DocumentVersionId = 0
            and @ReconciliationTypeId <> 0 
            begin
                select top 10
                        a.ClientMedicationReconciliationId
                      , a.ReconciliationDate as DateandTime
                      , ( select    CodeName
                          from      GlobalCodes
                          where     GlobalCodeId = a.ReconciliationReasonId
                        ) as Reason
                      , c.UserCode as Users
                      , ( select    CodeName
                          from      GlobalCodes
                          where     GlobalCodeId = a.ReconciliationTypeId
                        ) as ReconciliationType
                from    ClientMedicationReconciliations a
                      , Staff c
                where   a.StaffId = c.StaffId
                        and a.ClientId = @ClientId
                        and a.ReconciliationTypeId = @ReconciliationTypeId
                order by DateandTime desc
            end
		
        if @DocumentVersionId <> 0
            and @ReconciliationTypeId = 0 
            begin
                select top 10
                        a.ClientMedicationReconciliationId
                      , a.ReconciliationDate as DateandTime
                      , ( select    CodeName
                          from      GlobalCodes
                          where     GlobalCodeId = a.ReconciliationReasonId
                        ) as Reason
                      , c.UserCode as Users
                      , ( select    CodeName
                          from      GlobalCodes
                          where     GlobalCodeId = a.ReconciliationTypeId
                        ) as ReconciliationType
                from    ClientMedicationReconciliations a
                      , Staff c
                where   a.StaffId = c.StaffId
                        and a.ClientId = @ClientId
                        and a.DocumentVersionId = @DocumentVersionId
						and ReconciliationTypeId in (8793,8794) --Rx Meds and Allergies only
                order by DateandTime desc
            end

        if @DocumentVersionId <> 0
            and @ReconciliationTypeId <> 0 
            begin
                select top 10
                        a.ClientMedicationReconciliationId
                      , a.ReconciliationDate as DateandTime
                      , ( select    CodeName
                          from      GlobalCodes
                          where     GlobalCodeId = a.ReconciliationReasonId
                        ) as Reason
                      , c.UserCode as Users
                      , ( select    CodeName
                          from      GlobalCodes
                          where     GlobalCodeId = a.ReconciliationTypeId
                        ) as ReconciliationType
                from    ClientMedicationReconciliations a
                      , Staff c
                where   a.StaffId = c.StaffId
                        and a.ClientId = @ClientId
                        and a.DocumentVersionId = @DocumentVersionId
                        and a.ReconciliationTypeId = @ReconciliationTypeId
                order by DateandTime desc
		 END
            end


	

    end


GO


