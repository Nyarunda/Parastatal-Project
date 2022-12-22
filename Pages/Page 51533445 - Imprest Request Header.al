page 51533445 "Imprest Request Header"
{
    Caption = 'Imprest Request';
    DeleteAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Approval_Details,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = "Imprest Header";
    SourceTableView = WHERE(Posted = FILTER(false));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    //Editable = Rec.DateEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Department Code';
                    //Editable = Rec.GlobalDimension1CodeEditable;
                }
                field("Function Name"; Rec."Function Name")
                {
                    Caption = 'Description';
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Division Code';
                    // Editable = Rec.ShortcutDimension2CodeEditable;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    Caption = 'Description';
                    Editable = false;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                    Editable = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = true;
                }
                field(Payee; Rec.Payee)
                {
                    Enabled = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    //Editable = "Currency CodeEditable";
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    //Editable = Rec."Paying Bank AccountEditable";
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                }
                field(Purpose; Rec.Purpose)
                {
                }
                field(Designation; Rec.Designation)
                {
                    Caption = 'External Document No.';
                }
                field(Cashier; Rec.Cashier)
                {
                    Caption = 'Requestor ID';
                    Enabled = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = true;
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                }
                field("Total Net Amount LCY"; Rec."Total Net Amount LCY")
                {
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    Caption = 'Posting Date';
                    //Editable = "Payment Release DateEditable";
                }
                field("External Doc No"; Rec."External Doc No")
                {
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    Caption = 'Cheque/EFT No.';
                    //Editable = "Cheque No.Editable";
                }
                field("Employee Number"; Rec."Employee Number")
                {
                    Visible = false;
                }
                field(RecID; Format(Rec.RecordId))
                {
                    Visible = false;
                }
            }
            /**
            part(PVLines; "Imprest Request Details")
            {
                SubPageLink = No=FIELD("No.");
            }
            **/
            systempart(Control5; Links)
            {
                Visible = true;
            }
            systempart(Control3; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Post Payment")
                {
                    Caption = 'Post Payment';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CheckImprestRequiredItems(Rec);
                        PostImprest(Rec);
                        /*
                              RESET;
                              SETFILTER("No.","No.");
                              REPORT.RUN(39005885,TRUE,TRUE,Rec);
                              RESET;
                         */

                    end;
                }
                separator(Separator1102755026)
                {
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Document No." = FIELD("No.");
                }
                action("Check Budget Commitment")
                {
                    Caption = 'Check Budget Commitment';
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        BCSetup: Record "Budgetary Control Setup";
                    begin

                        BCSetup.Get;
                        if not BCSetup.Mandatory then
                            exit;

                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if not AllFieldsEntered then
                            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //First Check whether other lines are already committed.
                        /**
                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::Imprest);
                        Commitments.SetRange(Commitments."Document No.", "No.");
                        if Commitments.Find('-') then begin
                            if Confirm('Lines in this Document appear to be committed do you want to re-commit?', false) = false then begin exit end;
                            Commitments.Reset;
                            Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::Imprest);
                            Commitments.SetRange(Commitments."Document No.", "No.");
                            Commitments.DeleteAll;
                        end;
                        **/

                        CheckBudgetAvail.CheckImprest(Rec);
                    end;
                }
                action("Cancel Budget Commitment")
                {
                    Caption = 'Cancel Budget Commitment';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Do you Wish to Cancel the Commitment entries for this document', false) = false then begin exit end;
                        /**
                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::Imprest);
                        Commitments.SetRange(Commitments."Document No.", "No.");
                        Commitments.DeleteAll;
                        **/

                        PayLine.Reset;
                        PayLine.SetRange(PayLine.No, Rec."No.");
                        if PayLine.Find('-') then begin
                            repeat
                                PayLine.Committed := false;
                                PayLine.Modify;
                            until PayLine.Next = 0;
                        end;
                    end;
                }
                separator(Separator1102755033)
                {
                }
                action("Print/Preview")
                {
                    Caption = 'Print/Preview';
                    Image = ConfirmAndPrint;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Rec.Status <> Rec.Status::"Pending Approval" then
                            Error('You can only print after the document is Approved');
                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        //REPORT.Run(REPORT::"Travel Advance Report", true, false, Rec);
                        Rec.Reset;
                    end;
                }
                separator(Separator1102756006)
                {
                }
                action("Cancel Document")
                {
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text000: Label 'Are you sure you want to Cancel this Document?';
                        Text001: Label 'You have selected not to Cancel this Document';
                    begin
                        Rec.TestField(Status, Rec.Status::Rejected);
                        if Confirm(Text000, true) then begin
                            //Post Committment Reversals
                            Doc_Type := Doc_Type::Imprest;
                            BudgetControl.ReverseEntries(Doc_Type, Rec."No.");
                            Rec.Status := Rec.Status::Rejected;
                            Rec.Modify;
                        end else
                            Error(Text001);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if not (Rec.Status = Rec.Status::Open) then begin
                            Error('Document must be Pending/Open');
                        end;

                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if not AllFieldsEntered then
                            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //Ensure No Items That should be committed that are not
                        if LinesCommitmentStatus then
                            Error('There are some lines that have not been committed');

                        if Rec.Status = Rec.Status::Open then
                            VarVariant := Rec;
                        //if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        //    CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        VarVariant := Rec;
                        //CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
            }
            group(Navigate)
            {
                Caption = 'Navigate';
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
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);

                    end;
                }
            }
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
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId)
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
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId)
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
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId)
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = CONST(39005527),
                                  "Document No." = FIELD("No.");
                    Visible = OpenApprovalEntriesExistForCurrUser;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
        SetControlAppearance;
    end;

    trigger OnInit()
    begin
        "Currency CodeEditable" := true;
        DateEditable := true;
        ShortcutDimension2CodeEditable := true;
        GlobalDimension1CodeEditable := true;
        "Cheque No.Editable" := true;
        "Pay ModeEditable" := true;
        "Paying Bank AccountEditable" := true;
        "Payment Release DateEditable" := true;
        UpdateControls;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if GuiAllowed then begin
            //check if the documenent has been added while another one is still pending
            TravReqHeader.Reset;
            //TravAccHeader.SETRANGE(SaleHeader."Document Type",SaleHeader."Document Type"::"Cash Sale");
            TravReqHeader.SetRange(TravReqHeader.Cashier, UserId);
            TravReqHeader.SetRange(TravReqHeader.Status, Rec.Status::Open);

            if TravReqHeader.Count > 0 then begin
                //ERROR('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
            end;

            TravReqHeader.Reset;
            TravReqHeader.SetRange(TravReqHeader.Cashier, UserId);
            TravReqHeader.SetRange(TravReqHeader.Status, Rec.Status::Approved);

            if TravReqHeader.Count > 0 then begin
                //  ERROR('There are still some document(s) pending approval on your account.');
            end;
            TravReqHeader.Reset;
            TravReqHeader.SetRange(TravReqHeader.Cashier, UserId);
            TravReqHeader.SetRange(TravReqHeader.Status, Rec.Status::Approved);

            if TravReqHeader.Count > 0 then begin
                //ERROR('There are still somedocument(s)  pending  posting on your account.');
            end;
            //*********************************END ****************************************//
        end;

        //Rec."Payment Type" := "Payment Type"::Imprest;
        Rec."Account Type" := "Account Type"::Customer;
        //CurrPage.UPDATE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //Add dimensions if set by default here
        //Rec."Global Dimension 1 Code" := UserMgt.GetSetDimensions(UserId, 1);
        Rec.Validate("Global Dimension 1 Code");
        //Rec."Shortcut Dimension 2 Code" := UserMgt.GetSetDimensions(UserId, 2);
        Rec.Validate("Shortcut Dimension 2 Code");
        //Rec."Shortcut Dimension 5 Code" := UserMgt.GetSetDimensions(UserId, 3);
        Rec.Validate("Shortcut Dimension 5 Code");
        //Rec."Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(UserId, 4);
        Rec.Validate("Shortcut Dimension 4 Code");
        //OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
        UpdateControls;
        SetDocNoVisible;
    end;

    var
        PayLine: Record "Imprest Lines";
        PVUsers: Record "Imprest Lines";
        strFilter: Text[250];
        IntC: Integer;
        IntCount: Integer;
        Payments: Record "Payments Header";
        RecPayTypes: Record "Receipts and Payment Types";
        TarriffCodes: Record "Tariff Codes";
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record "Cash Office User Template";
        LineNo: Integer;
        Temp: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        PCheck: Codeunit prPayrollProcessing;
        Post: Boolean;
        strText: Text[100];
        PVHead: Record "Payments Header";
        BankAcc: Record "Bank Account";
        CheckBudgetAvail: Codeunit "Budgetary Control";
        //Commitments: Record Committments;
        UserMgt: Codeunit "User Setup Management";
        JournlPosted: Codeunit "Journal Post Successful";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,Loan,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","MSacco Applications","MSacco PinChange","MSacco PhoneChange","MSacco TransChange",BulkSMS,"Payment Voucher","Petty Cash",Imp,Requisition,ImpSurr,Interbank,Receipt,"Staff Claim","Staff Adv",AdvSurr,OT;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        BudgetControl: Codeunit "Budgetary Control";
        ImprestHdr: Record "Imprest Header";
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Paying Bank AccountEditable": Boolean;
        [InDataSet]
        "Pay ModeEditable": Boolean;
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension3CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension4CodeEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        TravReqHeader: Record "Imprest Header";
        DocNoVisible: Boolean;
        "NOT OpenApprovalEntriesExist": Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
    //CustomApprovals: Codeunit "Custom Approval Management";

    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record "Budgetary Control Setup";
    begin
        if BCsetup.Get() then begin
            if not BCsetup.Mandatory then begin
                Exists := false;
                exit;
            end;
        end else begin
            Exists := false;
            exit;
        end;
        Exists := false;
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Rec."No.");
        PayLine.SetRange(PayLine.Committed, false);
        PayLine.SetRange(PayLine."Budgetary Control A/C", true);
        if PayLine.Find('-') then
            Exists := true;
    end;

    procedure PostImprest(Rec: Record "Imprest Header")
    begin

        if Temp.Get(UserId) then begin
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            GenJnlLine.DeleteAll;
        end;

        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Payment Release Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Rec."Account No.";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine.Description := CopyStr('Imprest: ' + Rec."Account No." + ':' + Rec.Payee, 1, 50);
        Rec.CalcFields("Total Net Amount");
        GenJnlLine.Amount := Rec."Total Net Amount";
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := Rec."Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        //Added for Currency Codes
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");
        /*
        GenJnlLine."Currency Factor":=Payments."Currency Factor";
        GenJnlLine.VALIDATE("Currency Factor");
        */
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine."Shortcut Dimension 3 Code" := Rec."Shortcut Dimension 5 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 3 Code");
        //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;


        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

        Post := false;
        Post := JournlPosted.PostedSuccessfully();
        if Post then begin

        end;
        Rec.Posted := true;
        Rec."Date Posted" := Today;
        Rec."Time Posted" := Time;
        Rec."Posted By" := UserId;
        Rec.Status := Rec.Status::Cancelled;
        Rec.Modify;

    end;

    procedure CheckImprestRequiredItems(Rec: Record "Imprest Header")
    begin

        Rec.TestField("Payment Release Date");
        Rec.TestField("Paying Bank Account");
        Rec.TestField("Account No.");
        Rec.TestField("Account Type", "Account Type"::Customer);

        if Rec.Posted then begin
            Error('The Document has already been posted');
        end;

        Rec.TestField(Status, Rec.Status::Posted);

        /*Check if the user has selected all the relevant fields*/

        Temp.Get(UserId);
        JTemplate := Temp."Imprest Template";
        JBatch := Temp."Imprest  Batch";

        if JTemplate = '' then begin
            Error('Ensure the Imprest Template is set up in Cash Office Setup');
        end;

        if JBatch = '' then begin
            Error('Ensure the Imprest Batch is set up in the Cash Office Setup')
        end;

        if not LinesExists then
            Error('There are no Lines created for this Document');

    end;

    procedure UpdateControls()
    begin
        if Rec.Status <> Rec.Status::"Pending Approval" then begin
            "Payment Release DateEditable" := false;
            "Paying Bank AccountEditable" := false;
            "Pay ModeEditable" := false;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            "Cheque No.Editable" := false;
            CurrPage.Update;
        end else begin
            "Payment Release DateEditable" := true;
            "Paying Bank AccountEditable" := true;
            "Pay ModeEditable" := true;
            "Cheque No.Editable" := true;
            //CurrForm."Currency Code".EDITABLE:=TRUE;
            CurrPage.Update;
        end;

        if Rec.Status = Rec.Status::Open then begin
            GlobalDimension1CodeEditable := true;
            ShortcutDimension2CodeEditable := true;
            //CurrForm.Payee.EDITABLE:=TRUE;
            ShortcutDimension3CodeEditable := true;
            ShortcutDimension4CodeEditable := true;
            DateEditable := true;
            //CurrForm."Account No.".EDITABLE:=TRUE;
            "Currency CodeEditable" := true;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            CurrPage.Update;
        end else begin
            GlobalDimension1CodeEditable := false;
            ShortcutDimension2CodeEditable := false;
            //CurrForm.Payee.EDITABLE:=FALSE;
            ShortcutDimension3CodeEditable := false;
            ShortcutDimension4CodeEditable := false;
            DateEditable := false;
            //CurrForm."Account No.".EDITABLE:=FALSE;
            "Currency CodeEditable" := false;
            CurrPage.Update;
        end
    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Imprest Lines";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Imprest Lines";
    begin
        AllKeyFieldsEntered := true;
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec."No.");
        if PayLines.Find('-') then begin
            repeat
                if (PayLines."Account No:" = '') or (PayLines.Purpose = '') or (PayLines.Amount <= 0) then
                    AllKeyFieldsEntered := false;
            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Requisition","Transport Requisition",JV,"Grant Task","Concept Note",Proposal,"Job Approval","Disciplinary Approvals",GRN,Clearence,Donation,Transfer,PayChange,Budget,GL,"Cash Purchase","Leave Reimburse",Appraisal,Inspection,Closeout,"Lab Request",ProposalProjectsAreas,"Leave Carry over","IB Transfer",EmpTransfer,LeavePlanner,HrAssetTransfer;
    begin
        //DocNoVisible := DocumentNoVisibility.FundsMgtDocumentNoIsVisible(DocType::Imprest,"No.");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}

