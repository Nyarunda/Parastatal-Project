table 51533380 "Payment Lines"
{
    DrillDownPageID = "Payment Lines";
    LookupPageID = "Payment Lines";

    fields
    {
        field(1; No; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                    GenLedgerSetup.Get;
                    if "Payment Type" = "Payment Type"::Normal then begin
                        NoSeriesMgt.TestManual(GenLedgerSetup."Normal Payments No");
                    end
                    else begin
                        NoSeriesMgt.TestManual(GenLedgerSetup."Petty Cash Payments No");
                    end;
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Date; Date)
        {
        }
        field(3; Type; Code[20])
        {
            NotBlank = true;
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = FILTER(Payment),
                                                                     Blocked = CONST(false));

            trigger OnValidate()
            var
                TarrifCode: Record "Tariff Codes";
            begin

                "Account No." := '';
                "Account Name" := '';
                "Vendor PIN No." := '';
                Remarks := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);

                if RecPayTypes.Find('-') then begin
                    Grouping := RecPayTypes."Default Grouping";
                    "Require Surrender" := RecPayTypes."Pending Voucher";
                    "Payment Reference" := RecPayTypes."Payment Reference";
                    "Budgetary Control A/C" := RecPayTypes."Direct Expense";

                    if RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes then begin
                        "VAT Code" := RecPayTypes."VAT Code";
                        if TarrifCode.Get("VAT Code") then
                            "VAT Rate" := TarrifCode.Percentage;
                    end;
                    if RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes then begin
                        "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                        if TarrifCode.Get("Withholding Tax Code") then
                            "W/Tax Rate" := TarrifCode.Percentage;

                    end;


                    if RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes then begin
                        "VAT Withheld Code" := RecPayTypes."VAT Withheld Code";
                        if TarrifCode.Get("VAT Withheld Code") then
                            "VAT 6% Rate" := TarrifCode.Percentage;
                    end;


                    if RecPayTypes."Calculate Retention" = RecPayTypes."Calculate Retention"::Yes then begin
                        "Retention Code" := RecPayTypes."Retention Code";
                        if TarrifCode.Get("Retention Code") then
                            "Retention Rate" := TarrifCode.Percentage;

                    end;



                end;

                if RecPayTypes.Find('-') then begin
                    "Account Type" := RecPayTypes."Account Type";
                    Validate("Account Type");
                    "Transaction Name" := RecPayTypes.Description;
                    "Budgetary Control A/C" := RecPayTypes."Direct Expense";
                    if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" then begin
                        if RecPayTypes."G/L Account" <> '' then
                            RecPayTypes.TestField(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."G/L Account";
                        "Not Budgeted" := RecPayTypes."Not Budgeted";
                        Validate("Account No.");
                    end;

                    //Banks
                    if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"Bank Account" then begin
                        "Account No." := RecPayTypes."Bank Account";
                        Validate("Account No.");
                    end;
                end;

                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    Date := PHead.Date;
                    PHead.TestField("Responsibility Center");
                    "Global Dimension 1 Code" := PHead."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PHead."Shortcut Dimension 2 Code";
                    //"Shortcut Dimension 3 Code":=PHead."Shortcut Dimension 3 Code";
                    //"Shortcut Dimension 4 Code":=PHead."Shortcut Dimension 4 Code";
                    "Contract No" := PHead."Contract No";
                    "Dimension Set ID" := PHead."Dimension Set ID";
                    "Currency Code" := PHead."Currency Code";
                    "Currency Factor" := PHead."Currency Factor";
                    "Payment Type" := PHead."Payment Type";
                end;
            end;
        }
        field(4; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Custom 2","Custom 3","Custom 4","Custom 5";
        }
        field(5; "Cheque No"; Code[20])
        {
        }
        field(6; "Cheque Date"; Date)
        {
        }
        field(7; "Cheque Type"; Code[20])
        {
        }
        field(8; "Bank Code"; Code[20])
        {
        }
        field(9; "Received From"; Text[100])
        {
        }
        field(10; "On Behalf Of"; Text[100])
        {
        }
        field(11; Cashier; Code[50])
        {
        }
        field(12; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Staff,Invest,Item';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Staff,"None",Item;

            trigger OnValidate()
            var
                PayLines: Record "Payment Lines";
            begin
                /*
                   PayLines.RESET;
                   PayLines.SETRANGE(PayLines."Account Type",PayLines."Account Type"::Vendor);
                   PayLines.SETRANGE(PayLines.No,No);
                   IF PayLines.FIND('-') THEN
                      ERROR('There is already another existing Payment to a Vendor in this document');
                
                   PayLines.RESET;
                   PayLines.SETRANGE(PayLines."Account Type",PayLines."Account Type"::Customer);
                   PayLines.SETRANGE(PayLines.No,No);
                   IF PayLines.FIND('-') THEN
                      ERROR('There is already another existing Payment to a Customer in this document');
                
                   IF ("Account Type"= "Account Type"::Vendor) OR  ("Account Type"= "Account Type"::Customer) THEN  BEGIN
                      IF PayLinesExist THEN
                      ERROR('There is already another existing Line for this document');
                   END;
                */

            end;
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                                                          "Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer WHERE("Customer Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor WHERE("Vendor Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            var
                Text0001: Label 'The Account number CANNOT be the same as the Paying Bank Account No.';
            begin
                PH.Reset;
                PH.Get(No);
                "Account Name" := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);

                if "Account Type" in ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner",
                "Account Type"::"Bank Account"]
                then
                    case "Account Type" of
                        "Account Type"::"G/L Account":
                            begin
                                if "Account No." <> '' then
                                    GLAcc.Get("Account No.");
                                "Account Name" := GLAcc.Name;
                                PH.TestField("Global Dimension 1 Code");
                                PH.TestField("Shortcut Dimension 2 Code");
                                //"Global Dimension 1 Code":='';
                                //"Shortcut Dimension 2 Code":='';
                            end;
                        "Account Type"::Customer:
                            begin
                                Cust.Get("Account No.");
                                "Account Name" := Cust.Name;
                                PH.Payee := "Account Name";
                                PH.Modify;

                                if "Global Dimension 1 Code" = '' then begin
                                    "Global Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                end;
                                //insert for invest
                                // "Account Type"::None:
                                begin
                                    Cust.Get("Account No.");
                                    "Account Name" := Cust.Name;
                                    PH.Payee := "Account Name";
                                    PH.Modify;
                                end;

                            end;
                        "Account Type"::Vendor:
                            begin
                                Vend.Get("Account No.");
                                "Account Name" := Vend.Name;
                                //"Vendor PIN No." := Vend."PIN No.";
                                if "Global Dimension 1 Code" = '' then begin
                                    "Global Dimension 1 Code" := Vend."Global Dimension 1 Code";
                                end;
                                begin
                                    PH.Payee := "Account Name";
                                    PH.Modify;
                                end;
                                begin
                                    //PH."On Behalf Of":="Account Name";
                                    //  PH.MODIFY;
                                end;
                            end;
                        "Account Type"::"Bank Account":
                            begin
                                if BankAcc.Get("Account No.") then
                                    "Account Name" := BankAcc.Name;
                                PH.TestField("Paying Bank Account");
                                if PH."Paying Bank Account" = "Account No." then
                                    Error(Text0001);
                                if "Global Dimension 1 Code" = '' then begin
                                    "Global Dimension 1 Code" := BankAcc."Global Dimension 1 Code";
                                end;
                            end;
                        "Account Type"::"IC Partner":
                            begin
                                ICPartner.Reset;
                                ICPartner.Get("Account No.");
                                "Account Name" := ICPartner.Name;
                            end;
                    end;
                //Set the application to Invoice if Account type is vendor
                if "Account Type" = "Account Type"::Vendor then
                    "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
            end;
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Account Name"; Text[150])
        {
        }
        field(16; Posted; Boolean)
        {
        }
        field(17; "Date Posted"; Date)
        {
        }
        field(18; "Time Posted"; Time)
        {
        }
        field(19; "Posted By"; Code[50])
        {
        }
        field(20; Amount; Decimal)
        {

            trigger OnValidate()
            begin


                CalculateTax();
            end;
        }
        field(21; Remarks; Text[250])
        {
        }
        field(22; "Transaction Name"; Text[100])
        {
        }
        field(23; "VAT Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code WHERE(Type = CONST(VAT));

            trigger OnValidate()
            begin
                if TariffCode.Get("VAT Code") then
                    "VAT Rate" := TariffCode.Percentage
                else
                    "VAT Rate" := 0;
                CalculateTax();
            end;
        }
        field(24; "Withholding Tax Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code WHERE(Type = CONST("W/Tax"));

            trigger OnValidate()
            begin
                if TariffCode.Get("Withholding Tax Code") then
                    "W/Tax Rate" := TariffCode.Percentage
                else
                    "W/Tax Rate" := 0;

                CalculateTax();
            end;
        }
        field(25; "VAT Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                //Should not be entered until VAT Code is entered
                TestField("VAT Code");
                "Net Amount" := Amount - ("VAT Amount" + "Withholding Tax Amount");
                Validate("Net Amount");
            end;
        }
        field(26; "Withholding Tax Amount"; Decimal)
        {

            trigger OnLookup()
            begin
                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;

            trigger OnValidate()
            begin
                //Should not be entered until W/Tax code is entered
                TestField("Withholding Tax Code");
                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;

                "Net Amount" := Amount - ("Withholding Tax Amount" + "VAT Amount");
                Validate("Net Amount");
            end;
        }
        field(27; "Net Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                //MESSAGE('"Currency Factor"::'+ FORMAT("Currency Factor"));
                if "Currency Factor" <> 0 then
                    "NetAmount LCY" := "Net Amount" / "Currency Factor"
                else
                    "NetAmount LCY" := "Net Amount";
            end;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(29; Payee; Text[100])
        {
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name;

                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
                //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(1,"Global Dimension 1 Code","Dimension Set ID");
            end;
        }
        field(31; "Branch Code"; Code[20])
        {
            Description = 'NOt in use please us the shortcut dimension 2 below';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Branch Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;

                ValidateShortcutDimCode(2, "Branch Code");

                //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2,"Shortcut Dimension 2 Code","Dimension Set ID");
            end;
        }
        field(32; "PO/INV No"; Code[20])
        {
        }
        field(33; "Bank Account No"; Code[20])
        {
        }
        field(34; "Cashier Bank Account"; Code[20])
        {
        }
        field(35; Status; Option)
        {
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook;
        }
        field(36; Select; Boolean)
        {
        }
        field(37; Grouping; Code[20])
        {
            TableRelation = "Vendor Posting Group".Code;
        }
        field(38; "Payment Type"; Enum "Payment Type")
        {
        }
        field(39; "Bank Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
        }
        field(40; "PV Type"; Option)
        {
            OptionMembers = Normal,Other;
        }
        field(41; "Apply to"; Code[20])
        {
            TableRelation = "Vendor Ledger Entry"."Vendor No." WHERE("Vendor No." = FIELD("Account No."));
        }
        field(42; "Apply to ID"; Code[20])
        {
        }
        field(43; "No of Units"; Decimal)
        {
        }
        field(44; "Surrender Date"; Date)
        {
        }
        field(45; Surrendered; Boolean)
        {
        }
        field(46; "Surrender Doc. No"; Code[20])
        {
        }
        field(47; "Vote Book"; Code[10])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                /*
                          IF Amount<=0 THEN
                        ERROR('Please enter the Amount');
                
                       //Confirm the Amount to be issued doesnot exceed the budget and amount Committed
                        EVALUATE(CurrMonth,FORMAT(DATE2DMY(Date,2)));
                        EVALUATE(CurrYR,FORMAT(DATE2DMY(Date,3)));
                        EVALUATE(BudgetDate,FORMAT('01'+'/'+CurrMonth+'/'+CurrYR));
                
                          //Get the last day of the month
                
                          LastDay:=CALCDATE('1M', BudgetDate);
                          LastDay:=CALCDATE('-1D',LastDay);
                
                
                        //Get Budget for the G/L
                      IF GenLedSetup.GET THEN BEGIN
                        GLAccount.SETFILTER(GLAccount."Budget Filter",GenLedSetup."Current Budget");
                        GLAccount.SETRANGE(GLAccount."No.","Vote Book");
                        GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                        {Get the exact Monthly Budget}
                        //Start from first date of the budget.//BudgetDate
                        GLAccount.SETRANGE(GLAccount."Date Filter",GenLedSetup."Current Budget Start Date",LastDay);
                
                        IF GLAccount.FIND('-') THEN BEGIN
                         GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                         MonthBudget:=GLAccount."Budgeted Amount";
                         Expenses:=GLAccount."Net Change";
                         BudgetAvailable:=GLAccount."Budgeted Amount"-GLAccount."Net Change";
                         "Total Allocation":=MonthBudget;
                         "Total Expenditure":=Expenses;
                         END;
                
                
                     END;
                
                     CommitmentEntries.RESET;
                     CommitmentEntries.SETCURRENTKEY(CommitmentEntries.Account);
                     CommitmentEntries.SETRANGE(CommitmentEntries.Account,"Vote Book");
                     CommitmentEntries.SETRANGE(CommitmentEntries."Commitment Date",GenLedSetup."Current Budget Start Date",LastDay);
                     CommitmentEntries.CALCSUMS(CommitmentEntries."Committed Amount");
                     CommittedAmount:=CommitmentEntries."Committed Amount";
                
                     "Total Commitments":=CommittedAmount;
                     Balance:=BudgetAvailable-CommittedAmount;
                     "Balance Less this Entry":=BudgetAvailable-CommittedAmount-Amount;
                     MODIFY;
                     {
                     IF CommittedAmount+Amount>BudgetAvailable THEN
                        ERROR('%1,%2,%3,%4','You have Exceeded Budget for G/L Account No',"Vote Book",'by',
                        ABS(BudgetAvailable-(CommittedAmount+Amount)));
                      }
                     //End of Confirming whether Budget Allows Posting
                */

            end;
        }
        field(48; "Total Allocation"; Decimal)
        {
        }
        field(49; "Total Expenditure"; Decimal)
        {
        }
        field(50; "Total Commitments"; Decimal)
        {
        }
        field(51; Balance; Decimal)
        {
        }
        field(52; "Balance Less this Entry"; Decimal)
        {
        }
        field(53; "Applicant Designation"; Text[100])
        {
        }
        field(54; "Petty Cash"; Boolean)
        {
        }
        field(55; "Supplier Invoice No."; Code[30])
        {
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Branch Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;

                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");

                //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2,"Shortcut Dimension 2 Code","Dimension Set ID");
            end;
        }
        field(57; "Imprest Request No"; Code[20])
        {
            TableRelation = "Payments-Users" WHERE(Posted = CONST(false));

            trigger OnValidate()
            begin

                /*
                          TotAmt:=0;
                     //On Delete/Change of Request No. then Clear from Imprest Details
                     IF ("Imprest Request No"='') OR ("Imprest Request No"<>xRec."Imprest Request No") THEN
                        LoadImprestDetails.RESET;
                        LoadImprestDetails.SETRANGE(LoadImprestDetails.No,No);
                        IF LoadImprestDetails.FIND('-') THEN BEGIN
                           LoadImprestDetails.DELETEALL;
                           Amount:=TotAmt;
                           "Net Amount":=Amount;
                           MODIFY;
                
                        END;
                     //New Imprest Details
                     ImprestReqDet.RESET;
                     ImprestReqDet.SETRANGE(ImprestReqDet.No,"Imprest Request No");
                     IF ImprestReqDet.FIND('-') THEN BEGIN
                     REPEAT
                         LoadImprestDetails.INIT;
                         LoadImprestDetails.No:=No;
                         LoadImprestDetails.Date:=ImprestReqDet."Account No:";
                         LoadImprestDetails.Type:=ImprestReqDet."Account Name";
                         LoadImprestDetails."Pay Mode":=ImprestReqDet.Amount;
                         LoadImprestDetails."Cheque No":=ImprestReqDet."Due Date";
                         LoadImprestDetails."Cheque Date":=ImprestReqDet."Imprest Holder";
                         LoadImprestDetails.INSERT;
                         TotAmt:=TotAmt+ImprestReqDet.Amount;
                     UNTIL ImprestReqDet.NEXT=0;
                         Amount:=TotAmt;
                         "Account No.":=ImprestReqDet."Imprest Holder";
                         "Net Amount":=Amount;
                         MODIFY;
                     END;
                {
                       //ImprestDetForm.GETRECORD(LoadImprestDetails);
                }
                      */

            end;
        }
        field(58; "Batched Imprest Tot"; Decimal)
        {
            FieldClass = Normal;
        }
        field(59; "Function Name"; Text[100])
        {
        }
        field(60; "Budget Center Name"; Text[100])
        {
        }
        field(61; "Farmer Purchase No"; Code[20])
        {
        }
        field(62; "Transporter Ananlysis No"; Code[20])
        {
        }
        field(63; "User ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(64; "Journal Template"; Code[20])
        {
        }
        field(65; "Journal Batch"; Code[20])
        {
        }
        field(66; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(67; "Require Surrender"; Boolean)
        {
            Editable = false;
        }
        field(68; "Commited Ammount"; Decimal)
        {
            FieldClass = FlowFilter;
            //TableRelation = Table50019.Field4;
        }
        field(69; "Select to Surrender"; Boolean)
        {
        }
        field(71; "Payment Reference"; Option)
        {
            OptionMembers = Normal,"Farmer Purchase";
        }
        field(72; "ID Number"; Code[8])
        {
        }
        field(73; "VAT Rate"; Decimal)
        {

            trigger OnValidate()
            begin
                /*"VAT Amount":=(Amount * 100);
                "VAT Amount":=Amount-("VAT Amount"/(100 + "VAT Rate"));*/

            end;
        }
        field(74; "Amount With VAT"; Decimal)
        {
        }
        field(75; "Currency Code"; Code[20])
        {
        }
        field(76; "Exchange Rate"; Decimal)
        {
        }
        field(77; "Currency Reciprical"; Decimal)
        {
        }
        field(78; "VAT Prod. Posting Group"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "VAT Product Posting Group".Code;
        }
        field(79; "Budgetary Control A/C"; Boolean)
        {
        }
        field(83; Committed; Boolean)
        {
        }
        field(84; "Currency Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Currency Factor" <> 0 then
                    "NetAmount LCY" := "Net Amount" / "Currency Factor"
                else
                    "NetAmount LCY" := "Net Amount";
            end;
        }
        field(85; "NetAmount LCY"; Decimal)
        {
        }
        field(86; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;

            trigger OnLookup()
            begin
                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;

            trigger OnValidate()
            begin
                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;
        }
        field(87; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
                PayToVendorNo: Code[20];
                OK: Boolean;
                Text000: Label 'You must specify %1 or %2.';
            begin
                //CODEUNIT.RUN(CODEUNIT::"Payment Voucher Apply",Rec);
                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;

                if (Rec."Account Type" <> Rec."Account Type"::Customer) and (Rec."Account Type" <> Rec."Account Type"::Vendor) then
                    Error('You cannot apply to %1', "Account Type");

                with Rec do begin
                    Amount := 0;
                    Validate(Amount);
                    PayToVendorNo := "Account No.";
                    VendLedgEntry.SetCurrentKey("Vendor No.", Open);
                    VendLedgEntry.SetRange("Vendor No.", PayToVendorNo);
                    VendLedgEntry.SetRange(Open, true);
                    if "Applies-to ID" = '' then
                        "Applies-to ID" := No;
                    if "Applies-to ID" = '' then
                        Error(
                          Text000,
                          FieldCaption(No), FieldCaption("Applies-to ID"));
                    //ApplyVendEntries."SetPVLine-Delete"(PVLine,PVLine.FIELDNO("Applies-to ID"));
                    //ApplyVendEntries.SetPVLine(Rec,VendLedgEntry,Rec.FieldNo("Applies-to ID"));
                    ApplyVendEntries.SetRecord(VendLedgEntry);
                    ApplyVendEntries.SetTableView(VendLedgEntry);
                    ApplyVendEntries.LookupMode(true);
                    OK := ApplyVendEntries.RunModal = ACTION::LookupOK;
                    Clear(ApplyVendEntries);
                    if not OK then
                        exit;
                    VendLedgEntry.Reset;
                    VendLedgEntry.SetCurrentKey("Vendor No.", Open);
                    VendLedgEntry.SetRange("Vendor No.", PayToVendorNo);
                    VendLedgEntry.SetRange(Open, true);
                    VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                    if VendLedgEntry.Find('-') then begin
                        "Applies-to Doc. Type" := 0;
                        "Applies-to Doc. No." := '';
                    end else
                        "Applies-to ID" := '';

                end;
                //Calculate  Total To Apply
                VendLedgEntry.Reset;
                VendLedgEntry.SetCurrentKey("Vendor No.", Open, "Applies-to ID");
                VendLedgEntry.SetRange("Vendor No.", PayToVendorNo);
                VendLedgEntry.SetRange(Open, true);
                VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                if VendLedgEntry.Find('-') then begin
                    VendLedgEntry.CalcSums("Amount to Apply");
                    Amount := Abs(VendLedgEntry."Amount to Apply");
                    Validate(Amount);
                    PurchInvheader.Reset;
                    PurchInvheader.SetRange("No.", VendLedgEntry."Document No.");
                    if PurchInvheader.FindFirst then
                        "LPO/LSO" := PurchInvheader."Order No.";

                end;
            end;

            trigger OnValidate()
            begin
                //IF "Applies-to Doc. No." <> '' THEN
                //TESTFIELD("Bal. Account No.",'');

                if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." <> '') and
                   ("Applies-to Doc. No." <> '')
                then begin
                    SetAmountToApply("Applies-to Doc. No.", "Account No.");
                    SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
                end else
                    if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." = '') then
                        SetAmountToApply("Applies-to Doc. No.", "Account No.")
                    else
                        if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and ("Applies-to Doc. No." = '') then
                            SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");

                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;
        }
        field(88; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';

            trigger OnLookup()
            begin
                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;

            trigger OnValidate()
            var
                TempVendLedgEntry: Record "Vendor Ledger Entry";
            begin
                //IF "Applies-to ID" <> '' THEN
                //  TESTFIELD("Bal. Account No.",'');
                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;

                if ("Applies-to ID" <> xRec."Applies-to ID") and (xRec."Applies-to ID" <> '') then begin
                    VendLedgEntry.SetCurrentKey("Vendor No.", Open);
                    VendLedgEntry.SetRange("Vendor No.", "Account No.");
                    VendLedgEntry.SetRange(Open, true);
                    VendLedgEntry.SetRange("Applies-to ID", xRec."Applies-to ID");
                    if VendLedgEntry.FindFirst then
                        VendEntrySetApplID.SetApplId(VendLedgEntry, TempVendLedgEntry, '');

                    VendLedgEntry.Reset;
                end;
            end;
        }
        field(90; "Retention Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code WHERE(Type = CONST(Retention));

            trigger OnValidate()
            begin
                if TariffCode.Get("Retention Code") then
                    "Retention Rate" := TariffCode.Percentage
                else
                    "Retention Rate" := 0;

                CalculateTax();
            end;
        }
        field(91; "Retention  Amount"; Decimal)
        {
        }
        field(92; "Retention Rate"; Decimal)
        {
        }
        field(93; "W/Tax Rate"; Decimal)
        {
        }
        field(94; "Vendor Bank Account"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Vendor)) "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Account No."));

            trigger OnLookup()
            begin
                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;

            trigger OnValidate()
            begin
                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;
        }
        field(95; "Trip No"; Code[20])
        {
        }
        field(96; "Driver No"; Code[20])
        {
        }
        field(97; "Loan No"; Integer)
        {
        }
        field(98; "Grant No"; Code[20])
        {
            //TableRelation = Jobs."No." WHERE("Currency Code" = FIELD("Currency Code"),
            //                                  "Approval Status" = CONST(Approved),
            //                                  Status = CONST(Contract));

            trigger OnValidate()
            begin
                //job.Reset;
                //if job.Get("Grant No") then
                "Account Type" := "Account Type"::Customer;
                //"Account No.":=job."Bill-to Partner No.";
                //VALIDATE("Account No.");
                //"Account Name":=job.Description;
            end;
        }
        field(99; "Grant Phase"; Code[10])
        {
            //TableRelation = Table39004335;
        }
        field(100; "Installment No"; Integer)
        {
        }
        field(101; "Job-Planning Line No"; Integer)
        {
            //TableRelation = Table39004345.Field1 WHERE (Field2=FIELD("Grant No"),
            //                                            Field50008=FIELD("Account No."));
        }
        field(102; "Job No."; Code[10])
        {
            TableRelation = Job."No.";

            trigger OnValidate()
            begin
                CheckWipAccount;
            end;
        }
        field(103; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

            trigger OnValidate()
            begin
                /*
                IF "Job Task No." <> xRec."Job Task No." THEN
                  VALIDATE("Job Planning Line No.",0);
                IF "Job Task No." = '' THEN BEGIN
                  "Job Quantity" := 0;
                  "Job Currency Factor" := 0;
                  "Job Currency Code" := '';
                  "Job Unit Price" := 0;
                  "Job Total Price" := 0;
                  "Job Line Amount" := 0;
                  "Job Line Discount Amount" := 0;
                  "Job Unit Cost" := 0;
                  "Job Total Cost" := 0;
                  "Job Line Discount %" := 0;
                
                  "Job Unit Price (LCY)" := 0;
                  "Job Total Price (LCY)" := 0;
                  "Job Line Amount (LCY)" := 0;
                  "Job Line Disc. Amount (LCY)" := 0;
                  "Job Unit Cost (LCY)" := 0;
                  "Job Total Cost (LCY)" := 0;
                  EXIT;
                END;
                
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  UpdatePricesFromJobJnlLine;
                END;
                */

            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(50000; "Property Code"; Code[30])
        {
            //TableRelation = Table39006123.Field1;
        }
        field(50001; "Transaction Code"; Code[30])
        {
            //TableRelation = Table39006120.Field1;
        }
        field(50002; "Entry Type[Income/Expense]"; Option)
        {
            OptionCaption = ' ,Income,Expense';
            OptionMembers = " ",Income,Expense;
        }
        field(50003; "Asset No"; Code[10])
        {
            TableRelation = "Fixed Asset"."No.";
        }
        field(56000; "Invoice Nos."; Code[20])
        {
            TableRelation = "Vendor Ledger Entry"."Document No." WHERE(Open = CONST(true),
                                                                        "Document Type" = CONST(Invoice),
                                                                        "Vendor No." = FIELD("Account No."));

            trigger OnValidate()
            begin
                VendLedger.Reset;
                VendLedger.SetRange(VendLedger."Document No.", "Invoice Nos.");
                VendLedger.SetRange(VendLedger."Vendor No.", "Account No.");
                VendLedger.SetRange(VendLedger."Document Type", VendLedger."Document Type"::Invoice);
                if VendLedger.FindFirst then begin
                    VendLedger.CalcFields("Remaining Amount");
                    Amount := -VendLedger."Remaining Amount";
                    "Due Date" := VendLedger."Due Date";
                end
            end;
        }
        field(56001; "Due Date"; Date)
        {
        }
        field(56002; "VAT Withholding Amount"; Decimal)
        {
        }
        field(56003; "VAT Withheld Code"; Code[10])
        {
            TableRelation = "Tariff Codes".Code WHERE(Type = CONST("W/Tax"));

            trigger OnValidate()
            begin
                if TariffCode.Get("VAT Withheld Code") then
                    "VAT 6% Rate" := TariffCode.Percentage
                else
                    "VAT 6% Rate" := 0;

                CalculateTax();
            end;
        }
        field(56004; "VAT 6% Rate"; Decimal)
        {
        }
        field(56005; "LPO/LSO"; Code[20])
        {
        }
        field(56006; "Invoice No"; Code[20])
        {
        }
        field(56007; Invested; Boolean)
        {
            //CalcFormula = Exist("Investment Header" WHERE("Paying Document No." = FIELD(No)));
            //FieldClass = FlowField;
        }
        field(56008; "Advance Payment Recovery"; Decimal)
        {
        }
        field(56009; "Reimbursable Amount"; Decimal)
        {
        }
        field(56010; "Recovery Amount"; Decimal)
        {
        }
        field(56011; "LPO No"; Decimal)
        {
        }
        field(56012; "Other Deductions"; Code[20])
        {
            TableRelation = "Tariff Codes".Code WHERE(Type = CONST(Others));

            trigger OnValidate()
            begin
                if TariffCode.Get("Other Deductions") then
                    "Other Deductions Rate" := TariffCode.Percentage
                else
                    "Other Deductions Rate" := 0;

                CalculateTax();
            end;
        }
        field(56013; "Other Deductions Rate"; Decimal)
        {
        }
        field(56014; "Other Deductions Amount"; Decimal)
        {
        }
        field(56015; "Contract No"; Code[50])
        {
        }
        field(56016; "Staff No"; Code[20])
        {
        }
        field(56017; Designation; Text[100])
        {
        }
        field(56018; "Not Budgeted"; Boolean)
        {
            Editable = false;
        }
        field(56019; Milestone; Text[150])
        {
        }
        field(56020; "Vendor PIN No."; Text[30])
        {
            //CalcFormula = Lookup(Vendor."PIN No." WHERE("No." = FIELD("Account No.")));
            //FieldClass = FlowField;
        }
        field(56021; "Board Meeting No"; Code[20])
        {
            //TableRelation = "Board Committee Meetings";
        }
        field(56022; "Board Allowance"; Option)
        {
            OptionMembers = Sitting,Travelling,Lunch,"Per Diem",Airtime,"Chair Honoraria";
        }
        field(56023; "Actual Spent"; Decimal)
        {
        }
        field(56024; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(56025; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(56026; "VAT Withhelding Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Net Amount" := Amount - ("Withholding Tax Amount" + "VAT Withhelding Amount");
                Validate("Net Amount");
            end;
        }
    }

    keys
    {
        key(Key1; "Line No.", No, Type)
        {
            SumIndexFields = Amount, "VAT Amount", "Withholding Tax Amount", "Net Amount", "NetAmount LCY", "Retention  Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PHead.Reset;
        PHead.SetRange(PHead."No.", No);
        if PHead.FindFirst then begin
            if
            (PHead.Status = PHead.Status::Approved) or
             (PHead.Status = PHead.Status::Posted) or
            (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                Error('You Cannot Delete this record its already approved/posted/Send for Approval');
        end;
        TestField(Committed, false);
    end;

    trigger OnInsert()
    begin

        if No = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Normal Payments No");
            NoSeriesMgt.InitSeries(GenLedgerSetup."Normal Payments No", xRec."No. Series", 0D, No, "No. Series");
        end;
        PHead.Reset;
        PHead.SetRange(PHead."No.", No);
        if PHead.FindFirst then begin
            Date := PHead.Date;
            PHead.TestField("Responsibility Center");
            Validate("Global Dimension 1 Code", PHead."Global Dimension 1 Code");
            Validate("Shortcut Dimension 2 Code", PHead."Shortcut Dimension 2 Code");
            //VALIDATE("Shortcut Dimension 3 Code",PHead."Shortcut Dimension 3 Code");
            //VALIDATE("Shortcut Dimension 4 Code",PHead."Shortcut Dimension 4 Code");
            "Contract No" := PHead."Contract No";
            "Dimension Set ID" := PHead."Dimension Set ID";
            "Currency Code" := PHead."Currency Code";
            "Currency Factor" := PHead."Currency Factor";
            "Payment Type" := PHead."Payment Type";
            //"Internal Memo No" := PHead."Internal Memo No";
        end;

        //
        PHead.Reset;
        PHead.SetRange(PHead."No.", No);
        if PHead.FindFirst then begin
            if
            //  (PHead.Status=PHead.Status::Approved)
            (PHead.Status = PHead.Status::Posted) or
             (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                Error('You Cannot modify documents that are approved/posted/Send for Approval');
        end;
        TestField(Committed, false);
    end;

    trigger OnModify()
    begin
        PHead.Reset;
        PHead.SetRange(PHead."No.", No);
        if PHead.FindFirst then begin
            if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
             (PHead.Status = PHead.Status::"Pending Approval") then
                Error('You Cannot modify documents that are approved/posted/Send for Approval');
        end;
        TestField(Committed, false);
    end;

    var
        PH: Record "Payments Header";
        //BSetup: Record "Farmer Purchase Broker Setup";
        VLedgEntry: Record "Vendor Ledger Entry";
        ICPartner: Record "IC Partner";
        FPurch: Record "Purch. Inv. Header";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        CashierLinks: Record "Cash Office User Template";
        GLAccount: Record "G/L Account";
        EntryNo: Integer;
        SingleMonth: Boolean;
        DateFrom: Date;
        DateTo: Date;
        Budget: Decimal;
        CurrMonth: Code[10];
        CurrYR: Code[10];
        BudgDate: Text[30];
        BudgetDate: Date;
        YrBudget: Decimal;
        BudgetDateTo: Date;
        BudgetAvailable: Decimal;
        GenLedSetup: Record "Cash Office Setup";
        "Total Budget": Decimal;
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        LastDay: Date;
        ImprestReqDet: Record "Imprest Details User";
        LoadImprestDetails: Record "Cash Payment Line";
        TotAmt: Decimal;
        DimVal: Record "Dimension Value";
        PHead: Record "Payments Header";
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        GenJnILine: Record "Gen. Journal Line";
        ApplyVendEntries: Page "Apply Vendor Entries";
        TariffCode: Record "Tariff Codes";
        DimMgt: Codeunit DimensionManagement;
        VendLedger: Record "Vendor Ledger Entry";
        //job: Record "HR Employee Qualifications";
        //InvestmentCompany: Record "Investment Company";
        PurchInvheader: Record "Purch. Inv. Header";

    procedure SetAmountToApply(AppliesToDocNo: Code[20]; VendorNo: Code[20])
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        PurchInvheader.Reset;
        PurchInvheader.SetRange("No.", "Applies-to Doc. No.");
        if PurchInvheader.FindFirst then
            "LPO/LSO" := PurchInvheader."Order No.";

        VendLedgEntry.SetCurrentKey("Document No.");
        VendLedgEntry.SetRange("Document No.", AppliesToDocNo);
        VendLedgEntry.SetRange("Vendor No.", VendorNo);
        VendLedgEntry.SetRange(Open, true);
        if VendLedgEntry.FindFirst then begin


            if VendLedgEntry."Amount to Apply" = 0 then begin
                VendLedgEntry.CalcFields("Remaining Amount");
                VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
            end else
                VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Accepted Payment Tolerance" := 0;
            VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
            CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
        end;
    end;

    procedure PayLinesExist(): Boolean
    var
        PayLine: Record "Payment Lines";
    begin
        PayLine.Reset;
        PayLine.SetRange(No, No);
        exit(PayLine.FindFirst);
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Payment', "Line No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure CheckWipAccount()
    var
        FAWIPJob: Record Job;
        FAWIPJobPostingGrp: Record "Job Posting Group";
    begin
        FAWIPJob.Get("Job No.");
        FAWIPJobPostingGrp.Get(FAWIPJob."Job Posting Group");
        TestField("Account Type", "Account Type"::"G/L Account");
        if "Account No." <> FAWIPJobPostingGrp."WIP Costs Account" then
            Error('Insert the right WIP Account %1', FAWIPJobPostingGrp."WIP Costs Account");
    end;

    procedure CalculateTax()
    var
        CalculationType: Option VAT,"W/Tax",Retention;
        TaxCalc: Codeunit "Tax Calculation";
        TotalTax: Decimal;
        a: Decimal;
    begin
        "VAT Amount" := 0;
        "Withholding Tax Amount" := 0;
        "Retention  Amount" := 0;
        TotalTax := 0;
        "Net Amount" := 0;
        "VAT Withholding Amount" := 0;
        "Other Deductions Amount" := 0;
        //******************************** JEFF *******************************************************
        if Amount <> 0 then begin
            if "Retention Rate" <> 0 then begin
                "Retention  Amount" := (Amount * ("Retention Rate" / 100));
                TotalTax := TotalTax + "Retention  Amount"
            end;

            if "VAT Rate" <> 0 then begin
                "VAT Amount" := Round((Amount -/* "Retention  Amount" */-"Advance Payment Recovery" - "Reimbursable Amount") * ("VAT Rate" / 116), 0.01);
                // TotalTax:=TotalTax+"VAT Amount"
            end;

            if "W/Tax Rate" <> 0 then begin
                "Withholding Tax Amount" := Round((Amount -/* "Retention  Amount" */-"Advance Payment Recovery" - "Reimbursable Amount" - "VAT Amount") * ("W/Tax Rate" / 100), 0.01);
                TotalTax := TotalTax + "Withholding Tax Amount";
            end;
        end;
        //******************************** End Contractor Grouping ***************************************
        //"Net Amount":=Amount-TotalTax;
        // VALIDATE("Net Amount");

        //VAT Withholding
        if Amount <> 0 then begin
            if "VAT Amount" <> 0 then begin
                "VAT Withholding Amount" := Round("VAT Amount" * ("VAT 6% Rate" / "VAT Rate"), 0.01);
            end;
        end;
        //VAT Withholding


        if "Other Deductions Rate" <> 0 then begin
            //Other deductions
            "Other Deductions Amount" := (Amount - "VAT Amount") * ("Other Deductions Rate" / 100);
        end;


        "Net Amount" := Round((Amount - "Retention  Amount" - "Reimbursable Amount" - "Advance Payment Recovery" - "VAT Amount"
                       - "Withholding Tax Amount" - "VAT Withholding Amount") + "VAT Amount" + "Reimbursable Amount", 0.01);

        "Net Amount" := "Net Amount" - "Recovery Amount" - "Other Deductions Amount";

        Validate("Net Amount");

    end;
}

