page 51533444 "Imprest Vouchers List"
{
    Caption = 'Travel Advance Requisitions';
    CardPageID = "Imprest Request Header";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Approval_Details,Category10_caption';
    SourceTable = "Imprest Header";
    SourceTableView = WHERE(Posted = FILTER(false),
                            Status = FILTER(<> Rejected));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field("Account No."; Rec."Account No.")
                {
                }
                field(Payee; Rec.Payee)
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                }
                field("Total Net Amount LCY"; Rec."Total Net Amount LCY")
                {
                }
                field("Current Status"; Rec."Current Status")
                {
                }
                field(Cashier; Rec.Cashier)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Employee Number"; Rec."Employee Number")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755015; Notes)
            {
            }
            systempart(Control1102755016; MyNotes)
            {
            }
            systempart(Control1102755017; Outlook)
            {
            }
            systempart(Control1102755018; Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102755006>")
            {
                Caption = '&Functions';
                action("<Action1102755024>")
                {
                    Caption = 'Post Payment';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CheckImprestRequiredItems;
                        PostImprest;
                    end;
                }
                separator(Separator1102755025)
                {
                }
                action("<Action1102755031>")
                {
                    Caption = 'Check Budgetary Availability';
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
                        Commitments.SetRange(Commitments."Document No.", Rec."No.");
                        if Commitments.Find('-') then begin
                            if Confirm('Lines in this Document appear to be committed do you want to re-commit?', false) = false then begin exit end;
                            Commitments.Reset;
                            Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::Imprest);
                            Commitments.SetRange(Commitments."Document No.", Rec."No.");
                            Commitments.DeleteAll;
                        end;
                        **/
                        // CheckBudgetAvail.CheckImprest(Rec);
                    end;
                }
                action("<Action1102755032>")
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
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::"Payment Voucher");
                        Commitments.SetRange(Commitments."Document No.", Rec."No.");
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
                separator(Separator1102755022)
                {
                }
                action("<Action1102755010>")
                {
                    Caption = 'Print/Preview';
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // IF Status<>Status::Approved THEN
                        //  ERROR('You can only print after the document is Approved');

                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        //REPORT.Run(REPORT::"Travel Advance Report",true,false,Rec);
                        Rec.Reset;
                    end;
                }
                separator(Separator1102755020)
                {
                }
                action("<Action1102756007>")
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
                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if not AllFieldsEntered then
                            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //Ensure No Items That should be committed that are not
                        if LinesCommitmentStatus then
                            Error('There are some lines that have not been committed');

                        VarVariant := Rec;
                        //if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        //    CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
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
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //check if the documenent has been added while another one is still pending
        ImprestHdr.Reset;
        //TravAccHeader.SETRANGE(SaleHeader."Document Type",SaleHeader."Document Type"::"Cash Sale");
        ImprestHdr.SetRange(ImprestHdr.Cashier, UserId);
        ImprestHdr.SetRange(ImprestHdr.Status, ImprestHdr.Status::Open);

        if ImprestHdr.Count > 0 then begin
            Error('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
        end;
        //*********************************END ****************************************//
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //check if the documenent has been added while another one is still pending
        ImprestHdr.Reset;
        //TravAccHeader.SETRANGE(SaleHeader."Document Type",SaleHeader."Document Type"::"Cash Sale");
        ImprestHdr.SetRange(ImprestHdr.Cashier, UserId);
        ImprestHdr.SetRange(ImprestHdr.Status, ImprestHdr.Status::Open);

        if ImprestHdr.Count > 0 then begin
            Error('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
        end;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
        /*
        FILTERGROUP(2);
        SETRANGE(Cashier,USERID);
        FILTERGROUP(0);
        */
        Rec.SetFilter(Cashier, UserId);

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
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
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

    procedure PostImprest()
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
        GenJnlLine.Description := 'Imprest: ' + Rec."Account No." + ':' + Rec.Payee;
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
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;


        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Line", GenJnlLine);

        Post := false;
        Post := JournlPosted.PostedSuccessfully();
        if Post then begin
            Rec.Posted := true;
            Rec."Date Posted" := Today;
            Rec."Time Posted" := Time;
            Rec."Posted By" := UserId;
            Rec.Status := Rec.Status::Cancelled;
            Rec.Modify;
        end;

    end;

    procedure CheckImprestRequiredItems()
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
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
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
                if (PayLines."Account No:" = '') or (PayLines.Amount <= 0) then
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

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}

