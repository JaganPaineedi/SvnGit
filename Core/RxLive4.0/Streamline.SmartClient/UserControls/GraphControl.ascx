<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GraphControl.ascx.cs"
    Inherits="Streamline.SmartClient.UI.UserControls_GraphControl" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<div style="text-align: center">

    <telerik:RadChart Height="200" Width="650" ID="RadChartHealthData" runat="server"
        Skin="Telerik" IntelligentLabelsEnabled="true">
        <ChartTitle TextBlock-Text="Health Data">
            <TextBlock Text="Health Data" Appearance-Position-AlignedPosition="Center">
                <Appearance  TextProperties-Font="Verdana, 10pt" TextProperties-Color="Black" Position-AlignedPosition="Center">
                </Appearance>
            </TextBlock>
        </ChartTitle>
        <PlotArea>
            <EmptySeriesMessage TextBlock-Text="No data found for the period specified." >
            </EmptySeriesMessage>  
        </PlotArea>  
    </telerik:RadChart>
</div>
