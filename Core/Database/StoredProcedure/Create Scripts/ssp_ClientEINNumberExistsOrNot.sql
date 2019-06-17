/****** Object:  StoredProcedure [ssp_ClientEINNumberExistsOrNot]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_ClientEINNumberExistsOrNot]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_ClientEINNumberExistsOrNot]
GO

/****** Object:  StoredProcedure [ssp_ClientSSNNumberExistsOrNot]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create PROCEDURE [ssp_ClientEINNumberExistsOrNot]   
	@EIN				INT
  
AS
BEGIN
BEGIN TRY
    Declare @ClientId int
    set @ClientId = -1
    
    if(@EIN <> 999999999)
    begin
	select @ClientId = ClientId  from Clients where  isNull(RecordDeleted,'N')<>'Y' and  EIN = CAST(@EIN as varchar(25))
	end
	
	if(@ClientId = -1)
	begin
    select @ClientId as 'ClientId' , 'False' as 'IsExists'
    end
    else 
    begin
    select @ClientId as 'ClientId' , 'True' as 'IsExists'
    end
    
    
   END TRY
   BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ClientEINNumberExistsOrNot')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END
GO
