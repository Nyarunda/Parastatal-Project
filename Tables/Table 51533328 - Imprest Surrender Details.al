table 51533328 "Imprest Surrender Details"
{

    fields
    {
        field(1; "Surrender Doc No."; Code[20])
        {
            Editable = false;
            NotBlank = true;

            trigger OnValidate()
            begin
                // IF Pay.GET(No) THEN
                // "Imprest Holder":=Pay."Account No.";
            end;
        }
        field(2; "Account No:"; Code[10])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = CONST(true));

            trigger OnValidate()
            begin
                /*
                IF GLAcc.GET("Account No:") THEN
                 "Account Name":=GLAcc.Name;
                 GLAcc.TESTFIELD("Direct Posting",TRUE);
                IF Pay.GET("Surrender Doc No.") THEN BEGIN
                 IF Pay."Account No."<>'' THEN
                "Imprest Holder":=Pay."Account No."
                  ELSE
                  ERROR('Please Enter the Customer/Account Number');
                END;
                 */

            end;
        }
        field(3; "Account Name"; Text[65])
        {
            Editable = false;
        }
        field(4; Amount; Decimal)
        {
            Editable = false;
        }
        field(5; "Due Date"; Date)
        {
            Editable = false;
        }
        field(6; "Imprest Holder"; Code[20])
        {
            Editable = true;
            TableRelation = Customer."No.";
        }
        field(7; "Actual Spent"; Decimal)
        {

            trigger OnValidate()
            begin
                /*IF "Actual Spent">Amount THEN
                  ERROR('The Actual Spent Cannot be more than the Issued Amount');
                IF "Currency Factor"<>0 THEN
                   "Amount LCY":="Actual Spent"/"Currency Factor"
                  ELSE
                     "Amount LCY":="Actual Spent";*/

            end;
        }
        field(8; "Apply to"; Code[20])
        {
            Editable = false;
        }
        field(9; "Apply to ID"; Code[20])
        {
            Editable = false;
        }
        field(10; "Surrender Date"; Date)
        {
            Editable = false;
        }
        field(11; Surrendered; Boolean)
        {
            Editable = false;
        }
        field(12; "Cash Receipt No"; Code[20])
        {
            TableRelation = "Receipt Line".No WHERE("Account No." = FIELD("Imprest Holder"),
                                                     Posted = CONST(true));

            trigger OnValidate()
            begin
                /*CustLedger.RESET;
                CustLedger.SETRANGE(CustLedger."Document No.","Cash Receipt No");
                CustLedger.SETRANGE(CustLedger."Source Code",'CASHRECJNL');
                CustLedger.SETRANGE(CustLedger.Open,TRUE);
                IF CustLedger.FIND('-') THEN
                 "Cash Receipt Amount":=ABS(CustLedger.Amount)
                ELSE BEGIN
                   "Cash Receipt Amount":=0;
                   //MESSAGE();
                END;*/
                //"Cust. Ledger Entry"."Document No." WHERE (Source Code=CONST(CASHRECJNL),Open=CONST(Yes),Customer No.=FIELD(Account No:))
                "Cash Receipt Amount" := 0;
                ReceiptLine.Reset;
                ReceiptLine.SetRange(ReceiptLine.No, Rec."Cash Receipt No");
                if ReceiptLine.Find('-') then begin
                    "Cash Receipt Amount" := ReceiptLine.Amount;
                end;

            end;
        }
        field(13; "Date Issued"; Date)
        {
            Editable = false;
        }
        field(14; "Type of Surrender"; Option)
        {
            OptionMembers = " ",Cash,Receipt;
        }
        field(15; "Dept. Vch. No."; Code[20])
        {
        }
        field(16; "Cash Surrender Amt"; Decimal)
        {
        }
        field(17; "Bank/Petty Cash"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(18; " Doc No."; Code[20])
        {
            Editable = false;
        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(20; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(27; "VAT Prod. Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(28; "Imprest Type"; Code[20])
        {
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = CONST(Imprest));
        }
        field(46; "Imprest Issue Doc. No"; Code[20])
        {

            trigger OnLookup()
            var
                ImpHeader: Record "Imprest Header";
            begin
            end;
        }
        field(85; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(86; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(87; "Amount LCY"; Decimal)
        {
        }
        field(88; "Cash Surrender Amt LCY"; Decimal)
        {
        }
        field(89; "Imprest Req Amt LCY"; Decimal)
        {
        }
        field(90; "Cash Receipt Amount"; Decimal)
        {
            Editable = false;
        }
        field(91; "Line No."; Integer)
        {
        }
        field(200; "Internal Memo No"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Internal Memo"."No." WHERE ("Dimension Set ID"=FIELD("Dimension Set ID"));
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions
            end;
        }
        field(481; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(482; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(483; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(484; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(485; "Line on Original Document"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(486; Purpose; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(487; Rate; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(488; "Amount Per Day"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(489; "No Of Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Surrender Doc No.", "Line No.")
        {
            SumIndexFields = "Amount LCY", "Imprest Req Amt LCY", "Actual Spent";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*
        Pay.RESET;
        Pay.SETRANGE(Pay.No,"Surrender Doc No.");
        IF Pay.FIND('-') THEN
           IF (Pay.Status=Pay.Status::Posted) OR (Pay.Status=Pay.Status::"Pending Approval")
           OR (Pay.Status=Pay.Status::Approved)THEN
              ERROR('This Document is already Send for Approval/Approved or Posted');
      */

    end;

    trigger OnModify()
    begin
        Pay.Reset;
        Pay.SetRange(Pay.No, "Surrender Doc No.");
        if Pay.Find('-') then
            if (Pay.Status = Pay.Status::Posted) or (Pay.Status = Pay.Status::"Pending Approval")
            or (Pay.Status = Pay.Status::Approved) then
                Error(ErrorTextApproved);
    end;

    var
        GLAcc: Record "G/L Account";
        Pay: Record "Imprest Surrender Header";
        Dim: Record Dimension;
        CustLedger: Record "Cust. Ledger Entry";
        Text000: Label 'Receipt No %1 Is already Used in Another Document';
        DimMgt: Codeunit DimensionManagement;
        ReceiptLine: Record "Receipt Line";
        CashRcpt: Decimal;
        ErrorTextApproved: Label 'This Document is already Send for Approval/Approved or Posted';

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Imprest', "Line No."));
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

    procedure CalcCashReceiptAmount()
    begin
        CashRcpt := 0;
        CashRcpt := Amount - "Actual Spent";
        "Cash Receipt Amount" := CashRcpt;
        Modify;
    end;
}

