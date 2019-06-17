
namespace SHS.SmartCare
{
    public partial class ASAM2 : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            ASAMDynamic1.TableNameCustomASAMLevelOfCares = "CustomASAMLevelOfCares";
            ASAMDynamic1.TableNameCustomASAMPlacements = "CustomASAMPlacements";
            ASAMDynamic1.ColumnNameLeftDimensionDescription = "Dimension3Description";
            ASAMDynamic1.ColumnNameRightDimensionDescription = "Dimension4Description";
            ASAMDynamic1.ColumnNameLeftDimensionLevelOfCare = "Dimension3LevelOfCare";
            ASAMDynamic1.ColumnNameRightDimensionLevelOfCare = "Dimension4LevelOfCare";
            ASAMDynamic1.ColumnNameLevelOfCareName = "LevelOfCareName";
            ASAMDynamic1.Value = "ASAMLevelOfCareId";
            ASAMDynamic1.TextValueLeftDimensionDescription = "Dimension3Description";
            ASAMDynamic1.TextValueRightDimensionDescription = "Dimension4Description";
            ASAMDynamic1.ColumnNameLeftDimensionNeed = "Dimension3Need";
            ASAMDynamic1.ColumnNameRightDimensionNeed = "Dimension4Need";

            ASAMDynamic1.LeftDimensionDescriptionTitle = "Dimension 3: Emotional, Behavioral or Cognitive Conditions and Complications";
            ASAMDynamic1.RightDimensionDescriptionTitle = "Dimension 4: Readiness to Change";
            ASAMDynamic1.LeftDimensionNeedTitle = "Describe Dimension 3 Problem/Need";
            ASAMDynamic1.RightDimensionNeedTitle = "Describe Dimension 4 Problem/Need";


            ASAMDynamic1.BindDimensions();
        }
    }
}
