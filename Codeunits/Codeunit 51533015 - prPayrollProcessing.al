codeunit 51533015 prPayrollProcessing
{
    // ++Note
    // Tax on Excess Pension Not Clear /Not indicated anywhere
    // Low Interest Benefits
    // VOQ


    trigger OnRun()
    begin
    end;

    var
        Text020: Label 'Because of circular references, the program cannot calculate a formula.';
        Text012: Label 'You have entered an illegal value or a nonexistent row number.';
        Text013: Label 'You have entered an illegal value or a nonexistent column number.';
        Text017: Label 'The error occurred when the program tried to calculate:\';
        Text018: Label 'Acc. Sched. Line: Row No. = %1, Line No. = %2, Totaling = %3\';
        Text019: Label 'Acc. Sched. Column: Column No. = %4, Line No. = %5, Formula  = %6';
        Text023: Label 'Formulas ending with a percent sign require %2 %1 on a line before it.';
        VitalSetup: Record "prVital Setup Info";
        curReliefPersonal: Decimal;
        curReliefInsurance: Decimal;
        curReliefMorgage: Decimal;
        curReliefChild: Decimal;
        curReliefDependant: Decimal;
        curMaximumRelief: Decimal;
        curNssfEmployee: Decimal;
        curNssf_Employer_Factor: Decimal;
        intNHIF_BasedOn: Option Gross,Basic,"Taxable Pay";
        curNHFPerc: Decimal;
        curMaxPensionContrib: Decimal;
        curRateTaxExPension: Decimal;
        curOOIMaxMonthlyContrb: Decimal;
        curOOIDecemberDedc: Decimal;
        curLoanMarketRate: Decimal;
        curLoanCorpRate: Decimal;
        PostingGroup: Record "prEmployee Posting Group";
        TaxAccount: Code[20];
        salariesAcc: Code[20];
        PayablesAcc: Code[20];
        NSSFEMPyer: Code[20];
        PensionEMPyer: Code[20];
        PensionEMPyee: Code[20];
        NSSFEMPyee: Code[20];
        NHIFEMPyer: Code[20];
        NHIFEMPyee: Code[20];
        HrEmployee: Record "HR Employees";
        CoopParameters: Option "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,NSSF;
        PayrollType: Code[20];
        curReliefGrossPerc: Decimal;
        MonthlyReliefAmount: Decimal;
        EmployerAmount: Decimal;
        EmployerBalance: Decimal;
        VitalSetupS: Record "HR Employees";
        TotalTaxable: Decimal;
        Trans: Record "prTransaction Codes";
        Employee: Record "HR Employees";
        EmpTrans: Record "prEmployee Transactions";
        curTaxDeductions: Decimal;
        RemainingDays: Integer;
        TDate: Date;
        i: Integer;
        ArrearsDays: Integer;
        MonthDays: Integer;
        PayTillCutOff: Boolean;
        NoOfUnits: Decimal;
        ProrateAbsence: Boolean;
        SalCard: Record "prSalary Card";
        DayAbsent: Decimal;
        currAnnualPay: Decimal;
        statTaxPay: Decimal;
        DontProrateBPAY: Boolean;
        ExcludeNonTaxRelief: Boolean;
        ProrateAbsBP: Boolean;
        ProrateAbsMonthDays: Boolean;
        ExcludeMonthlyRelief: Boolean;
        curNssfEmployeeFormula: Code[20];
        SelectedPayrollPeriod: Date;
        PeriodTransAmountFCY: Decimal;
        PeriodTransCurrrency: Code[10];
        PeriodTransAmountLCY: Decimal;
        DOM: Integer;
        AngolaPayroll: Boolean;
        SSFBasedOn: Option " ",Basic,Gross,Taxable;
        NewSSFEmployee: Decimal;
        NewSSFEmployer: Decimal;
        OldSSFEmployee: Decimal;
        OldSSFEmployer: Decimal;
        PFEmployee: Decimal;
        PFEmployer: Decimal;
        PFIsAfterTax: Boolean;
        MaxSSF: Decimal;
        ExcessSSF: Decimal;
        "HR Employees": Record "HR Employees";
        Amount13th: Decimal;
        Perc: Decimal;
        PayrollPeriodR: Record "prPayroll Periods";
        PeriodTrans: Record "prPeriod Transactions";
        BonusPAYE: Decimal;
        BonusNetPay: Decimal;
        PayEmploymenTax: Boolean;
        EmploymentTaxPercent: Decimal;
        EmploymentTax: Decimal;
        PretaxDeductions: Decimal;
        MaxSSFEmployee: Decimal;
        MaxSSFEmployer: Decimal;
        QualifyingJuniorBPAY: Decimal;
        "OTTaxUpTo50%BPAY": Decimal;
        "OTTaxExcess50%BPAY": Decimal;
        OTTax: Decimal;
        OTExcessTax: Decimal;
        NormalOT: Decimal;
        ExcessOT: Decimal;
        QualifyingJunior: Boolean;
        OvertimeAllowance: Decimal;

    procedure fnInitialize()
    begin
        //Initialize Global Setup Items
        VitalSetup.FindFirst;
        with VitalSetup do begin
            curReliefPersonal := "Tax Relief";
            curReliefInsurance := "Insurance Relief";
            curReliefMorgage := "Mortgage Relief"; //Same as HOSP
            curMaximumRelief := "Max Relief";
            curReliefChild := "Child Relief";
            curReliefDependant := "Dependants Relief";
            curNssfEmployee := "Max SSF Employee Contribution";
            curNssf_Employer_Factor := "Max SSF Employer Contribution";
            intNHIF_BasedOn := "NHIF Based on";
            curNHFPerc := "NHF - % of Basic Pay";
            curMaxPensionContrib := "Max Pension Contribution";
            curRateTaxExPension := "Tax On Excess Pension";
            curOOIMaxMonthlyContrb := "OOI Deduction";
            curOOIDecemberDedc := "OOI December";
            curLoanMarketRate := "Loan Market Rate";
            curLoanCorpRate := "Loan Corporate Rate";
            curReliefGrossPerc := VitalSetup."Tax Relief % of Gross Income";
            ProrateAbsence := VitalSetup."Prorate Absence";
            DontProrateBPAY := VitalSetup."Don't Prorate Basic Pay";
            ProrateAbsBP := VitalSetup."Prorate Absence Basic Pay";
            ProrateAbsMonthDays := VitalSetup."Prol. Absence on days in month";
            ExcludeNonTaxRelief := VitalSetup."Exclude NonTax from Relief";
            ExcludeMonthlyRelief := VitalSetup."Exclude Monthly Relief";
            AngolaPayroll := VitalSetup."Angola Payroll";
            SSFBasedOn := VitalSetup."SSF Based on";
            NewSSFEmployee := VitalSetup."New SSF Employee %";
            NewSSFEmployer := VitalSetup."New SSF Employer %";
            OldSSFEmployee := VitalSetup."Old SSF Employee %";
            OldSSFEmployer := VitalSetup."Old SSF Employer %";
            MaxSSF := VitalSetup."Max. SSF Contribution";
            MaxSSFEmployee := VitalSetup."Max SSF Employee Contribution";
            MaxSSFEmployer := VitalSetup."Max SSF Employer Contribution";
            PFEmployee := VitalSetup."PF Employee %";
            PFEmployer := VitalSetup."PF Employer %";
            PFIsAfterTax := VitalSetup."PF is After Tax";
            PayEmploymenTax := VitalSetup."Pay Employment Tax";
            EmploymentTaxPercent := VitalSetup."Employment Tax %";
            QualifyingJuniorBPAY := VitalSetup."Qualifyng Junior Monthly BPAY";
            "OTTaxUpTo50%BPAY" := VitalSetup."OT Tax up to 50% BPAY";
            "OTTaxExcess50%BPAY" := VitalSetup."OT Tax Excess 50% BPAY";

        end;
    end;

    procedure fnProcesspayroll(strEmpCode: Code[20]; dtDOE: Date; curBasicPay: Decimal; blnPaysPaye: Boolean; blnPaysSSf: Boolean; blnPaysPF: Boolean; SelectedPeriod: Date; dtOpenPeriod: Date; Membership: Text[30]; ReferenceNo: Text[30]; dtTermination: Date; blnGetsPAYERelief: Boolean; Dept: Code[20]; PayrollCode: Code[20])
    var
        strTableName: Text[50];
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        strTransDescription: Text[50];
        TGroup: Text[30];
        TGroupOrder: Integer;
        TSubGroupOrder: Integer;
        curSalaryArrears: Decimal;
        curPayeArrears: Decimal;
        curGrossPay: Decimal;
        curTotAllowances: Decimal;
        curExcessPension: Decimal;
        curNSSF: Decimal;
        curDefinedContrib: Decimal;
        curPensionStaff: Decimal;
        curNonTaxable: Decimal;
        curGrossTaxable: Decimal;
        curBenefits: Decimal;
        curValueOfQuarters: Decimal;
        curUnusedRelief: Decimal;
        curInsuranceReliefAmount: Decimal;
        curMorgageReliefAmount: Decimal;
        curTaxablePay: Decimal;
        curTaxCharged: Decimal;
        curPAYE: Decimal;
        prPeriodTransactions: Record "prPeriod Transactions";
        intYear: Integer;
        intMonth: Integer;
        LeapYear: Boolean;
        CountDaysofMonth: Integer;
        DaysWorked: Decimal;
        prSalaryArrears: Record "prSalary Arrears";
        prEmployeeTransactions: Record "prEmployee Transactions";
        prTransactionCodes: Record "prTransaction Codes";
        strExtractedFrml: Text[250];
        SpecialTransType: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage;
        TransactionType: Option Income,Deduction;
        curPensionCompany: Decimal;
        curTaxOnExcessPension: Decimal;
        prUnusedRelief: Record "prUnused Relief";
        curNhif_Base_Amount: Decimal;
        curNHIF: Decimal;
        curTotalDeductions: Decimal;
        curNetRnd_Effect: Decimal;
        curNetPay: Decimal;
        curTotCompanyDed: Decimal;
        curOOI: Decimal;
        curHOSP: Decimal;
        curLoanInt: Decimal;
        strTransCode: Text[250];
        fnCalcFringeBenefit: Decimal;
        prEmployerDeductions: Record "prEmployer Deductions";
        JournalPostingType: Option " ","G/L Account",Customer,Vendor;
        JournalAcc: Code[20];
        Customer: Record Customer;
        JournalPostAs: Option " ",Debit,Credit;
        IsCashBenefit: Decimal;
        Text021: Label 'This application is not licensed on this server. Contact your systems administrator.';
        blnDoesPaysPayeOnBasic: Boolean;
        fullBasicPay: Decimal;
        prLatenessSummary: Record prLatenessLedger;
        PrOtherSetups: Record PrOtherSetups;
        checkmorethan5days: Decimal;
        curSSF: Decimal;
        curSSFEmployer: Decimal;
        curPF: Decimal;
        curPFEmployer: Decimal;
    begin
        //Initialize
        fnInitialize;
        fnGetJournalDet(strEmpCode);
        SelectedPayrollPeriod := SelectedPeriod;

        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange("Employee Code", strEmpCode);
        prPeriodTransactions.SetRange("Payroll Period", SelectedPeriod);
        prPeriodTransactions.DeleteAll;


        //PKK
        //PayrollType
        PayrollType := PayrollCode;

        //check if the period selected=current period. If not, do NOT run this function
        if SelectedPeriod <> dtOpenPeriod then exit;
        intMonth := Date2DMY(SelectedPeriod, 2);
        intYear := Date2DMY(SelectedPeriod, 3);


        //ADDED TO CATER FOR THE 13TH MONTH SALARY
        PayrollPeriodR.Reset;
        PayrollPeriodR.SetRange(PayrollPeriodR."Date Opened", SelectedPeriod);
        if PayrollPeriodR.Find('-') then begin
            if PayrollPeriodR."Period Month" <> 13 then begin


                DOM := fnDaysInMonth(SelectedPeriod);

                //PKK
                DayAbsent := 0;


                //insert the lateness ledger
                prLatenessSummary.Reset;
                prLatenessSummary.SetRange(prLatenessSummary."Employee Code", strEmpCode);
                prLatenessSummary.SetRange(prLatenessSummary."Payroll Period", SelectedPeriod);
                if prLatenessSummary.FindSet then begin
                    PrOtherSetups.Reset;
                    PrOtherSetups.SetRange(PrOtherSetups."Transaction Code", prLatenessSummary."Transaction Code");
                    PrOtherSetups.SetRange(PrOtherSetups.Range, prLatenessSummary."No. Of Days");
                    PrOtherSetups.FindSet;

                    prEmployeeTransactions.Reset;
                    prEmployeeTransactions.SetRange("Employee Code", strEmpCode);
                    prEmployeeTransactions.SetRange("Transaction Code", prLatenessSummary."Transaction Code");
                    prEmployeeTransactions.SetRange("Payroll Period", SelectedPeriod);
                    prEmployeeTransactions.DeleteAll;

                    prEmployeeTransactions.Init;
                    prEmployeeTransactions."Employee Code" := strEmpCode;
                    prEmployeeTransactions.Validate("Transaction Code", prLatenessSummary."Transaction Code");
                    Trans.Get(prLatenessSummary."Transaction Code");
                    prEmployeeTransactions."Transaction Name" := Trans."Transaction Name";
                    prEmployeeTransactions."Period Month" := intMonth;
                    prEmployeeTransactions."Period Year" := intYear;
                    prEmployeeTransactions.Validate("Payroll Period", SelectedPeriod);
                    if PrOtherSetups.Amount <> 0 then
                        prEmployeeTransactions.Amount := PrOtherSetups.Amount
                    else begin
                        if PrOtherSetups."Period Type" = PrOtherSetups."Period Type"::Day then
                            prEmployeeTransactions."No of Units" := PrOtherSetups.Period
                        else
                            prEmployeeTransactions."No of Units" := PrOtherSetups.Period * Date2DMY(CalcDate('CM', DMY2Date(1, intMonth, intYear)), 1);
                    end;
                    SalCard.Get(strEmpCode);
                    prEmployeeTransactions.Currency := SalCard.Currency;
                    prEmployeeTransactions.Insert(true);
                end;

                if ProrateAbsence = true then begin
                    Trans.Reset;
                    Trans.SetRange(Trans."Excl. from Basic Pay", true);  //have all that affect basic pay
                    if Trans.FindSet then
                        repeat
                            prEmployeeTransactions.Reset;
                            prEmployeeTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
                            prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
                            prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code", Trans."Transaction Code"); //have all that affect basic pay
                                                                                                                                  //prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Transaction Code",'ABS'); //have all with No. of units
                            prEmployeeTransactions.SetRange(prEmployeeTransactions."Payroll Period", SelectedPeriod);
                            prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended, false);
                            prEmployeeTransactions.SetFilter(prEmployeeTransactions."No of Units", '>%1', 0);
                            if prEmployeeTransactions.Find('-') then begin
                                DayAbsent += prEmployeeTransactions."No of Units";
                            end;
                        until Trans.Next = 0;
                end;

                //added for currency conversion ghana
                SalCard.Get(strEmpCode);
                blnDoesPaysPayeOnBasic := SalCard."Does Not Pay PAYE On Basic";
                if SalCard.Currency <> '' then begin
                    curBasicPay := fnCurrencyConv(SalCard.Currency, SelectedPeriod, curBasicPay, true);
                end;

                fullBasicPay := curBasicPay;

                if curBasicPay > 0 then begin
                    //Get the Basic Salary (prorate basc pay if needed)
                    if (Date2DMY(dtDOE, 2) = Date2DMY(dtOpenPeriod, 2)) and (Date2DMY(dtDOE, 3) = Date2DMY(dtOpenPeriod, 3)) then begin

                        CountDaysofMonth := fnDaysInMonth(dtDOE);
                        DaysWorked := fnDaysWorked(dtDOE, false);
                        //PKK
                        i := 0;
                        RemainingDays := 0;
                        ArrearsDays := 0;
                        //PKK
                        if DontProrateBPAY = false then //PKK
                            curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, DaysWorked, CountDaysofMonth);
                    end;

                    //PKK Prorate Absence
                    if (ProrateAbsence = true) and (ProrateAbsBP = true) then begin
                        if (DayAbsent > 0) and (curBasicPay > 0) then begin
                            CountDaysofMonth := fnDaysInMonth(SelectedPeriod);
                            DaysWorked := fnDaysWorked(SelectedPeriod, false);

                            if ProrateAbsMonthDays = true then
                                curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, CountDaysofMonth - DayAbsent, CountDaysofMonth)
                            else
                                curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, 22 - DayAbsent, 22);

                        end;
                    end;
                    //PKK Prorate Absence


                    //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
                    if dtTermination <> 0D then begin
                        if (Date2DMY(dtTermination, 2) = Date2DMY(dtOpenPeriod, 2)) and (Date2DMY(dtTermination, 3) = Date2DMY(dtOpenPeriod, 3)) then begin
                            CountDaysofMonth := fnDaysInMonth(dtTermination);
                            DaysWorked := fnDaysWorked(dtTermination, true);    //error('%1, %2, %3',countdaysofmonth,dttermination,daysworked);
                            DaysWorked := CountDaysofMonth - DaysWorked;
                            curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, DaysWorked, CountDaysofMonth)
                        end;
                    end;

                    //added to ensure absentism and lateness are reflected in the reports
                    if fullBasicPay <> curBasicPay then begin
                        //error('%1 for %2 for %3',strEmpCode,fullBasicPay,curbasicpay);
                        curTransAmount := fullBasicPay;
                        strTransDescription := 'Basic Pay';
                        TGroup := 'BASIC SALARY';
                        TGroupOrder := 1;
                        TSubGroupOrder := 0;
                        NoOfUnits := 0;
                        fnUpdatePeriodTrans(strEmpCode, 'BPAYFULL', TGroup, TGroupOrder,
                        TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth, intYear, Membership, ReferenceNo, SelectedPeriod, Dept,
                        salariesAcc, JournalPostAs::Debit, JournalPostingType::"G/L Account", '', CoopParameters::none);

                        curTransAmount := fullBasicPay - curBasicPay;
                        //divide the transaction amount into the different components
                        Trans.Reset;
                        Trans.SetRange(Trans."Excl. from Basic Pay", true);
                        if Trans.FindSet then
                            repeat
                                prEmployeeTransactions.Reset;
                                prEmployeeTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
                                prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
                                prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code", Trans."Transaction Code"); //have all that affect basic pay
                                prEmployeeTransactions.SetRange(prEmployeeTransactions."Payroll Period", SelectedPeriod);
                                prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended, false);
                                prEmployeeTransactions.SetFilter(prEmployeeTransactions."No of Units", '>%1', 0);
                                if prEmployeeTransactions.Find('-') then begin
                                    strTransDescription := prEmployeeTransactions."Transaction Name";
                                    TGroup := 'BASIC SALARY';
                                    TGroupOrder := 1;
                                    TSubGroupOrder := 1;
                                    NoOfUnits := 0;
                                    fnUpdatePeriodTrans(strEmpCode, prEmployeeTransactions."Transaction Code", TGroup, TGroupOrder,
                                    TSubGroupOrder, strTransDescription, curTransAmount * (prEmployeeTransactions."No of Units" / DayAbsent), 0, intMonth, intYear, Membership, 'BPAY', SelectedPeriod, Dept,
                                    salariesAcc, JournalPostAs::Debit, JournalPostingType::"G/L Account", '', CoopParameters::none);
                                end;
                            until Trans.Next = 0;
                    end;

                    curTransAmount := curBasicPay;
                    strTransDescription := 'Basic Pay';
                    TGroup := 'BASIC SALARY';
                    TGroupOrder := 1;
                    TSubGroupOrder := 2;
                    NoOfUnits := 0;
                    fnUpdatePeriodTrans(strEmpCode, 'BPAY', TGroup, TGroupOrder,
                    TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth, intYear, Membership, ReferenceNo, SelectedPeriod, Dept,
                    salariesAcc, JournalPostAs::Debit, JournalPostingType::"G/L Account", '', CoopParameters::none);

                    //Added for Countries which pay Employment Tax
                    if PayEmploymenTax then begin
                        EmploymentTax := 0;
                        EmploymentTax := EmploymentTaxPercent / 100 * curBasicPay;

                        //Make Employer Deductions entries
                        if EmploymentTax > 0 then
                            fnUpdateEmployerDeductions(strEmpCode, 'EMPTAX', 'EMP', TGroupOrder, TSubGroupOrder, '', EmploymentTax, 0, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No", SelectedPeriod);

                    end;


                    if blnDoesPaysPayeOnBasic = true then
                        curNonTaxable := curNonTaxable + curBasicPay; //**changes to exclude BPAY from PAYE

                    //Salary Arrears
                    prSalaryArrears.Reset;
                    prSalaryArrears.SetRange(prSalaryArrears."Employee Code", strEmpCode);
                    prSalaryArrears.SetRange(prSalaryArrears."Period Month", intMonth);
                    prSalaryArrears.SetRange(prSalaryArrears."Period Year", intYear);
                    if prSalaryArrears.Find('-') then begin
                        repeat
                            curSalaryArrears := prSalaryArrears."Salary Arrears";
                            curPayeArrears := prSalaryArrears."PAYE Arrears";

                            //Insert [Salary Arrears] into period trans [ARREARS]
                            curTransAmount := curSalaryArrears;
                            strTransDescription := 'Salary Arrears';
                            TGroup := 'ARREARS';
                            TGroupOrder := 1;
                            TSubGroupOrder := 3;
                            NoOfUnits := 0;
                            fnUpdatePeriodTrans(strEmpCode, prSalaryArrears."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                              strTransDescription, curTransAmount, 0, intMonth, intYear, Membership, ReferenceNo, SelectedPeriod, Dept, salariesAcc,
                              JournalPostAs::Debit, JournalPostingType::"G/L Account", '', CoopParameters::none);

                            //Insert [PAYE Arrears] into period trans [PYAR]
                            curTransAmount := curPayeArrears;
                            strTransDescription := 'P.A.Y.E Arrears';
                            TGroup := 'STATUTORIES';
                            TGroupOrder := 7;
                            TSubGroupOrder := 4;
                            NoOfUnits := 0;
                            fnUpdatePeriodTrans(strEmpCode, 'PYAR', TGroup, TGroupOrder, TSubGroupOrder,
                               strTransDescription, curTransAmount, 0, intMonth, intYear, Membership, ReferenceNo, SelectedPeriod, Dept,
                               TaxAccount, JournalPostAs::Debit, JournalPostingType::"G/L Account", '', CoopParameters::none)

                        until prSalaryArrears.Next = 0;
                    end;

                    //Get Earnings
                    currAnnualPay := 0;

                    fnUpdateEmployeeTransCurrency(strEmpCode, SelectedPeriod); //**changes** all transaction to lcy so to ease related calculations

                    prEmployeeTransactions.Reset;
                    prEmployeeTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
                    prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
                    prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
                    prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
                    prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended, false);
                    if prEmployeeTransactions.Find('-') then begin
                        curTotAllowances := 0;
                        IsCashBenefit := 0;

                        repeat

                            //Do not process transactions whose start date is greater than the current period
                            if (prEmployeeTransactions."Start Date" = 0D) or (prEmployeeTransactions."Start Date" < SelectedPeriod) or
                            (prEmployeeTransactions."Start Date" = SelectedPeriod) then begin

                                prTransactionCodes.Reset;
                                prTransactionCodes.SetRange(prTransactionCodes."Transaction Code", prEmployeeTransactions."Transaction Code");
                                prTransactionCodes.SetRange(prTransactionCodes."Transaction Type", prTransactionCodes."Transaction Type"::Income);
                                prTransactionCodes.SetRange(prTransactionCodes."Special Transactions", prTransactionCodes."Special Transactions"::Ignore);
                                if prTransactionCodes.Find('-') then begin
                                    curTransAmount := 0;
                                    curTransBalance := 0;
                                    strTransDescription := '';
                                    strExtractedFrml := '';

                                    if prTransactionCodes."Is Formula" then begin
                                        strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                                        curTransAmount := Round(fnFormulaResult(strExtractedFrml)); //Get the calculated amount
                                    end else begin
                                        curTransAmount := prEmployeeTransactions."Amount LCY";
                                    end;

                                    if prTransactionCodes."Balance Type" = prTransactionCodes."Balance Type"::None then //[0=None, 1=Increasing, 2=Reducing]
                                        curTransBalance := 0;
                                    if prTransactionCodes."Balance Type" = prTransactionCodes."Balance Type"::Increasing then
                                        curTransBalance := prEmployeeTransactions.Balance + curTransAmount;
                                    if prTransactionCodes."Balance Type" = prTransactionCodes."Balance Type"::Reducing then
                                        curTransBalance := prEmployeeTransactions.Balance - curTransAmount;


                                    //Start Ghana Qualifying Junior Overtime Taxation
                                    if prTransactionCodes."Is Overtime Allowance" then begin
                                        QualifyingJunior := false;
                                        //Check if Employee is a Qualifying Junior
                                        if curBasicPay <= QualifyingJuniorBPAY then begin
                                            QualifyingJunior := true;
                                            OvertimeAllowance := prEmployeeTransactions."Amount LCY";
                                            OTTax := 0;
                                            OTExcessTax := 0;
                                            NormalOT := 0;
                                            ExcessOT := 0;

                                            //Tax Overtime up to 50% of BPAY
                                            if prEmployeeTransactions."Amount LCY" <= (0.5 * curBasicPay) then begin
                                                OTTax := "OTTaxUpTo50%BPAY" / 100 * OvertimeAllowance;

                                                strTransDescription := 'P.A.Y.E Overtime';
                                                TGroup := 'STATUTORIES';
                                                TGroupOrder := 7;
                                                TSubGroupOrder := 5;
                                                fnUpdatePeriodTrans(strEmpCode, 'PAYEOT', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                                                 OTTax, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, TaxAccount, JournalPostAs::Credit,
                                                 JournalPostingType::"G/L Account", '', CoopParameters::none);

                                            end
                                            //End Tax Overtime up to 50% of BPAY

                                            //Tax Overtime Excess 50% of BPAY
                                            else begin
                                                NormalOT := 0.5 * curBasicPay;
                                                OTTax := "OTTaxUpTo50%BPAY" / 100 * NormalOT;

                                                strTransDescription := 'P.A.Y.E Overtime';
                                                TGroup := 'STATUTORIES';
                                                TGroupOrder := 7;
                                                TSubGroupOrder := 5;
                                                fnUpdatePeriodTrans(strEmpCode, 'PAYEOT', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                                                 OTTax, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, TaxAccount, JournalPostAs::Credit,
                                                 JournalPostingType::"G/L Account", '', CoopParameters::none);

                                                ExcessOT := OvertimeAllowance - NormalOT;
                                                OTExcessTax := "OTTaxExcess50%BPAY" / 100 * ExcessOT;

                                                strTransDescription := 'P.A.Y.E Excess Overtime';
                                                TGroup := 'STATUTORIES';
                                                TGroupOrder := 7;
                                                TSubGroupOrder := 7;
                                                fnUpdatePeriodTrans(strEmpCode, 'PAYEEXCESSOT', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                                                 OTExcessTax, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, TaxAccount, JournalPostAs::Credit,
                                                 JournalPostingType::"G/L Account", '', CoopParameters::none);

                                            end;
                                            //End Tax Overtime Excess 50% of BPAY

                                        end;
                                        //End Check if Employee is a Qualifying Junior
                                    end;
                                    //End Ghana Qualifying Junior Overtime Taxation


                                    //Prorate Allowances Here
                                    //Get the Basic Salary (prorate basc pay if needed) //Termination Remaining
                                    if prTransactionCodes."Excl. from Proration" = false then
                                        if (Date2DMY(dtDOE, 2) = Date2DMY(dtOpenPeriod, 2)) and (Date2DMY(dtDOE, 3) = Date2DMY(dtOpenPeriod, 3)) then begin
                                            CountDaysofMonth := fnDaysInMonth(dtDOE);
                                            DaysWorked := fnDaysWorked(dtDOE, false);
                                            curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, DaysWorked, CountDaysofMonth)
                                        end
                                        else
                                            curTransAmount := curTransAmount;

                                    //PKK Added
                                    //       IF prTransactionCodes."Excl. from Proration" = TRUE THEN
                                    //          curTransAmount := 0;
                                    //PKK Added

                                    //PKK Prorate absence
                                    if ProrateAbsence = true then begin
                                        if prTransactionCodes."Prorate Absence" = true then begin
                                            if curTransAmount > 0 then begin
                                                if DayAbsent > 0 then begin
                                                    CountDaysofMonth := fnDaysInMonth(SelectedPeriod);
                                                    DaysWorked := fnDaysWorked(SelectedPeriod, false);

                                                    if ProrateAbsMonthDays = true then
                                                        curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, CountDaysofMonth - DayAbsent,
                                                                          CountDaysofMonth)
                                                    else
                                                        curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, 22 - DayAbsent, 22);

                                                end;
                                            end;
                                        end;
                                    end;

                                    //PKK Prorate absence

                                    //{What if someone leaves within the same month they are employed}
                                    if prTransactionCodes."Excl. from Proration" = false then begin
                                        if dtTermination <> 0D then begin
                                            if (Date2DMY(dtTermination, 2) = Date2DMY(dtOpenPeriod, 2)) and (Date2DMY(dtTermination, 3) = Date2DMY(dtOpenPeriod, 3)) then begin
                                                CountDaysofMonth := fnDaysInMonth(dtTermination);
                                                DaysWorked := fnDaysWorked(dtTermination, true);
                                                DaysWorked := CountDaysofMonth - DaysWorked;
                                                curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, DaysWorked, CountDaysofMonth)
                                            end;
                                        end;
                                    end;
                                    // Prorate Allowances Here


                                    //Add Non Taxable Here
                                    if (not prTransactionCodes.Taxable) and (prTransactionCodes."Special Transactions" =
                                    prTransactionCodes."Special Transactions"::Ignore) then
                                        curNonTaxable := curNonTaxable + curTransAmount;

                                    //Added to ensure special transaction that are not taxable are not inlcuded in list of Allowances
                                    if (not prTransactionCodes.Taxable) and (prTransactionCodes."Special Transactions" <>
                                    prTransactionCodes."Special Transactions"::Ignore) then
                                        curTransAmount := 0;

                                    //PKK - Annual Trans
                                    if prTransactionCodes."Annual Pay" = true then
                                        currAnnualPay := currAnnualPay + curTransAmount;

                                    curTotAllowances := curTotAllowances + curTransAmount; //Sum-up all the allowances
                                    curTransAmount := curTransAmount;
                                    curTransBalance := curTransBalance;
                                    strTransDescription := prTransactionCodes."Transaction Name";
                                    TGroup := 'ALLOWANCE';
                                    TGroupOrder := 3;
                                    TSubGroupOrder := 0;

                                    //Get the posting Details
                                    JournalPostingType := JournalPostingType::" ";
                                    JournalAcc := '';
                                    if prTransactionCodes.Subledger <> prTransactionCodes.Subledger::" " then begin
                                        if prTransactionCodes.Subledger = prTransactionCodes.Subledger::Customer then begin
                                            HrEmployee.Get(strEmpCode);
                                            Customer.Reset;
                                            //Customer.SETRANGE(Customer."Payroll/Staff No",HrEmployee."Sacco Staff No");
                                            Customer.SetRange(Customer."No.", HrEmployee."No.");
                                            if Customer.Find('-') then begin
                                                JournalAcc := Customer."No.";
                                                JournalPostingType := JournalPostingType::Customer;
                                            end;
                                        end;
                                    end else begin
                                        JournalAcc := prTransactionCodes."GL Account";
                                        JournalPostingType := JournalPostingType::"G/L Account";
                                    end;

                                    //Get is Cash Benefits
                                    if prTransactionCodes."Is Cash" then
                                        IsCashBenefit := IsCashBenefit + curTransAmount;
                                    //End posting Details
                                    NoOfUnits := prEmployeeTransactions."No of Units";
                                    fnUpdatePeriodTrans(strEmpCode, prTransactionCodes."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                                    strTransDescription, curTransAmount, curTransBalance, intMonth, intYear, prEmployeeTransactions.Membership,
                                    prEmployeeTransactions."Reference No", SelectedPeriod, Dept, JournalAcc, JournalPostAs::Debit, JournalPostingType, '',
                                    prTransactionCodes."coop parameters");
                                end;

                            end;//Do not process transactions whose start date is greater than the current period

                        until prEmployeeTransactions.Next = 0;
                    end;

                    //Calc GrossPay = (BasicSalary + Allowances + SalaryArrears) [Group Order = 4]
                    curGrossPay := (curBasicPay + curTotAllowances + curSalaryArrears);

                    curTransAmount := curGrossPay;
                    strTransDescription := 'Gross Pay';
                    TGroup := 'GROSS PAY';
                    TGroupOrder := 4;
                    TSubGroupOrder := 0;
                    fnUpdatePeriodTrans(strEmpCode, 'GPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth,
                     intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" ", '', CoopParameters::none);


                    //PKK - NG Relief
                    /*
                    //Annual Relief
                    IF (((curGrossPay*12) * 0.01) + ((curGrossPay*12) * 0.2)) >
                       (curReliefPersonal+((curReliefGrossPerc/100)*(curGrossPay*12))) THEN
                    MonthlyReliefAmount:=((curGrossPay*12) * 0.01) + ((curGrossPay*12) * 0.2)
                    ELSE
                    MonthlyReliefAmount:=curReliefPersonal+((curReliefGrossPerc/100)*(curGrossPay*12));

                    //Monthly Relief
                    MonthlyReliefAmount:=MonthlyReliefAmount/12;
                    */
                    //Annual Relief
                    if ExcludeNonTaxRelief = true then begin
                        if (((((curGrossPay - (currAnnualPay + curNonTaxable)) * 12) + currAnnualPay) * 0.01) +
                           ((((curGrossPay - (currAnnualPay + curNonTaxable)) * 12) + currAnnualPay) * 0.2)) >
                           (curReliefPersonal + ((curReliefGrossPerc / 100) * (curGrossPay * 12))) then
                            MonthlyReliefAmount := ((((curGrossPay - (currAnnualPay + curNonTaxable)) * 12) + currAnnualPay) * 0.01)
                                                 + ((((curGrossPay - (currAnnualPay + curNonTaxable)) * 12) + currAnnualPay) * 0.2)
                        else
                            MonthlyReliefAmount := curReliefPersonal + ((curReliefGrossPerc / 100) *
                                                 ((((curGrossPay - (currAnnualPay + curNonTaxable)) * 12) + currAnnualPay)));

                    end else begin
                        if (((((curGrossPay - (currAnnualPay + curNonTaxable)) * 12) + currAnnualPay) * 0.01) +
                           ((((curGrossPay - currAnnualPay) * 12) + currAnnualPay) * 0.2)) >
                           (curReliefPersonal + ((curReliefGrossPerc / 100) * (curGrossPay * 12))) then
                            MonthlyReliefAmount := ((((curGrossPay - currAnnualPay) * 12) + currAnnualPay) * 0.01)
                                                 + ((((curGrossPay - currAnnualPay) * 12) + currAnnualPay) * 0.2)
                        else
                            MonthlyReliefAmount := curReliefPersonal + ((curReliefGrossPerc / 100) * ((((curGrossPay - currAnnualPay) * 12) + currAnnualPay)));
                    end;

                    if ExcludeMonthlyRelief = true then
                        MonthlyReliefAmount := 0;

                    //Monthly Relief
                    //MonthlyReliefAmount:=MonthlyReliefAmount/12;


                    //PKK NG
                    curTaxDeductions := 0;

                    Trans.Reset;
                    //Trans.SETRANGE(Trans.Pension,TRUE);
                    Trans.SetRange(Trans."Add to Relief", true);
                    if Trans.Find('-') then begin
                        repeat
                            EmpTrans.Reset;
                            EmpTrans.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
                            EmpTrans.SetRange("Employee Code", strEmpCode);
                            EmpTrans.SetRange(EmpTrans."Transaction Code", Trans."Transaction Code");
                            EmpTrans.SetRange("Period Month", intMonth);
                            EmpTrans.SetRange("Period Year", intYear);
                            EmpTrans.SetRange(Suspended, false);
                            if EmpTrans.Find('-') then begin
                                repeat
                                    curTaxDeductions := curTaxDeductions + EmpTrans."Amount LCY";

                                until EmpTrans.Next = 0
                            end;
                        until Trans.Next = 0;
                    end;

                    //PKK
                    //MonthlyReliefAmount:=MonthlyReliefAmount+curTaxDeductions;
                    MonthlyReliefAmount := MonthlyReliefAmount + (curTaxDeductions * 12);
                    //PKK

                    //PKKGet the N.H.F amount for the month
                    curNHIF := 0;
                    curNhif_Base_Amount := 0;

                    if intNHIF_BasedOn = intNHIF_BasedOn::Gross then //>NHIF calculation can be based on:
                        curNhif_Base_Amount := curGrossPay;
                    if intNHIF_BasedOn = intNHIF_BasedOn::Basic then
                        curNhif_Base_Amount := curBasicPay;
                    if intNHIF_BasedOn = intNHIF_BasedOn::"Taxable Pay" then
                        curNhif_Base_Amount := curTaxablePay;

                    /*
                     IF blnPaysNhif THEN BEGIN
                      curNHIF:=curNhif_Base_Amount*curNHFPerc*0.01;//fnGetEmployeeNHIF(curNhif_Base_Amount);
                      curTransAmount := curNHIF;
                      strTransDescription := 'N.H.F';
                      TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 2;
                      fnUpdatePeriodTrans (strEmpCode, 'NHF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                       curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
                       NHIFEMPyee,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::none);
                     END;
                    */
                    //PKK
                    //MonthlyReliefAmount:=MonthlyReliefAmount+curNHIF;
                    MonthlyReliefAmount := MonthlyReliefAmount + (curNHIF * 12);


                    if (curReliefChild + curReliefDependant) > 0 then
                        MonthlyReliefAmount := MonthlyReliefAmount + ((curReliefChild + curReliefDependant));///12 //PKK-NG


                    //PKK

                    //PKK NG



                    curReliefPersonal := 0;
                    //PKK - NG Relief

                    /*
                     //Get the NSSF amount
                     IF blnPaysNssf THEN
                       curNSSF := curNssfEmployee;
                    */

                    curTransAmount := curNSSF;
                    strTransDescription := 'N.S.S.F';
                    TGroup := 'STATUTORIES';
                    TGroupOrder := 7;
                    TSubGroupOrder := 1;
                    fnUpdatePeriodTrans(strEmpCode, 'NSSF', TGroup, TGroupOrder, TSubGroupOrder,
                    strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, NSSFEMPyee,
                    JournalPostAs::Credit, JournalPostingType::"G/L Account", '', CoopParameters::NSSF);


                    //Ghana SSF
                    ExcessSSF := 0;

                    if blnPaysSSf then begin
                        curSSF := 0;
                        curSSFEmployer := 0;
                        HrEmployee.Reset;
                        if HrEmployee.Get(strEmpCode) then begin

                            /*
                            if (HrEmployee."Social Security Scheme" = HrEmployee."Social Security Scheme"::New) then begin
                                curSSF := NewSSFEmployee / 100 * curBasicPay;
                                curSSFEmployer := NewSSFEmployer / 100 * curBasicPay;
                            end
                            else
                                if (HrEmployee."Social Security Scheme" = HrEmployee."Social Security Scheme"::Old) then begin
                                    curSSF := OldSSFEmployee / 100 * curBasicPay;
                                    curSSFEmployer := OldSSFEmployer / 100 * curBasicPay;
                                end;
                                */
                        end;

                        //Check for Maximum SSNIT contribution (Zambia)
                        if MaxSSFEmployee <> 0 then begin
                            if curSSF > MaxSSFEmployee then curSSF := MaxSSFEmployee;
                        end;
                        if MaxSSFEmployer <> 0 then begin
                            if curSSFEmployer > MaxSSFEmployer then curSSFEmployer := MaxSSFEmployer;
                        end;


                        //Check for Maximum PAYE SSNIT contribution (Zambia)
                        if (MaxSSF <> 0) then begin

                            if (curSSF > MaxSSF) then begin
                                //Get Excess SSF and insert it as a deduction
                                ExcessSSF := 0;
                                ExcessSSF := curSSF - MaxSSF;
                                strTransDescription := 'Excess NAPSA';
                                TGroup := 'DEDUCTIONS';
                                TGroupOrder := 8;
                                TSubGroupOrder := 0;
                                fnUpdatePeriodTrans(strEmpCode, 'ExcSSF', TGroup, TGroupOrder, TSubGroupOrder,
                                strTransDescription, ExcessSSF, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, NSSFEMPyee,
                                JournalPostAs::Credit, JournalPostingType::"G/L Account", '', CoopParameters::none);

                                //Then make SSF to be the MaxSSF
                                curSSF := MaxSSF;
                            end;

                        end;

                        curTransAmount := curSSF;
                        strTransDescription := 'Social Security';
                        TGroup := 'STATUTORIES';
                        TGroupOrder := 5;
                        TSubGroupOrder := 0;
                        fnUpdatePeriodTrans(strEmpCode, 'SSF', TGroup, TGroupOrder, TSubGroupOrder,
                        strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, NSSFEMPyee,
                        JournalPostAs::Credit, JournalPostingType::"G/L Account", '', CoopParameters::NSSF);

                        //Make Employer Deductions entries
                        if curSSFEmployer > 0 then
                            fnUpdateEmployerDeductions(strEmpCode, 'SSF', 'EMP', TGroupOrder, TSubGroupOrder, '', curSSFEmployer, 0, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No", SelectedPeriod);

                    end;


                    //Ghana PF
                    if blnPaysPF then begin
                        curPF := 0;
                        curPFEmployer := 0;

                        curPF := PFEmployee / 100 * curBasicPay;
                        curPFEmployer := PFEmployer / 100 * curBasicPay;

                        curTransAmount := curPF;
                        strTransDescription := 'Provident Fund';

                        //Provident Fund can either be PreTax or AfterTax
                        if PFIsAfterTax then begin
                            TGroup := 'DEDUCTIONS';
                            TGroupOrder := 8;
                            TSubGroupOrder := 0;
                        end else begin
                            TGroup := 'STATUTORIES';
                            TGroupOrder := 5;
                            TSubGroupOrder := 0;
                        end;

                        fnUpdatePeriodTrans(strEmpCode, 'PF', TGroup, TGroupOrder, TSubGroupOrder,
                        strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, PensionEMPyee,
                        JournalPostAs::Credit, JournalPostingType::"G/L Account", '', CoopParameters::Pension);

                        //Make Employer Deductions entries
                        if curPFEmployer > 0 then
                            fnUpdateEmployerDeductions(strEmpCode, 'PF', 'EMP', TGroupOrder, TSubGroupOrder, '', curPFEmployer, 0, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No", SelectedPeriod);

                    end;




                    //Get the Defined contribution to post based on the Max Def contrb allowed   ****************All Defined Contributions not included
                    curDefinedContrib := curNSSF; //(curNSSF + curPensionStaff + curNonTaxable) - curMorgageReliefAmount
                    curTransAmount := curDefinedContrib;
                    strTransDescription := 'Defined Contributions';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 1;
                    NoOfUnits := 0;
                    fnUpdatePeriodTrans(strEmpCode, 'DEFCON', TGroup, TGroupOrder, TSubGroupOrder,
                     strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ",
                     JournalPostingType::" ", '', CoopParameters::none);


                    //Get the Gross taxable amount
                    //>GrossTaxable = Gross + Benefits + nValueofQuarters  ******Confirm CurValueofQuaters
                    curGrossTaxable := curGrossPay + curBenefits + curValueOfQuarters;

                    //>If GrossTaxable = 0 Then TheDefinedToPost = 0
                    if curGrossTaxable = 0 then curDefinedContrib := 0;

                    //Personal Relief
                    // if get relief is ticked  - DENNO ADDED
                    if blnGetsPAYERelief then begin
                        curReliefPersonal := curReliefPersonal + curUnusedRelief; //*****Get curUnusedRelief
                        curTransAmount := curReliefPersonal;
                        strTransDescription := 'Personal Relief';
                        TGroup := 'TAX CALCULATIONS';
                        TGroupOrder := 6;
                        TSubGroupOrder := 9;
                        fnUpdatePeriodTrans(strEmpCode, 'PSNR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                         curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" ", '',
                         CoopParameters::none);
                    end
                    else
                        curReliefPersonal := 0;

                    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    //>Pension Contribution [self] relief
                    curPensionStaff := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                    SpecialTransType::"Defined Contribution", false);//Self contrib Pension is 1 on [Special Transaction]
                    if curPensionStaff > 0 then begin
                        if curPensionStaff > curMaxPensionContrib then
                            curTransAmount := curMaxPensionContrib
                        else
                            curTransAmount := curPensionStaff;
                        strTransDescription := 'Pension Relief';
                        TGroup := 'TAX CALCULATIONS';
                        TGroupOrder := 6;
                        TSubGroupOrder := 2;
                        fnUpdatePeriodTrans(strEmpCode, 'PNSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                        curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" ", '',
                        CoopParameters::none)
                    end;

                    //if he PAYS paye only*******************I
                    if blnPaysPaye and blnGetsPAYERelief then begin
                        //Get Insurance Relief
                        curInsuranceReliefAmount := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                        SpecialTransType::"Life Insurance", false); //Insurance is 3 on [Special Transaction]
                        if curInsuranceReliefAmount > 0 then begin
                            curTransAmount := curInsuranceReliefAmount;
                            strTransDescription := 'Insurance Relief';
                            TGroup := 'TAX CALCULATIONS';
                            TGroupOrder := 6;
                            TSubGroupOrder := 8;
                            fnUpdatePeriodTrans(strEmpCode, 'INSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                            curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" ", '',
                            CoopParameters::none);
                        end;

                        //>OOI
                        curOOI := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                        SpecialTransType::"Owner Occupier Interest", false); //Morgage is LAST on [Special Transaction]
                        if curOOI > 0 then begin
                            if curOOI <= curOOIMaxMonthlyContrb then
                                curTransAmount := curOOI
                            else
                                curTransAmount := curOOIMaxMonthlyContrb;

                            strTransDescription := 'Owner Occupier Interest';
                            TGroup := 'TAX CALCULATIONS';
                            TGroupOrder := 6;
                            TSubGroupOrder := 3;
                            fnUpdatePeriodTrans(strEmpCode, 'OOI', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                            curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" ", '',
                            CoopParameters::none);
                        end;

                        //HOSP
                        curHOSP := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                        SpecialTransType::"Home Ownership Savings Plan", false); //Home Ownership Savings Plan
                        if curHOSP > 0 then begin
                            if curHOSP <= curReliefMorgage then
                                curTransAmount := curHOSP
                            else
                                curTransAmount := curReliefMorgage;

                            strTransDescription := 'Home Ownership Savings Plan';
                            TGroup := 'TAX CALCULATIONS';
                            TGroupOrder := 6;
                            TSubGroupOrder := 4;
                            fnUpdatePeriodTrans(strEmpCode, 'HOSP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                            curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" ", '',
                            CoopParameters::none);
                        end;

                        //Enter NonTaxable Amount
                        if curNonTaxable > 0 then begin
                            strTransDescription := 'Other Non-Taxable Benefits';
                            TGroup := 'TAX CALCULATIONS';
                            TGroupOrder := 6;
                            TSubGroupOrder := 5;
                            fnUpdatePeriodTrans(strEmpCode, 'NONTAX', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                            curNonTaxable, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" ", '',
                            CoopParameters::none);
                        end;

                    end;

                    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    /*
                     //>Company pension, Excess pension, Tax on excess pension
                     curPensionCompany := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear, SpecialTransType::"Defined Contribution",
                     TRUE); //Self contrib Pension is 1 on [Special Transaction]
                     IF curPensionCompany > 0 THEN BEGIN
                         curTransAmount := curPensionCompany;
                         strTransDescription := 'Pension (Company)';
                         //Update the Employer deductions table

                         curExcessPension:= curPensionCompany - curMaxPensionContrib;
                         IF curExcessPension > 0 THEN BEGIN
                             curTransAmount := curExcessPension;
                             strTransDescription := 'Excess Pension';
                             TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 5;
                             fnUpdatePeriodTrans (strEmpCode, 'EXCP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                              intMonth,intYear,'','',SelectedPeriod);

                             curTaxOnExcessPension := (curRateTaxExPension / 100) * curExcessPension;
                             curTransAmount := curTaxOnExcessPension;
                             strTransDescription := 'Tax on ExPension';
                             TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 6;
                             fnUpdatePeriodTrans (strEmpCode, 'TXEP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                              intMonth,intYear,'','',SelectedPeriod);
                         END;
                     END;
                     */

                    //Get the Taxable amount for calculation of PAYE
                    //>prTaxablePay = (GrossTaxable - SalaryArrears) - (TheDefinedToPost + curSelfPensionContrb + MorgageRelief)


                    //Added For Pretax Deductions
                    PretaxDeductions := 0;

                    Trans.Reset;
                    Trans.SetRange(Trans."Transaction Type", Trans."Transaction Type"::Deduction);
                    Trans.SetRange(Trans."Pre-Tax Deduction", true);
                    if Trans.Find('-') then begin
                        repeat
                            EmpTrans.Reset;
                            EmpTrans.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
                            EmpTrans.SetRange("Employee Code", strEmpCode);
                            EmpTrans.SetRange(EmpTrans."Transaction Code", Trans."Transaction Code");
                            EmpTrans.SetRange("Period Month", intMonth);
                            EmpTrans.SetRange("Period Year", intYear);
                            EmpTrans.SetRange(Suspended, false);
                            if EmpTrans.Find('-') then begin
                                repeat
                                    PretaxDeductions := PretaxDeductions + EmpTrans."Amount LCY";

                                until EmpTrans.Next = 0
                            end;
                        until Trans.Next = 0;
                    end;



                    //Add HOSP and MORTGAGE KIM{}
                    if (curPensionStaff + curDefinedContrib) > curMaxPensionContrib then
                        curTaxablePay := curGrossTaxable - (curSalaryArrears + curSSF + curPF + curMaxPensionContrib + curOOI + curHOSP + curNonTaxable + curTaxDeductions + PretaxDeductions)
                    else
                        curTaxablePay := curGrossTaxable - (curSalaryArrears + curSSF + curPF + curPensionStaff + curOOI + curHOSP + curNonTaxable + curTaxDeductions + PretaxDeductions);

                    //Readd PF if it is AfterTax
                    if PFIsAfterTax then curTaxablePay := curTaxablePay + curPF;

                    //Remove Overtime Allowance from Normal Taxation if employee is a qualifying junior
                    if QualifyingJunior then curTaxablePay := curTaxablePay - OvertimeAllowance;

                    //curTransAmount := (curTaxablePay - MonthlyReliefAmount/12); //curTaxablePay; **changes
                    curTransAmount := curTaxablePay;
                    strTransDescription := 'Taxable Pay';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 6;
                    fnUpdatePeriodTrans(strEmpCode, 'TXBP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                     curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" ", '',
                     CoopParameters::none);

                    //Get the Tax charged for the month
                    if not AngolaPayroll then
                        curTaxCharged := fnGetEmployeePaye(curTaxablePay, strEmpCode);
                    //else
                    //    curTaxCharged := fnGetEmployeePayeAngola(curTaxablePay, strEmpCode);


                    /*
                     //PKK-NG ADDED
                     IF (curGrossPay*0.01) > curTaxCharged THEN
                     curTaxCharged:=(curGrossPay*0.01);
                     //PKK-NG ADDED
                    */

                    curTransAmount := curTaxCharged;
                    strTransDescription := 'Tax Charged';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 7;
                    fnUpdatePeriodTrans(strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                    curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" ", '',
                    CoopParameters::none);


                    //Get the Net PAYE amount to post for the month
                    if (curReliefPersonal + curInsuranceReliefAmount) > curMaximumRelief then
                        curPAYE := curTaxCharged - curMaximumRelief
                    else
                        curPAYE := curTaxCharged - (curReliefPersonal + curInsuranceReliefAmount);

                    if not blnPaysPaye then curPAYE := 0; //Get statutory Exemption for the staff. If exempted from tax, set PAYE=0
                    curTransAmount := curPAYE;
                    if curPAYE < 0 then curTransAmount := 0;
                    strTransDescription := 'P.A.Y.E';
                    TGroup := 'STATUTORIES';
                    TGroupOrder := 7;
                    TSubGroupOrder := 3;
                    fnUpdatePeriodTrans(strEmpCode, 'PAYE', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                     curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, TaxAccount, JournalPostAs::Credit,
                     JournalPostingType::"G/L Account", '', CoopParameters::none);

                    //Store the unused relief for the current month
                    //>If Paye<0 then "Insert into tblprUNUSEDRELIEF
                    if curPAYE < 0 then begin
                        prUnusedRelief.Reset;
                        prUnusedRelief.SetRange(prUnusedRelief."Employee Code", strEmpCode);
                        prUnusedRelief.SetRange(prUnusedRelief."Period Month", intMonth);
                        prUnusedRelief.SetRange(prUnusedRelief."Period Year", intYear);
                        if prUnusedRelief.Find('-') then
                            prUnusedRelief.Delete;

                        prUnusedRelief.Reset;
                        with prUnusedRelief do begin
                            Init;
                            "Employee Code" := strEmpCode;
                            "Unused Relief" := curPAYE;
                            "Period Month" := intMonth;
                            "Period Year" := intYear;
                            Insert;

                            curPAYE := 0;
                        end;
                    end;

                    //Deductions: get all deductions for the month
                    //Loans: calc loan deduction amount, interest, fringe benefit (employer deduction), loan balance
                    //>Balance = (Openning Bal + Deduction)...//Increasing balance
                    //>Balance = (Openning Bal - Deduction)...//Reducing balance
                    //>NB: some transactions (e.g Sacco shares) can be made by cheque or cash. Allow user to edit the outstanding balance


                    //Get the N.H.F amount for the month GBT //PKK
                    /*
                    curNhif_Base_Amount :=0;

                    IF intNHIF_BasedOn =intNHIF_BasedOn::Gross THEN //>NHIF calculation can be based on:
                            curNhif_Base_Amount := curGrossPay;
                    IF intNHIF_BasedOn = intNHIF_BasedOn::Basic THEN
                           curNhif_Base_Amount := curBasicPay;
                    IF intNHIF_BasedOn =intNHIF_BasedOn::"Taxable Pay" THEN
                           curNhif_Base_Amount := curTaxablePay;


                    IF blnPaysNhif THEN BEGIN
                     curNHIF:=curNhif_Base_Amount*curNHFPerc*0.01;//fnGetEmployeeNHIF(curNhif_Base_Amount);
                     curTransAmount := curNHIF;
                     strTransDescription := 'N.H.F';
                     TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 2;
                     fnUpdatePeriodTrans (strEmpCode, 'NHF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                      curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
                      NHIFEMPyee,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::none);
                    END;
                    */
                    //PKK

                    prEmployeeTransactions.Reset;
                    prEmployeeTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
                    prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
                    prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
                    prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
                    prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended, false);
                    if prEmployeeTransactions.Find('-') then begin
                        curTotalDeductions := 0;
                        repeat

                            //Do not process transactions whose start date is greater than the current period
                            if (prEmployeeTransactions."Start Date" = 0D) or (prEmployeeTransactions."Start Date" < SelectedPeriod) or
                            (prEmployeeTransactions."Start Date" = SelectedPeriod) then begin

                                EmployerAmount := 0; //PKK
                                EmployerBalance := 0; //PKK

                                prTransactionCodes.Reset;
                                prTransactionCodes.SetRange(prTransactionCodes."Transaction Code", prEmployeeTransactions."Transaction Code");
                                prTransactionCodes.SetRange(prTransactionCodes."Transaction Type", prTransactionCodes."Transaction Type"::Deduction);
                                if prTransactionCodes.Find('-') then begin
                                    curTransAmount := 0;
                                    curTransBalance := 0;
                                    strTransDescription := '';
                                    strExtractedFrml := '';

                                    if prTransactionCodes."Is Formula" then begin
                                        strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                                        curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount

                                    end else begin
                                        curTransAmount := prEmployeeTransactions."Amount LCY";
                                    end;

                                    //Prorate Deductions Here
                                    //If Employee date of join is after period start
                                    if prTransactionCodes."Excl. from Proration" = false then
                                        if (Date2DMY(dtDOE, 2) = Date2DMY(dtOpenPeriod, 2)) and (Date2DMY(dtDOE, 3) = Date2DMY(dtOpenPeriod, 3)) then begin
                                            CountDaysofMonth := fnDaysInMonth(dtDOE);
                                            DaysWorked := fnDaysWorked(dtDOE, false);
                                            curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, DaysWorked, CountDaysofMonth)
                                        end
                                        else
                                            curTransAmount := curTransAmount;


                                    //Prorate absence
                                    if ProrateAbsence = true then begin
                                        if prTransactionCodes."Prorate Absence" = true then begin
                                            if curTransAmount > 0 then begin
                                                if DayAbsent > 0 then begin
                                                    CountDaysofMonth := fnDaysInMonth(SelectedPeriod);
                                                    DaysWorked := fnDaysWorked(SelectedPeriod, false);

                                                    if ProrateAbsMonthDays = true then
                                                        curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, CountDaysofMonth - DayAbsent,
                                                                          CountDaysofMonth)
                                                    else
                                                        curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, 22 - DayAbsent, 22);

                                                end;
                                            end;
                                        end;
                                    end;

                                    //If employee leaves before end of period
                                    if prTransactionCodes."Excl. from Proration" = false then begin
                                        if dtTermination <> 0D then begin
                                            if (Date2DMY(dtTermination, 2) = Date2DMY(dtOpenPeriod, 2)) and (Date2DMY(dtTermination, 3) = Date2DMY(dtOpenPeriod, 3)) then begin
                                                CountDaysofMonth := fnDaysInMonth(dtTermination);
                                                DaysWorked := fnDaysWorked(dtTermination, true);
                                                DaysWorked := CountDaysofMonth - DaysWorked;
                                                curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, DaysWorked, CountDaysofMonth)
                                            end;
                                        end;
                                    end;
                                    // End of Prorate Deductions


                                    //PKK EMPLOYER TRANSACTION
                                    EmployerAmount := 0;
                                    EmployerBalance := 0;

                                    if (prTransactionCodes."Employer Deduction") or (prTransactionCodes."Include Employer Deduction") then begin
                                        if prTransactionCodes."Is Formula for employer" <> '' then begin
                                            strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes."Is Formula for employer");
                                            EmployerAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount


                                            prEmployeeTransactions."Employer Amount" := EmployerAmount;
                                            prEmployeeTransactions.Modify;

                                            EmployerBalance := prEmployeeTransactions."Employer Balance" + EmployerAmount;

                                        end else begin
                                            EmployerAmount := prEmployeeTransactions."Employer Amount";

                                            prEmployeeTransactions."Employer Amount" := EmployerAmount;
                                            prEmployeeTransactions.Modify;

                                            EmployerBalance := prEmployeeTransactions."Employer Balance" + EmployerAmount;

                                        end;
                                    end;

                                    //PKK EMPLOYER TRANSACTION

                                    //**************************If "deduct Premium" is not ticked and the type is insurance- Dennis*****
                                    if (prTransactionCodes."Special Transactions" = prTransactionCodes."Special Transactions"::"Life Insurance")
                                      and (prTransactionCodes."Deduct Premium" = false) then begin
                                        curTransAmount := 0;
                                    end;

                                    //**************************If "deduct Premium" is not ticked and the type is mortgage- Dennis*****
                                    if (prTransactionCodes."Special Transactions" = prTransactionCodes."Special Transactions"::Morgage)
                                     and (prTransactionCodes."Deduct Mortgage" = false) then begin
                                        curTransAmount := 0;
                                    end;




                                    //Get the posting Details
                                    JournalPostingType := JournalPostingType::" ";
                                    JournalAcc := '';
                                    if prTransactionCodes.Subledger <> prTransactionCodes.Subledger::" " then begin
                                        if prTransactionCodes.Subledger = prTransactionCodes.Subledger::Customer then begin
                                            Customer.Reset;
                                            HrEmployee.Get(strEmpCode);
                                            Customer.Reset;
                                            //IF prTransactionCodes.CustomerPostingGroup ='' THEN
                                            //Customer.SETRANGE(Customer."Employer Code",'KPSS');

                                            //IF prTransactionCodes.CustomerPostingGroup <>'' THEN
                                            //Customer.SETRANGE(Customer."Customer Posting Group",prTransactionCodes.CustomerPostingGroup);

                                            //Customer.SETRANGE(Customer."Payroll/Staff No",HrEmployee."Sacco Staff No");
                                            Customer.SetRange(Customer."No.", HrEmployee."No.");
                                            if Customer.Find('-') then begin
                                                JournalAcc := Customer."No.";
                                                JournalPostingType := JournalPostingType::Customer;
                                            end;
                                        end;
                                    end else begin
                                        JournalAcc := prTransactionCodes."GL Account";
                                        JournalPostingType := JournalPostingType::"G/L Account";
                                    end;

                                    //End posting Details


                                    //Loan Calculation is Amortized do Calculations here -Monthly Principal and Interest Keeps on Changing
                                    if (prTransactionCodes."Special Transactions" = prTransactionCodes."Special Transactions"::"Staff Loan") and
                                       (prTransactionCodes."Repayment Method" = prTransactionCodes."Repayment Method"::Amortized) then begin
                                        curTransAmount := 0;
                                        curLoanInt := 0;
                                        curLoanInt := fnCalcLoanInterest(strEmpCode, prEmployeeTransactions."Transaction Code",
                                        prTransactionCodes."Interest Rate", prTransactionCodes."Repayment Method",
                                           prEmployeeTransactions."Original Amount", prEmployeeTransactions.Balance, SelectedPeriod, false);
                                        //Post the Interest
                                        if (curLoanInt <> 0) then begin
                                            curTransAmount := curLoanInt;
                                            curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                                            curTransBalance := 0;
                                            strTransCode := prEmployeeTransactions."Transaction Code" + '-INT';
                                            strTransDescription := prEmployeeTransactions."Transaction Name" + 'Interest';
                                            TGroup := 'DEDUCTIONS';
                                            TGroupOrder := 8;
                                            TSubGroupOrder := 1;
                                            NoOfUnits := prEmployeeTransactions."No of Units";
                                            fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                                              strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                                              prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No", SelectedPeriod, Dept,
                                              JournalAcc, JournalPostAs::Credit, JournalPostingType, prEmployeeTransactions."Loan Number",
                                              CoopParameters::"loan Interest")
                                        end;
                                        //Get the Principal Amt
                                        curTransAmount := prEmployeeTransactions."Amortized Loan Total Repay Amt" - curLoanInt;
                                        //Modify PREmployeeTransaction Table
                                        prEmployeeTransactions."Amount LCY" := curTransAmount;
                                        prEmployeeTransactions.Modify;

                                    end;
                                    //Loan Calculation Amortized

                                    case prTransactionCodes."Balance Type" of //[0=None, 1=Increasing, 2=Reducing]
                                        prTransactionCodes."Balance Type"::None:
                                            curTransBalance := 0;
                                        prTransactionCodes."Balance Type"::Increasing:
                                            curTransBalance := prEmployeeTransactions.Balance + curTransAmount;
                                        prTransactionCodes."Balance Type"::Reducing:
                                            begin
                                                //curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                                                if prEmployeeTransactions.Balance < prEmployeeTransactions."Amount LCY" then begin
                                                    curTransAmount := prEmployeeTransactions.Balance;
                                                    curTransBalance := 0;
                                                end else begin
                                                    curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                                                end;
                                                if curTransBalance < 0 then begin
                                                    curTransAmount := 0;
                                                    curTransBalance := 0;
                                                end;
                                            end
                                    end;

                                    curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                                    curTransAmount := curTransAmount;
                                    curTransBalance := curTransBalance;
                                    strTransDescription := prTransactionCodes."Transaction Name";

                                    //Added to distinguish between pretax and after tax deductions
                                    if prTransactionCodes."Pre-Tax Deduction" then begin
                                        TGroup := 'DEDUCTIONS';
                                        TGroupOrder := 5;
                                        TSubGroupOrder := 0;
                                    end else begin
                                        TGroup := 'DEDUCTIONS';
                                        TGroupOrder := 8;
                                        TSubGroupOrder := 0;
                                    end;

                                    if prTransactionCodes."coop parameters" = prTransactionCodes."coop parameters"::Pension then TGroup := 'STATUTORIES';

                                    fnUpdatePeriodTrans(strEmpCode, prEmployeeTransactions."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                                     strTransDescription, curTransAmount, curTransBalance, intMonth,
                                     intYear, prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No", SelectedPeriod, Dept,
                                     JournalAcc, JournalPostAs::Credit, JournalPostingType, prEmployeeTransactions."Loan Number",
                                     prTransactionCodes."coop parameters");

                                    //Check if transaction is loan. Get the Interest on the loan & post it at this point before moving next ****Loan Calculation
                                    if (prTransactionCodes."Special Transactions" = prTransactionCodes."Special Transactions"::"Staff Loan") and
                                       (prTransactionCodes."Repayment Method" <> prTransactionCodes."Repayment Method"::Amortized) then begin

                                        curLoanInt := fnCalcLoanInterest(strEmpCode, prEmployeeTransactions."Transaction Code",
                                       prTransactionCodes."Interest Rate",
                                        prTransactionCodes."Repayment Method", prEmployeeTransactions."Original Amount",
                                        prEmployeeTransactions.Balance, SelectedPeriod, prTransactionCodes.Welfare);
                                        if curLoanInt > 0 then begin
                                            curTransAmount := curLoanInt;
                                            curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                                            curTransBalance := 0;
                                            strTransCode := prEmployeeTransactions."Transaction Code" + '-INT';
                                            strTransDescription := prEmployeeTransactions."Transaction Name" + 'Interest';
                                            TGroup := 'DEDUCTIONS';
                                            TGroupOrder := 8;
                                            TSubGroupOrder := 1;
                                            NoOfUnits := prEmployeeTransactions."No of Units";
                                            fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                                              strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                                              prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No", SelectedPeriod, Dept,
                                              JournalAcc, JournalPostAs::Credit, JournalPostingType, prEmployeeTransactions."Loan Number",
                                              CoopParameters::"loan Interest")
                                        end;
                                    end;
                                    //End Loan transaction calculation
                                    //Fringe Benefits and Low interest Benefits
                                    if prTransactionCodes."Fringe Benefit" = true then begin
                                        if prTransactionCodes."Interest Rate" < curLoanMarketRate then begin
                                            fnCalcFringeBenefit := (((curLoanMarketRate - prTransactionCodes."Interest Rate") * curLoanCorpRate) / 1200)
                                             * prEmployeeTransactions.Balance;
                                        end;
                                    end else begin
                                        fnCalcFringeBenefit := 0;
                                    end;
                                    if fnCalcFringeBenefit > 0 then begin
                                        fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code" + '-FRG',
                                         'EMP', TGroupOrder, TSubGroupOrder, 'Fringe Benefit Tax', fnCalcFringeBenefit, 0, intMonth, intYear,
                                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No", SelectedPeriod)

                                    end;
                                    //End Fringe Benefits

                                    //Create Employer Deduction
                                    EmployerAmount := 0;
                                    EmployerBalance := 0;
                                    if (prTransactionCodes."Employer Deduction") or (prTransactionCodes."Include Employer Deduction") then begin
                                        if prTransactionCodes."Is Formula for employer" <> '' then begin
                                            strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes."Is Formula for employer");
                                            curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount

                                        end else begin
                                            curTransAmount := prEmployeeTransactions."Employer Amount";

                                        end;
                                        if curTransAmount > 0 then
                                            fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code",
                                             'EMP', TGroupOrder, TSubGroupOrder, '', curTransAmount, 0, intMonth, intYear,
                                              prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No", SelectedPeriod)

                                    end;
                                    //Employer deductions

                                end;

                            end;//Do not process transactions whose start date is greater than the current period

                        until prEmployeeTransactions.Next = 0;
                        //GET TOTAL DEDUCTIONS
                        //PKK ADD NHF to TOTAL DEDUCTIONS
                        //curTotalDeductions:=curTotalDeductions+curNHIF;

                        curTransBalance := 0;
                        strTransCode := 'TOT-DED';
                        strTransDescription := 'TOTAL DEDUCTION';
                        TGroup := 'DEDUCTIONS';
                        TGroupOrder := 8;
                        TSubGroupOrder := 9;
                        NoOfUnits := prEmployeeTransactions."No of Units";
                        fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                          strTransDescription, curTotalDeductions, curTransBalance, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No", SelectedPeriod, Dept,
                          '', JournalPostAs::" ", JournalPostingType::" ", '', CoopParameters::none);

                        EmployerAmount := 0; //PKK
                        EmployerBalance := 0; //PKK

                        //END GET TOTAL DEDUCTIONS
                    end;

                    //Net Pay: calculate the Net pay for the month in the following manner:
                    //>Nett = Gross - (xNssfAmount + curMyNhifAmt + PAYE + PayeArrears + prTotDeductions)
                    //...Tot Deductions also include (SumLoan + SumInterest)
                    curNetPay := curGrossPay - (curSSF + curPF + curNHIF + curPAYE + curPayeArrears + curTotalDeductions + IsCashBenefit + ExcessSSF);

                    //Deduct Overtime Tax if employee is qualifying junior
                    if QualifyingJunior then curNetPay := curNetPay - OTTax - OTExcessTax;

                    //>Nett = Nett - curExcessPension
                    //...Excess pension is only used for tax. Staff is not paid the amount hence substract it
                    curNetPay := curNetPay; //- curExcessPension

                    //>Nett = Nett - cSumEmployerDeductions
                    //...Employer Deductions are used for reporting as cost to company BUT dont affect Net pay
                    curNetPay := curNetPay - curTotCompanyDed; //******Get Company Deduction*****


                    curNetRnd_Effect := curNetPay - Round(curNetPay);
                    curTransAmount := curNetPay;

                    strTransDescription := 'Net Pay';
                    TGroup := 'NET PAY';
                    TGroupOrder := 9;
                    TSubGroupOrder := 0;
                    NoOfUnits := 0;
                    fnUpdatePeriodTrans(strEmpCode, 'NPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                    curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                    PayablesAcc, JournalPostAs::Credit, JournalPostingType::"G/L Account", '', CoopParameters::none);

                    //Rounding Effect: if the Net pay is rounded, take the rounding effect &
                    //save it as an earning for the staff for the next month
                    //>Insert the Netpay rounding effect into the tblRoundingEffect table


                    //Negative pay: if the NetPay<0 then log the entry
                    //>Display an on screen report
                    //>Through a pop-up to the user
                    //>Send an email to the user or manager
                end;

                //ADDED TO CATER FOR THE 13TH MONTH SALARY
            end else begin

                "HR Employees".Reset;
                if "HR Employees".Get(strEmpCode) then begin
                    "HR Employees".TestField("HR Employees"."Date Of Join");

                    PayrollPeriodR.Reset;
                    PayrollPeriodR.SetRange(PayrollPeriodR."Date Opened", SelectedPeriod);
                    if PayrollPeriodR.Find('-') then begin
                        Amount13th := 0;
                        BonusPAYE := 0;
                        BonusNetPay := 0;

                        VitalSetup.Get;
                        Perc := VitalSetup."13th Month %";

                        if VitalSetup."Calculate 13th Month On" = VitalSetup."Calculate 13th Month On"::BPay then begin
                            if Date2DMY("HR Employees"."Date Of Join", 3) = Date2DMY(PayrollPeriodR."Date Opened", 3) then
                                Amount13th := ("HR Employees"."Basic Pay" * Perc * 0.01) * (((12 - Date2DMY("HR Employees"."Date Of Join", 2) + 1)) / 12)
                            else
                                Amount13th := "HR Employees"."Basic Pay" * Perc * 0.01;
                        end else

                            if VitalSetup."Calculate 13th Month On" = VitalSetup."Calculate 13th Month On"::GPay then begin
                                PeriodTrans.Reset;
                                PeriodTrans.SetRange("Employee Code", "HR Employees"."No.");
                                PeriodTrans.SetRange("Transaction Code", 'GPAY');
                                PeriodTrans.FindLast;
                                if Date2DMY("HR Employees"."Date Of Join", 3) = Date2DMY(PayrollPeriodR."Date Opened", 3) then
                                    Amount13th := (PeriodTrans.Amount * Perc * 0.01) * (((12 - Date2DMY("HR Employees"."Date Of Join", 2) + 1)) / 12)
                                else
                                    Amount13th := PeriodTrans.Amount * Perc * 0.01;
                            end else

                                if VitalSetup."Calculate 13th Month On" = VitalSetup."Calculate 13th Month On"::NPay then begin
                                    PeriodTrans.Reset;
                                    PeriodTrans.SetRange("Employee Code", "HR Employees"."No.");
                                    PeriodTrans.SetRange("Transaction Code", 'NPAY');
                                    PeriodTrans.FindLast;
                                    if Date2DMY("HR Employees"."Date Of Join", 3) = Date2DMY(PayrollPeriodR."Date Opened", 3) then
                                        Amount13th := (PeriodTrans.Amount * Perc * 0.01) * (((12 - Date2DMY("HR Employees"."Date Of Join", 2) + 1)) / 12)
                                    else
                                        Amount13th := PeriodTrans.Amount * Perc * 0.01;
                                end;

                        //Entries for Bonus Pay
                        strTransDescription := 'Bonus Pay';
                        TGroup := 'BASIC SALARY';
                        TGroupOrder := 1;
                        TSubGroupOrder := 2;
                        NoOfUnits := 0;
                        fnUpdatePeriodTrans(strEmpCode, 'BONPAY', TGroup, TGroupOrder,
                        TSubGroupOrder, strTransDescription, Amount13th, 0, PayrollPeriodR."Period Month", intYear, Membership, ReferenceNo, SelectedPeriod, Dept,
                        salariesAcc, JournalPostAs::Debit, JournalPostingType::"G/L Account", '', CoopParameters::none);

                        //Entries for Bonus PAYE
                        BonusPAYE := 0.05 * Amount13th;
                        strTransDescription := 'P.A.Y.E';
                        TGroup := 'STATUTORIES';
                        TGroupOrder := 7;
                        TSubGroupOrder := 3;
                        fnUpdatePeriodTrans(strEmpCode, 'PAYE', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                         BonusPAYE, 0, PayrollPeriodR."Period Month", intYear, '', '', SelectedPeriod, Dept, TaxAccount, JournalPostAs::Credit,
                         JournalPostingType::"G/L Account", '', CoopParameters::none);

                        //Entries for Bonus Net Pay
                        BonusNetPay := Amount13th - BonusPAYE;
                        strTransDescription := 'Net Pay';
                        TGroup := 'NET PAY';
                        TGroupOrder := 9;
                        TSubGroupOrder := 0;
                        NoOfUnits := 0;
                        fnUpdatePeriodTrans(strEmpCode, 'NPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                        BonusNetPay, 0, PayrollPeriodR."Period Month", intYear, '', '', SelectedPeriod, Dept,
                        PayablesAcc, JournalPostAs::Credit, JournalPostingType::"G/L Account", '', CoopParameters::none);



                    end;

                end;







            end;
        end;

    end;

    procedure fnBasicPayProrated(strEmpCode: Code[20]; Month: Integer; Year: Integer; BasicSalary: Decimal; DaysWorked: Decimal; DaysInMonth: Integer) ProratedAmt: Decimal
    begin
        ProratedAmt := Round((DaysWorked / DaysInMonth) * BasicSalary);
    end;

    procedure fnDaysInMonth(dtDate: Date) DaysInMonth: Integer
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;
    begin
        //VitalSetup.GET();

        TodayDate := dtDate;
        /*
         Day:=DATE2DMY(TodayDate,1);
         Expr1:=FORMAT(-Day)+'D+1D';
         FirstDay:=CALCDATE(Expr1,TodayDate);
         LastDate:=CALCDATE('1M-1D',FirstDay);
        
         SysDate.RESET;
         SysDate.SETRANGE(SysDate."Period Type",SysDate."Period Type"::Date);
         SysDate.SETRANGE(SysDate."Period Start",FirstDay,LastDate);
         SysDate.SETFILTER(SysDate."Period No.",'1..5');
         IF SysDate.FIND('-') THEN
            DaysInMonth:=SysDate.COUNT;
        */

        //W days in month
        MonthDays := CalcDate('-1D', CalcDate('1M', DMY2Date(1, Date2DMY(TodayDate, 2), Date2DMY(TodayDate, 3)))) -
                    DMY2Date(1, Date2DMY(TodayDate, 2), Date2DMY(TodayDate, 3));

        TDate := DMY2Date(1, Date2DMY(TodayDate, 2), Date2DMY(TodayDate, 3));

        i := 0;
        repeat
            i := i + 1;

            if VitalSetup."Prol. Based on days in month" = true then begin
                DaysInMonth := DaysInMonth + 1;
            end else begin
                if (Date2DWY(TDate, 1) <> 6) and (Date2DWY(TDate, 1) <> 7) then
                    DaysInMonth := DaysInMonth + 1;
            end;

            TDate := CalcDate('1D', TDate);

        until i = MonthDays + 1;
        //W days in month

    end;

    procedure fnUpdatePeriodTrans(EmpCode: Code[20]; TCode: Code[20]; TGroup: Code[20]; GroupOrder: Integer; SubGroupOrder: Integer; Description: Text[50]; curAmount: Decimal; curBalance: Decimal; Month: Integer; Year: Integer; mMembership: Text[30]; ReferenceNo: Text[30]; dtOpenPeriod: Date; Department: Code[20]; JournalAC: Code[20]; PostAs: Option " ",Debit,Credit; JournalACType: Option " ","G/L Account",Customer,Vendor; LoanNo: Code[10]; CoopParam: Option "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension)
    var
        prPeriodTransactions: Record "prPeriod Transactions";
        prSalCard: Record "HR Employees";
    begin

        if curAmount = 0 then exit;
        with prPeriodTransactions do begin
            Init;
            "Employee Code" := EmpCode;
            "Transaction Code" := TCode;
            "Group Text" := TGroup;
            "Transaction Name" := Description;
            fnUpdatePeriodTransCurrency(EmpCode, TCode, Month, Year, dtOpenPeriod, curAmount);
            Amount := Round(curAmount, 0.01, '=');
            Currency := PeriodTransCurrrency;
            AmountFCY := PeriodTransAmountFCY;
            Balance := curBalance;
            "Emp Amount" := EmployerAmount;
            "Emp Balance" := EmployerBalance;
            "Original Amount" := Balance;
            "Group Order" := GroupOrder;
            "Sub Group Order" := SubGroupOrder;
            Membership := mMembership;
            "Reference No" := ReferenceNo;
            "Period Month" := Month;
            "Period Year" := Year;
            "Payroll Period" := dtOpenPeriod;
            "Department Code" := Department;
            "Journal Account Type" := JournalACType;
            "Post As" := PostAs;
            "Journal Account Code" := JournalAC;
            "Loan Number" := LoanNo;
            "coop parameters" := CoopParam;
            "No. Of Units" := NoOfUnits;
            "Payroll Code" := PayrollType;
            prPeriodTransactions."Payslip Order" := 0;
            //Paymode
            if prSalCard.Get(EmpCode) then begin
                "Payment Mode" := prSalCard."Payment Mode";
                //"Location/Division" := prSalCard."Dimension 3 Code";
                //Department := prSalCard."Dimension 1 Code";
                "Cost Centre" := prSalCard."Cost Code";
                "Salary Grade" := prSalCard."Salary Grade";
                "Salary Notch" := prSalCard."Salary Notch/Step";
            end;
            if Trans.Get(TCode) then begin
                if Trans."Non-Transactional" = false then begin
                    if Trans.Frequency = Trans.Frequency::Varied then
                        prPeriodTransactions."Payslip Order" := 2
                end;
            end;
            Insert;
            //Update the prEmployee Transactions  with the Amount
            fnUpdateEmployeeTrans("Employee Code", "Transaction Code", Amount, "Period Month", "Period Year", "Payroll Period", "Reference No");
        end;
    end;

    procedure fnGetSpecialTransAmount(strEmpCode: Code[20]; intMonth: Integer; intYear: Integer; intSpecTransID: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage; blnCompDedc: Boolean) SpecialTransAmount: Decimal
    var
        prEmployeeTransactions: Record "prEmployee Transactions";
        prTransactionCodes: Record "prTransaction Codes";
        strExtractedFrml: Text[250];
    begin
        SpecialTransAmount := 0;
        prTransactionCodes.Reset;
        prTransactionCodes.SetRange(prTransactionCodes."Special Transactions", intSpecTransID);
        if prTransactionCodes.Find('-') then begin
            repeat
                prEmployeeTransactions.Reset;
                prEmployeeTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code", prTransactionCodes."Transaction Code");
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
                prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended, false);
                if prEmployeeTransactions.Find('-') then begin

                    //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
                    //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
                    case intSpecTransID of
                        intSpecTransID::"Defined Contribution":
                            if prTransactionCodes."Is Formula" then begin
                                strExtractedFrml := '';
                                strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                                SpecialTransAmount := SpecialTransAmount + (fnFormulaResult(strExtractedFrml)); //Get the calculated amount
                            end else
                                SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions."Amount LCY";

                        intSpecTransID::"Life Insurance":
                            SpecialTransAmount := SpecialTransAmount + ((curReliefInsurance / 100) * prEmployeeTransactions."Amount LCY");

                        //
                        intSpecTransID::"Owner Occupier Interest":
                            SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions."Amount LCY";


                        intSpecTransID::"Home Ownership Savings Plan":
                            SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions."Amount LCY";

                        intSpecTransID::Morgage:
                            begin
                                SpecialTransAmount := SpecialTransAmount + curReliefMorgage;

                                if SpecialTransAmount > curReliefMorgage then begin
                                    SpecialTransAmount := curReliefMorgage
                                end;

                            end;

                    end;
                end;
            until prTransactionCodes.Next = 0;
        end;
    end;

    procedure fnGetEmployeePaye(curTaxablePay: Decimal; curEmployee: Code[20]) PAYE: Decimal
    var
        prPAYE: Record prPAYE;
        curTempAmount: Decimal;
        KeepCount: Integer;
        Employees: Record "HR Employees";
        Posting: Record "prEmployee Posting Group";
    begin
        /*//PKK - Convert to annual
        //statTaxPay:=curTaxablePay;
        //curTaxablePay:=((curTaxablePay-currAnnualPay)*12)+currAnnualPay;
        //PKK - Convert to annual
        
        
        KeepCount:=0;
        prPAYE.RESET;
        IF prPAYE.FINDFIRST THEN BEGIN
        
        IF curTaxablePay < prPAYE."PAYE Tier" THEN BEGIN //PKK EXIT;
        IF KeepCount = 0 THEN BEGIN
        PAYE := PAYE + (curTaxablePay * (prPAYE.Rate / 100));
        END;
        //PKK
        //PAYE := PAYE/12;
        //Min PAYE
        //Min PAYE
        EXIT;
        END;
        REPEAT
         KeepCount+=1;
         curTempAmount:= curTaxablePay;
         IF curTaxablePay = 0 THEN EXIT;
               IF KeepCount = prPAYE.COUNT THEN   //this is the last record or loop
                  curTaxablePay := curTempAmount
                ELSE
                   IF curTempAmount >= prPAYE."PAYE Tier" THEN
                    curTempAmount := prPAYE."PAYE Tier"
                   ELSE
                     curTempAmount := curTempAmount;
        
        PAYE := PAYE + (curTempAmount * (prPAYE.Rate / 100));
        curTaxablePay := curTaxablePay - curTempAmount;
        
        UNTIL prPAYE.NEXT=0;
        END;
        
        //PKK
        //PAYE := PAYE/12;
        //curTaxablePay:=statTaxPay;
        //PKK
        */

        //Added to cater for the different tax groups
        //Get the employee's posting group
        Employees.Reset;
        if Employees.Get(curEmployee) then begin
            Employees.TestField(Employees."Posting Group");

            //Get the tax group for that posting group
            Posting.Reset;
            Posting.Get(Employees."Posting Group");

            KeepCount := 0;
            prPAYE.Reset;
            prPAYE.SetRange(prPAYE."Tax Code", Posting."Tax Code"); //Added
            if prPAYE.FindFirst then begin
                //IF curTaxablePay < prPAYE."PAYE Tier" THEN EXIT;  //Commented
                repeat
                    KeepCount += 1;
                    curTempAmount := curTaxablePay;
                    if curTaxablePay = 0 then exit;
                    if KeepCount = prPAYE.Count then   //this is the last record or loop
                        curTaxablePay := curTempAmount
                    else
                        if curTempAmount >= prPAYE."PAYE Tier" then
                            curTempAmount := prPAYE."PAYE Tier"
                        else
                            curTempAmount := curTempAmount;

                    PAYE := PAYE + (curTempAmount * (prPAYE.Rate / 100));
                    curTaxablePay := curTaxablePay - curTempAmount;

                until prPAYE.Next = 0;
            end;

        end;

    end;

    procedure fnGetEmployeeNHIF(curBaseAmount: Decimal) NHIF: Decimal
    var
        prNHIF: Record prNHIF;
    begin
        prNHIF.Reset;
        prNHIF.SetCurrentKey(prNHIF."Tier Code");
        if prNHIF.FindFirst then begin
            repeat
                if ((curBaseAmount >= prNHIF."Lower Limit") and (curBaseAmount <= prNHIF."Upper Limit")) then
                    NHIF := prNHIF.Amount;
            until prNHIF.Next = 0;
        end;
    end;

    procedure fnPureFormula(strEmpCode: Code[20]; intMonth: Integer; intYear: Integer; strFormula: Text[250]) Formula: Text[250]
    var
        Where: Text[30];
        Which: Text[30];
        i: Integer;
        TransCode: Code[20];
        Char: Text[1];
        FirstBracket: Integer;
        StartCopy: Boolean;
        FinalFormula: Text[250];
        TransCodeAmount: Decimal;
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        CalcAddCurr: Boolean;
        AccSchedMgt: Codeunit AccSchedManagement;
    begin
        TransCode := '';
        for i := 1 to StrLen(strFormula) do begin
            Char := CopyStr(strFormula, i, 1);
            if Char = '[' then StartCopy := true;

            if StartCopy then TransCode := TransCode + Char;
            //Copy Characters as long as is not within []
            if not StartCopy then
                FinalFormula := FinalFormula + Char;
            if Char = ']' then begin
                StartCopy := false;
                //Get Transcode
                Where := '=';
                Which := '[]';
                TransCode := DelChr(TransCode, Where, Which);
                //Get TransCodeAmount
                TransCodeAmount := fnGetTransAmount(strEmpCode, TransCode, intMonth, intYear);
                //Reset Transcode
                TransCode := '';
                //Get Final Formula
                FinalFormula := FinalFormula + Format(TransCodeAmount);
                //End Get Transcode
            end;
        end;
        Formula := FinalFormula;
    end;

    procedure fnGetTransAmount(strEmpCode: Code[20]; strTransCode: Code[20]; intMonth: Integer; intYear: Integer) TransAmount: Decimal
    var
        prEmployeeTransactions: Record "prEmployee Transactions";
        prPeriodTransactions: Record "prPeriod Transactions";
        prSalaryCard: Record "prSalary Card";
    begin
        if CopyStr(strTransCode, 1, 1) = '#' then begin  //PKK
            prEmployeeTransactions.Reset;
            prEmployeeTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code", DelChr(strTransCode, '=', '#'));
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
            prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended, false);
            if prEmployeeTransactions.FindFirst then begin
                TransAmount := prEmployeeTransactions."No of Units";
                //PKKIF prEmployeeTransactions."No of Units"<>0 THEN
                //PKK   TransAmount:=prEmployeeTransactions."No of Units";
            end;

        end else begin

            prEmployeeTransactions.Reset;
            prEmployeeTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code", strTransCode);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
            prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended, false);
            if prEmployeeTransactions.FindSet then begin
                // IF prEmployeeTransactions.Currency = '' THEN
                TransAmount := prEmployeeTransactions."Amount LCY";
                // ELSE
                //    TransAmount:=fnCurrencyConv(prEmployeeTransactions.Currency,SelectedPayrollPeriod,prEmployeeTransactions.Amount,TRUE)
                //PKKIF prEmployeeTransactions."No of Units"<>0 THEN
                //PKK   TransAmount:=prEmployeeTransactions."No of Units";
            end;

            if TransAmount = 0 then begin
                prPeriodTransactions.Reset;
                prEmployeeTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
                prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code", strEmpCode);
                prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code", strTransCode);
                prPeriodTransactions.SetRange(prPeriodTransactions."Period Month", intMonth);
                prPeriodTransactions.SetRange(prPeriodTransactions."Period Year", intYear);
                if prPeriodTransactions.FindFirst then begin
                    TransAmount := prPeriodTransactions.Amount;

                    //Added to cater for changes in BPAY that have not hit PrPeriod Transactions
                    if prPeriodTransactions."Transaction Code" = 'BPAY' then begin
                        prSalaryCard.Reset;
                        prSalaryCard.SetRange(prSalaryCard."Employee Code", strEmpCode);
                        if prSalaryCard.FindFirst then
                            TransAmount := prSalaryCard."Basic Pay";
                    end;
                end;
            end;

        end;


        //Added for new employees who have not had any entry into PrPeriod Transactions
        if TransAmount = 0 then begin
            if strTransCode = 'BPAY' then begin

                prSalaryCard.Reset;
                prSalaryCard.SetRange(prSalaryCard."Employee Code", strEmpCode);
                if prSalaryCard.FindFirst then
                    TransAmount := prSalaryCard."Basic Pay";

            end;
        end;


        if strTransCode = 'DOM' then // so as to use days of month
            TransAmount := DOM;

        //MESSAGE('%1 for %2 and %3 and %4 or %5 vs %6',strTransCode,TransAmount,prEmployeeTransactions.Currency,prEmployeeTransactions.Amount,prPeriodTransactions.Amount);
    end;

    procedure fnFormulaResult(strFormula: Text[250]) Results: Decimal
    var
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        CalcAddCurr: Boolean;
        AccSchedMgt: Codeunit AccSchedManagement;
    begin
        /* //To be checked
        Results :=AccSchedMgt.EvaluateExpression(true, strFormula, AccSchedLine, ColumnLayout, CalcAddCurr);
        */
    end;

    procedure fnClosePayrollPeriod(dtOpenPeriod: Date; PayrollCode: Code[20]) Closed: Boolean
    var
        dtNewPeriod: Date;
        intNewMonth: Integer;
        intNewYear: Integer;
        prEmployeeTransactions: Record "prEmployee Transactions";
        prPeriodTransactions: Record "prPeriod Transactions";
        intMonth: Integer;
        intYear: Integer;
        prTransactionCodes: Record "prTransaction Codes";
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        prEmployeeTrans: Record "prEmployee Transactions";
        prPayrollPeriods: Record "prPayroll Periods";
        prNewPayrollPeriods: Record "prPayroll Periods";
        CreateTrans: Boolean;
        ControlInfo: Record "Control-Information";
        prAssignEmployeeLoan: Record prAssignEmployeeLoan;
        Periods: Record "prPayroll Periods";
        Periods2: Record "prPayroll Periods";
    begin
        ControlInfo.Get();

        //Added to cater for the 13th Month
        Periods.Reset;
        Periods.SetRange(Periods."Date Opened", dtOpenPeriod);
        if Periods.Find('-') then begin
            if Periods."Period Month" = 13 then begin
                Periods.Closed := true;
                Periods."Date Closed" := Today;
                Periods.Modify;

                //Get the month before the 13th Month to be the one to close
                Periods2.Reset;
                Periods2.SetRange(Periods2."Is before 13th Month", true);
                if Periods2.Find('+') then
                    dtOpenPeriod := Periods2."Date Opened";
            end;
        end;


        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2DMY(dtNewPeriod, 2);
        intNewYear := Date2DMY(dtNewPeriod, 3);

        intMonth := Date2DMY(dtOpenPeriod, 2);
        intYear := Date2DMY(dtOpenPeriod, 3);

        prEmployeeTransactions.Reset;
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
        //Multiple Payroll
        if ControlInfo."Multiple Payroll" then
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Payroll Code", PayrollCode);
        if prEmployeeTransactions.Find('-') then begin
            repeat
                prTransactionCodes.Reset;
                prTransactionCodes.SetRange(prTransactionCodes."Transaction Code", prEmployeeTransactions."Transaction Code");
                if prTransactionCodes.Find('-') then begin
                    with prTransactionCodes do begin
                        case prTransactionCodes."Balance Type" of
                            prTransactionCodes."Balance Type"::None:
                                begin
                                    curTransAmount := prEmployeeTransactions."Amount LCY";
                                    curTransBalance := 0;
                                end;
                            prTransactionCodes."Balance Type"::Increasing:
                                begin
                                    curTransAmount := prEmployeeTransactions."Amount LCY";
                                    curTransBalance := prEmployeeTransactions.Balance + prEmployeeTransactions."Amount LCY";
                                end;
                            prTransactionCodes."Balance Type"::Reducing:
                                begin
                                    curTransAmount := prEmployeeTransactions."Amount LCY";
                                    if prEmployeeTransactions.Balance < prEmployeeTransactions."Amount LCY" then begin
                                        curTransAmount := prEmployeeTransactions.Balance;
                                        curTransBalance := 0;
                                    end else begin
                                        curTransBalance := prEmployeeTransactions.Balance - prEmployeeTransactions."Amount LCY";
                                    end;
                                    if curTransBalance < 0 then begin
                                        curTransAmount := 0;
                                        curTransBalance := 0;
                                    end;
                                end;
                        end;
                    end;
                end;

                //For those transactions with Start and End Date Specified
                if (prEmployeeTransactions."Start Date" <> 0D) and (prEmployeeTransactions."End Date" <> 0D) then begin
                    if prEmployeeTransactions."End Date" < dtNewPeriod then begin
                        curTransAmount := 0;
                        curTransBalance := 0;
                    end;
                end;
                //End Transactions with Start and End Date

                if (prTransactionCodes.Frequency = prTransactionCodes.Frequency::Fixed) and
                   (prEmployeeTransactions."Stop for Next Period" = false) then //DENNO ADDED THIS TO CHECK FREQUENCY AND STOP IF MARKED
                 begin
                    if (curTransAmount <> 0) then  //Update the employee transaction table
                     begin
                        if ((prTransactionCodes."Balance Type" = prTransactionCodes."Balance Type"::Reducing) and (curTransBalance <> 0)) or
                         (prTransactionCodes."Balance Type" <> prTransactionCodes."Balance Type"::Reducing) then
                            prEmployeeTransactions.Balance := curTransBalance;
                        prEmployeeTransactions.Modify;


                        //Insert record for the next period
                        with prEmployeeTrans do begin
                            Init;
                            "Employee Code" := prEmployeeTransactions."Employee Code";
                            "Transaction Code" := prEmployeeTransactions."Transaction Code";
                            "Transaction Name" := prEmployeeTransactions."Transaction Name";
                            Amount := curTransAmount;
                            Balance := curTransBalance;
                            "Amortized Loan Total Repay Amt" := prEmployeeTransactions."Amortized Loan Total Repay Amt";
                            "Original Amount" := prEmployeeTransactions."Original Amount";
                            Membership := prEmployeeTransactions.Membership;
                            "Reference No" := prEmployeeTransactions."Reference No";
                            "Loan Number" := prEmployeeTransactions."Loan Number";
                            "Period Month" := intNewMonth;
                            "Period Year" := intNewYear;
                            "Payroll Period" := dtNewPeriod;
                            "Payroll Code" := PayrollCode;
                            Currency := prEmployeeTransactions.Currency;
                            "Start Date" := prEmployeeTransactions."Start Date";
                            "End Date" := prEmployeeTransactions."End Date";
                            Insert;
                        end;
                    end;
                end
            until prEmployeeTransactions.Next = 0;
        end;

        //Added for loan card to push loans for next period into employee transactions **changes**
        prAssignEmployeeLoan.Reset;
        prAssignEmployeeLoan.SetRange(prAssignEmployeeLoan."Payroll Period", dtNewPeriod);
        prAssignEmployeeLoan.SetRange(prAssignEmployeeLoan.Status, prAssignEmployeeLoan.Status::Posted);
        if prAssignEmployeeLoan.FindSet then
            repeat
                fnInsertTrans(prAssignEmployeeLoan);
            until prAssignEmployeeLoan.Next = 0;


        //Update the Period as Closed
        prPayrollPeriods.Reset;
        prPayrollPeriods.SetRange(prPayrollPeriods."Period Month", intMonth);
        prPayrollPeriods.SetRange(prPayrollPeriods."Period Year", intYear);
        prPayrollPeriods.SetRange(prPayrollPeriods.Closed, false);
        if ControlInfo."Multiple Payroll" then
            prPayrollPeriods.SetRange(prPayrollPeriods."Payroll Code", PayrollCode);

        if prPayrollPeriods.Find('-') then begin
            prPayrollPeriods.Closed := true;
            prPayrollPeriods."Date Closed" := Today;
            prPayrollPeriods.Modify;
        end;

        //Enter a New Period
        with prNewPayrollPeriods do begin
            Init;
            "Period Month" := intNewMonth;
            "Period Year" := intNewYear;
            "Period Name" := Format(dtNewPeriod, 0, '<Month Text>') + ' ' + Format(intNewYear);
            "Date Opened" := dtNewPeriod;
            Closed := false;
            "Payroll Code" := PayrollCode;
            Insert;
        end;

        //Effect the transactions for the P9
        fnP9PeriodClosure(intMonth, intYear, dtOpenPeriod, PayrollCode);

        //Take all the Negative pay (Net) for the current month & treat it as a deduction in the new period
        fnGetNegativePay(intMonth, intYear, dtOpenPeriod);
    end;

    procedure fnGetNegativePay(intMonth: Integer; intYear: Integer; dtOpenPeriod: Date)
    var
        prPeriodTransactions: Record "prPeriod Transactions";
        prEmployeeTransactions: Record "prEmployee Transactions";
        intNewMonth: Integer;
        intNewYear: Integer;
        dtNewPeriod: Date;
    begin
        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2DMY(dtNewPeriod, 2);
        intNewYear := Date2DMY(dtNewPeriod, 3);

        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Month", intMonth);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Year", intYear);
        prPeriodTransactions.SetRange(prPeriodTransactions."Group Order", 9);
        prPeriodTransactions.SetFilter(prPeriodTransactions.Amount, '<0');

        if prPeriodTransactions.Find('-') then begin
            repeat
                with prEmployeeTransactions do begin
                    Init;
                    "Employee Code" := prPeriodTransactions."Employee Code";
                    "Transaction Code" := 'NEGP';
                    "Transaction Name" := 'Negative Pay';
                    Amount := prPeriodTransactions.Amount;
                    Balance := 0;
                    "Original Amount" := 0;
                    "Period Month" := intNewMonth;
                    "Period Year" := intNewYear;
                    "Payroll Period" := dtNewPeriod;
                    Insert;
                end;
            until prPeriodTransactions.Next = 0;
        end;
    end;

    procedure fnP9PeriodClosure(intMonth: Integer; intYear: Integer; dtCurPeriod: Date; PayrollCode: Code[20])
    var
        P9EmployeeCode: Code[20];
        P9BasicPay: Decimal;
        P9Allowances: Decimal;
        P9Benefits: Decimal;
        P9ValueOfQuarters: Decimal;
        P9DefinedContribution: Decimal;
        P9OwnerOccupierInterest: Decimal;
        P9GrossPay: Decimal;
        P9TaxablePay: Decimal;
        P9TaxCharged: Decimal;
        P9InsuranceRelief: Decimal;
        P9TaxRelief: Decimal;
        P9Paye: Decimal;
        P9NSSF: Decimal;
        P9NHIF: Decimal;
        P9Deductions: Decimal;
        P9NetPay: Decimal;
        prPeriodTransactions: Record "prPeriod Transactions";
        prEmployee: Record "HR Employees";
    begin
        P9BasicPay := 0;
        P9Allowances := 0;
        P9Benefits := 0;
        P9ValueOfQuarters := 0;
        P9DefinedContribution := 0;
        P9OwnerOccupierInterest := 0;
        P9GrossPay := 0;
        P9TaxablePay := 0;
        P9TaxCharged := 0;
        P9InsuranceRelief := 0;
        P9TaxRelief := 0;
        P9Paye := 0;
        P9NSSF := 0;
        P9NHIF := 0;
        P9Deductions := 0;
        P9NetPay := 0;

        prEmployee.Reset;
        prEmployee.SetRange(prEmployee.Status, prEmployee.Status::New);
        if prEmployee.Find('-') then begin
            repeat

                P9BasicPay := 0;
                P9Allowances := 0;
                P9Benefits := 0;
                P9ValueOfQuarters := 0;
                P9DefinedContribution := 0;
                P9OwnerOccupierInterest := 0;
                P9GrossPay := 0;
                P9TaxablePay := 0;
                P9TaxCharged := 0;
                P9InsuranceRelief := 0;
                P9TaxRelief := 0;
                P9Paye := 0;
                P9NSSF := 0;
                P9NHIF := 0;
                P9Deductions := 0;
                P9NetPay := 0;

                prPeriodTransactions.Reset;
                prPeriodTransactions.SetRange(prPeriodTransactions."Period Month", intMonth);
                prPeriodTransactions.SetRange(prPeriodTransactions."Period Year", intYear);
                prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code", prEmployee."No.");
                if prPeriodTransactions.Find('-') then begin
                    repeat
                        with prPeriodTransactions do begin
                            case prPeriodTransactions."Group Order" of
                                1: //Basic pay & Arrears
                                    begin
                                        if "Sub Group Order" = 1 then P9BasicPay := Amount; //Basic Pay
                                        if "Sub Group Order" = 2 then P9BasicPay := P9BasicPay + Amount; //Basic Pay Arrears
                                    end;
                                3:  //Allowances
                                    begin
                                        P9Allowances := P9Allowances + Amount
                                    end;
                                4: //Gross Pay
                                    begin
                                        P9GrossPay := Amount
                                    end;
                                6: //Taxation
                                    begin
                                        if "Sub Group Order" = 1 then P9DefinedContribution := Amount; //Defined Contribution
                                        if "Sub Group Order" = 9 then P9TaxRelief := Amount; //Tax Relief
                                        if "Sub Group Order" = 8 then P9InsuranceRelief := Amount; //Insurance Relief
                                        if "Sub Group Order" = 6 then P9TaxablePay := Amount; //Taxable Pay
                                        if "Sub Group Order" = 7 then P9TaxCharged := Amount; //Tax Charged
                                    end;
                                7: //Statutories
                                    begin
                                        if "Sub Group Order" = 1 then P9NSSF := Amount; //Nssf
                                        if "Sub Group Order" = 2 then P9NHIF := Amount; //Nhif
                                        if "Sub Group Order" = 3 then P9Paye := Amount; //paye
                                        if "Sub Group Order" = 4 then P9Paye := P9Paye + Amount; //Paye Arrears
                                    end;
                                8://Deductions
                                    begin
                                        P9Deductions := P9Deductions + Amount;
                                    end;
                                9: //NetPay
                                    begin
                                        P9NetPay := Amount;
                                    end;
                            end;
                        end;
                    until prPeriodTransactions.Next = 0;
                end;
                //Update the P9 Details
                if P9NetPay <> 0 then
                    fnUpdateP9Table(prEmployee."No.", P9BasicPay, P9Allowances, P9Benefits, P9ValueOfQuarters, P9DefinedContribution,
                        P9OwnerOccupierInterest, P9GrossPay, P9TaxablePay, P9TaxCharged, P9InsuranceRelief, P9TaxRelief, P9Paye, P9NSSF,
                        P9NHIF, P9Deductions, P9NetPay, dtCurPeriod, PayrollCode);

            until prEmployee.Next = 0;
        end;
    end;

    procedure fnUpdateP9Table(P9EmployeeCode: Code[20]; P9BasicPay: Decimal; P9Allowances: Decimal; P9Benefits: Decimal; P9ValueOfQuarters: Decimal; P9DefinedContribution: Decimal; P9OwnerOccupierInterest: Decimal; P9GrossPay: Decimal; P9TaxablePay: Decimal; P9TaxCharged: Decimal; P9InsuranceRelief: Decimal; P9TaxRelief: Decimal; P9Paye: Decimal; P9NSSF: Decimal; P9NHIF: Decimal; P9Deductions: Decimal; P9NetPay: Decimal; dtCurrPeriod: Date; prPayrollCode: Code[20])
    var
        prEmployeeP9Info: Record "prEmployee P9 Info";
        intYear: Integer;
        intMonth: Integer;
    begin
        intMonth := Date2DMY(dtCurrPeriod, 2);
        intYear := Date2DMY(dtCurrPeriod, 3);

        prEmployeeP9Info.Reset;
        with prEmployeeP9Info do begin
            Init;
            "Employee Code" := P9EmployeeCode;
            "Basic Pay" := P9BasicPay;
            Allowances := P9Allowances;
            Benefits := P9Benefits;
            "Value Of Quarters" := P9ValueOfQuarters;
            "Defined Contribution" := P9DefinedContribution;
            "Owner Occupier Interest" := P9OwnerOccupierInterest;
            "Gross Pay" := P9GrossPay;
            "Taxable Pay" := P9TaxablePay;
            "Tax Charged" := P9TaxCharged;
            "Insurance Relief" := P9InsuranceRelief;
            "Tax Relief" := P9TaxRelief;
            PAYE := P9Paye;
            NSSF := P9NSSF;
            NHIF := P9NHIF;
            Deductions := P9Deductions;
            "Net Pay" := P9NetPay;
            "Period Month" := intMonth;
            "Period Year" := intYear;
            "Payroll Period" := dtCurrPeriod;
            "Payroll Code" := prPayrollCode;
            Insert;
        end;
    end;

    procedure fnDaysWorked(dtDate: Date; IsTermination: Boolean) DaysWorked: Integer
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;
    begin
        TodayDate := dtDate;
        PayTillCutOff := false;

        if VitalSetup.Get() then begin
            PayTillCutOff := VitalSetup."Pay upto Cut Off Date";
            if PayTillCutOff = true then begin
                VitalSetup.TestField(VitalSetup."Payroll Cut Off Day");
            end;
        end;

        RemainingDays := 0;
        if PayTillCutOff = true then begin //PKK - AGROSACK
            RemainingDays := (DMY2Date(VitalSetup."Payroll Cut Off Day", Date2DMY(TodayDate, 2), Date2DMY(TodayDate, 3)) - TodayDate);

        end else begin
            RemainingDays := (CalcDate('-1D', CalcDate('1M', DMY2Date(1, Date2DMY(TodayDate, 2), Date2DMY(TodayDate, 3))))
                                            - TodayDate);
        end;


        TDate := TodayDate;

        i := 0;
        repeat
            i := i + 1;

            if VitalSetup."Prol. Based on days in month" = true then begin
                DaysWorked := DaysWorked + 1;
            end else begin
                if (Date2DWY(TDate, 1) <> 6) and (Date2DWY(TDate, 1) <> 7) then
                    DaysWorked := DaysWorked + 1;
            end;

            TDate := CalcDate('1D', TDate);

        until i = RemainingDays + 1;
    end;

    procedure fnSalaryArrears(EmpCode: Text[30]; TransCode: Text[30]; CBasic: Decimal; StartDate: Date; EndDate: Date; dtOpenPeriod: Date; dtDOE: Date; dtTermination: Date)
    var
        FirstMonth: Boolean;
        startmonth: Integer;
        startYear: Integer;
        "prEmployee P9 Info": Record "prEmployee P9 Info";
        P9BasicPay: Decimal;
        P9taxablePay: Decimal;
        P9PAYE: Decimal;
        ProratedBasic: Decimal;
        SalaryArrears: Decimal;
        SalaryVariance: Decimal;
        SupposedTaxablePay: Decimal;
        SupposedTaxCharged: Decimal;
        SupposedPAYE: Decimal;
        PAYEVariance: Decimal;
        PAYEArrears: Decimal;
        PeriodMonth: Integer;
        PeriodYear: Integer;
        CountDaysofMonth: Integer;
        DaysWorked: Integer;
    begin
        fnInitialize;

        FirstMonth := true;
        if EndDate > StartDate then begin
            while StartDate < EndDate do begin
                //fnGetEmpP9Info
                startmonth := Date2DMY(StartDate, 2);
                startYear := Date2DMY(StartDate, 3);

                "prEmployee P9 Info".Reset;
                "prEmployee P9 Info".SetRange("prEmployee P9 Info"."Employee Code", EmpCode);
                "prEmployee P9 Info".SetRange("prEmployee P9 Info"."Period Month", startmonth);
                "prEmployee P9 Info".SetRange("prEmployee P9 Info"."Period Year", startYear);
                if "prEmployee P9 Info".Find('-') then begin
                    P9BasicPay := "prEmployee P9 Info"."Basic Pay";
                    P9taxablePay := "prEmployee P9 Info"."Taxable Pay";
                    P9PAYE := "prEmployee P9 Info".PAYE;

                    if P9BasicPay > 0 then   //Staff payment history is available
                     begin
                        if FirstMonth then begin                 //This is the first month in the arrears loop
                            if Date2DMY(StartDate, 1) <> 1 then //if the date doesn't start on 1st, we have to prorate the salary
                             begin
                                //ProratedBasic := ProratePay.fnProratePay(P9BasicPay, CBasic, StartDate); ********
                                //Get the Basic Salary (prorate basic pay if needed) //Termination Remaining
                                if (Date2DMY(dtDOE, 2) = Date2DMY(StartDate, 2)) and (Date2DMY(dtDOE, 3) = Date2DMY(StartDate, 3)) then begin
                                    CountDaysofMonth := fnDaysInMonth(dtDOE);
                                    DaysWorked := fnDaysWorked(dtDOE, false);
                                    if DontProrateBPAY = false then
                                        ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay, DaysWorked, CountDaysofMonth)
                                end;

                                //PKK - Prorate Absence

                                //PKK - Prorate Absence

                                //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
                                if dtTermination <> 0D then begin
                                    if (Date2DMY(dtTermination, 2) = Date2DMY(StartDate, 2)) and (Date2DMY(dtTermination, 3) = Date2DMY(StartDate, 3)) then begin
                                        CountDaysofMonth := fnDaysInMonth(dtTermination);
                                        DaysWorked := fnDaysWorked(dtTermination, true);
                                        ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay, DaysWorked, CountDaysofMonth)
                                    end;
                                end;

                                SalaryArrears := (CBasic - ProratedBasic)
                            end
                            else begin
                                SalaryArrears := (CBasic - P9BasicPay);
                            end;
                        end;
                        SalaryVariance := SalaryVariance + SalaryArrears;
                        SupposedTaxablePay := P9taxablePay + SalaryArrears;

                        //To calc paye arrears, check if the Supposed Taxable Pay is > the taxable pay for the loop period
                        if SupposedTaxablePay > P9taxablePay then begin
                            SupposedTaxCharged := fnGetEmployeePaye(SupposedTaxablePay, EmpCode);
                            SupposedPAYE := SupposedTaxCharged - curReliefPersonal;
                            PAYEVariance := SupposedPAYE - P9PAYE;
                            PAYEArrears := PAYEArrears + PAYEVariance;
                        end;
                        FirstMonth := false;               //reset the FirstMonth Boolean to False
                    end;
                end;
                StartDate := CalcDate('+1M', StartDate);
            end;
            if SalaryArrears <> 0 then begin
                PeriodYear := Date2DMY(dtOpenPeriod, 3);
                PeriodMonth := Date2DMY(dtOpenPeriod, 2);
                fnUpdateSalaryArrears(EmpCode, TransCode, StartDate, EndDate, SalaryArrears, PAYEArrears, PeriodMonth, PeriodYear,
                dtOpenPeriod);
            end

        end
        else
            Error('The start date must be earlier than the end date');
    end;

    procedure fnUpdateSalaryArrears(EmployeeCode: Text[50]; TransCode: Text[50]; OrigStartDate: Date; EndDate: Date; SalaryArrears: Decimal; PayeArrears: Decimal; intMonth: Integer; intYear: Integer; payperiod: Date)
    var
        FirstMonth: Boolean;
        ProratedBasic: Decimal;
        SalaryVariance: Decimal;
        PayeVariance: Decimal;
        SupposedTaxablePay: Decimal;
        SupposedTaxCharged: Decimal;
        SupposedPaye: Decimal;
        CurrentBasic: Decimal;
        StartDate: Date;
        "prSalary Arrears": Record "prSalary Arrears";
    begin
        "prSalary Arrears".Reset;
        "prSalary Arrears".SetRange("prSalary Arrears"."Employee Code", EmployeeCode);
        "prSalary Arrears".SetRange("prSalary Arrears"."Transaction Code", TransCode);
        "prSalary Arrears".SetRange("prSalary Arrears"."Period Month", intMonth);
        "prSalary Arrears".SetRange("prSalary Arrears"."Period Year", intYear);
        if "prSalary Arrears".Find('-') = false then begin
            "prSalary Arrears".Init;
            "prSalary Arrears"."Employee Code" := EmployeeCode;
            "prSalary Arrears"."Transaction Code" := TransCode;
            "prSalary Arrears"."Start Date" := OrigStartDate;
            "prSalary Arrears"."End Date" := EndDate;
            "prSalary Arrears"."Salary Arrears" := SalaryArrears;
            "prSalary Arrears"."PAYE Arrears" := PayeArrears;
            "prSalary Arrears"."Period Month" := intMonth;
            "prSalary Arrears"."Period Year" := intYear;
            "prSalary Arrears"."Payroll Period" := payperiod;
            "prSalary Arrears".Insert;
        end
    end;

    procedure fnCalcLoanInterest(strEmpCode: Code[20]; strTransCode: Code[20]; InterestRate: Decimal; RecoveryMethod: Option Reducing,"Straight line",Amortized; LoanAmount: Decimal; Balance: Decimal; CurrPeriod: Date; Welfare: Boolean) LnInterest: Decimal
    var
        curLoanInt: Decimal;
        intMonth: Integer;
        intYear: Integer;
    begin
        intMonth := Date2DMY(CurrPeriod, 2);
        intYear := Date2DMY(CurrPeriod, 3);

        curLoanInt := 0;



        if InterestRate > 0 then begin
            if RecoveryMethod = RecoveryMethod::"Straight line" then //Straight Line Method [1]
                curLoanInt := (InterestRate / 1200) * LoanAmount;

            if RecoveryMethod = RecoveryMethod::Reducing then //Reducing Balance [0]

                 curLoanInt := (InterestRate / 1200) * Balance;

            if RecoveryMethod = RecoveryMethod::Amortized then //Amortized [2]
                curLoanInt := (InterestRate / 1200) * Balance;
        end else
            curLoanInt := 0;

        //Return the Amount
        LnInterest := Round(curLoanInt, 1);
    end;

    procedure fnUpdateEmployerDeductions(EmpCode: Code[20]; TCode: Code[20]; TGroup: Code[20]; GroupOrder: Integer; SubGroupOrder: Integer; Description: Text[50]; curAmount: Decimal; curBalance: Decimal; Month: Integer; Year: Integer; mMembership: Text[30]; ReferenceNo: Text[30]; dtOpenPeriod: Date)
    var
        prEmployerDeductions: Record "prEmployer Deductions";
    begin

        if curAmount = 0 then exit;
        with prEmployerDeductions do begin
            Init;
            "Employee Code" := EmpCode;
            "Transaction Code" := TCode;
            Amount := curAmount;
            "Period Month" := Month;
            "Period Year" := Year;
            "Payroll Period" := dtOpenPeriod;
            Insert;
        end;
    end;

    procedure fnDisplayFrmlValues(EmpCode: Code[30]; intMonth: Integer; intYear: Integer; Formula: Text[50]) curTransAmount: Decimal
    var
        pureformula: Text[50];
    begin
        pureformula := fnPureFormula(EmpCode, intMonth, intYear, Formula);
        curTransAmount := fnFormulaResult(pureformula); //Get the calculated amount
    end;

    procedure fnUpdateEmployeeTrans(EmpCode: Code[20]; TransCode: Code[20]; Amount: Decimal; Month: Integer; Year: Integer; PayrollPeriod: Date; ReffNo: Code[20])
    var
        prEmployeeTrans: Record "prEmployee Transactions";
    begin
        /*
        prEmployeeTrans.RESET;
        prEmployeeTrans.SETRANGE(prEmployeeTrans."Employee Code",EmpCode);
        prEmployeeTrans.SETRANGE(prEmployeeTrans."Transaction Code",TransCode);
        prEmployeeTrans.SETRANGE(prEmployeeTrans."Payroll Period",PayrollPeriod);
        prEmployeeTrans.SETRANGE(prEmployeeTrans."Reference No",ReffNo);
        IF prEmployeeTrans.FIND('-') THEN BEGIN
          IF prEmployeeTrans.Currency = '' THEN
           prEmployeeTrans."Amount LCY" :=Amount
          ELSE
            prEmployeeTrans."Amount LCY" := fnCurrencyConv(prEmployeeTrans.Currency,PayrollPeriod,Amount,FALSE);
        
          prEmployeeTrans.MODIFY;
        END;
        */
        if Employee.Get(EmpCode) then begin
            if (Date2DMY(Employee."Date Of Join", 2) = Month) and (Date2DMY(Employee."Date Of Join", 3) = Year) then begin
                if Trans.Get(TransCode) then begin
                    if Trans."Is Formula" = false then
                        exit;

                end;
            end;
        end;

        if ProrateAbsence = true then begin
            if DayAbsent > 0 then begin
                if Trans.Get(TransCode) then begin
                    if Trans."Is Formula" = false then
                        exit;

                end;
            end;
        end;

    end;

    procedure fnGetJournalDet(strEmpCode: Code[20])
    var
        SalaryCard: Record "HR Employees";
    begin
        //Get Payroll Posting Accounts
        if SalaryCard.Get(strEmpCode) then begin
            if PostingGroup.Get(SalaryCard."Posting Group") then begin
                //Comment This for the Time Being

                PostingGroup.TestField("Salary Account");
                PostingGroup.TestField("Income Tax Account");
                PostingGroup.TestField("Net Salary Payable");
                //PostingGroup.TESTFIELD("SSF Employer Account");
                PostingGroup.TestField("Pension Employer Acc");

                TaxAccount := PostingGroup."Income Tax Account";
                salariesAcc := PostingGroup."Salary Account";
                PayablesAcc := PostingGroup."Net Salary Payable";
                NSSFEMPyer := PostingGroup."SSF Employer Account";
                NSSFEMPyee := PostingGroup."SSF Employee Account";
                NHIFEMPyee := PostingGroup."NHIF Employee Account";
                PensionEMPyer := PostingGroup."Pension Employer Acc";
                PensionEMPyee := PostingGroup."Pension Employee Acc"
            end;
        end;
        //End Get Payroll Posting Accounts
    end;

    procedure fnInsertTrans(prAssignLoan: Record prAssignEmployeeLoan)
    var
        prEmployeeTrans: Record "prEmployee Transactions";
    begin

        prEmployeeTrans.Reset;
        prEmployeeTrans.SetRange(prEmployeeTrans."Employee Code", prAssignLoan."Employee Code");
        prEmployeeTrans.SetRange(prEmployeeTrans."Transaction Code", prAssignLoan."Transaction Code");
        prEmployeeTrans.SetRange(prEmployeeTrans."Payroll Period", prAssignLoan."Payroll Period");
        if not prEmployeeTrans.FindFirst then begin
            prEmployeeTrans.Init;
            prEmployeeTrans.TransferFields(prAssignLoan);
            prEmployeeTrans."End Date" := 0D;
            prEmployeeTrans.Insert;
        end
    end;

    procedure fnCurrencyConv(Currency: Code[10]; CurrencyPeriod: Date; AmountToConvert: Decimal; LCYToFCY: Boolean): Decimal
    var
        CurrExchRate: Record "Currency Exchange Rate";
        "Currency Factor": Decimal;
    begin
        "Currency Factor" := CurrExchRate.ExchangeRate(CalcDate('CM', CurrencyPeriod), Currency);
        if LCYToFCY = true then
            exit(Round(CurrExchRate.ExchangeAmtFCYToLCY(CalcDate('CM', CurrencyPeriod), Currency, AmountToConvert, "Currency Factor")))
        else
            exit(Round(CurrExchRate.ExchangeAmtLCYToFCY(CalcDate('CM', CurrencyPeriod), Currency, AmountToConvert, "Currency Factor")));
    end;

    procedure fnUpdateEmployeeTransCurrency(EmployeeCode: Code[10]; PayrollPeriod: Date)
    var
        EmployeeTransactions: Record "prEmployee Transactions";
    begin
        EmployeeTransactions.Reset;
        EmployeeTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
        EmployeeTransactions.SetRange(EmployeeTransactions."Employee Code", EmployeeCode);
        EmployeeTransactions.SetRange("Payroll Period", PayrollPeriod);
        //EmployeeTransactions.SETRANGE("Reference No",ReffNo);
        EmployeeTransactions.SetRange(EmployeeTransactions.Suspended, false);
        if EmployeeTransactions.Find('-') then
            repeat
                if EmployeeTransactions.Currency = '' then
                    EmployeeTransactions."Amount LCY" := EmployeeTransactions.Amount
                else
                    EmployeeTransactions."Amount LCY" := fnCurrencyConv(EmployeeTransactions.Currency, PayrollPeriod, EmployeeTransactions.Amount, true);

                EmployeeTransactions.Modify;

            until EmployeeTransactions.Next = 0;
    end;

    procedure fnUpdatePeriodTransCurrency(EmployeeCode: Code[10]; TransactionCode: Code[20]; PayrollMonth: Integer; PayrollYear: Integer; PayrollPeriod: Date; Amount: Decimal)
    var
        EmployeeTransactions: Record "prEmployee Transactions";
    begin
        PeriodTransAmountLCY := 0;
        PeriodTransCurrrency := '';
        PeriodTransAmountFCY := 0;

        EmployeeTransactions.Reset;
        EmployeeTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended);
        EmployeeTransactions.SetRange(EmployeeTransactions."Employee Code", EmployeeCode);
        EmployeeTransactions.SetRange(EmployeeTransactions."Transaction Code", TransactionCode);
        EmployeeTransactions.SetRange(EmployeeTransactions."Payroll Period", PayrollPeriod);
        if EmployeeTransactions.Find('-') then begin
            if EmployeeTransactions.Currency <> '' then begin
                PeriodTransAmountLCY := Amount;//fnCurrencyConv(EmployeeTransactions.Currency,PayrollPeriod,Amount,TRUE);
                PeriodTransCurrrency := EmployeeTransactions.Currency;
                PeriodTransAmountFCY := fnCurrencyConv(EmployeeTransactions.Currency, PayrollPeriod, Amount, false);
            end
            else begin
                PeriodTransAmountLCY := Amount;
                PeriodTransCurrrency := EmployeeTransactions.Currency;
                PeriodTransAmountFCY := Amount;
            end
        end //system transactions like bpay,gpay,npay
        else begin
            SalCard.Get(EmployeeCode);
            if SalCard.Currency <> '' then begin
                PeriodTransAmountLCY := Amount;//fnCurrencyConv(SalCard.Currency,PayrollPeriod,Amount,TRUE);
                PeriodTransCurrrency := SalCard.Currency;
                PeriodTransAmountFCY := fnCurrencyConv(SalCard.Currency, PayrollPeriod, Amount, false)
            end
            else begin
                PeriodTransAmountLCY := Amount;
                PeriodTransCurrrency := SalCard.Currency;
                PeriodTransAmountFCY := Amount;
            end
        end;
        /*
        IF (TransactionCode = 'BPAY') OR (TransactionCode = 'BPAYFULL') THEN
        BEGIN
          SalCard.GET(EmployeeCode);
          IF SalCard.Currency <> '' THEN
           BEGIN
            PeriodTransAmountLCY := fnCurrencyConv(SalCard.Currency,PayrollPeriod,Amount,TRUE);
            PeriodTransCurrrency := SalCard.Currency;
            PeriodTransAmountFCY := Amount;//fnCurrencyConv(SalCard.Currency,PayrollPeriod,Amount,FALSE);
           END
        END
        */

    end;
}

