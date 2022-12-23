page 51533499 "Quotation Analysis Page"
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval,New Document,Navigate,Incoming Documents';
    SourceTable = "Quotation Analysis Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    Lookup = true;
                    //LookupPageID = "RFQ List - Released";

                    trigger OnValidate()
                    var
                        PurchQuote: Record "Purchase Header";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        PurchQuote.Reset;
                        PurchQuote.SetRange(PurchQuote."No.", Rec."RFQ No.");
                        //IF "RFQ No."<> xRec."RFQ No." THEN BEGIN
                        if PurchQuote.Find('-') then begin
                            Rec."Responsibility Center" := PurchQuote."Responsibility Center";
                            //"Cost Center Name":=PurchQuote.CostcentreName;
                            //"Shortcut Dimension 1 Code":=PurchQuote."Shortcut Dimension 1 Code";
                            //Rec."Approved PR" := PurchQuote."Request for Quote No.";//"Approved PR No.";
                            Rec.Validate("Approved PR");
                        end;
                    end;
                }
                field("Quote No."; Rec."Quote No.")
                {
                }
                field(Description; Rec.Description)
                {
                    Visible = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    Visible = true;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field("Requires Expert Remarks"; Rec."Requires Expert Remarks")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Expert; Rec.Expert)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Expert Email"; Rec."Expert Email")
                {
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                }
                field("Confirm Next Action"; Rec."Confirm Next Action")
                {
                    Visible = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Visible = false;
                }
                field("Created By"; Rec."Created By")
                {
                    Caption = 'USER ID';
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                }
                field("Add Reccomendation"; Rec."Add Reccomendation")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if Rec."Add Reccomendation" = true then
                            RecommendEditable := true
                        else
                            RecommendEditable := false;
                    end;
                }
                field(Reccomendation; Rec.Reccomendation)
                {
                    Editable = RecommendEditable;
                    Visible = false;
                }
                field("Evaluation Status"; Rec."Evaluation Status")
                {
                }
                field("No. of Quotations Received"; Rec."No. of Quotations Received")
                {
                    Editable = false;
                }
                field("Technical  Pass Score"; Rec."Technical  Pass Score")
                {
                }
            }
            /**
            part(Control5; "Quotation Analysis Subform")
            {
                Editable = true;
                SubPageLink = "Header No" = FIELD("No.");
            }
            part("Evaluation Criteria List"; "Evaluation Criteria List")
            {
                SubPageLink = "RFQ No." = FIELD("RFQ No.");
                Visible = false;
            } **/
        }
    }

    actions
    {
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                    //ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Approval Comments";
                    Visible = OpenApprovalEntriesExistForCurrUser;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("Submit for Workflow")
                {
                    Caption = 'Submit for Workflow';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if Rec."Requires Expert Remarks" then begin
                            Rec.TestField(Expert);
                            Rec.TestField(Remarks);
                        end;

                        VarVariant := Rec;
                        //if ApprovalsMGT.CheckApprovalsWorkflowEnabled(VarVariant) then
                        //    ApprovalsMGT.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        VarVariant := Rec;
                        //ApprovalsMGT.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
                action(ApprovalsN)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        approvalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
                action("Send Approval")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                        //Commitments: Record Committments;
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        Rec.TestField("Evaluation Status", Rec."Evaluation Status"::Completed);
                        VarVariant := Rec;
                        //if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        //    CustomApprovals.OnSendDocForApproval(VarVariant);
                        //

                        // IF ApprovalsMgmt.CheckProfOpApprovalPossible(Rec) THEN
                        //  ApprovalsMgmt.OnSendProfOpDocForApproval(Rec);
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        VarVariant := Rec;
                        //CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                        //ApprovalMgt.OnCancelProfOpApprovalRequest(Rec);
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        /*
                        DocumentType := DocumentType::"Payment Voucher";
                        ApprovalEntries.Setfilters(DATABASE::"Payments Header","Document Type","No.");
                        ApprovalEntries.RUN;
                        */
                        ApprovalsMgmt.OpenApprovalEntriesPage(rec.RecordId);

                    end;
                }
            }
            group(ActionGroup19)
            {
            }
            action("Get Vendor Quotations")
            {
                Caption = 'Get Vendor Quotations';
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    Rec.TestField("RFQ No.");
                    //InsertBidAnalysisLines;
                end;
            }
            action("Quotation Analysis Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                Visible = true;

                trigger OnAction()
                begin
                    QuoteHead.Reset;
                    QuoteHead.SetRange(QuoteHead."No.", rec."No.");
                    if QuoteHead.Find('-') then
                        REPORT.Run(51533301, true, false, QuoteHead);
                end;
            }
            action("Quotation Analysis Report Updated")
            {
                Caption = 'Quotation Analysis Report Updated';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                Visible = true;

                trigger OnAction()
                begin
                    QuoteHead.Reset;
                    QuoteHead.SetRange(QuoteHead."No.", Rec."No.");
                    if QuoteHead.Find('-') then
                        REPORT.Run(51533703, true, false, QuoteHead);
                end;
            }
            action("Quotation Analysis")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                Visible = false;

                trigger OnAction()
                begin
                    QuoteHead.Reset;
                    QuoteHead.SetRange(QuoteHead."No.", Rec."No.");
                    if QuoteHead.Find('-') then
                        REPORT.Run(51533302, true, false, QuoteHead);
                end;
            }
            action("Mark as Reward Analysis")
            {
                Caption = 'Mark as Reward Analysis';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    if Confirm(Text003, true) then begin
                        Rec."Re-Award Analysis" := true;
                        Rec.Modify;
                    end;
                end;
            }
            action("Send to PR Officer")
            {
                Caption = 'Send to PR Officer';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TestField("RFQ No.");
                    Rec.TestField("Supplies Officer");
                    //CALCFIELDS("No. of Quotations Received");


                    //IF "No. of Quotations Received" < 3 THEN
                    // THEN Rec.Rec.TestField("Sent to Tender Chair", TRUE);
                    //ERROR('No. of quotations received are less than minimum three');
                    Clear(Text006);
                    Text006 := Rec."Supplies Officer E-Mail";
                    Text007Mails.Add(Text006);
                    if Confirm(Text002, true) then begin

                        smail.CreateMessage('ERPINFO', '', Text007Mails, 'Bid Analysis for Award Notification', 'You have a BID Analysis Document Notification no, ' + Rec."No.", true);
                        smail.Send();
                        Message('Email sent to PR Officer');

                        Rec."Sent to Proc Officer" := true;
                        Rec.Modify;
                    end;
                end;
            }
            action("Send to Tender Chair")
            {
                Caption = 'Send to Tender Chair For Waiver';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField("RFQ No.");
                    Rec.TestField("Tender Chair");
                    Rec.TestField("Supplies Officer");

                    SmtpSetup.Get;
                    //CALCFIELDS("No. of Quotations Received");

                    //IF "No. of Quotations Received" > 3 THEN
                    //ERROR('No. of quotations received are more than the minimum three');


                    //compa.GET(USERID);

                    //   UserEmail:=UserSetup."E-Mail";

                    if Confirm(Text001, true) then begin

                        /*smail.CreateMessage('ERPINFO',SmtpSetup."User ID","Tender Chair E-Mail",'Waiver Notification','You have a BID Analysis Document for waiver Notification no, '+"No.",TRUE);
                        smail.Send();*/
                        Message('Email sent to Tender Chair');

                        Rec."Sent to Tender Chair" := true;
                        Rec.Modify;

                    end;

                end;
            }
            action("Cancel Bid Analysis/RFQ")
            {
                Caption = 'Cancel Bid Analysis/RFQ';
                Image = cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField(Remarks);
                    if Confirm('Are you sure you want to Cancel the analysis/RFQ? It will not be available for LPO award', false) = true then begin

                        Rec.Status := Rec.Status::Canceled;
                        Rec."Cancelled By" := UserId;
                        Rec.Modify;

                    end;
                end;
            }
            action("Make Order")
            {
                Caption = 'Make &Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CODEUNIT.Run(CODEUNIT::"Purch.-Quote to Order (Yes/No)", Rec);
                end;
            }
            action("Quotation Analysis Members")
            {
                Caption = 'Quotation Analysis Members';
                Image = Form;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Quotation Analysis Members";
                //RunPageLink = Code = FIELD("No.");

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                end;
            }
            action("Send Email to Bidders")
            {
                Caption = 'Send Email to Bidders';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField("RFQ No.");
                    Rec.TestField("Supplies Officer");
                    //CALCFIELDS("No. of Quotations Received");


                    if Confirm(Text004, true) then begin
                        QuotationAnalysisLines.Reset;
                        QuotationAnalysisLines.SetRange("Header No", Rec."No.");
                        QuotationAnalysisLines.SetRange(Responsive, true);
                        if QuotationAnalysisLines.FindFirst then begin
                            repeat
                                Vend.Reset;
                                Vend.SetRange("No.", QuotationAnalysisLines."Vendor No.");
                                Text007Mails.Add(Text006);
                                if Vend.FindFirst then begin
                                    Clear(Text006);
                                    Text006 := Vend."E-Mail";
                                    Text007Mails.Add(Text006);
                                    smail.CreateMessage('ERPINFO', '', Text007Mails, 'Bid Analysis Response Notification', 'Your bid has been responsive, ' + Rec."No." + ' ' + QuotationAnalysisLines."Professional Opinion", true);
                                    smail.Send();
                                    Message('Email sent to Vendors');
                                end;
                            until QuotationAnalysisLines.Next = 0;
                        end;
                        QuotationAnalysisLines.Reset;
                        QuotationAnalysisLines.SetRange("Header No", Rec."No.");
                        QuotationAnalysisLines.SetRange(Responsive, false);
                        if QuotationAnalysisLines.FindFirst then begin
                            repeat
                                Vend.Reset;
                                Vend.SetRange("No.", QuotationAnalysisLines."Vendor No.");
                                if Vend.FindFirst then begin
                                    Clear(Text006);
                                    Text006 := Vend."E-Mail";
                                    Text007Mails.Add(Text006);
                                    smail.CreateMessage('ERPINFO', '', Text007Mails, 'Bid Analysis Response Notification', 'Your bid was not responsive, ' + Rec."No." + ' ' + QuotationAnalysisLines."Professional Opinion", true);
                                    smail.Send();
                                    Message('Email sent to Vendors');
                                end;
                            until QuotationAnalysisLines.Next = 0;
                        end;
                    end;
                end;
            }
            action("Send Email to Proc Officer")
            {
                Caption = 'Send Email to Procurement Officer';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField("RFQ No.");
                    Rec.TestField("Supplies Officer");


                    //CALCFIELDS("No. of Quotations Received");


                    if Confirm(Text005, true) then begin
                        QuotationAnalysisLines.Reset;
                        QuotationAnalysisLines.SetRange("Header No", Rec."No.");
                        QuotationAnalysisLines.SetRange(Responsive, true);
                        if QuotationAnalysisLines.FindFirst then begin
                            CI.Get();
                            Clear(Text006);
                            Text006 := Rec."Proc Officer Email";
                            Text007Mails.Add(Text006);

                            smail.CreateMessage('Professional Opinion ', CI."E-Mail", Text007Mails, 'Start of Professional Opinion Process',
                            'You can proceed to professional opinion process the bid has been responsive,' + Rec."No." + ' ' + QuotationAnalysisLines."Professional Opinion", true);
                            smail.Send();
                            Message('Email sent to Procurement Officer');
                        end;
                        //UNTIL QuotationAnalysisLines.NEXT=0;
                    end;

                    //END;
                end;
            }
            action("Evaluation Criteria List")
            {
                Image = AdjustVATExemption;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                //RunObject = Page "Evaluation Criteria List Page";
                //RunPageLink = "Bid No." = FIELD("No.");
            }
            action("Quotation Attachment")
            {
                Image = Link;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                //RunObject = Page "Record link";
                //RunPageLink = "Document No" = FIELD("Quote No.");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if UserSetup.Get(UserId) then begin
            Rec."Responsibility Center" := UserSetup."Responsibility Center";
            Rec."Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            Rec."Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        //ApprovalsMGT: Codeunit "Custom Approvals Codeunit2";
        PurchHeader: Record "Purchase Header";
        PurchLines: Record "Purchase Line";
        InsertCount: Integer;
        QuoteHead: Record "Quotation Analysis Header";
        smail: Codeunit "SMTP Mail";
        Vend: Record Vendor;
        Text001: Label 'Are you sure you want to send Quotation Analysis to Tender Chair for Waiver Approval?';
        Text002: Label 'Are you sure you want to send Quotation Analysis to PR Officer for award?';
        QuotationAnalysisLines: Record "Quotation Analysis Lines";
        USER: Record "User Setup";
        companyInfo: Record "Company Information";
        Text003: Label 'Are you sure you want to mark this analysis as Reward? This will allow addition of the an earlier RFQ.';
        SmtpSetup: Record "SMTP Mail Setup";
        Text004: Label 'Are you sure you want to send notification to Vendors?';
        Text005: Label 'Are you sure you want to send notification to Procurement Officer?';
        HREmp: Record "HR Employees";
        USetUp: Record "User Setup";
        CI: Record "Company Information";
        //CustomApprovals: Codeunit "Custom Approval Management";
        UserSetup: Record "User Setup";
        RecommendEditable: Boolean;
        EvaluationCriteriaTable: Record "Evaluation Criteria Table";
        EvaluationCriterialHeader: Record "Evaluation Criterial Header";
        Text006: Text[50];
        Text007Mails: List of [Text];

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    procedure InsertBidAnalysisLines()
    var
        BidAnalysisLines: Record "Quotation Analysis Lines";
    begin
        // Vend.RESET;
        // Vend.SETRANGE( Vend."No.",BidAnalysisLines."Vendor No.");
        // IF Vend.FIND('-') THEN
        // BidAnalysisLines."Vendor Name":=Vend.Name;
        //
        // BidAnalysisLines.RESET;
        // BidAnalysisLines.SETRANGE(BidAnalysisLines."Header No","No.");
        // IF BidAnalysisLines.FIND('-') THEN
        // BidAnalysisLines.DELETEALL;
        //
        // PurchHeader.RESET;
        // PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","RFQ No.");
        // PurchHeader.SETRANGE("Document Type",PurchHeader."Document Type"::Quote);
        // "No. of Quotations Received":=PurchHeader.COUNT;
        // IF PurchHeader.FIND('-') THEN BEGIN
        // REPEAT
        //  PurchLines.RESET;
        //  PurchLines.SETRANGE("Document No.",PurchHeader."No.");
        //  IF PurchLines.FIND('-') THEN BEGIN
        //      REPEAT
        //    BidAnalysisLines.INIT;
        //    BidAnalysisLines."RFQ No.":=PurchHeader."Request for Quote No.";
        //    BidAnalysisLines."Header No":="No.";
        //    BidAnalysisLines."RFQ Line No.":=PurchLines."Line No.";
        //    BidAnalysisLines."Quote No.":=PurchLines."Document No.";
        //    BidAnalysisLines."Vendor No.":=PurchHeader."Buy-from Vendor No.";
        //    BidAnalysisLines."Item No.":=PurchLines."No.";
        //   // BidAnalysisLines.Description:=PurchLines.Description;
        //    BidAnalysisLines.Description:=PurchLines."Description 2";
        //    BidAnalysisLines.Quantity:=PurchLines.Quantity;
        //    BidAnalysisLines."Currency Code":=PurchLines."Currency Code";
        //    BidAnalysisLines."Unit Of Measure":=PurchLines."Unit of Measure";
        //    BidAnalysisLines.Amount:=PurchLines."Direct Unit Cost";
        //    BidAnalysisLines."Line Amount":=BidAnalysisLines.Quantity*BidAnalysisLines.Amount;
        //    BidAnalysisLines.INSERT(TRUE);
        //   UNTIL PurchLines.NEXT=0;
        //   END;
        // UNTIL PurchHeader.NEXT=0;
        // END;
        //
        //
        // MESSAGE('Lines generated successfully');
        Vend.Reset;
        Vend.SetRange(Vend."No.", BidAnalysisLines."Vendor No.");
        if Vend.Find('-') then
            BidAnalysisLines."Vendor Name" := Vend.Name;

        BidAnalysisLines.Reset;
        BidAnalysisLines.SetRange(BidAnalysisLines."Header No", Rec."No.");
        if BidAnalysisLines.Find('-') then
            BidAnalysisLines.DeleteAll;

        PurchHeader.Reset;
        PurchHeader.SetRange(PurchHeader."RFQ No", Rec."RFQ No.");
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Quote);
        PurchHeader.SetRange(Status, PurchHeader.Status::Released);
        if PurchHeader.Find('-') then begin
            repeat
                PurchLines.Reset;
                PurchLines.SetRange("Document No.", PurchHeader."No.");
                if PurchLines.Find('-') then begin
                    repeat
                        BidAnalysisLines.Init;
                        BidAnalysisLines."RFQ No." := PurchHeader."RFQ No";
                        BidAnalysisLines."Header No" := Rec."No.";
                        BidAnalysisLines."RFQ Line No." := PurchLines."Line No.";
                        BidAnalysisLines."Quote No." := PurchLines."Document No.";
                        BidAnalysisLines."Vendor No." := PurchHeader."Buy-from Vendor No.";
                        BidAnalysisLines.Validate("Vendor No.");
                        BidAnalysisLines."Item No." := PurchLines."No.";
                        //BidAnalysisLines.Description:=PurchLines."Description 2";
                        BidAnalysisLines.Quantity := PurchLines.Quantity;
                        BidAnalysisLines."Currency Code" := PurchLines."Currency Code";
                        BidAnalysisLines."Unit Of Measure" := PurchLines."Unit of Measure";
                        BidAnalysisLines.Amount := PurchLines."Direct Unit Cost";
                        BidAnalysisLines.Description := PurchLines.Description;
                        BidAnalysisLines."Description 2" := PurchLines."Description 2";
                        BidAnalysisLines."Line Amount" := BidAnalysisLines.Quantity * BidAnalysisLines.Amount;
                        BidAnalysisLines.Insert(true);
                    until PurchLines.Next = 0;
                end;
            until PurchHeader.Next = 0;
        end;


        Message('Lines generated successfully');
    end;
}

