table 51533333 Workplan
{
    DrillDownPageID = "Workplan List";
    LookupPageID = "Workplan List";

    fields
    {
        field(1; "Workplan Code"; Code[20])
        {
            Description = '60';
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
            Caption = 'Budget Dimension 1 Code';
            Description = '60';
            TableRelation = Dimension;

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
            Caption = 'Budget Dimension 2 Code';
            Description = '60';
            TableRelation = Dimension;

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
            Caption = 'Budget Dimension 3 Code';
            Description = '60';
            TableRelation = Dimension;

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
            Caption = 'Budget Dimension 4 Code';
            Description = '60';
            TableRelation = Dimension;

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
            Description = '60';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Description = '60';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(11; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Pending,Pending Approval,Approved,Cancelled';
            OptionMembers = Pending,"Pending Approval",Approved,Cancelled;

            trigger OnValidate()
            begin
                WorkplanActivities.Reset;
                WorkplanActivities.SetRange(WorkplanActivities."Workplan Code", "Workplan Code");
                if WorkplanActivities.FindSet then
                    repeat
                        WorkplanActivities.Status := Status;
                        WorkplanActivities.Modify;
                    until WorkplanActivities.Next = 0;
            end;
        }
        field(12; "Workplan Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Inactive,Active';
            OptionMembers = " ",Inactive,Active;
        }
        field(39006077; "Entry Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Original,Adjustment';
            OptionMembers = " ",Original,Adjustment;
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

    trigger OnDelete()
    begin
        WorkplanActivities.Reset;
        WorkplanActivities.SetRange(WorkplanActivities."Workplan Code", "Workplan Code");
        if WorkplanActivities.Find('-') then begin
            WorkplanActivities.DeleteAll(true);
        end;
    end;

    var
        Dim: Record Dimension;
        DimSetEntry: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        Text000: Label '%1\You cannot use the same dimension twice in the same budget.';
        Text001: Label 'Updating budget entries @1@@@@@@@@@@@@@@@@@@';
        WorkplanActivities: Record "Workplan Activities";

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

