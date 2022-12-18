page 51533411 "Payment Requests List"
{
    CardPageID = 39005546;
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Payments Header";
    SourceTableView = WHERE("Payment Type"=CONST(Express),
                            Posted=CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field(Date;Date)
                {
                }
                field(Payee;Payee)
                {
                }
                field("Payment Narration";"Payment Narration")
                {
                }
                field("Currency Code";"Currency Code")
                {
                }
                field("Total VAT Amount";"Total VAT Amount")
                {
                    Visible = false;
                }
                field("Total Witholding Tax Amount";"Total Witholding Tax Amount")
                {
                    Visible = false;
                }
                field("Total Net Amount";"Total Net Amount")
                {
                    Visible = false;
                }
                field("Total Payment Amount";"Total Payment Amount")
                {
                }
                field("Cheque No.";"Cheque No.")
                {
                    Visible = false;
                }
                field(Status;Status)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755014;Notes)
            {
            }
            systempart(Control1102755015;MyNotes)
            {
            }
            systempart(Control1102755016;Outlook)
            {
            }
            systempart(Control1102755017;Links)
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
                    Caption = 'Post';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //Post PV Entries
                        CurrPage.SaveRecord;
                        CheckPVRequiredItems;
                        PostPaymentVoucher;

                        //Print Here
                        //RESET;
                        //SETFILTER("No.","No.");
                        //REPORT.RUN(51533300,TRUE,TRUE,Rec);
                        //RESET;
                        //End Print Here
                    end;
                }
                separator(Separator1102755029)
                {
                }
                action("<Action1102755034>")
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        /*
                        IF "Payment Type"="Payment Type"::Normal THEN
                          DocumentType:=DocumentType::"Payment Voucher"
                        ELSE
                          DocumentType:=DocumentType::"Express Pv";
                        */
                         DocumentType:=DocumentType::Requisition;
                        ApprovalEntries.Setfilters(DATABASE::"Payments Header",DocumentType,"No.");
                        ApprovalEntries.Run;

                    end;
                }
                action("<Action1102755007>")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if not LinesExists then
                           Error('There are no Lines created for this Document');
                        //Ensure No Items That should be committed that are not
                        if LinesCommitmentStatus then
                          Error('There are some lines that have not been committed');

                        //Release the PV for Approval
                        //IF ApprovalMgt.SendPVApprovalRequest(Rec) THEN;
                    end;
                }
                action("<Action1102755028>")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                          //IF ApprovalMgt.CancelPVApprovalRequest(Rec,TRUE,TRUE) THEN;
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
                    Visible = false;

                    trigger OnAction()
                    var
                        BCSetup: Record "Budgetary Control Setup";
                    begin
                        BCSetup.Get;
                        if not BCSetup.Mandatory then
                           exit;
                        
                            if not AllFieldsEntered then
                             Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');
                         /* //First Check whether other lines are already committed.
                          Commitments.RESET;
                          Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::"3");
                          Commitments.SETRANGE(Commitments."Document No.","No.");
                          IF Commitments.FIND('-') THEN BEGIN
                            IF CONFIRM('Lines in this Document appear to be committed do you want to re-commit?',FALSE)=FALSE THEN BEGIN EXIT END;
                          Commitments.RESET;
                          Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::"3");
                          Commitments.SETRANGE(Commitments."Document No.","No.");
                          Commitments.DELETEALL;
                         END;
                          */
                            //CheckBudgetAvail.CheckPayments(Rec);

                    end;
                }
                action("<Action1102755032>")
                {
                    Caption = 'Cancel Budget Commitment';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                          if Confirm('Do you Wish to Cancel the Commitment entries for this document',false)=false then begin exit end;
                         /*
                          Commitments.RESET;
                          Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::"3");
                          Commitments.SETRANGE(Commitments."Document No.","No.");
                          Commitments.DELETEALL;
                          */
                          PayLine.Reset;
                          PayLine.SetRange(PayLine.No,"No.");
                          if PayLine.Find('-') then begin
                            repeat
                              PayLine.Committed:=false;
                              PayLine.Modify;
                            until PayLine.Next=0;
                          end;

                    end;
                }
                separator(Separator1102755022)
                {
                }
                action(Print)
                {
                    Caption = 'Print/Preview';
                    Image = ConfirmAndPrint;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // IF Status<>Status::Approved THEN
                         //   ERROR('You can only print a Payment Voucher after it is fully Approved');



                        //IF Status=Status::Pending THEN
                           //ERROR('You cannot Print until the document is released for approval');
                        Reset;
                        SetFilter("No.","No.");
                        REPORT.Run(39005903,true,true,Rec);
                        Reset;

                        CurrPage.Update;
                        CurrPage.SaveRecord;
                    end;
                }
                action("<Action1102756004>")
                {
                    Caption = 'Bank Letter';
                    Visible = false;

                    trigger OnAction()
                    var
                        FilterbyPayline: Record "Payment Line";
                    begin
                        if Status=Status::Pending then
                           Error('You cannot Print until the document is released for approval');
                        FilterbyPayline.Reset;
                        FilterbyPayline.SetFilter(FilterbyPayline.No,"No.");
                        REPORT.Run(51533603,true,true,FilterbyPayline);
                        Reset;
                    end;
                }
                separator(Separator1102755019)
                {
                }
                action("<Action1102756006>")
                {
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text000: Label 'Are you sure you want to cancel this Document?';
                        Text001: Label 'You have selected not to Cancel the Document';
                    begin
                        TestField(Status,Status::"2nd Approval");
                        if Confirm(Text000,true) then  begin
                        //Post Reversal Entries for Commitments
                        Doc_Type:=Doc_Type::"Payment Voucher";
                        //CheckBudgetAvail.ReverseEntries(Doc_Type,"No.");
                        Status:=Status::Posted;
                        Modify;
                        end else
                          Error(Text001);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        
        if UserMgt.GetPurchasesFilter() <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FilterGroup(0);
        end;
        
        /*
        IF UserMgt.GetSetDimensions(USERID,2) <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Shortcut Dimension 2 Code",UserMgt.GetSetDimensions(USERID,2));
          FILTERGROUP(0);
        END;
        */

    end;

    var
        PayLine: Record "Payment Line";
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
        Post: Boolean;
        strText: Text[100];
        PVHead: Record "Payments Header";
        BankAcc: Record "Bank Account";
        UserMgt: Codeunit "User Setup Management BR";
        JournlPosted: Codeunit "Journal Post Successful";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,Load,Discharge,"Express Pv";
        DocPrint: Codeunit "Document-Print";
        CheckLedger: Record "Check Ledger Entry";
        CheckManagement: Codeunit CheckManagement;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Cheque TypeEditable": Boolean;
        [InDataSet]
        "Invoice Currency CodeEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        "Payment NarrationEditable": Boolean;
        [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        [InDataSet]
        PayeeEditable: Boolean;
        [InDataSet]
        ShortcutDimension3CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension4CodeEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        PVLinesEditable: Boolean;
        Text001: Label 'This Document no %1 has printed Cheque No %2 which will have to be voided first before reposting.';
        Text000: Label 'Do you want to Void Check No %1';
        Text002: Label 'You have selected post and generate a computer cheque ensure that your cheque printer is ready do you want to continue?';

    procedure PostPaymentVoucher()
    begin
        
         // DELETE ANY LINE ITEM THAT MAY BE PRESENT
         GenJnlLine.Reset;
         GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
         GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
         if GenJnlLine.Find('+') then
           begin
             LineNo:=GenJnlLine."Line No."+1000;
           end
         else
           begin
             LineNo:=1000;
           end;
         GenJnlLine.DeleteAll;
         GenJnlLine.Reset;
        
        Payments.Reset;
        Payments.SetRange(Payments."No.","No.");
        if Payments.Find('-') then begin
          PayLine.Reset;
          PayLine.SetRange(PayLine.No,Payments."No.");
          if PayLine.Find('-') then
            begin
              repeat
                PostHeader(Payments);
              until PayLine.Next=0;
            end;
        
        Post:=false;
        Post:=JournlPosted.PostedSuccessfully();
        if Post then  begin
            Posted:=true;
            Status:=Payments.Status::"Cheque Printing";
            "Posted By":=UserId;
            "Date Posted":=Today;
            "Time Posted":=Time;
            Modify;
          /*
          //Post Reversal Entries for Commitments
          Doc_Type:=Doc_Type::"Payment Voucher";
          CheckBudgetAvail.ReverseEntries(Doc_Type,"No.");
          */
          end;
        end;

    end;

    procedure PostHeader(var Payment: Record "Payments Header")
    begin

        if (Payments."Pay Mode"=Payments."Pay Mode"::Cheque) and ("Cheque Type"="Cheque Type"::" ") then
           Error('Cheque type has to be specified');

        if Payments."Pay Mode"=Payments."Pay Mode"::Cheque then begin
            if (Payments."Cheque No."='') and ("Cheque Type"="Cheque Type"::"Manual Check") then
              begin
                Error('Please ensure that the cheque number is inserted');
              end;
        end;

        if Payments."Pay Mode"=Payments."Pay Mode"::EFT then
          begin
            if Payments."Cheque No."='' then
              begin
                Error ('Please ensure that the EFT number is inserted');
              end;
          end;

        if Payments."Pay Mode"=Payments."Pay Mode"::"Letter of Credit" then
          begin
            if Payments."Cheque No."='' then
              begin
                Error('Please ensure that the Letter of Credit ref no. is entered.');
              end;
          end;
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);

          if GenJnlLine.Find('+') then
            begin
              LineNo:=GenJnlLine."Line No."+1000;
            end
          else
            begin
              LineNo:=1000;
            end;


        LineNo:=LineNo+1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name":=JTemplate;
        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name":=JBatch;
        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No.":=LineNo;
        GenJnlLine."Source Code":='PAYMENTJNL';
        GenJnlLine."Posting Date":=Payment."Payment Release Date";
        if CustomerPayLinesExist then
         GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
        else
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No.":=Payments."No.";
        GenJnlLine."External Document No.":=Payments."Cheque No.";

        GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No.":=Payments."Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Account No.");

        GenJnlLine."Currency Code":=Payments."Currency Code";
        GenJnlLine.Validate(GenJnlLine."Currency Code");
          //CurrFactor
          GenJnlLine."Currency Factor":=Payments."Currency Factor";
          GenJnlLine.Validate("Currency Factor");

        Payments.CalcFields(Payments."Total Net Amount",Payments."Total VAT Amount");
        GenJnlLine.Amount:=-(Payments."Total Net Amount" );
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No.":='';

        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");

        GenJnlLine.Description:=CopyStr('Pay To:' + Payments.Payee,1,50);
        GenJnlLine.Validate(GenJnlLine.Description);

        if "Pay Mode"<>"Pay Mode"::Cheque then  begin
        GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "
        end else begin
        if "Cheque Type"="Cheque Type"::"Computer Check" then
         GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::"Computer Check"
        else
           GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "

        end;
        if GenJnlLine.Amount<>0 then
        GenJnlLine.Insert;

        //Post Other Payment Journal Entries
        PostPV(Payments);
    end;

    procedure GetAppliedEntries(var LineNo: Integer) InvText: Text[100]
    begin
        /*
        InvText:='';
        Appl.RESET;
        Appl.SETRANGE(Appl."Document Type",Appl."Document Type"::"0");
        Appl.SETRANGE(Appl."Document No.","No.");
        Appl.SETRANGE(Appl."Line No.",LineNo);
        IF Appl.FINDFIRST THEN
          BEGIN
            REPEAT
              InvText:=COPYSTR(InvText + ',' + Appl."Appl. Doc. No",1,50);
            UNTIL Appl.NEXT=0;
          END;
          */

    end;

    procedure InsertApproval()
    var
        Appl: Record "CshMgt Approvals";
        LineNo: Integer;
    begin
        LineNo:=0;
        Appl.Reset;
        if Appl.FindLast then
          begin
            LineNo:=Appl."Line No.";
          end;

        LineNo:=LineNo +1;

        Appl.Reset;
        Appl.Init;
          Appl."Line No.":=LineNo;
          Appl."Document Type":=Appl."Document Type"::PV;
          Appl."Document No.":="No.";
          Appl."Document Date":=Date;
          Appl."Process Date":=Today;
          Appl."Process Time":=Time;
          Appl."Process User ID":=UserId;
          Appl."Process Name":="Current Status";
          //Appl."Process Machine":=ENVIRON('COMPUTERNAME');
        Appl.Insert;
    end;

    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCSetup: Record "Budgetary Control Setup";
    begin
         if BCSetup.Get() then  begin
            if not BCSetup.Mandatory then  begin
               Exists:=false;
               exit;
            end;
         end else begin
               Exists:=false;
               exit;
         end;
         Exists:=false;
         PayLine.Reset;
         PayLine.SetRange(PayLine.No,"No.");
         PayLine.SetRange(PayLine.Committed,false);
         PayLine.SetRange(PayLine."Budgetary Control A/C",true);
          if PayLine.Find('-') then
             Exists:=true;
    end;

    procedure CheckPVRequiredItems()
    begin
        if Posted then  begin
            Error('The Document has already been posted');
        end;
        
        TestField(Status,Status::"2nd Approval");
        TestField("Paying Bank Account");
        TestField("Pay Mode");
        TestField("Payment Release Date");
        //Confirm whether Bank Has the Cash
        //IF "Pay Mode"="Pay Mode"::Cash THEN
        // CheckBudgetAvail.CheckFundsAvailability(Rec);
        
         //Confirm Payment Release Date is today);
        if "Pay Mode"="Pay Mode"::Cash then
          TestField("Payment Release Date",WorkDate);
        
        /*Check if the user has selected all the relevant fields*/
        Temp.Get(UserId);
        
        JTemplate:=Temp."Payment Journal Template";JBatch:=Temp."Payment Journal Batch";
        
        if JTemplate='' then
          begin
            Error('Ensure the PV Template is set up in Cash Office Setup');
          end;
        if JBatch='' then
          begin
            Error('Ensure the PV Batch is set up in the Cash Office Setup')
          end;
        
        if ("Pay Mode"="Pay Mode"::Cheque) and ("Cheque Type"="Cheque Type"::"Computer Check") then begin
           if not Confirm(Text002,false) then
              Error('You have selected to Abort PV Posting');
        end;
        //Check whether there is any printed cheques and lines not posted
        CheckLedger.Reset;
        CheckLedger.SetRange(CheckLedger."Document No.","No.");
        CheckLedger.SetRange(CheckLedger."Entry Status",CheckLedger."Entry Status"::Printed);
        if CheckLedger.Find('-') then begin
        //Ask whether to void the printed cheque
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
        GenJnlLine.FindFirst;
        if Confirm(Text000,false,CheckLedger."Check No.") then
          CheckManagement.VoidCheck(GenJnlLine)
          else
           Error(Text001,"No.",CheckLedger."Check No.");
        end;

    end;

    procedure PostPV(var Payment: Record "Payments Header")
    begin

        PayLine.Reset;
        PayLine.SetRange(PayLine.No,Payments."No.");
        if PayLine.Find('-') then begin

        repeat
            strText:=GetAppliedEntries(PayLine."Line No.");
            Payment.TestField(Payment.Payee);
            PayLine.TestField(PayLine.Amount);
           // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

            //BANK
            if PayLine."Pay Mode"=PayLine."Pay Mode"::Cash then begin
              CashierLinks.Reset;
              CashierLinks.SetRange(CashierLinks.UserID,UserId);
            end;

            //CHEQUE
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document No.":=PayLine.No;
            if PayLine."Account Type"=PayLine."Account Type"::Customer then
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
            else
              GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine.Description:=CopyStr(PayLine."Transaction Name" + ':' + Payment.Payee,1,50);
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate("Currency Code");
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");
            if PayLine."VAT Code"='' then
              begin
                GenJnlLine.Amount:=PayLine."Net Amount" ;
              end
            else
              begin
                GenJnlLine.Amount:=PayLine."Net Amount";
              end;
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."VAT Prod. Posting Group":=PayLine."VAT Prod. Posting Group";
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        //    GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
        //    GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Applies-to Doc. No.";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Applies-to ID";

            if GenJnlLine.Amount<>0 then GenJnlLine.Insert;

            //Post VAT to GL[VAT GL]
            TarriffCodes.Reset;
            TarriffCodes.SetRange(TarriffCodes.Code,PayLine."VAT Code");
            if TarriffCodes.Find('-') then begin
            TarriffCodes.TestField(TarriffCodes."Account No.");
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            //CurrFactor
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");

            GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
            GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=-PayLine."VAT Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr('VAT:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50);
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        //    GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
        //    GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
            if GenJnlLine.Amount<>0 then GenJnlLine.Insert;
            end;

            //POST W/TAX to Respective W/TAX GL Account
            TarriffCodes.Reset;
            TarriffCodes.SetRange(TarriffCodes.Code,PayLine."Withholding Tax Code");
            if TarriffCodes.Find('-') then begin
            TarriffCodes.TestField(TarriffCodes."Account No.");
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            //CurrFactor
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");

            GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
            GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=-PayLine."Withholding Tax Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine.Description:=CopyStr('W/Tax:' + Format(PayLine."Account Name") +'::' + strText,1,50);
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        //    GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
        //    GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
            if GenJnlLine.Amount<>0 then
            GenJnlLine.Insert;
            end;

            //Post VAT Balancing Entry Goes to Vendor
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            //CurrFactor
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");

            if PayLine."VAT Code"='' then
              begin
                GenJnlLine.Amount:=0;
              end
            else
              begin
                GenJnlLine.Amount:=PayLine."VAT Amount";
              end;
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr('VAT:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50) ;
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        //    GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
        //    GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
            if GenJnlLine.Amount<>0 then
            GenJnlLine.Insert;

            //Post W/TAX Balancing Entry Goes to Vendor
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            //CurrFactor
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");

            GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
            GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=PayLine."Withholding Tax Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr('W/Tax:' + strText ,1,50);
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        //    GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
        //    GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
            if GenJnlLine.Amount<>0 then
            GenJnlLine.Insert;


        until PayLine.Next=0;

        Commit;
        //Post the Journal Lines
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
        //Adjust Gen Jnl Exchange Rate Rounding Balances
           AdjustGenJnl.Run(GenJnlLine);
        //End Adjust Gen Jnl Exchange Rate Rounding Balances


        //Before posting if paymode is cheque print the cheque
        if ("Pay Mode"="Pay Mode"::Cheque) and ("Cheque Type"="Cheque Type"::"Computer Check") then begin
        DocPrint.PrintCheck(GenJnlLine);
        CODEUNIT.Run(CODEUNIT::"Adjust Gen. Journal Balance",GenJnlLine);
        //Confirm Cheque printed //Not necessary.
        end;

        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Line",GenJnlLine);
        Post:=false;
        Post:=JournlPosted.PostedSuccessfully();
        if Post then
          begin
            if PayLine.FindFirst then
              begin
                repeat
                  PayLine."Date Posted":=Today;
                  PayLine."Time Posted":=Time;
                  PayLine."Posted By":=UserId;
                  PayLine.Status:=PayLine.Status::Posted;
                  PayLine.Modify;
               until PayLine.Next=0;
             end;
          end;

        end;
    end;

    procedure UpdatePageControls()
    begin
             if Status<>Status::"2nd Approval" then begin
             "Payment Release DateEditable" :=false;
             //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
             //CurrForm."Pay Mode".EDITABLE:=FALSE;
             //CurrForm."Currency Code".EDITABLE:=TRUE;
             "Cheque No.Editable" :=false;
             "Cheque TypeEditable" :=false;
             "Invoice Currency CodeEditable" :=true;
             end else begin
             "Payment Release DateEditable" :=true;
             //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
             //CurrForm."Pay Mode".EDITABLE:=TRUE;
             if "Pay Mode"="Pay Mode"::Cheque then
               "Cheque TypeEditable" :=true;
             //CurrForm."Currency Code".EDITABLE:=FALSE;
             if "Cheque Type"<>"Cheque Type"::"Computer Check" then
                 "Cheque No.Editable" :=true;
             "Invoice Currency CodeEditable" :=false;

             CurrPage.Update;
             end;


             if Status=Status::Pending then begin
             "Currency CodeEditable" :=true;
             GlobalDimension1CodeEditable :=true;
             "Payment NarrationEditable" :=true;
             ShortcutDimension2CodeEditable :=true;
             PayeeEditable :=true;
             ShortcutDimension3CodeEditable :=true;
             ShortcutDimension4CodeEditable :=true;
             DateEditable :=true;
             PVLinesEditable :=true;

             CurrPage.Update;
             end else begin
             "Currency CodeEditable" :=false;
             GlobalDimension1CodeEditable :=false;
             "Payment NarrationEditable" :=false;
             ShortcutDimension2CodeEditable :=false;
             PayeeEditable :=false;
             ShortcutDimension3CodeEditable :=false;
             ShortcutDimension4CodeEditable :=false;
             DateEditable :=false;
             PVLinesEditable :=false;


             CurrPage.Update;
             end
    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Payment Line";
    begin
         HasLines:=false;
         PayLines.Reset;
         PayLines.SetRange(PayLines.No,"No.");
          if PayLines.Find('-') then begin
             HasLines:=true;
             exit(HasLines);
          end;
    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Payment Line";
    begin
        AllKeyFieldsEntered:=true;
         PayLines.Reset;
         PayLines.SetRange(PayLines.No,"No.");
          if PayLines.Find('-') then begin
            repeat
             if (PayLines."Account No."='') or (PayLines.Amount<=0) then
             AllKeyFieldsEntered:=false;
            until PayLines.Next=0;
             exit(AllKeyFieldsEntered);
          end;
    end;

    procedure CustomerPayLinesExist(): Boolean
    var
        PayLine: Record "Payment Line";
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.No,"No.");
        PayLine.SetRange(PayLine."Account Type",PayLine."Account Type"::Customer);
        exit(PayLine.FindFirst);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdatePageControls();

        //Set the filters here
        SetRange(Posted,false);
        SetRange("Payment Type","Payment Type"::Normal);
        SetFilter(Status,'<>Cancelled');
    end;

    procedure SetSelection(var Collection: Record "Payments Header")
    begin
        CurrPage.SetSelectionFilter(Collection);
    end;
}

