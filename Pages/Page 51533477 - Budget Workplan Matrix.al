page 51533477 "Budget Workplan Matrix"
{
    Caption = 'Budget Matrix';
    DataCaptionExpression = BudgetName;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Dimension Code Buffer";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                ShowCaption = false;
                field("Code";Rec.Code)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookUpCode(LineDimOption,LineDimCode,Rec.Code);
                    end;
                }
                field(Name;Rec.Name)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(TotalBudgetedAmount;Rec.Amount)
                {
                    BlankZero = true;
                    Caption = 'Budgeted Amount';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        SetCommonFilters(GLAccBudgetBuf);
                        SetDimFilters(GLAccBudgetBuf,0);
                        BudgetDrillDown;
                    end;
                }
                field(Field1;MATRIX_CellData[1])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(1);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(1);
                    end;
                }
                field(Field2;MATRIX_CellData[2])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(2);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(2);
                    end;
                }
                field(Field3;MATRIX_CellData[3])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(3);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(3);
                    end;
                }
                field(Field4;MATRIX_CellData[4])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(4);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(4);
                    end;
                }
                field(Field5;MATRIX_CellData[5])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(5);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(5);
                    end;
                }
                field(Field6;MATRIX_CellData[6])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[6];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(6);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(6);
                    end;
                }
                field(Field7;MATRIX_CellData[7])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[7];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(7);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(7);
                    end;
                }
                field(Field8;MATRIX_CellData[8])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[8];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(8);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(8);
                    end;
                }
                field(Field9;MATRIX_CellData[9])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[9];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(9);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(9);
                    end;
                }
                field(Field10;MATRIX_CellData[10])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[10];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(10);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(10);
                    end;
                }
                field(Field11;MATRIX_CellData[11])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[11];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(11);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(11);
                    end;
                }
                field(Field12;MATRIX_CellData[12])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[12];
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(12);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateAmount(12);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Balance")
            {
                Caption = '&Balance';
                Image = Balance;
                action("G/L Account Balance/Bud&get")
                {
                    Caption = 'G/L Account Balance/Bud&get';
                    Image = Period;

                    trigger OnAction()
                    begin
                        GLAccountBalanceBudget;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
        NameIndent := 0;
        for MATRIX_CurrentColumnOrdinal := 1 to MATRIX_CurrentNoOfMatrixColumn do
          MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
        Rec.Amount := ToRoundedValue(CalcAmount(false));
        FormatLine;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(FindRec(LineDimOption,Rec,Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(NextRec(LineDimOption,Rec,Steps));
    end;

    trigger OnOpenPage()
    begin

        if GLAccBudgetBuf.GetFilter("Global Dimension 1 Filter") <> '' then
          GlobalDim1Filter := GLAccBudgetBuf.GetFilter("Global Dimension 1 Filter");
        if GLAccBudgetBuf.GetFilter("Global Dimension 2 Filter") <> '' then
          GlobalDim2Filter := GLAccBudgetBuf.GetFilter("Global Dimension 2 Filter");

        GLSetup.Get;
    end;

    var
        Text001: Label 'Period';
        Text002: Label 'You may only edit column 1 to %1.';
        GLSetup: Record "General Ledger Setup";
        GLAccBudgetBuf: Record "Workplan Budget Buffer";
        GLBudgetName: Record Workplan;
        MatrixRecords: array [12] of Record "Dimension Code Buffer";
        MATRIX_MatrixRecord: Record "Dimension Code Buffer";
        BudgetName: Code[70];
        LineDimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4",WorkPlan;
        ColumnDimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4",WorkPlan;
        LineDimCode: Text[30];
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        RoundingFactor: Option "None","1","1000","1000000";
        ShowColumnName: Boolean;
        DateFilter: Text[30];
        InternalDateFilter: Text[30];
        BusUnitFilter: Code[250];
        GLAccFilter: Code[250];
        GlobalDim1Filter: Code[250];
        GlobalDim2Filter: Code[250];
        BudgetDim1Filter: Code[250];
        BudgetDim2Filter: Code[250];
        BudgetDim3Filter: Code[250];
        BudgetDim4Filter: Code[250];
        MatrixHeader: Text[50];
        PeriodInitialized: Boolean;
        MATRIX_CurrentNoOfMatrixColumn: Integer;
        MATRIX_CellData: array [12] of Decimal;
        MATRIX_CaptionSet: array [12] of Text[80];
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure DimCodeToOption(DimCode: Text[30]): Integer
    var
        BusUnit: Record "Business Unit";
        GLAcc: Record "Workplan Activities";
    begin
        case DimCode of
          '':
            exit(-1);
          GLAcc.TableCaption:
            exit(9);
          Text001:
            exit(1);
          BusUnit.TableCaption:
            exit(2);
          GLSetup."Global Dimension 1 Code":
            exit(3);
          GLSetup."Global Dimension 2 Code":
            exit(4);
          GLBudgetName."Budget Dimension 1 Code":
            exit(5);
          GLBudgetName."Budget Dimension 2 Code":
            exit(6);
          GLBudgetName."Budget Dimension 3 Code":
            exit(7);
          GLBudgetName."Budget Dimension 4 Code":
            exit(8);
          else
            exit(-1);
        end;
    end;

    local procedure FindRec(var DimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4",WorkPlan;var DimCodeBuf: Record "Dimension Code Buffer";Which: Text[250]): Boolean
    var
        GLAcc: Record "Workplan Activities";
        BusUnit: Record "Business Unit";
        Period: Record Date;
        DimVal: Record "Dimension Value";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        Found: Boolean;
        WorkPlan: Record "Workplan Activities";
    begin
        case DimOption of
          DimOption::"G/L Account":
            begin
              GLAcc."No." := DimCodeBuf.Code;
              if GLAccFilter <> '' then
                GLAcc.SetFilter("No.",GLAccFilter);
              Found := GLAcc.Find(Which);
              if Found then
                CopyGLAccToBuf(GLAcc,DimCodeBuf);
            end;
          DimOption::Period:
            begin
              if not PeriodInitialized then
                DateFilter := '';
              PeriodInitialized := true;
              Period."Period Start" := DimCodeBuf."Period Start";
              if DateFilter <> '' then
                Period.SetFilter("Period Start",DateFilter)
              else
                if not PeriodInitialized and (InternalDateFilter <> '') then
                  Period.SetFilter("Period Start",InternalDateFilter);
              Found := PeriodFormMgt.FindDate(Which,Period,PeriodType);
              if Found then
                CopyPeriodToBuf(Period,DimCodeBuf);
            end;
          DimOption::"Business Unit":
            begin
              BusUnit.Code := DimCodeBuf.Code;
              if BusUnitFilter <> '' then
                BusUnit.SetFilter(Code,BusUnitFilter);
              Found := BusUnit.Find(Which);
              if Found then
                CopyBusUnitToBuf(BusUnit,DimCodeBuf);
            end;
          DimOption::"Global Dimension 1":
            begin
              if GlobalDim1Filter <> '' then
                DimVal.SetFilter(Code,GlobalDim1Filter);
              DimVal."Dimension Code" := GLSetup."Global Dimension 1 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              Found := DimVal.Find(Which);
              if Found then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::"Global Dimension 2":
            begin
              if GlobalDim2Filter <> '' then
                DimVal.SetFilter(Code,GlobalDim2Filter);
              DimVal."Dimension Code" := GLSetup."Global Dimension 2 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              Found := DimVal.Find(Which);
              if Found then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::"Budget Dimension 1":
            begin
              if BudgetDim1Filter <> '' then
                DimVal.SetFilter(Code,BudgetDim1Filter);
              DimVal."Dimension Code" := GLBudgetName."Budget Dimension 1 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              Found := DimVal.Find(Which);
              if Found then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::"Budget Dimension 2":
            begin
              if BudgetDim2Filter <> '' then
                DimVal.SetFilter(Code,BudgetDim2Filter);
              DimVal."Dimension Code" := GLBudgetName."Budget Dimension 2 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              Found := DimVal.Find(Which);
              if Found then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::"Budget Dimension 3":
            begin
              if BudgetDim3Filter <> '' then
                DimVal.SetFilter(Code,BudgetDim3Filter);
              DimVal."Dimension Code" := GLBudgetName."Budget Dimension 3 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              Found := DimVal.Find(Which);
              if Found then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::"Budget Dimension 4":
            begin
              if BudgetDim4Filter <> '' then
                DimVal.SetFilter(Code,BudgetDim4Filter);
              DimVal."Dimension Code" := GLBudgetName."Budget Dimension 4 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              Found := DimVal.Find(Which);
              if Found then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;

          DimOption::WorkPlan:
            begin
              WorkPlan."Activity Code":=DimCodeBuf.Code;
              if GLAccFilter <> '' then
                WorkPlan.SetFilter("Activity Code",GLAccFilter);

              //Added
             if GLBudgetName."Workplan Code" = 'PR0CMNT' then
              begin
                  //Do not set any filters
              end else
              begin
                  //Filter by Departmental Workplan
                  WorkPlan.SetFilter("Workplan Code",GLBudgetName."Workplan Code");
              end;

              Found := WorkPlan.Find(Which);
              if Found then
                CopyWorkPlanToBuf(WorkPlan,DimCodeBuf);
            end;

          end;
        exit(Found);
    end;

    local procedure NextRec(DimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4",WorkPlan;var DimCodeBuf: Record "Dimension Code Buffer";Steps: Integer): Integer
    var
        GLAcc: Record "Workplan Activities";
        BusUnit: Record "Business Unit";
        Period: Record Date;
        DimVal: Record "Dimension Value";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        ResultSteps: Integer;
        WorkPlan: Record "Workplan Activities";
    begin

        case DimOption of
          DimOption::"G/L Account":
            begin
              GLAcc."No." := DimCodeBuf.Code;
              if GLAccFilter <> '' then
                GLAcc.SetFilter("No.",GLAccFilter);
              ResultSteps := GLAcc.Next(Steps);
              if ResultSteps <> 0 then
                CopyGLAccToBuf(GLAcc,DimCodeBuf);
            end;


          DimOption::Period:
            begin
              if DateFilter <> '' then
                Period.SetFilter("Period Start",DateFilter);
              Period."Period Start" := DimCodeBuf."Period Start";
              ResultSteps := PeriodFormMgt.NextDate(Steps,Period,PeriodType);
              if ResultSteps <> 0 then
                CopyPeriodToBuf(Period,DimCodeBuf);
            end;
          DimOption::"Business Unit":
            begin
              BusUnit.Code := DimCodeBuf.Code;
              if BusUnitFilter <> '' then
                BusUnit.SetFilter(Code,BusUnitFilter);
              ResultSteps := BusUnit.Next(Steps);
              if ResultSteps <> 0 then
                CopyBusUnitToBuf(BusUnit,DimCodeBuf);
            end;
          DimOption::"Global Dimension 1":
            begin
              if GlobalDim1Filter <> '' then
                DimVal.SetFilter(Code,GlobalDim1Filter);
              DimVal."Dimension Code" := GLSetup."Global Dimension 1 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              ResultSteps := DimVal.Next(Steps);
              if ResultSteps <> 0 then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::"Global Dimension 2":
            begin
              if GlobalDim2Filter <> '' then
                DimVal.SetFilter(Code,GlobalDim2Filter);
              DimVal."Dimension Code" := GLSetup."Global Dimension 2 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              ResultSteps := DimVal.Next(Steps);
              if ResultSteps <> 0 then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::"Budget Dimension 1":
            begin
              if BudgetDim1Filter <> '' then
                DimVal.SetFilter(Code,BudgetDim1Filter);
              DimVal."Dimension Code" := GLBudgetName."Budget Dimension 1 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              ResultSteps := DimVal.Next(Steps);
              if ResultSteps <> 0 then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::"Budget Dimension 2":
            begin
              if BudgetDim2Filter <> '' then
                DimVal.SetFilter(Code,BudgetDim2Filter);
              DimVal."Dimension Code" := GLBudgetName."Budget Dimension 2 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              ResultSteps := DimVal.Next(Steps);
              if ResultSteps <> 0 then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::"Budget Dimension 3":
            begin
              if BudgetDim3Filter <> '' then
                DimVal.SetFilter(Code,BudgetDim3Filter);
              DimVal."Dimension Code" := GLBudgetName."Budget Dimension 3 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              ResultSteps := DimVal.Next(Steps);
              if ResultSteps <> 0 then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::"Budget Dimension 4":
            begin
              if BudgetDim4Filter <> '' then
                DimVal.SetFilter(Code,BudgetDim4Filter);
              DimVal."Dimension Code" := GLBudgetName."Budget Dimension 4 Code";
              DimVal.SetRange("Dimension Code",DimVal."Dimension Code");
              DimVal.Code := DimCodeBuf.Code;
              ResultSteps := DimVal.Next(Steps);
              if ResultSteps <> 0 then
                CopyDimValToBuf(DimVal,DimCodeBuf);
            end;
          DimOption::WorkPlan:

            begin
              WorkPlan."Activity Code" := DimCodeBuf.Code;
              if GLAccFilter <> '' then
                WorkPlan.SetFilter("Activity Code",GLAccFilter);
               //Cater for Year and other dimensions

               //Added
               if GLBudgetName."Workplan Code" = 'PR0CMNT' then
               begin
                   //Do not set any filters
               end else
               begin
                   //Filter by Departmental Workplan
                   WorkPlan.SetFilter("Workplan Code",GLBudgetName."Workplan Code");
               end;

               if GlobalDim1Filter <> '' then
                WorkPlan.SetFilter("Global Dimension 1 Code",GlobalDim1Filter);
               if GlobalDim2Filter <> '' then
                WorkPlan.SetFilter("Shortcut Dimension 2 Code",GlobalDim2Filter);
               //End Year and other Dimensions

              ResultSteps := WorkPlan.Next(Steps);
              if ResultSteps <> 0 then
                CopyWorkPlanToBuf(WorkPlan,DimCodeBuf);
            end;

        end;


        exit(ResultSteps);
    end;

    local procedure CopyGLAccToBuf(var TheGLAcc: Record "Workplan Activities";var TheDimCodeBuf: Record "Dimension Code Buffer")
    begin

        with TheDimCodeBuf do begin
          Init;
          Code := TheGLAcc."No.";
          Name := TheGLAcc."Activity Code";
          Totaling := TheGLAcc.Totaling;
          Indentation := TheGLAcc.Indentation;
          "Show in Bold" := TheGLAcc."Account Type" <> TheGLAcc."Account Type"::Posting;
        end;
    end;

    local procedure CopyPeriodToBuf(var ThePeriod: Record Date;var TheDimCodeBuf: Record "Dimension Code Buffer")
    var
        Period2: Record Date;
    begin
        with TheDimCodeBuf do begin
          Init;
          Code := Format(ThePeriod."Period Start");
          "Period Start" := ThePeriod."Period Start";
          "Period End" := ThePeriod."Period End";
          if DateFilter <> '' then begin
            Period2.SetFilter("Period End",DateFilter);
            if Period2.GetRangeMax("Period End") < "Period End" then
              "Period End" := Period2.GetRangeMax("Period End");
          end;
          Name := ThePeriod."Period Name";
        end;
    end;

    local procedure CopyBusUnitToBuf(var TheBusUnit: Record "Business Unit";var TheDimCodeBuf: Record "Dimension Code Buffer")
    begin
        with TheDimCodeBuf do begin
          Init;
          Code := TheBusUnit.Code;
          if TheBusUnit.Name <> '' then
            Name := TheBusUnit.Name
          else
            Name := TheBusUnit."Company Name";
        end;
    end;

    local procedure CopyDimValToBuf(var TheDimVal: Record "Dimension Value";var TheDimCodeBuf: Record "Dimension Code Buffer")
    begin
        with TheDimCodeBuf do begin
          Init;
          Code := TheDimVal.Code;
          Name := TheDimVal.Name;
          Totaling := TheDimVal.Totaling;
          Indentation := TheDimVal.Indentation;
          "Show in Bold" :=
            TheDimVal."Dimension Value Type" <> TheDimVal."Dimension Value Type"::Standard;
        end;
    end;

    local procedure LookUpCode(DimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4";DimCode: Text[30];"Code": Text[30])
    var
        GLAcc: Record "Workplan Activities";
        BusUnit: Record "Business Unit";
        DimVal: Record "Dimension Value";
        DimValList: Page "Dimension Value List";
    begin
        case DimOption of
          DimOption::"G/L Account":
            begin
              GLAcc.Get(Code);
              PAGE.RunModal(PAGE::"G/L Account List",GLAcc);
            end;
          DimOption::Period:
            ;
          DimOption::"Business Unit":
            begin
              BusUnit.Get(Code);
              PAGE.RunModal(PAGE::"Business Unit List",BusUnit);
            end;
          DimOption::"Global Dimension 1",DimOption::"Global Dimension 2",
          DimOption::"Budget Dimension 1",DimOption::"Budget Dimension 2",
          DimOption::"Budget Dimension 3",DimOption::"Budget Dimension 4":
            begin
              DimVal.SetRange("Dimension Code",DimCode);
              DimVal.Get(DimCode,Code);
              DimValList.SetTableView(DimVal);
              DimValList.SetRecord(DimVal);
              DimValList.RunModal;
            end;
        end;
    end;

    local procedure SetCommonFilters(var TheGLAccBudgetBuf: Record "Workplan Budget Buffer")
    begin
        with TheGLAccBudgetBuf do begin
          Reset;
          SetRange("Budget Filter",GLBudgetName."Workplan Code");
          if BusUnitFilter <> '' then
            SetFilter("Business Unit Filter",BusUnitFilter);
          if GLAccFilter <> '' then
            SetFilter("G/L Account Filter",GLAccFilter);
          if DateFilter <> '' then
            SetFilter("Date Filter",DateFilter);
          if GlobalDim1Filter <> '' then
            SetFilter("Global Dimension 1 Filter",GlobalDim1Filter);
          if GlobalDim2Filter <> '' then
            SetFilter("Global Dimension 2 Filter",GlobalDim2Filter);
          if BudgetDim1Filter <> '' then
            SetFilter("Budget Dimension 1 Filter",BudgetDim1Filter);
          if BudgetDim2Filter <> '' then
            SetFilter("Budget Dimension 2 Filter",BudgetDim2Filter);
          if BudgetDim3Filter <> '' then
            SetFilter("Budget Dimension 3 Filter",BudgetDim3Filter);
          if BudgetDim4Filter <> '' then
            SetFilter("Budget Dimension 4 Filter",BudgetDim4Filter);
        end;
    end;

    local procedure SetDimFilters(var TheGLAccBudgetBuf: Record "Workplan Budget Buffer";LineOrColumn: Option Line,Column)
    var
        DimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4",WorkPlan;
        DimCodeBuf: Record "Dimension Code Buffer";
    begin
        if LineOrColumn = LineOrColumn::Line then begin
          DimCodeBuf := Rec;
          DimOption := LineDimOption;
        end else begin
          DimCodeBuf := MATRIX_MatrixRecord;
          DimOption := ColumnDimOption;
        end;

        with TheGLAccBudgetBuf do
          case DimOption of
            DimOption::"G/L Account":
              if DimCodeBuf.Totaling <> '' then
                GLAccBudgetBuf.SetFilter("G/L Account Filter",DimCodeBuf.Totaling)
              else
                GLAccBudgetBuf.SetRange("G/L Account Filter",DimCodeBuf.Code);
            //WorkPlan
            DimOption::WorkPlan :
              if DimCodeBuf.Totaling <> '' then
                GLAccBudgetBuf.SetFilter("G/L Account Filter",DimCodeBuf.Totaling)
              else
                GLAccBudgetBuf.SetRange("G/L Account Filter",DimCodeBuf.Code);

            DimOption::Period:
              SetRange("Date Filter",DimCodeBuf."Period Start",DimCodeBuf."Period End");
            DimOption::"Business Unit":
              SetRange("Business Unit Filter",DimCodeBuf.Code);
            DimOption::"Global Dimension 1":
              if DimCodeBuf.Totaling <> '' then
                SetFilter("Global Dimension 1 Filter",DimCodeBuf.Totaling)
              else
                SetRange("Global Dimension 1 Filter",DimCodeBuf.Code);
            DimOption::"Global Dimension 2":
              if DimCodeBuf.Totaling <> '' then
                SetFilter("Global Dimension 2 Filter",DimCodeBuf.Totaling)
              else
                SetRange("Global Dimension 2 Filter",DimCodeBuf.Code);
            DimOption::"Budget Dimension 1":
              if DimCodeBuf.Totaling <> '' then
                SetFilter("Budget Dimension 1 Filter",DimCodeBuf.Totaling)
              else
                SetRange("Budget Dimension 1 Filter",DimCodeBuf.Code);
            DimOption::"Budget Dimension 2":
              if DimCodeBuf.Totaling <> '' then
                SetFilter("Budget Dimension 2 Filter",DimCodeBuf.Totaling)
              else
                SetRange("Budget Dimension 2 Filter",DimCodeBuf.Code);
            DimOption::"Budget Dimension 3":
              if DimCodeBuf.Totaling <> '' then
                SetFilter("Budget Dimension 3 Filter",DimCodeBuf.Totaling)
              else
                SetRange("Budget Dimension 3 Filter",DimCodeBuf.Code);
            DimOption::"Budget Dimension 4":
              if DimCodeBuf.Totaling <> '' then
                SetFilter("Budget Dimension 4 Filter",DimCodeBuf.Totaling)
              else
                SetRange("Budget Dimension 4 Filter",DimCodeBuf.Code);

          end;
    end;

    local procedure BudgetDrillDown()
    var
        GLBudgetEntry: Record "Workplan Entry";
    begin

        GLBudgetEntry.SetRange("Workplan Code",GLBudgetName."Workplan Code");
        if GLAccBudgetBuf.GetFilter("G/L Account Filter") <> '' then
        GLAccBudgetBuf.CopyFilter("G/L Account Filter",GLBudgetEntry."Activity Code");
        if GLAccBudgetBuf.GetFilter("Business Unit Filter") <> '' then
          GLAccBudgetBuf.CopyFilter("Business Unit Filter",GLBudgetEntry."Business Unit Code");
        if GLAccBudgetBuf.GetFilter("Global Dimension 1 Filter") <> '' then
          GLAccBudgetBuf.CopyFilter("Global Dimension 1 Filter",GLBudgetEntry."Global Dimension 1 Code");
        if GLAccBudgetBuf.GetFilter("Global Dimension 2 Filter") <> '' then
          GLAccBudgetBuf.CopyFilter("Global Dimension 2 Filter",GLBudgetEntry."Global Dimension 2 Code");
        if GLAccBudgetBuf.GetFilter("Budget Dimension 1 Filter") <> '' then
          GLAccBudgetBuf.CopyFilter("Budget Dimension 1 Filter",GLBudgetEntry."Budget Dimension 1 Code");
        if GLAccBudgetBuf.GetFilter("Budget Dimension 2 Filter") <> '' then
          GLAccBudgetBuf.CopyFilter("Budget Dimension 2 Filter",GLBudgetEntry."Budget Dimension 2 Code");
        if GLAccBudgetBuf.GetFilter("Budget Dimension 3 Filter") <> '' then
          GLAccBudgetBuf.CopyFilter("Budget Dimension 3 Filter",GLBudgetEntry."Budget Dimension 3 Code");
        if GLAccBudgetBuf.GetFilter("Budget Dimension 4 Filter") <> '' then
          GLAccBudgetBuf.CopyFilter("Budget Dimension 4 Filter",GLBudgetEntry."Budget Dimension 4 Code");
        if GLAccBudgetBuf.GetFilter("Date Filter") <> '' then
          GLAccBudgetBuf.CopyFilter("Date Filter",GLBudgetEntry.Date)
        else
          GLBudgetEntry.SetRange(Date,0D,99991231D);
        with GLBudgetEntry do
          if (GetFilter("Global Dimension 1 Code") <> '') or (GetFilter("Global Dimension 2 Code") <> '') or
             (GetFilter("Business Unit Code") <> '')
          then
            SetCurrentKey("Workplan Code","Activity Code","Business Unit Code","Global Dimension 1 Code")
          else
            SetCurrentKey("Workplan Code","Activity Code",Date);
        PAGE.Run(0,GLBudgetEntry);
    end;

    local procedure CalcAmount(SetColumnFilter: Boolean): Decimal
    begin


        SetCommonFilters(GLAccBudgetBuf);
        SetDimFilters(GLAccBudgetBuf,0);
        if SetColumnFilter then
          SetDimFilters(GLAccBudgetBuf,1);
        GLAccBudgetBuf.CalcFields("Budgeted Amount");
        exit(GLAccBudgetBuf."Budgeted Amount");
    end;

    local procedure ToRoundedValue(OrgAmount: Decimal): Decimal
    var
        NewAmount: Decimal;
    begin
        NewAmount := OrgAmount;
        case RoundingFactor of
          RoundingFactor::"1":
            NewAmount := Round(OrgAmount,1);
          RoundingFactor::"1000":
            NewAmount := Round(OrgAmount / 1000);
          RoundingFactor::"1000000":
            NewAmount := Round(OrgAmount / 1000000);
        end;
        exit(NewAmount);
    end;

    local procedure FromRoundedValue(OrgAmount: Decimal): Decimal
    var
        NewAmount: Decimal;
    begin
        NewAmount := OrgAmount;
        case RoundingFactor of
          RoundingFactor::"1000":
            NewAmount := OrgAmount * 1000;
          RoundingFactor::"1000000":
            NewAmount := OrgAmount * 1000000;
        end;
        exit(NewAmount);
    end;

    procedure Load(MatrixColumns1: array [32] of Text[80];var MatrixRecords1: array [12] of Record "Dimension Code Buffer";CurrentNoOfMatrixColumns: Integer;_LineDimCode: Text[30];_LineDimOption: Integer;_ColumnDimOption: Integer;_GlobalDim1Filter: Code[250];_GlobalDim2Filter: Code[250];_BudgetDim1Filter: Code[250];_BudgetDim2Filter: Code[250];_BudgetDim3Filter: Code[250];_BudgetDim4Filter: Code[250];var _GLBudgetName: Record Workplan;_DateFilter: Text[30];_GLAccFilter: Code[250];_RoundingFactor: Integer;_PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period")
    var
        i: Integer;
    begin
        for i := 1 to 12 do
          MATRIX_CellData[i] := 0;

        for i := 1 to 12 do begin
          if MatrixColumns1[i] = '' then
            MATRIX_CaptionSet[i] := ' '
          else
            MATRIX_CaptionSet[i] := MatrixColumns1[i];
          MatrixRecords[i] := MatrixRecords1[i];
        end;
        if CurrentNoOfMatrixColumns > ArrayLen(MATRIX_CellData) then
          MATRIX_CurrentNoOfMatrixColumn := ArrayLen(MATRIX_CellData)
        else
          MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
        LineDimCode := _LineDimCode;
        LineDimOption := _LineDimOption;
        ColumnDimOption := _ColumnDimOption;
        GlobalDim1Filter := _GlobalDim1Filter;
        GlobalDim2Filter := _GlobalDim2Filter;
        BudgetDim1Filter := _BudgetDim1Filter;
        BudgetDim2Filter := _BudgetDim2Filter;
        BudgetDim3Filter := _BudgetDim3Filter;
        BudgetDim4Filter := _BudgetDim4Filter;
        GLBudgetName:= _GLBudgetName;
        DateFilter := _DateFilter;
        GLAccFilter := _GLAccFilter;
        RoundingFactor := _RoundingFactor;
        PeriodType := _PeriodType;
    end;

    local procedure MATRIX_OnDrillDown(MATRIX_ColumnOrdinal: Integer)
    begin
        MATRIX_MatrixRecord := MatrixRecords[MATRIX_ColumnOrdinal];
        SetCommonFilters(GLAccBudgetBuf);
        SetDimFilters(GLAccBudgetBuf,0);
        SetDimFilters(GLAccBudgetBuf,1);
        BudgetDrillDown;
    end;

    local procedure MATRIX_OnAfterGetRecord(MATRIX_ColumnOrdinal: Integer)
    begin
        if ShowColumnName then
          MatrixHeader := MatrixRecords[MATRIX_ColumnOrdinal].Name
        else
          MatrixHeader := MatrixRecords[MATRIX_ColumnOrdinal].Code;
        MATRIX_MatrixRecord := MatrixRecords[MATRIX_ColumnOrdinal];
        MATRIX_CellData[MATRIX_ColumnOrdinal] := ToRoundedValue(CalcAmount(true));
    end;

    procedure UpdateAmount(MATRIX_ColumnOrdinal: Integer)
    var
        NewAmount: Decimal;
    begin
        if MATRIX_ColumnOrdinal > MATRIX_CurrentNoOfMatrixColumn then
          Error(Text002,MATRIX_CurrentNoOfMatrixColumn);
        MATRIX_MatrixRecord := MatrixRecords[MATRIX_ColumnOrdinal];
        NewAmount := FromRoundedValue(MATRIX_CellData[MATRIX_ColumnOrdinal]);
        if CalcAmount(true) = 0 then; // To set filters correctly
        GLAccBudgetBuf.CalcFields("Budgeted Amount");
        GLAccBudgetBuf.Validate("Budgeted Amount",NewAmount);
        Rec.Amount := ToRoundedValue(CalcAmount(false));
        CurrPage.Update;
    end;

    procedure GLAccountBalanceBudget()
    var
        GLAcc: Record "Workplan Activities";
    begin
        if DimCodeToOption(LineDimCode) = 0 then
          GLAcc.Get(Rec.Code)
        else begin
          if GLAccFilter <> '' then
            GLAcc.SetFilter("No.",GLAccFilter);
          GLAcc.FindFirst;
          GLAcc.Reset;
        end;
        with GLAcc do begin
          SetRange("Budget Filter",BudgetName);
          if BusUnitFilter <> '' then
            SetFilter("Business Unit Filter",BusUnitFilter);
          if GLAccFilter <> '' then
            SetFilter("No.",GLAccFilter);
          if GlobalDim1Filter <> '' then
            SetFilter("Global Dimension 1 Filter",GlobalDim1Filter);
          if GlobalDim2Filter <> '' then
            SetFilter("Global Dimension 2 Filter",GlobalDim2Filter);
        end;
        PAGE.Run(PAGE::"G/L Account Balance/Budget",GLAcc);
    end;

    local procedure FormatLine()
    begin
        Emphasize := Rec."Show in Bold";
        NameIndent := Rec.Indentation;
    end;

    local procedure CopyWorkPlanToBuf(var TheGLAcc: Record "Workplan Activities";var TheDimCodeBuf: Record "Dimension Code Buffer")
    begin
        with TheDimCodeBuf do begin
          Init;
          Code :=TheGLAcc."Activity Code";
          Name := TheGLAcc."Activity Description";
          Totaling := TheGLAcc.Totaling;
          Indentation := TheGLAcc.Indentation;
          "Show in Bold" := TheGLAcc."Account Type" <> TheGLAcc."Account Type"::Posting;
        end;
    end;
}

