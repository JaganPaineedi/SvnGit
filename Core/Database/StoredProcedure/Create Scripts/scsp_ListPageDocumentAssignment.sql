/****** Object:  StoredProcedure [dbo].[scsp_ListPageCMGetAllInsurers]    Script Date: 10/07/2016 18:52:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageDocumentAssignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_ListPageDocumentAssignment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[scsp_ListPageDocumentAssignment]    
	@Packet INT,   
	@PacketType INT,   
    @Status	INT,    
    @OtherFilter INT
AS     
  /************************************************************************************************                                    
  -- Stored Procedure: dbo.[scsp_ListPageDocumentAssignment]          
  -- Copyright: Streamline Healthcate Solutions           
  -- Purpose: Used by Document Assignment list page           
  -- Updates:           
  -- Date          Author            Purpose           
  -- 07 Oct 2016  Arjun KR           Created           
  -- Modified
  --11 DEC 2018	  Alok Kumar		Added a new parameter '@PacketType'.	Ref#618 EII.
  *************************************************************************************************/    
SELECT @OtherFilter;

RETURN 

GO


