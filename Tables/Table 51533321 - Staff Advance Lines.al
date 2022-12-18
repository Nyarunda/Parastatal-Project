table 51533321 "Staff Advance Lines"
{

    fields
    {
        field(1; No; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                if Pay.Get(No) then
                    "Advance Holder" := Pay."Account No.";
            end;
        }
        field(2; "Account No:"; Code[10])
        {
            Editable = false;
            NotBlank = false;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Expense Code" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor WHERE("Vendor Posting Group" = FIELD(Grouping));

            trigger OnValidate()
            begin
                if GLAcc.Get("Account No:") then
                    "Account Name" := CopyStr(GLAcc.Name, 1, 30);
                GLAcc.TestField("Direct Posting", true);
                //"Budgetary Control A/C":=GLAcc."Budget Controlled";
                Pay.SetRange(Pay."No.", No);
                if Pay.FindFirst then begin
                    if Pay."Account No." <> '' then
                        "Advance Holder" := Pay."Account No."
                    else
                        Error('Please Enter the Customer/Account Number');
                end;
            end;
        }
        field(3; "Account Name"; Text[50])
        {
        }
        field(4; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                GenSetup.Get;
                Amount := Round(Amount, GenSetup."Appln. Rounding Precision", '=');

                ImprestHeader.Reset;
                ImprestHeader.SetRange(ImprestHeader."No.", No);
                if ImprestHeader.FindFirst then begin
                    "Date Taken" := ImprestHeader.Date;
                    ImprestHeader.TestField("Responsibility Center");
                    ImprestHeader.TestField("Global Dimension 1 Code");
                    ImprestHeader.TestField("Shortcut Dimension 2 Code");
                    // "Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                    // "Shortcut Dimension 2 Code":=ImprestHeader."Shortcut Dimension 2 Code";
                    // "Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                    // "Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                    "Currency Factor" := ImprestHeader."Currency Factor";
                    "Currency Code" := ImprestHeader."Currency Code";
                    if Purpose = '' then
                        Purpose := ImprestHeader.Purpose;

                end;

                if "Currency Factor" <> 0 then
                    "Amount LCY" := Amount / "Currency Factor"
                else
                    "Amount LCY" := Amount;

                if "Advance Type" = 'PETTY' then
                    if Amount > 10000 then Error('Payment of type::[%1] should not exceed %2', 'PETTY CASH', 10000);
            end;
        }
        field(5; "Due Date"; Date)
        {
        }
        field(6; "Advance Holder"; Code[20])
        {
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(7; "Actual Spent"; Decimal)
        {
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
                ////"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(1,"Global Dimension 1 Code","Dimension Set ID");
            end;
        }
        field(41; "Apply to"; Code[20])
        {
        }
        field(42; "Apply to ID"; Code[20])
        {
        }
        field(44; "Surrender Date"; Date)
        {
        }
        field(45; Surrendered; Boolean)
        {
        }
        field(46; "M.R. No"; Code[20])
        {
        }
        field(47; "Date Issued"; Date)
        {
        }
        field(48; "Type of Surrender"; Option)
        {
            OptionMembers = " ",Cash,Receipt;
        }
        field(49; "Dept. Vch. No."; Code[20])
        {
        }
        field(50; "Cash Surrender Amt"; Decimal)
        {
        }
        field(51; "Bank/Petty Cash"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(52; "Surrender Doc No."; Code[20])
        {
        }
        field(53; "Date Taken"; Date)
        {
        }
        field(54; Purpose; Text[250])
        {
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                ////"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2,"Shortcut Dimension 2 Code","Dimension Set ID");
            end;
        }
        field(79; "Budgetary Control A/C"; Boolean)
        {
        }
        field(83; Committed; Boolean)
        {
        }
        field(84; "Advance Type"; Code[20])
        {
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = CONST(Advance),
                                                                     Blocked = CONST(false));

            trigger OnValidate()
            begin
                ImprestHeader.Reset;
                ImprestHeader.SetRange(ImprestHeader."No.", No);
                if ImprestHeader.FindFirst then begin
                    StaffAdvanceLines."Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
                    StaffAdvanceLines."Shortcut Dimension 2 Code" := ImprestHeader."Shortcut Dimension 2 Code";
                    if (ImprestHeader.Status = ImprestHeader.Status::Posted) or
                        (ImprestHeader.Status = ImprestHeader.Status::Approved) then
                        Error('You Cannot Insert a new record when the status of the document is not Pending');
                end;

                RecPay.Reset;
                RecPay.SetRange(RecPay.Code, "Advance Type");
                RecPay.SetRange(RecPay.Type, RecPay.Type::Advance);
                if RecPay.Find('-') then begin
                    Grouping := RecPay."Default Grouping";
                    "Account No:" := RecPay."G/L Account";
                    "Account Type" := RecPay."Account Type";
                    Validate("Account No:");
                end;

                //TYPE PETTY CASH SHOULD NOT EXCEED 10000
            end;
        }
        field(85; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Currency Factor" <> 0 then
                    "Amount LCY" := Amount / "Currency Factor"
                else
                    "Amount LCY" := Amount;
            end;
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
        field(88; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(89; "Claim Receipt No"; Code[20])
        {
        }
        field(90; "Expenditure Date"; Date)
        {
        }
        field(91; "Attendee/Organization Names"; Text[250])
        {
        }
        field(92; Grouping; Code[20])
        {
            Description = 'Stores Expense Code';
        }
        field(95; "No. Of Units"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcAmount;
            end;
        }
        field(96; "Unit Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcAmount;
            end;
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
        field(5007; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 3);
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                ////"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2,"Shortcut Dimension 2 Code","Dimension Set ID");
            end;
        }
        field(50004; Status; Option)
        {
            CalcFormula = Lookup("Staff Advance Header".Status WHERE("No." = FIELD(No)));
            Description = 'Stores the status of the record in the database';
            FieldClass = FlowField;
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
        }
        field(50006; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Staff,None';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Staff,"None";
        }
    }

    keys
    {
        key(Key1; "Line No.", No)
        {
            SumIndexFields = Amount, "Amount LCY";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ImprestHeader.Reset;
        ImprestHeader.SetRange(ImprestHeader."No.", No);
        if ImprestHeader.FindFirst then begin
            if (ImprestHeader.Status = ImprestHeader.Status::Approved) or
            (ImprestHeader.Status = ImprestHeader.Status::Posted) or
            (ImprestHeader.Status = ImprestHeader.Status::"Pending Approval") then
                Error('You Cannot Delete this record its status is not Pending');
        end;
        TestField(Committed, false);
    end;

    trigger OnInsert()
    begin
        ImprestHeader.Reset;
        ImprestHeader.SetRange(ImprestHeader."No.", No);
        if ImprestHeader.FindFirst then begin
            "Date Taken" := ImprestHeader.Date;
            ImprestHeader.TestField("Responsibility Center");
            ImprestHeader.TestField("Global Dimension 1 Code");
            ImprestHeader.TestField("Shortcut Dimension 2 Code");
            Validate("Global Dimension 1 Code", ImprestHeader."Global Dimension 1 Code");
            Validate("Shortcut Dimension 2 Code", ImprestHeader."Shortcut Dimension 2 Code");
            Validate("Shortcut Dimension 3 Code", ImprestHeader."Shortcut Dimension 3 Code");
            //VALIDATE("Shortcut Dimension 4 Code",ImprestHeader."Shortcut Dimension 4 Code");
            "Dimension Set ID" := ImprestHeader."Dimension Set ID";
            "Currency Factor" := ImprestHeader."Currency Factor";
            "Currency Code" := ImprestHeader."Currency Code";
            if Purpose = '' then
                Purpose := ImprestHeader.Purpose;
        end;
    end;

    trigger OnModify()
    begin
        ImprestHeader.Reset;
        ImprestHeader.SetRange(ImprestHeader."No.", No);
        if ImprestHeader.FindFirst then begin
            if
             (ImprestHeader.Status = ImprestHeader.Status::Approved) or
                (ImprestHeader.Status = ImprestHeader.Status::Posted) then
                //  OR
                //   (ImprestHeader.Status=ImprestHeader.Status::"Pending Approval") THEN
                //ERROR('You Cannot Modify this record its status is not Pending');

                "Date Taken" := ImprestHeader.Date;
            //"Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
            //"Shortcut Dimension 2 Code":=ImprestHeader."Shortcut Dimension 2 Code";
            //"Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
            //"Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
            "Currency Factor" := ImprestHeader."Currency Factor";
            "Currency Code" := ImprestHeader."Currency Code";
            if Purpose = '' then
                Purpose := ImprestHeader.Purpose;

        end;

        TestField(Committed, false);
    end;

    var
        GLAcc: Record "G/L Account";
        Pay: Record "Staff Advance Header";
        ImprestHeader: Record "Staff Advance Header";
        RecPay: Record "Receipts and Payment Types";
        DimVal: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        StaffAdvanceLines: Record "Staff Advance Lines";
        GenSetup: Record "General Ledger Setup";

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Staff advance lines', "Line No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Shortcut Dimension 2 Code");
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

    local procedure CalcAmount()
    begin
        Amount := "No. Of Units" * "Unit Cost";
        Validate(Amount);
    end;
}

