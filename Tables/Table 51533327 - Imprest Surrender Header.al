table 51533327 "Imprest Surrender Header"
{
    DrillDownPageID = "Imprest Surrender List";
    LookupPageID = "Imprest Surrender List";

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                if No <> xRec.No then begin
                    GenLedgerSetup.Get;
                    NoSeriesMgt.TestManual(GenLedgerSetup."Imprest Surrender No");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Surrender Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Type; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = FILTER(Payment));

            trigger OnValidate()
            begin

                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);

                if RecPayTypes.Find('-') then begin
                    Grouping := RecPayTypes."Default Grouping";
                end;

                if RecPayTypes.Find('-') then begin
                    "Account Type" := RecPayTypes."Account Type";
                    "Transaction Name" := RecPayTypes.Description;

                    if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" then begin
                        RecPayTypes.TestField(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."G/L Account";
                        Validate("Account No.");
                    end;

                    //Banks
                    if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"Bank Account" then begin
                        //RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."Bank Account";
                        Validate("Account No.");
                    end;


                end;

                //VALIDATE("Account No.");
            end;
        }
        field(4; "Pay Mode"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Cash,Cheque,EFT,"Custom 1","Custom 2","Custom 3","Custom 4","Custom 5";
        }
        field(5; "Cheque No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Cheque Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Cash Payments Header";
        }
        field(9; "Received From"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "On Behalf Of"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Cashier; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Account Type"; Option)
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                Cust.Reset;
                Cust.SetRange(Cust."No.", "Account No.");
                if Cust.Find('-') then
                    "Account Name" := Cust.Name;


                /*
                "Account Name":='';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code,Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type,RecPayTypes.Type::Payment);
                
                IF "Account Type" IN ["Account Type"::"G/L Account","Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"]
                THEN
                
                CASE "Account Type" OF
                  "Account Type"::"G/L Account":
                    BEGIN
                      GLAcc.GET("Account No.");
                      "Account Name":=GLAcc.Name;
                      "VAT Code":=RecPayTypes."VAT Code";
                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                      "Global Dimension 1 Code":='';
                    END;
                  "Account Type"::Customer:
                    BEGIN
                      Cust.GET("Account No.");
                      "Account Name":=Cust.Name;
                //      "VAT Code":=Cust."Default Withholding Tax Code";
                //      "Withholding Tax Code":=Cust."Default Withholding Tax Code";
                      "Global Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    END;
                  "Account Type"::Vendor:
                    BEGIN
                      Vend.GET("Account No.");
                      "Account Name":=Vend.Name;
                //      "VAT Code":=Vend."Default VAT Code";
                //      "Withholding Tax Code":=Vend."Default Withholding Tax Code";
                      "Global Dimension 1 Code":=Vend."Global Dimension 1 Code";
                    END;
                  "Account Type"::"Bank Account":
                    BEGIN
                      BankAcc.GET("Account No.");
                      "Account Name":=BankAcc.Name;
                      "VAT Code":=RecPayTypes."VAT Code";
                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                      "Global Dimension 1 Code":=BankAcc."Global Dimension 1 Code";
                
                    END;
                    {
                  "Account Type"::"Fixed Asset":
                    BEGIN
                      FA.GET("Account No.");
                      "Account Name":=FA.Description;
                      "VAT Code":=FA."Default VAT Code";
                      "Withholding Tax Code":=FA."Default Withholding Tax Code";
                       "Global Dimension 1 Code":=FA."Global Dimension 1 Code";
                    END;
                    }
                END;
                */

            end;
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Account Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Date Posted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Time Posted"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Posted By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Transaction Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Net Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(29; Payee; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name;

                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(31; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Global Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;

                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(33; "Bank Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Cashier Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(35; Status; Enum "Impreset Surrender Statuts")
        {
            DataClassification = ToBeClassified;
        }
        field(37; Grouping; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Posting Group".Code;
        }
        field(38; "Payment Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Normal,"Petty Cash";
        }
        field(39; "Bank Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Normal,"Petty Cash";
        }
        field(40; "PV Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Normal,Other;
        }
        field(42; "Apply to ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Imprest Issue Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(45; Surrendered; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(46; "Imprest Issue Doc. No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Imprest Header"."No." WHERE("Account No." = FIELD("Account No."),
                                                          Posted = CONST(true),
                                                          "Surrender Status" = CONST(" "));

            trigger OnValidate()
            var
            //Memo: Record "Internal Memo";
            begin

                PaymentRequest.Reset;
                PaymentRequest.SetRange(PaymentRequest."Imprest Issue Doc. No", "Imprest Issue Doc. No");
                if PaymentRequest.FindFirst then Error(Text0001, PaymentRequest.No);

                /*Copy the details from the payments header tableto the imprest surrender table to enable the user work on the same document*/
                /*Retrieve the header details using the get statement*/

                PayHeader.Reset;
                PayHeader.Get(Rec."Imprest Issue Doc. No");

                /*Copy the details to the user interface*/
                "Paying Bank Account" := PayHeader."Paying Bank Account";
                Payee := PayHeader.Payee;
                "Internal Memo No" := PayHeader."Internal Memo No";
                Validate("Internal Memo No");
                "Date of Departure" := PayHeader."Date of Departure";
                "Date of Return" := PayHeader."Date of Return";
                PayHeader.CalcFields(PayHeader."Total Net Amount");
                Amount := PayHeader."Total Net Amount";
                "Amount Surrendered LCY" := PayHeader."Total Net Amount LCY";
                //Currencies
                "Currency Factor" := PayHeader."Currency Factor";
                "Currency Code" := PayHeader."Currency Code";

                "Date Posted" := PayHeader."Date Posted";
                // "Global Dimension 1 Code":=PayHeader."Global Dimension 1 Code";
                // //VALIDATE("Global Dimension 1 Code");
                // "Shortcut Dimension 2 Code":=PayHeader."Shortcut Dimension 2 Code";
                // //VALIDATE("Shortcut Dimension 2 Code");
                // "Shortcut Dimension 3 Code":=PayHeader."Shortcut Dimension 3 Code";
                // Dim3:=PayHeader.Dim3;
                // "Shortcut Dimension 4 Code":=PayHeader."Shortcut Dimension 4 Code";
                // Dim4:=PayHeader.Dim4;
                // "Shortcut Dimension 5 code":=PayHeader."Shortcut Dimension 5 Code";
                // "Dimension Set ID":=PayHeader."Dimension Set ID";
                /** 
                if Memo.Get(PayHeader."Internal Memo No") then begin
                    PayHeader."Global Dimension 1 Code" := Memo."Shortcut Dimension 1 Code";
                    PayHeader."Shortcut Dimension 2 Code" := Memo."Shortcut Dimension 2 Code";
                    PayHeader."Shortcut Dimension 3 Code" := Memo."Shortcut Dimension 3 Code";
                    PayHeader."Shortcut Dimension 4 Code" := Memo."Shortcut Dimension 4 Code";
                    PayHeader."Shortcut Dimension 5 Code" := Memo."Shortcut Dimension 5 Code";
                    PayHeader."Dimension Set ID" := Memo."Dimension Set ID";
                end;
                **/

                "Imprest Issue Date" := PayHeader.Date;

                //Get Line No
                if ImpSurrLine.FindLast then
                    LineNo := ImpSurrLine."Line No." + 1
                else
                    LineNo := LineNo + 1;

                /*Copy the detail lines from the imprest details table in the database*/
                PayLine.Reset;
                PayLine.SetRange(PayLine.No, "Imprest Issue Doc. No");
                if PayLine.Find('-') then /*Copy the lines to the line table in the database*/
                  begin
                    repeat
                        ImpSurrLine.Init;
                        ImpSurrLine."Surrender Doc No." := Rec.No;
                        ImpSurrLine."Account No:" := PayLine."Account No:";
                        ImpSurrLine."Imprest Type" := PayLine."Advance Type";
                        ImpSurrLine.Validate(ImpSurrLine."Account No:");
                        ImpSurrLine."Account Name" := PayLine."Account Name";
                        ImpSurrLine.Amount := PayLine.Amount;
                        ImpSurrLine."Due Date" := PayLine."Due Date";
                        ImpSurrLine."Imprest Holder" := PayLine."Imprest Holder";
                        //ImpSurrLine."Actual Spent":=PayLine."Actual Spent";
                        ImpSurrLine."Actual Spent" := PayLine.Amount;
                        ImpSurrLine."Apply to" := PayLine."Apply to";
                        ImpSurrLine."Apply to ID" := PayLine."Apply to ID";
                        ImpSurrLine."Surrender Date" := PayLine."Surrender Date";
                        ImpSurrLine.Surrendered := PayLine.Surrendered;
                        ImpSurrLine."Cash Receipt No" := PayLine."M.R. No";
                        ImpSurrLine."Date Issued" := PayLine."Date Issued";
                        ImpSurrLine."Type of Surrender" := PayLine."Type of Surrender";
                        ImpSurrLine."Dept. Vch. No." := PayLine."Dept. Vch. No.";
                        ImpSurrLine."Currency Factor" := PayLine."Currency Factor";
                        ImpSurrLine."Currency Code" := PayLine."Currency Code";
                        ImpSurrLine."Imprest Req Amt LCY" := PayLine."Amount LCY";
                        //      IF Memo.GET(ImpSurrLine."Internal Memo No") THEN BEGIN
                        ImpSurrLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                        ImpSurrLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                        ImpSurrLine."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
                        ImpSurrLine."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
                        ImpSurrLine."Shortcut Dimension 5 Code" := "Shortcut Dimension 5 code";
                        ImpSurrLine."Dimension Set ID" := "Dimension Set ID";
                        ImpSurrLine."Staff No." := "Account No.";
                        ImpSurrLine."Line on Original Document" := true;
                        ImpSurrLine.Purpose := PayLine.Purpose;
                        ImpSurrLine.Rate := PayLine."Daily Rate(Amount)";
                        ImpSurrLine."No Of Days" := PayLine."No of Days";
                        //ERROR(ImpSurrLine."Staff No.");
                        LineNo += 1;
                        ImpSurrLine."Line No." := LineNo;
                        ImpSurrLine.Insert;
                    until PayLine.Next = 0;
                end;

            end;
        }
        field(47; "Vote Book"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(48; "Total Allocation"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Total Expenditure"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Total Commitments"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51; Balance; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Balance Less this Entry"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(54; "Petty Cash"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;

                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(59; "Function Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Budget Center Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(61; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
        }
        field(62; "Issue Voucher Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Cash Voucher","Payment Voucher";
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';

            trigger OnLookup()
            begin
                LookupShortcutDimCode(3, "Shortcut Dimension 3 Code");
                Validate("Shortcut Dimension 3 Code");
            end;

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 3);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name
            end;
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';

            trigger OnLookup()
            begin
                LookupShortcutDimCode(4, "Shortcut Dimension 4 Code");
                Validate("Shortcut Dimension 4 Code");
            end;

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 4);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(83; Dim3; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(84; Dim4; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(85; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(86; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = Currency;
        }
        field(87; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin

                TestField(Status, Status::Pending);
                if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
                    Error(
                      Text001,
                      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
            end;
        }
        field(88; "Amount Surrendered LCY"; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Details".Amount WHERE("Surrender Doc No." = FIELD(No)));
            FieldClass = FlowField;
        }
        field(89; "Actual Spent"; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Details"."Actual Spent" WHERE("Surrender Doc No." = FIELD(No)));
            FieldClass = FlowField;
        }
        field(90; "Allow Over-Expenditure"; Boolean)
        {
            Caption = 'Allow Over-Expenditure';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(91; "Open for Over-Expenditure by"; Code[20])
        {
            Caption = 'Open for Over-Expenditure by';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(92; "Date opened for Ov-Expenditure"; Date)
        {
            Caption = 'Date opened for Ov-Expenditure';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(94; "Cash Receipt Amount"; Decimal)
        {
            CalcFormula = Sum("Imprest Surrender Details"."Cash Receipt Amount" WHERE("Surrender Doc No." = FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(95; "Additional Lines"; Integer)
        {
            CalcFormula = Count("Imprest Surrender Details" WHERE("Line on Original Document" = CONST(false),
                                                                   "Surrender Doc No." = FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(96; "Budget Ref"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";

            trigger OnValidate()
            begin

                GLBudgetName.Get("Budget Ref");

                if "Budget Ref" <> xRec."Budget Ref" then
                    Message('You have changed the budget refference code. Please ensure the document date ' +
                    'falls between' + ' ' + Format(GLBudgetName."Start Date") + '' + ' & ' + '' + Format(GLBudgetName."End Date"));


                "Budget Ref Selected Manually" := true;
                Modify;
            end;
        }
        field(97; "Budget Ref Selected Manually"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(99; "Amount on Original Document"; Decimal)
        {
            CalcFormula = Sum("Imprest Lines".Amount WHERE(No = FIELD("Imprest Issue Doc. No")));
            FieldClass = FlowField;
        }
        field(200; "Internal Memo No"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Internal Memo"."No.";

            trigger OnValidate()
            begin
                //IF InternalMemo.GET("Internal Memo No") THEN
                //VALIDATE("Dimension Set ID",InternalMemo."Dimension Set ID");

                //       InternalMemo.RESET;
                //       InternalMemo.SETRANGE(InternalMemo."No.","Internal Memo No");
                //       IF InternalMemo.FIND('-') THEN
                //       BEGIN
                //          "Global Dimension 1 Code":=InternalMemo."Shortcut Dimension 1 Code";
                //          "Shortcut Dimension 2 Code":=InternalMemo."Shortcut Dimension 2 Code";
                //          "Shortcut Dimension 3 Code":=InternalMemo."Shortcut Dimension 3 Code";
                //          "Shortcut Dimension 4 Code":=InternalMemo."Shortcut Dimension 4 Code";
                //          "Shortcut Dimension 5 code":=InternalMemo."Shortcut Dimension 5 Code";
                //
                //       END;

                /**
                if InternalMemo.Get("Internal Memo No") then
                    "Global Dimension 1 Code" := InternalMemo."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := InternalMemo."Shortcut Dimension 2 Code";
                "Shortcut Dimension 3 Code" := InternalMemo."Shortcut Dimension 3 Code";
                "Shortcut Dimension 4 Code" := InternalMemo."Shortcut Dimension 4 Code";
                "Shortcut Dimension 5 code" := InternalMemo."Shortcut Dimension 5 Code";
                **/

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name;

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;


                //  VALIDATE("Dimension Set ID",InternalMemo."Dimension Set ID");
                /**

                "Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(1, "Global Dimension 1 Code", "Dimension Set ID");
                "Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2, "Shortcut Dimension 2 Code", "Dimension Set ID");
                "Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(3, "Shortcut Dimension 3 Code", "Dimension Set ID");
                "Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(4, "Shortcut Dimension 4 Code", "Dimension Set ID");
                "Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(5, "Shortcut Dimension 5 code", "Dimension Set ID");
                **/
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions
            end;
        }
        field(481; "Addtional line purpose"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(482; "Date of Departure"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(483; "Date of Return"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Surrender Manual No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Shortcut Dimension 5 code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,LevyInvoice,memo';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",LevyInvoice,memo;
        }
        field(50029; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            DataClassification = ToBeClassified;
            TableRelation = "Incoming Document";

            trigger OnValidate()
            var
                IncomingDocument: Record "Incoming Document";
            begin
                if "Incoming Document Entry No." = xRec."Incoming Document Entry No." then
                    exit;
                if "Incoming Document Entry No." = 0 then
                    IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                /**
                else
                    IncomingDocument.SetstaffsurrDoc(Rec);
                    **/
            end;
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        if Status = Status::Posted then
            Error('Cannot Delete Document is already Posted');
    end;

    trigger OnInsert()
    begin
        if No = '' then begin
            GenLedgerSetup.Get;

            GenLedgerSetup.TestField(GenLedgerSetup."Imprest Surrender No");
            NoSeriesMgt.InitSeries(GenLedgerSetup."Imprest Surrender No", xRec."No. Series", 0D, No, "No. Series");
        end;

        "Account Type" := "Account Type"::Customer;
        "Surrender Date" := Today;
        Cashier := UserId;
        Validate(Cashier);
        //
        if UserSetup.Get(UserId) then begin
            UserSetup.TestField(UserSetup."Staff Travel Account");
            "Account Type" := "Account Type"::Customer;
            "Account No." := UserSetup."Staff Travel Account";
            Validate("Account No.");


        end
        //ELSE
        //ERROR('User must be setup under User Setup and their respective Account Entered');
    end;

    trigger OnModify()
    begin

        //if Status = Status::Posted then
        //ERROR('Cannot Modify Document is already Posted');
    end;

    var
        ImprestSurrHeader: Record "Imprest Surrender Header";
        ImprestSurrLines: Record "Imprest Surrender Details";
        ImpSurrLine: Record "Imprest Surrender Details";
        PayHeader: Record "Imprest Header";
        PayLine: Record "Imprest Lines";
        "Withholding Tax Code": Code[200];
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        CashierLinks: Record "Cash Office User Template";
        GLAccount: Record "G/L Account";
        EntryNo: Integer;
        SingleMonth: Boolean;
        DateFrom: Date;
        DateTo: Date;
        Budget: Decimal;
        CurrMonth: Code[10];
        CurrYR: Code[10];
        BudgDate: Text[30];
        BudgetDate: Date;
        YrBudget: Decimal;
        BudgetDateTo: Date;
        BudgetAvailable: Decimal;
        GenLedSetup: Record "Cash Office Setup";
        "Total Budget": Decimal;
        CommittedAmount: Decimal;
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        LastDay: Date;
        ImprestReqDet: Record "Imprest Lines";
        LoadImprestDetails: Record "Imprest Lines";
        TotAmt: Decimal;
        DimVal: Record "Dimension Value";
        "VAT Code": Code[20];
        RespCenter: Record "Responsibility Center";
        UserMgt: Codeunit "User Setup Management";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        LineNo: Integer;
        DimMgt: Codeunit DimensionManagement;
        UserSetup: Record "User Setup";
        PaymentRequest: Record "Imprest Surrender Header";
        GLBudgetName: Record "G/L Budget Name";
        //InternalMemo: Record "Internal Memo";
        Text0001: Label 'The imprest document has been utilized in document no %1';

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Imprest', No));
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
}

