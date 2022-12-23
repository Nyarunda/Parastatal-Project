table 51533910 "Purch. Inspection Header"
{
    DataCaptionFields = "No.", "Buy-from Vendor Name";
    DrillDownPageID = "Purchase Inspection list";
    LookupPageID = "Purchase Inspection list";

    fields
    {
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                Vendor.Reset;
                Vendor.SetRange(Vendor."No.", "Buy-from Vendor No.");
                if Vendor.Find('-') then begin
                    "Buy-from Vendor Name" := Vendor.Name;
                end
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(5; "Pay-to Name"; Text[50])
        {
            Caption = 'Pay-to Name';
        }
        field(6; "Pay-to Name 2"; Text[50])
        {
            Caption = 'Pay-to Name 2';
        }
        field(7; "Pay-to Address"; Text[50])
        {
            Caption = 'Pay-to Address';
        }
        field(8; "Pay-to Address 2"; Text[50])
        {
            Caption = 'Pay-to Address 2';
        }
        field(9; "Pay-to City"; Text[30])
        {
            Caption = 'Pay-to City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10; "Pay-to Contact"; Text[50])
        {
            Caption = 'Pay-to Contact';
        }
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
        }
        field(12; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(13; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name';
        }
        field(14; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(15; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(16; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(17; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(18; "Ship-to Contact"; Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(22; "Posting Description"; Text[250])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(31; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            Editable = false;
            TableRelation = "Vendor Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43; "Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(44; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Purchase Header"."No." WHERE(Status = FILTER(Released),
                                                           "Document Type" = CONST(Order));

            trigger OnValidate()
            begin
                PurchInspectionLine.Reset;
                PurchInspectionLine.SetRange("Document No.", "No.");
                PurchInspectionLine.DeleteAll;

                "Buy-from Vendor No." := '';
                "Buy-from Vendor Name" := '';
                "Posting Description" := '';
                "Posting Date" := 0D;

                PurchaseHeader.Reset;
                PurchaseHeader.SetRange(PurchaseHeader."No.", "Order No.");
                if PurchaseHeader.Find('-') then begin
                    "Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                    "Buy-from Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                    "Posting Description" := PurchaseHeader."Posting Description";
                    "Posting Date" := PurchaseHeader."Posting Date";

                    PurchaseLine.Reset;
                    PurchaseLine.SetRange(PurchaseLine."Document No.", PurchaseHeader."No.");
                    if PurchaseLine.Find('-') then
                        repeat
                            PurchInspectionLine.Init;
                            PurchInspectionLine."Document No." := "No.";
                            PurchInspectionLine.Type := PurchaseLine.Type;
                            PurchInspectionLine."No." := PurchaseLine."No.";
                            PurchInspectionLine.Description := PurchaseLine.Description;
                            PurchInspectionLine."Line No." := PurchaseLine."Line No.";
                            PurchInspectionLine."Unit Cost" := PurchaseLine."Unit Cost";
                            PurchInspectionLine."Direct Unit Cost" := PurchaseLine."Direct Unit Cost";
                            PurchInspectionLine."Unit of Measure" := PurchaseLine."Unit of Measure";
                            PurchInspectionLine."Unit of Measure Code" := PurchaseLine."Unit of Measure Code";
                            PurchInspectionLine."Order No." := PurchaseHeader."No.";
                            PurchInspectionLine.Validate(Quantity, PurchaseLine.Quantity);
                            PurchInspectionLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                            PurchInspectionLine.Insert;
                        until PurchaseLine.Next = 0;
                end
            end;
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist("Purch. Comment Line" WHERE("Document Type" = CONST(Receipt),
                                                             "No." = FIELD("No."),
                                                             "Document Line No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(51; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(52; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            begin
                VendLedgEntry.SetCurrentKey("Document No.");
                VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                PAGE.Run(0, VendLedgEntry);
            end;
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(66; "Vendor Order No."; Code[35])
        {
            Caption = 'Vendor Order No.';
        }
        field(67; "Vendor Shipment No."; Code[35])
        {
            Caption = 'Vendor Shipment No.';
        }
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(72; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(73; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(74; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(79; "Buy-from Vendor Name"; Text[50])
        {
            Caption = 'Buy-from Vendor Name';
        }
        field(80; "Buy-from Vendor Name 2"; Text[50])
        {
            Caption = 'Buy-from Vendor Name 2';
        }
        field(81; "Buy-from Address"; Text[50])
        {
            Caption = 'Buy-from Address';
        }
        field(82; "Buy-from Address 2"; Text[50])
        {
            Caption = 'Buy-from Address 2';
        }
        field(83; "Buy-from City"; Text[30])
        {
            Caption = 'Buy-from City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(84; "Buy-from Contact"; Text[50])
        {
            Caption = 'Buy-from Contact';
        }
        field(85; "Pay-to Post Code"; Code[20])
        {
            Caption = 'Pay-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(86; "Pay-to County"; Text[30])
        {
            Caption = 'Pay-to County';
        }
        field(87; "Pay-to Country/Region Code"; Code[10])
        {
            Caption = 'Pay-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(88; "Buy-from Post Code"; Code[20])
        {
            Caption = 'Buy-from Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89; "Buy-from County"; Text[30])
        {
            Caption = 'Buy-from County';
        }
        field(90; "Buy-from Country/Region Code"; Code[10])
        {
            Caption = 'Buy-from Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(92; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(94; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(95; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
        }
        field(97; "Entry Point"; Code[10])
        {
            Caption = 'Entry Point';
            TableRelation = "Entry/Exit Point";
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(109; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(110; "Order No. Series"; Code[10])
        {
            Caption = 'Order No. Series';
            TableRelation = "No. Series";
        }
        field(112; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(113; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(114; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(116; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(151; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
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
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5052; "Buy-from Contact No."; Code[20])
        {
            Caption = 'Buy-from Contact No.';
            TableRelation = Contact;
        }
        field(5053; "Pay-to Contact no."; Code[20])
        {
            Caption = 'Pay-to Contact no.';
            TableRelation = Contact;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5790; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
            Editable = false;
        }
        field(5791; "Promised Receipt Date"; Date)
        {
            Caption = 'Promised Receipt Date';
            Editable = false;
        }
        field(5792; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
            Editable = false;
        }
        field(5793; "Inbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Inbound Whse. Handling Time';
            Editable = false;
        }
        field(39003900; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Approved';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Approved;
        }
        field(39003901; "Internal Memo"; Code[20])
        {
            //TableRelation = "Internal Memo"."No." WHERE(Status = CONST(Approved));
        }
        field(39003902; "Inspection Committtee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Inspection Committee Activity".Code;
        }
    }

    keys
    {
        key(Key1; "No.", "Inspection Committtee No.")
        {
        }
        key(Key2; "Order No.")
        {
        }
        key(Key3; "Pay-to Vendor No.")
        {
        }
        key(Key4; "Buy-from Vendor No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "Posting Date", "Posting Description")
        {
        }
    }

    trigger OnDelete()
    begin
        /*
        LOCKTABLE;
        PostPurchLinesDelete.DeletePurchInspectionLines(Rec);
        
        PurchCommentLine.SETRANGE("Document Type",PurchCommentLine."Document Type"::Receipt);
        PurchCommentLine.SETRANGE("No.","No.");
        PurchCommentLine.DELETEALL;
        ApprovalsMgt.DeletePostedApprovalEntry(DATABASE::"Purch. Rcpt. Header","No.");
            */

    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            Payables.Get;
            Payables.TestField(Payables."Inspection Nos");
            NoSeriesMgt.InitSeries(Payables."Inspection Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        PurchRcptHeader: Record "Purch. Inspection Header";
        PurchCommentLine: Record "Purch. Comment Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PostPurchLinesDelete: Codeunit "PostPurch-Delete";
        DimMgt: Codeunit DimensionManagement;
        UserSetupMgt: Codeunit "User Setup Management";
        Payables: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchInspectionLine: Record "Purch. Inspection Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Vendor: Record Vendor;

    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        ReportSelection: Record "Report Selections";
    begin
        with PurchRcptHeader do begin
            Copy(Rec);
            ReportSelection.SetRange(Usage, ReportSelection.Usage::"P.Receipt");
            ReportSelection.SetFilter("Report ID", '<>0');
            ReportSelection.Find('-');
            repeat
                REPORT.RunModal(ReportSelection."Report ID", ShowRequestForm, false, PurchRcptHeader);
            until ReportSelection.Next = 0;
        end;
    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run;
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
    end;

    procedure SetSecurityFilterOnRespCenter()
    begin
        if UserSetupMgt.GetPurchasesFilter <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center", UserSetupMgt.GetPurchasesFilter);
            FilterGroup(0);
        end;
    end;
}

