/****** Object:  StoredProcedure [dbo].[ssp_MedicationReconciliationInformation]    Script Date: 06/08/2015 10:33:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MedicationReconciliationInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_MedicationReconciliationInformation]
GO


/****** Object:  StoredProcedure [dbo].[ssp_MedicationReconciliationInformation]    Script Date: 06/08/2015 10:33:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- *****History****   
--/* Date				Author				Purpose              */
--/* 07.April2016		Manjunath K       Added Code to save ClientMedicationId in ClientMedicationReconciliations
--/*									  table from ClientMedications table*/
/*   28/Sep/2017		Alok				Set @RowIdentifier  default value as null
											Ref: task #26.2 Meaningful Use - Stage 3							*/
								
CREATE PROCEDURE [dbo].[ssp_MedicationReconciliationInformation] 
	-- Add the parameters for the stored procedure here

	@ClientId INT,
	@StaffId INT,
	@GlobalCodeId INT,
	@DocumentVersionId INT,
	@ReconciliationTypeId INT,
	@RowIdentifier type_GUID = NULL
AS
BEGIN

	Declare @ClientMedicationId Int = NULL
	IF(@RowIdentifier <> NULL)
	BEGIN
		SET @ClientMedicationId = (select Top 1 ClientMedicationId from ClientMedications where RowIdentifier like @RowIdentifier)
	END
	
	 INSERT  into ClientMedicationReconciliations
                ( RecordDeleted ,
				  DocumentVersionId	,
                  ClientId ,
				  StaffId,
                  ReconciliationReasonId ,
                  ReconciliationDate,
				  ReconciliationTypeId,ClientMedicationId	        
                )
values('N',@DocumentVersionId,@ClientId,@StaffId,@GlobalCodeId, GETDATE(),@ReconciliationTypeId,@ClientMedicationId )
           
    

        
END



GO


