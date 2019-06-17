IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_WhiteBoardMonitor]')
                  AND type IN (N'P', N'PC'))
    DROP PROCEDURE [dbo].[ssp_WhiteBoardMonitor];


GO
/****** Object:  StoredProcedure [dbo].[ssp_WhiteBoardMonitor]    Script Date: 24/12/2013 12:28:24 ******/
SET ANSI_NULLS ON;


GO
SET QUOTED_IDENTIFIER ON;


GO
CREATE PROCEDURE [dbo].[ssp_WhiteBoardMonitor]
                       @CurrentPageNumber INT,
                       @PageSize INT, 
                       @PageNumber INT, 
                       @SortExpression VARCHAR (100), 
                       @DateFilter DATETIME, 
                       @UnitsFilter INT, 
                       @AttendingFilter INT, 
                       @DAFilter INT, 
                       @BedFilter INT, 
                       @OtherFilter INT,
                       @TotalBeds INT OUTPUT
AS
/****************************************************************************************************/
/* Procedure: [ssp_WhiteBoardMonitor]              */
/*                         */
/* Purpose:     */
/*                         */
/* Created By: Praveen Potnuru                   */
/*
 16 Jun 2015  Chethan N               What : Merged White Board Changes. 
									Calling ssp_ListPageWhiteBoard with Additional parameter to get White Board list page data and Order data.
									-- '1' -- To Get White Board details. '2' -- To get Order details.	
 19 Jun 2015  Chethan N               What : Merged White Board Changes. Added AuthorizationId and AuthorizationDocumentId to match with the ssp_ListPageWhiteBoard result set   */
/****************************************************************************************************/
BEGIN
    CREATE TABLE #Beds
    (
        SequenceNumber                    INT           IDENTITY NOT NULL,
        BedId                             INT          ,
        BedName                           VARCHAR (200),
        DisplayAs                         VARCHAR (200),
        ClientId                          INT          ,
        ClientName                        VARCHAR (200),
        FallsPrecaution                   CHAR (1)     ,
        BleedingPrecaution                CHAR (1)     ,
        SeizuresPrecaution                CHAR (1)     ,
        BulimiaProtocolPrecaution         CHAR (1)     ,
        UrinaryIncontinencePrecaution     CHAR (1)     ,
        InfectionPrecaution               CHAR (1)     ,
        OtherPrecaution                   CHAR (1)     ,
        FallsPrecautionText               VARCHAR (200),
        BleedingPrecautionText            VARCHAR (200),
        SeizuresPrecautionText            VARCHAR (200),
        BulimiaProtocolPrecautionText     VARCHAR (200),
        UrinaryIncontinencePrecautionText VARCHAR (200),
        InfectionPrecautionText           VARCHAR (200),
        OtherPrecautionText               VARCHAR (200),
        PrimaryClinicianId                INT          ,
        PrimaryPhysicianId                INT          ,
        Therapist                         VARCHAR (200),
        Attending                         VARCHAR (200),
        DOA                               DATETIME     ,
        EDD                               DATETIME     ,
        LCD                               DATETIME     ,
        LOS                               INT          ,
        MiscellaneousText                 VARCHAR (200),
        DandA                             INT          ,
        DandAText                         VARCHAR (200),
        WhiteBoardInfoId                  INT          ,
        Color                             VARCHAR (200),
        LegalStatus                       VARCHAR (200),
        OrderLevel                        VARCHAR (200),
        UO                                INT          ,
        Observations                      VARCHAR (200),
        OverdueMedicationCount            INT          ,
        ClientInpatientVisitId            INT          ,
        Unit							  VARCHAR (200),
        DueMedicationCount                INT,
        RenewalFlag						  CHAR,
        AuthorizationId					  INT,
        AuthorizationDocumentId			  INT,
        RowNumber                         BIGINT       
    );
    
    CREATE Table #ClientOrder
    (
		ClientId		INT,
		ClientOrderId	INT,
		OrderName		VARCHAR(200)
	)
    -- Get a list of Active Rooms    
   INSERT INTO #Beds (BedId, BedName, DisplayAs, ClientId, ClientName, FallsPrecaution, BleedingPrecaution, SeizuresPrecaution, BulimiaProtocolPrecaution, UrinaryIncontinencePrecaution, InfectionPrecaution, OtherPrecaution, FallsPrecautionText, BleedingPrecautionText, SeizuresPrecautionText, BulimiaProtocolPrecautionText, UrinaryIncontinencePrecautionText, InfectionPrecautionText, OtherPrecautionText, PrimaryClinicianId, PrimaryPhysicianId, Therapist, Attending, DOA, EDD, LCD, LOS, MiscellaneousText, DandA, DandAText, WhiteBoardInfoId, Color, LegalStatus, OrderLevel, UO, Observations, OverdueMedicationCount, ClientInpatientVisitId,Unit,DueMedicationCount,RenewalFlag, AuthorizationId, AuthorizationDocumentId, RowNumber)
   EXECUTE ssp_ListPageWhiteBoard @PageNumber, @PageSize, @SortExpression, @DateFilter, @UnitsFilter, @AttendingFilter, @DAFilter,@BedFilter, @OtherFilter, 1;
    
   INSERT INTO #ClientOrder (ClientId, ClientOrderId, OrderName)
   EXECUTE ssp_ListPageWhiteBoard @PageNumber, @PageSize, @SortExpression, @DateFilter, @UnitsFilter, @AttendingFilter, @DAFilter,@BedFilter, @OtherFilter, 2;
    
    
    SELECT @TotalBeds = COUNT(BedId)
    FROM   #Beds;
    -- Delete Rooms that will not be displayed in the current page    
    DELETE #Beds
    WHERE  SequenceNumber > @PageSize * @CurrentPageNumber;
    DELETE #Beds
    WHERE  SequenceNumber <= @PageSize * (@CurrentPageNumber - 1);
   
    SELECT *
    FROM   #Beds Order by Unit,DisplayAs;
    
    SELECT *
    FROM   #ClientOrder
   
    DROP TABLE #Beds;
END