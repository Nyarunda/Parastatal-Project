page 51533449 "Imprest Surrender"
{
    Caption = 'Travel Imprest surrender';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approvals,Cancellation,Category6_caption,Category7_caption,Category8_caption,Approval_Details,Category10_caption';
    SourceTable = "Imprest Surrender Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                }
                field("Surrender Date"; Rec."Surrender Date")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Account No."; Rec."Account No.")
                {

                    trigger OnValidate()
                    begin
                        AccountName := GetCustName(Rec."Account No.");
                    end;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = true;
                    Enabled = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {
                }
                field(Amount; Rec.Amount)
                {
                    Enabled = false;
                }
                field("Imprest Issue Date"; Rec."Imprest Issue Date")
                {
                    Enabled = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Department Code';
                    Enabled = false;

                    trigger OnValidate()
                    begin
                        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
                    end;
                }
                field("Function Name"; Rec."Function Name")
                {
                    Caption = 'Department Name';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Division Code';
                    Enabled = false;

                    trigger OnValidate()
                    begin
                        DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
                    end;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    Caption = 'Division Name';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                }
                //field("Extrenal Document No.";Rec."Extrenal Document No.") { ShowCaption = false;  }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = true;
                }
                field(Status; Rec.Status)
                {
                }
                field(Cashier; Rec.Cashier)
                {
                    Enabled = false;
                }
                field("User ID"; Rec."User ID")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Enabled = false;
                }
                field(RecID; Format(Rec.RecordId))
                {
                    Visible = false;
                }
            }
            field(Control1102755001; '')
            {
                //CaptionClass = Text19053222;
                ShowCaption = false;
                Style = Standard;
                StyleExpr = TRUE;
            }
            //part(ImprestLines; "Imprest Surrender Details") { Editable = ImprestLinesEditable; SubPageLink = "Surrender Doc No."=FIELD(No);          }
            systempart(Control1; Notes)
            {
                Visible = true;
            }
            systempart(Control2; Links)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Cancel Document")
                {
                    Caption = 'Cancel Document';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Post Committment Reversals
                        Rec.TestField(Status, Rec.Status::Approved);
                        if Confirm(Text002, true) then begin
                            Doc_Type := Doc_Type::Imprest;
                            //BudgetControl.ReverseEntries(Doc_Type, "Imprest Issue Doc. No");
                            Rec.Status := Rec.Status::Cancelled;
                            Rec.Modify;
                        end;
                    end;
                }
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                var
                    Txt0001: Label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                begin
                    Rec.TestField(Status, Rec.Status::Approved);

                    ImprestDetails.Reset;
                    ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.", Rec.No);
                    if ImprestDetails.FindSet then
                        repeat
                            if (ImprestDetails."Cash Receipt Amount" + ImprestDetails."Actual Spent") <> ImprestDetails.Amount then
                                Error(Txt0001);
                        /*IF (ImprestDetails."Cash Receipt Amount"<>ImprestDetails.Amount) THEN BEGIN
                           IF (ImprestDetails."Actual Spent"<>ImprestDetails.Amount) THEN
                            ERROR(Txt0001);
                           END;*/

                        until ImprestDetails.Next = 0;

                    if Rec.Posted then
                        Error('The transaction has already been posted.');

                    //HOW ABOUT WHERE ONE RETURNS ALL THE AMOUNT??
                    //THERE SHOULD BE NO GENJNL ENTRIES BUT REVERSE THE COMMITTMENTS
                    Rec.CalcFields("Actual Spent");
                    if Rec."Actual Spent" = 0 then
                        if Confirm(Text000, true) then
                            UpdateforNoActualSpent
                        else
                            Error(Text001);

                    // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                    if GenledSetup.Get then begin
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", GenledSetup."Surrender Template");
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", GenledSetup."Surrender  Batch");
                        GenJnlLine.DeleteAll;
                    end;

                    if DefaultBatch.Get(GenledSetup."Surrender Template", GenledSetup."Surrender  Batch") then begin
                        DefaultBatch.Delete;
                    end;

                    DefaultBatch.Reset;
                    DefaultBatch."Journal Template Name" := GenledSetup."Surrender Template";
                    DefaultBatch.Name := GenledSetup."Surrender  Batch";
                    DefaultBatch.Insert;
                    LineNo := 0;

                    ImprestDetails.Reset;
                    ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.", Rec.No);
                    if ImprestDetails.Find('-') then begin
                        repeat
                            //Post Surrender Journal
                            //Compare the amount issued =amount on cash reciecied.
                            //Created new field for zero spent
                            //

                            //ImprestDetails.TESTFIELD("Actual Spent");
                            //ImprestDetails.TESTFIELD("Actual Spent");
                            /*IF (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount THEN
                               ERROR(Txt0001);*///sheshi

                            Rec.TestField("Global Dimension 1 Code");

                            LineNo := LineNo + 1000;
                            GenJnlLine.Init;
                            GenJnlLine."Journal Template Name" := GenledSetup."Surrender Template";
                            GenJnlLine."Journal Batch Name" := GenledSetup."Surrender  Batch";
                            GenJnlLine."Line No." := LineNo;
                            GenJnlLine."Source Code" := 'PAYMENTJNL';
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No." := ImprestDetails."Account No:";
                            GenJnlLine.Validate(GenJnlLine."Account No.");
                            //Set these fields to blanks
                            //GenJnlLine."Posting Date":="Surrender Date";
                            GenJnlLine."Posting Date" := Rec."Date Posted";
                            GenJnlLine."Document Date" := Rec."Surrender Date";
                            GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                            GenJnlLine.Validate("Gen. Posting Type");
                            GenJnlLine."Gen. Bus. Posting Group" := '';
                            GenJnlLine.Validate("Gen. Bus. Posting Group");
                            GenJnlLine."Gen. Prod. Posting Group" := '';
                            GenJnlLine.Validate("Gen. Prod. Posting Group");
                            GenJnlLine."VAT Bus. Posting Group" := '';
                            GenJnlLine.Validate("VAT Bus. Posting Group");
                            GenJnlLine."VAT Prod. Posting Group" := '';
                            GenJnlLine.Validate("VAT Prod. Posting Group");
                            GenJnlLine."Document No." := Rec.No;
                            GenJnlLine.Amount := ImprestDetails."Actual Spent";
                            GenJnlLine.Validate(GenJnlLine.Amount);
                            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
                            GenJnlLine."Bal. Account No." := ImprestDetails."Imprest Holder";
                            GenJnlLine.Description := 'Surrendered by:' + Rec."Account No." + ':' + Rec.Payee + ':' + Rec.No;
                            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                            GenJnlLine."Currency Code" := Rec."Currency Code";
                            GenJnlLine.Validate("Currency Code");
                            //Take care of Currency Factor
                            GenJnlLine."Currency Factor" := Rec."Currency Factor";
                            GenJnlLine.Validate("Currency Factor");

                            GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                            GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                            GenJnlLine."Shortcut Dimension 3 Code" := Rec."Shortcut Dimension 3 Code";
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 3 Code");
                            //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                            GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

                            //Application of Surrender entries
                            if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer then begin
                                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                                //GenJnlLine."Applies-to Doc. No." := "Imprest Issue Doc. No";
                                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                                GenJnlLine."Applies-to ID" := Rec."Apply to ID";
                            end;

                            if GenJnlLine.Amount <> 0 then
                                GenJnlLine.Insert;

                            //Post Cash Surrender
                            if ImprestDetails."Cash Surrender Amt" > 0 then begin
                                if ImprestDetails."Bank/Petty Cash" = '' then
                                    Error('Select a Bank Code where the Cash Surrender will be posted');
                                LineNo := LineNo + 1000;
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := GenledSetup."Surrender Template";
                                GenJnlLine."Journal Batch Name" := GenledSetup."Surrender  Batch";
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                GenJnlLine."Account No." := ImprestDetails."Imprest Holder";
                                GenJnlLine.Validate(GenJnlLine."Account No.");
                                //Set these fields to blanks
                                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                                GenJnlLine.Validate("Gen. Posting Type");
                                GenJnlLine."Gen. Bus. Posting Group" := '';
                                GenJnlLine.Validate("Gen. Bus. Posting Group");
                                GenJnlLine."Gen. Prod. Posting Group" := '';
                                GenJnlLine.Validate("Gen. Prod. Posting Group");
                                GenJnlLine."VAT Bus. Posting Group" := '';
                                GenJnlLine.Validate("VAT Bus. Posting Group");
                                GenJnlLine."VAT Prod. Posting Group" := '';
                                GenJnlLine.Validate("VAT Prod. Posting Group");
                                //GenJnlLine."Posting Date":="Surrender Date";
                                GenJnlLine."Posting Date" := Rec."Date Posted";
                                GenJnlLine."Document Date" := Rec."Surrender Date";
                                GenJnlLine."Document No." := Rec.No;
                                GenJnlLine.Amount := -ImprestDetails."Cash Surrender Amt";
                                GenJnlLine.Validate(GenJnlLine.Amount);
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.Validate("Currency Code");
                                //Take care of Currency Factor
                                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                                GenJnlLine.Validate("Currency Factor");

                                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                                GenJnlLine."Bal. Account No." := ImprestDetails."Bank/Petty Cash";
                                GenJnlLine.Description := 'Imprest Surrender by staff' + ':' + Rec."Account Name" + ':' + Rec.No;
                                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                                GenJnlLine."Shortcut Dimension 1 Code" := ImprestDetails."Shortcut Dimension 1 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := ImprestDetails."Shortcut Dimension 2 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine."Shortcut Dimension 3 Code" := ImprestDetails."Shortcut Dimension 3 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 3 Code");
                                GenJnlLine."Dimension Set ID" := ImprestDetails."Dimension Set ID";
                                //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                                GenJnlLine."Applies-to ID" := ImprestDetails."Imprest Holder";
                                if GenJnlLine.Amount <> 0 then
                                    GenJnlLine.Insert;

                            end;

                        //End Post Surrender Journal

                        until ImprestDetails.Next = 0;
                        //Post Entries
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", GenledSetup."Surrender Template");
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", GenledSetup."Surrender  Batch");
                        //Adjust Gen Jnl Exchange Rate Rounding Balances
                        AdjustGenJnl.Run(GenJnlLine);
                        //End Adjust Gen Jnl Exchange Rate Rounding Balances

                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
                    end;

                    if JournalPostSuccessful.PostedSuccessfully then begin
                    end;
                    Rec.Posted := true;
                    Rec.Status := Rec.Status::Posted;
                    Rec."Date Posted" := Today;
                    Rec."Time Posted" := Time;
                    Rec."Posted By" := UserId;
                    Rec.Modify;
                    //Tag the Source Imprest Requisition as Surrendered
                    ImprestReq.Reset;
                    ImprestReq.SetRange(ImprestReq."No.", Rec."Imprest Issue Doc. No");
                    if ImprestReq.Find('-') then begin
                        ImprestReq."Surrender Status" := ImprestReq."Surrender Status"::Full;
                        ImprestReq.Modify;
                    end;

                    //End Tag
                    //Post Committment Reversals
                    Doc_Type := Doc_Type::Imprest;
                    BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");

                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    REPORT.Run(51533320, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action("Get Imprest Document")
            {
                Caption = 'Get Imprest Document';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."Imprest Issue Doc. No" = '' then
                        Error('Please Select the Imprest Issue Document Number');

                    PaymentLine.Reset;
                    PaymentLine.SetRange(PaymentLine.No, Rec."Imprest Issue Doc. No");
                    PAGE.RunModal(39006085, PaymentLine);
                end;
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
                        Txt0001: Label 'Actual spent should be equal with the Amount';
                    begin
                        Rec."Surrender Date" := Today;
                        if not (Rec.Status = Rec.Status::Pending) then begin
                            Error('Document must be Pending/Open');
                        end;

                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if not AllFieldsEntered then
                            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        /*
                        //Ensure No Items That should be committed that are not
                        IF LinesCommitmentStatus THEN
                          ERROR('There are some lines that have not been committed');
                        */
                        //First Check whether all amount entered tally
                        ImprestDetails.Reset;
                        ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.", Rec.No);
                        //ImprestDetails.CALCFIELDS(ImprestDetails.Amount);
                        if ImprestDetails.FindSet then
                            repeat
                                if (ImprestDetails."Cash Receipt Amount" + ImprestDetails."Actual Spent") <> ImprestDetails.Amount then
                                    Error(Txt0001);
                            until ImprestDetails.Next = 0;

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
                    PromotedIsBig = true;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = CONST(39005495),
                                  "Document No." = FIELD(No);
                    Visible = OpenApprovalEntriesExistForCurrUser;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Document No." = FIELD(No);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
        CurrPageUpdate;
        SetControlAppearance;
    end;

    trigger OnInit()
    begin
        ImprestLinesEditable := true;
        "Responsibility CenterEditable" := true;
        "Imprest Issue Doc. NoEditable" := true;
        "Account No.Editable" := true;
        "Surrender DateEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        //check if the documenent has been added while another one is still pending
        TravAccHeader.Reset;
        TravAccHeader.SetRange(TravAccHeader.Cashier, UserId);
        TravAccHeader.SetRange(TravAccHeader.Status, Rec.Status::Pending);

        if TravAccHeader.Count > 0 then begin
            //ERROR('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
        end;

        TravAccHeader.Reset;
        TravAccHeader.SetRange(TravAccHeader.Cashier, UserId);
        TravAccHeader.SetRange(TravAccHeader.Status, Rec.Status::"Pending Approval");

        if TravAccHeader.Count > 0 then begin
            //ERROR('There are still some document(s) pending approval on your account.');
        end;
        TravAccHeader.Reset;
        TravAccHeader.SetRange(TravAccHeader.Cashier, UserId);
        TravAccHeader.SetRange(TravAccHeader.Status, Rec.Status::Approved);

        if TravAccHeader.Count > 0 then begin
            //ERROR('There are still somedocument(s)  pending  posting on your account.');
        end;
        //*********************************END ****************************************//

        Rec."User ID" := UserId;
        //CurrPage.UPDATE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //OnAfterGetCurrRecord;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        //SETFILTER(Status,'<>Cancelled');

        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
        Rec.Validate("Account No.");
        AccountName := GetCustName(Rec."Account No.");
        SetDocNoVisible;
    end;

    var
        RecPayTypes: Record "Receipts and Payment Types";
        TarriffCodes: Record "Tariff Codes";
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record "Cash Office User Template";
        LineNo: Integer;
        NextEntryNo: Integer;
        CommitNo: Integer;
        ImprestDetails: Record "Imprest Surrender Details";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        IsImprest: Boolean;
        GenledSetup: Record "Cash Office Setup";
        ImprestAmt: Decimal;
        DimName1: Text[60];
        DimName2: Text[60];
        CashPaymentLine: Record "Payment Line";
        PaymentLine: Record "Imprest Lines";
        CurrSurrDocNo: Code[20];
        JournalPostSuccessful: Codeunit "Journal Post Successful";
        //Commitments: Record Committments;
        BCSetup: Record "Budgetary Control Setup";
        BudgetControl: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        ImprestReq: Record "Imprest Header";
        UserMgt: Codeunit "User Setup Management";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,Loan,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","MSacco Applications","MSacco PinChange","MSacco PhoneChange","MSacco TransChange",BulkSMS,"Payment Voucher","Petty Cash",Imp,Requisition,ImpSurr,Interbank,Receipt,"Staff Claim","Staff Adv",AdvSurr,OT;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AccountName: Text[100];
        Text000: Label 'You have not specified the Actual Amount Spent. This document will only reverse the committment and you will have to receipt the total amount returned.';
        Text001: Label 'Document Not Posted';
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        Text002: Label 'Are you sure you want to Cancel this Document?';
        [InDataSet]
        "Surrender DateEditable": Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;
        [InDataSet]
        "Imprest Issue Doc. NoEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        ImprestLinesEditable: Boolean;
        Text19053222: Label 'Enter Advance Accounting Details below';
        TravAccHeader: Record "Imprest Surrender Header";
        StatusEditable: Boolean;
        DocNoVisible: Boolean;
        "NOT OpenApprovalEntriesExist": Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
    // CustomApprovals: Codeunit "Custom Approval Management";

    procedure GetDimensionName(var "Code": Code[20]; DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
    begin
        /*Get the global dimension 1 and 2 from the database*/
        Name := '';

        GLSetup.Reset;
        GLSetup.Get();

        DimVal.Reset;
        DimVal.SetRange(DimVal.Code, Code);

        if DimNo = 1 then begin
            DimVal.SetRange(DimVal."Dimension Code", GLSetup."Global Dimension 1 Code");
        end
        else
            if DimNo = 2 then begin
                DimVal.SetRange(DimVal."Dimension Code", GLSetup."Global Dimension 2 Code");
            end;
        if DimVal.Find('-') then begin
            Name := DimVal.Name;
        end;

    end;

    procedure UpdateControl()
    begin
        if Rec.Status <> Rec.Status::Pending then begin
            "Surrender DateEditable" := false;
            "Account No.Editable" := false;
            "Imprest Issue Doc. NoEditable" := false;
            "Responsibility CenterEditable" := false;
            ImprestLinesEditable := false;
        end else begin
            "Surrender DateEditable" := true;
            "Account No.Editable" := true;
            "Imprest Issue Doc. NoEditable" := true;
            "Responsibility CenterEditable" := true;
            ImprestLinesEditable := true;

        end;
    end;

    procedure GetCustName(No: Code[20]) Name: Text[100]
    var
        Cust: Record Customer;
    begin
        Name := '';
        if Cust.Get(No) then
            Name := Cust.Name;
        exit(Name);
    end;

    procedure UpdateforNoActualSpent()
    begin
        Rec.Posted := true;
        Rec.Status := Rec.Status::Posted;
        Rec."Date Posted" := Today;
        Rec."Time Posted" := Time;
        Rec."Posted By" := UserId;
        Rec.Modify;
        //Tag the Source Imprest Requisition as Surrendered
        ImprestReq.Reset;
        ImprestReq.SetRange(ImprestReq."No.", Rec."Imprest Issue Doc. No");
        if ImprestReq.Find('-') then begin
            ImprestReq."Surrender Status" := ImprestReq."Surrender Status"::Full;
            ImprestReq.Modify;
        end;
        //End Tag
        //Post Committment Reversals
        Doc_Type := Doc_Type::Imprest;
        BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
    end;

    procedure CompareAllAmounts()
    begin
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        //Update Controls as necessary
        //SETFILTER(Status,'<>Cancelled');
        UpdateControl;
        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
        DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
        AccountName := GetCustName(Rec."Account No.");
    end;

    procedure UpdateControls()
    begin
        if Rec.Status = Rec.Status::Pending then
            StatusEditable := true
        else
            StatusEditable := false;
    end;

    procedure CurrPageUpdate()
    begin
        xRec := Rec;
        UpdateControls;
        CurrPage.Update;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Requisition","Transport Requisition",JV,"Grant Task","Concept Note",Proposal,"Job Approval","Disciplinary Approvals",GRN,Clearence,Donation,Transfer,PayChange,Budget,GL,"Cash Purchase","Leave Reimburse",Appraisal,Inspection,Closeout,"Lab Request",ProposalProjectsAreas,"Leave Carry over","IB Transfer",EmpTransfer,LeavePlanner,HrAssetTransfer;
    begin
        //DocNoVisible := DocumentNoVisibility.FundsMgtDocumentNoIsVisible(DocType::ImprestSurrender,No);
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Imprest Surrender Details";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines."Surrender Doc No.", Rec.No);
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Imprest Surrender Details";
    begin
        AllKeyFieldsEntered := true;
        PayLines.Reset;
        PayLines.SetRange(PayLines."Surrender Doc No.", Rec.No);
        if PayLines.Find('-') then begin
            repeat
                if (PayLines."Account No:" = '') or (PayLines.Amount <= 0) then
                    AllKeyFieldsEntered := false;
            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record "Budgetary Control Setup";
        PayLine: Record "Imprest Surrender Details";
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
        PayLine.SetRange(PayLine."Surrender Doc No.", Rec.No);
        //PayLine.SETRANGE(PayLine.Committed,FALSE);
        //PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
        if PayLine.Find('-') then
            Exists := true;
    end;
}

