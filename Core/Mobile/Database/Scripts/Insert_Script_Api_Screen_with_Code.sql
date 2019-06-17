IF NOT EXISTS
(
    SELECT 1
    FROM Screens
    WHERE Code = 'APIMYPREFERENCE' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIMYPREFERENCE',
         '/api/mypreference',
         5767,
         '/api/mypreference',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE Code = 'APIPATIENTPRIMARYCLINICIAN' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIPATIENTPRIMARYCLINICIAN',
         '/api/Patient/PrimaryClinician',
         5767,
         '/api/Patient/PrimaryClinician',
         NULL,
         7
        );
    END;

		IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APIPATIENTPROGRAMCLINICIAN' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIPATIENTPROGRAMCLINICIAN',
         '/api/Patient/ProgramClinicians',
         5767,
         '/api/Patient/ProgramClinicians',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APIPATIENTUPDATEPAYMENT' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIPATIENTUPDATEPAYMENT',
         '/api/Patient/UpdatePayment',
         5767,
         '/api/Patient/UpdatePayment',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APIPATIENTGETAPPOINTMENTS' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIPATIENTGETAPPOINTMENTS',
         '/api/Patient/GetAppointments',
         5767,
         '/api/Patient/GetAppointments',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APIPATIENTBALANCE' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIPATIENTBALANCE',
         '/api/Patient/Balance',
         5767,
         '/api/Patient/Balance',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APICALENDAREVENTCANCELAPPOINTMENT' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APICALENDAREVENTCANCELAPPOINTMENT',
         '/api/calendarevent/CancelAppointment',
         5767,
         '/api/calendarevent/CancelAppointment',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APICALENDAREVENTCREATEAPPOINTMENT' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APICALENDAREVENTCREATEAPPOINTMENT',
         '/api/calendarevent/CreateAppointment',
         5767,
         '/api/calendarevent/CreateAppointment',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APICALENDAREVENTGETAPPOINTMENT' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APICALENDAREVENTGETAPPOINTMENT',
         '/api/calendarevent/GetAppointment',
         5767,
         '/api/calendarevent/GetAppointment',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APIPATIENTAPPOINTMENTSEARCH' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIPATIENTAPPOINTMENTSEARCH',
         '/api/Patient/AppointmentSearch',
         5767,
         '/api/Patient/AppointmentSearch',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APICOMMONGETGLOBALCODES' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APICOMMONGETGLOBALCODES',
         '/api/Common/GetGlobalCodes',
         5767,
         '/api/Common/GetGlobalCodes',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APIPATIENTGETDOCUMENT' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIPATIENTGETDOCUMENT',
         '/api/Patient/GetDocument',
         5767,
         '/api/Patient/GetDocument',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE code = 'APIPATIENTDOCUMENTS' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIPATIENTDOCUMENTS',
         '/api/Patient/Documents',
         5767,
         '/api/Patient/Documents',
         NULL,
         7
        );
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE Code = 'APIPATIENTSERVICEDROPDOWNDETAILS' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIPATIENTSERVICEDROPDOWNDETAILS',
         '/api/Patient/ServiceDropdownDetails',
         5767,
         '/api/Patient/ServiceDropdownDetails',
         NULL,
         7
        );
    END;
	
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE Code = 'APIPATIENTCREATESERVICE' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('APIPATIENTCREATESERVICE',
         '/api/Patient/CreateService',
         5767,
         '/api/Patient/CreateService',
         NULL,
         7
        );
    END;	