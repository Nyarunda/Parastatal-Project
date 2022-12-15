table 51533355 "Quotation Analysis Header"
{
    DrillDownPageID = "Quotation Analysis List";
    LookupPageID = "Quotation Analysis List";

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin

                if "No." <> xRec."No." then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Bid Analysis Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[250])
        {
        }
        field(3; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; Status; Enum "Approval Status")
        {

            trigger OnValidate()
            begin
                if EvaluationCriteriaTable.Get("No.") then
                    EvaluationCriteriaTable."Bid Status" := Status;
                //EvaluationCriteriaTable.Validate(EvaluationCriterialHeader."Bid Status", Status);
            end;
        }
        field(5; "RFQ No."; Code[20])
        {
            //TableRelation = "Purchase Quote Header"."No." WHERE(Status = CONST(Released));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                PurchQuote.Reset;
                PurchQuote.SetRange(PurchQuote."No.", "RFQ No.");
                //IF "RFQ No."<> xRec."RFQ No." THEN BEGIN
                if PurchQuote.Find('-') then begin
                    "Responsibility Center" := PurchQuote."Responsibility Center";
                    Description := PurchQuote."Posting Description";
                    //"Shortcut Dimension 1 Code":=PurchQuote."Shortcut Dimension 1 Code";
                    //"Approved PR" := PurchQuote."Request for Quote No.";//"Approved PR No.";
                    Validate("Approved PR");
                    // "Shortcut Dimension 2 Code":= PurchQuote."Shortcut Dimension 2 Code";
                    // "Repeat Order" := PurchQuote."Repeat Order";
                    //"Repeat order RFQ No." := PurchQuote."RFQ No.";
                    /**PurchaseQuoteHeader.Reset;
                    PurchaseQuoteHeader.SetRange("No.", "RFQ No.");
                    if PurchaseQuoteHeader.Find('-') then begin
                        "Technical  Pass Score" := PurchaseQuoteHeader."Technical Pass Score";
                    end; **/


                end;

                PurchQuote.Reset;
                PurchQuote.SetRange(PurchQuote."No.", "RFQ No.");
                if PurchQuote.Find('-') then
                    RecordLinkManagement.CopyLinks(PurchQuote, Rec);
                //END


                /**
                                PurchaseQuoteHeader.Reset;
                                PurchaseQuoteHeader.SetRange("No.", "RFQ No.");
                                if PurchaseQuoteHeader.Find('-') then begin

                                    InternalMemo.Reset;
                                    InternalMemo.SetRange("No.", PurchaseQuoteHeader."Internal Requisition No.");
                                    if InternalMemo.Find('-') then begin
                                        "Shortcut Dimension 1 Code" := InternalMemo."Shortcut Dimension 1 Code";
                                        "Shortcut Dimension 2 Code" := InternalMemo."Shortcut Dimension 2 Code";
                                        "Shortcut Dimension 3 Code" := InternalMemo."Shortcut Dimension 3 Code";
                                        "Shortcut Dimension 4 Code" := InternalMemo."Shortcut Dimension 4 Code";
                                        "Shortcut Dimension 5 Code" := InternalMemo."Shortcut Dimension 5 Code";
                                        "Shortcut Dimension 6 Code" := InternalMemo."Shortcut Dimension 6 Code";
                                    end;
                                    Description := PurchaseQuoteHeader."Posting Description";
                                    "Memo No." := PurchaseQuoteHeader."Internal Requisition No.";
                                    "Technical  Pass Score" := PurchaseQuoteHeader."Technical Pass Score";
                                end; **/

                //insert evaluation criterias
                EvaluationCriteriaTable.Reset;
                EvaluationCriteriaTable.SetRange(EvaluationCriteriaTable."Bid No.", "No.");
                if not EvaluationCriteriaTable.Find('-') then begin

                    EvaluationCriterialHeader.Reset;
                    EvaluationCriterialHeader.SetRange(EvaluationCriterialHeader."RFQ No.", "RFQ No.");
                    if EvaluationCriterialHeader.Find('-') then begin
                        repeat
                            EvaluationCriteriaTable.Init;
                            EvaluationCriteriaTable."Entry No" := 0;
                            EvaluationCriteriaTable."No." := '';
                            EvaluationCriteriaTable."RFQ No." := "RFQ No.";
                            EvaluationCriteriaTable.Code := EvaluationCriterialHeader.Code;
                            EvaluationCriteriaTable."Procurement Method" := EvaluationCriterialHeader."Procurement Method";
                            EvaluationCriteriaTable."Actual Weight Assigned" := EvaluationCriterialHeader."Actual Weight Assigned";
                            EvaluationCriteriaTable."Evaluation Category" := EvaluationCriterialHeader."Evaluation Category";
                            EvaluationCriteriaTable."Evaluation Maximum Score" := EvaluationCriterialHeader."Evaluation Maximum Score";
                            EvaluationCriteriaTable."Evaluation Year" := EvaluationCriterialHeader."Evaluation Year";
                            EvaluationCriteriaTable.YesNo := EvaluationCriterialHeader.YesNo;
                            EvaluationCriteriaTable.Description := EvaluationCriterialHeader.Description;
                            EvaluationCriteriaTable."User ID" := "Created By";
                            EvaluationCriteriaTable."Quote No" := "Quote No.";
                            EvaluationCriteriaTable."Bid No." := "No.";
                            EvaluationCriteriaTable."Bid Status" := Status;
                            //EvaluationCriteriaTable.Validate(EvaluationCriterialHeader."Bid Status");
                            EvaluationCriteriaTable.Insert(true);
                        until EvaluationCriterialHeader.Next = 0;
                    end;
                end;
            end;
        }
        field(6; "Requires Expert Remarks"; Boolean)
        {
        }
        field(7; Remarks; Text[250])
        {
        }
        field(8; "Expert Email"; Text[100])
        {
            Editable = false;
        }
        field(9; Expert; Code[50])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                if Expert = '' then
                    "Expert Email" := '';


                UserSetup.Reset;
                UserSetup.SetRange(UserSetup."User ID", Expert);
                if UserSetup.Find('-') then
                    "Expert Email" := UserSetup."E-Mail";
            end;
        }
        field(10; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(11; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(12; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(13; "Document Date"; Date)
        {
        }
        field(14; "Created By"; Code[50])
        {
        }
        field(15; "Awarded Quote"; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Quote),
                                                           //"Insurance Ref.No" = FIELD("RFQ No."),
                                                           Status = CONST(Open));

            trigger OnValidate()
            begin
                if "Awarded Quote" = '' then
                    "Vendor Name" := '' else
                    PurchHeader.Reset;
                PurchHeader.SetRange(PurchHeader."No.", "Awarded Quote");
                if PurchHeader.Find('-') then
                    "Vendor Name" := PurchHeader."Buy-from Vendor Name";
                // PurchHeader.CALCFIELDS(PurchHeader."Total Amount(LCY)");
                //"Awarded Quote Amount(LCY)":=PurchHeader."Total Amount(LCY)";
                Modify;
            end;
        }
        field(16; "Confirm Next Action"; Option)
        {
            OptionCaption = ' ,Forward to Supplies Officer';
            OptionMembers = " ","Forward to Supplies Officer";
        }
        field(17; "Supplies Officer"; Code[50])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                if "Supplies Officer" = '' then
                    "Supplies Officer E-Mail" := '';

                UserSetup.Reset;
                UserSetup.SetRange(UserSetup."User ID", "Supplies Officer");
                if UserSetup.Find('-') then
                    "Supplies Officer E-Mail" := UserSetup."E-Mail";
            end;
        }
        field(18; "Supplies Officer E-Mail"; Text[100])
        {
            Editable = false;
        }
        field(19; "Sent to Proc Officer"; Boolean)
        {
        }
        field(20; "Cost Center Name"; Text[100])
        {
        }
        field(21; "Vendor Name"; Text[100])
        {
            Editable = false;
        }
        field(22; "Re-Award Analysis"; Boolean)
        {
        }
        field(50005; "Payment Terms"; Code[20])
        {
            TableRelation = "Payment Terms".Code;
        }
        field(50006; "Delivery Time"; Duration)
        {
        }
        field(50007; "Approved PR"; Code[30])
        {

            trigger OnValidate()
            begin

                if "Approved PR" <> '' then begin
                    Analysis.Reset;
                    Analysis.SetRange(Analysis."Approved PR", "Approved PR");
                    if Analysis.FindFirst then begin
                        //IF "Re-Award Analysis" = FALSE THEN
                        Error(Text100, Analysis."Approved PR", Analysis."No.");
                    end;
                end;
            end;
        }
        field(50008; "Document Type"; Option)
        {
            OptionCaption = 'Quote Analysis Officer';
            OptionMembers = "Quote Analysis Officer";
        }
        field(50009; "Budget Line Name"; Text[100])
        {
        }
        field(50010; "Expert Remarks"; Text[250])
        {

            trigger OnValidate()
            begin
                if "Expert Remarks" <> ''
                  then
                    Remarks := "Expert Remarks";
                if Expert = '' then
                    "Expert Email" := '';
                Expert := UserId;
            end;
        }
        field(50011; "Awarded Quote Amount(LCY)"; Decimal)
        {
        }
        field(50012; "Sent to Finance"; Boolean)
        {
        }
        field(50013; "No. of Quotations Received"; Integer)
        {
        }
        field(50014; "Tender Chair"; Code[50])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                if "Tender Chair" = '' then
                    "Tender Chair E-Mail" := '';

                UserSetup.Reset;
                UserSetup.SetRange(UserSetup."User ID", "Tender Chair");
                if UserSetup.Find('-') then
                    "Tender Chair E-Mail" := UserSetup."E-Mail";
            end;
        }
        field(50015; "Tender Chair E-Mail"; Text[100])
        {
            Editable = false;
        }
        field(50016; "Sent to Tender Chair"; Boolean)
        {
        }
        field(50017; "Waiver Approved By"; Text[100])
        {
        }
        field(50018; "LPO No."; Code[50])
        {
            FieldClass = Normal;
        }
        field(50019; "Repeat Order"; Boolean)
        {
        }
        field(50020; "Cancelled By"; Text[50])
        {
        }
        field(50021; "Awarded Quote Status"; enum "Approval Status")
        {
            CalcFormula = Lookup("Purchase Header".Status WHERE("Document Type" = CONST(Quote),
                                                                 "No." = FIELD("Awarded Quote")));
            FieldClass = FlowField;
        }
        field(50022; "Awarded Quote Accountant"; Code[50])
        {
            FieldClass = Normal;
        }
        field(50023; "Repeat order Awardee"; Code[20])
        {
        }
        field(50024; "Repeat order RFQ No."; Code[20])
        {
            //TableRelation = "Purchase Quote Header"."No.";
        }
        field(50025; "Re-Awarded"; Boolean)
        {
        }
        field(39005610; "Shortcut Dimension 3 Code"; Code[30])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                // ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
            end;
        }
        field(39005611; "Shortcut Dimension 4 Code"; Code[30])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
            end;
        }
        field(39005612; "Shortcut Dimension 5 Code"; Code[30])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(5,"Shortcut Dimension 5 Code");
            end;
        }
        field(39005613; "Shortcut Dimension 6 Code"; Code[30])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          Blocked = CONST(false));
        }
        field(39005614; "Memo No."; Code[20])
        {
        }
        field(39005615; "Professional Opinion"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Professional Opinion"."No." WHERE(Status = CONST(Released));
        }
        field(39005616; "Proc Officer Incharge"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID" WHERE("Allow Send Email Proc Officer" = CONST(true));

            trigger OnValidate()
            begin
                if "Proc Officer Incharge" = '' then
                    "Proc Officer Email" := '';

                UserSetup.SetRange(UserSetup."User ID", "Proc Officer Incharge");
                if UserSetup.Find('-') then
                    "Proc Officer Email" := UserSetup."E-Mail";
            end;
        }
        field(39005617; "Proc Officer Email"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(39005618; "Quote No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Quote),
                                                           Status = CONST(Released));
            //"RFQ No" = FIELD("RFQ No."));

            trigger OnValidate()
            begin
                Vend.Reset;
                Vend.SetRange(Vend."No.", QuotationAnalysisLines."Vendor No.");
                if Vend.Find('-') then
                    QuotationAnalysisLines."Vendor Name" := Vend.Name;

                QuotationAnalysisLines.Reset;
                QuotationAnalysisLines.SetRange(QuotationAnalysisLines."Header No", "No.");
                if QuotationAnalysisLines.Find('-') then
                    QuotationAnalysisLines.DeleteAll;

                PurchHeader.Reset;
                PurchHeader.SetRange(PurchHeader."No.", "Quote No.");
                PurchHeader.SetRange(Status, PurchHeader.Status::Released);
                if PurchHeader.Find('-') then begin
                    repeat
                        PurchLines.Reset;
                        PurchLines.SetRange("Document No.", PurchHeader."No.");
                        if PurchLines.Find('-') then begin
                            repeat

                                QuotationAnalysisLines.Init;
                                QuotationAnalysisLines."RFQ No." := PurchHeader."RFQ No";
                                QuotationAnalysisLines."Header No" := "No.";
                                QuotationAnalysisLines."RFQ Line No." := PurchLines."Line No.";
                                QuotationAnalysisLines."Quote No." := PurchLines."Document No.";
                                QuotationAnalysisLines."Vendor No." := PurchHeader."Buy-from Vendor No.";
                                QuotationAnalysisLines.Validate("Vendor No.");
                                QuotationAnalysisLines."Item No." := PurchLines."No.";
                                //QuotationAnalysisLines.Description:=PurchLines."Description 2";
                                QuotationAnalysisLines.Quantity := PurchLines.Quantity;
                                QuotationAnalysisLines."Currency Code" := PurchLines."Currency Code";
                                QuotationAnalysisLines."Unit Of Measure" := PurchLines."Unit of Measure";
                                QuotationAnalysisLines.Amount := PurchLines."Direct Unit Cost";
                                QuotationAnalysisLines.Description := PurchLines.Description;
                                QuotationAnalysisLines."Description 2" := PurchLines."Description 2";
                                QuotationAnalysisLines."Line Amount" := QuotationAnalysisLines.Quantity * QuotationAnalysisLines.Amount;
                                //QuotationAnalysisLines."Supplier No" := PurchHeader."Supplier No";
                                //QuotationAnalysisLines."Supplier Name" := PurchHeader."Supplier Name";
                                QuotationAnalysisLines.Insert(true);
                            until PurchLines.Next = 0;
                        end;
                    until PurchHeader.Next = 0;
                end;


                Message('Lines generated successfully');
            end;
        }
        field(39005619; "Add Reccomendation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39005620; Reccomendation; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(39005621; "Evaluation Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Open,Ongoing,Completed';
            OptionMembers = " ",Open,Ongoing,Completed;
        }
        field(39005622; "Technical  Pass Score"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "RFQ No.")
        {
        }
        key(Key2; "RFQ No.")
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
            NoSetup.TestField(NoSetup."Bid Analysis Nos");
            NoSeriesMgt.InitSeries(NoSetup."Bid Analysis Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;


        "Document Date" := Today;
        "Created By" := UserId;
    end;

    var
        NoSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HrEmp: Record "HR Employees";
        UserSetup: Record "User Setup";
        PurchQuote: Record "Purchase Header";
        PurchHeader: Record "Purchase Header";
        RecordLinkManagement: Codeunit "Record Link Management";
        Analysis: Record "Quotation Analysis Header";
        Text100: Label 'The Approved PR No. %1 you are trying to attach has already been picked in another Bid Analysis No %2.';
        PurchaseQuoteHeader: Record "Purchase Quote Header";
        RecommendEditable: Boolean;
        PurchLines: Record "Purchase Line";
        QuotationAnalysisLines: Record "Quotation Analysis Lines";
        Vend: Record Vendor;
        EvaluationCriteriaTable: Record "Evaluation Criteria Table";
        EvaluationCriterialHeader: Record "Evaluation Criterial Header";
}

