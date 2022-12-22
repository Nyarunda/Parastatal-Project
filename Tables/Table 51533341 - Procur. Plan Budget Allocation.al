table 51533341 "Procur. Plan Budget Allocation"
{
    Caption = 'Procurment Plan Budget Allocation';

    fields
    {
        field(1; Name; Code[30])
        {
            Caption = 'Name';
            Editable = true;
            TableRelation = "Item Budget Name".Name WHERE("Analysis Area" = CONST(Purchase));
        }
        field(2; Description; Text[80])
        {
            CalcFormula = Lookup("Item Budget Name".Description WHERE(Name = FIELD(Name)));
            Caption = 'Description';
            FieldClass = FlowField;
        }
        field(3; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(4; "Budget Dimension 1 Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(1);
            Caption = 'Budget Dimension 1 Code';
            TableRelation = "Dimension Value".Code;
        }
        field(5; "Budget Dimension 2 Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(2);
            Caption = 'Budget Dimension 2 Code';
            TableRelation = "Dimension Value".Code;
        }
        field(6; "Budget Dimension 3 Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(3);
            Caption = 'Budget Dimension 3 Code';
            TableRelation = "Dimension Value".Code;
        }
        field(7; "Budget Dimension 4 Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(4);
            Caption = 'Budget Dimension 4 Code';
            TableRelation = "Dimension Value".Code;
        }
        field(8; "Budget Dimension 5 Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(5);
            Caption = 'Budget Dimension 5 Code';
            TableRelation = "Dimension Value".Code;
        }
        field(9; "Budget Dimension 6 Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(6);
            Caption = 'Budget Dimension 6 Code';
            TableRelation = "Dimension Value".Code;
        }
        field(10; "Start Date"; Date)
        {
        }
        field(11; "Period Type"; Option)
        {
            OptionMembers = Daily,Weekly,Monthly,Quarterly,Annually;
        }
        field(12; "End Date"; Date)
        {
        }
        field(13; "Item No"; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(14; Amount; Decimal)
        {
        }
        field(15; Overwrite; Boolean)
        {
        }
        field(16; "Business Unit"; Code[20])
        {
            TableRelation = "Business Unit".Code;
        }
        field(17; "User ID"; Code[20])
        {
        }
        field(18; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(19; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                /*
                IF "Global Dimension 1 Code" = '' THEN
                  EXIT;
                GetGLSetup;
                ValidateDimValue(GLSetup."Global Dimension 1 Code","Global Dimension 1 Code");
                */

            end;
        }
        field(20; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                /*
                IF "Global Dimension 2 Code" = '' THEN
                  EXIT;
                GetGLSetup;
                ValidateDimValue(GLSetup."Global Dimension 2 Code","Global Dimension 2 Code");
                */

            end;
        }
        field(21; Processed; Boolean)
        {
        }
        field(22; "Analysis Area"; Option)
        {
            OptionCaption = 'Purchase,Item and G/L Account';
            OptionMembers = Purchase,"Item and G/L Account";
        }
        field(23; "Show As"; Option)
        {
            OptionMembers = Quantity,"Cost Amount";
        }
        field(24; "Current G/L Budget"; Code[30])
        {
            TableRelation = "G/L Budget Name";
        }
        field(25; "Current Item Budget"; Code[30])
        {
            TableRelation = "Item Budget Name";
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
        key(Key1; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ItemBudgetName: Record "Item Budget Name";
        Text000: Label 'The dimension value %1 has not been set up for dimension %2.';
        Text001: Label '1,5,,Budget Dimension 1 Code';
        Text002: Label '1,5,,Budget Dimension 2 Code';
        Text003: Label '1,5,,Budget Dimension 3 Code';
        Text004: Label '1,5,,Budget Dimension 4 Code';
        Text005: Label '1,5,,Budget Dimension 5 Code';
        Text006: Label '1,5,,Budget Dimension 6 Code';
        IBudgetName: Record "Item Budget Name";

    procedure GetCaptionClass(BudgetDimType: Integer): Text[250]
    begin
        if IBudgetName.Get(IBudgetName."Analysis Area"::Purchase, Name) then begin
            /*
            IF (IBudgetName."Analysis Area" <> "Analysis Area"::Purchase) OR
               (IBudgetName.Name <> Name)
            THEN
              IF NOT IBudgetName.GET("Analysis Area"::Purchase,Name) THEN
                EXIT('');
            */
            case BudgetDimType of
                1:
                    begin
                        if IBudgetName."Budget Dimension 1 Code" <> '' then
                            exit('1,5,' + IBudgetName."Budget Dimension 1 Code");
                        exit(Text001);
                    end;
                2:
                    begin
                        if IBudgetName."Budget Dimension 2 Code" <> '' then
                            exit('1,5,' + IBudgetName."Budget Dimension 2 Code");
                        exit(Text002);
                    end;
                3:
                    begin
                        if IBudgetName."Budget Dimension 3 Code" <> '' then
                            exit('1,5,' + IBudgetName."Budget Dimension 3 Code");
                        exit(Text003);
                    end;
            end;
        end;

    end;
}

