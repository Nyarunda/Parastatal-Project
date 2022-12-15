table 51533344 "Purchase Quote Header"
{
    DataCaptionFields = "No.";
    DrillDownPageID = "RFQ List all";
    LookupPageID = "RFQ List all";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quotation Request,Open Tender,Restricted Tender,Low Value Procurement,Direct Procurement,Request For Quoatation,Design Competition,Force Auction,Electronic Reverse Auction,Two Stage Tendering,Frame Work Agreement,Competitive Negotiations,Request For Proposal,requisition';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request For Quoatation","Design Competition","Force Auction","Electronic Reverse Auction","Two Stage Tendering","Frame Work Agreement","Competitive Negotiations","Request For Proposal",requisition;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(11; "Your Reference"; Text[30])
        {
            Caption = 'Your Reference';
        }
        field(12; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = Location.Code WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            begin
                if "Ship-to Code" <> '' then begin
                    location.Get("Ship-to Code");
                    "Location Code" := "Ship-to Code";
                    "Ship-to Name" := location.Name;
                    "Ship-to Name 2" := location."Name 2";
                    "Ship-to Address" := location.Address;
                    "Ship-to Address 2" := location."Address 2";
                    "Ship-to City" := location.City;
                    "Ship-to Contact" := location.Contact;
                end
            end;
        }
        field(13; "Ship-to Name"; Text[70])
        {
            Caption = 'Ship-to Name';
        }
        field(14; "Ship-to Name 2"; Text[70])
        {
            Caption = 'Ship-to Name 2';
        }
        field(15; "Ship-to Address"; Text[70])
        {
            Caption = 'Ship-to Address';
        }
        field(16; "Ship-to Address 2"; Text[70])
        {
            Caption = 'Ship-to Address 2';
        }
        field(17; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
        }
        field(18; "Ship-to Contact"; Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(19; "Expected Opening Date"; DateTime)
        {
            Caption = 'Expected Opening Date';

            trigger OnValidate()
            begin
                "Portal Expected Opening Date" := "Expected Opening Date" + (3 * 60 * 60 * 1000);
            end;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Expected Closing Date"; DateTime)
        {
            Caption = 'Expected Closing Date';

            trigger OnValidate()
            begin
                "Portal Expected Closing Date" := "Expected Closing Date" + (3 * 60 * 60 * 1000);
                /**
                TenderCommitteeActivities.Reset;
                TenderCommitteeActivities.SetRange(TenderCommitteeActivities.Code, "Opening Committee No.");
                if TenderCommitteeActivities.Find('-') then begin
                    TenderCommitteeActivities.Date := "Expected Closing Date";
                    "Portal Expected Opening Date" := "Portal Expected Opening Date";
                    TenderCommitteeActivities.Modify;
                end;
                **/
            end;
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
        field(29; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
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
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                PurchLine: Record "Purchase Line";
                Currency: Record Currency;
                RecalculatePrice: Boolean;
            begin
            end;
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

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
            end;
        }
        field(45; "Order Class"; Code[10])
        {
            Caption = 'Order Class';
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist("Purch. Comment Line" WHERE("Document Type" = FIELD("Document Type"),
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
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(57; Receive; Boolean)
        {
            Caption = 'Receive';
        }
        field(58; Invoice; Boolean)
        {
            Caption = 'Invoice';
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                            "Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"),
                                                                            "Document No." = FIELD("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Receiving No."; Code[20])
        {
            Caption = 'Receiving No.';
        }
        field(63; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(64; "Last Receiving No."; Code[20])
        {
            Caption = 'Last Receiving No.';
            Editable = false;
            TableRelation = "Purch. Rcpt. Header";
        }
        field(65; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Purch. Inv. Header";
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

            trigger OnValidate()
            var
                PayToVend: Record Vendor;
            begin
            end;
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
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(109; "Receiving No. Series"; Code[10])
        {
            Caption = 'Receiving No. Series';
            TableRelation = "No. Series";
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
        field(118; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            var
                TempVendLedgEntry: Record "Vendor Ledger Entry";
            begin
            end;
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                ChangeLogMgt: Codeunit "Change Log Management";
                RecRef: RecordRef;
                xRecRef: RecordRef;
            begin
            end;
        }
        field(120; Status; Option)
        {
            Caption = 'Status';
            Editable = true;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Closed,Cancelled,Stopped';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Closed,Cancelled,Stopped;
        }
        field(121; "Invoice Discount Calculation"; Option)
        {
            Caption = 'Invoice Discount Calculation';
            Editable = true;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122; "Invoice Discount Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            Editable = false;
        }
        field(123; "Send IC Document"; Boolean)
        {
            Caption = 'Send IC Document';
        }
        field(124; "IC Status"; Option)
        {
            Caption = 'IC Status';
            OptionCaption = 'New,Pending,Sent';
            OptionMembers = New,Pending,Sent;
        }
        field(125; "Buy-from IC Partner Code"; Code[20])
        {
            Caption = 'Buy-from IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(126; "Pay-to IC Partner Code"; Code[20])
        {
            Caption = 'Pay-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(129; "IC Direction"; Option)
        {
            Caption = 'IC Direction';
            OptionCaption = 'Outgoing,Incoming';
            OptionMembers = Outgoing,Incoming;
        }
        field(151; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(5043; "No. of Archived Versions"; Integer)
        {
            CalcFormula = Max("Purchase Header Archive"."Version No." WHERE("Document Type" = FIELD("Document Type"),
                                                                             "No." = FIELD("No."),
                                                                             "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence")));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
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

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
            end;
        }
        field(5053; "Pay-to Contact No."; Code[20])
        {
            Caption = 'Pay-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5752; "Completely Received"; Boolean)
        {
            CalcFormula = Min("Purchase Line"."Completely Received" WHERE("Document Type" = FIELD("Document Type"),
                                                                           "Document No." = FIELD("No."),
                                                                           Type = FILTER(<> " "),
                                                                           "Location Code" = FIELD("Location Filter")));
            Caption = 'Completely Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5753; "Posting from Whse. Ref."; Integer)
        {
            Caption = 'Posting from Whse. Ref.';
        }
        field(5754; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5790; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
        }
        field(5791; "Promised Receipt Date"; Date)
        {
            Caption = 'Promised Receipt Date';
        }
        field(5792; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(5793; "Inbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Inbound Whse. Handling Time';
        }
        field(5796; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5801; "Return Shipment No."; Code[20])
        {
            Caption = 'Return Shipment No.';
        }
        field(5802; "Return Shipment No. Series"; Code[10])
        {
            Caption = 'Return Shipment No. Series';
            TableRelation = "No. Series";
        }
        field(5803; Ship; Boolean)
        {
            Caption = 'Ship';
        }
        field(5804; "Last Return Shipment No."; Code[20])
        {
            Caption = 'Last Return Shipment No.';
            Editable = false;
            TableRelation = "Return Shipment Header";
        }
        field(9000; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            //TableRelation = "User Setup"."User ID" WHERE("Procurement Officer" = CONST(true));
        }
        field(50000; "Vendor Category Code"; Code[20])
        {
            //TableRelation = "Vendor Categories".Code;

            trigger OnValidate()
            begin
                /**
                VendorCatego.Reset;
                VendorCatego.SetRange(VendorCatego.Code, "Vendor Category Code");
                if VendorCatego.Find('-') then
                    "Vendor Category Description" := VendorCatego.Description;
                **/
            end;
        }
        field(50001; "Vendor Category Description"; Text[70])
        {
        }
        field(50002; "Vendor No."; Code[20])
        {
            //TableRelation = "Quotation Request Vendors"."Vendor No." WHERE("Requisition Document No." = FIELD("No."));
        }
        field(50003; "Vendor Class"; Code[20])
        {
            //TableRelation = "vendor class".Code;
        }
        field(50004; "Evaluation Comm Remarks"; Text[250])
        {
            Caption = 'Evaluation Commitee Remarks';
        }
        field(50005; "ED Remarks"; Text[250])
        {
        }
        field(50006; "SCM Remarks"; Text[250])
        {
        }
        field(50007; "Tender No"; Text[20])
        {
        }
        field(50008; "Proffessional Oinion Remarks"; Text[250])
        {
        }
        field(50009; Assigned; Boolean)
        {
        }
        field(50010; Type; Option)
        {
            OptionMembers = Normal,RFP;
        }
        field(50011; "Incoming Document Entry No."; Integer)
        {

            trigger OnValidate()
            begin
                if "Incoming Document Entry No." = xRec."Incoming Document Entry No." then
                    exit;
                if "Incoming Document Entry No." = 0 then
                    IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                //else
                //    IncomingDocument.SetRFQDoc(Rec);
            end;
        }
        field(50012; "Doc Type"; Option)
        {
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Restricted Quote";
        }
        field(50013; "Scheme Applied"; Option)
        {
            OptionCaption = ' ,Youth,Women,PWD,General';
            OptionMembers = " ",Youth,Women,PWD,General;
        }
        field(50014; "Reason for extending"; Text[250])
        {
        }
        field(50015; "Financial Exp Opening Date"; DateTime)
        {
        }
        field(39004240; Copied; Boolean)
        {
        }
        field(39004241; "Debit Note"; Boolean)
        {
        }
        field(39004243; "PRF No"; Code[10])
        {
            //TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Requisition));
            //"Purchase Header".Status = FILTER(Released),
            //"Requisition Status" = CONST(Open));

            trigger OnLookup()
            begin
                PurchHeader.Reset;
                //PurchHeader.SetRange(PurchHeader."Document Type", PurchHeader."Document Type"::Requisition);
                //PurchHeader.SETRANGE(PurchHeader.DocApprovalType,PurchHeader.DocApprovalType::Requisition);
                PurchHeader.SetRange(PurchHeader.Status, PurchHeader.Status::Released);
                if PAGE.RunModal(53, PurchHeader) = ACTION::LookupOK then begin
                    "PRF No" := PurchHeader."No.";
                    AutoPopPurchLine;
                    PurchHeader.Reset;
                    PurchHeader.SetRange(PurchHeader."No.", "PRF No");
                    //if PurchHeader.FindFirst then
                    //    "Internal Requisition No." := PurchHeader."Internal Memo No.";
                end
            end;

            trigger OnValidate()
            begin
                PurchHeader.Reset;
                PurchHeader.SetRange(PurchHeader."No.", "PRF No");
                //PurchHeader.SetRange(PurchHeader."Requisition Status", PurchHeader."Requisition Status"::Closed);
                if PurchHeader.Find('-') then begin
                    Error('This Requisition number is fully utilized');
                end else begin
                    AutoPopPurchLine;
                    PurchHeader.Reset;
                    PurchHeader.SetRange("No.", "PRF No");
                    //if PurchHeader.FindFirst then
                    //"Internal Requisition No." := PurchHeader."Internal Memo No.";
                end;
            end;
        }
        field(39004244; "Released By"; Code[50])
        {
        }
        field(39004245; "Release Date"; Date)
        {
        }
        field(39005536; Cancelled; Boolean)
        {
        }
        field(39005537; "Cancelled By"; Code[50])
        {
        }
        field(39005538; "Cancelled Date"; Date)
        {
        }
        field(39005539; DocApprovalType; Option)
        {
            OptionMembers = Purchase,Requisition,Quote,"Restricted Quote";
        }
        field(39005540; "Procurement Type Code"; Code[20])
        {
            //TableRelation = "Store Requistion Header2";
        }
        field(39005556; "Internal Requisition No."; Code[20])
        {
            Caption = 'Internal Memo No';
            //TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Requisition),
            //                                              Status = FILTER(Released),
            //                                             "Requisition Status" = CONST(Open));

            trigger OnValidate()
            begin
                // IF InternalMemo.GET("Internal Memo No.") THEN
                //  VALIDATE("Dimension Set ID",InternalMemo."Dimension Set ID");
                /**
                PurchLine.Reset;
                PurchLine.SetRange(PurchLine."Document No.", "No.");
                PurchLine.DeleteAll;


                InternalMemoLines.Reset;
                InternalMemoLines.SetRange(InternalMemoLines."Document No.", "Internal Requisition No.");
                InternalMemoLines.SetRange(InternalMemoLines."Memo Type", InternalMemoLines."Memo Type"::Procurement);
                if InternalMemoLines.Find('-') then begin
                    repeat
                        PurchLine.Init;
                        PurchLine."Document Type" := PurchLine."Document Type"::"Quotation Request";
                        PurchLine."Document Type" := PurchLine."Document Type"::"Open Tender";
                        PurchLine."Document Type" := PurchLine."Document Type"::"Restricted Tender";
                        PurchLine."Document No." := "No.";
                        PurchLine."Line No." := RFQ."Line No.";
                        PurchLine.Type := PurchLine.Type::"G/L Account";
                        PurchLine."Expense Code" := InternalMemoLines."Expense Code";
                        PurchLine."No." := InternalMemoLines."No.";
                        PurchLine.Validate("No.");
                        PurchLine.Quantity := InternalMemoLines.Quantity;
                        //PurchLine.Validate(Quantity);
                        PurchLine."Direct Unit Cost" := InternalMemoLines.Amount;
                        //PurchLine.Validate("Direct Unit Cost");
                        PurchLine.Amount := InternalMemoLines."Total Amount";
                        PurchLine."Shortcut Dimension 1 Code" := InternalMemoLines."Shortcut Dimension 1 Code";
                        PurchLine."Shortcut Dimension 2 Code" := InternalMemoLines."Shortcut Dimension 2 Code";
                        PurchLine."Shortcut Dimension 3 Code" := InternalMemoLines."Shortcut Dimension 3 Code";
                        PurchLine."Shortcut Dimension 4 Code" := InternalMemoLines."Shortcut Dimension 4 Code";
                        PurchLine."Shortcut Dimension 5 Code" := InternalMemoLines."Shortcut Dimension 5 Code";
                        //PurchLine:="Dimension Set ID";
                        PurchLine.Description := InternalMemoLines.Description;
                        PurchLine."Line No." := InternalMemoLines."Line No.";
                        PurchLine.Insert;
                    until InternalMemoLines.Next = 0;
                end;
                **/
                // //CHECK WHETHER HAS LINES AND DELETE
                //       IF NOT CONFIRM('If you change the Request for Quote No. the current lines will be deleted. Do you want to continue?',FALSE)
                //       THEN
                //           ERROR('You have selected to abort the process') ;
                //
                //       PurchLine.RESET;
                //       PurchLine.SETRANGE(PurchLine."Document No.","No.");
                //       PurchLine.DELETEALL;
                //
                //       PurchHeader.RESET;
                //       PurchHeader.SETRANGE(PurchHeader."No.","No.");
                //       IF PurchHeader.FIND('-') THEN
                //       BEGIN
                //          "Procurement Methods":=PurchHeader."Procurement Method";
                //       END;
                //
                //       RFQ.RESET;
                //       RFQ.SETRANGE(RFQ."Document No.","Internal Requisition No.");
                //       IF RFQ.FIND('-') THEN
                //       BEGIN
                //         REPEAT
                //             PurchLine.INIT;
                //             "Procurement Methods":=PurchHeader."Procurement Method";
                //             PurchLine."Document Type":="Document Type";
                //             PurchLine."Document No.":="No.";
                //             PurchLine."Line No.":=RFQ."Line No.";
                //             PurchLine.Type:=RFQ.Type;
                //             PurchLine."No.":=RFQ."No.";
                //             PurchLine."Expense Code":=RFQ."Expense Code";
                //             PurchLine.VALIDATE("No.");
                //             PurchLine."Location Code":=RFQ."Location Code";
                //             PurchLine.VALIDATE("Location Code");
                //             PurchLine.Quantity:=RFQ.Quantity;
                //             PurchLine.VALIDATE(Quantity);
                //             //PurchLine."Direct Unit Cost":=RFQ."Direct Unit Cost";
                //             //PurchLine.VALIDATE("Direct Unit Cost");
                //             PurchLine."Unit of Measure":=RFQ."Unit of Measure";
                //             PurchLine.VALIDATE(PurchLine."Unit of Measure");
                //             PurchLine."Unit of Measure Code" := RFQ."Unit of Measure Code";
                //             PurchLine."Description 2" := RFQ."Description 2";
                //             //PurchLine.Amount:=RFQ.Amount;
                //             PurchLine."Shortcut Dimension 1 Code":=RFQ."Global Dimension 1 Code";
                //            PurchLine."Shortcut Dimension 2 Code":=RFQ."Global Dimension 2 Code";
                //             PurchLine.INSERT;
                //         UNTIL RFQ.NEXT=0;
                //
                //         //Insert Header Dimension
                //         PurchHeader_2.RESET;
                //         PurchHeader_2.SETRANGE(PurchHeader_2."No.","Internal Requisition No.");
                //         IF PurchHeader_2.FIND('-') THEN
                //         BEGIN
                //             "Global Dimension 1 Code":=PurchHeader_2."Global Dimension 1 Code";
                //             "Shortcut Dimension 2 Code":=PurchHeader_2."Global Dimension 2 Code";
                //             MODIFY;
                //         END;
                //       END;
            end;
        }
        field(39005557; Published; Boolean)
        {

            trigger OnValidate()
            begin
                //only select if doc is released
                /*IF Status=Status::Released  THEN BEGIN
                  Published:=TRUE;
                  MODIFY;
                END ELSE
                ERROR(PublishErr);*/

            end;
        }
        field(39005558; "Memo No"; Code[20])
        {
        }
        field(99008500; "Date Received"; Date)
        {
            Caption = 'Date Received';
        }
        field(99008501; "Time Received"; Time)
        {
            Caption = 'Time Received';
        }
        field(99008504; "BizTalk Purchase Quote"; Boolean)
        {
            Caption = 'BizTalk Purchase Quote';
        }
        field(99008505; "BizTalk Purch. Order Cnfmn."; Boolean)
        {
            Caption = 'BizTalk Purch. Order Cnfmn.';
        }
        field(99008506; "BizTalk Purchase Invoice"; Boolean)
        {
            Caption = 'BizTalk Purchase Invoice';
        }
        field(99008507; "BizTalk Purchase Receipt"; Boolean)
        {
            Caption = 'BizTalk Purchase Receipt';
        }
        field(99008508; "BizTalk Purchase Credit Memo"; Boolean)
        {
            Caption = 'BizTalk Purchase Credit Memo';
        }
        field(99008509; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
        }
        field(99008510; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
        }
        field(99008511; "BizTalk Request for Purch. Qte"; Boolean)
        {
            Caption = 'BizTalk Request for Purch. Qte';
        }
        field(99008512; "BizTalk Purchase Order"; Boolean)
        {
            Caption = 'BizTalk Purchase Order';
        }
        field(99008520; "Vendor Quote No."; Code[20])
        {
            Caption = 'Vendor Quote No.';
        }
        field(99008521; "BizTalk Document Sent"; Boolean)
        {
            Caption = 'BizTalk Document Sent';
        }
        field(99008522; "Procurement Methods"; Code[20])
        {
            TableRelation = "Procurement Methods".Code;
        }
        field(99008523; "Quotation date"; Date)
        {
        }
        field(99008524; "Bid validity period"; Code[40])
        {
        }
        field(99008525; "Evaluation Remarks2"; Text[250])
        {
        }
        field(99008526; "Evaluation Remarks"; Text[250])
        {
        }
        field(99008527; "User IDS"; Code[30])
        {
            //CalcFormula = Lookup("Requisition Email"."USER ID" WHERE(Code = FIELD("No.")));
            //FieldClass = FlowField;
        }
        field(99008528; "Elegibility Creteria"; Text[250])
        {
        }
        field(99008529; "Financial Year"; Code[30])
        {
            TableRelation = "G/L Budget Name".Name WHERE(Blocked = CONST(false));
        }
        field(99008530; "Date Tenders Invited"; Date)
        {
        }
        field(99008531; "Vendor Category Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Vendor Categories".Code;

            trigger OnValidate()
            begin
                /**VendorCatego.Reset;
                VendorCatego.SetRange(VendorCatego.Code, "Vendor Category Code 2");
                if VendorCatego.Find('-') then
                    "Vendor Category Description 2" := VendorCatego.Description; **/
            end;
        }
        field(99008532; "Vendor Category Description 2"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(99008533; "Opening Committee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Tender Committee Activities".Code WHERE(Status = CONST(Approved));

            trigger OnValidate()
            begin
                /*TenderCommitteeActivities.RESET;
                TenderCommitteeActivities.SETRANGE(TenderCommitteeActivities.Code,"Opening Committee No.");
                TenderCommitteeActivities.SETRANGE(TenderCommitteeActivities.Status,TenderCommitteeActivities.Status::Approved);
                IF TenderCommitteeActivities.FIND('-') THEN BEGIN
                
                
                  ERROR('Please note that the committee No is already in use and approved');
                
                END;
                */
                PQH.Reset;
                //PQH.SETRANGE(PQH."Procurement Methods",'OT');
                PQH.SetRange(PQH."Opening Committee No.", "Opening Committee No.");
                PQH.SetRange(PQH.Status, PQH.Status::Released);
                if PQH.FindFirst then Error('This committee is already utilized in Procurement Method No %1', PQH."No.");

            end;
        }
        field(99008534; "Evaluation Committee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Evaluation Committee Activity".Code WHERE(Status = CONST(Approved));

            trigger OnValidate()
            begin
                PQH.Reset;
                //PQH.SETRANGE(PQH."Procurement Methods",'OT');
                PQH.SetRange(PQH."Evaluation Committee No.", "Evaluation Committee No.");
                PQH.SetRange(PQH.Status, PQH.Status::Released);
                if PQH.FindFirst then Error('This committee is already utilized in Open tender no %1', PQH."No.");
            end;
        }
        field(99008535; "Technical Pass Score"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Technical Pass Score" > 100 then
                    Error('The Technical Pass Score should not be more than 100');
            end;
        }
        field(99008536; "Portal Expected Opening Date"; DateTime)
        {
            Caption = 'Expected Opening Date';
            DataClassification = ToBeClassified;
        }
        field(99008537; "Portal Expected Closing Date"; DateTime)
        {
            Caption = 'Expected Closing Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /**
                TenderCommitteeActivities.Reset;
                //TenderCommitteeActivities.SetRange(Code, "Opening Committee No.");
                if TenderCommitteeActivities.Find('-') then begin
                    TenderCommitteeActivities.Date := "Expected Closing Date";
                    TenderCommitteeActivities.Modify; **/
            end;
        }
        field(99008538; "Tender Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Open,Reserved';
            OptionMembers = " ",Open,Reserved;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
        }
        key(Key2; "No.", "Document Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*`//Check if the number has been inserted by the user
        IF "No."='' THEN BEGIN
          IF "Document Type"="Document Type"::"Quotation Request" THEN
            PurchSetup.RESET;
            PurchSetup.GET();
            PurchSetup.TESTFIELD(PurchSetup."Quotation Request No");
            NoSeriesMgt.InitSeries(PurchSetup."Quotation Request No",xRec."No. Series",TODAY,"No.","No. Series");
          END;
             */

        if "No." = '' then begin
            PurchSetup.Get;
            if "Document Type" = "Document Type"::"Low Value Procurement" then begin
                PurchSetup.TestField(PurchSetup."Low Value Proucrement No");
                NoSeriesMgt.InitSeries(PurchSetup."Low Value Proucrement No", xRec."No. Series", 0D, "No.", "No. Series");
            end
            else
                if "Document Type" = "Document Type"::"Quotation Request" then begin
                    PurchSetup.TestField(PurchSetup."Request For Quotation");
                    NoSeriesMgt.InitSeries(PurchSetup."Request For Quotation", xRec."No. Series", 0D, "No.", "No. Series");
                end
                else
                    if "Document Type" = "Document Type"::"Open Tender" then begin
                        PurchSetup.TestField(PurchSetup."Open Tender No");
                        NoSeriesMgt.InitSeries(PurchSetup."Open Tender No", xRec."No. Series", 0D, "No.", "No. Series");
                    end
            /**
            else
                if "Document Type" = "Document Type"::"Direct Procurement" then begin
                    PurchSetup.TestField(PurchSetup."Direct Procurement No");
                    NoSeriesMgt.InitSeries(PurchSetup."Direct Procurement No", xRec."No. Series", 0D, "No.", "No. Series");
                end

                else
                    if "Document Type" = "Document Type"::"Restricted Tender" then begin
                        PurchSetup.TestField(PurchSetup."Restricted Tender No");
                        NoSeriesMgt.InitSeries(PurchSetup."Restricted Tender No", xRec."No. Series", 0D, "No.", "No. Series");
                    end

                    else
                        if "Document Type" = "Document Type"::"Competitive Negotiations" then begin
                            PurchSetup.TestField(PurchSetup."Competitive Negotiation No");
                            NoSeriesMgt.InitSeries(PurchSetup."Competitive Negotiation No", xRec."No. Series", 0D, "No.", "No. Series");
                        end

                        else
                            if "Document Type" = "Document Type"::"Frame Work Agreement" then begin
                                PurchSetup.TestField(PurchSetup."Frame Work Agreement No");
                                NoSeriesMgt.InitSeries(PurchSetup."Frame Work Agreement No", xRec."No. Series", 0D, "No.", "No. Series");
                            end

                            else
                                if "Document Type" = "Document Type"::"Two Stage Tendering" then begin
                                    PurchSetup.TestField(PurchSetup."Two Stage Tendering No");
                                    NoSeriesMgt.InitSeries(PurchSetup."Two Stage Tendering No", xRec."No. Series", 0D, "No.", "No. Series");
                                end

                                else
                                    if "Document Type" = "Document Type"::"Electronic Reverse Auction" then begin
                                        PurchSetup.TestField(PurchSetup."Electronic Reverse No");
                                        NoSeriesMgt.InitSeries(PurchSetup."Electronic Reverse No", xRec."No. Series", 0D, "No.", "No. Series");
                                    end

                                    else
                                        if "Document Type" = "Document Type"::"Force Auction" then begin
                                            PurchSetup.TestField(PurchSetup."Force Auction No");
                                            NoSeriesMgt.InitSeries(PurchSetup."Force Auction No", xRec."No. Series", 0D, "No.", "No. Series");
                                        end

                                        else
                                            if "Document Type" = "Document Type"::"Request For Proposal" then begin
                                                PurchSetup.TestField(PurchSetup."Request For Proposal");
                                                NoSeriesMgt.InitSeries(PurchSetup."Request For Proposal", xRec."No. Series", 0D, "No.", "No. Series");
                                            end; **/


        end;
        "Quotation date" := Today;

        ProcurementMethods.Reset;
        ProcurementMethods.SetRange(ProcurementMethods."Document Type", "Document Type");
        if ProcurementMethods.FindSet then begin
            "Procurement Type Code" := ProcurementMethods.Code;
            "Procurement Methods" := ProcurementMethods.Code;
        end;
        "Assigned User ID" := UserId;

    end;

    trigger OnModify()
    begin
        if xRec."No." <> "No." then begin
            PurchSetup.Get();
            NoSeriesMgt.TestManual(PurchSetup."Request For Quotation");
        end;

        /*
        IF (Status=Status::Released) OR (Status=Status::"Pending Approval")THEN
           ERROR('You Cannot Modify this record its status is not Open');
         */

    end;

    var
        Text000: Label 'Do you want to print receipt %1?';
        Text001: Label 'Do you want to print invoice %1?';
        Text002: Label 'Do you want to print credit memo %1?';
        Text003: Label 'You cannot rename a %1.';
        Text004: Label 'Do you want to change %1?';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        Text006: Label 'You cannot change %1 because the order is associated with one or more sales orders.';
        Text007: Label '%1 is greater than %2 in the %3 table.\';
        Text008: Label 'Confirm change?';
        Text009: Label 'Deleting this document will cause a gap in the number series for receipts. ';
        Text010: Label 'An empty receipt %1 will be created to fill this gap in the number series.\\';
        Text011: Label 'Do you want to continue?';
        Text012: Label 'Deleting this document will cause a gap in the number series for posted invoices. ';
        Text013: Label 'An empty posted invoice %1 will be created to fill this gap in the number series.\\';
        Text014: Label 'Deleting this document will cause a gap in the number series for posted credit memos. ';
        Text015: Label 'An empty posted credit memo %1 will be created to fill this gap in the number series.\\';
        Text016: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\';
        Text018: Label 'You must delete the existing purchase lines before you can change %1.';
        Text019: Label 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.\';
        Text020: Label 'You must update the existing purchase lines manually.';
        Text021: Label 'The change may affect the exchange rate used on the price calculation of the purchase lines.';
        Text022: Label 'Do you want to update the exchange rate?';
        Text023: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text024: Label 'Do you want to print return shipment %1?';
        Text025: Label 'You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. ';
        Text027: Label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text028: Label 'Your identification is set up to process from %1 %2 only.';
        Text029: Label 'Deleting this document will cause a gap in the number series for return shipments. ';
        Text030: Label 'An empty return shipment %1 will be created to fill this gap in the number series.\\';
        Text032: Label 'You have modified %1.\\';
        Text033: Label 'Do you want to update the lines?';
        Text034: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text037: Label 'Contact %1 %2 is not related to vendor %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than vendor %3.';
        Text039: Label 'Contact %1 %2 is not related to a vendor.';
        Text040: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text041: Label 'The purchase %1 %2 has item tracking. Do you want to delete it anyway?';
        Text042: Label 'You must cancel the approval process if you wish to change the %1.';
        Text043: Label 'Do you want to print prepayment invoice %1?';
        Text044: Label 'Do you want to print prepayment credit memo %1?';
        Text045: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. ';
        Text046: Label 'An empty prepayment invoice %1 will be created to fill this gap in the number series.\\';
        Text047: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos. ';
        Text049: Label '%1 is set up to process from %2 %3 only.';
        Text050: Label 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\';
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        location: Record Location;
        PurchHeader: Record "Purchase Header";
        //PurchLine: Record "Purchase Quote Line";
        RFQ: Record "Purchase Line";
        //VendorCatego: Record "Vendor Categories";
        PurchHeader_2: Record "Purchase Header";
        ProcurementMethods: Record "Procurement Methods";
        DocTxt: Label 'Invoice';
        //InternalMemoLines: Record "Internal Memo Lines";
        PQH: Record "Purchase Quote Header";
        IncomingDocument: Record "Incoming Document";
        GenSetup: Record "General Ledger Setup";
    //EvaluationCommitteeActivity: Record "Evaluation Committee Activity";
    //TenderCommitteeActivities: Record "Tender Committee Activities";

    procedure AutoPopPurchLine()
    var
        reqLine: Record "Purchase Line";
        //PurchLine2: Record "Purchase Quote Line";
        LineNo: Integer;
    //delReqLine: Record "Purchase Quote Line";

    begin
        /**
        PurchLine2.SetRange("Document Type", "Document Type");
        PurchLine2.SetRange("Document No.", "No.");
        PurchLine2.DeleteAll;
        PurchLine2.Reset; 

        //reqLine.SETRANGE(reqLine."Document Type","Document Type");
        reqLine.Reset;
        reqLine.SetRange(reqLine."Document No.", "PRF No");
        if reqLine.Find('-') then begin
            //PurchLine2.Init;
            
            repeat
            /**
                if reqLine.Quantity <> 0 then begin
                    PurchLine2.Init;
                    LineNo := LineNo + 1000;
                    PurchLine2."Document Type" := "Document Type";
                    PurchLine2.Validate("Document Type");
                    PurchLine2."Document No." := "No.";
                    PurchLine2.Validate("Document No.");
                    PurchLine2."Line No." := LineNo;
                    PurchLine2.Type := reqLine.Type;
                    PurchLine2."Expense Code" := reqLine."Expense Code";    //Denno added---
                    PurchLine2."No." := reqLine."No.";
                    PurchLine2.Validate("No.");
                    PurchLine2.Description := reqLine.Description;
                    PurchLine2."Description 2" := reqLine."Description 2";
                    PurchLine2.Quantity := reqLine.Quantity;
                    PurchLine2.Validate(Quantity);
                    PurchLine2."Unit of Measure Code" := reqLine."Unit of Measure Code";
                    PurchLine2.Validate("Unit of Measure Code");
                    PurchLine2."Unit of Measure" := reqLine."Unit of Measure";
                    //PurchLine2."Direct Unit Cost":=reqLine."Direct Unit Cost";
                    //PurchLine2.VALIDATE("Direct Unit Cost");
                    PurchLine2."Location Code" := reqLine."Location Code";
                    PurchLine2."Location Code" := "Location Code";
                    PurchLine2."Shortcut Dimension 1 Code" := reqLine."Global Dimension 1 Code";
                    PurchLine2."Shortcut Dimension 2 Code" := reqLine."Global Dimension 2 Code";
                    PurchLine2."Gen. Bus. Posting Group" := reqLine."Gen. Bus. Posting Group";
                    PurchLine2."Gen. Prod. Posting Group" := reqLine."Gen. Prod. Posting Group";
                    PurchLine2."VAT Prod. Posting Group" := reqLine."VAT Prod. Posting Group";
                    PurchLine2."VAT Bus. Posting Group" := reqLine."VAT Bus. Posting Group";

                    PurchLine2.Insert(true);
                    
        end;
            until reqLine.Next = 0;
    end;**/
    end;

    procedure EmailRecords(ShowDialog: Boolean)
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DummyReportSelections: Record "Report Selections";
    begin
        DocumentSendingProfile.TrySendToEMail(DummyReportSelections.Usage::"S.Invoice", Rec, FieldNo("No."), DocTxt, FieldNo("Vendor No."), ShowDialog);
    end;

    procedure SendRecords()
    var
        DocumentSendingProfile: Record "Document Sending Profile";
    begin
        if DocumentSendingProfile.LookUpProfileVendor("Vendor No.", IsSingleCustomerSelected, true) then
            SendProfile(DocumentSendingProfile);
    end;

    local procedure IsSingleCustomerSelected(): Boolean
    var
        SelectedCount: Integer;
        CustomerCount: Integer;
        BillToCustomerNoFilter: Text;
    begin
        SelectedCount := Count;

        if SelectedCount < 1 then
            exit(false);

        if SelectedCount = 1 then
            exit(true);

        BillToCustomerNoFilter := GetFilter("Vendor No.");
        SetRange("Vendor No.", "Vendor No.");
        CustomerCount := Count;
        SetFilter("Vendor No.", BillToCustomerNoFilter);

        exit(SelectedCount = CustomerCount);
    end;

    procedure SendProfile(var DocumentSendingProfile: Record "Document Sending Profile")
    var
        DummyReportSelections: Record "Report Selections";
    begin
        DocumentSendingProfile.Send(39005982, Rec, "No.", "Vendor No.", DocTxt, FieldNo("Vendor No."), FieldNo("No."));
    end;
}

