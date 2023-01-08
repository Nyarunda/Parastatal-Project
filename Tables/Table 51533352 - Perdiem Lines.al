table 51533352 "Perdiem Lines"
{
    //DrillDownPageID = 39006214;
    //LookupPageID = 39006214;

    fields
    {
        field(1; No; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Account No:"; Code[10])
        {
            Editable = false;
            NotBlank = false;
            TableRelation = "G/L Account"."No.";// WHERE(Test = FIELD(Grouping));

            trigger OnValidate()
            begin
                if GLAcc.Get("Account No:") then
                    "Account Name" := GLAcc.Name;
                GLAcc.TestField("Direct Posting", true);
                "Budgetary Control A/C" := GLAcc."Budget Controlled";
                Pay.SetRange(Pay."No.", No);
                if Pay.FindFirst then begin
                    if Pay."Account No." <> '' then
                        "Imprest Holder" := Pay."Account No."
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
            Editable = true;

            trigger OnValidate()
            begin

                PerdiemHeader.Reset;
                PerdiemHeader.SetRange(PerdiemHeader."No.", No);
                if PerdiemHeader.FindFirst then begin
                    "Date Taken" := PerdiemHeader.Date;
                    PerdiemHeader.TestField("Responsibility Center");
                    PerdiemHeader.TestField("Global Dimension 1 Code");
                    PerdiemHeader.TestField("Shortcut Dimension 2 Code");
                    "Global Dimension 1 Code" := PerdiemHeader."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PerdiemHeader."Shortcut Dimension 2 Code";
                    //"Shortcut Dimension 3 Code":=PerdiemHeader."Shortcut Dimension 3 Code";
                    //"Shortcut Dimension 4 Code":=PerdiemHeader."Shortcut Dimension 4 Code";
                    //"Dimension Set ID" := PerdiemHeader."Dimension Set ID";
                    "Currency Factor" := PerdiemHeader."Currency Factor";
                    "Currency Code" := PerdiemHeader."Currency Code";
                    if Purpose = '' then
                        Purpose := PerdiemHeader.Purpose;
                    // "Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(1,"Global Dimension 1 Code","Dimension Set ID");
                    //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2,"Shortcut Dimension 2 Code","Dimension Set ID");
                end;

                if "Currency Factor" <> 0 then
                    "Amount LCY" := Amount / "Currency Factor"
                else
                    "Amount LCY" := Amount;
            end;
        }
        field(5; "Due Date"; Date)
        {
        }
        field(6; "Imprest Holder"; Code[20])
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
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
                //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(1,"Global Dimension 1 Code","Dimension Set ID");
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
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2,"Shortcut Dimension 2 Code","Dimension Set ID");
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
            Caption = 'Claim Type';
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = CONST(Perdiem),
                                                                     Blocked = CONST(false));

            trigger OnValidate()
            begin
                PerdiemHeader.Reset;
                PerdiemHeader.SetRange(PerdiemHeader."No.", No);
                if PerdiemHeader.FindFirst then begin
                    if
                     (PerdiemHeader.Status = PerdiemHeader.Status::Approved) or
                     (PerdiemHeader.Status = PerdiemHeader.Status::Posted) then
                        //        (PerdiemHeader.Status=PerdiemHeader.Status::"Pending Approval") THEN
                        Error('You Cannot Insert a new record when the status of the document is not Pending');
                end;

                RecPay.Reset;
                RecPay.SetRange(RecPay.Code, "Advance Type");
                RecPay.SetRange(RecPay.Type, RecPay.Type::Perdiem);
                if RecPay.Find('-') then begin
                    Grouping := RecPay."Default Grouping";
                    "Account No:" := RecPay."G/L Account";
                    Validate("Account No:");
                end;

                PerdiemHeader.Reset;
                PerdiemHeader.SetRange(PerdiemHeader."No.", No);
                if PerdiemHeader.FindFirst then begin
                    NoofDays := (PerdiemHeader."Date of Return" - PerdiemHeader."Date of Departure");
                end;
                //"No of Days":=NoofDays + 1;
                "No of Days" := NoofDays;

                CustomerPostingGroup.Reset;
                CustomerPostingGroup.SetRange(CustomerPostingGroup.Code, RecPay."Default Grouping");
                if CustomerPostingGroup.Find('-') then
                    RecPay.Reset;
                RecPay.SetRange(RecPay.Code, "Advance Type");
                if RecPay.Find('-') then
                    "Account No:" := CustomerPostingGroup."Receivables Account";

                RecPay.Reset;
                RecPay.SetRange(RecPay.Code, "Advance Type");
                if RecPay.Find('-') then
                    "Account No:" := RecPay."G/L Account";
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

            trigger OnValidate()
            begin
                if "Expenditure Date" > Today then
                    Error('Expenditure date cannot be in the future')
            end;
        }
        field(91; "Attendee/Organization Names"; Text[250])
        {
        }
        field(92; Grouping; Code[20])
        {
            Description = 'Stores Expense Code';
        }
        field(102; "Job No."; Code[10])
        {
            TableRelation = Job."No.";

            trigger OnValidate()
            begin
                CheckWipAccount
            end;
        }
        field(103; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

            trigger OnValidate()
            begin
                /*
                IF "Job Task No." <> xRec."Job Task No." THEN
                  VALIDATE("Job Planning Line No.",0);
                IF "Job Task No." = '' THEN BEGIN
                  "Job Quantity" := 0;
                  "Job Currency Factor" := 0;
                  "Job Currency Code" := '';
                  "Job Unit Price" := 0;
                  "Job Total Price" := 0;
                  "Job Line Amount" := 0;
                  "Job Line Discount Amount" := 0;
                  "Job Unit Cost" := 0;
                  "Job Total Cost" := 0;
                  "Job Line Discount %" := 0;
                
                  "Job Unit Price (LCY)" := 0;
                  "Job Total Price (LCY)" := 0;
                  "Job Line Amount (LCY)" := 0;
                  "Job Line Disc. Amount (LCY)" := 0;
                  "Job Unit Cost (LCY)" := 0;
                  "Job Total Cost (LCY)" := 0;
                  EXIT;
                END;
                
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  UpdatePricesFromJobJnlLine;
                END;
                */

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
        field(50000; "Destination Code"; Code[20])
        {
            TableRelation = "Travel Destination"."Destination Code" WHERE(Currency = FIELD("Currency Code"));

            trigger OnValidate()
            begin
                /*
                IF ("Advance Type"='P_DIEM DOMESTIC') OR ("Advance Type"='P_DIEM FOREIGN') THEN
                  BEGIN
                TestStatus;
                      getDestinationRateAndAmounts();
                END;
                */
                //Reset the brare fields
                TestStatus;
                "Daily Rate(Amount)" := 0;
                Amount := 0;

                //Get the customer no
                Pay.Reset;
                Pay.SetRange(Pay."No.", No);
                if Pay.Find('-') then begin
                    CustNo := Pay."Account No.";
                end;
                //Get Employee No
                UserSetup.Reset;
                UserSetup.SetRange(UserSetup."Staff Travel Account", CustNo);
                if UserSetup.FindFirst then begin
                    //EmpNo := UserSetup."Employee No.2"
                end;

                // get the grade
                //     objEmp.RESET;
                //     objEmp.SETRANGE(objEmp."No.",EmpNo);
                //     IF objEmp.FIND('-') THEN BEGIN
                //      EmpGrade:=objEmp."Salary Grade";
                //     END;
                objCust.Reset;
                objCust.SetRange("No.", CustNo);
                if objCust.FindFirst then begin
                    //EmpGrade := objCust."Employee Job Group";
                end;


                PerdiemHeader.Get(No);
                if PerdiemHeader."Perdiem type" = PerdiemHeader."Perdiem type"::Half
                     then begin
                    //get the destination rate for the grade
                    objDestRateEntry.Reset;
                    objDestRateEntry.SetRange(objDestRateEntry."Employee Job Group", EmpGrade);
                    objDestRateEntry.SetRange(objDestRateEntry."Destination Code", "Destination Code");
                    if objDestRateEntry.Find('-') then begin
                        "Daily Rate(Amount)" := (objDestRateEntry."Daily Rate (Amount)" / 2);
                        Amount := "Daily Rate(Amount)" * "No of Days";
                    end;
                end;
                PerdiemHeader.Get(No);
                if PerdiemHeader."Perdiem type" = PerdiemHeader."Perdiem type"::Quarter
                 then begin
                    objDestRateEntry.Reset;
                    objDestRateEntry.SetRange(objDestRateEntry."Employee Job Group", EmpGrade);
                    objDestRateEntry.SetRange(objDestRateEntry."Destination Code", "Destination Code");
                    if objDestRateEntry.Find('-') then begin
                        "Daily Rate(Amount)" := (objDestRateEntry."Daily Rate (Amount)" / 4);
                        Amount := "Daily Rate(Amount)" * "No of Days";
                    end;
                end;

                PerdiemHeader.Get(No);
                if PerdiemHeader."Perdiem type" = PerdiemHeader."Perdiem type"::Full
                 then begin
                    objDestRateEntry.Reset;
                    objDestRateEntry.SetRange(objDestRateEntry."Employee Job Group", EmpGrade);
                    objDestRateEntry.SetRange(objDestRateEntry."Destination Code", "Destination Code");
                    if objDestRateEntry.Find('-') then begin
                        "Daily Rate(Amount)" := objDestRateEntry."Daily Rate (Amount)";
                        Amount := "Daily Rate(Amount)" * "No of Days";
                    end;
                end;

            end;
        }
        field(50001; "No of Days"; Decimal)
        {
            Editable = true;

            trigger OnValidate()
            begin
                TestStatus;
                getDestinationRateAndAmounts();

                if ("Advance Type" = 'P_DIEM DOMESTIC') or ("Advance Type" = 'P_DIEM FOREIGN') then begin
                    Amount := ("No of Clients" * "No of Days" * "Daily Rate(Amount)");
                end
            end;
        }
        field(50002; "Daily Rate(Amount)"; Decimal)
        {

            trigger OnValidate()
            begin
                if ("Advance Type" = 'P_DIEM DOMESTIC') or ("Advance Type" = 'P_DIEM FOREIGN') then begin
                    Amount := ("No of Clients" * "No of Days" * "Daily Rate(Amount)");
                end
            end;
        }
        field(50003; "No of Clients"; Integer)
        {

            trigger OnValidate()
            begin
                if "Advance Type" = 'EXTERNAL' then begin
                    Amount := ("No of Clients" * "No of Days" * "Daily Rate(Amount)");
                end
            end;
        }
        field(50006; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Staff,None';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Staff,"None";
        }
        field(50007; "Engine cc"; Code[10])
        {
            TableRelation = "Mileage Setup"."Engine Capacity";

            trigger OnValidate()
            begin
                MileageSetup.Reset;
                MileageSetup.SetRange(MileageSetup."Engine Capacity", "Engine cc");
                if MileageSetup.Find('-') then begin
                    "Rate Per KM" := MileageSetup."Rate per km";
                end
            end;
        }
        field(50008; "KMs Covered"; Decimal)
        {

            trigger OnValidate()
            begin
                Amount := "Rate Per KM" * "KMs Covered";
            end;
        }
        field(50009; "Rate Per KM"; Decimal)
        {
            Editable = false;
        }
        field(50010; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnLookup()
            begin
                LookupShortcutDimCode(3, "Shortcut Dimension 3 Code");
                Validate("Shortcut Dimension 3 Code");
            end;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
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
        PerdiemHeader.Reset;
        PerdiemHeader.SetRange(PerdiemHeader."No.", No);
        if PerdiemHeader.FindFirst then begin
            if
            //(PerdiemHeader.Status=PerdiemHeader.Status::Approved)
            (PerdiemHeader.Status = PerdiemHeader.Status::Posted) or
            (PerdiemHeader.Status = PerdiemHeader.Status::"Pending Approval") then
                Error('You Cannot Delete this record its status is not Pending');
        end;
        TestField(Committed, false);
    end;

    trigger OnInsert()
    begin
        PerdiemHeader.Reset;
        PerdiemHeader.SetRange(PerdiemHeader."No.", No);
        if PerdiemHeader.FindFirst then begin
            "Date Taken" := PerdiemHeader.Date;
            PerdiemHeader.TestField("Responsibility Center");
            PerdiemHeader.TestField("Global Dimension 1 Code");
            PerdiemHeader.TestField("Shortcut Dimension 2 Code");
            Validate("Global Dimension 1 Code", PerdiemHeader."Global Dimension 1 Code");
            Validate("Shortcut Dimension 2 Code", PerdiemHeader."Shortcut Dimension 2 Code");
            Validate("Shortcut Dimension 3 Code", PerdiemHeader."Shortcut Dimension 3 Code");
            //VALIDATE("Shortcut Dimension 4 Code",PerdiemHeader."Shortcut Dimension 4 Code");
            //"Dimension Set ID" := PerdiemHeader."Dimension Set ID";
            "Currency Factor" := PerdiemHeader."Currency Factor";
            "Currency Code" := PerdiemHeader."Currency Code";
            if Purpose = '' then
                Purpose := PerdiemHeader.Purpose;
        end;
        //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(1,"Global Dimension 1 Code","Dimension Set ID");
        //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2,"Shortcut Dimension 2 Code","Dimension Set ID");
    end;

    trigger OnModify()
    begin
        PerdiemHeader.Reset;
        PerdiemHeader.SetRange(PerdiemHeader."No.", No);
        if PerdiemHeader.FindFirst then begin
            if
                (PerdiemHeader.Status = PerdiemHeader.Status::"Pending Approval") or
                (PerdiemHeader.Status = PerdiemHeader.Status::Posted) or
                (PerdiemHeader.Status = PerdiemHeader.Status::Approved) then
                Error('You Cannot Modify this record its status is not Pending');

            "Date Taken" := PerdiemHeader.Date;
            //    "Global Dimension 1 Code":=PerdiemHeader."Global Dimension 1 Code";
            //    "Shortcut Dimension 2 Code":=PerdiemHeader."Shortcut Dimension 2 Code";
            //    "Shortcut Dimension 3 Code":=PerdiemHeader."Shortcut Dimension 3 Code";
            //    "Shortcut Dimension 4 Code":=PerdiemHeader."Shortcut Dimension 4 Code";
            "Currency Factor" := PerdiemHeader."Currency Factor";
            "Currency Code" := PerdiemHeader."Currency Code";
            if Purpose = '' then
                Purpose := PerdiemHeader.Purpose;

        end;

        //TESTFIELD(Committed,FALSE);
    end;

    var
        GLAcc: Record "G/L Account";
        Pay: Record "Perdiem Header";
        PerdiemHeader: Record "Perdiem Header";
        RecPay: Record "Receipts and Payment Types";
        DimMgt: Codeunit DimensionManagement;
        CustomerPostingGroup: Record "Customer Posting Group";
        MileageSetup: Record "Mileage Setup";
        CustNo: Code[50];
        objCust: Record Customer;
        EmpNo: Code[50];
        objEmp: Record "HR Employees";
        EmpGrade: Code[50];
        objDestRateEntry: Record "Destination Rate Entry";
        TravelDestination: Record "Travel Destination";
        PerdiemLines: Record "Perdiem Lines";
        NoofDays: Decimal;
        UserSetup: Record "User Setup";

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Receipt', "Line No."));
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

    procedure CheckWipAccount()
    var
        FAWIPJob: Record Job;
        FAWIPJobPostingGrp: Record "Job Posting Group";
    begin
        FAWIPJob.Get("Job No.");
        FAWIPJobPostingGrp.Get(FAWIPJob."Job Posting Group");
        TestField("Account Type", "Account Type"::"G/L Account");
        if "Account No:" <> FAWIPJobPostingGrp."WIP Costs Account" then
            Error('Insert the right WIP Account %1', FAWIPJobPostingGrp."WIP Costs Account");
    end;

    local procedure TestStatus()
    var
        ErrStatus: Label 'Document is approved and can not be modified';
    begin
        PerdiemHeader.Get(No);
        if PerdiemHeader.Status = PerdiemHeader.Status::Approved then
            Error(ErrStatus);
    end;

    procedure getDestinationRateAndAmounts()
    begin
        /* //Reset the brare fields
             "Daily Rate(Amount)":=0;
             Amount:=0;

          //Get the customer no
           Pay.RESET;
           Pay.SETRANGE(Pay."No.",No);
           IF Pay.FIND('-') THEN BEGIN
            CustNo:=Pay."Account No.";
           END;
       {
       //Get the Emp No
           objCust.RESET;
           objCust.SETRANGE(objCust."No.",CustNo);
           IF objCust.FIND('-') THEN BEGIN
            EmpNo:=objCust."Employee No."
           END;
           }
         UserSetup.RESET;
         UserSetup.SETRANGE(UserSetup."Staff Travel Account",CustNo);
         IF UserSetup.FINDFIRST THEN BEGIN
          EmpNo:=UserSetup."Employee No."
           END;
           MESSAGE(FORMAT(EmpNo));
       // get the grade
            objEmp.RESET;
            objEmp.SETRANGE(objEmp."No.",EmpNo);
            IF objEmp.FIND('-') THEN BEGIN
             //EmpGrade:=objEmp.Grade;
             EmpGrade:=objEmp."Job Group";
            END;
       //*************half
       PerdiemHeader.GET(No);
       IF PerdiemHeader.Status = PerdiemHeader.Status::"Pending Approval" THEN ERROR('Document is pending approval and can not be modified');
         IF PerdiemHeader."Perdiem type"=PerdiemHeader."Perdiem type"::Half
            THEN BEGIN
       //get the destination rate for the grade
            objDestRateEntry.RESET;
            objDestRateEntry.SETRANGE(objDestRateEntry."Employee Job Group",EmpGrade);
            objDestRateEntry.SETRANGE(objDestRateEntry."Destination Code","Destination Code");
            IF objDestRateEntry.FIND('-') THEN BEGIN
             "Daily Rate(Amount)":=(objDestRateEntry."Daily Rate (Amount)"/2);
            // Amount:=objDestRateEntry."Daily Rate (Amount)"*"No of Days";
            END ELSE IF PerdiemHeader."Perdiem type"=PerdiemHeader."Perdiem type"::Quarter
             THEN BEGIN
            objDestRateEntry.RESET;
            objDestRateEntry.SETRANGE(objDestRateEntry."Employee Job Group",EmpGrade);
            objDestRateEntry.SETRANGE(objDestRateEntry."Destination Code","Destination Code");
            IF objDestRateEntry.FIND('-') THEN BEGIN
             "Daily Rate(Amount)":=(objDestRateEntry."Daily Rate (Amount)"/4);
              END ELSE
            objDestRateEntry.RESET;
            objDestRateEntry.SETRANGE(objDestRateEntry."Employee Job Group",EmpGrade);
            objDestRateEntry.SETRANGE(objDestRateEntry."Destination Code","Destination Code");
            IF objDestRateEntry.FIND('-') THEN BEGIN
             "Daily Rate(Amount)":=objDestRateEntry."Daily Rate (Amount)";
              END;
               END;
         VALIDATE(Amount);
         END;
         */

    end;

    procedure ValidateAmounts()
    begin
        TestStatus;
        "Daily Rate(Amount)" := 0;
        Amount := 0;

        //Get the customer no
        Pay.Reset;
        Pay.SetRange(Pay."No.", No);
        if Pay.Find('-') then begin
            CustNo := Pay."Account No.";
        end;
        //Get Employee No
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."Staff Travel Account", CustNo);
        if UserSetup.FindFirst then begin
            //EmpNo := UserSetup."Employee No.2"
        end;

        // get the grade
        objEmp.Reset;
        objEmp.SetRange(objEmp."No.", EmpNo);
        if objEmp.Find('-') then begin
            EmpGrade := objEmp."Salary Grade";
        end;


        PerdiemHeader.Get(No);
        if PerdiemHeader."Perdiem type" = PerdiemHeader."Perdiem type"::Half
             then begin
            //get the destination rate for the grade
            objDestRateEntry.Reset;
            objDestRateEntry.SetRange(objDestRateEntry."Employee Job Group", EmpGrade);
            objDestRateEntry.SetRange(objDestRateEntry."Destination Code", "Destination Code");
            if objDestRateEntry.Find('-') then begin
                "Daily Rate(Amount)" := (objDestRateEntry."Daily Rate (Amount)" / 2);
                Amount := "Daily Rate(Amount)" * "No of Days";
                Rec.Modify(true);
            end;
        end;
        PerdiemHeader.Get(No);
        if PerdiemHeader."Perdiem type" = PerdiemHeader."Perdiem type"::Quarter
         then begin
            objDestRateEntry.Reset;
            objDestRateEntry.SetRange(objDestRateEntry."Employee Job Group", EmpGrade);
            objDestRateEntry.SetRange(objDestRateEntry."Destination Code", "Destination Code");
            if objDestRateEntry.Find('-') then begin
                "Daily Rate(Amount)" := (objDestRateEntry."Daily Rate (Amount)" / 4);
                Amount := "Daily Rate(Amount)" * "No of Days";
                Rec.Modify(true);
            end;
        end;

        PerdiemHeader.Get(No);
        if PerdiemHeader."Perdiem type" = PerdiemHeader."Perdiem type"::Full
         then begin
            objDestRateEntry.Reset;
            objDestRateEntry.SetRange(objDestRateEntry."Employee Job Group", EmpGrade);
            objDestRateEntry.SetRange(objDestRateEntry."Destination Code", "Destination Code");
            if objDestRateEntry.Find('-') then begin
                "Daily Rate(Amount)" := objDestRateEntry."Daily Rate (Amount)";
                Amount := "Daily Rate(Amount)" * "No of Days";
                Rec.Modify(true);
            end;
        end;
    end;
}

