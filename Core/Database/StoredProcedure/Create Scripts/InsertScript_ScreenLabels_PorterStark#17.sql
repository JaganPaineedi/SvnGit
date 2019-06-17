
---------------------------------------------------------
--Author : Kaushal Pandey
--Date   : 20/Dec/2018
--Purpose: To insert OverrideText in ScreenLabels Table for.Ref :#17 Porter Starke-Enhancements Go Live.
---------------------------------------------------------
Declare @ScreenId Int
Declare @ScreenType Int
Declare @TabControlId varchar(500)
Declare @LabelControlId varchar(500) 
Declare @NearestControlId varchar(500)
Declare @OriginalText varchar(500)
Declare @OverrideText varchar(500)

Set @ScreenId = 1077
Set @ScreenType = 5763
Set @TabControlId = 'CarePlanTabPageInstance_C0'
Set @LabelControlId = 'span_MHLoc'
Set @NearestControlId = 'DivCarePlanGeneral'
Set @OriginalText = 'MH Assessment Level of Care:'
Set @OverrideText = 'Level of Care:'

If Not Exists (Select 1 From ScreenLabels Where ScreenId = @ScreenId And TabControlId = @TabControlId and LabelControlId = @LabelControlId)
Begin
	Insert Into ScreenLabels (ScreenId, ScreenType,LabelHasId,LabelControlId,NearestControlId,TabControlId,OriginalText,[Override],OverrideText)
		Values( @ScreenId, @ScreenType,'Y',@LabelControlId,@NearestControlId,@TabControlId,@OriginalText,'Y',@OverrideText)
End