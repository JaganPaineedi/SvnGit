
IF EXISTS
(
    SELECT GlobalCodeId
    FROM GlobalCodes
    WHERE Category = 'NOTIFICATIONTYPE'
          AND Code = 'NOTIFIACTIONTYPEALERT'
)
    BEGIN
        UPDATE GlobalCodes
          SET
              CodeName = 'Alerts',
			  Code = 'NOTIFICATIONTYPEALERTS'
        WHERE Category = 'NOTIFICATIONTYPE'
              AND Code = 'NOTIFIACTIONTYPEALERT';
    END;
IF EXISTS
(
    SELECT GlobalCodeId
    FROM GlobalCodes
    WHERE Category = 'NOTIFICATIONTYPE'
          AND Code = 'NOTIFIACTIONTYPMESSAGE'
)
    BEGIN
        UPDATE GlobalCodes
          SET
              CodeName = 'Messages',
			  Code = 'NOTIFICATIONTYPEMESSAGES'
        WHERE Category = 'NOTIFICATIONTYPE'
              AND Code = 'NOTIFIACTIONTYPMESSAGE';
    END;

IF EXISTS
(
    SELECT GlobalCodeId
    FROM GlobalCodes
    WHERE Category = 'NOTIFICATIONTYPE'
          AND Code = 'NOTIFIACTIONTYPERECEPTION'
)
    BEGIN
        UPDATE GlobalCodes
          SET
              CodeName = 'Reception',
			  Code = 'NOTIFICATIONTYPERECEPTION'
        WHERE Category = 'NOTIFICATIONTYPE'
              AND Code = 'NOTIFIACTIONTYPERECEPTION';
    END;
