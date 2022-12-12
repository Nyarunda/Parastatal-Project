table 51533302 "Store Requistion Lines"
{
    DrillDownPageID = "Store Requisition Line";
    LookupPageID = "Store Requisition Line";

    fields
    {
        field(1; "Requistion No"; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                  IF ReqHeader.GET("Requistion No") THEN BEGIN
                    IF ReqHeader."Global Dimension 1 Code"='' THEN
                       ERROR('Please Select the Global Dimension 1 Requisitioning')
                  END;
                 */

            end;
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item';
            OptionMembers = Item;
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = Item WHERE(Blocked = CONST(false));

            trigger OnValidate()
            begin

                //Control: Don't Post Same Item Twice NOT GL's
                if Type = Type::Item then begin
                    RequisitionLine.Reset;
                    RequisitionLine.SetRange(RequisitionLine."Requistion No", "Requistion No");
                    RequisitionLine.SetRange(RequisitionLine."No.", "No.");
                    if RequisitionLine.Find('-') then
                        Error('You Cannot enter two lines for the same Item');
                end;
                //

                "Action Type" := "Action Type"::"Ask for Quote";

                if Type = Type::Item then begin
                    if QtyStore.Get("No.") then
                        Description := QtyStore.Description;
                    "Unit of Measure" := QtyStore."Base Unit of Measure";
                    "Unit Cost" := QtyStore."Unit Cost";
                    "Line Amount" := "Unit Cost" * Quantity;
                    QtyStore.CalcFields(QtyStore.Inventory);
                    "Qty in store" := QtyStore.Inventory;
                    "Gen. Bus. Posting Group" := GenPostGroup."Gen. Bus. Posting Group";
                    "Gen. Prod. Posting Group" := QtyStore."Gen. Prod. Posting Group";

                end;



                /*IF Type=Type::Item THEN BEGIN
                   IF GLAccount.GET("No.") THEN
                      Description:=GLAccount.Name;
                 END;*/

                /*
                {Modified}
                         //Validate Item
                      GLAccount.GET(QtyStore."Item G/L Budget Account");
                      GLAccount.CheckGLAcc;
                
                */

            end;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin

                if Type = Type::Item then begin
                    "Line Amount" := "Unit Cost" * Quantity;
                end;

                if QtyStore.Get("No.") then
                    QtyStore.CalcFields(QtyStore.Inventory);
                "Qty in store" := QtyStore.Inventory;

                if "Last Quantity Issued" > "Qty in store" then
                    Error('You cannot request more  than what is in the store');
            end;
        }
        field(9; "Qty in store"; Decimal)
        {
            FieldClass = Normal;
        }
        field(10; "Request Status"; Enum "Store Status")
        {
            //CalcFormula = Lookup("Store Requistion Header2".Status WHERE ("No."=FIELD("Requistion No")));
            Editable = true;
            //FieldClass = FlowField;
        }
        field(11; "Action Type"; Option)
        {
            OptionMembers = " ",Issue,"Ask for Quote";

            trigger OnValidate()
            begin
                if Type = Type::Item then begin
                    if "Action Type" = "Action Type"::Issue then
                        Error('You cannot Issue a G/L Account please order for it')
                end;
                //Compare Quantity in Store and Qty to Issue
                if Type = Type::Item then begin
                    if "Action Type" = "Action Type"::Issue then begin
                        if Quantity > "Qty in store" then
                            Error('You cannot Issue More than what is available in store')
                    end;
                end;
            end;
        }
        field(12; "Unit of Measure"; Code[20])
        {
            TableRelation = "Item Unit of Measure";
        }
        field(13; "Total Budget"; Decimal)
        {
        }
        field(14; "Current Month Budget"; Decimal)
        {
        }
        field(15; "Unit Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                // IF Type=Type::Item THEN
                "Line Amount" := "Unit Cost" * Quantity;
            end;
        }
        field(16; "Line Amount"; Decimal)
        {
        }
        field(17; "Quantity Requested"; Decimal)
        {
            Caption = 'Quantity Requested';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                Quantity := "Quantity Requested";
                Validate(Quantity);
                "Line Amount" := "Unit Cost" * Quantity;

                if "Quantity Requested" > "Qty in store" then
                    Error('You cannot request more  than what is in the store');
            end;
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(26; "Current Actuals Amount"; Decimal)
        {
        }
        field(27; Committed; Boolean)
        {
        }
        field(57; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(58; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(83; "Issuing Store"; Code[20])
        {
            TableRelation = Location;
        }
        field(84; "Bin Code"; Code[20])
        {
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Issuing Store"));
        }
        field(85; "FA No."; Code[20])
        {
            TableRelation = "Fixed Asset"."No.";
        }
        field(86; "Maintenance Code"; Code[10])
        {
            Caption = 'Maintenance Code';
            TableRelation = Maintenance;

            trigger OnValidate()
            begin
                /*
                IF "Maintenance Code" <> '' THEN
                  TESTFIELD("FA Posting Type","FA Posting Type"::Maintenance);
                */

            end;
        }
        field(87; "Last Date of Issue"; Date)
        {
        }
        field(88; "Last Quantity Issued"; Decimal)
        {
        }
        field(89; Remarks; Text[250])
        {
        }
        field(92; new; Code[10])
        {
            DataClassification = ToBeClassified;
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
        }
        field(50000; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(50001; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(39003900; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            Editable = false;
        }
        field(39003901; "Item Status"; Option)
        {
            OptionMembers = ,Functional,Faulty;
        }
    }

    keys
    {
        key(Key1; "Requistion No", "Line No.")
        {
            SumIndexFields = "Line Amount";
        }
        key(Key2; "No.", Type)
        {
            SumIndexFields = Quantity;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /* ReqHeader.RESET;
         ReqHeader.SETRANGE(ReqHeader."No.","Requistion No");
         IF ReqHeader.FIND('-') THEN
          IF ReqHeader.Status<>ReqHeader.Status::Open THEN
              ERROR('You Cannot Delete Entries if status is not Pending')
         */

    end;

    trigger OnInsert()
    begin
        "Line Amount" := "Unit Cost" * Quantity;

        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."No.", "Requistion No");
        if ReqHeader.Find('-') then begin
            "Shortcut Dimension 1 Code" := ReqHeader."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ReqHeader."Shortcut Dimension 2 Code";
            "Dimension Set ID" := ReqHeader."Dimension Set ID";
            "Issuing Store" := ReqHeader."Issuing Store";
            if ReqHeader.Status <> ReqHeader.Status::Open then
                Error('You Cannot Enter Entries if status is not Pending')
        end;
    end;

    trigger OnModify()
    begin
        if Type = Type::Item then
            "Line Amount" := "Unit Cost" * Quantity;
        /*
         ReqHeader.RESET;
         ReqHeader.SETRANGE(ReqHeader."No.","Requistion No");
         IF ReqHeader.FIND('-') THEN BEGIN
          //"Shortcut Dimension 1 Code":=ReqHeader."Global Dimension 1 Code";
          //"Shortcut Dimension 2 Code":=ReqHeader."Shortcut Dimension 2 Code";
        //  "Shortcut Dimension 3 Code":=ReqHeader."Shortcut Dimension 3 Code";
        //  "Shortcut Dimension 4 Code":=ReqHeader."Shortcut Dimension 4 Code";
        //  IF ReqHeader.Status<>ReqHeader.Status::Open THEN
        //      ERROR('You Cannot Modify Entries if status is not Pending')
         END;
         */

    end;

    var
        GLAccount: Record "G/L Account";
        GenLedSetup: Record "General Ledger Setup";
        QtyStore: Record Item;
        GenPostGroup: Record "General Posting Setup";
        Budget: Decimal;
        CurrMonth: Code[10];
        CurrYR: Code[10];
        BudgDate: Text[30];
        ReqHeader: Record "Store Requistion Header";
        BudgetDate: Date;
        YrBudget: Decimal;
        RequisitionLine: Record "Store Requistion Lines";
        Text031: Label 'You cannot define item tracking on this line because it is linked to production order %1.';
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        DimMgt: Codeunit DimensionManagement;

    procedure OpenItemTrackingLines()
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        if "Lot No." <> '' then
            Error(Text031, "Lot No.");

        TestField(Quantity);

        //ReservePurchLine.CallItemTrackingS11(Rec);
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Payment', "Line No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}

