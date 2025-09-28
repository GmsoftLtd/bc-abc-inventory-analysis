<?xml version="1.0" encoding="utf-8"?>
<Report xmlns="http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner">
  <AutoRefresh>0</AutoRefresh>
  <Body>
    <ReportItems>
      <Tablix Name="Tablix1">
        <TablixBody>
          <TablixColumns>
            <TablixColumn><Width>2.5cm</Width></TablixColumn>  <!-- Item No. -->
            <TablixColumn><Width>6.0cm</Width></TablixColumn>  <!-- Description -->
            <TablixColumn><Width>2.8cm</Width></TablixColumn>  <!-- Model -->
            <TablixColumn><Width>2.8cm</Width></TablixColumn>  <!-- Value -->
            <TablixColumn><Width>2.8cm</Width></TablixColumn>  <!-- Value % -->
            <TablixColumn><Width>2.8cm</Width></TablixColumn>  <!-- Cum. % -->
            <TablixColumn><Width>2.3cm</Width></TablixColumn>  <!-- Class -->
          </TablixColumns>
          <TablixRows>
            <!-- Header Row -->
            <TablixRow>
              <Height>0.9cm</Height>
              <TablixCells>
                <TablixCell><CellContents><Textbox Name="H_ItemNo"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Item No.</Value><Style><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style /></Paragraph></Paragraphs><Style><Border><Style>Solid</Style></Border></Style></Textbox></CellContents></TablixCell>
                <TablixCell><CellContents><Textbox Name="H_Desc"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Description</Value><Style><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style /></Paragraph></Paragraphs><Style><Border><Style>Solid</Style></Border></Style></Textbox></CellContents></TablixCell>
                <TablixCell><CellContents><Textbox Name="H_Model"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Model</Value><Style><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style /></Paragraph></Paragraphs><Style><Border><Style>Solid</Style></Border></Style></Textbox></CellContents></TablixCell>
                <TablixCell><CellContents><Textbox Name="H_Value"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Value</Value><Style><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style /></Paragraph></Paragraphs><Style><Border><Style>Solid</Style></Border></Style></Textbox></CellContents></TablixCell>
                <TablixCell><CellContents><Textbox Name="H_ValuePct"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Value %</Value><Style><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style /></Paragraph></Paragraphs><Style><Border><Style>Solid</Style></Border></Style></Textbox></CellContents></TablixCell>
                <TablixCell><CellContents><Textbox Name="H_CumPct"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Cum. %</Value><Style><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style /></Paragraph></Paragraphs><Style><Border><Style>Solid</Style></Border></Style></Textbox></CellContents></TablixCell>
                <TablixCell><CellContents><Textbox Name="H_Class"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Class</Value><Style><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style /></Paragraph></Paragraphs><Style><Border><Style>Solid</Style></Border></Style></Textbox></CellContents></TablixCell>
              </TablixCells>
            </TablixRow>

            <!-- Data Row -->
            <TablixRow>
              <Height>0.8cm</Height>
              <TablixCells>
                <TablixCell>
                  <CellContents>
                    <Textbox Name="D_ItemNo">
                      <CanGrow>true</CanGrow><KeepTogether>true</KeepTogether>
                      <Paragraphs><Paragraph><TextRuns><TextRun><Value>=Fields!Item_No_.Value</Value></TextRun></TextRuns><Style /></Paragraph></Paragraphs>
                      <Style><Border><Style>Solid</Style></Border></Style>
                    </Textbox>
                  </CellContents>
                </TablixCell>

                <TablixCell>
                  <CellContents>
                    <Textbox Name="D_Desc">
                      <CanGrow>true</CanGrow><KeepTogether>true</KeepTogether>
                      <Paragraphs><Paragraph><TextRuns><TextRun><Value>=Fields!Description.Value</Value></TextRun></TextRuns><Style /></Paragraph></Paragraphs>
                      <Style><Border><Style>Solid</Style></Border></Style>
                    </Textbox>
                  </CellContents>
                </TablixCell>

                <TablixCell>
                  <CellContents>
                    <Textbox Name="D_Model">
                      <CanGrow>true</CanGrow><KeepTogether>true</KeepTogether>
                      <Paragraphs><Paragraph><TextRuns><TextRun><Value>=Fields!Model.Value</Value></TextRun></TextRuns><Style /></Paragraph></Paragraphs>
                      <Style><Border><Style>Solid</Style></Border></Style>
                    </Textbox>
                  </CellContents>
                </TablixCell>

                <TablixCell>
                  <CellContents>
                    <Textbox Name="D_Value">
                      <CanGrow>true</CanGrow><KeepTogether>true</KeepTogether>
                      <Paragraphs><Paragraph><TextRuns><TextRun><Value>=Fields!Value.Value</Value></TextRun></TextRuns><Style /></Paragraph></Paragraphs>
                      <Style><Border><Style>Solid</Style></Border><Format>N2</Format></Style>
                    </Textbox>
                  </CellContents>
                </TablixCell>

                <TablixCell>
                  <CellContents>
                    <Textbox Name="D_ValuePct">
                      <CanGrow>true</CanGrow><KeepTogether>true</KeepTogether>
                      <Paragraphs><Paragraph><TextRuns><TextRun><Value>=Fields!ValuePct.Value</Value></TextRun></TextRuns><Style /></Paragraph></Paragraphs>
                      <Style><Border><Style>Solid</Style></Border><Format>N2</Format></Style>
                    </Textbox>
                  </CellContents>
                </TablixCell>

                <TablixCell>
                  <CellContents>
                    <Textbox Name="D_CumPct">
                      <CanGrow>true</CanGrow><KeepTogether>true</KeepTogether>
                      <Paragraphs><Paragraph><TextRuns><TextRun><Value>=Fields!CumPct.Value</Value></TextRun></TextRuns><Style /></Paragraph></Paragraphs>
                      <Style><Border><Style>Solid</Style></Border><Format>N2</Format></Style>
                    </Textbox>
                  </CellContents>
                </TablixCell>

                <!-- CLASS with color + bold -->
                <TablixCell>
                  <CellContents>
                    <Textbox Name="D_Class">
                      <CanGrow>true</CanGrow><KeepTogether>true</KeepTogether>
                      <Paragraphs>
                        <Paragraph>
                          <TextRuns>
                            <TextRun>
                              <Value>=Fields!Class.Value</Value>
                              <Style>
                                <FontWeight>Bold</FontWeight>
                                <Color>=IIF(Fields!Class.Value = "A", "Green", IIF(Fields!Class.Value = "B", "Goldenrod", "Red"))</Color>
                              </Style>
                            </TextRun>
                          </TextRuns>
                          <Style />
                        </Paragraph>
                      </Paragraphs>
                      <Style>
                        <Border><Style>Solid</Style></Border>
                      </Style>
                    </Textbox>
                  </CellContents>
                </TablixCell>

              </TablixCells>
            </TablixRow>
          </TablixRows>
        </TablixBody>

        <TablixColumnHierarchy>
          <TablixMembers>
            <TablixMember />
            <TablixMember />
            <TablixMember />
            <TablixMember />
            <TablixMember />
            <TablixMember />
            <TablixMember />
          </TablixMembers>
        </TablixColumnHierarchy>

        <TablixRowHierarchy>
          <TablixMembers>
            <TablixMember>
              <KeepTogether>true</KeepTogether>
              <RepeatOnNewPage>true</RepeatOnNewPage>
              <KeepWithGroup>After</KeepWithGroup>
            </TablixMember>
            <TablixMember><KeepTogether>true</KeepTogether></TablixMember>
          </TablixMembers>
        </TablixRowHierarchy>

        <DataSetName>DataSet_Result</DataSetName>
        <Top>0.5cm</Top>
        <Left>0.5cm</Left>
        <Height>2.0cm</Height>
        <Width>22.0cm</Width>
        <Style />
      </Tablix>
    </ReportItems>
    <Height>3.0cm</Height>
    <Style />
  </Body>

  <DataSources>
    <DataSource Name="Dummy">
      <DataSourceReference>Dummy</DataSourceReference>
      <rd:DataSourceID>5f7f1788-7c7a-4d08-9e88-1b76b4bdbd0f</rd:DataSourceID>
    </DataSource>
  </DataSources>

  <DataSets>
    <DataSet Name="DataSet_Result">
      <Fields>
        <Field Name="LineNo"><DataField>LineNo</DataField><rd:TypeName>System.Int32</rd:TypeName></Field>
        <Field Name="Item_No_"><DataField>Item_No_</DataField><rd:TypeName>System.String</rd:TypeName></Field>
        <Field Name="Description"><DataField>Description</DataField><rd:TypeName>System.String</rd:TypeName></Field>
        <Field Name="Model"><DataField>Model</DataField><rd:TypeName>System.String</rd:TypeName></Field>
        <Field Name="Value"><DataField>Value</DataField><rd:TypeName>System.Decimal</rd:TypeName></Field>
        <Field Name="ValuePct"><DataField>ValuePct</DataField><rd:TypeName>System.Decimal</rd:TypeName></Field>
        <Field Name="CumPct"><DataField>CumPct</DataField><rd:TypeName>System.Decimal</rd:TypeName></Field>
        <Field Name="Class"><DataField>Class</DataField><rd:TypeName>System.String</rd:TypeName></Field>
      </Fields>
      <Query><DataSourceName>Dummy</DataSourceName><CommandText /></Query>
    </DataSet>
  </DataSets>

  <Width>22.5cm</Width>
  <Page>
    <PageWidth>21cm</PageWidth>
    <PageHeight>29.7cm</PageHeight>
    <LeftMargin>1cm</LeftMargin>
    <RightMargin>1cm</RightMargin>
    <TopMargin>1cm</TopMargin>
    <BottomMargin>1cm</BottomMargin>
    <Style />
  </Page>

  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>3aef25e8-9ed6-4c8b-8f9b-58a4391e18c4</rd:ReportID>
</Report>
