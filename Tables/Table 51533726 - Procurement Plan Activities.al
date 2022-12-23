table 51533726 "Procurement Plan Activities"
{
    DataCaptionFields = "Code", "Workplan Code";
    DrillDownPageID = "Procurement Plan";
    LookupPageID = "Procurement Plan";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Activity Code';
        }
        field(2; Description; Text[250])
        {
        }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";
        }
        field(4; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(5; Totaling; Text[250])
        {
            Caption = 'Totaling';
            TableRelation = "Procurement Plan Activities";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                /*IF NOT ("Account Type" IN ["Account Type"::Total,"Account Type"::"End-Total"]) THEN
                  FIELDERROR("Account Type");
                CALCFIELDS(Balance);*/

            end;
        }
        field(6; "Business Unit Filter"; Code[10])
        {
            Caption = 'Business Unit Filter';
            FieldClass = FlowFilter;
            TableRelation = "Business Unit";
        }
        field(7; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
            TableRelation = Date;
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(13; "Workplan Code"; Code[20])
        {
            //TableRelation = "Procurement Plan"."Workplan Code" WHERE(Blocked = CONST(false));
        }
        field(14; "Converted to Budget"; Boolean)
        {
        }
        field(16; "Strategic Plan Desc"; Text[100])
        {
        }
        field(17; "Medium term Plan Code"; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                Medium.RESET;
                Medium.SETRANGE(Medium.Code,"Medium term Plan Code");
                IF Medium.FIND('-') THEN BEGIN
                  "Medium term  Plan Desc":=Medium.Description;
                END
                */

            end;
        }
        field(18; "Medium term  Plan Desc"; Text[100])
        {
        }
        field(19; "PC Code"; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                PC.RESET;
                PC.SETRANGE(PC."PC Code","PC Code");
                IF PC.FIND('-') THEN BEGIN
                  "PC Name":=PC."PC Activities";
                END
                */

            end;
        }
        field(20; "PC Name"; Text[100])
        {
        }
        field(21; "Workplan Description"; Text[250])
        {
        }
        field(22; "Amount to Transfer"; Decimal)
        {
        }
        field(23; "Uploaded to Procurement Workpl"; Boolean)
        {
            Caption = 'Uploaded to Procurement Workplan';
        }
        field(24; "Date to Transfer"; Date)
        {

            trigger OnValidate()
            begin
                //Added to ensure that Dates to be transfered are within budetary Control Dates
                // // IF "Date to Transfer"<> 0D THEN
                // // BEGIN
                // //    BudgetControl.RESET;
                // //    IF BudgetControl.GET THEN
                // //    BEGIN
                // //        //  MESSAGE(FORMAT("Date to Transfer" ));
                // //         IF ("Date to Transfer" < BudgetControl."Current Budget Start Date") OR ("Date to Transfer" > BudgetControl."Current Budget End Date")
                // //        THEN
                // //        BEGIN
                // //            ERROR(Text002,"Date to Transfer",BudgetControl."Current Budget Start Date",BudgetControl."Current Budget End Date");
                // //        END;
                // //    END;
                // // END;
            end;
        }
        field(25; "Description 2"; Text[100])
        {
            Editable = false;
        }
        field(26; "Converted to Budget by:"; Text[100])
        {
        }
        field(28; "Unit of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(29; "Maximum Duration"; DateFormula)
        {
        }
        field(30; "Minimum Duration"; DateFormula)
        {
        }
        field(31; "Default RFP Code"; Code[20])
        {
            TableRelation = "Procurement Methods";
        }
        field(32; "Procurement Method Code"; Code[20])
        {
            TableRelation = "Procurement Methods".Code;
        }
        field(33; "Budgeted Amount"; Decimal)
        {
            CalcFormula = Lookup("G/L Budget Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; Quantitys; Decimal)
        {
        }
        field(35; "Expense Code"; Code[30])
        {
            //TableRelation = "Expense Code".Code;
        }
        field(36; "No."; Code[50])
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"."No." WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST(Item)) Item."No." WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No." WHERE(Blocked = CONST(false));

            trigger OnValidate()
            begin
                //    "Description 2":='';
                //    "Unit of Measure":='';
                //    "No.":='';
                //    CLEAR("Maximum Duration");
                //    CLEAR("Minimum Duration");
                //    "Expense Code":='';
                //    Quantity:=0;
                //    "Global Dimension 1 Code":='';
                //    "Shortcut Dimension 2 Code":='';
                //    "Shortcut Dimension 3 Code":='';
                //    "Shortcut Dimension 4 Code":='';
                //    "Procurement Method Code":='';
                //    "Amount to Transfer":=0;
                //    "Date to Transfer":=0D;


                // //    IF Type = Type::Item THEN
                // //    BEGIN
                // //        Item.RESET;
                // //        IF Item.GET("No.") THEN
                // //        BEGIN
                // //            "Description 2":=Item.Description;
                // //            "Unit of Measure":=Item."Base Unit of Measure";
                // //            VALIDATE("Unit of Measure");
                // //        END;
                // //    END;
                // //
                // //    IF Type = Type::"G/L Account" THEN
                // //    BEGIN
                // //        GLAccount.RESET;
                // //        IF GLAccount.GET("No.") THEN
                // //        BEGIN
                // //            "Description 2":=GLAccount.Name;
                // //            "Expense Code":=GLAccount."Expense Code";
                // //        END;
                // //    END;
            end;
        }
        field(37; Type; Option)
        {
            OptionMembers = " ","G/L Account",Item,"Fixed Asset";

            trigger OnValidate()
            begin
                // // VALIDATE("No.");
            end;
        }
        field(38; "Budget Filter"; Code[10])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Global Dimension 2 Code");
            end;
        }
        field(50008; "Global Dimension 1 Filter"; Code[10])
        {
        }
        field(50009; "Global Dimension 2 Filter"; Code[10])
        {
        }
        field(50010; Preference; Option)
        {
            OptionCaption = ',Agpo,Open';
            OptionMembers = ,Agpo,Open;
        }
        field(50011; "Unit Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                // //  CalcTotals
            end;
        }
        field(50012; Quantity; Integer)
        {

            trigger OnValidate()
            begin
                // //  CalcTotals
            end;
        }
        field(50013; "Unit Cost2"; Decimal)
        {
        }
        field(50015; "Received Qty."; Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line".Quantity WHERE("Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                                  "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Code")));
            //"Activity Code" = FIELD(Code)
            //"Workplan Code" = FIELD("Workplan Code"),
            Description = 'Flowfield picks from received items using workplan code, and dimensions';
            FieldClass = FlowField;
        }
        field(50016; "Line Amount Inv"; Decimal)
        {
            CalcFormula = Sum("Purch. Inv. Line"."Amount Including VAT" WHERE("Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                                               "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Code"))); //"Activity Code" = FIELD(Code)
            //"Workplan Code" = FIELD("Workplan Code"),

            Description = 'Flowfield picks from received items using workplan code, and dimensions';
            FieldClass = FlowField;
        }
        field(50017; Commited; Boolean)
        {
        }
        field(50018; "Date Commited"; Date)
        {
            Editable = false;
        }
        field(50019; "Document Commited"; Code[10])
        {
            Editable = false;
        }
        field(50020; Q1; Decimal)
        {
        }
        field(50021; Q2; Decimal)
        {
        }
        field(50022; Q3; Decimal)
        {
        }
        field(50023; Q4; Decimal)
        {
        }
        field(50024; Description3; Text[30])
        {
        }
        field(50025; "Workplan description 2"; Text[250])
        {
        }
        field(50026; "Source of Fund"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Source of Fund';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Source of Fund");
            end;
        }
        field(50027; "Activities Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Activities Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Activities Code");
            end;
        }
        field(50028; "Strategic Goal"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Strategic Goal';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Strategic Goal");
            end;
        }
        field(50029; "Procurement Type"; Option)
        {
            OptionCaption = ' ,Program,Procurement';
            OptionMembers = " ","Program",Procurement;
        }
    }

    keys
    {
        key(Key1; "Code", "Budget Filter", "Workplan Code")
        {
        }
        key(Key2; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //IF "Uploaded to Procurement Workpl"  THEN ERROR(Text003);
    end;

    trigger OnModify()
    begin
        //IF "Uploaded to Procurement Workpl"  THEN ERROR(Text003);
    end;

    trigger OnRename()
    begin
        //IF "Uploaded to Procurement Workpl"  THEN ERROR(Text003);
    end;

    var
        Item: Record Item;
        GLAccount: Record "G/L Account";
        WorkplanActivities: Record "Procurement Plan Activities";
        BudgetControl: Record "Budgetary Control Setup";
        Text002: Label 'The current date [%1 ] does not fall within the Budget Dates. Current Budget Dates are between [%2 upto %3]';
        Text003: Label 'You cannot make any changes because this entry has been uploaded to the procurement workplan';
        DimMgt: Codeunit DimensionManagement;

    local procedure CalcTotals()
    begin
        // //  "Amount to Transfer" := "Unit Cost" * Quantity;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        // //  DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        // //  ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        // //  DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
         DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', 'Procurement plan', Code, "Workplan Code"));

        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;
}

