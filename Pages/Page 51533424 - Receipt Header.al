page 51533424 "Receipt Header"
{
    DeleteAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Receipts Header";
    SourceTableView = WHERE("Receipt Type" = CONST(Bank));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                }
                field(Date; Rec.Date)
                {
                    //Editable = StatusEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    //Editable = StatusEditable;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Department Code';
                    //Editable = StatusEditable;

                    trigger OnValidate()
                    begin
                        FunctionName := '';
                        DimVal.Reset;
                        DimVal.SetRange(DimVal."Global Dimension No.", 1);
                        DimVal.SetRange(DimVal.Code, Rec."Global Dimension 1 Code");
                        if DimVal.Find('-') then begin
                            FunctionName := DimVal.Name;
                        end;
                    end;
                }
                /*field(FunctionName; Rec.FunctionName)
                {
                    Caption = 'Description';
                    Editable = false;
                } **/
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Division Code';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    //Editable = StatusEditable;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    //Editable = StatusEditable;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    //Editable = StatusEditable;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                }
                field("Amount Recieved"; Rec."Amount Recieved")
                {
                    //Editable = StatusEditable;
                }
                field("Received From"; Rec."Received From")
                {
                    //Editable = StatusEditable;
                }
                field(Description; Rec.Description)
                {
                }
                field("Total Amount"; Rec."Total Amount")
                {
                }
                field("PIN No"; Rec."PIN No")
                {
                }
                field("Tender No"; Rec."Tender No")
                {
                }
                field(Year; Rec.Year)
                {
                }
                field(TenderReceipt; Rec.TenderReceipt)
                {
                    Editable = false;
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                }
            }
            part(Control1000000000; "Receipts Line")
            {
                //Editable = StatusEditable;
                SubPageLink = No = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Rec.Posted = false then Error('Post the receipt before printing.');
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(51533321, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    //Check Post Dated
                    if CheckPostDated then
                        Error('One of the Receipt Lines is Post Dated');


                    //Update Bidder Details Here
                    UpdateBidderDetails();
                    //End Update Bidder Details

                    //Post the transaction into the database
                    PerformPost();
                end;
            }
            action(PostPrint)
            {
                Caption = 'Post & Print';
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+F9';

                trigger OnAction()
                begin
                    //Check Post Dated
                    if CheckPostDated then
                        Error('One of the Receipt Lines is Post Dated');


                    //Update Bidder Details Here
                    UpdateBidderDetails();
                    //End Update Bidder Details

                    //Post the transaction into the database
                    PerformPost();
                    Commit;
                    if Rec.Posted = false then Error('Post the receipt before printing.');
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(51533321, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action(PostEmail)
            {
                Caption = 'Post & Email';
                Image = PostMail;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+F9';

                trigger OnAction()
                var
                    Cust: Record Customer;
                    MyRecordRef: RecordRef;
                    MyFieldRef: FieldRef;
                    EmailMgt: Codeunit prPayrollProcessing;
                    ReceiptLine: Record "Receipt Line";
                begin
                    begin
                        //Check Post Dated
                        if CheckPostDated then
                            Error('One of the Receipt Lines is Post Dated');

                        //Update Bidder Details Here
                        UpdateBidderDetails();
                        //End Update Bidder Details

                        //Post the transaction into the database
                        PerformPost();
                        Commit;
                        if Rec.Posted = false then Error('Post the receipt before printing.');

                        if Confirm('Do you want to print the report?', false) then
                            REPORT.Run(39005883, false, false, Rec);

                        ReceiptLine.Reset;
                        ReceiptLine.SetRange(No, Rec."No.");
                        ReceiptLine.SetRange("Account Type", ReceiptLine."Account Type"::Customer);
                        if not ReceiptLine.FindFirst then exit;
                        Cust.Get(ReceiptLine."Account No.");

                        MyRecordRef.Open(39005499);
                        MyFieldRef := MyRecordRef.Field(1); // Document no.
                        MyFieldRef.SetRange(Rec."No.");
                        MyRecordRef.Find('-');

                        // EmailMgt.SendEmail(Cust."E-Mail",39005883,MyRecordRef,FORMAT('Receipt : '+"No."));
                        MyRecordRef.Close;
                    end
                end;
            }
            action("Import Lines")
            {
                Caption = 'Import Lines';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = XMLport Receipt;

                trigger OnAction()
                var
                    Cust: Record Customer;
                    MyRecordRef: RecordRef;
                    MyFieldRef: FieldRef;
                    EmailMgt: Codeunit prPayrollProcessing;
                    ReceiptLine: Record "Receipt Line";
                begin
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
        CurrPageUpdate;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //********************************JACK**********************************//

        Rcpt.Reset;
        Rcpt.SetRange(Rcpt.Posted, false);
        Rcpt.SetRange(Rcpt."Created By", UserId);
        if Rcpt.Count > 0 then begin
            if Confirm('There are still some unposted receipts. Continue?', false) = false then begin
                Error('There are still some unposted receipts. Please utilise them first');
            end;
        end;

        //********************************END **********************************//
        //CurrPage.UPDATE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetSalesFilter();
        //Add dimensions if set by default here
        //Rec."Global Dimension 1 Code":=UserMgt.GetSetDimensions(UserId,1);
        //Rec."Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(UserId,2);
        //Rec."Shortcut Dimension 3 Code":=UserMgt.GetSetDimensions(UserId,3);
        Rec.Validate("Shortcut Dimension 3 Code");
        //Rec."Shortcut Dimension 4 Code":=UserMgt.GetSetDimensions(UserId,4);
        Rec.Validate("Shortcut Dimension 4 Code");
        Rec.Status := Rec.Status::" ";
        Rec."Receipt Type" := Rec."Receipt Type"::Bank;

        UpdateControls;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin

        UserSetup.Reset;

        if UserSetup.Get(UserId) then begin
            JTemplate := UserSetup."Receipt Journal Template";
            JBatch := UserSetup."Receipt Journal Batch";
        end;
        if (JTemplate = '') or (JBatch = '') then begin
            //ERROR('Please contact the system administrator to be setup as a receipting user');
        end;
        if UserSetup."Default Receipts Bank" = '' then begin
            //ERROR('Please contact the system administrator to be setup as a receipting user');
        end;

        //***************************JACK***************************//
        //  SETRANGE("Created By",USERID);
        if UserMgt.GetSalesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter());
            Rec.FilterGroup(0);
        end;

        //***************************END ***************************//
        //SetDocNoVisible;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        ReceiptLine: Record "Receipt Line";
        tAmount: Decimal;
        DefaultBatch: Record "Gen. Journal Batch";
        FunctionName: Text[100];
        BudgetCenterName: Text[100];
        BankName: Text[100];
        Rcpt: Record "Receipts Header";
        RcptNo: Code[20];
        DimVal: Record "Dimension Value";
        BankAcc: Record "Bank Account";
        UserSetup: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        GLine: Record "Gen. Journal Line";
        LineNo: Integer;
        BAmount: Decimal;
        SRSetup: Record "Sales & Receivables Setup";
        PCheck: Codeunit prPayrollProcessing;
        Post: Boolean;
        USetup: Record "Cash Office User Template";
        RegMgt: Codeunit prPayrollProcessing;
        RegisterNumber: Integer;
        FromNumber: Integer;
        ToNumber: Integer;
        StrInvoices: Text[250];
        UserMgt: Codeunit "User Setup Management";
        JournalPosted: Codeunit "Journal Post Successful";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        IsCashAccount: Boolean;
        [InDataSet]
        StatusEditable: Boolean;
        DocNoVisible: Boolean;

    procedure PerformPost()
    begin
        //get all the invoices that have been paid for using the receipt
        /*
        StrInvoices:='';
        Appl.RESET;
        Appl.SETRANGE(Appl."Document Type",Appl."Document Type"::"1");
        Appl.SETRANGE(Appl."Document No.","No.");
        IF Appl.FINDFIRST THEN
          BEGIN
            REPEAT
              StrInvoices:=StrInvoices + ',' + Appl."Appl. Doc. No";
            UNTIL Appl.NEXT=0;
          END;
        */
        //Cater for Cash Accounts
        IsCashAccount := false;
        BankAcc.Reset;
        if BankAcc.Get(Rec."Bank Code") then begin
            if BankAcc."Bank Type" = BankAcc."Bank Type"::Cash then
                IsCashAccount := true;
        end;

        //IF IsCashAccount THEN
        //TESTFIELD(Date,WORKDATE);
        //End Cater for Cash Account


        USetup.Reset;
        USetup.SetRange(USetup.UserID, UserId);
        if USetup.FindFirst then begin
            if USetup."Receipt Journal Template" = '' then begin
                Error('Please ensure that the Administrator sets you up as a cashier');
            end;
            if USetup."Receipt Journal Batch" = '' then begin
                Error('Please ensure that the Administrator sets you up as a cashier');
            end;
            if USetup."Default Receipts Bank" = '' then begin
                Error('Please ensure that the Administrator sets you up as a cashier');
            end;
        end
        else begin
            Error('Please ensure that the Administrator sets you up as a cashier');
        end;

        JTemplate := USetup."Receipt Journal Template";
        JBatch := USetup."Receipt Journal Batch";

        //check if the receipt has any post dated cheques.
        //check if the amounts are similar

        Rec.CalcFields("Total Amount");
        if Rec."Total Amount" <> Rec."Amount Recieved" then begin
            Error('Please note that the Total Amount and the Amount Received Must be the same');
        end;

        //if any then the amount to be posted must be less the post dated amount
        if Rec.Posted = true then begin
            Error('A Transaction Posted cannot be posted again');
        end;

        //check if the person received from has been selected
        Rec.TestField(Date);
        Rec.TestField("Bank Code");
        Rec.TestField("Global Dimension 1 Code");
        Rec.TestField("Shortcut Dimension 2 Code");
        Rec.TestField("Received From");
        /*Check if the amount received is equal to the total amount*/
        tAmount := 0;

        //Check Bank
        CheckBnkCurrency(Rec."Bank Code", Rec."Currency Code");

        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
        if ReceiptLine.Find('-') then begin
            repeat
                if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::" " then
                    Error('Paymode is Mandatory on the Receipt Line');

                if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::"Deposit Slip" then begin
                    if ReceiptLine."Cheque/Deposit Slip No" = '' then begin
                        Error('The Cheque/Deposit Slip No must be inserted');
                    end;
                    if ReceiptLine."Cheque/Deposit Slip Date" = 0D then begin
                        Error('The Cheque/Deposit Date must be inserted');
                    end;
                    if ReceiptLine."Transaction No." = '' then begin
                        Error('Please ensure that the Transaction Number is inserted');
                    end;
                    if ReceiptLine.Type = '' then
                        Error('Please ensure that the Receipt Type is inserted');

                end;

                if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::Cheque then begin
                    if ReceiptLine."Cheque/Deposit Slip No" = '' then begin
                        Error('The Cheque/Deposit Slip No must be inserted');
                    end;
                    if ReceiptLine."Cheque/Deposit Slip Date" = 0D then begin
                        Error('The Cheque/Deposit Date must be inserted');
                    end;
                    /*
                    IF ReceiptLine."Pay Mode"=ReceiptLine."Pay Mode"::Cheque THEN
                      BEGIN
                        IF STRLEN(ReceiptLine."Cheque/Deposit Slip No")<>6 THEN
                          BEGIN
                            ERROR ('Invalid Cheque Number inserted');
                          END;
                      END;
                    */
                end;
                tAmount := tAmount + ReceiptLine.Amount;
            until ReceiptLine.Next = 0;
        end;



        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        GenJnlLine.DeleteAll;

        if DefaultBatch.Get(JTemplate, JBatch) then
            DefaultBatch.Delete;

        DefaultBatch.Reset;
        DefaultBatch."Journal Template Name" := JTemplate;
        DefaultBatch.Name := JBatch;
        DefaultBatch.Insert;

        /*Insert the bank transaction*/
        if BAmount < tAmount then begin
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name" := JTemplate;
            GenJnlLine."Journal Batch Name" := JBatch;
            GenJnlLine."Source Code" := 'CASHRECJNL';
            GenJnlLine."Line No." := 1;
            GenJnlLine."Posting Date" := Rec.Date;
            GenJnlLine."Document No." := Rec."No.";
            GenJnlLine."Document Date" := Rec."Document Date";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";

            GenJnlLine."Account No." := Rec."Bank Code";//USetup."Default Receipts Bank";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code" := Rec."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            GenJnlLine.Amount := (tAmount);
            GenJnlLine.Validate(GenJnlLine.Amount);

            GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

            GenJnlLine.Description := CopyStr('On Behalf Of:' + Rec."Received From" + 'For' + Rec.Description + '' + 'Invoices:' + StrInvoices, 1, 50);
            GenJnlLine.Validate(GenJnlLine.Description);
            if GenJnlLine.Amount <> 0 then
                GenJnlLine.Insert;




            //insert the transaction lines into the database
            ReceiptLine.Reset;
            ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
            ReceiptLine.SetRange(ReceiptLine.Posted, false);

            if ReceiptLine.Find('-') then begin
                repeat
                    if ReceiptLine.Amount = 0 then Error('Please enter amount.');

                    if ReceiptLine.Amount < 0 then Error('Amount cannot be less than zero.');

                    ReceiptLine.TestField(ReceiptLine."Global Dimension 1 Code");

                    ReceiptLine.TestField(ReceiptLine."Shortcut Dimension 2 Code");

                    //get the last line number from the general journal line
                    GLine.Reset;
                    GLine.SetRange(GLine."Journal Template Name", JTemplate);
                    GLine.SetRange(GLine."Journal Batch Name", JBatch);
                    LineNo := 0;
                    if GLine.Find('+') then begin LineNo := GLine."Line No."; end;
                    LineNo := LineNo + 1;
                    if ReceiptLine."Pay Mode" <> ReceiptLine."Pay Mode"::Cheque then begin
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := JTemplate;
                        GenJnlLine."Journal Batch Name" := JBatch;
                        GenJnlLine."Source Code" := 'CASHRECJNL';
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Posting Date" := Rec.Date;
                        GenJnlLine."Document No." := ReceiptLine.No;
                        GenJnlLine."Document Date" := Rec."Document Date";
                        /*IF ReceiptLine."Customer Payment On Account" THEN
                          BEGIN
                            {SRSetup.GET();
                            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No.":=SRSetup."Receivable Batch Account";}

                            GenJnlLine."Account Type":=ReceiptLine."Account Type";
                            GenJnlLine."Account No.":=ReceiptLine."Account No.";

                          END
                        ELSE
                          BEGIN
                            GenJnlLine."Account Type":=ReceiptLine."Account Type";
                            GenJnlLine."Account No.":=ReceiptLine."Account No.";
                          END;*/
                        GenJnlLine."Account Type" := ReceiptLine."Account Type";
                        GenJnlLine."Account No." := ReceiptLine."Account No.";

                        //GenJnlLine."Transaction Type":=ReceiptLine."Transaction Type";
                        //GenJnlLine."Loan No":=ReceiptLine."Loan No.";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
                        GenJnlLine."Currency Code" := Rec."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");

                        GenJnlLine.Amount := -ReceiptLine.Amount;
                        GenJnlLine.Validate(GenJnlLine.Amount);

                        if ReceiptLine."Customer Payment On Account" = false then begin
                            //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                            GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                            GenJnlLine.Validate("Applies-to Doc. No.");
                            GenJnlLine."Applies-to ID" := ReceiptLine."Applies-to ID";
                            GenJnlLine.Validate(GenJnlLine."Applies-to ID");
                        end;

                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        //GenJnlLine.Description:=COPYSTR(ReceiptLine."Account Name" + ':' + FORMAT(ReceiptLine."Pay Mode") +
                        // ' Invoices:' + StrInvoices,1,50);
                        GenJnlLine.Description := CopyStr(Rec."Received From" + 'For' + Rec.Description, 1, 50);
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptLine."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptLine."Shortcut Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        //                  GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                        //                  GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                        GenJnlLine."Dimension Set ID" := ReceiptLine."Dimension Set ID";

                        if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                    end
                    else
                        if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::Cheque then begin
                            if ReceiptLine."Cheque/Deposit Slip Date" <= Today then begin
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := JTemplate;
                                GenJnlLine."Journal Batch Name" := JBatch;
                                GenJnlLine."Source Code" := 'CASHRECJNL';
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Posting Date" := Rec.Date;
                                GenJnlLine."Document No." := ReceiptLine.No;
                                GenJnlLine."Document Date" := Rec."Document Date";
                                /*IF ReceiptLine."Customer Payment On Account" THEN
                                  BEGIN
                                    SRSetup.GET();
                                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                                    GenJnlLine."Account No.":=SRSetup."Receivable Batch Account";
                                  END
                                ELSE
                                  BEGIN
                                    GenJnlLine."Account Type":=ReceiptLine."Account Type";
                                    GenJnlLine."Account No.":=ReceiptLine."Account No.";
                                  END;*/

                                GenJnlLine."Account Type" := ReceiptLine."Account Type";
                                GenJnlLine."Account No." := ReceiptLine."Account No.";
                                GenJnlLine.Validate(GenJnlLine."Account No.");
                                //GenJnlLine."Transaction Type":=ReceiptLine."Transaction Type";//Sacco
                                //GenJnlLine."Loan No":=ReceiptLine."Loan No.";Sacco
                                GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.Validate(GenJnlLine."Currency Code");

                                GenJnlLine.Amount := -ReceiptLine.Amount;
                                GenJnlLine.Validate(GenJnlLine.Amount);

                                if ReceiptLine."Customer Payment On Account" = false then begin
                                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                    GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                                    GenJnlLine.Validate("Applies-to Doc. No.");
                                    GenJnlLine."Applies-to ID" := ReceiptLine."Applies-to ID";
                                    GenJnlLine.Validate(GenJnlLine."Applies-to ID");
                                end;
                                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                                // GenJnlLine.Description:=COPYSTR(ReceiptLine."Account Name" + ':' + FORMAT(ReceiptLine."Pay Mode")
                                //+ ' Invoices:' + StrInvoices,1,50);
                                GenJnlLine.Description := CopyStr(Rec."Received From" + 'For' + Rec.Description + '', 1, 50);
                                GenJnlLine."Shortcut Dimension 1 Code" := ReceiptLine."Global Dimension 1 Code";
                                //                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := ReceiptLine."Shortcut Dimension 2 Code";
                                //                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                                //                    GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                                //                    GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                                GenJnlLine."Dimension Set ID" := ReceiptLine."Dimension Set ID";

                                if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                            end;
                        end;
                until ReceiptLine.Next = 0;
            end;

            /*Post the transactions*/
            Post := false;
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            //Adjust Gen Jnl Exchange Rate Rounding Balances
            AdjustGenJnl.Run(GenJnlLine);
            //End Adjust Gen Jnl Exchange Rate Rounding Balances

            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            Post := JournalPosted.PostedSuccessfully();
            if Post then begin
                //Update Header
                Rec.Cashier := UserId;
                //"Bank Code":=USetup."Default Receipts Bank";
                Rec.Posted := true;
                Rec."Date Posted" := Today;
                Rec."Time Posted" := Time;
                Rec."Posted By" := UserId;
                Rec.Modify;
                //Update Lines
                ReceiptLine.Reset;
                ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
                ReceiptLine.SetRange(ReceiptLine.Posted, false);
                if ReceiptLine.Find('-') then begin
                    repeat
                        ReceiptLine.Posted := true;
                        ReceiptLine."Date Posted" := Today;
                        ReceiptLine."Time Posted" := Time;
                        ReceiptLine."Posted By" := UserId;
                        ReceiptLine.Modify;
                    until ReceiptLine.Next = 0;
                end;

                Message('Receipt Posted Successfully');

            end;
            Rec.Cashier := UserId;
            //"Bank Code":=USetup."Default Receipts Bank";
            Rec.Posted := true;
            Rec."Date Posted" := Today;
            Rec."Time Posted" := Time;
            Rec."Posted By" := UserId;
            Rec.Modify;
            //Update Lines
            ReceiptLine.Reset;
            ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
            ReceiptLine.SetRange(ReceiptLine.Posted, false);
            if ReceiptLine.Find('-') then begin
                repeat
                    ReceiptLine.Posted := true;
                    ReceiptLine."Date Posted" := Today;
                    ReceiptLine."Time Posted" := Time;
                    ReceiptLine."Posted By" := UserId;
                    ReceiptLine.Modify;
                until ReceiptLine.Next = 0;
            end;
        end;

    end;

    procedure PerformPostLine()
    begin
    end;

    procedure CheckPostDated() Exists: Boolean
    begin
        //get the sum total of the post dated cheques is any
        //reset the bank amount first
        Exists := false;
        BAmount := 0;
        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
        ReceiptLine.SetRange(ReceiptLine."Pay Mode", ReceiptLine."Pay Mode"::Cheque);
        if ReceiptLine.Find('-') then begin
            repeat
                if ReceiptLine."Cheque/Deposit Slip Date" > Today then begin
                    Exists := true;
                    exit;
                    //cheque is post dated
                    // BAmount:=BAmount + ReceiptLine.Amount;
                end;
            until ReceiptLine.Next = 0;
        end;
    end;

    procedure CheckBnkCurrency(BankAcc: Code[20]; CurrCode: Code[20])
    var
        BankAcct: Record "Bank Account";
    begin
        BankAcct.Reset;
        BankAcct.SetRange(BankAcct."No.", BankAcc);
        if BankAcct.Find('-') then begin
            if BankAcct."Currency Code" <> CurrCode then begin
                if BankAcct."Currency Code" = '' then
                    Error('This bank [%1:- %2] can only transact in LOCAL Currency', BankAcct."No.", BankAcct.Name)
                else
                    Error('This bank [%1:- %2] can only transact in %3', BankAcct."No.", BankAcct.Name, BankAcct."Currency Code");
            end;
        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        //xRec := Rec;
        FunctionName := '';
        DimVal.Reset;
        DimVal.SetRange(DimVal."Global Dimension No.", 1);
        DimVal.SetRange(DimVal.Code, Rec."Global Dimension 1 Code");
        if DimVal.Find('-') then begin
            FunctionName := DimVal.Name;
        end;
        BudgetCenterName := '';
        DimVal.Reset;
        DimVal.SetRange(DimVal."Global Dimension No.", 2);
        DimVal.SetRange(DimVal.Code, Rec."Shortcut Dimension 2 Code");
        if DimVal.Find('-') then begin
            BudgetCenterName := DimVal.Name;
        end;
        BankName := '';
        BankAcc.Reset;
        BankAcc.SetRange(BankAcc."No.", Rec."Bank Code");
        if BankAcc.Find('-') then begin
            BankName := BankAcc.Name;
        end;
    end;

    procedure UpdateControls()
    begin
        if Rec.Posted = false then
            StatusEditable := true
        else
            StatusEditable := false;
    end;

    procedure CurrPageUpdate()
    begin
        xRec := Rec;
        UpdateControls;
        OnAfterGetCurrRecord;
        //CurrPage.UPDATE;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Requisition","Transport Requisition",JV,"Grant Task","Concept Note",Proposal,"Job Approval","Disciplinary Approvals",GRN,Clearence,Donation,Transfer,PayChange,Budget,GL,"Cash Purchase","Leave Reimburse",Appraisal,Inspection,Closeout,"Lab Request",ProposalProjectsAreas,"Leave Carry over","IB Transfer",EmpTransfer,LeavePlanner,HrAssetTransfer;
    begin
        //DocNoVisible := DocumentNoVisibility.FundsMgtDocumentNoIsVisible(DocType::Receipt,"No.");
    end;

    procedure UpdateBidderDetails()
    var
        Bidder: Record "Receipts Header";
        BidderTender: Record "Receipts Header";
        Tender: Record "Receipts Header";
    begin
        /*IF  TenderReceipt THEN BEGIN
        
          Bidder.RESET;
          Bidder.SETRANGE(Bidder."PIN No","PIN No");
          IF NOT Bidder.FIND('-') THEN BEGIN
             Bidder.INIT;
             Bidder."PIN No":="PIN No";
             Bidder."Date Created":=TODAY;
             Bidder."Created By":=USERID;
             Bidder.Password:="No.";
             Bidder."Tenderer Name":="On Behalf Of";
             Bidder.INSERT;
          END
          //modified to allow updating of password to the new receipt number
          ELSE BEGIN
             Bidder.Password:="No.";
             Bidder."Changed Password":=FALSE;
             Bidder."Posted To Portal":=FALSE;
             Bidder.MODIFY;
          END;
        
         //Update the Tender Details
         BidderTender.RESET;
         BidderTender.SETRANGE(BidderTender."Tender ID","Tender No");
         BidderTender.SETRANGE(BidderTender."PIN No.","PIN No");
         BidderTender.SETRANGE(BidderTender."Receipt No.","No.");
        
         IF NOT BidderTender.FIND('-') THEN BEGIN
            BidderTender.INIT;
            BidderTender."Tender ID":="Tender No";
            BidderTender."PIN No.":="PIN No";
            BidderTender."Receipt No.":="No.";
            BidderTender."Date Created":=TODAY;
            BidderTender."Created By":=USERID;
            BidderTender."Tenderer Names":="On Behalf Of";
            CALCFIELDS("Total Amount");
            BidderTender."Non Refundable Fee":="Total Amount";
            BidderTender.Year:=Year;
            BidderTender.INSERT;
         END;
        END;
        */

    end;
}

