page 51533460 "Staff Advance Surrender List"
{
    Caption = 'Petty Cash Surrender List';
    CardPageID = "Staff Advance Surrender";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Approval_Details,Category10_caption';
    SourceTable = "Staff Advance Surrender Header";
    SourceTableView = WHERE(Posted = CONST(false),
                            Status = FILTER(Pending | "Pending Approval"));

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field(No; Rec.No)
                {
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {
                }
                field("Surrender Date"; Rec."Surrender Date")
                {
                }
                field("User ID"; Rec."User ID")
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
                field(Amount; Rec.Amount)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field(Surrendered; Rec.Surrendered)
                {
                }
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
                action(Post)
                {
                    Caption = 'Post';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        Txt0001: Label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);
                        Rec.TestField("Surrender Posting Date");


                        if Rec.Posted then
                            Error('The transaction has already been posted.');

                        //Ensure actual spent does not exceed the amount on original document
                        Rec.CalcFields("Actual Spent", "Cash Receipt Amount");
                        if (Rec."Actual Spent" + Rec."Cash Receipt Amount") < Rec.Amount then
                            Error('Please select the receipt used to receipt money not actually spent');

                        //test that any modifications to the document do not exceed the amount on origina document
                        Rec.CalcFields("Actual Spent");
                        //IF "Actual Spent"<>"Amount on Original Document" THEN ERROR('The amount on the original document differs from the current actual amount spent by  %1',("Actual Spent"-"Amount on Original Document"));

                        //Get the Cash office user template
                        Temp.Get(UserId);
                        SurrBatch := Temp."Advance Surr Batch";
                        SurrTemplate := Temp."Advance Surr Template";


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
                            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", SurrTemplate);
                            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", SurrBatch);
                            GenJnlLine.DeleteAll;
                        end;

                        if DefaultBatch.Get(SurrTemplate, SurrBatch) then begin
                            DefaultBatch.Delete;
                        end;

                        DefaultBatch.Reset;
                        DefaultBatch."Journal Template Name" := SurrTemplate;
                        DefaultBatch.Name := SurrBatch;
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

                                //ImprestDetails.Rec.TestField("Actual Spent");
                                //ImprestDetails.Rec.TestField("Actual Spent");
                                /*
                                IF (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount THEN
                                   ERROR(Txt0001);
                                       */
                                Rec.TestField("Global Dimension 1 Code");


                                LineNo := LineNo + 1000;
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := SurrTemplate;
                                GenJnlLine."Journal Batch Name" := SurrBatch;
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Source Code" := 'PAYMENTJNL';
                                RecPayTypes.Get(ImprestDetails."Imprest Type", RecPayTypes.Type::Advance);
                                //GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                                GenJnlLine."Account Type" := RecPayTypes."Account Type";
                                GenJnlLine."Account No." := ImprestDetails."Account No:";
                                GenJnlLine.Validate(GenJnlLine."Account No.");
                                //Set these fields to blanks
                                GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
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
                                //GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::Customer;
                                //GenJnlLine."Bal. Account No.":=ImprestDetails."Advance Holder";
                                GenJnlLine.Description := CopyStr('Advance Surrendered ' + ImprestDetails."Account Name", 1, 50);
                                //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.Validate("Currency Code");
                                //Take care of Currency Factor
                                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                                GenJnlLine.Validate("Currency Factor");

                                GenJnlLine."Shortcut Dimension 1 Code" := ImprestDetails."Shortcut Dimension 1 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := ImprestDetails."Shortcut Dimension 2 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine."Dimension Set ID" := ImprestDetails."Dimension Set ID";

                                //Application of Surrender entries
                                if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer then begin
                                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                    //GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
                                    PVHeader.Reset;
                                    PVHeader.SetRange(PVHeader."Creation Doc No.", Rec."Imprest Issue Doc. No");
                                    PVHeader.SetRange(PVHeader.Status, PVHeader.Status::Posted);
                                    PVHeader.FindFirst;
                                    GenJnlLine."Applies-to Doc. No." := PVHeader."No.";
                                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                                    GenJnlLine."Applies-to ID" := Rec."Apply to ID";
                                end;

                                if GenJnlLine.Amount <> 0 then
                                    GenJnlLine.Insert;

                                //insert balancing customer Entries

                                LineNo := LineNo + 1000;
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := SurrTemplate;
                                GenJnlLine."Journal Batch Name" := SurrBatch;
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Source Code" := 'PAYMENTJNL';
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                GenJnlLine."Account No." := ImprestDetails."Advance Holder";
                                ;
                                GenJnlLine.Validate(GenJnlLine."Account No.");
                                //Set these fields to blanks
                                GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
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
                                /*
                                //used no more raise staff claim instead
                                Rec.CalcFields(Difference);
                                IF Difference < 0 THEN
                                  GenJnlLine.Amount:=-ImprestDetails.Amount
                                ELSE
                                */
                                GenJnlLine.Amount := -ImprestDetails."Actual Spent";
                                GenJnlLine.Validate(GenJnlLine.Amount);
                                //GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::Customer;
                                //GenJnlLine."Bal. Account No.":=ImprestDetails."Advance Holder";
                                GenJnlLine.Description := CopyStr('Advance Surrendered ' + ImprestDetails."Account Name", 1, 50);
                                //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.Validate("Currency Code");
                                //Take care of Currency Factor
                                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                                GenJnlLine.Validate("Currency Factor");

                                GenJnlLine."Shortcut Dimension 1 Code" := ImprestDetails."Shortcut Dimension 1 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := ImprestDetails."Shortcut Dimension 2 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine."Dimension Set ID" := ImprestDetails."Dimension Set ID";

                                //Application of Surrender entries
                                if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer then begin
                                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                    PVHeader.Reset;
                                    PVHeader.SetRange(PVHeader."Creation Doc No.", Rec."Imprest Issue Doc. No");
                                    PVHeader.SetRange(PVHeader.Status, PVHeader.Status::Posted);
                                    PVHeader.FindFirst;
                                    GenJnlLine."Applies-to Doc. No." := PVHeader."No.";
                                    //GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
                                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                                    GenJnlLine."Applies-to ID" := Rec."Apply to ID";
                                end;

                                if GenJnlLine.Amount <> 0 then
                                    GenJnlLine.Insert;

                            until ImprestDetails.Next = 0;
                            /*
                            //used no more
                            //insert balancing bank Entries
                            Rec.CalcFields(Difference);
                            IF Difference < 0 THEN
                            InsertBankBalancing;
                            */
                            //Post Entries
                            GenJnlLine.Reset;
                            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", SurrTemplate);
                            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", SurrBatch);
                            //Adjust Gen Jnl Exchange Rate Rounding Balances
                            AdjustGenJnl.Run(GenJnlLine);
                            //End Adjust Gen Jnl Exchange Rate Rounding Balances

                            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Line", GenJnlLine);
                        end;

                        if JournalPostSuccessful.PostedSuccessfully then begin
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
                            Doc_Type := Doc_Type::StaffSurrender;
                            BudgetControl.ReverseEntries(Doc_Type, Rec.No);
                        end;
                        Commit;
                        if Rec.Posted = true then begin
                            //insert balancing bank Entries
                            Rec.CalcFields(Difference);
                            if Rec.Difference < 0 then
                                CreateStaffClaim;
                        end

                    end;
                }
                separator(Separator1102755022)
                {
                }
                action("Check Budgetary Availability")
                {
                    Caption = 'Check Budgetary Availability';
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Ensure actual spent does not exceed the amount on original document
                        Rec.CalcFields("Actual Spent", "Cash Receipt Amount");
                        if Rec."Actual Spent" + Rec."Cash Receipt Amount" > Rec.Amount then
                            Error('The actual Amount spent should not exceed the amount issued ');

                        //Post Committment Reversals of the Staff Advance if it had not been reversed
                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffAdvance);
                        Commitments.SetRange(Commitments."Document No.", Rec."Imprest Issue Doc. No");
                        Commitments.SetRange(Commitments.Committed, false);
                        if not Commitments.Find('-') then begin
                            Doc_Type := Doc_Type::StaffAdvance;
                            BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
                        end;

                        //First Check whether other lines are already committed.
                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffSurrender);
                        Commitments.SetRange(Commitments."Document No.", Rec.No);
                        if Commitments.Find('-') then begin
                            if Confirm('Lines in this Document appear to be committed do you want to re-commit?', false) = false then begin exit end;
                            Commitments.Reset;
                            Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffSurrender);
                            Commitments.SetRange(Commitments."Document No.", Rec.No);
                            Commitments.DeleteAll;
                        end;

                        //Check the Budget here
                        //    CheckBudgetAvail.CheckStaffAdvSurr(Rec);
                    end;
                }
                action("Cancel Budgetary Allocation")
                {
                    Caption = 'Cancel Budgetary Allocation';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Do you Wish to Cancel the Commitment entries for this document', false) = false then begin exit end;

                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffSurrender);
                        Commitments.SetRange(Commitments."Document No.", Rec.No);
                        Commitments.DeleteAll;

                        Payline.Reset;
                        Payline.SetRange(Payline."Surrender Doc No.", Rec.No);
                        if Payline.Find('-') then begin
                            repeat
                                Payline.Committed := false;
                                Payline.Modify;
                            until Payline.Next = 0;
                        end;
                    end;
                }
                separator(Separator1102755012)
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
                    begin
                        //Post Committment Reversals
                        Rec.TestField(Status, Rec.Status::Approved);
                        if Confirm(Text002, true) then begin
                            Doc_Type := Doc_Type::Imprest;
                            BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
                            Rec.Status := Rec.Status::Cancelled;
                            Rec.Modify;
                        end;
                    end;
                }
                separator(Separator1102755008)
                {
                }
                action("Open for OverExpenditure")
                {
                    Caption = 'Open for OverExpenditure';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //Opening should only be for Pending Documents
                        //Rec.TestField(Status,Rec.Status::Pending);
                        //Open for Overexpenditure
                        Rec."Allow Overexpenditure" := true;
                        Rec."Open for Overexpenditure by" := UserId;
                        Rec."Date opened for OvExpenditure" := Today;
                        Rec.Modify;
                        //Open lines
                        Payline.Reset;
                        Payline.SetRange(Payline."Surrender Doc No.", Rec.No);
                        if Payline.Find('-') then begin
                            repeat
                                Payline."Allow Overexpenditure" := true;
                                Payline."Open for Overexpenditure by" := UserId;
                                Payline."Date opened for OvExpenditure" := Today;
                                Payline.Modify;
                            until Payline.Next = 0;
                        end;
                        //End open for Overexpenditure
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
                        if Rec.Status <> Rec.Status::Approved then Error('You can only print approved documents');
                        Rec.Reset;
                        Rec.SetFilter(No, Rec.No);
                        REPORT.Run(39005880, true, true, Rec);
                        Rec.Reset;
                    end;
                }
                action(Upload)
                {
                    Image = TransmitElectronicDoc;

                    trigger OnAction()
                    var
                        vartest: Variant;
                        TestFile: File;
                        FilePath: Text;
                        FileName: Text;
                        DocNo: Code[20];
                        varLink: Text;
                        DocRecRef: RecordRef;
                        MyFieldRef: FieldRef;
                        LinkId: Integer;
                        CopyFrom: Text;
                        CopyTo: Text;
                    begin
                        if Upload('Upload file', 'C:\', 'Text file(*.txt)|*.txt|PDF file(*.pdf)|*.pdf|EXCEL File(*.xlsx)|*.xlsx|WORD File(*.docx)|*.docx|ALL Files(*.*)|*.*', 'Upload.txt', vartest) then begin
                            Message('File successfully uploaded to the server', vartest);
                            //TestFile.OPEN(vartest);
                            //FileName:=TestFile.NAME;
                            //MESSAGE('%1',FileName);

                            DocNo := Rec.No;
                            DocRecRef.Open(DATABASE::"Staff Advance Surrender Header");
                            MyFieldRef := DocRecRef.Field(1);
                            MyFieldRef.Value := DocNo;
                            if DocRecRef.Find('=') then begin
                                LinkId := DocRecRef.AddLink(vartest);
                                RecordLinks.Get(LinkId);
                                RecordLinks.Validate(Type);
                                //  MESSAGE('link %1 added successfully',LinkId);
                                /*
                                //taken to record links table for server side processing
                                RecordLinks.GET(LinkId);
                                CopyFrom:=RecordLinks.URL1;
                                FileName:=GetFileName(RecordLinks.URL1);
                                CopyTo:='C:\NavAttachments\'+FileName;
                                FILE.COPY(CopyFrom,CopyTo);
                                RecordLinks.URL1:=CopyTo;
                                RecordLinks.Description:=FileName;
                                RecordLinks.MODIFY;
                                */
                            end
                            else
                                Message('Link not added');

                        end
                        else
                            Error('File not Successfully uploaded');

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
                        //   CustomApprovals.OnSendDocForApproval(VarVariant);
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

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        //check if the documenent has been added while another one is still pending
        TravAccHeader.Reset;
        //TravAccHeader.SETRANGE(SaleHeader."Document Type",SaleHeader."Document Type"::"Cash Sale");
        TravAccHeader.SetRange(TravAccHeader.Cashier, UserId);
        TravAccHeader.SetRange(TravAccHeader.Status, Rec.Status::Pending);

        if TravAccHeader.Count > 0 then begin
            Error('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
        end;
        //*********************************
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;


        /**if UserMgt.GetSetDimensions(UserId, 2) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Global Dimension 2 Code", UserMgt.GetSetDimensions(UserId, 2));
            Rec.FilterGroup(0);
        end;
        Rec.SetFilter(Cashier, UserId);**/
    end;

    var
        Text000: Label 'You have not specified the Actual Amount Spent. This document will only reverse the committment and you will have to receipt the total amount returned.';
        Text001: Label 'Document Not Posted';
        Text002: Label 'Are you sure you want to Cancel this Document?';
        Text19053222: Label 'Enter Advance Accounting Details below';
        RecPayTypes: Record "Receipts and Payment Types";
        TarriffCodes: Record "Tariff Codes";
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record "Cash Office User Template";
        LineNo: Integer;
        NextEntryNo: Integer;
        CommitNo: Integer;
        ImprestDetails: Record "Staff Advanc Surrender Details";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        IsImprest: Boolean;
        GenledSetup: Record "Cash Office Setup";
        ImprestAmt: Decimal;
        DimName1: Text[60];
        DimName2: Text[60];
        CashPaymentLine: Record "Payment Line";
        PaymentLine: Record "Staff Advance Lines";
        CurrSurrDocNo: Code[20];
        JournalPostSuccessful: Codeunit "Journal Post Successful";
        Commitments: Record Committments;
        BCSetup: Record "Budgetary Control Setup";
        BudgetControl: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender;
        ImprestReq: Record "Staff Advance Header";
        UserMgt: Codeunit "User Setup Management";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AccountName: Text[100];
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        TravAccHeader: Record "Staff Advance Surrender Header";
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Payline: Record "Staff Advanc Surrender Details";
        Temp: Record "Cash Office User Template";
        SurrBatch: Code[10];
        SurrTemplate: Code[10];
        [InDataSet]
        "Surrender DateEditable": Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;
        [InDataSet]
        "Imprest Issue Doc. NoEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        "Surrender Posting DateEditable": Boolean;
        [InDataSet]
        ImprestLinesEditable: Boolean;
        StatusEditable: Boolean;
        RecRef: RecordRef;
        RecordLinks: Record "Record Link";
        FileName: Text;
        PVHeader: Record "Payments Header";
        "NOT OpenApprovalEntriesExist": Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
    //CustomApprovals: Codeunit "Custom Approval Management";

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

    procedure UpdateControls()
    begin
        if Rec.Status <> Rec.Status::Pending then begin
            "Surrender DateEditable" := false;
            "Account No.Editable" := false;
            "Imprest Issue Doc. NoEditable" := false;
            "Responsibility CenterEditable" := true;
            "Surrender Posting DateEditable" := true;
            //   ImprestLinesEditable :=FALSE;
        end else begin
            "Surrender DateEditable" := true;
            "Account No.Editable" := true;
            "Imprest Issue Doc. NoEditable" := true;
            "Responsibility CenterEditable" := true;
            "Surrender Posting DateEditable" := false;
            //   ImprestLinesEditable :=TRUE;

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
        Doc_Type := Doc_Type::StaffSurrender;
        BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
    end;

    procedure CompareAllAmounts()
    begin
    end;

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
        Payline.Reset;
        Payline.SetRange(Payline."Surrender Doc No.", Rec.No);
        Payline.SetRange(Payline.Committed, false);
        Payline.SetRange(Payline."Budgetary Control A/C", true);
        if Payline.Find('-') then
            Exists := true;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        /*
        xRec := Rec;
        //Update Controls as necessary
        //SETFILTER(Status,'<>Cancelled');
        UpdateControl;
        DimName1:=GetDimensionName("Global Dimension 1 Code",1);
        DimName2:=GetDimensionName("Global Dimension 2 Code",2);
        AccountName:=GetCustName("Account No.");
        */

    end;

    procedure CurrPageUpdate()
    begin
        xRec := Rec;
        UpdateControls;
        AccountName := GetCustName(Rec."Account No.");
        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
        DimName2 := GetDimensionName(Rec."Global Dimension 2 Code", 2);
        CurrPage.Update;
    end;

    procedure InsertBalancing()
    begin
        //insert customer balancing
        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := SurrTemplate;
        GenJnlLine."Journal Batch Name" := SurrBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Rec."Account No.";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        //Set these fields to blanks
        GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
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
        //Rec.Rec.CalcFields(Difference);
        GenJnlLine.Amount := -Rec.Amount;//ImprestDetails."Actual Spent";
        GenJnlLine.Validate(GenJnlLine.Amount);
        //GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::Customer;
        //GenJnlLine."Bal. Account No.":=ImprestDetails."Advance Holder";
        GenJnlLine.Description := 'Advance Surrendered by staff';
        //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        //Take care of Currency Factor
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");

        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Global Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        //Application of Surrender entries
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer then begin
            //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
            //GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
            PVHeader.Reset;
            PVHeader.SetRange(PVHeader."Creation Doc No.", Rec."Imprest Issue Doc. No");
            PVHeader.SetRange(PVHeader.Status, PVHeader.Status::Posted);
            PVHeader.FindFirst;
            GenJnlLine."Applies-to Doc. No." := PVHeader."No.";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID" := Rec."Apply to ID";
        end;

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;
    end;

    procedure InsertBankBalancing()
    begin

        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := SurrTemplate;
        GenJnlLine."Journal Batch Name" := SurrBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := Rec."Bank Code";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        //Set these fields to blanks
        GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
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
        GenJnlLine."External Document No." := ImprestDetails."Cash Receipt No";
        Rec.CalcFields(Rec.Difference);
        GenJnlLine.Amount := Rec.Difference;
        GenJnlLine.Validate(GenJnlLine.Amount);
        //GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::Customer;
        //GenJnlLine."Bal. Account No.":=ImprestDetails."Advance Holder";
        GenJnlLine.Description := 'Advance Surrendered by staff';
        //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        //Take care of Currency Factor
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");

        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Global Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        //Application of Surrender entries
        if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer then begin
            //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
            //GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
            PVHeader.Reset;
            PVHeader.SetRange(PVHeader."Creation Doc No.", Rec."Imprest Issue Doc. No");
            PVHeader.SetRange(PVHeader.Status, PVHeader.Status::Posted);
            PVHeader.FindFirst;
            GenJnlLine."Applies-to Doc. No." := PVHeader."No.";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID" := Rec."Apply to ID";
        end;

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;
    end;

    procedure CreateStaffClaim()
    var
        SClaimHdr: Record "Staff Claims Header";
        SClaimLines: Record "Staff Claim Lines";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenLedgerSetup: Record "Cash Office Setup";
    begin
        GenLedgerSetup.Get;
        SClaimHdr.Init;
        SClaimHdr."No." := NoSeriesMgt.GetNextNo(GenLedgerSetup."Staff Claim No.", Today, true);
        SClaimHdr.Date := Today;
        SClaimHdr.Cashier := UserId;
        SClaimHdr."Account Type" := "Account Type"::Customer;
        SClaimHdr.Validate("Account No.", Rec."Account No.");
        //SClaimHdr.Payee := Payee;
        SClaimHdr."Responsibility Center" := Rec."Responsibility Center";
        SClaimHdr.Validate("Global Dimension 1 Code", Rec."Global Dimension 1 Code");
        SClaimHdr.Validate("Shortcut Dimension 2 Code", Rec."Global Dimension 2 Code");
        SClaimHdr."Dimension Set ID" := Rec."Dimension Set ID";
        SClaimHdr.Purpose := 'Advance ' + Rec.No + ' Over Expenditure Claim';
        SClaimHdr."Creation Doc No" := Rec.No;
        SClaimHdr.Status := SClaimHdr.Status::Approved;
        SClaimHdr.Insert();

        SClaimLines.Init;
        SClaimLines."Line No." := Payline."Line No.";
        SClaimLines.No := SClaimHdr."No.";
        SClaimLines."Account Type" := SClaimLines."Account Type"::Customer;
        SClaimLines."Account No:" := Rec."Account No.";
        SClaimLines."Account Name" := 'Advance ' + Rec.No + ' Over Expenditure Claim';
        SClaimLines.Amount := -Rec.Difference;
        SClaimLines."Global Dimension 1 Code" := Payline."Shortcut Dimension 1 Code";
        SClaimLines."Shortcut Dimension 2 Code" := Payline."Shortcut Dimension 2 Code";
        SClaimLines."Dimension Set ID" := Payline."Dimension Set ID";
        SClaimLines.Purpose := 'Advance ' + Rec.No + ' Over Expenditure Claim';
        SClaimLines.Insert(true);

        Message('Staff Claim %1 automatically created and approved, Please post it to effect payment to the staff %2', SClaimHdr."No.", Rec.Payee);
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Payment Line";
    begin
        AllKeyFieldsEntered := true;
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec.No);
        if PayLines.Find('-') then begin
            repeat
                if (PayLines."Account No." = '') or (PayLines.Amount <= 0) then
                    AllKeyFieldsEntered := false;
            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Staff Advanc Surrender Details";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines."Surrender Doc No.", Rec.No);
        if PayLines.Find('-') then
            repeat
                PayLines.TestField(PayLines."Amount LCY");
                HasLines := true;
                exit(HasLines);
            until PayLines.Next = 0;
    end;
}

