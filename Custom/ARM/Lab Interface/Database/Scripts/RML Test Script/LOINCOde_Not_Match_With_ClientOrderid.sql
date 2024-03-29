Declare @Input xml

Set @Input=Convert(Xml,'<?xml version="1.0" encoding="utf-8"?>
<HL7Message>
  <MSH>
    <MSH.0>
      <MSH.0.0>
        <ITEM>MSH</ITEM>
      </MSH.0.0>
    </MSH.0>
    <MSH.1>
      <MSH.1.0>
        <ITEM>|</ITEM>
      </MSH.1.0>
    </MSH.1>
    <MSH.2>
      <MSH.2.0>
        <ITEM>^~\&amp;</ITEM>
      </MSH.2.0>
    </MSH.2>
    <MSH.3>
      <MSH.3.0>
        <ITEM>RML</ITEM>
      </MSH.3.0>
    </MSH.3>
    <MSH.4>
      <MSH.4.0>
        <ITEM></ITEM>
      </MSH.4.0>
    </MSH.4>
    <MSH.5>
      <MSH.5.0>
        <ITEM></ITEM>
      </MSH.5.0>
    </MSH.5>
    <MSH.6>
      <MSH.6.0>
        <ITEM></ITEM>
      </MSH.6.0>
    </MSH.6>
    <MSH.7>
      <MSH.7.0>
        <ITEM>20140212141211</ITEM>
      </MSH.7.0>
    </MSH.7>
    <MSH.8>
      <MSH.8.0>
        <ITEM></ITEM>
      </MSH.8.0>
    </MSH.8>
    <MSH.9>
      <MSH.9.0>
        <ITEM>ORU</ITEM>
      </MSH.9.0>
      <MSH.9.1>
        <ITEM>R01</ITEM>
      </MSH.9.1>
    </MSH.9>
    <MSH.10>
      <MSH.10.0>
        <ITEM>Q210107382T238080227</ITEM>
      </MSH.10.0>
    </MSH.10>
    <MSH.11>
      <MSH.11.0>
        <ITEM>T</ITEM>
      </MSH.11.0>
    </MSH.11>
    <MSH.12>
      <MSH.12.0>
        <ITEM>2.2</ITEM>
      </MSH.12.0>
    </MSH.12>
    <MSH.13>
      <MSH.13.0>
        <ITEM></ITEM>
      </MSH.13.0>
    </MSH.13>
  </MSH>
  <PID>
    <PID.0>
      <PID.0.0>
        <ITEM>PID</ITEM>
      </PID.0.0>
    </PID.0>
    <PID.1>
      <PID.1.0>
        <ITEM>1</ITEM>
      </PID.1.0>
    </PID.1>
    <PID.2>
      <PID.2.0>
        <ITEM>349_NC</ITEM>
      </PID.2.0>
      <PID.2.1>
        <ITEM></ITEM>
      </PID.2.1>
      <PID.2.2>
        <ITEM></ITEM>
      </PID.2.2>
      <PID.2.3>
        <ITEM>RML  MRN Pool</ITEM>
      </PID.2.3>
      <PID.2.4>
        <ITEM>MRN</ITEM>
      </PID.2.4>
      <PID.2.5>
        <ITEM>RML_DATA</ITEM>
      </PID.2.5>
    </PID.2>
    <PID.3>
      <PID.3.0>
        <ITEM>349_NC</ITEM>
      </PID.3.0>
      <PID.3.1>
        <ITEM></ITEM>
      </PID.3.1>
      <PID.3.2>
        <ITEM></ITEM>
      </PID.3.2>
      <PID.3.3>
        <ITEM>RML  MRN Pool</ITEM>
      </PID.3.3>
      <PID.3.4>
        <ITEM>MRN</ITEM>
      </PID.3.4>
      <PID.3.5>
        <ITEM>RML_DATA</ITEM>
      </PID.3.5>
    </PID.3>
    <PID.4>
      <PID.4.0>
        <ITEM>UNKNOWN_NC</ITEM>
      </PID.4.0>
      <PID.4.1>
        <ITEM></ITEM>
      </PID.4.1>
      <PID.4.2>
        <ITEM></ITEM>
      </PID.4.2>
      <PID.4.3>
        <ITEM>RMLDATA Referring MRN</ITEM>
      </PID.4.3>
      <PID.4.4>
        <ITEM>Referring MRN</ITEM>
      </PID.4.4>
      <PID.4.5>
        <ITEM>RML_DATA</ITEM>
      </PID.4.5>
    </PID.4>
    <PID.4>
      <PID.4.0>
        <ITEM>349_NC</ITEM>
      </PID.4.0>
      <PID.4.1>
        <ITEM></ITEM>
      </PID.4.1>
      <PID.4.2>
        <ITEM></ITEM>
      </PID.4.2>
      <PID.4.3>
        <ITEM>RMLDATA Referring MRN</ITEM>
      </PID.4.3>
      <PID.4.4>
        <ITEM>Referring MRN</ITEM>
      </PID.4.4>
      <PID.4.5>
        <ITEM>RML_DATA</ITEM>
      </PID.4.5>
    </PID.4>
    <PID.5>
      <PID.5.0>
        <ITEM>David</ITEM>
      </PID.5.0>
      <PID.5.1>
        <ITEM>Mang</ITEM>
      </PID.5.1>
      <PID.5.2>
        <ITEM></ITEM>
      </PID.5.2>
      <PID.5.3>
        <ITEM></ITEM>
      </PID.5.3>
      <PID.5.4>
        <ITEM></ITEM>
      </PID.5.4>
      <PID.5.5>
        <ITEM></ITEM>
      </PID.5.5>
      <PID.5.6>
        <ITEM>Current</ITEM>
      </PID.5.6>
    </PID.5>
    <PID.6>
      <PID.6.0>
        <ITEM></ITEM>
      </PID.6.0>
    </PID.6>
    <PID.7>
      <PID.7.0>
        <ITEM>19910128000000</ITEM>
      </PID.7.0>
    </PID.7>
    <PID.8>
      <PID.8.0>
        <ITEM></ITEM>
      </PID.8.0>
    </PID.8>
    <PID.9>
      <PID.9.0>
        <ITEM></ITEM>
      </PID.9.0>
    </PID.9>
    <PID.10>
      <PID.10.0>
        <ITEM></ITEM>
      </PID.10.0>
    </PID.10>
    <PID.11>
      <PID.11.0>
        <ITEM></ITEM>
      </PID.11.0>
    </PID.11>
    <PID.12>
      <PID.12.0>
        <ITEM></ITEM>
      </PID.12.0>
    </PID.12>
    <PID.13>
      <PID.13.0>
        <ITEM></ITEM>
      </PID.13.0>
    </PID.13>
    <PID.14>
      <PID.14.0>
        <ITEM></ITEM>
      </PID.14.0>
    </PID.14>
    <PID.15>
      <PID.15.0>
        <ITEM></ITEM>
      </PID.15.0>
    </PID.15>
    <PID.16>
      <PID.16.0>
        <ITEM></ITEM>
      </PID.16.0>
    </PID.16>
    <PID.17>
      <PID.17.0>
        <ITEM></ITEM>
      </PID.17.0>
    </PID.17>
    <PID.18>
      <PID.18.0>
        <ITEM>5808236</ITEM>
      </PID.18.0>
      <PID.18.1>
        <ITEM></ITEM>
      </PID.18.1>
      <PID.18.2>
        <ITEM></ITEM>
      </PID.18.2>
      <PID.18.3>
        <ITEM>RML Fin Nbr</ITEM>
      </PID.18.3>
      <PID.18.4>
        <ITEM>FIN NBR</ITEM>
      </PID.18.4>
      <PID.18.5>
        <ITEM>RML_DATA</ITEM>
      </PID.18.5>
    </PID.18>
    <PID.19>
      <PID.19.0>
        <ITEM></ITEM>
      </PID.19.0>
    </PID.19>
    <PID.20>
      <PID.20.0>
        <ITEM></ITEM>
      </PID.20.0>
    </PID.20>
    <PID.21>
      <PID.21.0>
        <ITEM></ITEM>
      </PID.21.0>
    </PID.21>
    <PID.22>
      <PID.22.0>
        <ITEM></ITEM>
      </PID.22.0>
    </PID.22>
    <PID.23>
      <PID.23.0>
        <ITEM></ITEM>
      </PID.23.0>
    </PID.23>
    <PID.24>
      <PID.24.0>
        <ITEM></ITEM>
      </PID.24.0>
    </PID.24>
    <PID.25>
      <PID.25.0>
        <ITEM>0</ITEM>
      </PID.25.0>
    </PID.25>
    <PID.26>
      <PID.26.0>
        <ITEM></ITEM>
      </PID.26.0>
    </PID.26>
  </PID>
  <PV1>
    <PV1.0>
      <PV1.0.0>
        <ITEM>PV1</ITEM>
      </PV1.0.0>
    </PV1.0>
    <PV1.1>
      <PV1.1.0>
        <ITEM>1</ITEM>
      </PV1.1.0>
    </PV1.1>
    <PV1.2>
      <PV1.2.0>
        <ITEM></ITEM>
      </PV1.2.0>
    </PV1.2>
    <PV1.3>
      <PV1.3.0>
        <ITEM>Summit BC</ITEM>
      </PV1.3.0>
      <PV1.3.1>
        <ITEM></ITEM>
      </PV1.3.1>
      <PV1.3.2>
        <ITEM></ITEM>
      </PV1.3.2>
      <PV1.3.3>
        <ITEM>Summit Pointe</ITEM>
      </PV1.3.3>
      <PV1.3.4>
        <ITEM></ITEM>
      </PV1.3.4>
      <PV1.3.5>
        <ITEM></ITEM>
      </PV1.3.5>
      <PV1.3.6>
        <ITEM>Summit Pointe BC</ITEM>
      </PV1.3.6>
    </PV1.3>
    <PV1.4>
      <PV1.4.0>
        <ITEM></ITEM>
      </PV1.4.0>
    </PV1.4>
    <PV1.5>
      <PV1.5.0>
        <ITEM></ITEM>
      </PV1.5.0>
    </PV1.5>
    <PV1.6>
      <PV1.6.0>
        <ITEM></ITEM>
      </PV1.6.0>
    </PV1.6>
    <PV1.7>
      <PV1.7.0>
        <ITEM></ITEM>
      </PV1.7.0>
    </PV1.7>
    <PV1.8>
      <PV1.8.0>
        <ITEM></ITEM>
      </PV1.8.0>
    </PV1.8>
    <PV1.9>
      <PV1.9.0>
        <ITEM></ITEM>
      </PV1.9.0>
    </PV1.9>
    <PV1.10>
      <PV1.10.0>
        <ITEM></ITEM>
      </PV1.10.0>
    </PV1.10>
    <PV1.11>
      <PV1.11.0>
        <ITEM></ITEM>
      </PV1.11.0>
    </PV1.11>
    <PV1.12>
      <PV1.12.0>
        <ITEM></ITEM>
      </PV1.12.0>
    </PV1.12>
    <PV1.13>
      <PV1.13.0>
        <ITEM></ITEM>
      </PV1.13.0>
    </PV1.13>
    <PV1.14>
      <PV1.14.0>
        <ITEM></ITEM>
      </PV1.14.0>
    </PV1.14>
    <PV1.15>
      <PV1.15.0>
        <ITEM></ITEM>
      </PV1.15.0>
    </PV1.15>
    <PV1.16>
      <PV1.16.0>
        <ITEM></ITEM>
      </PV1.16.0>
    </PV1.16>
    <PV1.17>
      <PV1.17.0>
        <ITEM></ITEM>
      </PV1.17.0>
    </PV1.17>
    <PV1.18>
      <PV1.18.0>
        <ITEM>O</ITEM>
      </PV1.18.0>
    </PV1.18>
    <PV1.19>
      <PV1.19.0>
        <ITEM></ITEM>
      </PV1.19.0>
    </PV1.19>
    <PV1.20>
      <PV1.20.0>
        <ITEM></ITEM>
      </PV1.20.0>
    </PV1.20>
    <PV1.21>
      <PV1.21.0>
        <ITEM></ITEM>
      </PV1.21.0>
    </PV1.21>
    <PV1.22>
      <PV1.22.0>
        <ITEM></ITEM>
      </PV1.22.0>
    </PV1.22>
    <PV1.23>
      <PV1.23.0>
        <ITEM></ITEM>
      </PV1.23.0>
    </PV1.23>
    <PV1.24>
      <PV1.24.0>
        <ITEM></ITEM>
      </PV1.24.0>
    </PV1.24>
    <PV1.25>
      <PV1.25.0>
        <ITEM></ITEM>
      </PV1.25.0>
    </PV1.25>
    <PV1.26>
      <PV1.26.0>
        <ITEM></ITEM>
      </PV1.26.0>
    </PV1.26>
    <PV1.27>
      <PV1.27.0>
        <ITEM></ITEM>
      </PV1.27.0>
    </PV1.27>
    <PV1.28>
      <PV1.28.0>
        <ITEM></ITEM>
      </PV1.28.0>
    </PV1.28>
    <PV1.29>
      <PV1.29.0>
        <ITEM></ITEM>
      </PV1.29.0>
    </PV1.29>
    <PV1.30>
      <PV1.30.0>
        <ITEM></ITEM>
      </PV1.30.0>
    </PV1.30>
    <PV1.31>
      <PV1.31.0>
        <ITEM></ITEM>
      </PV1.31.0>
    </PV1.31>
    <PV1.32>
      <PV1.32.0>
        <ITEM></ITEM>
      </PV1.32.0>
    </PV1.32>
    <PV1.33>
      <PV1.33.0>
        <ITEM></ITEM>
      </PV1.33.0>
    </PV1.33>
    <PV1.34>
      <PV1.34.0>
        <ITEM></ITEM>
      </PV1.34.0>
    </PV1.34>
    <PV1.35>
      <PV1.35.0>
        <ITEM></ITEM>
      </PV1.35.0>
    </PV1.35>
    <PV1.36>
      <PV1.36.0>
        <ITEM></ITEM>
      </PV1.36.0>
    </PV1.36>
    <PV1.37>
      <PV1.37.0>
        <ITEM></ITEM>
      </PV1.37.0>
    </PV1.37>
    <PV1.38>
      <PV1.38.0>
        <ITEM></ITEM>
      </PV1.38.0>
    </PV1.38>
    <PV1.39>
      <PV1.39.0>
        <ITEM>Summit Pointe</ITEM>
      </PV1.39.0>
    </PV1.39>
    <PV1.40>
      <PV1.40.0>
        <ITEM></ITEM>
      </PV1.40.0>
    </PV1.40>
    <PV1.41>
      <PV1.41.0>
        <ITEM></ITEM>
      </PV1.41.0>
    </PV1.41>
    <PV1.42>
      <PV1.42.0>
        <ITEM></ITEM>
      </PV1.42.0>
    </PV1.42>
    <PV1.43>
      <PV1.43.0>
        <ITEM></ITEM>
      </PV1.43.0>
    </PV1.43>
    <PV1.44>
      <PV1.44.0>
        <ITEM>20140212000000</ITEM>
      </PV1.44.0>
    </PV1.44>
    <PV1.45>
      <PV1.45.0>
        <ITEM></ITEM>
      </PV1.45.0>
    </PV1.45>
  </PV1>
  <ORC>
    <ORC.0>
      <ORC.0.0>
        <ITEM>ORC</ITEM>
      </ORC.0.0>
    </ORC.0>
    <ORC.1>
      <ORC.1.0>
        <ITEM>RE</ITEM>
      </ORC.1.0>
    </ORC.1>
    <ORC.2>
      <ORC.2.0>
        <ITEM>50</ITEM>
      </ORC.2.0>
    </ORC.2>
    <ORC.3>
      <ORC.3.0>
        <ITEM>132044068</ITEM>
      </ORC.3.0>
    </ORC.3>
    <ORC.4>
      <ORC.4.0>
        <ITEM></ITEM>
      </ORC.4.0>
    </ORC.4>
    <ORC.5>
      <ORC.5.0>
        <ITEM>CM</ITEM>
      </ORC.5.0>
    </ORC.5>
    <ORC.6>
      <ORC.6.0>
        <ITEM></ITEM>
      </ORC.6.0>
    </ORC.6>
    <ORC.7>
      <ORC.7.0>
        <ITEM>1</ITEM>
      </ORC.7.0>
      <ORC.7.1>
        <ITEM></ITEM>
      </ORC.7.1>
      <ORC.7.2>
        <ITEM></ITEM>
      </ORC.7.2>
      <ORC.7.3>
        <ITEM>20140212000000</ITEM>
      </ORC.7.3>
      <ORC.7.4>
        <ITEM></ITEM>
      </ORC.7.4>
      <ORC.7.5>
        <ITEM>R</ITEM>
      </ORC.7.5>
    </ORC.7>
    <ORC.7>
      <ORC.7.0>
        <ITEM></ITEM>
      </ORC.7.0>
      <ORC.7.1>
        <ITEM></ITEM>
      </ORC.7.1>
      <ORC.7.2>
        <ITEM></ITEM>
      </ORC.7.2>
      <ORC.7.3>
        <ITEM></ITEM>
      </ORC.7.3>
      <ORC.7.4>
        <ITEM></ITEM>
      </ORC.7.4>
      <ORC.7.5>
        <ITEM>9</ITEM>
      </ORC.7.5>
    </ORC.7>
    <ORC.8>
      <ORC.8.0>
        <ITEM></ITEM>
      </ORC.8.0>
    </ORC.8>
    <ORC.9>
      <ORC.9.0>
        <ITEM></ITEM>
      </ORC.9.0>
    </ORC.9>
    <ORC.10>
      <ORC.10.0>
        <ITEM></ITEM>
      </ORC.10.0>
    </ORC.10>
    <ORC.11>
      <ORC.11.0>
        <ITEM></ITEM>
      </ORC.11.0>
    </ORC.11>
    <ORC.12>
      <ORC.12.0>
        <ITEM>1871628628</ITEM>
      </ORC.12.0>
      <ORC.12.1>
        <ITEM>GANDY</ITEM>
      </ORC.12.1>
      <ORC.12.2>
        <ITEM>JAMES</ITEM>
      </ORC.12.2>
      <ORC.12.3>
        <ITEM></ITEM>
      </ORC.12.3>
      <ORC.12.4>
        <ITEM></ITEM>
      </ORC.12.4>
      <ORC.12.5>
        <ITEM></ITEM>
      </ORC.12.5>
      <ORC.12.6>
        <ITEM></ITEM>
      </ORC.12.6>
      <ORC.12.7>
        <ITEM>NPI</ITEM>
      </ORC.12.7>
    </ORC.12>
    <ORC.13>
      <ORC.13.0>
        <ITEM></ITEM>
      </ORC.13.0>
    </ORC.13>
  </ORC>
  <OBR>
    <OBR.0>
      <OBR.0.0>
        <ITEM>OBR</ITEM>
      </OBR.0.0>
    </OBR.0>
    <OBR.1>
      <OBR.1.0>
        <ITEM>1</ITEM>
      </OBR.1.0>
    </OBR.1>
    <OBR.2>
      <OBR.2.0>
        <ITEM>6</ITEM>
      </OBR.2.0>
    </OBR.2>
    <OBR.3>
      <OBR.3.0>
        <ITEM>132044068</ITEM>
      </OBR.3.0>
    </OBR.3>
    <OBR.4>
      <OBR.4.0>
        <ITEM>4041</ITEM>
      </OBR.4.0>
      <OBR.4.1>
        <ITEM>NAttributes</ITEM>
      </OBR.4.1>
    </OBR.4>
    <OBR.5>
      <OBR.5.0>
        <ITEM></ITEM>
      </OBR.5.0>
    </OBR.5>
    <OBR.6>
      <OBR.6.0>
        <ITEM></ITEM>
      </OBR.6.0>
    </OBR.6>
    <OBR.7>
      <OBR.7.0>
        <ITEM>20140212123000</ITEM>
      </OBR.7.0>
    </OBR.7>
    <OBR.8>
      <OBR.8.0>
        <ITEM></ITEM>
      </OBR.8.0>
    </OBR.8>
    <OBR.9>
      <OBR.9.0>
        <ITEM></ITEM>
      </OBR.9.0>
    </OBR.9>
    <OBR.10>
      <OBR.10.0>
        <ITEM></ITEM>
      </OBR.10.0>
      <OBR.10.1>
        <ITEM>CONTRIBUTOR_SYSTEM</ITEM>
      </OBR.10.1>
      <OBR.10.2>
        <ITEM>RML_DATA</ITEM>
      </OBR.10.2>
      <OBR.10.3>
        <ITEM></ITEM>
      </OBR.10.3>
      <OBR.10.4>
        <ITEM></ITEM>
      </OBR.10.4>
      <OBR.10.5>
        <ITEM></ITEM>
      </OBR.10.5>
      <OBR.10.6>
        <ITEM></ITEM>
      </OBR.10.6>
      <OBR.10.7>
        <ITEM></ITEM>
      </OBR.10.7>
      <OBR.10.8>
        <ITEM></ITEM>
      </OBR.10.8>
      <OBR.10.9>
        <ITEM>PRSNL</ITEM>
      </OBR.10.9>
    </OBR.10>
    <OBR.11>
      <OBR.11.0>
        <ITEM></ITEM>
      </OBR.11.0>
    </OBR.11>
    <OBR.12>
      <OBR.12.0>
        <ITEM></ITEM>
      </OBR.12.0>
    </OBR.12>
    <OBR.13>
      <OBR.13.0>
        <ITEM></ITEM>
      </OBR.13.0>
    </OBR.13>
    <OBR.14>
      <OBR.14.0>
        <ITEM>20140212125300</ITEM>
      </OBR.14.0>
    </OBR.14>
    <OBR.15>
      <OBR.15.0>
        <ITEM>BLOOD</ITEM>
        <SUB>
          <ITEM>Blood</ITEM>
        </SUB>
      </OBR.15.0>
    </OBR.15>
    <OBR.16>
      <OBR.16.0>
        <ITEM>GANDY</ITEM>
      </OBR.16.0>
      <OBR.16.1>
        <ITEM>GANDY</ITEM>
      </OBR.16.1>
      <OBR.16.2>
        <ITEM>JAMES</ITEM>
      </OBR.16.2>
      <OBR.16.3>
        <ITEM></ITEM>
      </OBR.16.3>
      <OBR.16.4>
        <ITEM></ITEM>
      </OBR.16.4>
      <OBR.16.5>
        <ITEM></ITEM>
      </OBR.16.5>
      <OBR.16.6>
        <ITEM></ITEM>
      </OBR.16.6>
      <OBR.16.7>
        <ITEM>NPI</ITEM>
      </OBR.16.7>
    </OBR.16>
    <OBR.17>
      <OBR.17.0>
        <ITEM></ITEM>
      </OBR.17.0>
    </OBR.17>
    <OBR.18>
      <OBR.18.0>
        <ITEM></ITEM>
      </OBR.18.0>
    </OBR.18>
    <OBR.19>
      <OBR.19.0>
        <ITEM></ITEM>
      </OBR.19.0>
    </OBR.19>
    <OBR.20>
      <OBR.20.0>
        <ITEM>000002014043000001</ITEM>
      </OBR.20.0>
    </OBR.20>
    <OBR.20>
      <OBR.20.0>
        <ITEM>8077262</ITEM>
      </OBR.20.0>
    </OBR.20>
    <OBR.21>
      <OBR.21.0>
        <ITEM>16370030</ITEM>
      </OBR.21.0>
    </OBR.21>
    <OBR.22>
      <OBR.22.0>
        <ITEM>20140212130404</ITEM>
      </OBR.22.0>
    </OBR.22>
    <OBR.23>
      <OBR.23.0>
        <ITEM></ITEM>
      </OBR.23.0>
    </OBR.23>
    <OBR.24>
      <OBR.24.0>
        <ITEM>GLB</ITEM>
      </OBR.24.0>
    </OBR.24>
    <OBR.25>
      <OBR.25.0>
        <ITEM>F</ITEM>
      </OBR.25.0>
    </OBR.25>
    <OBR.26>
      <OBR.26.0>
        <ITEM></ITEM>
      </OBR.26.0>
    </OBR.26>
    <OBR.27>
      <OBR.27.0>
        <ITEM>1</ITEM>
      </OBR.27.0>
      <OBR.27.1>
        <ITEM></ITEM>
      </OBR.27.1>
      <OBR.27.2>
        <ITEM></ITEM>
      </OBR.27.2>
      <OBR.27.3>
        <ITEM>20140212000000</ITEM>
      </OBR.27.3>
      <OBR.27.4>
        <ITEM></ITEM>
      </OBR.27.4>
      <OBR.27.5>
        <ITEM>R</ITEM>
      </OBR.27.5>
    </OBR.27>
    <OBR.27>
      <OBR.27.0>
        <ITEM></ITEM>
      </OBR.27.0>
      <OBR.27.1>
        <ITEM></ITEM>
      </OBR.27.1>
      <OBR.27.2>
        <ITEM></ITEM>
      </OBR.27.2>
      <OBR.27.3>
        <ITEM></ITEM>
      </OBR.27.3>
      <OBR.27.4>
        <ITEM></ITEM>
      </OBR.27.4>
      <OBR.27.5>
        <ITEM>9</ITEM>
      </OBR.27.5>
    </OBR.27>
    <OBR.28>
      <OBR.28.0>
        <ITEM></ITEM>
      </OBR.28.0>
    </OBR.28>
    <OBR.29>
      <OBR.29.0>
        <ITEM></ITEM>
      </OBR.29.0>
    </OBR.29>
    <OBR.30>
      <OBR.30.0>
        <ITEM></ITEM>
      </OBR.30.0>
    </OBR.30>
    <OBR.31>
      <OBR.31.0>
        <ITEM></ITEM>
      </OBR.31.0>
    </OBR.31>
    <OBR.32>
      <OBR.32.0>
        <ITEM></ITEM>
      </OBR.32.0>
    </OBR.32>
    <OBR.33>
      <OBR.33.0>
        <ITEM></ITEM>
      </OBR.33.0>
    </OBR.33>
    <OBR.34>
      <OBR.34.0>
        <ITEM></ITEM>
      </OBR.34.0>
    </OBR.34>
    <OBR.35>
      <OBR.35.0>
        <ITEM></ITEM>
      </OBR.35.0>
    </OBR.35>
    <OBR.36>
      <OBR.36.0>
        <ITEM>20140212235900</ITEM>
      </OBR.36.0>
    </OBR.36>
    <OBR.37>
      <OBR.37.0>
        <ITEM></ITEM>
      </OBR.37.0>
    </OBR.37>
  </OBR>
  <OBX>
    <OBX.0>
      <OBX.0.0>
        <ITEM>OBX</ITEM>
      </OBX.0.0>
    </OBX.0>
    <OBX.1>
      <OBX.1.0>
        <ITEM>1</ITEM>
      </OBX.1.0>
    </OBX.1>
    <OBX.2>
      <OBX.2.0>
        <ITEM>NM</ITEM>
      </OBX.2.0>
    </OBX.2>
    <OBX.3>
      <OBX.3.0>
        <ITEM>Cholesterol</ITEM>
      </OBX.3.0>
      <OBX.3.1>
        <ITEM>Cholesterol</ITEM>
      </OBX.3.1>
    </OBX.3>
    <OBX.4>
      <OBX.4.0>
        <ITEM></ITEM>
      </OBX.4.0>
    </OBX.4>
    <OBX.5>
      <OBX.5.0>
        <ITEM>210</ITEM>
      </OBX.5.0>
    </OBX.5>
    <OBX.6>
      <OBX.6.0>
        <ITEM>mg/dL</ITEM>
      </OBX.6.0>
    </OBX.6>
    <OBX.7>
      <OBX.7.0>
        <ITEM>&lt;=200</ITEM>
      </OBX.7.0>
    </OBX.7>
    <OBX.8>
      <OBX.8.0>
        <ITEM>H</ITEM>
      </OBX.8.0>
    </OBX.8>
    <OBX.9>
      <OBX.9.0>
        <ITEM></ITEM>
      </OBX.9.0>
    </OBX.9>
    <OBX.10>
      <OBX.10.0>
        <ITEM>U</ITEM>
      </OBX.10.0>
    </OBX.10>
    <OBX.11>
      <OBX.11.0>
        <ITEM>F</ITEM>
      </OBX.11.0>
    </OBX.11>
    <OBX.12>
      <OBX.12.0>
        <ITEM></ITEM>
      </OBX.12.0>
    </OBX.12>
    <OBX.13>
      <OBX.13.0>
        <ITEM></ITEM>
      </OBX.13.0>
    </OBX.13>
    <OBX.14>
      <OBX.14.0>
        <ITEM>20140212130401</ITEM>
      </OBX.14.0>
    </OBX.14>
    <OBX.15>
      <OBX.15.0>
        <ITEM></ITEM>
      </OBX.15.0>
    </OBX.15>
    <OBX.16>
      <OBX.16.0>
        <ITEM>RML</ITEM>
      </OBX.16.0>
    </OBX.16>
    <OBX.17>
      <OBX.17.0>
        <ITEM></ITEM>
      </OBX.17.0>
      <OBX.17.1>
        <ITEM></ITEM>
      </OBX.17.1>
      <OBX.17.2>
        <ITEM></ITEM>
      </OBX.17.2>
      <OBX.17.3>
        <ITEM>CD:8973036</ITEM>
      </OBX.17.3>
    </OBX.17>
    <OBX.18>
      <OBX.18.0>
        <ITEM></ITEM>
      </OBX.18.0>
    </OBX.18>
    <OBX.19>
      <OBX.19.0>
        <ITEM></ITEM>
      </OBX.19.0>
    </OBX.19>
    <OBX.20>
      <OBX.20.0>
        <ITEM></ITEM>
      </OBX.20.0>
    </OBX.20>
    <OBX.21>
      <OBX.21.0>
        <ITEM></ITEM>
      </OBX.21.0>
    </OBX.21>
    <OBX.22>
      <OBX.22.0>
        <ITEM></ITEM>
      </OBX.22.0>
    </OBX.22>
    <OBX.23>
      <OBX.23.0>
        <ITEM></ITEM>
      </OBX.23.0>
    </OBX.23>
    <OBX.24>
      <OBX.24.0>
        <ITEM></ITEM>
      </OBX.24.0>
    </OBX.24>
    <OBX.25>
      <OBX.25.0>
        <ITEM></ITEM>
      </OBX.25.0>
    </OBX.25>
    <OBX.26>
      <OBX.26.0>
        <ITEM></ITEM>
      </OBX.26.0>
    </OBX.26>
  </OBX>
  <OBX>
    <OBX.0>
      <OBX.0.0>
        <ITEM>OBX</ITEM>
      </OBX.0.0>
    </OBX.0>
    <OBX.1>
      <OBX.1.0>
        <ITEM>2</ITEM>
      </OBX.1.0>
    </OBX.1>
    <OBX.2>
      <OBX.2.0>
        <ITEM>NM</ITEM>
      </OBX.2.0>
    </OBX.2>
    <OBX.3>
      <OBX.3.0>
        <ITEM>HDL Cholesterol</ITEM>
      </OBX.3.0>
      <OBX.3.1>
        <ITEM>HDL Cholesterol</ITEM>
      </OBX.3.1>
    </OBX.3>
    <OBX.4>
      <OBX.4.0>
        <ITEM></ITEM>
      </OBX.4.0>
    </OBX.4>
    <OBX.5>
      <OBX.5.0>
        <ITEM>20</ITEM>
      </OBX.5.0>
    </OBX.5>
    <OBX.6>
      <OBX.6.0>
        <ITEM>mg/dL</ITEM>
      </OBX.6.0>
    </OBX.6>
    <OBX.7>
      <OBX.7.0>
        <ITEM>&gt;=40</ITEM>
      </OBX.7.0>
    </OBX.7>
    <OBX.8>
      <OBX.8.0>
        <ITEM>L</ITEM>
      </OBX.8.0>
    </OBX.8>
    <OBX.9>
      <OBX.9.0>
        <ITEM></ITEM>
      </OBX.9.0>
    </OBX.9>
    <OBX.10>
      <OBX.10.0>
        <ITEM>U</ITEM>
      </OBX.10.0>
    </OBX.10>
    <OBX.11>
      <OBX.11.0>
        <ITEM>F</ITEM>
      </OBX.11.0>
    </OBX.11>
    <OBX.12>
      <OBX.12.0>
        <ITEM></ITEM>
      </OBX.12.0>
    </OBX.12>
    <OBX.13>
      <OBX.13.0>
        <ITEM></ITEM>
      </OBX.13.0>
    </OBX.13>
    <OBX.14>
      <OBX.14.0>
        <ITEM>20140212130401</ITEM>
      </OBX.14.0>
    </OBX.14>
    <OBX.15>
      <OBX.15.0>
        <ITEM></ITEM>
      </OBX.15.0>
    </OBX.15>
    <OBX.16>
      <OBX.16.0>
        <ITEM>RML</ITEM>
      </OBX.16.0>
    </OBX.16>
    <OBX.17>
      <OBX.17.0>
        <ITEM></ITEM>
      </OBX.17.0>
      <OBX.17.1>
        <ITEM></ITEM>
      </OBX.17.1>
      <OBX.17.2>
        <ITEM></ITEM>
      </OBX.17.2>
      <OBX.17.3>
        <ITEM>CD:8973036</ITEM>
      </OBX.17.3>
    </OBX.17>
    <OBX.18>
      <OBX.18.0>
        <ITEM></ITEM>
      </OBX.18.0>
    </OBX.18>
    <OBX.19>
      <OBX.19.0>
        <ITEM></ITEM>
      </OBX.19.0>
    </OBX.19>
    <OBX.20>
      <OBX.20.0>
        <ITEM></ITEM>
      </OBX.20.0>
    </OBX.20>
    <OBX.21>
      <OBX.21.0>
        <ITEM></ITEM>
      </OBX.21.0>
    </OBX.21>
    <OBX.22>
      <OBX.22.0>
        <ITEM></ITEM>
      </OBX.22.0>
    </OBX.22>
    <OBX.23>
      <OBX.23.0>
        <ITEM></ITEM>
      </OBX.23.0>
    </OBX.23>
    <OBX.24>
      <OBX.24.0>
        <ITEM></ITEM>
      </OBX.24.0>
    </OBX.24>
    <OBX.25>
      <OBX.25.0>
        <ITEM></ITEM>
      </OBX.25.0>
    </OBX.25>
    <OBX.26>
      <OBX.26.0>
        <ITEM></ITEM>
      </OBX.26.0>
    </OBX.26>
  </OBX>
  <OBX>
    <OBX.0>
      <OBX.0.0>
        <ITEM>OBX</ITEM>
      </OBX.0.0>
    </OBX.0>
    <OBX.1>
      <OBX.1.0>
        <ITEM>3</ITEM>
      </OBX.1.0>
    </OBX.1>
    <OBX.2>
      <OBX.2.0>
        <ITEM>NM</ITEM>
      </OBX.2.0>
    </OBX.2>
    <OBX.3>
      <OBX.3.0>
        <ITEM>Chol HDL Ratio</ITEM>
      </OBX.3.0>
      <OBX.3.1>
        <ITEM>Chol HDL Ratio</ITEM>
      </OBX.3.1>
    </OBX.3>
    <OBX.4>
      <OBX.4.0>
        <ITEM></ITEM>
      </OBX.4.0>
    </OBX.4>
    <OBX.5>
      <OBX.5.0>
        <ITEM>10.5</ITEM>
      </OBX.5.0>
    </OBX.5>
    <OBX.6>
      <OBX.6.0>
        <ITEM>Ratio</ITEM>
      </OBX.6.0>
    </OBX.6>
    <OBX.7>
      <OBX.7.0>
        <ITEM>None</ITEM>
      </OBX.7.0>
    </OBX.7>
    <OBX.8>
      <OBX.8.0>
        <ITEM>N</ITEM>
      </OBX.8.0>
    </OBX.8>
    <OBX.9>
      <OBX.9.0>
        <ITEM></ITEM>
      </OBX.9.0>
    </OBX.9>
    <OBX.10>
      <OBX.10.0>
        <ITEM>U</ITEM>
      </OBX.10.0>
    </OBX.10>
    <OBX.11>
      <OBX.11.0>
        <ITEM>F</ITEM>
      </OBX.11.0>
    </OBX.11>
    <OBX.12>
      <OBX.12.0>
        <ITEM></ITEM>
      </OBX.12.0>
    </OBX.12>
    <OBX.13>
      <OBX.13.0>
        <ITEM></ITEM>
      </OBX.13.0>
    </OBX.13>
    <OBX.14>
      <OBX.14.0>
        <ITEM>20140212130401</ITEM>
      </OBX.14.0>
    </OBX.14>
    <OBX.15>
      <OBX.15.0>
        <ITEM></ITEM>
      </OBX.15.0>
    </OBX.15>
    <OBX.16>
      <OBX.16.0>
        <ITEM>RML</ITEM>
      </OBX.16.0>
    </OBX.16>
    <OBX.17>
      <OBX.17.0>
        <ITEM></ITEM>
      </OBX.17.0>
      <OBX.17.1>
        <ITEM></ITEM>
      </OBX.17.1>
      <OBX.17.2>
        <ITEM></ITEM>
      </OBX.17.2>
      <OBX.17.3>
        <ITEM>CD:8973036</ITEM>
      </OBX.17.3>
    </OBX.17>
    <OBX.18>
      <OBX.18.0>
        <ITEM></ITEM>
      </OBX.18.0>
    </OBX.18>
    <OBX.19>
      <OBX.19.0>
        <ITEM></ITEM>
      </OBX.19.0>
    </OBX.19>
    <OBX.20>
      <OBX.20.0>
        <ITEM></ITEM>
      </OBX.20.0>
    </OBX.20>
    <OBX.21>
      <OBX.21.0>
        <ITEM></ITEM>
      </OBX.21.0>
    </OBX.21>
    <OBX.22>
      <OBX.22.0>
        <ITEM></ITEM>
      </OBX.22.0>
    </OBX.22>
    <OBX.23>
      <OBX.23.0>
        <ITEM></ITEM>
      </OBX.23.0>
    </OBX.23>
    <OBX.24>
      <OBX.24.0>
        <ITEM></ITEM>
      </OBX.24.0>
    </OBX.24>
    <OBX.25>
      <OBX.25.0>
        <ITEM></ITEM>
      </OBX.25.0>
    </OBX.25>
    <OBX.26>
      <OBX.26.0>
        <ITEM></ITEM>
      </OBX.26.0>
    </OBX.26>
  </OBX>
  <OBX>
    <OBX.0>
      <OBX.0.0>
        <ITEM>OBX</ITEM>
      </OBX.0.0>
    </OBX.0>
    <OBX.1>
      <OBX.1.0>
        <ITEM>4</ITEM>
      </OBX.1.0>
    </OBX.1>
    <OBX.2>
      <OBX.2.0>
        <ITEM>NM</ITEM>
      </OBX.2.0>
    </OBX.2>
    <OBX.3>
      <OBX.3.0>
        <ITEM>LDL Calculated</ITEM>
      </OBX.3.0>
      <OBX.3.1>
        <ITEM>LDL Calculated</ITEM>
      </OBX.3.1>
    </OBX.3>
    <OBX.4>
      <OBX.4.0>
        <ITEM></ITEM>
      </OBX.4.0>
    </OBX.4>
    <OBX.5>
      <OBX.5.0>
        <ITEM>188</ITEM>
      </OBX.5.0>
    </OBX.5>
    <OBX.6>
      <OBX.6.0>
        <ITEM>mg/dL</ITEM>
      </OBX.6.0>
    </OBX.6>
    <OBX.7>
      <OBX.7.0>
        <ITEM>&lt;=100</ITEM>
      </OBX.7.0>
    </OBX.7>
    <OBX.8>
      <OBX.8.0>
        <ITEM>H</ITEM>
      </OBX.8.0>
    </OBX.8>
    <OBX.9>
      <OBX.9.0>
        <ITEM></ITEM>
      </OBX.9.0>
    </OBX.9>
    <OBX.10>
      <OBX.10.0>
        <ITEM>U</ITEM>
      </OBX.10.0>
    </OBX.10>
    <OBX.11>
      <OBX.11.0>
        <ITEM>F</ITEM>
      </OBX.11.0>
    </OBX.11>
    <OBX.12>
      <OBX.12.0>
        <ITEM></ITEM>
      </OBX.12.0>
    </OBX.12>
    <OBX.13>
      <OBX.13.0>
        <ITEM></ITEM>
      </OBX.13.0>
    </OBX.13>
    <OBX.14>
      <OBX.14.0>
        <ITEM>20140212130401</ITEM>
      </OBX.14.0>
    </OBX.14>
    <OBX.15>
      <OBX.15.0>
        <ITEM></ITEM>
      </OBX.15.0>
    </OBX.15>
    <OBX.16>
      <OBX.16.0>
        <ITEM>RML</ITEM>
      </OBX.16.0>
    </OBX.16>
    <OBX.17>
      <OBX.17.0>
        <ITEM></ITEM>
      </OBX.17.0>
      <OBX.17.1>
        <ITEM></ITEM>
      </OBX.17.1>
      <OBX.17.2>
        <ITEM></ITEM>
      </OBX.17.2>
      <OBX.17.3>
        <ITEM>CD:8973036</ITEM>
      </OBX.17.3>
    </OBX.17>
    <OBX.18>
      <OBX.18.0>
        <ITEM></ITEM>
      </OBX.18.0>
    </OBX.18>
    <OBX.19>
      <OBX.19.0>
        <ITEM></ITEM>
      </OBX.19.0>
    </OBX.19>
    <OBX.20>
      <OBX.20.0>
        <ITEM></ITEM>
      </OBX.20.0>
    </OBX.20>
    <OBX.21>
      <OBX.21.0>
        <ITEM></ITEM>
      </OBX.21.0>
    </OBX.21>
    <OBX.22>
      <OBX.22.0>
        <ITEM></ITEM>
      </OBX.22.0>
    </OBX.22>
    <OBX.23>
      <OBX.23.0>
        <ITEM></ITEM>
      </OBX.23.0>
    </OBX.23>
    <OBX.24>
      <OBX.24.0>
        <ITEM></ITEM>
      </OBX.24.0>
    </OBX.24>
    <OBX.25>
      <OBX.25.0>
        <ITEM></ITEM>
      </OBX.25.0>
    </OBX.25>
    <OBX.26>
      <OBX.26.0>
        <ITEM></ITEM>
      </OBX.26.0>
    </OBX.26>
  </OBX>
  <OBX>
    <OBX.0>
      <OBX.0.0>
        <ITEM>OBX</ITEM>
      </OBX.0.0>
    </OBX.0>
    <OBX.1>
      <OBX.1.0>
        <ITEM>5</ITEM>
      </OBX.1.0>
    </OBX.1>
    <OBX.2>
      <OBX.2.0>
        <ITEM>NM</ITEM>
      </OBX.2.0>
    </OBX.2>
    <OBX.3>
      <OBX.3.0>
        <ITEM>Triglycerides</ITEM>
      </OBX.3.0>
      <OBX.3.1>
        <ITEM>Triglycerides</ITEM>
      </OBX.3.1>
    </OBX.3>
    <OBX.4>
      <OBX.4.0>
        <ITEM></ITEM>
      </OBX.4.0>
    </OBX.4>
    <OBX.5>
      <OBX.5.0>
        <ITEM>10</ITEM>
      </OBX.5.0>
    </OBX.5>
    <OBX.6>
      <OBX.6.0>
        <ITEM>mg/dL</ITEM>
      </OBX.6.0>
    </OBX.6>
    <OBX.7>
      <OBX.7.0>
        <ITEM>&lt;=150</ITEM>
      </OBX.7.0>
    </OBX.7>
    <OBX.8>
      <OBX.8.0>
        <ITEM>N</ITEM>
      </OBX.8.0>
    </OBX.8>
    <OBX.9>
      <OBX.9.0>
        <ITEM></ITEM>
      </OBX.9.0>
    </OBX.9>
    <OBX.10>
      <OBX.10.0>
        <ITEM>U</ITEM>
      </OBX.10.0>
    </OBX.10>
    <OBX.11>
      <OBX.11.0>
        <ITEM>F</ITEM>
      </OBX.11.0>
    </OBX.11>
    <OBX.12>
      <OBX.12.0>
        <ITEM></ITEM>
      </OBX.12.0>
    </OBX.12>
    <OBX.13>
      <OBX.13.0>
        <ITEM></ITEM>
      </OBX.13.0>
    </OBX.13>
    <OBX.14>
      <OBX.14.0>
        <ITEM>20140212130401</ITEM>
      </OBX.14.0>
    </OBX.14>
    <OBX.15>
      <OBX.15.0>
        <ITEM></ITEM>
      </OBX.15.0>
    </OBX.15>
    <OBX.16>
      <OBX.16.0>
        <ITEM>RML</ITEM>
      </OBX.16.0>
    </OBX.16>
    <OBX.17>
      <OBX.17.0>
        <ITEM></ITEM>
      </OBX.17.0>
      <OBX.17.1>
        <ITEM></ITEM>
      </OBX.17.1>
      <OBX.17.2>
        <ITEM></ITEM>
      </OBX.17.2>
      <OBX.17.3>
        <ITEM>CD:8973036</ITEM>
      </OBX.17.3>
    </OBX.17>
    <OBX.18>
      <OBX.18.0>
        <ITEM></ITEM>
      </OBX.18.0>
    </OBX.18>
    <OBX.19>
      <OBX.19.0>
        <ITEM></ITEM>
      </OBX.19.0>
    </OBX.19>
    <OBX.20>
      <OBX.20.0>
        <ITEM></ITEM>
      </OBX.20.0>
    </OBX.20>
    <OBX.21>
      <OBX.21.0>
        <ITEM></ITEM>
      </OBX.21.0>
    </OBX.21>
    <OBX.22>
      <OBX.22.0>
        <ITEM></ITEM>
      </OBX.22.0>
    </OBX.22>
    <OBX.23>
      <OBX.23.0>
        <ITEM></ITEM>
      </OBX.23.0>
    </OBX.23>
    <OBX.24>
      <OBX.24.0>
        <ITEM></ITEM>
      </OBX.24.0>
    </OBX.24>
    <OBX.25>
      <OBX.25.0>
        <ITEM></ITEM>
      </OBX.25.0>
    </OBX.25>
    <OBX.26>
      <OBX.26.0>
        <ITEM></ITEM>
      </OBX.26.0>
    </OBX.26>
  </OBX>
  <OBX>
    <OBX.0>
      <OBX.0.0>
        <ITEM>OBX</ITEM>
      </OBX.0.0>
    </OBX.0>
    <OBX.1>
      <OBX.1.0>
        <ITEM>6</ITEM>
      </OBX.1.0>
    </OBX.1>
    <OBX.2>
      <OBX.2.0>
        <ITEM>NM</ITEM>
      </OBX.2.0>
    </OBX.2>
    <OBX.3>
      <OBX.3.0>
        <ITEM>Non-HDL Cholesterol</ITEM>
      </OBX.3.0>
      <OBX.3.1>
        <ITEM>Non-HDL Choles</ITEM>
      </OBX.3.1>
    </OBX.3>
    <OBX.4>
      <OBX.4.0>
        <ITEM></ITEM>
      </OBX.4.0>
    </OBX.4>
    <OBX.5>
      <OBX.5.0>
        <ITEM>190</ITEM>
      </OBX.5.0>
    </OBX.5>
    <OBX.6>
      <OBX.6.0>
        <ITEM>mg/dL</ITEM>
      </OBX.6.0>
    </OBX.6>
    <OBX.7>
      <OBX.7.0>
        <ITEM>&lt;=130</ITEM>
      </OBX.7.0>
    </OBX.7>
    <OBX.8>
      <OBX.8.0>
        <ITEM>H</ITEM>
      </OBX.8.0>
    </OBX.8>
    <OBX.9>
      <OBX.9.0>
        <ITEM></ITEM>
      </OBX.9.0>
    </OBX.9>
    <OBX.10>
      <OBX.10.0>
        <ITEM>U</ITEM>
      </OBX.10.0>
    </OBX.10>
    <OBX.11>
      <OBX.11.0>
        <ITEM>F</ITEM>
      </OBX.11.0>
    </OBX.11>
    <OBX.12>
      <OBX.12.0>
        <ITEM></ITEM>
      </OBX.12.0>
    </OBX.12>
    <OBX.13>
      <OBX.13.0>
        <ITEM></ITEM>
      </OBX.13.0>
    </OBX.13>
    <OBX.14>
      <OBX.14.0>
        <ITEM>20140212130401</ITEM>
      </OBX.14.0>
    </OBX.14>
    <OBX.15>
      <OBX.15.0>
        <ITEM></ITEM>
      </OBX.15.0>
    </OBX.15>
    <OBX.16>
      <OBX.16.0>
        <ITEM>RML</ITEM>
      </OBX.16.0>
    </OBX.16>
    <OBX.17>
      <OBX.17.0>
        <ITEM></ITEM>
      </OBX.17.0>
      <OBX.17.1>
        <ITEM></ITEM>
      </OBX.17.1>
      <OBX.17.2>
        <ITEM></ITEM>
      </OBX.17.2>
      <OBX.17.3>
        <ITEM>CD:8973036</ITEM>
      </OBX.17.3>
    </OBX.17>
    <OBX.18>
      <OBX.18.0>
        <ITEM></ITEM>
      </OBX.18.0>
    </OBX.18>
    <OBX.19>
      <OBX.19.0>
        <ITEM></ITEM>
      </OBX.19.0>
    </OBX.19>
    <OBX.20>
      <OBX.20.0>
        <ITEM></ITEM>
      </OBX.20.0>
    </OBX.20>
    <OBX.21>
      <OBX.21.0>
        <ITEM></ITEM>
      </OBX.21.0>
    </OBX.21>
    <OBX.22>
      <OBX.22.0>
        <ITEM></ITEM>
      </OBX.22.0>
    </OBX.22>
    <OBX.23>
      <OBX.23.0>
        <ITEM></ITEM>
      </OBX.23.0>
    </OBX.23>
    <OBX.24>
      <OBX.24.0>
        <ITEM></ITEM>
      </OBX.24.0>
    </OBX.24>
    <OBX.25>
      <OBX.25.0>
        <ITEM></ITEM>
      </OBX.25.0>
    </OBX.25>
    <OBX.26>
      <OBX.26.0>
        <ITEM></ITEM>
      </OBX.26.0>
    </OBX.26>
  </OBX>
  <NTE>
    <NTE.0>
      <NTE.0.0>
        <ITEM>NTE</ITEM>
      </NTE.0.0>
    </NTE.0>
    <NTE.1>
      <NTE.1.0>
        <ITEM>1</ITEM>
      </NTE.1.0>
    </NTE.1>
    <NTE.2>
      <NTE.2.0>
        <ITEM></ITEM>
      </NTE.2.0>
    </NTE.2>
    <NTE.3>
      <NTE.3.0>
        <ITEM>Current NCEP (National Cholesterol Education Program) guidelines suggest a</ITEM>
      </NTE.3.0>
    </NTE.3>
    <NTE.4>
      <NTE.4.0>
        <ITEM></ITEM>
      </NTE.4.0>
    </NTE.4>
  </NTE>
  <NTE>
    <NTE.0>
      <NTE.0.0>
        <ITEM>NTE</ITEM>
      </NTE.0.0>
    </NTE.0>
    <NTE.1>
      <NTE.1.0>
        <ITEM>2</ITEM>
      </NTE.1.0>
    </NTE.1>
    <NTE.2>
      <NTE.2.0>
        <ITEM></ITEM>
      </NTE.2.0>
    </NTE.2>
    <NTE.3>
      <NTE.3.0>
        <ITEM>goal of &lt;130 mg/dl for patients with high risk of coronary heart disease, &lt;160</ITEM>
      </NTE.3.0>
    </NTE.3>
    <NTE.4>
      <NTE.4.0>
        <ITEM></ITEM>
      </NTE.4.0>
    </NTE.4>
  </NTE>
  <NTE>
    <NTE.0>
      <NTE.0.0>
        <ITEM>NTE</ITEM>
      </NTE.0.0>
    </NTE.0>
    <NTE.1>
      <NTE.1.0>
        <ITEM>3</ITEM>
      </NTE.1.0>
    </NTE.1>
    <NTE.2>
      <NTE.2.0>
        <ITEM></ITEM>
      </NTE.2.0>
    </NTE.2>
    <NTE.3>
      <NTE.3.0>
        <ITEM>mg/dl for patients with moderate risk, and &lt;190 mg/dl for patients with low</ITEM>
      </NTE.3.0>
    </NTE.3>
    <NTE.4>
      <NTE.4.0>
        <ITEM></ITEM>
      </NTE.4.0>
    </NTE.4>
  </NTE>
  <NTE>
    <NTE.0>
      <NTE.0.0>
        <ITEM>NTE</ITEM>
      </NTE.0.0>
    </NTE.0>
    <NTE.1>
      <NTE.1.0>
        <ITEM>4</ITEM>
      </NTE.1.0>
    </NTE.1>
    <NTE.2>
      <NTE.2.0>
        <ITEM></ITEM>
      </NTE.2.0>
    </NTE.2>
    <NTE.3>
      <NTE.3.0>
        <ITEM>risk.</ITEM>
      </NTE.3.0>
    </NTE.3>
    <NTE.4>
      <NTE.4.0>
        <ITEM></ITEM>
      </NTE.4.0>
    </NTE.4>
  </NTE>
  <NTE>
    <NTE.0>
      <NTE.0.0>
        <ITEM>NTE</ITEM>
      </NTE.0.0>
    </NTE.0>
    <NTE.1>
      <NTE.1.0>
        <ITEM>5</ITEM>
      </NTE.1.0>
    </NTE.1>
    <NTE.2>
      <NTE.2.0>
        <ITEM></ITEM>
      </NTE.2.0>
    </NTE.2>
    <NTE.3>
      <NTE.3.0>
        <ITEM>Unless noted, test(s) performed at Regional Medical Labs,</ITEM>
      </NTE.3.0>
    </NTE.3>
  </NTE>
  <NTE>
    <NTE.0>
      <NTE.0.0>
        <ITEM>NTE</ITEM>
      </NTE.0.0>
    </NTE.0>
    <NTE.1>
      <NTE.1.0>
        <ITEM>6</ITEM>
      </NTE.1.0>
    </NTE.1>
    <NTE.2>
      <NTE.2.0>
        <ITEM></ITEM>
      </NTE.2.0>
    </NTE.2>
    <NTE.3>
      <NTE.3.0>
        <ITEM>Battle Creek, MI.</ITEM>
      </NTE.3.0>
    </NTE.3>
  </NTE>
</HL7Message>')

Declare @OutputParamter nvarchar(max)
exec csp_RMLProcessHL7_22_ORU_InboundMessage 2,@Input,@OutputParamter Output
