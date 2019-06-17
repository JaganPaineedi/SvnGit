
IF EXISTS(SELECT ScreenId FROM dbo.Screens WHERE ISNULL(RecordDeleted,'N')='N')
BEGIN
  UPDATE screens SET ScreenURL='/ScreenToolBars/ServiceNoteErrorPopUp.ascx' , ScreenName='NoteError' WHERE ScreenId=2220 AND ISNULL(RecordDeleted,'N')='N'
END	