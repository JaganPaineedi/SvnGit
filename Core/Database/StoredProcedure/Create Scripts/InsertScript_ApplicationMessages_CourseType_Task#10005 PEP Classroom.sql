
---------------------------------------
--Author: Abhishek
--Purpose: Task#10005 - PEP Classroom : Error message for Course Type detail page to check for required fields.
--------------------------------------

DECLARE @APPLICATIONMESSAGEID int

-------------INSERT SCRIPT FOR MESSAGE CODE REQCOURSETYPE
IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSETYPE'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'REQCOURSETYPE', 'Course Information – Course Type is required.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSETYPE'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSETYPE'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END

-------------INSERT SCRIPT FOR MESSAGE CODE REQCOURSEGROUP
IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSEGROUP'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'REQCOURSEGROUP', 'Course Information – Course Group is required.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSEGROUP'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSEGROUP'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END

-------------INSERT SCRIPT FOR MESSAGE CODE REQPOINTS
IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQPOINTS'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'REQPOINTS', 'Course Information – Points is required.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'REQPOINTS'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQPOINTS'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END

-------------INSERT SCRIPT FOR MESSAGE CODE REQNUMBEROFCREDITS
IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQNUMBEROFCREDITS'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'REQNUMBEROFCREDITS', 'Course Information – Number of credits is required.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'REQNUMBEROFCREDITS'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQNUMBEROFCREDITS'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END

-------------INSERT SCRIPT FOR MESSAGE CODE REQTESTMODE
IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQTESTMODE'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'REQTESTMODE', 'Course Information – Test mode is required.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'REQTESTMODE'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQTESTMODE'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END
-------------INSERT SCRIPT FOR MESSAGE CODE REQCOURSELEVEL
IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSELEVEL'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'REQCOURSELEVEL', 'Course Information – Course Level is required.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSELEVEL'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSELEVEL'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END

-------------INSERT SCRIPT FOR MESSAGE CODE REQHSCREDIT
IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQHSCREDIT'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'REQHSCREDIT', 'CourseInformation – HS Credit is required.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'REQHSCREDIT'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQHSCREDIT'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END
-------------INSERT SCRIPT FOR MESSAGE CODE REQCOURSELEVEL
IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSECODE'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'REQCOURSECODE', 'Course Information – Course code is required.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSECODE'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQCOURSECODE'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END
-------------INSERT SCRIPT FOR MESSAGE CODE REQLENGTHOFINSTRUCTION
IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQLENGTHOFINSTRUCTION'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'REQLENGTHOFINSTRUCTION', 'Course Information – Length of instruction is required.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'REQLENGTHOFINSTRUCTION'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQLENGTHOFINSTRUCTION'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END

-------------INSERT SCRIPT FOR MESSAGE CODE DUPLICATECOURSETYPE
IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'DUPLICATECOURSETYPE'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'DUPLICATECOURSETYPE', 'Combination of Course Type and Course Group already exists.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'DUPLICATECOURSETYPE'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'DUPLICATECOURSETYPE'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END

-------------INSERT SCRIPT FOR MESSAGE CODE REQSTAFFNAME

IF NOT EXISTS (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQSTAFFNAME'
  AND PrimaryScreenId = 1316)
BEGIN
  INSERT INTO ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText)
    VALUES (1316, 'REQSTAFFNAME', 'Highly Qualified Teachers – Staff Name is required.')
END

IF EXISTS (SELECT
    @APPLICATIONMESSAGEID
  FROM ApplicationMessages
  WHERE MessageCode = 'REQSTAFFNAME'
  AND PrimaryScreenId = 1316)
BEGIN
  SET @APPLICATIONMESSAGEID = (SELECT
    ApplicationMessageId
  FROM ApplicationMessages
  WHERE MessageCode = 'REQSTAFFNAME'
  AND PrimaryScreenId = 1316)
  IF NOT EXISTS (SELECT
      *
    FROM ApplicationMessageScreens
    WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
  BEGIN
    INSERT INTO ApplicationMessageScreens (ApplicationMessageId, ScreenId)
      VALUES (@APPLICATIONMESSAGEID, 1316);
  END
END