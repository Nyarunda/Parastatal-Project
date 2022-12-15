table 51533358 "Evaluation Parameter Header"
{

    fields
    {
        field(1; "Criteria Code"; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Criteria Code" <> xRec."Criteria Code" then begin
                    PurchSetup.Get;
                    //NoSeriesMgt.TestManual(PurchSetup."Requisition Default Vendor");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Criteria Description"; Text[100])
        {
        }
        field(3; "Evaluation  Period"; Code[20])
        {
            TableRelation = "Evaluation Year".Code;

            trigger OnValidate()
            begin
                EvaluationYear.Reset;
                EvaluationYear.SetRange(Code, "Evaluation  Period");
                if EvaluationYear.FindFirst then begin
                    "Evaluation Start Period" := EvaluationYear."Start Date";
                    "Evaluation  End Period" := EvaluationYear."End Date";
                    "Criteria Description" := EvaluationYear.Description;
                end;
            end;
        }
        field(4; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                Vend.Reset;
                Vend.SetRange(Vend."No.", "Vendor No.");
                if Vend.Find('-') then
                    "Vendor Name" := Vend.Name;
                "Vendor Category" := Vend."Vendor Category";

                EvaluationParameterLine.Reset;
                EvaluationParameterLine.SetRange(EvaluationParameterLine.Code, "Criteria Code");
                if EvaluationParameterLine.Find('-') then begin
                    //Clear existing data
                    EvaluationParameterLine.DeleteAll;
                end;


                EValCriteria.Reset;
                if EValCriteria.FindFirst then begin
                    repeat
                        //Populate Lines
                        EvaluationParameterLine.Init;
                        EvaluationParameterLine."Line No." := GetLastEntryNo;
                        EvaluationParameterLine."Vendor No" := "Vendor No.";
                        if Vend.Get("Vendor No.") then
                            EvaluationParameterLine."Vendor Name" := Vend.Name;
                        EvaluationParameterLine.Code := "Criteria Code";
                        EvaluationParameterLine."Parameter Code" := EValCriteria.Code;
                        EvaluationParameterLine."Parameter description" := EValCriteria.Description;
                        EvaluationParameterLine."Max. Score" := EValCriteria."Actual Weight Assigned";
                        EvaluationParameterLine.Insert;
                    until EValCriteria.Next = 0;
                end;
                Message('Process Complete');
            end;
        }
        field(5; "Total Expected Value"; Decimal)
        {
            CalcFormula = Sum("Evaluation Parameter Line"."Max. Score" WHERE(Code = FIELD("Criteria Code")));
            FieldClass = FlowField;
        }
        field(6; "Overall Comment"; Text[100])
        {
        }
        field(7; "Total Actuals Value"; Decimal)
        {
            CalcFormula = Sum("Evaluation Parameter Line"."Actuals Scores" WHERE(Code = FIELD("Criteria Code")));
            FieldClass = FlowField;
        }
        field(8; "Vendor Name"; Text[100])
        {
        }
        field(50000; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50001; "Evaluation Start Period"; Date)
        {
        }
        field(50002; "Evaluation  End Period"; Date)
        {
        }
        field(50003; "Evaluation Type"; Code[20])
        {
        }
        field(50004; "Contract Name"; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE(Status = CONST(Released));
        }
        field(50005; "Eval Criteria Code"; Code[20])
        {
            TableRelation = "Evaluation Criterial Header".Code;
        }
        field(50006; Status; Option)
        {
            OptionMembers = Open,Pending,Approved;
        }
        field(50007; "Vendor Category"; Code[30])
        {
            //TableRelation = "Vendor Categories";
        }
    }

    keys
    {
        key(Key1; "Criteria Code")
        {
        }
        key(Key2; "Evaluation  Period", "Criteria Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Criteria Code" = '' then begin
            PurchSetup.Get;
            //PurchSetup.TestField(PurchSetup."Requisition Default Vendor");
            //NoSeriesMgt.InitSeries(PurchSetup."Requisition Default Vendor", xRec."No. Series", 0D, "Criteria Code", "No. Series");
        end;
    end;

    var
        EvaluationParameterLine: Record "Evaluation Parameter Line";
        Vend: Record Vendor;
        lastno: Integer;
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EValCriteria: Record "Evaluation Criterial Header";
        EvaluationParameterLine_2: Record "Evaluation Parameter Line";
        EvaluationYear: Record "Evaluation Year";

    local procedure GetLastEntryNo() LastLineNum: Integer
    var
        EvaluationParameterLine_2: Record "Evaluation Parameter Line";
    begin
        EvaluationParameterLine_2.Reset;
        if EvaluationParameterLine_2.Find('+') then begin
            LastLineNum := EvaluationParameterLine_2."Line No." + 1;
        end else begin
            LastLineNum := 1000;
        end;
    end;
}

