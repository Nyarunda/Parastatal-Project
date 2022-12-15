table 51533916 "Professional Opinion."
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin

                if "No." <> xRec."No." then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Professional Opinion Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[150])
        {
        }
        field(3; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected,Cancelled,Completed,Released';
            OptionMembers = Open,Pending,Approved,Rejected,Cancelled,Completed,Released;
        }
        field(5; "RFQ No."; Code[20])
        {
            Caption = 'Tender No';
            TableRelation = "Purchase Quote Header"."No." WHERE(Status = CONST(Released));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                PurchQuote.Reset;
                PurchQuote.SetRange(PurchQuote."No.", "RFQ No.");
                if PurchQuote.Find('-') then begin
                    "Responsibility Center" := PurchQuote."Responsibility Center";
                    Description := PurchQuote."Posting Description";
                    "Procurement Method" := PurchQuote."Procurement Methods";
                end;

                // PurchQuote.RESET;
                // PurchQuote.SETRANGE(PurchQuote."No.","RFQ No.");
                // IF PurchQuote.FIND('-') THEN
                // RecordLinkManagement.CopyLinks(PurchQuote,Rec);

                /*PurchaseQuoteHeader.RESET;
                PurchaseQuoteHeader.SETRANGE("No.","RFQ No.");
                IF PurchaseQuoteHeader.FIND('-') THEN BEGIN
                
                  InternalMemo.RESET;
                  InternalMemo.SETRANGE("No.",PurchaseQuoteHeader."Internal Requisition No.");
                  IF InternalMemo.FIND('-') THEN BEGIN
                    "Shortcut Dimension 1 Code":=InternalMemo."Shortcut Dimension 1 Code";
                    "Shortcut Dimension 2 Code":=InternalMemo."Shortcut Dimension 2 Code";
                    "Shortcut Dimension 3 Code":=InternalMemo."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code":=InternalMemo."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code":=InternalMemo."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code":=InternalMemo."Shortcut Dimension 6 Code";
                    END;
                
                "Memo No.":=PurchaseQuoteHeader."Internal Requisition No.";
                  END;
                  */

            end;
        }
        field(6; Remarks; Text[250])
        {
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(9; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(10; "Document Date"; Date)
        {
        }
        field(11; "Created By"; Code[50])
        {
        }
        field(12; "Approved PR"; Code[30])
        {
        }
        field(13; "LPO No."; Code[50])
        {
        }
        field(14; "Vendor No"; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                Vendor.Reset;
                Vendor.SetRange("No.", "Vendor No");
                if Vendor.FindFirst then
                    "Vendor Name" := Vendor.Name;
            end;
        }
        field(15; "Vendor Name"; Text[100])
        {
            Editable = false;
        }
        field(16; "Tender Opening Date"; Date)
        {
        }
        field(17; "Date Tenders Invited"; Date)
        {
        }
        field(18; "Procurement Method"; Code[20])
        {
        }
        field(19; "No Of Bids Received"; Integer)
        {
            CalcFormula = Count("Quotation Analysis Lines" WHERE("RFQ No." = FIELD("RFQ No.")));
            FieldClass = FlowField;
        }
        field(20; "No Of Tenderers Issues"; Integer)
        {
            //CalcFormula = Count("Quotation Request Vendors" WHERE("Requisition Document No." = FIELD("RFQ No.")));
            //FieldClass = FlowField;
        }
        field(21; "Background Statement"; Text[250])
        {
        }
        field(22; "Due Diligence Conducted"; Boolean)
        {
        }
        field(23; "Due diligence Comment"; Text[250])
        {
        }
        field(24; "Whether award is appropriate"; Text[250])
        {
        }
        field(25; "Recommended price"; Text[250])
        {
        }
        field(26; "Evaluation criteria applied"; Text[250])
        {
        }
        field(27; "Confirm adequate funds"; Text[250])
        {
        }
        field(28; "Opinion on Proc practices"; Text[250])
        {
        }
        field(29; "Bid No"; Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Evaluate Completed Bids Header".Code WHERE("Forwaded to HOD" = CONST(true));

            trigger OnValidate()
            begin
                /**EvalBidH.Reset;
                EvalBidH.SetRange(EvalBidH.Code, "Bid No");
                if EvalBidH.Find('-') then begin
                    "RFQ No." := EvalBidH."RFQ No.";
                end;
                **/
            end;
        }
        field(30; "Rejected Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Rejected';
            OptionMembers = " ",Rejected;
        }
        field(31; "Financial Evaluation No"; Code[30])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Financial Evaluation Header".Code WHERE(Status = CONST(Approved));
        }
        field(32; "C.E.O Reccommendations"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(33; Award; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "H.O.D  Reccomendation"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Professional Opinion Nos");
            NoSeriesMgt.InitSeries(NoSetup."Professional Opinion Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;


        "Document Date" := Today;
        "Created By" := UserId;
    end;

    var
        NoSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchQuote: Record "Purchase Quote Header";
        Vendor: Record Vendor;
    // EvalBidH: Record "Evaluate Completed Bids Header";
}

