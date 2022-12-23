table 51533733 "Procurement Plan"
{
    Caption = 'Workplan';
    DrillDownPageID = "Procurement Plan List";
    LookupPageID = "Procurement Plan List";

    fields
    {
        field(1; "Workplan Code"; Code[30])
        {
        }
        field(2; "Workplan Description"; Text[250])
        {
        }
        field(3; Blocked; Boolean)
        {
            Caption = 'Blocked';

            trigger OnValidate()
            begin
                if Confirm('Are you sure you want to make this change?', false) = false then Error('Process aborted');
            end;
        }
        field(4; "Budget Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Budget Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                /*IF "Budget Dimension 1 Code" <> xRec."Budget Dimension 1 Code" THEN BEGIN
                  IF Dim.CheckIfDimUsed("Budget Dimension 1 Code",9,"WorkPlan Name",'',0) THEN
                    ERROR(Text000,Dim.GetCheckDimErr);
                  MODIFY;
                  UpdateBudgetDim("Budget Dimension 1 Code",0);
                END;*/

            end;
        }
        field(5; "Budget Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Budget Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                /*IF "Budget Dimension 2 Code" <> xRec."Budget Dimension 2 Code" THEN BEGIN
                  IF Dim.CheckIfDimUsed("Budget Dimension 2 Code",10,Name,'',0) THEN
                    ERROR(Text000,Dim.GetCheckDimErr);
                  MODIFY;
                  UpdateBudgetDim("Budget Dimension 2 Code",1);
                END;*/

            end;
        }
        field(6; "Budget Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Budget Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                /*IF "Budget Dimension 3 Code" <> xRec."Budget Dimension 3 Code" THEN BEGIN
                  IF Dim.CheckIfDimUsed("Budget Dimension 3 Code",11,Name,'',0) THEN
                    ERROR(Text000,Dim.GetCheckDimErr);
                  MODIFY;
                  UpdateBudgetDim("Budget Dimension 3 Code",2);
                END;*/

            end;
        }
        field(7; "Budget Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Budget Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                /*IF "Budget Dimension 4 Code" <> xRec."Budget Dimension 4 Code" THEN BEGIN
                  IF Dim.CheckIfDimUsed("Budget Dimension 4 Code",12,Name,'',0) THEN
                    ERROR(Text000,Dim.GetCheckDimErr);
                  MODIFY;
                  UpdateBudgetDim("Budget Dimension 4 Code",3);
                END;*/

            end;
        }
        field(8; "Last Year"; Boolean)
        {
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(11; Status; Option)
        {
            OptionCaption = 'Pending,Pending Approval,Approved,Cancelled';
            OptionMembers = Pending,"Pending Approval",Approved,Cancelled;
        }
        field(12; "Source of Funds"; Text[30])
        {
        }
        field(13; Quarter; Code[2])
        {
        }
    }

    keys
    {
        key(Key1; "Workplan Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Dim: Record Dimension;
        DimSetEntry: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        Text000: Label '%1\You cannot use the same dimension twice in the same budget.';
        Text001: Label 'Updating budget entries @1@@@@@@@@@@@@@@@@@@';

    local procedure GetDimValCode(DimSetID: Integer; DimCode: Code[20]): Code[20]
    begin
        if DimCode = '' then
            exit('');
        if TempDimSetEntry.Get(DimSetID, DimCode) then
            exit(TempDimSetEntry."Dimension Value Code");
        if DimSetEntry.Get(DimSetID, DimCode) then
            TempDimSetEntry := DimSetEntry
        else begin
            TempDimSetEntry.Init;
            TempDimSetEntry."Dimension Set ID" := DimSetID;
            TempDimSetEntry."Dimension Code" := DimCode;
        end;
        TempDimSetEntry.Insert;
        exit(TempDimSetEntry."Dimension Value Code")
    end;
}

