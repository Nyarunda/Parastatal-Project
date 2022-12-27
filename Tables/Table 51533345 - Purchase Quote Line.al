table 51533345 "Purchase Quote Line"
{
    Caption = 'Purchase Quote Line';
    //LookupPageID = 39004371;
    PasteIsValid = false;

    fields
    {
        field(1;"Document Type";Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Quotation Request,Open Tender,Restricted Tender';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender";
        }
        field(2;"Buy-from Vendor No.";Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Vendor;
        }
        field(3;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(4;"Line No.";Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(5;Type;Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item),Non Stock Item';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)","Non Stock Item";
        }
        field(6;"No.";Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST("G/L Account")) "G/L Account"."No." WHERE ("Expense Code"=FIELD("Expense Code"))
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST("Fixed Asset")) "Fixed Asset"
                            ELSE IF (Type=CONST("Fixed Asset")) Resource
                            ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";

            trigger OnValidate()
            var
                ICPartner: Record "IC Partner";
                ItemCrossReference: Record "Item Cross Reference";
                PrepmtMgt: Codeunit "Prepayment Mgt.";
            begin
                //,G/L Account,Item,,Fixed Asset,Charge (Item),Non Stock Item
                if Type=Type::"G/L Account" then
                  begin
                    GLAcc.Reset;
                    GLAcc.Get("No.");
                    Description:=GLAcc.Name;
                    //IF Type=Type:: "G/L Account" THEN
                    "Unit of Measure Code":='LOT';
                  end
                else if Type=Type::Item then
                  begin
                    Item.Reset;
                    Item.Get("No.");
                    Description:=Item.Description;
                  end
                else if Type=Type::"Fixed Asset" then
                  begin
                    FA.Reset;
                    FA.Get("No.");
                    Description:=FA.Description;
                  end
                else if Type=Type::"Charge (Item)" then
                  begin
                    CItem.Reset;
                    CItem.Get("No.");
                    Description:=CItem.Description;
                  end
                else if Type=Type::"Non Stock Item" then
                  begin
                    NonStockItem.Reset;
                    NonStockItem.SetRange(NonStockItem.No,"No.");
                    if NonStockItem.Find('-') then
                    Description:=NonStockItem.Description;
                  end
            end;
        }
        field(7;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE ("Use As In-Transit"=CONST(false));
        }
        field(8;"Posting Group";Code[10])
        {
            Caption = 'Posting Group';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF (Type=CONST(Item)) "Inventory Posting Group"
                            ELSE IF (Type=CONST("Fixed Asset")) "FA Posting Group";
        }
        field(10;"Expected Receipt Date";Date)
        {
            Caption = 'Expected Receipt Date';
            DataClassification = ToBeClassified;
        }
        field(11;Description;Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(12;"Description 2";Text[250])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(13;"Unit of Measure";Code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(15;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = true;

            trigger OnValidate()
            begin
                if "Direct Unit Cost"<>0 then
                  begin
                    Amount:=Quantity * "Direct Unit Cost";
                  end;
            end;
        }
        field(16;"Outstanding Quantity";Decimal)
        {
            Caption = 'Outstanding Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(17;"Qty. to Invoice";Decimal)
        {
            Caption = 'Qty. to Invoice';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(18;"Qty. to Receive";Decimal)
        {
            Caption = 'Qty. to Receive';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(22;"Direct Unit Cost";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Quantity<>0 then
                  begin
                    Amount:=Quantity * "Direct Unit Cost";
                  end;
            end;
        }
        field(23;"Unit Cost (LCY)";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            DataClassification = ToBeClassified;
        }
        field(25;"VAT %";Decimal)
        {
            Caption = 'VAT %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(27;"Line Discount %";Decimal)
        {
            Caption = 'Line Discount %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28;"Line Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
            DataClassification = ToBeClassified;
        }
        field(29;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(31;"Unit Price (LCY)";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price (LCY)';
            DataClassification = ToBeClassified;
        }
        field(32;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(34;"Gross Weight";Decimal)
        {
            Caption = 'Gross Weight';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(35;"Net Weight";Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(36;"Units per Parcel";Decimal)
        {
            Caption = 'Units per Parcel';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(37;"Unit Volume";Decimal)
        {
            Caption = 'Unit Volume';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(38;"Appl.-to Item Entry";Integer)
        {
            Caption = 'Appl.-to Item Entry';
            DataClassification = ToBeClassified;
        }
        field(40;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(41;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(45;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            DataClassification = ToBeClassified;
            TableRelation = Job;

            trigger OnValidate()
            var
                Job: Record Job;
            begin
            end;
        }
        field(54;"Indirect Cost %";Decimal)
        {
            Caption = 'Indirect Cost %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(57;"Outstanding Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Outstanding Amount';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
            end;
        }
        field(58;"Qty. Rcd. Not Invoiced";Decimal)
        {
            Caption = 'Qty. Rcd. Not Invoiced';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(59;"Amt. Rcd. Not Invoiced";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amt. Rcd. Not Invoiced';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
            end;
        }
        field(60;"Quantity Received";Decimal)
        {
            Caption = 'Quantity Received';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(61;"Quantity Invoiced";Decimal)
        {
            Caption = 'Quantity Invoiced';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(63;"Receipt No.";Code[20])
        {
            Caption = 'Receipt No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(64;"Receipt Line No.";Integer)
        {
            Caption = 'Receipt Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(67;"Profit %";Decimal)
        {
            Caption = 'Profit %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(68;"Pay-to Vendor No.";Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Vendor;
        }
        field(69;"Inv. Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70;"Vendor Item No.";Text[20])
        {
            Caption = 'Vendor Item No.';
            DataClassification = ToBeClassified;
        }
        field(71;"Sales Order No.";Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF ("Drop Shipment"=CONST(true)) "Sales Header"."No." WHERE ("Document Type"=CONST(Order));
        }
        field(72;"Sales Order Line No.";Integer)
        {
            Caption = 'Sales Order Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF ("Drop Shipment"=CONST(true)) "Sales Line"."Line No." WHERE ("Document Type"=CONST(Order),
                                                                                            "Document No."=FIELD("Sales Order No."));
        }
        field(73;"Drop Shipment";Boolean)
        {
            Caption = 'Drop Shipment';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(74;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(75;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(77;"VAT Calculation Type";Option)
        {
            Caption = 'VAT Calculation Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(78;"Transaction Type";Code[10])
        {
            Caption = 'Transaction Type';
            DataClassification = ToBeClassified;
            TableRelation = "Transaction Type";
        }
        field(79;"Transport Method";Code[10])
        {
            Caption = 'Transport Method';
            DataClassification = ToBeClassified;
            TableRelation = "Transport Method";
        }
        field(80;"Attached to Line No.";Integer)
        {
            Caption = 'Attached to Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Purchase Line"."Line No." WHERE ("Document Type"=FIELD("Document Type"),
                                                              "Document No."=FIELD("Document No."));
        }
        field(81;"Entry Point";Code[10])
        {
            Caption = 'Entry Point';
            DataClassification = ToBeClassified;
            TableRelation = "Entry/Exit Point";
        }
        field(82;"Area";Code[10])
        {
            Caption = 'Area';
            DataClassification = ToBeClassified;
            TableRelation = Area;
        }
        field(83;"Transaction Specification";Code[10])
        {
            Caption = 'Transaction Specification';
            DataClassification = ToBeClassified;
            TableRelation = "Transaction Specification";
        }
        field(85;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Area";
        }
        field(86;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';
            DataClassification = ToBeClassified;
        }
        field(87;"Tax Group Code";Code[10])
        {
            Caption = 'Tax Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Group";
        }
        field(88;"Use Tax";Boolean)
        {
            Caption = 'Use Tax';
            DataClassification = ToBeClassified;
        }
        field(89;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";
        }
        field(90;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
        }
        field(91;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Currency;
        }
        field(92;"Outstanding Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Outstanding Amount (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(93;"Amt. Rcd. Not Invoiced (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amt. Rcd. Not Invoiced (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(95;"Reserved Quantity";Decimal)
        {
            CalcFormula = Sum("Reservation Entry".Quantity WHERE ("Source ID"=FIELD("Document No."),
                                                                  "Source Ref. No."=FIELD("Line No."),
                                                                  "Source Type"=CONST(39),
                                                                  "Source Subtype"=FIELD("Document Type"),
                                                                  "Reservation Status"=CONST(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(97;"Blanket Order No.";Code[20])
        {
            Caption = 'Blanket Order No.';
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." WHERE ("Document Type"=CONST("Blanket Order"));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(98;"Blanket Order Line No.";Integer)
        {
            Caption = 'Blanket Order Line No.';
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Line"."Line No." WHERE ("Document Type"=CONST("Blanket Order"),
                                                              "Document No."=FIELD("Blanket Order No."));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(99;"VAT Base Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(100;"Unit Cost";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(101;"System-Created Entry";Boolean)
        {
            Caption = 'System-Created Entry';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(103;"Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Amount';
            DataClassification = ToBeClassified;
        }
        field(104;"VAT Difference";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(105;"Inv. Disc. Amount to Invoice";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(106;"VAT Identifier";Code[10])
        {
            Caption = 'VAT Identifier';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(107;"IC Partner Ref. Type";Option)
        {
            Caption = 'IC Partner Ref. Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.,Vendor Item No.';
            OptionMembers = " ","G/L Account",Item,,,"Charge (Item)","Cross Reference","Common Item No.","Vendor Item No.";
        }
        field(108;"IC Partner Reference";Code[20])
        {
            Caption = 'IC Partner Reference';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                ICGLAccount: Record "IC G/L Account";
                ItemCrossReference: Record "Item Cross Reference";
                ItemVendorCatalog: Record "Item Vendor";
            begin
            end;
        }
        field(109;"Prepayment %";Decimal)
        {
            Caption = 'Prepayment %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                GenPostingSetup: Record "General Posting Setup";
                GLAcc: Record "G/L Account";
            begin
            end;
        }
        field(110;"Prepmt. Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Line Amount';
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(111;"Prepmt. Amt. Inv.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Inv.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(112;"Prepmt. Amt. Incl. VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Incl. VAT';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(113;"Prepayment Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(114;"Prepmt. VAT Base Amt.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. VAT Base Amt.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(115;"Prepayment VAT %";Decimal)
        {
            Caption = 'Prepayment VAT %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
            MinValue = 0;
        }
        field(116;"Prepmt. VAT Calc. Type";Option)
        {
            Caption = 'Prepmt. VAT Calc. Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(117;"Prepayment VAT Identifier";Code[10])
        {
            Caption = 'Prepayment VAT Identifier';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(118;"Prepayment Tax Area Code";Code[20])
        {
            Caption = 'Prepayment Tax Area Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Area";
        }
        field(119;"Prepayment Tax Liable";Boolean)
        {
            Caption = 'Prepayment Tax Liable';
            DataClassification = ToBeClassified;
        }
        field(120;"Prepayment Tax Group Code";Code[10])
        {
            Caption = 'Prepayment Tax Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Group";
        }
        field(121;"Prepmt Amt to Deduct";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt Amt to Deduct';
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(122;"Prepmt Amt Deducted";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt Amt Deducted';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(123;"Prepayment Line";Boolean)
        {
            Caption = 'Prepayment Line';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(124;"Prepmt. Amount Inv. Incl. VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. Incl. VAT';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(129;"Prepmt. Amount Inv. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(130;"IC Partner Code";Code[20])
        {
            Caption = 'IC Partner Code';
            DataClassification = ToBeClassified;
            TableRelation = "IC Partner";
        }
        field(135;"Prepayment VAT Difference";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment VAT Difference';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(136;"Prepmt VAT Diff. to Deduct";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt VAT Diff. to Deduct';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(137;"Prepmt VAT Diff. Deducted";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt VAT Diff. Deducted';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1001;"Job Task No.";Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No." WHERE ("Job No."=FIELD("Job No."));
        }
        field(1002;"Job Line Type";Option)
        {
            Caption = 'Job Line Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Schedule,Contract,Both Schedule and Contract';
            OptionMembers = " ",Schedule,Contract,"Both Schedule and Contract";
        }
        field(1003;"Job Unit Price";Decimal)
        {
            BlankZero = true;
            Caption = 'Job Unit Price';
            DataClassification = ToBeClassified;
        }
        field(1004;"Job Total Price";Decimal)
        {
            BlankZero = true;
            Caption = 'Job Total Price';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1005;"Job Line Amount";Decimal)
        {
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Job Line Amount';
            DataClassification = ToBeClassified;
        }
        field(1006;"Job Line Discount Amount";Decimal)
        {
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Job Line Discount Amount';
            DataClassification = ToBeClassified;
        }
        field(1007;"Job Line Discount %";Decimal)
        {
            BlankZero = true;
            Caption = 'Job Line Discount %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(1008;"Job Unit Price (LCY)";Decimal)
        {
            BlankZero = true;
            Caption = 'Job Unit Price (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1009;"Job Total Price (LCY)";Decimal)
        {
            BlankZero = true;
            Caption = 'Job Total Price (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1010;"Job Line Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Job Line Amount (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1011;"Job Line Disc. Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Job Line Disc. Amount (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1012;"Job Currency Factor";Decimal)
        {
            BlankZero = true;
            Caption = 'Job Currency Factor';
            DataClassification = ToBeClassified;
        }
        field(1013;"Job Currency Code";Code[20])
        {
            Caption = 'Job Currency Code';
            DataClassification = ToBeClassified;
        }
        field(5401;"Prod. Order No.";Code[20])
        {
            Caption = 'Prod. Order No.';
            DataClassification = ToBeClassified;
            TableRelation = "Production Order"."No." WHERE (Status=CONST(Released));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5402;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE ("Item No."=FIELD("No."));
        }
        field(5403;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                WMSManagement: Codeunit "WMS Management";
                BinCode: Code[20];
            begin
            end;

            trigger OnValidate()
            var
                WMSManagement: Codeunit "WMS Management";
            begin
            end;
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("No."))
                            ELSE "Unit of Measure";

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
            begin
            end;
        }
        field(5415;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(5416;"Outstanding Qty. (Base)";Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5417;"Qty. to Invoice (Base)";Decimal)
        {
            Caption = 'Qty. to Invoice (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(5418;"Qty. to Receive (Base)";Decimal)
        {
            Caption = 'Qty. to Receive (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(5458;"Qty. Rcd. Not Invoiced (Base)";Decimal)
        {
            Caption = 'Qty. Rcd. Not Invoiced (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5460;"Qty. Received (Base)";Decimal)
        {
            Caption = 'Qty. Received (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5461;"Qty. Invoiced (Base)";Decimal)
        {
            Caption = 'Qty. Invoiced (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5495;"Reserved Qty. (Base)";Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE ("Source Type"=CONST(39),
                                                                           "Source Subtype"=FIELD("Document Type"),
                                                                           "Source ID"=FIELD("Document No."),
                                                                           "Source Ref. No."=FIELD("Line No."),
                                                                           "Reservation Status"=CONST(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5600;"FA Posting Date";Date)
        {
            Caption = 'FA Posting Date';
            DataClassification = ToBeClassified;
        }
        field(5601;"FA Posting Type";Option)
        {
            Caption = 'FA Posting Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Acquisition Cost,Maintenance';
            OptionMembers = " ","Acquisition Cost",Maintenance;
        }
        field(5602;"Depreciation Book Code";Code[10])
        {
            Caption = 'Depreciation Book Code';
            DataClassification = ToBeClassified;
            TableRelation = "Depreciation Book";
        }
        field(5603;"Salvage Value";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Salvage Value';
            DataClassification = ToBeClassified;
        }
        field(5605;"Depr. until FA Posting Date";Boolean)
        {
            Caption = 'Depr. until FA Posting Date';
            DataClassification = ToBeClassified;
        }
        field(5606;"Depr. Acquisition Cost";Boolean)
        {
            Caption = 'Depr. Acquisition Cost';
            DataClassification = ToBeClassified;
        }
        field(5609;"Maintenance Code";Code[10])
        {
            Caption = 'Maintenance Code';
            DataClassification = ToBeClassified;
            TableRelation = Maintenance;
        }
        field(5610;"Insurance No.";Code[20])
        {
            Caption = 'Insurance No.';
            DataClassification = ToBeClassified;
            TableRelation = Insurance;
        }
        field(5611;"Budgeted FA No.";Code[20])
        {
            Caption = 'Budgeted FA No.';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
        }
        field(5612;"Duplicate in Depreciation Book";Code[10])
        {
            Caption = 'Duplicate in Depreciation Book';
            DataClassification = ToBeClassified;
            TableRelation = "Depreciation Book";
        }
        field(5613;"Use Duplication List";Boolean)
        {
            Caption = 'Use Duplication List';
            DataClassification = ToBeClassified;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(5705;"Cross-Reference No.";Code[20])
        {
            Caption = 'Cross-Reference No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ReturnedCrossRef: Record "Item Cross Reference";
            begin
            end;
        }
        field(5706;"Unit of Measure (Cross Ref.)";Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("No."));
        }
        field(5707;"Cross-Reference Type";Option)
        {
            Caption = 'Cross-Reference Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Customer,Vendor,Bar Code';
            OptionMembers = " ",Customer,Vendor,"Bar Code";
        }
        field(5708;"Cross-Reference Type No.";Code[30])
        {
            Caption = 'Cross-Reference Type No.';
            DataClassification = ToBeClassified;
        }
        field(5709;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
        field(5710;Nonstock;Boolean)
        {
            Caption = 'Nonstock';
            DataClassification = ToBeClassified;
        }
        field(5711;"Purchasing Code";Code[10])
        {
            Caption = 'Purchasing Code';
            DataClassification = ToBeClassified;
            TableRelation = Purchasing;
        }
        field(5712;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Product Group".Code WHERE ("Item Category Code"=FIELD("Item Category Code"));
        }
        field(5713;"Special Order";Boolean)
        {
            Caption = 'Special Order';
            DataClassification = ToBeClassified;
        }
        field(5714;"Special Order Sales No.";Code[20])
        {
            Caption = 'Special Order Sales No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Special Order"=CONST(true)) "Sales Header"."No." WHERE ("Document Type"=CONST(Order));
        }
        field(5715;"Special Order Sales Line No.";Integer)
        {
            Caption = 'Special Order Sales Line No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Special Order"=CONST(true)) "Sales Line"."Line No." WHERE ("Document Type"=CONST(Order),
                                                                                            "Document No."=FIELD("Special Order Sales No."));
        }
        field(5750;"Whse. Outstanding Qty. (Base)";Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Warehouse Receipt Line"."Qty. Outstanding (Base)" WHERE ("Source Type"=CONST(39),
                                                                                        "Source Subtype"=FIELD("Document Type"),
                                                                                        "Source No."=FIELD("Document No."),
                                                                                        "Source Line No."=FIELD("Line No.")));
            Caption = 'Whse. Outstanding Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5752;"Completely Received";Boolean)
        {
            Caption = 'Completely Received';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5790;"Requested Receipt Date";Date)
        {
            Caption = 'Requested Receipt Date';
            DataClassification = ToBeClassified;
        }
        field(5791;"Promised Receipt Date";Date)
        {
            Caption = 'Promised Receipt Date';
            DataClassification = ToBeClassified;
        }
        field(5792;"Lead Time Calculation";DateFormula)
        {
            Caption = 'Lead Time Calculation';
            DataClassification = ToBeClassified;
        }
        field(5793;"Inbound Whse. Handling Time";DateFormula)
        {
            Caption = 'Inbound Whse. Handling Time';
            DataClassification = ToBeClassified;
        }
        field(5794;"Planned Receipt Date";Date)
        {
            Caption = 'Planned Receipt Date';
            DataClassification = ToBeClassified;
        }
        field(5795;"Order Date";Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(5800;"Allow Item Charge Assignment";Boolean)
        {
            Caption = 'Allow Item Charge Assignment';
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(5801;"Qty. to Assign";Decimal)
        {
            CalcFormula = Sum("Item Charge Assignment (Purch)"."Qty. to Assign" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                       "Document No."=FIELD("Document No."),
                                                                                       "Document Line No."=FIELD("Line No.")));
            Caption = 'Qty. to Assign';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5802;"Qty. Assigned";Decimal)
        {
            CalcFormula = Sum("Item Charge Assignment (Purch)"."Qty. Assigned" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                      "Document No."=FIELD("Document No."),
                                                                                      "Document Line No."=FIELD("Line No.")));
            Caption = 'Qty. Assigned';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5803;"Return Qty. to Ship";Decimal)
        {
            Caption = 'Return Qty. to Ship';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(5804;"Return Qty. to Ship (Base)";Decimal)
        {
            Caption = 'Return Qty. to Ship (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(5805;"Return Qty. Shipped Not Invd.";Decimal)
        {
            Caption = 'Return Qty. Shipped Not Invd.';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5806;"Ret. Qty. Shpd Not Invd.(Base)";Decimal)
        {
            Caption = 'Ret. Qty. Shpd Not Invd.(Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5807;"Return Shpd. Not Invd.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Return Shpd. Not Invd.';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
            end;
        }
        field(5808;"Return Shpd. Not Invd. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Return Shpd. Not Invd. (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5809;"Return Qty. Shipped";Decimal)
        {
            Caption = 'Return Qty. Shipped';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5810;"Return Qty. Shipped (Base)";Decimal)
        {
            Caption = 'Return Qty. Shipped (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(6600;"Return Shipment No.";Code[20])
        {
            Caption = 'Return Shipment No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6601;"Return Shipment Line No.";Integer)
        {
            Caption = 'Return Shipment Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6608;"Return Reason Code";Code[10])
        {
            Caption = 'Return Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = "Return Reason";
        }
        field(39004240;Committed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004241;"Expense Code";Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Expense Code".Code;
        }
        field(39004242;"Asset No.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset"."No.";
        }
        field(39004243;Specifications;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(39004244;"PRF No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(39004245;"PRF Line No.";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(39004246;"Qty Received";Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line".Quantity WHERE ("Document No."=FIELD("Document No."),
                                                                  "Line No."=FIELD("Line No.")));
            Description = 'if quantity received=quantity then the lines have been completely received';
            FieldClass = FlowField;
        }
        field(39004353;"Extended Order Description";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(39005608;"Workplan Code";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ProcurementPlanActivities: Record "Procurement Plan Activities";
            begin
            end;
        }
        field(39005609;"Activity Code";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ProcurementPlanActivities: Record "Procurement Plan Activities";
                GLAccount: Record "G/L Account";
                Item: Record Item;
            begin
            end;
        }
        field(39005610;"Shortcut Dimension 3 Code";Code[30])
        {
            CaptionClass = '1,2,3';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3),
                                                          Blocked=CONST(false));

            trigger OnValidate()
            begin
                // ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
            end;
        }
        field(39005611;"Shortcut Dimension 4 Code";Code[30])
        {
            CaptionClass = '1,2,4';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(4),
                                                          Blocked=CONST(false));

            trigger OnValidate()
            begin
                 //ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
            end;
        }
        field(39005612;"Shortcut Dimension 5 Code";Code[30])
        {
            CaptionClass = '1,2,5';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(5),
                                                          Blocked=CONST(false));

            trigger OnValidate()
            begin
                 //ValidateShortcutDimCode(5,"Shortcut Dimension 5 Code");
            end;
        }
        field(39005613;Remarks;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Recommended,not recommended';
            OptionMembers = " ",Recommended,"not recommended";
        }
        field(99000750;"Routing No.";Code[20])
        {
            Caption = 'Routing No.';
            DataClassification = ToBeClassified;
            TableRelation = "Routing Header";
        }
        field(99000751;"Operation No.";Code[10])
        {
            Caption = 'Operation No.';
            DataClassification = ToBeClassified;
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE (Status=CONST(Released),
                                                                              "Prod. Order No."=FIELD("Prod. Order No."),
                                                                              "Routing No."=FIELD("Routing No."));

            trigger OnValidate()
            var
                ProdOrderRtngLine: Record "Prod. Order Routing Line";
            begin
            end;
        }
        field(99000752;"Work Center No.";Code[20])
        {
            Caption = 'Work Center No.';
            DataClassification = ToBeClassified;
            TableRelation = "Work Center";
        }
        field(99000753;Finished;Boolean)
        {
            Caption = 'Finished';
            DataClassification = ToBeClassified;
        }
        field(99000754;"Prod. Order Line No.";Integer)
        {
            Caption = 'Prod. Order Line No.';
            DataClassification = ToBeClassified;
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status=FILTER(Released..),
                                                                 "Prod. Order No."=FIELD("Prod. Order No."));
        }
        field(99000755;"Overhead Rate";Decimal)
        {
            Caption = 'Overhead Rate';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0:5;
        }
        field(99000756;"MPS Order";Boolean)
        {
            Caption = 'MPS Order';
            DataClassification = ToBeClassified;
        }
        field(99000757;"Planning Flexibility";Option)
        {
            Caption = 'Planning Flexibility';
            DataClassification = ToBeClassified;
            OptionCaption = 'Unlimited,None';
            OptionMembers = Unlimited,"None";
        }
        field(99000758;"Safety Lead Time";DateFormula)
        {
            Caption = 'Safety Lead Time';
            DataClassification = ToBeClassified;
        }
        field(99000759;"Routing Reference No.";Integer)
        {
            Caption = 'Routing Reference No.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Amount,"Amount Including VAT";
        }
        key(Key2;"Document No.","Line No.","Document Type")
        {
        }
        key(Key3;"Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key4;"Document Type","Pay-to Vendor No.","Currency Code")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Outstanding Amount","Amt. Rcd. Not Invoiced","Outstanding Amount (LCY)","Amt. Rcd. Not Invoiced (LCY)";
        }
        key(Key5;"Document Type",Type,"No.","Variant Code","Drop Shipment","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Location Code","Expected Receipt Date")
        {
            Enabled = false;
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key6;"Document Type","Pay-to Vendor No.","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Currency Code")
        {
            Enabled = false;
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Outstanding Amount","Amt. Rcd. Not Invoiced","Outstanding Amount (LCY)","Amt. Rcd. Not Invoiced (LCY)";
        }
        key(Key7;"Document Type","Blanket Order No.","Blanket Order Line No.")
        {
        }
        key(Key8;"Document Type",Type,"Prod. Order No.","Prod. Order Line No.","Routing No.","Operation No.")
        {
        }
        key(Key9;"Document Type","Document No.","Location Code")
        {
        }
        key(Key10;"Document Type","Receipt No.","Receipt Line No.")
        {
        }
        key(Key11;Type,"No.","Variant Code","Drop Shipment","Location Code","Document Type","Expected Receipt Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key12;"Document Type","Buy-from Vendor No.")
        {
        }
        key(Key13;"Document Type","Job No.","Job Task No.")
        {
            SumIndexFields = "Outstanding Amount (LCY)","Amt. Rcd. Not Invoiced (LCY)";
        }
        key(Key14;Committed,"Expected Receipt Date")
        {
            SumIndexFields = Amount,"Amount Including VAT";
        }
        key(Key15;"Document No.",Type,"No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PurchCommentLine: Record "Purch. Comment Line";
    begin
        Header.Reset;
        Header.SetRange(Header."No.", "Document No.");
        if Header.Find('-') then
          begin
            if Header.Status=Header.Status::Released then
              Error('You can not Delete Lines for a released Document!');
            end;
    end;

    var
        Text000: Label 'You cannot rename a %1.';
        Text001: Label 'You cannot change %1 because the order line is associated with sales order %2.';
        Text002: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        Text003: Label 'You cannot purchase resources.';
        Text004: Label 'must not be less than %1';
        Text006: Label 'You cannot invoice more than %1 units.';
        Text007: Label 'You cannot invoice more than %1 base units.';
        Text008: Label 'You cannot receive more than %1 units.';
        Text009: Label 'You cannot receive more than %1 base units.';
        Text010: Label 'You cannot change %1 when %2 is %3.';
        Text011: Label ' must be 0 when %1 is %2';
        Text012: Label 'must not be specified when %1 = %2';
        Text014: Label 'Change %1 from %2 to %3?';
        Text016: Label '%1 is required for %2 = %3.';
        Text017: Label '\The entered information will be disregarded by warehouse operations.';
        Text018: Label '%1 %2 is earlier than the work date %3.';
        Text020: Label 'You cannot return more than %1 units.';
        Text021: Label 'You cannot return more than %1 base units.';
        Text022: Label 'You cannot change %1, if item charge is already posted.';
        Text023: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text029: Label 'must be positive.';
        Text030: Label 'must be negative.';
        Text031: Label 'You cannot define item tracking on this line because it is linked to production order %1.';
        Text032: Label '%1 must not be greater than %2.';
        Text033: Label 'Warehouse ';
        Text034: Label 'Inventory ';
        Text035: Label '%1 units for %2 %3 have already been returned or transferred. Therefore, only %4 units can be returned.';
        Text036: Label 'You must cancel the existing approval for this document to be able to change the %1 field.';
        Text037: Label 'cannot be %1.';
        Text038: Label 'cannot be less than %1.';
        Text039: Label 'cannot be more than %1.';
        Text99000000: Label 'You cannot change %1 when the purchase order is associated to a production order.';
        Text042: Label 'You cannot return more than the %1 units that you have received for %2 %3.';
        Text043: Label 'must be positive when %1 is not 0.';
        Text044: Label 'You cannot change %1 because this purchase order is associated with %2 %3.';
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FA: Record "Fixed Asset";
        CItem: Record "Item Charge";
        Header: Record "Purchase Quote Header";
        NonStockItem: Record "Non Stock Ledger Entry";
}

