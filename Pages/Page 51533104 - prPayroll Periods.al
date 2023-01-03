page 51533104 "prPayroll Periods"
{
    CardPageID = "prPayroll Period";
    DeleteAllowed = false;
    PageType = List;
    PromotedActionCategories = 'Manage,Process,Report,13th Month,Variance Report';
    SourceTable = "prPayroll Periods";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("Period Month"; Rec."Period Month")
                {
                    Editable = false;
                }
                field("Period Year"; Rec."Period Year")
                {
                    Editable = false;
                }
                field("Period Name"; Rec."Period Name")
                {
                    Editable = false;
                }
                field("Date Opened"; Rec."Date Opened")
                {
                    Editable = false;
                }
                field("Date Closed"; Rec."Date Closed")
                {
                    Editable = false;
                }
                field(Closed; Rec.Closed)
                {
                    Editable = false;
                }
                field(Control1; Rec."Variance Report")
                {
                    ShowCaption = false;
                }
                field("Journal Transferred"; Rec."Journal Transferred")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Close Period")
            {
                Caption = 'Close Period';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*
                    Warn user about the consequence of closure - operation is not reversible.
                    Ask if he is sure about the closure.
                    */

                    fnGetOpenPeriod;

                    Question := 'Once a period has been closed it can NOT be opened.\It is assumed that you have PAID out salaries.\'
                    + 'Do you still want to close [' + strPeriodName + ']';

                    //For Multiple Payroll
                    /*ContrInfo.GET();
                    IF ContrInfo."Multiple Payroll" THEN BEGIN
                    PayrollDefined:='';
                    PayrollType.SETCURRENTKEY(EntryNo);
                    IF PayrollType.FINDFIRST THEN BEGIN
                        NoofRecords:=PayrollType.COUNT;
                        REPEAT
                          i+= 1;
                          PayrollDefined:=PayrollDefined+'&'+PayrollType."Payroll Code";
                          IF i<NoofRecords THEN
                             PayrollDefined:=PayrollDefined+','
                        UNTIL PayrollType.NEXT=0;
                    END;
                    
                    
                            Selection := STRMENU(PayrollDefined,3);
                            PayrollType.RESET;
                            PayrollType.SETRANGE(PayrollType.EntryNo,Selection);
                            IF PayrollType.FIND('-') THEN BEGIN
                                PayrollCode:=PayrollType."Payroll Code";
                            END;
                    END;*/
                    //End Multiple Payroll



                    Answer := DIALOG.Confirm(Question, false);
                    if Answer = true then begin
                        Clear(objOcx);
                        objOcx.fnClosePayrollPeriod(dtOpenPeriod, PayrollCode);
                        Message('Process Complete');
                    end else begin
                        Message('You have selected NOT to Close the period');
                    end

                end;
            }
            action("Create 13th Month")
            {
                Caption = 'Create 13th Month';
                Image = CreateSerialNo;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;

                trigger OnAction()
                begin

                    if Confirm(Text002, true) = false then exit;

                    Periods.Reset;
                    Periods.SetRange(Periods.Closed, false);
                    if Periods.Find('-') then begin

                        Month13Day := CalcDate('1M-1D', Periods."Date Opened");
                        Month13Month := 13;
                        Month13Year := Date2DMY(Periods."Date Opened", 3);

                        //Close Current Month
                        Periods."Is before 13th Month" := true;
                        Periods."Date Closed" := Today;
                        Periods.Closed := true;
                        Periods.Modify;

                        //Create 13th Month
                        Periods.Init;
                        Periods."Date Opened" := Month13Day;
                        Periods."Period Month" := Month13Month;
                        Periods."Period Year" := Month13Year;
                        Periods."Period Name" := '13th Month ' + Format(Month13Year);
                        Periods.Closed := false;
                        Periods.Insert;

                    end;
                end;
            }
            action("Compute Variance")
            {
                Caption = 'Compute Variance';
                Image = RollUpCosts;
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction()
                begin
                    i := 0;

                    PayPeriods.Reset;
                    PayPeriods.SetRange(PayPeriods."Variance Report", true);
                    if PayPeriods.Find('-') then begin
                        if PayPeriods.Count = 2 then begin
                            repeat
                                i := i + 1;

                                if i = 1 then begin
                                    PrevPeriod := PayPeriods."Date Opened";
                                end
                                else begin
                                    CurrPeriod := PayPeriods."Date Opened";
                                end;

                            until PayPeriods.Next = 0
                        end
                        else begin
                            Error('Please select two periods to compare.');
                        end;
                    end
                    else begin
                        Error('Please select the periods.');
                    end;

                    //DELETE DATA
                    varianceTable.Reset;
                    //varianceTable.SETRANGE(varianceTable."User Name",UPPERCASE(USERID));
                    if varianceTable.Find('-') then begin
                        varianceTable.DeleteAll;
                    end;

                    //Employees
                    Employee.Reset;
                    //Employee.SETRANGE(Employee.Status,Employee.Status::Normal);
                    if Employee.Find('-') then begin
                        repeat

                            CurrAmnt := 0;
                            PrevAmnt := 0;

                            //BASIC SALARY
                            //Curr Period
                            salaryCard.Reset;
                            salaryCard.SetRange(salaryCard."Payroll Period", CurrPeriod);
                            salaryCard.SetRange(salaryCard."Employee Code", Employee."No.");
                            salaryCard.SetRange(salaryCard."Transaction Code", 'BPAY');
                            if salaryCard.Find('-') then begin
                                CurrAmnt := salaryCard.Amount;
                            end;

                            //Prev Period

                            salaryCard.Reset;
                            salaryCard.SetRange(salaryCard."Payroll Period", PrevPeriod);
                            salaryCard.SetRange(salaryCard."Employee Code", Employee."No.");
                            salaryCard.SetRange(salaryCard."Transaction Code", 'BPAY');
                            if salaryCard.Find('-') then begin
                                PrevAmnt := salaryCard.Amount
                            end;

                            Variance := PrevAmnt - CurrAmnt;

                            //INSERT
                            varianceTable.Init;
                            varianceTable."lineNo." := varianceTable."lineNo." + 1;
                            varianceTable."Trans Code" := 'BPAY';
                            varianceTable."Trans Name" := 'Basic Pay';
                            varianceTable."Employee code" := Employee."No.";
                            //varianceTable.Period:=CurrPeriod;
                            varianceTable."Curr Amount" := CurrAmnt;
                            varianceTable."Prev Amount" := PrevAmnt;
                            varianceTable.Variance := Variance;
                            varianceTable."Current Period" := CurrPeriod;
                            varianceTable."Previous Period" := PrevPeriod;
                            varianceTable."User Name" := UpperCase(UserId);
                            varianceTable."Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                            varianceTable.Insert;


                            CurrAmnt := 0;
                            PrevAmnt := 0;

                            //NET SALARY
                            //Curr Period
                            salaryCard.Reset;
                            salaryCard.SetRange(salaryCard."Payroll Period", CurrPeriod);
                            salaryCard.SetRange(salaryCard."Employee Code", Employee."No.");
                            salaryCard.SetRange(salaryCard."Transaction Code", 'NPAY');
                            if salaryCard.Find('-') then begin
                                CurrAmnt := salaryCard.Amount;
                            end;

                            //Prev Period

                            salaryCard.Reset;
                            salaryCard.SetRange(salaryCard."Payroll Period", PrevPeriod);
                            salaryCard.SetRange(salaryCard."Employee Code", Employee."No.");
                            salaryCard.SetRange(salaryCard."Transaction Code", 'NPAY');
                            if salaryCard.Find('-') then begin
                                PrevAmnt := salaryCard.Amount
                            end;

                            Variance := PrevAmnt - CurrAmnt;

                            //INSERT
                            varianceTable.Init;
                            varianceTable."lineNo." := varianceTable."lineNo." + 1;
                            varianceTable."Trans Code" := 'NPAY';
                            varianceTable."Trans Name" := 'Net Pay';
                            varianceTable."Employee code" := Employee."No.";
                            //varianceTable.Period:=CurrPeriod;
                            varianceTable."Curr Amount" := CurrAmnt;
                            varianceTable."Prev Amount" := PrevAmnt;
                            varianceTable.Variance := Variance;
                            varianceTable."Current Period" := CurrPeriod;
                            varianceTable."Previous Period" := PrevPeriod;
                            varianceTable."User Name" := UpperCase(UserId);
                            varianceTable."Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                            varianceTable.Insert;


                            //Transaction Codes
                            TransCode.Reset;
                            if TransCode.Find('-') then begin
                                repeat

                                    CurrAmnt := 0;
                                    PrevAmnt := 0;


                                    //Previous Period
                                    PeriodTrans.Reset;
                                    PeriodTrans.SetRange(PeriodTrans."Employee Code", Employee."No.");
                                    PeriodTrans.SetRange(PeriodTrans."Transaction Code", TransCode."Transaction Code");
                                    PeriodTrans.SetRange(PeriodTrans."Payroll Period", PrevPeriod);
                                    if PeriodTrans.Find('-') then begin
                                        repeat
                                            PrevAmnt := PeriodTrans.Amount;
                                        until PeriodTrans.Next = 0
                                    end;

                                    //Current Period
                                    PeriodTrans.Reset;
                                    PeriodTrans.SetRange(PeriodTrans."Employee Code", Employee."No.");
                                    PeriodTrans.SetRange(PeriodTrans."Transaction Code", TransCode."Transaction Code");
                                    PeriodTrans.SetRange(PeriodTrans."Payroll Period", CurrPeriod);
                                    if PeriodTrans.Find('-') then begin
                                        repeat
                                            CurrAmnt := PeriodTrans.Amount;
                                        until PeriodTrans.Next = 0
                                    end;

                                    //INSERT
                                    Variance := PrevAmnt - CurrAmnt;

                                    //INSERT
                                    varianceTable.Init;
                                    varianceTable."lineNo." := varianceTable."lineNo." + 1;
                                    varianceTable."Trans Code" := TransCode."Transaction Code";
                                    varianceTable."Trans Name" := TransCode."Transaction Name";
                                    varianceTable."Employee code" := Employee."No.";
                                    //varianceTable.Period:=CurrPeriod;
                                    varianceTable."Curr Amount" := CurrAmnt;
                                    varianceTable."Prev Amount" := PrevAmnt;
                                    varianceTable.Variance := Variance;
                                    varianceTable."Current Period" := CurrPeriod;
                                    varianceTable."Previous Period" := PrevPeriod;
                                    varianceTable."User Name" := UpperCase(UserId);
                                    varianceTable."Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                                    varianceTable.Insert;

                                until TransCode.Next = 0
                            end;

                        until Employee.Next = 0
                    end;

                    Message('Variance Computed successfully. You can now run the Variance Report');
                end;
            }
            action("Variance Report")
            {
                Caption = 'Variance Report';
                Image = Report2;
                Promoted = true;
                PromotedCategory = Category5;
                //RunObject = Report "prMonthly Variance";
            }
        }
    }

    var
        PayPeriod: Record "prPayroll Periods";
        strPeriodName: Text[30];
        Text000: Label '''Leave without saving changes?''';
        Text001: Label '''You selected %1.''';
        Question: Text[250];
        Answer: Boolean;
        objOcx: Codeunit prPayrollProcessing;
        dtOpenPeriod: Date;
        PayrollType: Record "prPayroll Type";
        Selection: Integer;
        PayrollDefined: Text[30];
        PayrollCode: Code[10];
        NoofRecords: Integer;
        i: Integer;
        ContrInfo: Record "Control-Information";
        Periods: Record "prPayroll Periods";
        Month13Day: Date;
        Month13Month: Integer;
        Month13Year: Integer;
        Text002: Label 'Creating the 13th Month will automatically close the current month and it can not be reopened. (It is assumed that you have paid out the salaries). Do you still want to create the 13th Month?';
        PayPeriods: Record "prPayroll Periods";
        "prtransaction codes": Record "prTransaction Codes";
        CurrAmnt: Decimal;
        PrevAmnt: Decimal;
        CurrPeriod: Date;
        PrevPeriod: Date;
        employees: Record "prEmployee Transactions";
        Variance: Decimal;
        salaryCard: Record "prPeriod Transactions";
        currAmnt2: Decimal;
        Employee: Record "HR Employees";
        Name: Text[60];
        varianceTable: Record "PrMonthly Variance";
        TransCode: Record "prTransaction Codes";
        PeriodTrans: Record "prPeriod Transactions";

    procedure fnGetOpenPeriod()
    begin

        //Get the open/current period
        PayPeriod.SetRange(PayPeriod.Closed, false);
        if PayPeriod.Find('-') then begin
            //Added to ensure journal tranfers are done  before closing periods
            PayPeriod.TestField(PayPeriod."Journal Transferred");
            //
            //IF PayPeriod."Period Month" = 12 THEN ERROR('You need to create the 13th Month before closing '+PayPeriod."Period Name");

            strPeriodName := PayPeriod."Period Name";
            dtOpenPeriod := PayPeriod."Date Opened";
        end;
    end;
}

