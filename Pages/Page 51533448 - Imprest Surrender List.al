page 51533448 "Imprest Surrender List"
{
    CardPageID = "Imprest Surrender";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approvals,Cancellation,Category6_caption,Category7_caption,Category8_caption,Approval_Details,Category10_caption';
    SourceTable = "Imprest Surrender Header";
    SourceTableView = WHERE(Status=FILTER(Pending|"Pending Approval"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                }
                field("Surrender Date";"Surrender Date")
                {
                }
                field("Account No.";"Account No.")
                {
                }
                field("Account Name";"Account Name")
                {
                }
                field("Imprest Issue Doc. No";"Imprest Issue Doc. No")
                {
                }
                field("Imprest Issue Date";"Imprest Issue Date")
                {
                }
                field(Amount;Amount)
                {
                }
                field(Status;Status)
                {
                }
                field(Cashier;Cashier)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755010;Notes)
            {
            }
            systempart(Control1102755011;MyNotes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102756004>")
            {
                Caption = 'Functions';
                action("<Action1000000001>")
                {
                    Caption = 'Cancel Document';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Post Committment Reversals
                        TestField(Status,Status::Approved);
                        if Confirm(Text002,true) then begin
                          Doc_Type:=Doc_Type::Imprest;
                          BudgetControl.ReverseEntries(Doc_Type,"Imprest Issue Doc. No");
                          Status:=Status::Cancelled;
                          Modify;
                        end;
                    end;
                }
            }
            action("<Action1102758002>")
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



                    TestField(Status,Status::Approved);

                    if Posted then
                    //ERROR('The transaction has already been posted.');

                    //HOW ABOUT WHERE ONE RETURNS ALL THE AMOUNT??
                    //THERE SHOULD BE NO GENJNL ENTRIES BUT REVERSE THE COMMITTMENTS
                    CalcFields("Actual Spent");
                    if "Actual Spent"=0 then
                        if Confirm(Text000,true) then
                          UpdateforNoActualSpent
                        else
                           Error(Text001);

                      // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                    if GenledSetup.Get then begin
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",GenledSetup."Surrender Template");
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",GenledSetup."Surrender  Batch");
                        GenJnlLine.DeleteAll;
                    end;

                    if DefaultBatch.Get(GenledSetup."Surrender Template",GenledSetup."Surrender  Batch") then begin
                         DefaultBatch.Delete;
                    end;

                    DefaultBatch.Reset;
                    DefaultBatch."Journal Template Name":=GenledSetup."Surrender Template";
                    DefaultBatch.Name:=GenledSetup."Surrender  Batch";
                    DefaultBatch.Insert;
                    LineNo:=0;

                    ImprestDetails.Reset;
                    ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.",No);
                    if ImprestDetails.Find('-') then begin
                    repeat
                    //Post Surrender Journal
                    //Compare the amount issued =amount on cash reciecied.
                    //Created new field for zero spent
                    //

                    //ImprestDetails.TESTFIELD("Actual Spent");
                    //ImprestDetails.TESTFIELD("Actual Spent");
                    if (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount then
                       Error(Txt0001);

                    TestField("Global Dimension 1 Code");

                    LineNo:=LineNo+1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name":=GenledSetup."Surrender Template";
                    GenJnlLine."Journal Batch Name":=GenledSetup."Surrender  Batch";
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Source Code":='PAYMENTJNL';
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No.":=ImprestDetails."Account No:";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    //Set these fields to blanks
                    GenJnlLine."Posting Date":="Surrender Date";
                    GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.Validate("Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group":='';
                    GenJnlLine.Validate("Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group":='';
                    GenJnlLine.Validate("Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group":='';
                    GenJnlLine.Validate("VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group":='';
                    GenJnlLine.Validate("VAT Prod. Posting Group");
                    GenJnlLine."Document No.":=No;
                    GenJnlLine.Amount:=ImprestDetails."Actual Spent";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::Customer;
                    GenJnlLine."Bal. Account No.":=ImprestDetails."Imprest Holder";
                    GenJnlLine.Description:='Imprest Surrendered by staff';
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Currency Code":="Currency Code";
                    GenJnlLine.Validate("Currency Code");
                    //Take care of Currency Factor
                      GenJnlLine."Currency Factor":="Currency Factor";
                      GenJnlLine.Validate("Currency Factor");

                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");

                    //Application of Surrender entries
                    if GenJnlLine."Bal. Account Type"=GenJnlLine."Bal. Account Type"::Customer then begin
                    GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                    GenJnlLine."Applies-to ID":="Apply to ID";
                    end;

                    if GenJnlLine.Amount<>0 then
                    GenJnlLine.Insert;

                    //Post Cash Surrender
                    if ImprestDetails."Cash Surrender Amt">0 then begin
                     if ImprestDetails."Bank/Petty Cash"='' then
                       Error('Select a Bank Code where the Cash Surrender will be posted');
                    LineNo:=LineNo+1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name":=GenledSetup."Surrender Template";
                    GenJnlLine."Journal Batch Name":=GenledSetup."Surrender  Batch";
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::Customer;
                    GenJnlLine."Account No.":=ImprestDetails."Imprest Holder";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    //Set these fields to blanks
                    GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.Validate("Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group":='';
                    GenJnlLine.Validate("Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group":='';
                    GenJnlLine.Validate("Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group":='';
                    GenJnlLine.Validate("VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group":='';
                    GenJnlLine.Validate("VAT Prod. Posting Group");
                    GenJnlLine."Posting Date":="Surrender Date";
                    GenJnlLine."Document No.":=No;
                    GenJnlLine.Amount:=-ImprestDetails."Cash Surrender Amt";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Currency Code":="Currency Code";
                    GenJnlLine.Validate("Currency Code");
                    //Take care of Currency Factor
                      GenJnlLine."Currency Factor":="Currency Factor";
                      GenJnlLine.Validate("Currency Factor");

                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"Bank Account";
                    GenJnlLine."Bal. Account No.":=ImprestDetails."Bank/Petty Cash";
                    GenJnlLine.Description:='Imprest Surrender by staff';
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                    GenJnlLine."Applies-to ID":=ImprestDetails."Imprest Holder";
                    if GenJnlLine.Amount<>0 then
                    GenJnlLine.Insert;

                    end;

                    //End Post Surrender Journal

                    until ImprestDetails.Next=0;
                    //Post Entries
                      GenJnlLine.Reset;
                      GenJnlLine.SetRange(GenJnlLine."Journal Template Name",GenledSetup."Surrender Template");
                      GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",GenledSetup."Surrender  Batch");
                    //Adjust Gen Jnl Exchange Rate Rounding Balances
                       AdjustGenJnl.Run(GenJnlLine);
                    //End Adjust Gen Jnl Exchange Rate Rounding Balances

                      CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Line",GenJnlLine);
                    end;

                    if JournalPostSuccessful.PostedSuccessfully then begin
                        Posted:=true;
                        Status:=Status::Posted;
                        "Date Posted":=Today;
                        "Time Posted":=Time;
                        "Posted By":=UserId;
                        Modify;
                    //Tag the Source Imprest Requisition as Surrendered
                       ImprestReq.Reset;
                       ImprestReq.SetRange(ImprestReq."No.","Imprest Issue Doc. No");
                       if ImprestReq.Find('-') then begin
                         ImprestReq."Surrender Status":=ImprestReq."Surrender Status"::Full;
                         ImprestReq.Modify;
                       end;

                    //End Tag
                     //Post Committment Reversals
                    Doc_Type:=Doc_Type::Imprest;
                    BudgetControl.ReverseEntries(Doc_Type,"Imprest Issue Doc. No");
                    end;
                end;
            }
            action("<Action1102758001>")
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Reset;
                    SetFilter(No,No);
                    //50025
                    REPORT.Run(51533320,true,true,Rec);
                    Reset;
                end;
            }
            action("<Action1102760000>")
            {
                Caption = 'Get Imprest Document';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if "Imprest Issue Doc. No"='' then
                       Error('Please Select the Imprest Issue Document Number');

                    PaymentLine.Reset;
                    PaymentLine.SetRange(PaymentLine.No,"Imprest Issue Doc. No");
                    PAGE.RunModal(39006085,PaymentLine);
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
                    begin
                        VarVariant := Rec;
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                          CustomApprovals.OnSendDocForApproval(VarVariant);
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
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
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
                        ApprovalsMgmt.OpenApprovalEntriesPage(RecordId);

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
            ImprestHdr.SetRange(ImprestHdr.Cashier,UserId);
            ImprestHdr.SetRange(ImprestHdr.Status,Status::Pending);

            if ImprestHdr.Count>0 then
              begin
                Error('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
              end;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FilterGroup(0);
        end;
        SetFilter(Cashier,UserId);
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
        Commitments: Record Committments;
        BCSetup: Record "Budgetary Control Setup";
        BudgetControl: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        ImprestReq: Record "Imprest Header";
        UserMgt: Codeunit "User Setup Management BR";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AccountName: Text[100];
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
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
        Text000: Label 'You have not specified the Actual Amount Spent. This document will only reverse the committment and you will have to receipt the total amount returned.';
        Text001: Label 'Document Not Posted';
        Text002: Label 'Are you sure you want to Cancel this Document?';
        Text19053222: Label 'Enter Advance Accounting Details below';
        "NOT OpenApprovalEntriesExist": Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approval Management";
        ImprestHdr: Record "Imprest Surrender Header";

    procedure GetDimensionName(var "Code": Code[20];DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
    begin
        /*Get the global dimension 1 and 2 from the database*/
        Name:='';
        
        GLSetup.Reset;
        GLSetup.Get();
        
        DimVal.Reset;
        DimVal.SetRange(DimVal.Code,Code);
        
        if DimNo=1 then
          begin
            DimVal.SetRange(DimVal."Dimension Code",GLSetup."Global Dimension 1 Code"  );
          end
        else if DimNo=2 then
          begin
            DimVal.SetRange(DimVal."Dimension Code",GLSetup."Global Dimension 2 Code");
          end;
        if DimVal.Find('-') then
          begin
            Name:=DimVal.Name;
          end;

    end;

    procedure UpdateControl()
    begin
          if Status<>Status::Pending then begin
           "Surrender DateEditable" :=false;
           "Account No.Editable" :=false;
           "Imprest Issue Doc. NoEditable" :=false;
           "Responsibility CenterEditable" :=false;
           ImprestLinesEditable :=false;
          end else begin
           "Surrender DateEditable" :=true;
           "Account No.Editable" :=true;
           "Imprest Issue Doc. NoEditable" :=true;
           "Responsibility CenterEditable" :=true;
           ImprestLinesEditable :=true;

          end;
    end;

    procedure GetCustName(No: Code[20]) Name: Text[100]
    var
        Cust: Record Customer;
    begin
        Name:='';
        if Cust.Get(No) then
           Name:=Cust.Name;
           exit(Name);
    end;

    procedure UpdateforNoActualSpent()
    begin
          Posted:=true;
          Status:=Status::Posted;
          "Date Posted":=Today;
          "Time Posted":=Time;
          "Posted By":=UserId;
          Modify;
        //Tag the Source Imprest Requisition as Surrendered
           ImprestReq.Reset;
           ImprestReq.SetRange(ImprestReq."No.","Imprest Issue Doc. No");
           if ImprestReq.Find('-') then begin
             ImprestReq."Surrender Status":=ImprestReq."Surrender Status"::Full;
             ImprestReq.Modify;
           end;
        //End Tag
        //Post Committment Reversals
        Doc_Type:=Doc_Type::Imprest;
        BudgetControl.ReverseEntries(Doc_Type,"Imprest Issue Doc. No");
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
        DimName1:=GetDimensionName("Global Dimension 1 Code",1);
        DimName2:=GetDimensionName("Shortcut Dimension 2 Code",2);
        AccountName:=GetCustName("Account No.");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;
}

