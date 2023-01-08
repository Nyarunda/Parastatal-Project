table 51533323 "Staff Advanc Surrender Details"
{

    fields
    {
        field(1;"Surrender Doc No.";Code[20])
        {
            Editable = false;
            NotBlank = true;

            trigger OnValidate()
            begin
                // IF Pay.GET(No) THEN
                // "Imprest Holder":=Pay."Account No.";
            end;
        }
        field(2;"Account No:";Code[10])
        {
            NotBlank = true;
            TableRelation = IF ("Account Type"=FILTER("G/L Account")) "G/L Account"."No." WHERE ("Direct Posting"=CONST(true))
                            ELSE IF ("Account Type"=FILTER(Vendor)) Vendor."No.";

            trigger OnValidate()
            begin

                //IF GUIALLOWED THEN BEGIN
                if GLAcc.Get("Account No:") then
                 "Account Name":=CopyStr(GLAcc.Name,1,30);
                 GLAcc.TestField("Direct Posting",true);
                 "Budgetary Control A/C":=GLAcc."Budget Controlled";
                 Pay.SetRange(Pay.No,"Surrender Doc No.");
                if Pay.FindFirst then begin
                 if Pay."Account No."<>'' then begin
                "Advance Holder":=Pay."Account No.";
                "Shortcut Dimension 1 Code":=Pay."Global Dimension 1 Code";
                "Shortcut Dimension 2 Code":=Pay."Global Dimension 2 Code";
                "Shortcut Dimension 3 Code":=Pay."Shortcut Dimension 3 Code";
                "Currency Factor":=Pay."Currency Factor";
                "Currency Code":=Pay."Currency Code";

                end else
                  Error('Please Enter the Customer/Account Number');
                end;
                //END;
            end;
        }
        field(3;"Account Name";Text[50])
        {
        }
        field(4;Amount;Decimal)
        {

            trigger OnValidate()
            begin
                Difference:=Amount-"Actual Spent";
            end;
        }
        field(5;"Due Date";Date)
        {
            Editable = false;
        }
        field(6;"Advance Holder";Code[20])
        {
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(7;"Actual Spent";Decimal)
        {

            trigger OnValidate()
            begin
                   /*//Allow actual spent to be more than amount if open for overexpenditure and from original document
                   IF NOT ("Allow Overexpenditure") AND ("Line on Original Document") THEN BEGIN
                     IF "Actual Spent">Amount THEN
                       ERROR('The Actual Spent Cannot be more than the Issued Amount');
                   END;*/
                   if "Actual Spent">Amount then
                       Error('The Actual Spent Cannot be more than the Issued Amount');
                     if "Currency Factor"<>0 then
                        "Amount LCY":="Actual Spent"/"Currency Factor"
                       else
                          "Amount LCY":="Actual Spent";
                
                  if "Line No."=0 then
                  "Line No." := GetLastLineNo+1;
                
                
                     if "Currency Factor"<>0 then
                        "Amount LCY":="Actual Spent"/"Currency Factor"
                       else
                          "Amount LCY":="Actual Spent";
                
                Difference:=Amount-"Actual Spent";

            end;
        }
        field(8;"Apply to";Code[20])
        {
            Editable = true;
        }
        field(9;"Apply to ID";Code[20])
        {
            Editable = false;
        }
        field(10;"Surrender Date";Date)
        {
            Editable = false;
        }
        field(11;Surrendered;Boolean)
        {
            Editable = false;
        }
        field(12;"Cash Receipt No";Code[20])
        {
            TableRelation = "Receipt Line".No WHERE ("Account No."=FIELD("Advance Holder"));

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
                   MESSAGE();
                END;*/
                //"Cust. Ledger Entry"."Document No." WHERE (Source Code=CONST(CASHRECJNL),Open=CONST(Yes),Customer No.=FIELD(Account No:))
                
                if ReceiptHeader.Get("Cash Receipt No") then
                "Cash Receipt Amount":=ReceiptHeader."Amount Recieved";

            end;
        }
        field(13;"Date Issued";Date)
        {
            Editable = false;
        }
        field(14;"Type of Surrender";Option)
        {
            OptionMembers = " ",Cash,Receipt;
        }
        field(15;"Dept. Vch. No.";Code[20])
        {
        }
        field(16;"Cash Surrender Amt";Decimal)
        {
        }
        field(17;"Bank/Petty Cash";Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(18;" Doc No.";Code[20])
        {
            Editable = false;
        }
        field(19;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1),
                                                          "Dimension Value Type"=CONST(Standard));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(1,"Shortcut Dimension 1 Code","Dimension Set ID");
            end;
        }
        field(20;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2),
                                                          "Dimension Value Type"=CONST(Standard));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2,"Shortcut Dimension 2 Code","Dimension Set ID");
            end;
        }
        field(27;"VAT Prod. Posting Group";Code[20])
        {
            Editable = false;
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(28;"Imprest Type";Code[20])
        {
            Caption = 'Advance Type';
            TableRelation = "Receipts and Payment Types".Code WHERE (Type=CONST(Advance));

            trigger OnValidate()
            begin
                ImprestHeader.Reset;
                ImprestHeader.SetRange(ImprestHeader.No,"Surrender Doc No.");
                if ImprestHeader.FindFirst then
                  begin
                        if //(ImprestHeader.Status=ImprestHeader.Status::Approved) OR
                        (ImprestHeader.Status=ImprestHeader.Status::Posted)or
                        (ImprestHeader.Status=ImprestHeader.Status::"Pending Approval") then
                       Error('You Cannot Insert a new record when the status of the document is not Pending');
                  end;

                     RecPay.Reset;
                    RecPay.SetRange(RecPay.Code,"Imprest Type");
                    RecPay.SetRange(RecPay.Type,RecPay.Type::Advance);
                    if RecPay.Find('-') then begin
                      "Account No:":=RecPay."G/L Account";
                      "Account Name":=RecPay."Transation Remarks";
                      "Account Type":=RecPay."Account Type";
                       Validate("Account No:");
                    end;
            end;
        }
        field(85;"Currency Factor";Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0:15;
            Editable = false;
            MinValue = 0;
        }
        field(86;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(87;"Amount LCY";Decimal)
        {
        }
        field(88;"Cash Surrender Amt LCY";Decimal)
        {
        }
        field(89;"Imprest Req Amt LCY";Decimal)
        {
        }
        field(90;"Cash Receipt Amount";Decimal)
        {
        }
        field(91;"Line No.";Integer)
        {
        }
        field(92;Committed;Boolean)
        {
        }
        field(93;"Budgetary Control A/C";Boolean)
        {
        }
        field(94;"Line on Original Document";Boolean)
        {
        }
        field(95;"Allow Overexpenditure";Boolean)
        {
        }
        field(96;"Open for Overexpenditure by";Code[20])
        {
        }
        field(97;"Date opened for OvExpenditure";Date)
        {
        }
        field(98;Difference;Decimal)
        {
        }
        field(102;"Job No.";Code[10])
        {
            TableRelation = Job."No.";

            trigger OnValidate()
            begin
                CheckWipAccount
            end;
        }
        field(103;"Job Task No.";Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE ("Job No."=FIELD("Job No."));

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
        field(200;"Internal Memo No";Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Internal Memo"."No." WHERE ("Dimension Set ID"=FIELD("Dimension Set ID"));
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions
            end;
        }
        field(50000;"Account Type";Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Staff,None';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Staff,"None";
        }
        field(50001;"Shortcut Dimension 3 Code";Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3),
                                                          "Dimension Value Type"=CONST(Standard));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2,"Shortcut Dimension 2 Code","Dimension Set ID");
            end;
        }
    }

    keys
    {
        key(Key1;"Surrender Doc No.","Line No.")
        {
            SumIndexFields = "Amount LCY","Imprest Req Amt LCY","Actual Spent","Cash Receipt Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
         //Don't Allow deleting of lines on original document
          if ("Line on Original Document") and (Amount <> 0) then
            Error('You are not allowed to delete lines that were on the original issuing document');

          Pay.Reset;
          Pay.SetRange(Pay.No,"Surrender Doc No.");
          if Pay.Find('-') then
             if (Pay.Status=Pay.Status::Posted) or (Pay.Status=Pay.Status::"Pending Approval") then
        //     OR (Pay.Status=Pay.Status::Approved)THEN
                Error('This Document is already Send for Approval or Posted');

                TestField(Committed ,false);
    end;

    trigger OnInsert()
    begin
          //Do not allow insertion of lines until the document is open for over expenditure
          Pay.Reset;
          Pay.SetRange(Pay.No,"Surrender Doc No.");
          if Pay.Find('-') then  begin
              if not Pay."Allow Overexpenditure" then
                 Error('You must first open the document to allow over expenditure and addition of lines');
          end;
    end;

    trigger OnModify()
    begin
          Pay.Reset;
          Pay.SetRange(Pay.No,"Surrender Doc No.");
          if Pay.Find('-') then
             if (Pay.Status=Pay.Status::Posted) then //OR (Pay.Status=Pay.Status::"Pending Approval") THEN
             //OR (Pay.Status=Pay.Status::Approved)THEN
                Error('This Document is already Send for Approval or Posted');
                Pay.TestField("Commitment Status",false);
    end;

    var
        GLAcc: Record "G/L Account";
        Pay: Record "Staff Advance Surrender Header";
        Dim: Record Dimension;
        CustLedger: Record "Cust. Ledger Entry";
        Text000: Label 'Receipt No %1 Is already Used in Another Document';
        ImprestHeader: Record "Staff Advance Surrender Header";
        RecPay: Record "Receipts and Payment Types";
        DimMgt: Codeunit DimensionManagement;
        ReceiptHeader: Record "Receipts Header";

    procedure GetLastLineNo(): Integer
    var
        StaffAdvanceSurrLines: Record "Staff Advanc Surrender Details";
    begin
        StaffAdvanceSurrLines.Reset;
        StaffAdvanceSurrLines.SetRange(StaffAdvanceSurrLines."Surrender Doc No.","Surrender Doc No.");
        StaffAdvanceSurrLines.FindLast;
        exit(StaffAdvanceSurrLines."Line No.");
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID",StrSubstNo('%1 %2','Advance Surrender',"Line No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array [8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;

    procedure CheckWipAccount()
    var
        FAWIPJob: Record Job;
        FAWIPJobPostingGrp: Record "Job Posting Group";
    begin
        FAWIPJob.Get("Job No.");
        FAWIPJobPostingGrp.Get(FAWIPJob."Job Posting Group");
        TestField("Account Type","Account Type"::"G/L Account");
        if "Account No:"<>FAWIPJobPostingGrp."WIP Costs Account" then
        Error('Insert the right WIP Account %1',FAWIPJobPostingGrp."WIP Costs Account");
    end;
}

