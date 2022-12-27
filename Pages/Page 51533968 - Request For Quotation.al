page 51533907 "Request For Quotation"
{
    DeleteAllowed = false;
    PageType = Document;
    SourceTable = "Purchase Quote Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = pageeditable;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    Editable = pageeditable;
                }
                field("Expected Opening Date"; Rec."Expected Opening Date")
                {

                    trigger OnValidate()
                    begin
                        if Rec.Status = Rec.Status::Released then begin
                            if UserSetup.Get(UserId) then begin
                                //if UserSetup."Modify RFQ Dates" = false then
                                Error('You do not have permission to modify Expected Opening Date %1 ', Rec."Expected Opening Date");
                            end;
                            OpeningCommittee.Reset;
                            OpeningCommittee.SetRange(OpeningCommittee."RFQ No.", Rec."No.");
                            if OpeningCommittee.Find('-') then begin
                                OpeningCommittee.Date := Rec."Expected Opening Date";
                                OpeningCommittee.Modify;
                            end;
                        end;
                    end;
                }
                field("Expected Closing Date"; Rec."Expected Closing Date")
                {

                    trigger OnValidate()
                    begin
                        if Rec.Status = Rec.Status::Released then begin
                            if UserSetup.Get(UserId) then begin
                                //if UserSetup."Modify RFQ Dates" = false then
                                Error('You do not have permission to modify Expected Closing Date%1 ', Rec."Expected Closing Date");
                            end;
                        end;
                    end;
                }
                field("Reason for extending"; Rec."Reason for extending")
                {
                    Editable = true;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = pageeditable;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Scheme Applied"; Rec."Scheme Applied")
                {
                    Caption = 'Procurement Category';
                    Editable = pageeditable;
                }
                field("Tender Type"; Rec."Tender Type")
                {
                }
                field(Control8; Rec.Status)
                {
                    Editable = pageeditable;
                    ShowCaption = false;
                }
                field("Purchase Requisition No."; Rec."PRF No")
                {
                    Caption = 'Purchase Requisition No.';
                    Editable = true;
                    Visible = true;
                }
                field("Evaluation Committee No."; Rec."Evaluation Committee No.")
                {
                    Editable = pageeditable;
                }
                field("Opening Committee No."; Rec."Opening Committee No.")
                {
                    Editable = pageeditable;
                }
                field("Vendor Category Code"; Rec."Vendor Category Code")
                {
                    Editable = pageeditable;
                }
                field("Vendor Category Description"; Rec."Vendor Category Description")
                {
                    Editable = pageeditable;
                }
                field("Procurement Methods"; Rec."Procurement Methods")
                {
                    Editable = false;
                    // TableRelation = "General Ledger Setup"."RFQ Proc Methods" WHERE("RFQ Proc Methods" = FIELD("Procurement Methods"));
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = pageeditable;
                    Visible = false;
                }
                field(RecID; Format(Rec.RecordId))
                {
                    Visible = false;
                }
                field("Quotation date"; Rec."Quotation date")
                {
                    Editable = pageeditable;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    Caption = 'User ID';
                    Editable = pageeditable;
                    Enabled = false;
                }
                field("Technical Pass Score"; Rec."Technical Pass Score")
                {
                    Enabled = UneditablewhenApproved;
                }
            }
            group("Evaluation Commmitee Remarks")
            {
                Caption = 'Evaluation Commmitee Remarks';
                Visible = false;
                field("Evaluation Comm Remarks"; Rec."Evaluation Comm Remarks")
                {
                    MultiLine = true;
                    Visible = false;
                }
            }
            group("ED Remarks")
            {
                Caption = 'ED Remarks';
                Visible = false;
                field(Control23; Rec."ED Remarks")
                {
                    MultiLine = true;
                    ShowCaption = false;
                    Visible = false;
                }
            }
            group("SCM Remarks")
            {
                Caption = 'SCM Remarks';
                Visible = false;
                field(Control25; Rec."SCM Remarks")
                {
                    MultiLine = true;
                    ShowCaption = false;
                    Visible = false;
                }
            }
            /**
            part(Control1102755015; "RFQ Subform")
            {
                Editable = pageeditable;
                //SubPageLink = "Document No." = FIELD("No.");
            } **/
            part(Control48; "Evaluation Criteria List")
            {
                SubPageLink = "RFQ No." = FIELD("No.");
                UpdatePropagation = SubPart;
            }
        }
        area(factboxes)
        {
            /**part(AttachedDocsFactBox; "Attached Docs Factbox")
            {
                Caption = 'Attached Documents';
            } **/
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1102755017)
            {
                action("Get Document Lines")
                {
                    Caption = 'Get Document Lines';
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CurrPage.Update(true);
                        InsertRFQLines;
                    end;
                }
                action("Assign Vendor(s)")
                {
                    Caption = 'Assign Vendor(s)';
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                    //Vends: Record "Quotation Request Vendors";
                    begin
                        /*
                        Vends.RESET;
                        Vends.SETRANGE(Vends."Document Type","Document Type");
                        Vends.SETRANGE(Vends."Requisition Document No.","No.");
                        PAGE.RUN(PAGE::"Quotation Request Vendors",Vends);
                         

                        Vends.Reset;
                        Vends.SetRange(Vends."Document Type", "Document Type");
                        //Vends.SETRANGE(Vends."Vendor Category Code","Vendor Category Code");
                        Vends.SetRange(Vends."Requisition Document No.", "No.");
                        //Vends.SETRANGE(Vends."PR Requisition No","Internal Requisition No.");
                        //Vends.SETRANGE(Vends."PRF No","PRF No");
                        //Vends.SETRANGE(Vends."Vendor Category Code","Vendor Category Code");
                        //Vends.SETRANGE(Vends."Vendor Class","Vendor Class");
                        //Vends.SETRANGE(Vends."Scheme Applied","Scheme Applied");
                        Vends.SetRange(Vends."Vendor Category Code", "Vendor Category Code");
                        PAGE.Run(PAGE::"Quotation Request Vendors", Vends);
                        */

                    end;
                }
                action("Create Quotes")
                {
                    Caption = 'Create Vendor Quotes';
                    Image = VendorPayment;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    var
                        RFQLines: Record "Purchase Quote Line";
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLines: Record "Purchase Line";
                        Vends: Record "Quotation Request Vendors";
                    begin
                        Vends.SetRange(Vends."Requisition Document No.", Rec."No.");
                        if Vends.FindSet then
                            repeat
                                //create header
                                PurchaseHeader.Init;
                                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Quote;
                                //PurchaseHeader.DocApprovalType := PurchaseHeader.DocApprovalType::Quote;
                                PurchaseHeader."No." := '';
                                PurchaseHeader."Responsibility Center" := Rec."Responsibility Center";
                                PurchaseHeader."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                PurchaseHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                PurchaseHeader.Insert(true);
                                PurchaseHeader.Validate("Buy-from Vendor No.", Vends."Vendor No.");
                                PurchaseHeader."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                PurchaseHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                //  PurchaseHeader.validate("RFQ No.","No.");
                                PurchaseHeader.Modify;
                                PurchaseHeader.Insert(true);

                                //create lines

                                RFQLines.SetRange(RFQLines."Document No.", Rec."No.");
                                if RFQLines.FindSet then
                                    repeat
                                        PurchaseLines.Init;
                                        PurchaseLines.TransferFields(RFQLines);
                                        PurchaseLines."Document Type" := PurchaseLines."Document Type"::Quote;
                                        PurchaseLines."Document No." := Rec."No.";
                                        PurchaseLines.Insert;
                                    /*
                                      ReqLines.VALIDATE(ReqLines."No.");
                                      ReqLines.VALIDATE(ReqLines.Quantity);
                                      ReqLines.VALIDATE(ReqLines."Direct Unit Cost");
                                      ReqLines.MODIFY;
                                    */
                                    until RFQLines.Next = 0;
                            until Vends.Next = 0;

                    end;
                }
                action("Bid Analysis")
                {
                    Caption = 'Bid Analysis';
                    Image = Worksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    //RunObject = Page "Bid Analysis Worksheet";
                    //RunPageLink = "RFQ No." = FIELD("No.");
                    Visible = false;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLines: Record "Purchase Line";
                        ItemNoFilter: Text[250];
                        RFQNoFilter: Text[250];
                        InsertCount: Integer;
                        BidAnalysis: Record "Bid Analysis";
                    begin
                        //deletebidanalysis for this vendor
                        BidAnalysis.SetRange(BidAnalysis."RFQ No.", Rec."No.");
                        BidAnalysis.DeleteAll;


                        //insert the quotes from vendors

                        PurchaseHeader.SetRange(PurchaseHeader."No.", Rec."No.");
                        PurchaseHeader.FindSet;
                        repeat
                            PurchaseLines.Reset;
                            PurchaseLines.SetRange("Document No.", PurchaseHeader."No.");
                            if PurchaseLines.FindSet then
                                repeat
                                    BidAnalysis.Init;
                                    BidAnalysis."RFQ No." := Rec."No.";
                                    BidAnalysis."RFQ Line No." := PurchaseLines."Line No.";
                                    BidAnalysis."Quote No." := PurchaseLines."Document No.";
                                    BidAnalysis."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                                    BidAnalysis."Item No." := PurchaseLines."No.";
                                    BidAnalysis.Description := PurchaseLines.Description;
                                    BidAnalysis.Quantity := PurchaseLines.Quantity;
                                    BidAnalysis."Unit Of Measure" := PurchaseLines."Unit of Measure";
                                    BidAnalysis.Amount := PurchaseLines."Direct Unit Cost";
                                    BidAnalysis."Line Amount" := BidAnalysis.Quantity * BidAnalysis.Amount;
                                    BidAnalysis.Insert(true);
                                    InsertCount += 1;
                                until PurchaseLines.Next = 0;
                        until PurchaseHeader.Next = 0;
                        //MESSAGE('%1 records have been inserted to the bid analysis',InsertCount);
                    end;
                }
                action("Popuate Evaluation Documents")
                {
                    Image = Populate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin

                        ECH.Reset;
                        ECH.SetRange(ECH."RFQ No.", Rec."No.");
                        if ECH.Find('-') then begin
                            ECH.DeleteAll;
                            Message('Lines Successfully Deleted, Ready to update changes');
                        end
                        else begin
                            Message('There are no lines to delete');
                        end;


                        DocSetUp.Reset;
                        DocSetUp.SetRange(DocSetUp."Tender No", Rec."No.");
                        if DocSetUp.Find('-') then begin
                            repeat
                                ECH.Init;
                                ECH.Code := DocSetUp.Code;
                                ECH.Description := DocSetUp.Description;
                                ECH."RFQ No." := DocSetUp."Tender No";
                                ECH."Procurement Method" := DocSetUp."Procurement Method Code";
                                ECH."Evaluation Category" := DocSetUp.Category;
                                ECH.Insert(true);
                            until DocSetUp.Next = 0;
                            Message('Lines Successfully Updated');
                        end;
                    end;
                }
            }
            group(Status)
            {
                Caption = 'Status';
                action(Cancel)
                {
                    Caption = 'Cancel';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin

                        //check if the quotation for request number has already been used
                        /*
                        PurchHeader.RESET;
                        PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                        PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                        IF PurchHeader.FINDFIRST THEN
                          BEGIN
                            ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                          END;
                        */
                        if Confirm('Cancel Document?', false) = false then begin exit end;
                        Rec.Status := Rec.Status::Cancelled;
                        Rec.Modify;

                    end;
                }
                action(SendCustom)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send';
                    Ellipsis = true;
                    Image = SendToMultiple;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';
                    Visible = false;

                    trigger OnAction()
                    var
                        SalesInvHeader: Record "Purchase Quote Header";
                    begin
                        SalesInvHeader := Rec;
                        CurrPage.SetSelectionFilter(SalesInvHeader);
                        SalesInvHeader.SendRecords
                    end;
                }
                action("Send Addendum")
                {
                    Image = Form;
                    Promoted = true;
                    PromotedCategory = Process;
                    //RunObject = Page "Created ETender Suppliers Card";
                    //RunPageLink = No = FIELD("No.");
                    Visible = false;
                }
                action(Stop)
                {
                    Caption = 'Stop';
                    Image = Stop;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin

                        //check if the quotation for request number has already been used
                        /*
                        PurchHeader.RESET;
                        PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                        PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                        IF PurchHeader.FINDFIRST THEN
                          BEGIN
                            ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                          END;
                        */
                        if Confirm('Close Document?', false) = false then begin exit end;
                        Rec.Status := Rec.Status::Closed;
                        Rec.Modify;

                    end;
                }
                action(Close)
                {
                    Caption = 'Close';
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin

                        //check if the quotation for request number has already been used
                        /*
                        PurchHeader.RESET;
                        PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                        PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                        IF PurchHeader.FINDFIRST THEN
                          BEGIN
                            ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                          END;
                        */
                        if Confirm('Close Document?', false) = false then begin exit end;
                        Rec.Status := Rec.Status::Closed;
                        Rec.Modify;

                    end;
                }
                action(Release)
                {
                    Caption = 'Release';
                    Enabled = false;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CheckVendors;

                        if Confirm('Release document?', false) = false then begin exit end;
                        //check if the document has any lines
                        Lines.Reset;
                        Lines.SetRange(Lines."Document Type", Rec."Document Type");
                        Lines.SetRange(Lines."Document No.", Rec."No.");
                        if Lines.FindFirst then begin
                            repeat
                                Lines.TestField(Lines.Quantity);
                                //Lines.TESTFIELD(Lines."Direct Unit Cost");

                                Lines.TestField("No.");
                            until Lines.Next = 0;
                        end
                        else begin
                            Error('Document has no lines');
                        end;
                        Rec.Status := Rec.Status::Released;
                        Rec."Released By" := UserId;
                        Rec."Release Date" := Today;
                        Rec.Modify;
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Reopen';
                    Enabled = false;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin

                        //check if the quotation for request number has already been used
                        PurchHeader.Reset;
                        PurchHeader.SetRange(PurchHeader."Document Type", PurchHeader."Document Type"::Quote);
                        //PurchHeader.SETRANGE(purchheader."request for quote no","No.");
                        if PurchHeader.FindFirst then begin
                            Error('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                        end;

                        if Confirm('Reopen Document?', false) = false then begin exit end;
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify;
                    end;
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Rec.SetRange("No.", Rec."No.");
                        //Rec.REPORT.Run(REPORT::"RFQ Report", true, false, Rec);
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = true;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imp,Requisition,ImpSurr,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,GrSu,EmpReq,LeaveApp,"Training Requisition",TransportReq,JV,"Grant Task","Concept Note",Disposal,"Job Approval","Disciplinary Approvals",GRN,Clearence,Donation,Transfer,PayChange,Budget,GL,"Cash Purchase","Leave Reimburse",Appraisal,Inspection,Closeout,"Lab Request",Proposal,LeaveCO,"IB Transfer",EmpTransfer,LeavePlanner,HrAssetTransfer,Contract,Project,MR,Inves,PB,Prom,Ind,Conf,BSC,OT,Jobsucc,SuccDetails,Qualified,Disc,Vote,Clearance,TNeed,B2Off,TBill,RFQ;
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType := DocumentType::RFQ;
                        ApprovalEntries.Setfilters(DATABASE::"Purchase Quote Header", DocumentType, Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        QRV.Reset;
                        QRV.SetRange(QRV."Requisition Document No.", Rec."No.");
                        if not QRV.Find('-') then
                            Error('No Vendors have been assigned');
                        Rec.TestField("Posting Description");
                        Rec.TestField("Vendor Category Code");
                        Rec.TestField("Expected Opening Date");
                        Rec.TestField("Expected Closing Date");
                        ECH.Reset;
                        ECH.SetRange("RFQ No.", Rec."No.");
                        if ECH.Find('-') then begin
                            ECH.TestField(Code);
                            ECH.TestField(Description);
                            ECH.TestField("Actual Weight Assigned");
                        end;

                        VarVariant := Rec;
                        //if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        //    CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        VarVariant := Rec;
                        //CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
                group("Assigning Documents")
                {
                    Caption = 'Assigning Documents';
                }
                action("Requisition Email")
                {
                    Caption = 'Requisition Email';
                    Image = Note;
                    Promoted = true;
                    PromotedCategory = Category4;
                    //RunObject = Page "Requisition Email";
                    //RunPageLink = Code = FIELD("No.");
                    Visible = false;
                }
                action("Attach Documents")
                {
                    Image = Attach;
                    Promoted = true;
                    Visible = false;

                    trigger OnAction()
                    begin

                        /*DMSint.Reset;
                        DMSint.SetRange(DMSint."DMS Link Type", DMSint."DMS Link Type"::DMSAttach);
                        if DMSint.Find('-') then begin

                            //HYPERLINK('http://192.168.254.60:81/Navition/AttachDocument.aspx?DT_ID=96&dt_code=DT_1_1464075594713&dtgcode=DTT_1_1464075717112&savetype=UPLOADONLY&spu_id=' +"No."+
                            HyperLink(DMSint."DMS Link Path" + '&dt_code=DT_1_1464075594713&dtgcode=DTT_1_1464075717112&savetype=UPLOADONLY&spu_id=' + Rec."No." +

                            '&txtRQD_QUOT_NO=' + Rec."No." + '&txtRQD_FIN_YEAR=' + Rec."Financial Year" + '&txtRQD_ITEM_DESP=' + Rec."Vendor Category Description" +
                            '&attach_category=Request+for+Quotation+document')
                        end*/
                    end;
                }
                action("View Documents")
                {
                    Image = Attach;
                    Promoted = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*DMSint.Reset;
                        DMSint.SetRange(DMSint."DMS Link Type", DMSint."DMS Link Type"::DMSView);
                        if DMSint.Find('-') then begin

                            HyperLink(DMSint."DMS Link Path" + '&dt_code=DT_1_1464075594713&dtgcode=DTT_1_1464075717112&spu_id=' + Rec."No." +
                            '&attach_category=Request+for+Quotation+document')
                        end;*/
                    end;
                }
                action(Email)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send by &Email';
                    Image = Email;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ToolTip = 'Prepare to send the document by email. The Send Email window opens prefilled for the vendor where you can add or change information before you send the email.';
                    Visible = false;

                    trigger OnAction()
                    var
                        SalesInvHeader: Record "Purchase Quote Header";
                    begin
                        SalesInvHeader := Rec;
                        CurrPage.SetSelectionFilter(SalesInvHeader);
                        //SalesInvHeader.email(TRUE);
                    end;
                }
                action(EmailExtension)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Email Extension';
                    Image = Email;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ToolTip = 'Prepare to send the document by email. The Send Email window opens prefilled for the vendor where you can add or change information before you send the email.';
                    Visible = false;

                    trigger OnAction()
                    var
                        SalesInvHeader: Record "Purchase Quote Header";
                        SMTPMail: Codeunit "SMTP Mail";
                        QuotationRequestVendors: Record "Quotation Request Vendors";
                    begin

                        if Confirm('Send extension Email to vendors?', false) = false then begin exit end;

                        QuotationRequestVendors.Reset;
                        QuotationRequestVendors.SetRange("Requisition Document No.", Rec."No.");
                        if QuotationRequestVendors.FindSet then
                            repeat
                                Vend.Get(QuotationRequestVendors."Vendor No.");
                                Clear(SMTPMail);
                                Clear(Text001);
                                Clear(Textmail);
                                Text001 := Rec."Vendor Category Code";
                                Textmail.Add(Text001);
                                SMTPMailSetup.Get;
                                SMTPMail.CreateMessage(' ', ' ', Textmail, 'EXTENSION', 'Dear Sir/Madam, Kindly note that there has been an extension to the quotation no ' + Rec."No."
                                + ' to ' + Format(Rec."Expected Closing Date") + 'for the reason: ' + Rec."Reason for extending", true);
                                SMTPMail.AppendBody('<br>');
                                //SMTPMail.AddRecipients(Vend."E-Mail");
                                SMTPMail.Send;
                            until QuotationRequestVendors.Next = 0;
                        Message('Mail sent');
                    end;
                }
                action("Send Mail")
                {
                    Caption = 'Send RFQ to Vendors';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        QuotationRequestVendors: Record "Quotation Request Vendors";
                        Vend: Record Vendor;
                        //EmailMgt: Codeunit "Posting Check FP";
                        MyRecordRef: RecordRef;
                        MyFieldRef: FieldRef;
                        RFQLimitErr: Label 'This Request For Quotation has to go for Approval';
                        LinkFilea: Text[100];
                        RecordLinkk: Record "Record Link";
                        LinkFileb: Text[100];
                        LinkFilec: Text[100];
                        LinkFiled: Text[100];
                        LinkFilee: Text[100];
                        CountT: Integer;
                        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
                        SMTPMail: Codeunit "SMTP Mail";
                    begin
                        //IF USERID<>'AMREF\JKAMAU.CORETECH' THEN
                        //ERROR('process under testing');
                        Rec.TestField("Opening Committee No.");
                        Rec.TestField("Expected Opening Date");
                        Rec.TestField("Expected Closing Date");
                        Rec.TestField("Evaluation Committee No.");
                        //CHECK WHETHER THE AMOUNT IS ABOVE OR BELOW LIMIT
                        PurchasesPayablesSetup.Get;

                        RFQAmount := 0;
                        if Confirm('Release document?', false) = false then begin exit end;


                        //check if the document has any lines
                        Lines.Reset;
                        Lines.SetRange(Lines."Document Type", Rec."Document Type");
                        Lines.SetRange(Lines."Document No.", Rec."No.");
                        if Lines.FindFirst then begin
                            repeat
                                Lines.TestField(Lines.Quantity);
                                //Lines.TESTFIELD(Lines."Direct Unit Cost");
                                RFQAmount := RFQAmount + Lines.Amount;
                                Lines.TestField("No.");
                            until Lines.Next = 0;
                        end
                        else begin
                            Error('Document has no lines');
                        end;
                        // Status:=Status::Released;
                        // "Released By":=USERID;
                        // "Release Date":=TODAY;
                        // MODIFY;

                        begin
                            CountVendor := 0;
                            QuotationRequestVendors.Reset;
                            QuotationRequestVendors.SetRange("Requisition Document No.", Rec."No.");
                            //QuotationRequestVendors.SETRANGE(QuotationRequestVendors."Do NOT Send Mail",FALSE);
                            if QuotationRequestVendors.FindSet then begin
                                repeat
                                    //Vend.GET(QuotationRequestVendors."Vendor No.");
                                    Vend.Reset;
                                    Vend.SetRange("No.", QuotationRequestVendors."Vendor No.");
                                    if Vend.Find('-') then
                                        CountT := 0;

                                    LinkFilea := '';
                                    LinkFileb := '';
                                    LinkFilec := '';
                                    LinkFiled := '';
                                    LinkFilee := '';

                                    RecordLinkk.Reset;
                                    RecordLinkk.SetRange(RecordLinkk."Record ID", Rec.RecordId);
                                    if RecordLinkk.Find('-') then begin
                                        repeat
                                            //MESSAGE('The record link is %1',RECORDID);
                                            if CountT = 0 then
                                                LinkFilea := RecordLinkk.URL1
                                            else
                                                if CountT = 1 then
                                                    LinkFileb := RecordLinkk.URL1
                                                else
                                                    if CountT = 2 then
                                                        LinkFilec := RecordLinkk.URL1
                                                    else
                                                        if CountT = 3 then
                                                            LinkFiled := RecordLinkk.URL1
                                                        else
                                                            if CountT = 4 then
                                                                LinkFilee := RecordLinkk.URL1;
                                            //MESSAGE('The record link file is %1',LinkFile);
                                            CountT := CountT + 1;
                                        until RecordLinkk.Next = 0;
                                    end;

                                    MyRecordRef.Open(51533344);
                                    MyFieldRef := MyRecordRef.Field(3); // Document no.
                                    MyFieldRef.SetRange(Rec."No.");
                                    MyRecordRef.Find('-');
                                    CountVendor := QuotationRequestVendors.Count;
                                    if CountVendor < 3 then
                                        Error('Please assign vendors as per the minimum threshhold of 3');
                                    if QuotationRequestVendors.Notified = false then
                                        //EmailMgt.SendEmail(Vend."E-Mail", 51533315, MyRecordRef, Format(' : ' + "Posting Description" + ' ' + Rec."No." + ' ' +
                                        //'Kindly login to eprocurement portal; https://eprocurement.ufaa.go.ke to submit your quotation.'));//LinkFilea,LinkFileb,LinkFilec,LinkFiled,LinkFilee);
                                    MyRecordRef.Close;
                                    QuotationRequestVendors.Notified := true;
                                    QuotationRequestVendors.Modify;
                                until QuotationRequestVendors.Next = 0;
                            end
                            else begin
                                Error('Please assign vendors');
                            end;
                            //MESSAGE('CountVendor%1,',CountVendor);
                            Message('Mail sent');
                            Rec.Status := Rec.Status::Released;
                        end;
                    end;
                }
                action(Advertise)
                {
                    Image = ShowInventoryPeriods;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                }
            }
            group(DMS)
            {
                Caption = ' ATTACHMENT';
                Image = Documents;
                action(IncomingDocCard)
                {
                    Caption = 'View';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';
                    Visible = false;

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCardFromEntryNo(Rec."Incoming Document Entry No.");
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document" = R;
                    Caption = 'Select';
                    Image = SelectLineToApply;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';
                    Visible = false;

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        Rec.Validate("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RecordId));
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    Caption = 'Attach';
                    Ellipsis = true;
                    Enabled = NOT HasIncomingDocument;
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';
                    Visible = false;

                    trigger OnAction()
                    var
                        IncomingDocumentAttachment: Record "Incoming Document Attachment";
                    begin
                        //IncomingDocumentAttachment.NewAttachmentFromRFQ(Rec);
                    end;
                }
                action(RemoveIncomingDoc)
                {
                    Caption = 'Remove File';
                    Enabled = HasIncomingDocument;
                    Image = RemoveLine;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';
                    Visible = false;

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        if IncomingDocument.Get(Rec."Incoming Document Entry No.") then
                            IncomingDocument.RemoveLinkToRelatedRecord;
                        Rec."Incoming Document Entry No." := 0;
                        Rec.Modify(true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        PageRecordRef.GetTable(Rec);
        //CurrPage.AttachedDocsFactBox.PAGE.FilterDocuments(PageRecordRef.RecordId);
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
    end;

    trigger OnAfterGetRecord()
    begin
        UserSetup.Get(UserId);
        if Rec.Status = Rec.Status::Released then
            PageEditable := false
        else
            PageEditable := true;

        /*if UserSetup."Modify RFQ Dates" = true then
            DatesEditable := true
        else
            DatesEditable := false; */

        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        Rec."Procurement Methods" := 'RFQ';
        //Rec.MODIFY;
        /*ECH.GET;
         ECH."Procurement Method No":= "No.";
         ECH.MODIFY;*/
        if Rec.Status <> Rec.Status::Released then
            UneditablewhenApproved := false
        else
            UneditablewhenApproved := true;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //"Responsibility Center":='SCMD';
        Rec."Document Type" := Rec."Document Type"::"Quotation Request";
        CurrPage.Update;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PageEditable := true;
    end;

    trigger OnOpenPage()
    begin
        //SETFILTER("User IDS",USERID);SETFILTER("User IDS",USERID);

        Rec."Assigned User ID" := UserId;
        if Rec."Document Type" = Rec."Document Type"::"Request For Quoatation" then begin
            GenLedSet.Get;
            //Rec."Procurement Methods" := GenLedSet."RFQ Proc Methods";
            Rec.Modify;
        end;


        if Rec.Status <> Rec.Status::Released then
            UneditablewhenApproved := false
        else
            UneditablewhenApproved := true;
    end;

    var
        PurchHeader: Record "Purchase Header";
        //PParams: Record "Purchase Quote Params";
        Lines: Record "Purchase Quote Line";
        PQH: Record "Purchase Quote Header";
        //repvend: Report "RFQ Report 2";
        Assignvendor: Record "Quotation Request Vendors";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        //DMSint: Record "DMS Intergration";
        [InDataSet]

        PageEditable: Boolean;
        PageRecordRef: RecordRef;
        DocTxt: Label 'Invoice';
        QRV: Record "Quotation Request Vendors";
        VarVariant: Variant;
        //CustomApprovals: Codeunit "Custom Approval Management";
        Purchasequoteheader: Record "Purchase Quote Header";
        PrintRecords: Boolean;
        RFQAmount: Decimal;
        HasIncomingDocument: Boolean;
        SMTPMailSetup: Record "SMTP Mail Setup";
        Vend: Record Vendor;
        GenLedSet: Record "General Ledger Setup";
        ECH: Record "Evaluation Criterial Header";
        UserSetup: Record "User Setup";
        [InDataSet]
        DatesEditable: Boolean;
        CountVendor: Integer;
        OpeningCommittee: Record "Tender Committee Activities";
        DocSetUp: Record "RFP Document Setup";
        UneditablewhenApproved: Boolean;
        Text001: Text[30];
        Textmail: list of [Text];

    procedure InsertRFQLines()
    var
        Counter: Integer;
        Collection: Record "Purchase Line";
        CollectionList: Page "PRF Lists";
    begin
        CollectionList.LookupMode(true);
        if CollectionList.RunModal = ACTION::LookupOK then begin
            CollectionList.SetSelection(Collection);
            Counter := Collection.Count;
            if Counter > 0 then begin
                if Collection.FindSet then
                    repeat
                        Lines.Init;
                        Lines.TransferFields(Collection);
                        Lines."Document Type" := Rec."Document Type";
                        Lines."Document No." := Rec."No.";
                        Lines."Line No." := 0;
                        Lines."PRF No" := Collection."Document No.";
                        Lines."PRF Line No." := Collection."Line No.";
                        Lines.Insert(true);
                        Lines."Shortcut Dimension 1 Code" := Collection."Shortcut Dimension 1 Code";
                        Lines."Shortcut Dimension 2 Code" := Collection."Shortcut Dimension 2 Code";
                        Lines.Description := Collection.Description;
                        Lines."Description 2" := Collection."Description 2";
                        Lines.Modify;
                    //Collection.Copied:=TRUE;
                    //Collection.MODIFY;
                    until Collection.Next = 0;
            end;
        end;
    end;

    local procedure CheckVendors()
    begin
        /*
        Assignvendor.RESET;
        Assignvendor.SETRANGE(Assignvendor."Requisition Document No.","No.");
        IF NOT Assignvendor.FIND('-') THEN
          ERROR('Kindly Assign Vendors Before You Release');
        */

    end;

    procedure EmailRecords(ShowDialog: Boolean)
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DummyReportSelections: Record "Report Selections";
    begin
        DocumentSendingProfile.TrySendToEMail(39005982, Rec, Rec.FieldNo("No."), DocTxt, Rec.FieldNo("Vendor No."), ShowDialog);
    end;
}

