codeunit 51533018 "PR Payroll Processing Updated"
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
        curMaximumRelief: Decimal;
        currMinRelief: Decimal;
        curNssfEmployee: Decimal;
        curNssf_Employer_Factor: Decimal;
        intNHIF_BasedOn: Option Gross,Basic,"Taxable Pay";
        intNSSF_BasedOn: Option Gross,Basic;
        curDisabledLimit: Decimal;
        curMaxPensionContrib: Decimal;
        curRateTaxExPension: Decimal;
        curOOIMaxMonthlyContrb: Decimal;
        curOOIDecemberDedc: Decimal;
        curLoanMarketRate: Decimal;
        curLoanCorpRate: Decimal;
        curReliefPension: Decimal;
        TaxAccount: Code[20];
        salariesAcc: Code[20];
        PayablesAcc: Code[20];
        NSSFEMPyer: Code[20];
        PensionEMPyer: Code[20];
        NSSFEMPyee: Code[20];
        NHIFEMPyer: Code[20];
        NHIFEMPyee: Code[20];
        HREmployee: Record "HR-Employee";
        CoopParameters: Option "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,NSSF;
        PostingGroup: Record "prEmployee Posting Group";
        AccSchedMgt: Codeunit AccSchedManagement;
        HREmp2: Record "HR-Employee";
        PRTransCode: Record "prTransaction Codes";
        HREmployes: Record "HR-Employee";
        Cust2: Record Customer;
        curTransSubledger: Option " ",Customer,Vendor;
        curTransSubledgerAccount: Code[20];
        PRSalCard: Record "prSalary Card";
        HRBankSummary: Record "HR Bank Summary";
        PRSalCard_2: Record "prSalary Card";
        EmployeeInterestRate: Decimal;
        curMorgageRelief: Decimal;
        PRTransCode_2: Record "prTransaction Codes";
        PREmpTrans_2: Record "prEmployee Transactions";
        BenifitAmount: Decimal;
        HREmpBankAC: Record "HR Employee Bank Accounts";
        HREmp: Record "HR-Employee";
        PRTransCodeForm: Record "prTransaction Codes";
        curDefinedContrib_2: Decimal;
        curEmployerContribution: Decimal;
        curVoluntaryPayCut: Decimal;
        PensionArrears: Decimal;
        CurClubMembership: Decimal;
        ProratedPension: Decimal;
        ThirdSalary: Decimal;
        Text001: Label 'The previous column set could not be found.';
        Text002: Label 'The period could not be found.';
        Text003: Label 'There are no Calendar entries within the filter.';

    procedure fnInitialize()
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
        DaysWorked: Integer;
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
        "`": Integer;
    begin
        //Initialize Global Setup Items
        VitalSetup.FindFirst;
        with VitalSetup do begin
                curReliefPersonal := "Tax Relief";
                curReliefInsurance := "Insurance Relief";
                curReliefMorgage := "Mortgage Relief"; //Same as HOSP
                curMaximumRelief := "Max Relief";
                curNssfEmployee := "NSSF Employee";
                curNssf_Employer_Factor:= "NSSF Employer Factor";
                intNHIF_BasedOn := "NHIF Based on";
                curMaxPensionContrib := "Max Pension Contribution";
                curRateTaxExPension := "Tax On Excess Pension";
                curOOIMaxMonthlyContrb := "OOI Deduction";
                curOOIDecemberDedc := "OOI December";
                curLoanMarketRate := "Loan Market Rate";
                curLoanCorpRate := "Loan Corporate Rate";
                currMinRelief := "Minimum Relief Amount";
                curDisabledLimit:= "Disbled Tax Limit";

        end;
    end;

    procedure fnProcesspayroll(strEmpCode: Code[20];dtDOE: Date;curBasicPay: Decimal;blnPaysPaye: Boolean;blnPaysNssf: Boolean;blnPaysNhif: Boolean;SelectedPeriod: Date;dtOpenPeriod: Date;Membership: Text[30];ReferenceNo: Text[30];dtTermination: Date;blnGetsPAYERelief: Boolean;Dept: Code[20])
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
        DaysWorked: Integer;
        prSalaryArrears: Record "prSalary Arrears";
        prEmployeeTransactions: Record "prEmployee Transactions";
        prTransactionCodes: Record "prTransaction Codes";
        strExtractedFrml: Text[250];
        SpecialTransType: Option "None","Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan (Interest Varies)","Value of Quarters",Mortgage,VoluntaryCut;
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
        salCard: Record "prSalary Card";
        curBPAYBal: Decimal;
        curPensionReliefAmount: Decimal;
        curIncludeinNet: Decimal;
        JournalPostAs: Option ,Debit,Credit;
        JournalPostingType: Option " ","G/L Account",Customer,Vendor;
        JournalAc: Code[20];
        Customer: Record Customer;
        curIncludeGross: Decimal;
        IsCashbenefit: Decimal;
        curNssf_Base_Amount: Decimal;
        PRPeriodTrans: Record "prPeriod Transactions";
        EmployerPension: Decimal;
        ExcessPenTax: Decimal;
        blnInsuranceCertificate: Boolean;
    begin
        ClearAll;
        dtOpenPeriod:=fnGetOpenPeriod();
        
        //Initialize
        fnInitialize;
        
        //Get Payroll Posting Accountss
        fnGetJournalDet(strEmpCode);
        
        
        //check if the period selected=current period. If not, do NOT run this function
        if SelectedPeriod <> dtOpenPeriod then exit;
        intMonth:=Date2DMY(SelectedPeriod,2);
        intYear:=Date2DMY(SelectedPeriod,3);
        
        
        
        
        //Delete all Records from the prPeriod Transactions for Reprocessing
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code",strEmpCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period",dtOpenPeriod);
        if prPeriodTransactions.Find('-') then
           prPeriodTransactions.DeleteAll;
        
        //Delete all Records from prEmployer Deductions
        prEmployerDeductions.Reset;
        prEmployerDeductions.SetRange(prEmployerDeductions."Employee Code",strEmpCode);
        prEmployerDeductions.SetRange(prEmployerDeductions."Payroll Period",dtOpenPeriod);
        if prEmployerDeductions.Find('-') then
           prEmployerDeductions.DeleteAll;
        
        //Delete all records from HRBankSummary
        HRBankSummary.Reset;
        HRBankSummary.SetRange(HRBankSummary."Payroll Period",dtOpenPeriod);
        HRBankSummary.SetRange(HRBankSummary."Staff No.",strEmpCode);
        if HRBankSummary.Find('-') then HRBankSummary.DeleteAll;
        
        
        
        //IF curBasicPay >0 THEN
        begin
           //Get the Basic Salary (prorate basc pay if needed) //Termination Remaining
           if (Date2DMY(dtDOE,2)=Date2DMY(dtOpenPeriod,2)) and (Date2DMY(dtDOE,3)=Date2DMY(dtOpenPeriod,3))then begin
              CountDaysofMonth:=fnDaysInMonth(dtDOE);
              DaysWorked:=fnDaysWorked(dtDOE,false);
              //MESSAGE(FORMAT(DaysWorked));
              curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay,DaysWorked,CountDaysofMonth)
           end;
        
          //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
          if dtTermination<>0D then begin
           if (Date2DMY(dtTermination,2)=Date2DMY(dtOpenPeriod,2)) and (Date2DMY(dtTermination,3)=Date2DMY(dtOpenPeriod,3))then begin
             CountDaysofMonth:=fnDaysInMonth(dtTermination);
             DaysWorked:=fnDaysWorked(dtTermination,true);
             curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay,DaysWorked,CountDaysofMonth)
           end;
          end;
         //basic pay balance
         curBPAYBal:=0;
         salCard.Reset;
         salCard.SetRange(salCard."Employee Code",strEmpCode);
         //salCard.CALCFIELDS(salCard."Cumm BasicPay");
         if salCard.Find('-') then begin
          //curBPAYBal:=curBasicPay;
         end;
        
         curTransAmount := curBasicPay;
         strTransDescription := 'Basic Pay';
         TGroup := 'EARNINGS'; TGroupOrder := 1; TSubGroupOrder := 1;
         fnUpdatePeriodTrans(strEmpCode, 'BPAY', TGroup, TGroupOrder,
                            TSubGroupOrder, strTransDescription, curTransAmount, curBPAYBal,
                            intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,
                            salariesAcc,JournalPostAs::Debit,JournalPostingType::"G/L Account",''
                            ,CoopParameters::none);
        
        
         //Salary Arrears
         prSalaryArrears.Reset;
         prSalaryArrears.SetRange(prSalaryArrears."Employee Code",strEmpCode);
         prSalaryArrears.SetRange(prSalaryArrears."Period Month",intMonth);
         prSalaryArrears.SetRange(prSalaryArrears."Period Year",intYear);
         if prSalaryArrears.Find('-') then begin
         repeat
              curSalaryArrears := prSalaryArrears."Salary Arrears";
              curPayeArrears := prSalaryArrears."PAYE Arrears";
        
              //Insert [Salary Arrears] into period trans [ARREARS]
              curTransAmount := curSalaryArrears;
              strTransDescription := 'Salary Arrears';
              TGroup := 'ARREARS'; TGroupOrder := 1; TSubGroupOrder := 2;
              fnUpdatePeriodTrans(strEmpCode, prSalaryArrears."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,
                salariesAcc,JournalPostAs::Debit,JournalPostingType::"G/L Account",'',CoopParameters::none);
        
              //Insert [PAYE Arrears] into period trans [PYAR]
              curTransAmount:= curPayeArrears;
              strTransDescription := 'P.A.Y.E Arrears';
              TGroup := 'STATUTORY DEDUCTIONS'; TGroupOrder := 7; TSubGroupOrder := 4;
              fnUpdatePeriodTrans(strEmpCode, 'PYAR', TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept
                 ,salariesAcc,JournalPostAs::Debit,JournalPostingType::"G/L Account",'',CoopParameters::none)
        
         until prSalaryArrears.Next=0;
         end;
        
         //Get Earnings
         prEmployeeTransactions.Reset;
         prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
         prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
         prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
         prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped,false); //Added DW to not process Stopped Transactions
         if prEmployeeTransactions.Find('-') then begin
           curTotAllowances:= 0;
           repeat
             prTransactionCodes.Reset;
             prTransactionCodes.SetRange(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
             prTransactionCodes.SetRange(prTransactionCodes."Transaction Type",prTransactionCodes."Transaction Type"::Income);
             if prTransactionCodes.Find('-') then begin
        
               curTransAmount:=0; curTransBalance := 0; strTransDescription := ''; strExtractedFrml := ''; curIncludeinNet:=0;
               if prTransactionCodes."Is Formula" then begin
                   strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                   //curTransAmount := ROUND(fnFormulaResult(strExtractedFrml),0.1,'>'); //Get the calculated amount
                   curTransAmount := fnFormulaResult(strExtractedFrml);
                   //error('%1',curTransAmount);
        
               end else begin
                   curTransAmount := prEmployeeTransactions.Amount;
                   curTransAmount:=curTransAmount;
               end;
        
              if prTransactionCodes."Balance Type"=prTransactionCodes."Balance Type"::None then //[0=None, 1=Increasing, 2=Reducing]
                        curTransBalance := 0;
              if prTransactionCodes."Balance Type"=prTransactionCodes."Balance Type"::Increasing then
                        curTransBalance := prEmployeeTransactions.Balance+ curTransAmount;
              if prTransactionCodes."Balance Type"= prTransactionCodes."Balance Type"::Reducing then
                        curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
        //      IF prTransactionCodes."Include in Net"=TRUE THEN BEGIN
        //                curIncludeinNet:= curTransAmount;
        //      END;
        
        
                 //Prorate Allowances Here
                  //Get the Basic Salary (prorate basc pay if needed) //Termination Remaining
                  if (Date2DMY(dtDOE,2)=Date2DMY(dtOpenPeriod,2)) and (Date2DMY(dtDOE,3)=Date2DMY(dtOpenPeriod,3))then begin
                     CountDaysofMonth:=fnDaysInMonth(dtDOE);
                     DaysWorked:=fnDaysWorked(dtDOE,false);
                     curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount,DaysWorked,CountDaysofMonth)
                  end;
        
                 //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
                 if dtTermination<>0D then begin
                  if (Date2DMY(dtTermination,2)=Date2DMY(dtOpenPeriod,2)) and (Date2DMY(dtTermination,3)=Date2DMY(dtOpenPeriod,3))then
                    begin
                    CountDaysofMonth:=fnDaysInMonth(dtTermination);
                    DaysWorked:=fnDaysWorked(dtTermination,true);
                    curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount,DaysWorked,CountDaysofMonth)
                  end;
                 end;
                // Prorate Allowances Here
        
                 //Add Non Taxable Here
                 if (not prTransactionCodes.Taxable) and (prTransactionCodes."Special Transactions" =
                 prTransactionCodes."Special Transactions"::Ignore) then
                     curNonTaxable:=curNonTaxable+curTransAmount;
        
                 //Added to ensure special transaction that are not taxable are not inlcuded in list of Allowances
                 if (not prTransactionCodes.Taxable) and (prTransactionCodes."Special Transactions" <>
                 prTransactionCodes."Special Transactions"::Ignore) then
                    curTransAmount:=0;
        
                 curTotAllowances := curTotAllowances + curTransAmount; //Sum-up all the allowances
                 curTransAmount := curTransAmount;
                 curTransBalance := curTransBalance;
                 strTransDescription := prTransactionCodes."Transaction Name";
                 //jnlcode:=prTransactionCodes."GL Account";
                 TGroup := 'EARNINGS'; TGroupOrder := 2; TSubGroupOrder := 0;
                   //MESSAGE(FORMAT(JournalAc));
        
        
                 //Get the posting Details
                 JournalPostingType:=JournalPostingType::" ";JournalAc:='';
                 if prTransactionCodes.Subledger <> prTransactionCodes.Subledger::" " then
                 begin
                   //Customer
        
                    if prTransactionCodes.Subledger=prTransactionCodes.Subledger::Customer then begin
                        HREmployee.Get(strEmpCode);
                        Customer.Reset;
                        Customer.SetRange(Customer."Payroll No",strEmpCode);
                       if Customer.Find('-') then begin
                           JournalAc:=Customer."No.";
                        // MESSAGE(JournalAc);
                           JournalPostingType:=JournalPostingType::Customer;
                        end;
                    end;
                   /*
                    //FOR CUSTOMER
                    //***********************************
        
                    IF prTransactionCodes.Subledger=prTransactionCodes.Subledger::Customer THEN
                    BEGIN
                        //HrEmployee.GET(strEmpCode);
                        Customer.RESET;
                        Customer.SETRANGE(Customer."No.",strEmpCode);
                        IF Customer.FIND('-') THEN
                        BEGIN
                           JournalAc:=strEmpCode;
                           JournalPostingType:=JournalPostingType::Customer;
                        END;
                    END;
                    */
                    //FOR VENDOR
                    //***********************************
        /*            IF prTransactionCodes.Subledger=prTransactionCodes.Subledger::Vendor THEN
                    BEGIN
                         HREmployes.RESET;
                         HREmployes.SETRANGE(HREmployes."No.",strEmpCode);
                         IF HREmployes.FIND('-') THEN
                         BEGIN
                            JournalAc:=prEmployeeTransactions."Subledger Account";
                            JournalPostingType:=JournalPostingType::Vendor;
                         END;
                     END;
                     */
                 end else begin
                     //JournalAc:=jnlcode;
                    JournalPostingType:=JournalPostingType::"G/L Account";
                    JournalAc:=prTransactionCodes."GL Account";
        
                 end;
        
        
        
                 //End posting Details
        
                 fnUpdatePeriodTrans(strEmpCode,prTransactionCodes."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,prEmployeeTransactions.Membership,
                 prEmployeeTransactions."Reference No",SelectedPeriod,Dept,JournalAc,JournalPostAs::Debit,JournalPostingType,'',
                 prTransactionCodes."coop parameters");
        
        
        
             end;
           until prEmployeeTransactions.Next=0;
         end;
        
         //Calc GrossPay = (BasicSalary + Allowances + SalaryArrears) [Group Order = 4]
         curGrossPay := (curBasicPay + curTotAllowances + curSalaryArrears+curIncludeGross);
         curTransAmount :=/*ROUND(curGrossPay,0.1,'>'); //*/curGrossPay;
        
         strTransDescription := 'Gross Pay';
         TGroup := ' '; TGroupOrder := 3; TSubGroupOrder := 0;
         fnUpdatePeriodTrans (strEmpCode, 'GPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth,
          intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::Debit,JournalPostingType::" ",'',CoopParameters::none);
        
        //************************************************************************************************************************************
        /*
                  //Get the NSSF amount
                  IF blnPaysNssf THEN
                    curNSSF := curNssfEmployee;
                  curTransAmount := curNSSF;
                  strTransDescription := 'N.S.S.F';
                  TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 1;
                  fnUpdatePeriodTrans (strEmpCode, 'NSSF', TGroup, TGroupOrder, TSubGroupOrder,
                  strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
                  NSSFEMPyee,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::NSSF);
        */
        
        
        //************************************************************************************************************************************
                                                                   //NEW NSSF CODE HERE
        //Get the N.S.S.F amount for the month GBT
         curNssf_Base_Amount :=0;
         if intNSSF_BasedOn =intNSSF_BasedOn::Gross then //>NSSF calculation can be based on:
                 curNssf_Base_Amount := curGrossPay;
         if intNSSF_BasedOn = intNSSF_BasedOn::Basic then
                curNssf_Base_Amount := curBasicPay;
        
         //Get the NSSF amount
         if blnPaysNssf then
          curNSSF:=fnGetEmployerNSSF(curNssf_Base_Amount);
          curTransAmount := curNSSF;
         strTransDescription := 'N.S.S.F';
         TGroup := 'STATUTORY DEDUCTIONS'; TGroupOrder := 7; TSubGroupOrder := 1;
         fnUpdatePeriodTrans (strEmpCode, 'NSSF', TGroup, TGroupOrder, TSubGroupOrder,
         strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,NSSFEMPyee,
         JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::NSSF);
        
        //Update Employer deductions
         if blnPaysNssf then
          curNSSF:=fnGetEmployerNSSF(curNssf_Base_Amount);
          curTransAmount := curNSSF;
          fnUpdateEmployerDeductions(strEmpCode, 'NSSF',
           'EMP', TGroupOrder, TSubGroupOrder,'', curTransAmount, 0, intMonth, intYear,
            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod);
        
        
        //************************************************************************************************************************************
        
        
        //MESSAGE('paysnssf %1 amt %2',blnPaysNssf,curNSSF);
        //Get the Defined contribution to post based on the Max Def contrb allowed   ****************All Defined Contributions not included
         curDefinedContrib := curNSSF; //(curNSSF + curPensionStaff + curNonTaxable) - curMorgageReliefAmount
         curTransAmount := curDefinedContrib;
         curDefinedContrib_2:=curNSSF;
         strTransDescription := 'Defined Contributions';
         TGroup := 'PAYE INFORMATION'; TGroupOrder:= 5; TSubGroupOrder:= 1;
         fnUpdatePeriodTrans(strEmpCode, 'DEFCON', TGroup, TGroupOrder, TSubGroupOrder,
          strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
          '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
        
         //Get the Gross taxable amount
         //>GrossTaxable = Gross + Benefits + nValueofQuarters  ******Confirm CurValueofQuaters
         curGrossTaxable := curGrossPay + curBenefits + curValueOfQuarters;
        
         //>If GrossTaxable = 0 Then TheDefinedToPost = 0
         if curGrossTaxable = 0 then curDefinedContrib := 0;
        
         //Personal Relief
        // if get relief is ticked  - DENNO ADDED
        
        
        //Added for auto relief calculation
        if  (curGrossPay-curNSSF)  <= currMinRelief then
        begin
            blnGetsPAYERelief:=false;
        end else
        begin
            blnGetsPAYERelief:=true;
            //If employee is marked on salary card as not entitle to personal relief
            PRSalCard_2.Reset;
            if PRSalCard_2.Get(strEmpCode) then
            begin
                if PRSalCard_2."De-Activate Personal Relief?" then blnGetsPAYERelief:=false;
            end;
        
        end;
        
        if blnGetsPAYERelief then
        begin
         curReliefPersonal := curReliefPersonal + curUnusedRelief; //*****Get curUnusedRelief
         curTransAmount := curReliefPersonal;
         strTransDescription := 'Personal Relief';
         TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder := 2;
         fnUpdatePeriodTrans (strEmpCode, 'PSNR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
          '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
        end
        else
         curReliefPersonal := 0;
        
        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         //>Pension Contribution [self] relief
         curPensionStaff := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
         SpecialTransType::"Defined Contribution",false) ;//Self contrib Pension is 1 on [Special Transaction]
         if curPensionStaff > 0 then begin
             if curPensionStaff > curMaxPensionContrib then
                 curTransAmount :=Round(curMaxPensionContrib,0.1,'<')
             else
                 curTransAmount :=Round(curPensionStaff,0.1,'<');
             strTransDescription := 'Pension Relief';
             TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder := 3;
             fnUpdatePeriodTrans (strEmpCode, 'PNSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
             curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
             '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none)
         end;
        
        
        //if he PAYS paye only*******************I
        if blnPaysPaye and blnGetsPAYERelief then
        begin
          //Get Insurance Relief
          curInsuranceReliefAmount := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          SpecialTransType::"Life Insurance",false); //Insurance is 3 on [Special Transaction]
        
          //********************************************************************************************************************************************************
          //Added DW - for employees who have brought the Insurance certificate, they are entitled to Insurance relief, Otherwise NO
          //Place a check mark on the Salary Card to YES
          if (curInsuranceReliefAmount > 0) /*AND (blnInsuranceCertificate)*/then begin
              curTransAmount := curInsuranceReliefAmount;
              strTransDescription := 'Insurance Relief';
              TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder := 4;
              fnUpdatePeriodTrans (strEmpCode, 'INSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
              '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
         end;
        
        // //Get Pension Relief
        //  curPensionReliefAmount := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
        //  SpecialTransType::"Voluntary Pension",FALSE); //Insurance is 3 on [Special Transaction]
        //  IF curPensionReliefAmount > 0 THEN BEGIN
        //      curTransAmount := curPensionReliefAmount;
        //      strTransDescription := 'Voluntary NSSF / Pension Relief';
        //      TGroup := 'PAYE INFORMATION'; TGroupOrder := 6; TSubGroupOrder := 8;
        //      fnUpdatePeriodTrans (strEmpCode, 'IPR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
        //      curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
        //      '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
        //
        //  END;
        
         //>OOI
          curOOI := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          SpecialTransType::"Owner Occupier Interest",false); //Morgage is LAST on [Special Transaction]
          if curOOI > 0 then begin
            if curOOI<=curOOIMaxMonthlyContrb then
              curTransAmount := curOOI
            else
              curTransAmount:=curOOIMaxMonthlyContrb;
        
              strTransDescription := 'Owner Occupier Interest';
              TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder := 5;
              fnUpdatePeriodTrans (strEmpCode, 'OOI', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
              '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
          end;
        
        //HOSP
          curHOSP := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          SpecialTransType::"Home Ownership Savings Plan",false); //Home Ownership Savings Plan
          if curHOSP > 0 then begin
            if curHOSP<=curReliefMorgage then
              curTransAmount := curHOSP
            else
              curTransAmount:=curReliefMorgage;
        
              strTransDescription := 'Home Ownership Savings Plan';
              TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder := 6;
              fnUpdatePeriodTrans (strEmpCode, 'HOSP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
              '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
          end;
        
        //Mortage Relief
          curMorgageRelief := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          SpecialTransType::Mortgage,false);
          if curMorgageRelief > 0 then begin
              curTransAmount:=curMorgageRelief;
             strTransDescription := 'Mortgage Relief';
             TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder :=7;
             fnUpdatePeriodTrans (strEmpCode, 'MORG-RL', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
             curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
             '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none)
        
          end;
          //Voluntary
          curVoluntaryPayCut := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          SpecialTransType::VoluntaryCut,false);
          if curVoluntaryPayCut > 0 then begin
              curTransAmount:=curVoluntaryPayCut;
             strTransDescription := 'Voluntary Pay Cut';
             TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder :=8;
             fnUpdatePeriodTrans (strEmpCode, 'VOLPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
             curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
             '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none)
        
          end;
          //Voluntary
        
        //Enter NonTaxable Amount
        if curNonTaxable>0 then begin
              strTransDescription := 'Other Non-Taxable Benefits';
              TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder := 9;
              fnUpdatePeriodTrans (strEmpCode, 'NONTAX', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curNonTaxable, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
              '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
        end;
        
        end;
        
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        curExcessPension:=0;EmployerPension:=0;curPensionCompany:=0;
         //kate
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         //>Company pension, Excess pension, Tax on excess pension
          curPensionCompany := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear, SpecialTransType::"Defined Contribution",
         true); //Self contrib Pension is 1 on [Special Transaction]
         if curPensionCompany > 0 then begin
             curTransAmount := curPensionCompany;
             strTransDescription := 'Pension (Company)';
             curExcessPension:=(EmployerPension+curPensionCompany)-curMaxPensionContrib;
                 if curExcessPension > 0 then begin
                 curTransAmount := curExcessPension;
        
                 strTransDescription := 'Excess Pension';
                 TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder := 10;
                 fnUpdatePeriodTrans (strEmpCode, 'EXCP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                 curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
                  '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
                  curTransAmount:=0;
        
                 curTaxOnExcessPension := (curRateTaxExPension / 100) * curExcessPension;
                 curTransAmount := curTaxOnExcessPension;
                 ExcessPenTax:=curTransAmount;
                 strTransDescription := 'Tax on ExPension';
                 TGroup := 'STATUTORY DEDUCTIONS'; TGroupOrder := 7; TSubGroupOrder := 5;
                 fnUpdatePeriodTrans (strEmpCode, 'TXEP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                 curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
                  '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
        
                  end;
                  end;
         end;
        
        
        //kay
        
        
         //Get the Taxable amount for calculation of PAYE
         //>prTaxablePay = (GrossTaxable - SalaryArrears) - (TheDefinedToPost + curSelfPensionContrb + MorgageRelief)
        
        
        BenifitAmount:=0;
        
        PRTransCode_2.Reset;
        PRTransCode_2.SetRange(PRTransCode_2."Transaction Type",PRTransCode_2."Transaction Type"::Benefit);
        //PRTransCode_2.SETFILTER(PRTransCode_2."Special Transactions",'<>%1',PRTransCode_2."Special Transactions"::;
        if PRTransCode_2.Find('-') then
        begin
         repeat
            PREmpTrans_2.Reset;
            PREmpTrans_2.SetRange(PREmpTrans_2."Transaction Code",PRTransCode_2."Transaction Code");
            PREmpTrans_2.SetRange(PREmpTrans_2."Employee Code",strEmpCode);
            PREmpTrans_2.SetRange(PREmpTrans_2."Payroll Period",SelectedPeriod);
            if PREmpTrans_2.Find('-') then
            begin
        
                if PRTransCode_2.Taxable then BenifitAmount:=(PREmpTrans_2.Amount);
                strTransDescription := PRTransCode_2."Transaction Name";
                curTransAmount:=PREmpTrans_2.Amount;
                TGroup := 'PAYE INFORMATION'; TGroupOrder:= 5; TSubGroupOrder:= 11;
                fnUpdatePeriodTrans(strEmpCode, 'BFT'+PRTransCode_2."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
                '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
        
        
            end;
         until PRTransCode_2.Next=0;
        end;
         /* CurClubMembership:=0;
        //Club Membership
        PRTransCode_2.RESET;
        PRTransCode_2.SETRANGE(PRTransCode_2."Transaction Type",PRTransCode_2."Transaction Type"::Benefit);
        PRTransCode_2.SETRANGE(PRTransCode_2."Special Trans Incomes",PRTransCode_2."Special Trans Incomes"::ClubMembership);
        IF PRTransCode_2.FIND('-') THEN
        BEGIN
            PREmpTrans_2.RESET;
            PREmpTrans_2.SETRANGE(PREmpTrans_2."Transaction Code",PRTransCode_2."Transaction Code");
            PREmpTrans_2.SETRANGE(PREmpTrans_2."Employee Code",strEmpCode);
            PREmpTrans_2.SETRANGE(PREmpTrans_2."Payroll Period",SelectedPeriod);
            IF PREmpTrans_2.FIND('-') THEN
            BEGIN
                IF PRTransCode_2.Taxable THEN CurClubMembership:=(PREmpTrans_2.Amount);
                //Club Membership
                //Insert in to PR Period Trans
                strTransDescription := PRTransCode_2."Transaction Name";
                curTransAmount:=PREmpTrans_2.Amount;
                TGroup := 'PAYE INFORMATION'; TGroupOrder:= 6; TSubGroupOrder:= 1;
                fnUpdatePeriodTrans(strEmpCode, PRTransCode_2."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
                '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
        
                //Initialize
                curTransAmount:=0; curTransBalance := 0; strTransDescription := '';
            END;
        END;
        */
        
          //Add HOSP and MORTGAGE KIM{}
          /*To be used for 2 Scenarios only
         IF curPensionStaff*3 > curMaxPensionContrib THEN
           curTaxablePay:= curGrossTaxable  - (curSalaryArrears + curDefinedContrib +curMaxPensionContrib+curOOI+curHOSP+curNonTaxable
                            +curPensionReliefAmount) + BenifitAmount+curExcessPension//Kay
         ELSE
             curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +curPensionStaff+curOOI+curHOSP+curNonTaxable
                            +curPensionReliefAmount) + BenifitAmount;//+curExcessPension;//Kay;
        */
         //Taxable pay for 3 Pension Scenarios****Kay
         //one
        
         if (curPensionStaff+curDefinedContrib) > curMaxPensionContrib then
           curTaxablePay:= curGrossTaxable - (curSalaryArrears + curMaxPensionContrib+curOOI+curHOSP+curNonTaxable)+BenifitAmount
         else
             curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +curPensionStaff+curOOI+curHOSP+curNonTaxable)+BenifitAmount;
         /*//Two
          IF curPensionStaff> curMaxPensionContrib THEN
          curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib+curMorgageRelief+curVoluntaryPayCut +curPensionStaff+curOOI+curHOSP+curNonTaxable
                            +curPensionReliefAmount) +CurClubMembership+ BenifitAmount+curExcessPension+curNSSF;
        //Normal
          IF curPensionStaff< curMaxPensionContrib THEN
          curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib+curMorgageRelief+curVoluntaryPayCut +curPensionStaff+curOOI+curHOSP+curNonTaxable
                            +curPensionReliefAmount) +CurClubMembership+ BenifitAmount+curExcessPension;*/
        /*
         IF curPensionStaff*3 > curMaxPensionContrib THEN
          IF curPensionStaff > curMaxPensionContrib THEN
           curTaxablePay:= curGrossTaxable  - (curSalaryArrears + curDefinedContrib+curMorgageRelief+curVoluntaryPayCut+curMaxPensionContrib+curOOI+curHOSP+curNonTaxable
                            +curPensionReliefAmount) +CurClubMembership+ BenifitAmount+curExcessPension;
        
        //Three
         IF curPensionStaff*3< curMaxPensionContrib THEN
         IF curPensionStaff<curMaxPensionContrib THEN
             curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +curMorgageRelief+curVoluntaryPayCut+curPensionStaff+curOOI+curHOSP+curNonTaxable
                            +curPensionReliefAmount) +CurClubMembership+ BenifitAmount;
          */
        //Diabled
         //If Employee is disabled and Tax Pay > 150,000 then tax excess of 150,000 else do not tax anything
         HREmp.Get(strEmpCode);
         if HREmp.Disabled = HREmp.Disabled::Yes then
         begin
            //If TP > 150,000
            if curTaxablePay >= VitalSetup."Disbled Tax Limit" then
            begin
                curTaxablePay:=curTaxablePay - VitalSetup."Disbled Tax Limit";
        
            end else if curTaxablePay < VitalSetup."Disbled Tax Limit" then
            begin
                curTaxablePay:=0;
            end;
        end;
        //End Disabled Tax Limit
         /*kay
         //Added increase taxable if curPensionStaff > 20K increase taxable pay by 30% OF  excess pension contribution
         IF curPensionStaff > curMaxPensionContrib THEN
         BEGIN
            curTaxablePay += 0.3 *(curPensionStaff - curMaxPensionContrib - curDefinedContrib);
         END;
         //End added
         */
         curTaxablePay:=curTaxablePay;
         curTransAmount := curTaxablePay;
         strTransDescription := 'Taxable Pay';
         TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder := 12;
         fnUpdatePeriodTrans (strEmpCode, 'TXBP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
          '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
        
        //
        //  //Get the Tax charged for the month
        // //Added for auto relief calculation
        // IF  (curGrossPay-curNSSF)  <= currMinRelief THEN
        // BEGIN
        //     blnPaysPaye:=FALSE;
        // END ELSE
        // BEGIN
        //     blnPaysPaye:=TRUE;
        // END;
        //
        
        
         if blnPaysPaye then
         begin
            //Added:: Special Tax for Secondary Staff
            HREmp2.Reset;
            if HREmp2.Get(strEmpCode) then
            begin
        //    IF HREmp2."Employment Type" = HREmp2."Employment Type"::Casuals THEN
        //    BEGIN
        //        curTaxCharged := curTaxablePay * 0.25; //<<< 29-April-2020 New Paye Changes >>>
        //        curTransAmount := curTaxCharged;
        //        curTransAmount :=  ROUND(curTaxCharged,1,'>');
        //        strTransDescription := 'Tax Charged';
        //        TGroup := 'PAYE INFORMATION'; TGroupOrder := 6; TSubGroupOrder := 7;
        //        fnUpdatePeriodTrans (strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
        //        curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
        //        '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
        //    END ELSE
            //End Added
            begin
        
            //Tax for Normal staff
        
              curTaxCharged := fnGetEmployeePaye(curTaxablePay);
              curTransAmount :=  curTaxCharged; //ROUND PAYE UP TO NEAREST WHOLE NO
              strTransDescription := 'Tax Charged';
              TGroup := 'PAYE INFORMATION'; TGroupOrder := 5; TSubGroupOrder := 13;
              fnUpdatePeriodTrans (strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
              '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
            end;
            end;
         end;
        // MESSAGE('pays %1 tax %2',blnPaysPaye,curGrossTaxable);
         //Get the Net PAYE amount to post for the month
         if (curReliefPersonal + curInsuranceReliefAmount) > curMaximumRelief then
         begin
            curPAYE :=curTaxCharged - curMaximumRelief;
         end else
         begin
            //******************************************************************************************************************************************
            //Added DW: Only for Employees who have brought their insurance Certificate are entitled to Insurance Relief Otherwise NO
            //Place a check mark on the Salary Card to YES
        
            if (curInsuranceReliefAmount)>0 then
            begin
                //curPAYE := curTaxCharged - (curReliefPersonal + curInsuranceReliefAmount + curMorgageRelief);
                curPAYE := curTaxCharged - (curReliefPersonal + curInsuranceReliefAmount);
            end else begin
                //curPAYE := curTaxCharged - (curReliefPersonal + curMorgageRelief);
                curPAYE := curTaxCharged - (curReliefPersonal);
            end;
            //******************************************************************************************************************************************
          end;
        
        
        
        
          //Added for auto PAYE calculation
        //   IF  (curGrossPay-curNSSF)  <= currMinRelief THEN
        //   BEGIN
        //       blnPaysPaye:=FALSE;
        //   END ELSE
        //   BEGIN
        //       blnPaysPaye:=TRUE;
        //   END;
        
        
         if not blnPaysPaye then curPAYE := 0; //Get statutory Exemption for the staff. If exempted from tax, set PAYE=0
         curTransAmount := curPAYE;
         //curTransAmount := ROUND(curPAYE,0.1,'>');
         if curPAYE<0 then curTransAmount := 0;
         strTransDescription := 'P.A.Y.E';
         TGroup := 'STATUTORY DEDUCTIONS'; TGroupOrder := 7; TSubGroupOrder := 3;
         fnUpdatePeriodTrans (strEmpCode, 'PAYE', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
          TaxAccount,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::none);
        
         //Store the unused relief for the current month
         //>If Paye<0 then "Insert into tblprUNUSEDRELIEF
         if curPAYE < 0 then begin
         prUnusedRelief.Reset;
         prUnusedRelief.SetRange(prUnusedRelief."Employee Code",strEmpCode);
         prUnusedRelief.SetRange(prUnusedRelief."Period Month",intMonth);
         prUnusedRelief.SetRange(prUnusedRelief."Period Year",intYear);
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
         end;
        end;
        
         //Deductions: get all deductions for the month
         //Loans: calc loan deduction amount, interest, fringe benefit (employer deduction), loan balance
         //>Balance = (Openning Bal + Deduction)...//Increasing balance
         //>Balance = (Openning Bal - Deduction)...//Reducing balance
         //>NB: some transactions (e.g Sacco shares) can be made by cheque or cash. Allow user to edit the outstanding balance
        
         //Get the N.H.I.F amount for the month GBT
         curNhif_Base_Amount :=0;
        
         if intNHIF_BasedOn =intNHIF_BasedOn::Gross then //>NHIF calculation can be based on:
                 curNhif_Base_Amount := curGrossPay;
         if intNHIF_BasedOn = intNHIF_BasedOn::Basic then
                curNhif_Base_Amount := curBasicPay;
         if intNHIF_BasedOn =intNHIF_BasedOn::"Taxable Pay" then
                curNhif_Base_Amount := curTaxablePay;
        
         if blnPaysNhif then begin
          curNHIF:=fnGetEmployeeNHIF(curNhif_Base_Amount);
          curTransAmount := curNHIF;
          strTransDescription := 'N.H.I.F';
          TGroup := 'STATUTORY DEDUCTIONS'; TGroupOrder := 7; TSubGroupOrder := 2;
          fnUpdatePeriodTrans (strEmpCode, 'NHIF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
           curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
           NHIFEMPyee,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::none);
         end;
        
          prEmployeeTransactions.Reset;
          prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
          prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
          prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
          prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped,false); //Added DW to not process Stopped Transactions
          if prEmployeeTransactions.Find('-') then begin
            curTotalDeductions:= 0;
            repeat
              prTransactionCodes.Reset;
              prTransactionCodes.SetRange(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
              prTransactionCodes.SetRange(prTransactionCodes."Transaction Type",prTransactionCodes."Transaction Type"::Deduction);
              if prTransactionCodes.Find('-') then begin
                curTransAmount:=0; curTransBalance := 0; strTransDescription := ''; strExtractedFrml := '';
        
                if prTransactionCodes."Is Formula" then
                begin
                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                    curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount
                    fnUpdateEmployeeTrans(strEmpCode,prTransactionCodes."Transaction Code",curTransAmount,intMonth,intYear,SelectedPeriod);
                end else begin
                    curTransAmount := prEmployeeTransactions.Amount;
                end;
        
                // - Customized for AFFA (Each Directorate has its own Formalua for Pension
        /*        IF prTransactionCodes."Is Formula Per Directorate" THEN
                BEGIN
                    //Get directorate of staff
                    HREmp.RESET;
                    HREmp.SETRANGE(HREmp."No.",strEmpCode);
                    IF HREmp.FIND('-') THEN
                    BEGIN
                        HREmp.TESTFIELD(HREmp."Dimension 1 Code");
        
                        //Get Formulae from PR Trans Code Formulae
                        PRTransCodeForm.RESET;
                        PRTransCodeForm.SETRANGE(PRTransCodeForm."Global Dimension 1 Code",HREmp."Dimension 1 Code");
                        IF PRTransCodeForm.FIND('-') THEN
                        BEGIN
                            PRTransCodeForm.TESTFIELD(PRTransCodeForm."Employee Formulae");
                            strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear,PRTransCodeForm."Employee Formulae");
                            curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount
                        END ELSE
                        BEGIN
        //                     ERROR('Formulae Per Directorate for Transaction Code[ %1 ] is not specified for Directorate %2',
        //                           strTransCode,HREmp."Dimension 1 Code");
                        END;
                    END;
                END;
                // - End Customized for AFFA*/
        
               //**************************If "deduct Premium" is not ticked and the type is insurance- Dennis*****
               if (prTransactionCodes."Special Transactions"=prTransactionCodes."Special Transactions"::"Life Insurance")
                 and (prTransactionCodes."Deduct Premium"=false) then
                begin
                 curTransAmount:=0;
                end;
        
               //**************************If "deduct Premium" is not ticked and the type is mortgage- Dennis*****
               if(prTransactionCodes."Special Transactions"=prTransactionCodes."Special Transactions"::Morgage)
                and (prTransactionCodes."Deduct Mortgage"=false) then
                begin
                 curTransAmount:=0;
                end;
        
                /*
               //**************************If "deduct Premium" is not ticked and the type is mortgage- Dennis*****
               IF(prTransactionCodes."Special Transactions"=prTransactionCodes."Special Transactions"::)
                AND (prTransactionCodes.Welfare=FALSE) THEN
                BEGIN
                 curTransAmount:=0;
                END;
                */
            //Get the posting Details
                 JournalPostingType:=JournalPostingType::" ";JournalAc:='';
                 if prTransactionCodes.Subledger<>prTransactionCodes.Subledger::" " then begin
                    //IF prTransactionCodes.Subledger=prTransactionCodes.Subledger::Customer THEN BEGIN
                        ////Customer.RESET;
                       // HrEmployee.GET(strEmpCode);
                     //   {
                          //Customer
                          if prTransactionCodes.Subledger=prTransactionCodes.Subledger::Customer then
                          begin
                              //HrEmployee.GET(strEmpCode);
                              Customer.Reset;
                              Customer.SetRange(Customer."No.",strEmpCode);
                              if Customer.Find('-') then
                              begin
                                 JournalAc:=strEmpCode;
                                 JournalPostingType:=JournalPostingType::Customer;
                              end;
                          end;
        
                          //FOR VENDOR
                          //***********************************
                /*          IF prTransactionCodes.Subledger=prTransactionCodes.Subledger::Vendor THEN
                          BEGIN
                               HREmployes.RESET;
                               HREmployes.SETRANGE(HREmployes."No.",strEmpCode);
                               IF HREmployes.FIND('-') THEN
                               BEGIN
                                  JournalAc:=prEmployeeTransactions."Subledger Account";
                                  JournalPostingType:=JournalPostingType::Vendor;
                               END;
                           END;*/
        
                 end else begin
                    JournalAc:=prTransactionCodes."GL Account";
                    JournalPostingType:=JournalPostingType::"G/L Account";
                 end;
        
                //End posting Details
        
        
                //Loan Calculation is Amortized do Calculations here -Monthly Principal and Interest Keeps on Changing
            /*    IF (prTransactionCodes."Special Transactions"=prTransactionCodes."Special Transactions"::"Staff Loan") AND
                   (prTransactionCodes."Repayment Method" = prTransactionCodes."Repayment Method"::Reducing) THEN BEGIN
                   curTransAmount:=0; curLoanInt:=0;
        
                   IF NOT prEmployeeTransactions. THEN prEmployeeTransactions.TESTFIELD(prEmployeeTransactions."Loan Interest Rate");
        
                   curLoanInt:=fnCalcLoanInterest (strEmpCode, prEmployeeTransactions."Transaction Code",
                   prEmployeeTransactions."Loan Interest Rate",prTransactionCodes."Repayment Method",
                      prEmployeeTransactions."Original Amount",prEmployeeTransactions.Balance,SelectedPeriod);
                   //Post the Interest
                   IF (curLoanInt<>0) THEN BEGIN
                          curTransAmount := curLoanInt;
                          curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                          curTransBalance:=0;
                          strTransCode := prEmployeeTransactions."Transaction Code"+'-INT';
                          strTransDescription := prEmployeeTransactions."Transaction Name"+ ' Interest';
                          TGroup := 'OTHER DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 1;
        
                          fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                            strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                            JournalAc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                            CoopParameters::"loan Interest")
                    END;
                   //Get the Principal Amt
                   //curTransAmount:=prEmployeeTransactions."Amortized Loan Total Repay Amt"-curLoanInt;
                    //Modify PREmployeeTransaction Table
                    //prEmployeeTransactions.Amount:=curTransAmount;
                    //prEmployeeTransactions.MODIFY;
                END;
                //Loan Calculation Amortized*/
        
                case prTransactionCodes."Balance Type" of //[0=None, 1=Increasing, 2=Reducing]
                    prTransactionCodes."Balance Type"::None:
                         curTransBalance := 0;
                    prTransactionCodes."Balance Type"::Increasing:
                    begin
                          //Added Dann
                         if prTransactionCodes."Special Transactions" <> prTransactionCodes."Special Transactions"::"Defined Contribution"
                         then
                         begin
                            curTransAmount := prEmployeeTransactions.Amount;
                         end;
                         //Added Dann
                        curTransBalance := prEmployeeTransactions.Balance+ curTransAmount;
                    end;
                   prTransactionCodes."Balance Type"::Reducing:
                   begin
                        //curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                        if prEmployeeTransactions.Balance < prEmployeeTransactions.Amount then begin
                             curTransAmount := prEmployeeTransactions.Balance;
                             curTransBalance := 0;
                         end else begin
                             //Added Dann
                             curTransAmount := prEmployeeTransactions.Amount;
                             //Added Dann
        
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
        
                TGroup := 'DEDUCTIONS'; TGroupOrder := 4; TSubGroupOrder := 0;
                fnUpdatePeriodTrans (strEmpCode, prEmployeeTransactions."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription,curTransAmount, curTransBalance, intMonth,
                 intYear, prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                 JournalAc,JournalPostAs::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                 prTransactionCodes."coop parameters");
                 /*
               //Fringe Benefits and Low interest Benefits
                      IF prTransactionCodes."Fringe Benefit" = TRUE THEN BEGIN
                          IF prTransactionCodes."Interest Rate" < curLoanMarketRate THEN BEGIN
                              fnCalcFringeBenefit := (((curLoanMarketRate - prTransactionCodes."Interest Rate") * curLoanCorpRate) / 1200)
                               * prEmployeeTransactions.Balance;
                          END;
                      END ELSE BEGIN
                          fnCalcFringeBenefit := 0;
                      END;
                      IF  fnCalcFringeBenefit>0 THEN BEGIN
                          fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code"+'-FRG',
                           'EMP', TGroupOrder, TSubGroupOrder,'Fringe Benefit Tax', fnCalcFringeBenefit, 0, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod)
        
                      END;
               //End Fringe Benefits
               */
                //Added to get Fringe Benefit Tax
                if prTransactionCodes."Fringe Benefit" then
                begin
                     //Get Fringe Benefit Amount
                     if curLoanCorpRate < curLoanMarketRate then
                     begin
                         fnCalcFringeBenefit := (curLoanMarketRate - curLoanCorpRate)*prEmployeeTransactions.Balance;
                     end else
                     begin
                          fnCalcFringeBenefit := 0;
                     end;
        
                    //Get Fringe Benefit Tax = FBA / 12 *30%
                    if  fnCalcFringeBenefit > 0 then
                    begin
                        fnCalcFringeBenefit:=(fnCalcFringeBenefit / 12 ) * 0.3;
        
                        fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code"+'-FRG',
                          'EMP', TGroupOrder, TSubGroupOrder,'Fringe Benefit Tax', fnCalcFringeBenefit, 0, intMonth, intYear,
                          prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod)
        
                    end;
              end;
                //Added to get Fringe Benefit Tax
              //Create Employer Deduction
              //Modified  - Each Directorate has its own formula for Pension
              if (prTransactionCodes."Special Transactions" = prTransactionCodes."Special Transactions"::"Defined Contribution") then
              begin
        //          IF prTransactionCodes."Is Formula Per Directorate" THEN
        //          BEGIN
        //            //Get Directorate of Staff
        //            HREmp.RESET;
        //            HREmp.SETRANGE(HREmp."No.",strEmpCode);
        //            IF HREmp.FIND('-') THEN
        //            BEGIN
        //                HREmp.TESTFIELD(HREmp."Dimension 1 Code");
        //
        //                //Get Formulae from PR Trans Code Formulae
        //                PRTransCodeForm.RESET;
        //                PRTransCodeForm.SETRANGE(PRTransCodeForm."Global Dimension 1 Code",HREmp."Dimension 1 Code");
        //                IF PRTransCodeForm.FIND('-') THEN
        //                BEGIN
        //                    IF PRTransCodeForm."Include In Employer Deductions" THEN
        //                    BEGIN
        //                        PRTransCodeForm.TESTFIELD(PRTransCodeForm."Employer Formulae");
        //                    END;
                            if prTransactionCodes."Include Employer Deduction" then
                            begin
                                strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear,prTransactionCodes."Is Formula for employer");
                                curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount
        
                                if curTransAmount > 0 then
                                begin
                                    fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code",
                                   'EMP', TGroupOrder, TSubGroupOrder,'', curTransAmount, 0, intMonth, intYear,
                                    prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod);
                                end;
                          end;
        //            END;
        //      END;
              //Modified Dan - Each Directorate has its own formula for Pension
        
        //         //Update Balance on PR Period Transaction Table with Pension Contributed from Employer
        //          PRPeriodTrans.RESET;
        //          PRPeriodTrans.SETRANGE(PRPeriodTrans."Employee Code",strEmpCode);
        //          PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code",prEmployeeTransactions."Transaction Code");
        //          PRPeriodTrans.SETRANGE(PRPeriodTrans."Payroll Period",SelectedPeriod);
        //          IF PRPeriodTrans.FIND('-') THEN
        //          BEGIN
        //             IF PRPeriodTrans.Balance <> 0 THEN PRPeriodTrans.Balance += curTransAmount;
        //             PRPeriodTrans.MODIFY;
        //          END;
        //         //Added Dann
        
              end;
              end;
        
          until prEmployeeTransactions.Next=0;
             //GET TOTAL DEDUCTIONS
                          //Total Deductions to Include PAYE, NSSF, NHIF
                          //curTotalDeductions:=curTotalDeductions;
                          //Total Deductions to Include PAYE, NSSF, NHIF
                          curTransBalance:=0;
                          strTransCode := 'TOT-DED';
                          strTransDescription := 'TOTAL NON-STATUTORY DEDUCTIONS';
                          TGroup := ''; TGroupOrder := 4; TSubGroupOrder := 0;
                          fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                            strTransDescription, curTotalDeductions, curTransBalance, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                            '',JournalPostAs::Credit,JournalPostingType::" ",'',CoopParameters::none);
        
             //END GET TOTAL DEDUCTIONS
         end;
        
        
        
        
        
          //Net Pay: calculate the Net pay for the month in the following manner:
          //>Nett = Gross - (xNssfAmount + curMyNhifAmt + PAYE + PayeArrears + prTotDeductions)
          //...Tot Deductions also include (SumLoan + SumInterest)
           curNetPay :=curGrossPay - (curNSSF + curNHIF + curPAYE + curPayeArrears + curTotalDeductions);//-curIncludeinNet;
          //curNetPay:=curNetPay+curIncludeinNet;
          //>Nett = Nett - curExcessPension
          //...Excess pension is only used for tax. Staff is not paid the amount hence substract it
          curNetPay := curNetPay; //- curExcessPension
        
          //>Nett = Nett - cSumEmployerDeductions
          //...Employer Deductions are used for reporting as cost to company BUT dont affect Net pay
          curNetPay := curNetPay - curTotCompanyDed; //******Get Company Deduction*****
        
        /*//to check 1/3rule when processing hk
        IF curNetPay<(1/3*curBasicPay) THEN
        ERROR('Netpay for staff'+' '+strEmpCode+' '+'is below the 1/3 rule which is'+' '+(format(1/3*curBasicPay)));
        */
          curNetRnd_Effect := curNetPay - Round(curNetPay);
          //curNetPay:=ROUND(curNetPay,0.5,'>'); //Check here
          curNetPay:=curNetPay;
          curTransAmount := curNetPay;
          strTransDescription := 'Net Pay';
          TGroup := 'NET PAY'; TGroupOrder := 4; TSubGroupOrder := 1;
         // MESSAGE('NetPay %1',curNetPay);
        /*
         // IF curNetPay < 0 THEN MESSAGE('Net Pay for Employee No. %1 is %2',strEmpCode, curNetPay);
         //1/3 Rule
             PRSalCard_2.RESET;
              PRSalCard_2.SETRANGE(PRSalCard_2."Employee Code",strEmpCode);
              //PRSalCard_2.SETRANGE(PRSalCard_2."Ignore A Third Rule",FALSE);
        
                IF PRSalCard_2.FIND('-') THEN
                   BEGIN
                   ThirdSalary:=1/3*PRSalCard_2."Basic Pay";
                   END;
        
        
             IF curNetPay< ThirdSalary THEN
        
           //ERROR('Net Pay for Employee No. %1 which is %2 violates the 1/3 rule',strEmpCode,curNetPay);
        
           //1/3 Rule*/
        
          fnUpdatePeriodTrans(strEmpCode, 'NPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
          PayablesAcc,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::none);
        
        //  //*************************************************************************************************************
        //  //Added: DW. To Update PR Staff Bank Transactions with Net Pay Amounts that are transfered to Individual Banks
        
        //  fnUpdateStaffBankTrans(strEmpCode, 'NPAY',strTransDescription,curTransAmount,
        //                        intMonth, intYear,SelectedPeriod,Dept);
        
        
        //  //*************************************************************************************************************

    end;

    procedure fnBasicPayProrated(strEmpCode: Code[20];Month: Integer;Year: Integer;BasicSalary: Decimal;DaysWorked: Integer;DaysInMonth: Integer) ProratedAmt: Decimal
    begin
         ProratedAmt:= Round((DaysWorked / DaysInMonth) * BasicSalary,0.1,'<');
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
        TodayDate:=dtDate;

         Day:=Date2DMY(TodayDate,1);
         Expr1:=Format(-Day)+'D+1D';
         FirstDay:=CalcDate(Expr1,TodayDate);
         LastDate:=CalcDate('1M-1D',FirstDay);

         SysDate.Reset;
         SysDate.SetRange(SysDate."Period Type",SysDate."Period Type"::Date);
         SysDate.SetRange(SysDate."Period Start",FirstDay,LastDate);
         SysDate.SetFilter(SysDate."Period No.",'1..7');
         if SysDate.Find('-') then
            DaysInMonth:=SysDate.Count;
    end;

    procedure fnUpdatePeriodTrans(EmpCode: Code[20];TCode: Code[20];TGroup: Code[30];GroupOrder: Integer;SubGroupOrder: Integer;Description: Text[50];curAmount: Decimal;curBalance: Decimal;Month: Integer;Year: Integer;mMembership: Text[30];ReferenceNo: Text[30];dtOpenPeriod: Date;Department: Code[50];JournalAC: Code[20];PostAs: Option " ",Debit,Credit;JournalACType: Option " ","G/L Account",Customer,Vendor;LoanNo: Code[10];CoopParam: Option "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension)
    var
        PRPeriodTransactions: Record "prPeriod Transactions";
        HRBankAccounts: Record "HR Employee Bank Accounts";
        curNetPay_2: Decimal;
        InterestCode: Code[20];
    begin
        //******************************************************************************************************************************************
        /* Added Dann. for Multiple bank A/Cs                                                                                                       */
        //******************************************************************************************************************************************
        if TCode = 'NPAY' then
        begin
            HRBankAccounts.Reset;
            HRBankAccounts.SetRange(HRBankAccounts."Employee Code",EmpCode);
            if HRBankAccounts.Find('-') then
            begin
              repeat
                 HRBankAccounts.TestField(HRBankAccounts."Bank  Code");
                 HRBankAccounts.TestField(HRBankAccounts."Branch Code");
                 HRBankAccounts.TestField(HRBankAccounts."A/C  Number");
                 HRBankAccounts.TestField(HRBankAccounts."Percentage to Transfer");
        
                 HRBankSummary.Reset;
                 HRBankSummary.Init;
        
                 HRBankSummary."Line No.":=GetLastEntryNo;
                 HRBankSummary."Bank Code":=HRBankAccounts."Bank  Code";
                 HRBankSummary."Branch Code":=HRBankAccounts."Branch Code";
                 HRBankSummary."Staff Bank Name":=UpperCase(HRBankAccounts."Bank Name");
                 HRBankSummary."Payroll Period":=dtOpenPeriod;
                 HRBankSummary.Amount:=curAmount*HRBankAccounts."Percentage to Transfer"*0.01;
                 HRBankSummary."Transaction Code":='NPAY';
                 HRBankSummary."Staff No.":=EmpCode;
                 HRBankSummary."Bank Name":=UpperCase(HRBankAccounts."Bank Name");
                 HRBankSummary."Branch Name":=UpperCase(HRBankAccounts."Branch Name");
                 HRBankSummary."A/C Number":=HRBankAccounts."A/C  Number";
                 HRBankSummary."% NPAY":=HRBankAccounts."Percentage to Transfer";
        
                 if HRBankSummary.Amount > 0 then HRBankSummary.Insert;
        
               until HRBankAccounts.Next =0;
             end else
             begin
                 //ERROR('No Bank A/C has been specified for [Employee No %1]',EmpCode);
             end;
        end;
        //******************************************************************************************************************************************
        //******************************************************************************************************************************************
        
        
        if curAmount = 0 then exit;
        with PRPeriodTransactions do begin
            Init;
            "Employee Code" := EmpCode;
            "Transaction Code" := TCode;
            "Group Text" := TGroup;
            "Transaction Name" := Description;
             Amount := curAmount;
             Balance := curBalance;
            "Original Amount" := Balance;
            "Group Order" := GroupOrder;
            "Sub Group Order" := SubGroupOrder;
             Membership := mMembership;
             "Reference No" := ReferenceNo;
            "Period Month" := Month;
            "Period Year" := Year;
            "Payroll Period" := dtOpenPeriod;
            "Department Code":=Department;
            "Journal Account Type":=JournalACType;
            "Post As":=PostAs;
            "Journal Account Code":=JournalAC;
             "Loan Number":=LoanNo;
             "coop parameters":=CoopParam;
        
        
        
             //DW
             //Insert Dim and Contract Type for each Trans Being Updated
             HREmp2.Reset;
             if HREmp2.Get(EmpCode) then
             begin
                 "Global Dimension 1 Code":=HREmp2."Dimension 1 Code";
                 "Global Dimension 2 Code":=HREmp2."Dimension 2 Code";
                 //:=HREmp2."Employment Type";
             end;
             //Insert Transaction Type (Either "Income or Deduction") for each Trans Being Updated
             PRTransCode.Reset;
             PRTransCode.SetRange(PRTransCode."Transaction Code",TCode);
             if PRTransCode.Find('-') then
             begin
                  "Transaction Type":=PRTransCode."Transaction Type";
        //           "Group Code":=PRTransCode."Group Code";
        //           "Group Description":=PRTransCode."Group Description";
             end;
        
        
            Insert;
        //Update the prEmployee Transactions  with the Amount
        //fnUpdateEmployeeTrans( "Employee Code","Transaction Code",Amount,"Period Month","Period Year","Payroll Period");
        
        end;

    end;

    procedure fnGetSpecialTransAmount(strEmpCode: Code[20];intMonth: Integer;intYear: Integer;intSpecTransID: Option "None","Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan (Interest Varies)","Value of Quarters",Mortgage,VoluntaryCut,ClubMembership;blnCompDedc: Boolean) SpecialTransAmount: Decimal
    var
        prEmployeeTransactions: Record "prEmployee Transactions";
        prTransactionCodes: Record "prTransaction Codes";
        strExtractedFrml: Text[250];
        MortgageInterest: Decimal;
        MortgageRelief: Decimal;
        VoluntaryPayCut: Decimal;
        ClubMembership: Decimal;
    begin
        SpecialTransAmount:=0;
        prTransactionCodes.Reset;
        prTransactionCodes.SetRange(prTransactionCodes."Special Transactions",intSpecTransID);
        if prTransactionCodes.Find('-') then begin
        repeat
           prEmployeeTransactions.Reset;
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code",prTransactionCodes."Transaction Code");
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
           prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped,false); //Added DW to not process Stopped Transactions
           if prEmployeeTransactions.Find('-') then begin
        
            //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
            //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
              case intSpecTransID of
                intSpecTransID::"Defined Contribution":
                  if prTransactionCodes."Is Formula" then begin
                      strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                      SpecialTransAmount :=SpecialTransAmount+(fnFormulaResult(strExtractedFrml)); //Get the calculated amount for the Special Transaction
        
                  end else
                      SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;
        
                intSpecTransID::"Life Insurance":
                    SpecialTransAmount :=SpecialTransAmount+( (curReliefInsurance / 100) * prEmployeeTransactions.Amount);
                intSpecTransID::"Owner Occupier Interest":
                      SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;
        
                intSpecTransID::"Home Ownership Savings Plan":
                begin
                      SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;
                      if  SpecialTransAmount > 4000 then  SpecialTransAmount:=4000;
                end;
                //Voluntary
                    intSpecTransID::VoluntaryCut:
                  begin
                    VoluntaryPayCut:=prEmployeeTransactions.Amount;
                    SpecialTransAmount :=Round(VoluntaryPayCut,0.1,'<');
        
                  end;
                //Voluntary
                /*
                //Club Membership
                    intSpecTransID::ClubMembership:
                  BEGIN
                   ClubMembership:=prEmployeeTransactions.Amount;
                    SpecialTransAmount :=ROUND(ClubMembership,1,'<');
        
                  END;
                //Club Membership
                */
                intSpecTransID::Mortgage:
                  begin
                    //MortgageInterest:=0.01 * prEmployeeTransactions.Balance;
                    MortgageInterest:=prEmployeeTransactions.Amount;
        
                    if  MortgageInterest < curReliefMorgage then
                    begin
                     // MortgageRelief:=0.3 * MortgageInterest;
                       MortgageRelief:=prEmployeeTransactions.Amount;
                    end;
        
                    if  MortgageInterest > curReliefMorgage then
                    begin
                       MortgageRelief:=prEmployeeTransactions.Amount;
                        //MortgageRelief:=0.3 * curReliefMorgage;
                    end;
                    SpecialTransAmount :=Round(MortgageRelief,0.1,'<');
                end;
              end;
           end;
         until prTransactionCodes.Next=0;
        end;

    end;

    procedure fnGetEmployeePaye(curTaxablePay: Decimal) PAYE: Decimal
    var
        prPAYE: Record prPAYE;
        curTempAmount: Decimal;
        KeepCount: Integer;
    begin
        KeepCount:=0;
        prPAYE.Reset;
        if prPAYE.FindFirst then begin
        if curTaxablePay < prPAYE."PAYE Tier" then exit;
        repeat
         KeepCount+=1;
         curTempAmount:= curTaxablePay;
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

        until prPAYE.Next=0;
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
        if ((curBaseAmount>=prNHIF."Lower Limit") and (curBaseAmount<=prNHIF."Upper Limit")) then
            NHIF:=prNHIF.Amount;
        until prNHIF.Next=0;
        end;
    end;

    procedure fnPureFormula(strEmpCode: Code[20];intMonth: Integer;intYear: Integer;strFormula: Text[250]) Formula: Text[250]
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
           TransCode:='';
           for i:=1 to StrLen(strFormula) do begin
           Char:=CopyStr(strFormula,i,1);
           if Char='[' then  StartCopy:=true;

           if StartCopy then TransCode:=TransCode+Char;
           //Copy Characters as long as is not within []
           if not StartCopy then
              FinalFormula:=FinalFormula+Char;
           if Char=']' then begin
            StartCopy:=false;
            //Get Transcode
              Where := '=';
              Which := '[]';
              TransCode := DelChr(TransCode, Where, Which);
            //Get TransCodeAmount
            TransCodeAmount:=fnGetTransAmount(strEmpCode, TransCode, intMonth, intYear);
            //Reset Transcode
             TransCode:='';
            //Get Final Formula
             FinalFormula:=FinalFormula+Format(TransCodeAmount);
            //End Get Transcode
           end;
           end;
           Formula:=FinalFormula;
    end;

    procedure fnGetTransAmount(strEmpCode: Code[20];strTransCode: Code[20];intMonth: Integer;intYear: Integer) TransAmount: Decimal
    var
        prEmployeeTransactions: Record "prEmployee Transactions";
        prPeriodTransactions: Record "prPeriod Transactions";
    begin
        prEmployeeTransactions.Reset;
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code",strTransCode);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
        prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped,false); //Added DW to not process Stopped Transactions
        if prEmployeeTransactions.FindFirst then
          TransAmount:=prEmployeeTransactions.Amount;

        if TransAmount=0 then begin
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code",strEmpCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code",strTransCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Month",intMonth);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Year",intYear);
        if prPeriodTransactions.FindFirst then
          TransAmount:=prPeriodTransactions.Amount;
        end;
    end;

    procedure fnFormulaResult(strFormula: Text[250]) Results: Decimal
    var
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        CalcAddCurr: Boolean;
        AccSchedMgt: Codeunit AccSchedManagement;
    begin
        Results:=AccSchedMgt.EvaluateExpression(true,strFormula,AccSchedLine,ColumnLayout,CalcAddCurr);
    end;

    procedure fnClosePayrollPeriod(dtOpenPeriod: Date) Closed: Boolean
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
    begin
        //MESSAGE('Also include function to reset No. of days worked');
        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2DMY(dtNewPeriod,2);
        intNewYear := Date2DMY(dtNewPeriod,3);
        
        intMonth := Date2DMY(dtOpenPeriod,2);
        intYear := Date2DMY(dtOpenPeriod,3);
        
        prEmployeeTransactions.Reset;
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
        prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped,false); //Added DW to not process Stopped Transactions
        if prEmployeeTransactions.Find('-') then begin
          repeat
           prTransactionCodes.Reset;
           prTransactionCodes.SetRange(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
           if prTransactionCodes.Find('-') then begin
            with prTransactionCodes do begin
              case prTransactionCodes."Balance Type" of
                prTransactionCodes."Balance Type"::None:
                 begin
                  curTransAmount:= prEmployeeTransactions.Amount;
                  curTransBalance:= 0;
                 end;
                prTransactionCodes."Balance Type"::Increasing:
                 begin
                   curTransAmount := prEmployeeTransactions.Amount;
                   curTransBalance := prEmployeeTransactions.Balance + prEmployeeTransactions.Amount;
                   /*//****
                   //Added DW to Include Subledger and Subledger Account for the next period
                   IF prEmployeeTransactions.Subledger <> prEmployeeTransactions.Subledger::" " THEN
                   BEGIN
                      curTransSubledger:=prEmployeeTransactions.Subledger;
                      curTransSubledgerAccount:=prEmployeeTransactions."Subledger Account";
                   END;
                   //*****/
        
                 end;
                prTransactionCodes."Balance Type"::Reducing:
                 begin
                   curTransAmount := prEmployeeTransactions.Amount;
                   if prEmployeeTransactions.Balance < prEmployeeTransactions.Amount then begin
                       curTransAmount := prEmployeeTransactions.Balance;
                       curTransBalance := 0;
                   end else begin
                       curTransBalance := prEmployeeTransactions.Balance - prEmployeeTransactions.Amount;
                   end;
                   if curTransBalance < 0 then
                    begin
                       curTransAmount:=0;
                       curTransBalance:=0;
                    end;
                  end;
              end;
            end;
           end;
        
            //For those transactions with Start and End Date Specified
               if (prEmployeeTransactions."Start Date"<>0D) and (prEmployeeTransactions."End Date"<>0D) then begin
                   if prEmployeeTransactions."End Date"<dtNewPeriod then begin
                       curTransAmount:=0;
                       curTransBalance:=0;
                   end;
               end;
            //End Transactions with Start and End Date
        
          if (prTransactionCodes.Frequency=prTransactionCodes.Frequency::Fixed) and
             (prEmployeeTransactions."Stop for Next Period"=false) then //DENNO ADDED THIS TO CHECK FREQUENCY AND STOP IF MARKED
           begin
            if (curTransAmount <> 0) then  //Update the employee transaction table
             begin
             if ((prTransactionCodes."Balance Type"=prTransactionCodes."Balance Type"::Reducing) and (curTransBalance <> 0)) or
              (prTransactionCodes."Balance Type"<>prTransactionCodes."Balance Type"::Reducing) then
              prEmployeeTransactions.Balance:=curTransBalance;
              prEmployeeTransactions.Modify;
        
        
           //Insert record for the next period
            with prEmployeeTrans do begin
              Init;
              "Employee Code":= prEmployeeTransactions."Employee Code";
              "Transaction Code":= prEmployeeTransactions."Transaction Code";
              "Transaction Name":= prEmployeeTransactions."Transaction Name";
               Amount:= curTransAmount;
               Balance:= curTransBalance;
               "Amortized Loan Total Repay Amt":=prEmployeeTransactions. "Amortized Loan Total Repay Amt";
              "Original Amount":= prEmployeeTransactions."Original Amount";
               Membership:= prEmployeeTransactions.Membership;
              "Reference No":= prEmployeeTransactions."Reference No";
              "Period Month":= intNewMonth;
              "Period Year":= intNewYear;
              "Payroll Period":= dtNewPeriod;
               //****
               //"Exempt from Interest":=prEmployeeTransactions."Exempt from Interest";
              //"Loan Interest Rate":=prEmployeeTransactions."Loan Interest Rate";
              "Reference No":=prEmployeeTransactions."Reference No";
        
               /*IF curTransSubledger <> curTransSubledger::" " THEN
               BEGIN
                  Subledger:=curTransSubledger;
                  "Subledger Account":=curTransSubledgerAccount;
               END;
               //*****/
        
               Insert;
             end;
          end;
          end
          until prEmployeeTransactions.Next=0;
        end;
        
        //Update the Period as Closed
        prPayrollPeriods.Reset;
        prPayrollPeriods.SetRange(prPayrollPeriods."Period Month",intMonth);
        prPayrollPeriods.SetRange(prPayrollPeriods."Period Year",intYear);
        prPayrollPeriods.SetRange(prPayrollPeriods.Closed,false);
        if prPayrollPeriods.Find('-') then begin
           prPayrollPeriods.Closed:=true;
           prPayrollPeriods."Date Closed":=Today;
           prPayrollPeriods."Closed By":=UserId;
           prPayrollPeriods.Modify;
        end;
        
        //Enter a New Period
        with prNewPayrollPeriods do begin
          Init;
            "Period Month":=intNewMonth;
            "Period Year":= intNewYear;
            "Period Name":= Format(dtNewPeriod,0,'<Month Text>')+''+Format(intNewYear);
            "Date Opened":= dtNewPeriod;
            //opene:=USERID;
             Closed :=false;
            Insert;
        end;
        
        //Effect the transactions for the P9
        fnP9PeriodClosure (intMonth, intYear, dtOpenPeriod);
        
        //Take all the Negative pay (Net) for the current month & treat it as a deduction in the new period
        fnGetNegativePay(intMonth, intYear,dtOpenPeriod);
        
        
        /*
        //Reset no. of days worked for casuals
        PRSalCard.RESET;
        PRSalCard.SETRANGE(PRSalCard."Employee Contract Type",'CASUALS');
        IF PRSalCard.FIND('-') THEN
        BEGIN
            REPEAT
                PRSalCard."No. of Days Worked":=0;
                PRSalCard.MODIFY;
            UNTIL PRSalCard.NEXT = 0;
        END;
        */

    end;

    procedure fnGetNegativePay(intMonth: Integer;intYear: Integer;dtOpenPeriod: Date)
    var
        prPeriodTransactions: Record "prPeriod Transactions";
        prEmployeeTransactions: Record "prEmployee Transactions";
        intNewMonth: Integer;
        intNewYear: Integer;
        dtNewPeriod: Date;
    begin
        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2DMY(dtNewPeriod,2);
        intNewYear := Date2DMY(dtNewPeriod,3);

        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Month",intMonth);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Year",intYear);
        prPeriodTransactions.SetRange(prPeriodTransactions."Group Order",9);
        prPeriodTransactions.SetFilter(prPeriodTransactions.Amount,'<0');

        if prPeriodTransactions.Find('-') then begin
        repeat
          with  prEmployeeTransactions do begin
            Init;
            "Employee Code":= prPeriodTransactions."Employee Code";
            "Transaction Code":= 'NEGP';
            "Transaction Name":='Negative Pay';
            Amount:= prPeriodTransactions.Amount;
            Balance:= 0;
            "Original Amount":=0;
            "Period Month":= intNewMonth;
            "Period Year":= intNewYear;
            "Payroll Period":=dtNewPeriod;
            Insert;
          end;
        until prPeriodTransactions.Next=0;
        end;
    end;

    procedure fnP9PeriodClosure(intMonth: Integer;intYear: Integer;dtCurPeriod: Date)
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
        prEmployee: Record "HR-Employee";
    begin
        P9BasicPay := 0; P9Allowances := 0; P9Benefits := 0; P9ValueOfQuarters := 0;
        P9DefinedContribution := 0; P9OwnerOccupierInterest := 0;
        P9GrossPay := 0; P9TaxablePay := 0; P9TaxCharged := 0; P9InsuranceRelief := 0;
        P9TaxRelief := 0; P9Paye := 0; P9NSSF := 0; P9NHIF := 0;
        P9Deductions := 0; P9NetPay := 0;

        prEmployee.Reset;
        prEmployee.SetRange(prEmployee.Status,prEmployee.Status::Approved);
        //prEmployee.SETFILTER(prEmployee."Employee Contract Type",'<>%1','CASUALS'); //Remove
        if prEmployee.Find('-') then begin
        repeat

        P9BasicPay := 0; P9Allowances := 0; P9Benefits := 0; P9ValueOfQuarters := 0;
        P9DefinedContribution := 0; P9OwnerOccupierInterest := 0;
        P9GrossPay := 0; P9TaxablePay := 0; P9TaxCharged := 0; P9InsuranceRelief := 0;
        P9TaxRelief := 0; P9Paye := 0; P9NSSF := 0; P9NHIF := 0;
        P9Deductions := 0; P9NetPay := 0;

        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code",prEmployee."No.");
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Month",intMonth);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Year",intYear);
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
          until prPeriodTransactions.Next=0;
        end;
        //Update the P9 Details
        if P9NetPay <> 0 then
         fnUpdateP9Table (prEmployee."No.", P9BasicPay, P9Allowances, P9Benefits, P9ValueOfQuarters, P9DefinedContribution,
             P9OwnerOccupierInterest, P9GrossPay, P9TaxablePay, P9TaxCharged, P9InsuranceRelief, P9TaxRelief, P9Paye, P9NSSF,
             P9NHIF, P9Deductions, P9NetPay, dtCurPeriod);

        until prEmployee.Next=0;
        end;
    end;

    procedure fnUpdateP9Table(P9EmployeeCode: Code[20];P9BasicPay: Decimal;P9Allowances: Decimal;P9Benefits: Decimal;P9ValueOfQuarters: Decimal;P9DefinedContribution: Decimal;P9OwnerOccupierInterest: Decimal;P9GrossPay: Decimal;P9TaxablePay: Decimal;P9TaxCharged: Decimal;P9InsuranceRelief: Decimal;P9TaxRelief: Decimal;P9Paye: Decimal;P9NSSF: Decimal;P9NHIF: Decimal;P9Deductions: Decimal;P9NetPay: Decimal;dtCurrPeriod: Date)
    var
        prEmployeeP9Info: Record "prEmployee P9 Info";
        intYear: Integer;
        intMonth: Integer;
    begin
        intMonth := Date2DMY(dtCurrPeriod,2);
        intYear := Date2DMY(dtCurrPeriod,3);

        prEmployeeP9Info.Reset;
        with prEmployeeP9Info do begin
            Init;
            "Employee Code":= P9EmployeeCode;
            "Basic Pay":= P9BasicPay;
            Allowances:= P9Allowances;
            Benefits:= P9Benefits;
            "Value Of Quarters":= P9ValueOfQuarters;
            "Defined Contribution":= P9DefinedContribution;
            "Owner Occupier Interest":= P9OwnerOccupierInterest;
            "Gross Pay":= P9GrossPay;
            "Taxable Pay":= P9TaxablePay;
            "Tax Charged":= P9TaxCharged;
            "Insurance Relief":= P9InsuranceRelief;
            "Tax Relief":= P9TaxRelief;
            PAYE:= P9Paye;
            NSSF:= P9NSSF;
            NHIF:= P9NHIF;
            Deductions:= P9Deductions;
            "Net Pay":= P9NetPay;
            "Period Month":= intMonth;
            "Period Year":= intYear;
            "Payroll Period":= dtCurrPeriod;
            Insert;
        end;
    end;

    procedure fnDaysWorked(dtDate: Date;IsTermination: Boolean) DaysWorked: Integer
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;
    begin
        TodayDate:=dtDate;

         Day:=Date2DMY(TodayDate,1);
         Expr1:=Format(-Day)+'D+1D';
         FirstDay:=CalcDate(Expr1,TodayDate);
         LastDate:=CalcDate('1M-1D',FirstDay);

         SysDate.Reset;
         SysDate.SetRange(SysDate."Period Type",SysDate."Period Type"::Date);
         if not IsTermination then
          SysDate.SetRange(SysDate."Period Start",dtDate,LastDate)
         else
          SysDate.SetRange(SysDate."Period Start",FirstDay,dtDate);
         SysDate.SetFilter(SysDate."Period No.",'1..7');
         if SysDate.Find('-') then
            DaysWorked:=SysDate.Count;
    end;

    procedure fnSalaryArrears(EmpCode: Text[30];TransCode: Text[30];CBasic: Decimal;StartDate: Date;EndDate: Date;dtOpenPeriod: Date;dtDOE: Date;dtTermination: Date)
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
        FirstMonth := true;
        if EndDate>StartDate then
         begin
          while StartDate < EndDate do
           begin
            //fnGetEmpP9Info
              startmonth:=Date2DMY(StartDate,2);
              startYear:=Date2DMY(StartDate,3);

              "prEmployee P9 Info".Reset;
              "prEmployee P9 Info".SetRange("prEmployee P9 Info"."Employee Code",EmpCode);
              "prEmployee P9 Info".SetRange("prEmployee P9 Info"."Period Month",startmonth);
              "prEmployee P9 Info".SetRange("prEmployee P9 Info"."Period Year",startYear);
              if "prEmployee P9 Info".Find('-') then
               begin
                P9BasicPay:="prEmployee P9 Info"."Basic Pay";
                P9taxablePay:="prEmployee P9 Info"."Taxable Pay";
                P9PAYE:="prEmployee P9 Info".PAYE;

                if P9BasicPay > 0 then   //Staff payment history is available
                 begin
                  if FirstMonth then
                   begin                 //This is the first month in the arrears loop
                    if Date2DMY(StartDate,1) <> 1 then //if the date doesn't start on 1st, we have to prorate the salary
                     begin
                    //ProratedBasic := ProratePay.fnProratePay(P9BasicPay, CBasic, StartDate); ********
                  //Get the Basic Salary (prorate basic pay if needed) //Termination Remaining
                  if (Date2DMY(dtDOE,2)=Date2DMY(StartDate,2)) and (Date2DMY(dtDOE,3)=Date2DMY(StartDate,3))then begin
                      CountDaysofMonth:=fnDaysInMonth(dtDOE);
                      DaysWorked:=fnDaysWorked(dtDOE,false);
                      ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay,DaysWorked,CountDaysofMonth)
                  end;

                  //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
                  if dtTermination<>0D then begin
                  if (Date2DMY(dtTermination,2)=Date2DMY(StartDate,2)) and (Date2DMY(dtTermination,3)=Date2DMY(StartDate,3))then begin
                      CountDaysofMonth:=fnDaysInMonth(dtTermination);
                      DaysWorked:=fnDaysWorked(dtTermination,true);
                      ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay,DaysWorked,CountDaysofMonth)
                  end;
                end;

                         SalaryArrears := (CBasic - ProratedBasic)
                     end
                   else
                     begin
                        SalaryArrears := (CBasic - P9BasicPay);
                     end;
                 end;
                 SalaryVariance := SalaryVariance + SalaryArrears;
                 SupposedTaxablePay := P9taxablePay + SalaryArrears;

                 //To calc paye arrears, check if the Supposed Taxable Pay is > the taxable pay for the loop period
                 if SupposedTaxablePay > P9taxablePay then
                  begin
                       SupposedTaxCharged := fnGetEmployeePaye(SupposedTaxablePay);
                       SupposedPAYE := SupposedTaxCharged - curReliefPersonal;
                       PAYEVariance := SupposedPAYE - P9PAYE;
                       PAYEArrears := PAYEArrears + PAYEVariance ;
                  end;
                 FirstMonth := false;               //reset the FirstMonth Boolean to False
               end;
             end;
              StartDate :=CalcDate('+1M',StartDate);
           end;
         if SalaryArrears <> 0 then
           begin
           PeriodYear:=Date2DMY(dtOpenPeriod,3);
           PeriodMonth:=Date2DMY(dtOpenPeriod,2);
            fnUpdateSalaryArrears(EmpCode,TransCode,StartDate,EndDate,SalaryArrears, PAYEArrears,PeriodMonth,PeriodYear,
            dtOpenPeriod);
           end

         end
        else
         Error('The start date must be earlier than the end date');
    end;

    procedure fnUpdateSalaryArrears(EmployeeCode: Text[50];TransCode: Text[50];OrigStartDate: Date;EndDate: Date;SalaryArrears: Decimal;PayeArrears: Decimal;intMonth: Integer;intYear: Integer;payperiod: Date)
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
         "prSalary Arrears".SetRange("prSalary Arrears"."Employee Code");
         "prSalary Arrears".SetRange("prSalary Arrears"."Transaction Code",TransCode);
         "prSalary Arrears".SetRange("prSalary Arrears"."Period Month",intMonth);
         "prSalary Arrears".SetRange("prSalary Arrears"."Period Year",intYear);
         if "prSalary Arrears".Find('-')=false then
         begin
            "prSalary Arrears"."Employee Code" := EmployeeCode;
            "prSalary Arrears"."Transaction Code" := TransCode;
            "prSalary Arrears"."Start Date" := OrigStartDate;
            "prSalary Arrears"."End Date" := EndDate;
            "prSalary Arrears"."Salary Arrears" := SalaryArrears;
            "prSalary Arrears"."PAYE Arrears" := PayeArrears;
            "prSalary Arrears"."Period Month" := intMonth;
            "prSalary Arrears"."Period Year" := intYear;
            "prSalary Arrears"."Payroll Period" := payperiod;
            "prSalary Arrears".Modify;
         end
    end;

    procedure fnCalcLoanInterest(strEmpCode: Code[20];strTransCode: Code[20];InterestRate: Decimal;RecoveryMethod: Option Reducing,"Straight line",Amortized;LoanAmount: Decimal;Balance: Decimal;CurrPeriod: Date) LnInterest: Decimal
    var
        curLoanInt: Decimal;
        intMonth: Integer;
        intYear: Integer;
    begin
        intMonth := Date2DMY(CurrPeriod,2);
        intYear := Date2DMY(CurrPeriod,3);

        curLoanInt := 0;
        if InterestRate > 0 then begin
            if RecoveryMethod = RecoveryMethod::"Straight line" then //Straight Line Method [1]
                 curLoanInt := (InterestRate / 1200) * LoanAmount;

            if RecoveryMethod = RecoveryMethod::Reducing then //Reducing Balance [0]

                 curLoanInt := (InterestRate / 100) * Balance;

            if RecoveryMethod = RecoveryMethod::Amortized then //Amortized [2]
                 curLoanInt := (InterestRate / 100) * Balance;

        end else
            curLoanInt := 0;

        //Return the Amount
        LnInterest:=Round(curLoanInt,1);
    end;

    procedure fnUpdateEmployerDeductions(EmpCode: Code[20];TCode: Code[20];TGroup: Code[20];GroupOrder: Integer;SubGroupOrder: Integer;Description: Text[50];curAmount: Decimal;curBalance: Decimal;Month: Integer;Year: Integer;mMembership: Text[30];ReferenceNo: Text[30];dtOpenPeriod: Date)
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
             //Insert Dim and Contract Type for each Trans Being Updated
             HREmp2.Reset;
             if HREmp2.Get(EmpCode) then
             begin
                 "Global Dimension 1 Code":=HREmp2."Dimension 1 Code";
                 "Global Dimension 2 Code":=HREmp."Dimension 2 Code";
                 //"Contract Type":=HREmp2."Employment Type";

             end;
             //Insert Transaction Type (Either "Income or Deduction") for each Trans Being Updated
            Insert;
        end;
    end;

    procedure fnDisplayFrmlValues(EmpCode: Code[30];intMonth: Integer;intYear: Integer;Formula: Text[50]) curTransAmount: Decimal
    var
        pureformula: Text[50];
    begin
           pureformula := fnPureFormula(EmpCode, intMonth, intYear, Formula);
           curTransAmount := fnFormulaResult(pureformula); //Get the calculated amount
            curTransAmount :=Round(curTransAmount,0.01,'>');
    end;

    procedure fnUpdateEmployeeTrans(EmpCode: Code[20];TransCode: Code[20];Amount: Decimal;Month: Integer;Year: Integer;PayrollPeriod: Date)
    var
        prEmployeeTrans: Record "prEmployee Transactions";
    begin
           prEmployeeTrans.Reset;
           prEmployeeTrans.SetRange(prEmployeeTrans."Employee Code",EmpCode);
           prEmployeeTrans.SetRange(prEmployeeTrans."Transaction Code",TransCode);
           prEmployeeTrans.SetRange(prEmployeeTrans."Payroll Period",PayrollPeriod);
           prEmployeeTrans.SetRange(prEmployeeTrans."Period Month",Month);
           prEmployeeTrans.SetRange(prEmployeeTrans."Period Year",Year);
           if prEmployeeTrans.Find('-') then begin
             prEmployeeTrans.Amount:=Amount;
             prEmployeeTrans.Modify;
           end;
    end;

    procedure fnGetOpenPeriod() dtOpenPeriod: Date
    var
        "prPayroll Periods": Record "prPayroll Periods";
        intMonth: Integer;
        intYear: Integer;
    begin
        "prPayroll Periods".Reset;
        "prPayroll Periods".SetRange("prPayroll Periods".Closed,false);

        if "prPayroll Periods".Find('-') then
         begin
          dtOpenPeriod:="prPayroll Periods"."Date Opened";
          intMonth := Date2DMY(dtOpenPeriod,2); //GET THE MONTH
          intYear  := Date2DMY(dtOpenPeriod,3);  //GET THE YEAR
         end
        else
         begin
          Error('There is no open payroll period');
         end
    end;

    procedure fnGetJournalDet(strEmpCode: Code[20])
    var
        SalaryCard: Record "prSalary Card";
        HREmp: Record "HR-Employee";
    begin
        //Get Payroll Posting Accounts
        //IF SalaryCard.GET(strEmpCode) THEN BEGIN
        if HREmp.Get(strEmpCode) then begin
        if PostingGroup.Get(HREmp."Posting Group") then
         begin
           if HREmp."Posting Group" = 'PAYROLL' then
           begin
               //Comment This for the Time Being
               PostingGroup.TestField("Salary Account");
               PostingGroup.TestField("Income Tax Account");
               PostingGroup.TestField("Net Salary Payable");
               PostingGroup.TestField("SSF Employer Account");
               PostingGroup.TestField("Pension Employer Acc");

              TaxAccount:=PostingGroup."Income Tax Account";
              salariesAcc:=PostingGroup."Salary Account";
              PayablesAcc:=PostingGroup."Net Salary Payable";
              NSSFEMPyer:= PostingGroup."SSF Employer Account";
              NSSFEMPyee:= PostingGroup."SSF Employee Account";
              NHIFEMPyee:=PostingGroup."NHIF Employee Account";
              PensionEMPyer:=PostingGroup."Pension Employer Acc";
          end;
         end;
        end;
        //End Get Payroll Posting Accounts
    end;

    procedure fnGetEmployeeNSSF(curBaseAmount: Decimal) NSSF: Decimal
    var
        prNSSF: Record "PR NSSF";
    begin

        prNSSF.Reset;
        prNSSF.SetCurrentKey(prNSSF.Tier);
        if prNSSF.FindFirst then begin
        repeat
        if ((curBaseAmount>=prNSSF."Lower Limit") and (curBaseAmount<=prNSSF."Upper Limit")) then
            NSSF:=prNSSF."Tier 1 Employee Deduction" + prNSSF."Tier 2 Employee Deduction";
        until prNSSF.Next=0;
        end;
    end;

    procedure fnGetEmployerNSSF(curBaseAmount: Decimal) NSSF: Decimal
    var
        prNSSF: Record "PR NSSF";
    begin

        prNSSF.Reset;
        prNSSF.SetCurrentKey(prNSSF.Tier);
        if prNSSF.FindFirst then begin
        repeat
        if ((curBaseAmount>=prNSSF."Lower Limit") and (curBaseAmount<=prNSSF."Upper Limit")) then
            NSSF:=prNSSF."Tier 1 Employer Contribution" + prNSSF."Tier 2 Employer Contribution";
        until prNSSF.Next=0;
        end;
    end;

    local procedure GetLastEntryNo() LastLineNum: Integer
    var
        HRBankSummary_2: Record "HR Bank Summary";
    begin
        HRBankSummary_2.Reset;
        if HRBankSummary_2.Find('+') then
        begin
            LastLineNum:=HRBankSummary_2."Line No."+1;
        end else
        begin
            LastLineNum:=1000;
        end;
    end;

    procedure GeneratePeriodMatrixData(SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;MaximumSetLength: Integer;UseNameForCaption: Boolean;PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";DateFilter: Text[30];var PKFirstRecInCurrSet: Text[100];var CaptionSet: array [32] of Text[200];var CaptionRange: Text[100];var CurrSetLength: Integer;var PeriodRecords: array [32] of Record Date temporary)
    var
        Steps: Integer;
        Calendar: Record Date;
        PeriodFormMgt: Codeunit PeriodFormManagement;
    begin
        Clear(CaptionSet);
        CaptionRange := '';
        CurrSetLength := 0;
        Clear(PeriodRecords);
        Clear(Calendar);
        Clear(PeriodFormMgt);

        Calendar.SetFilter("Period Start",DateFilter);
        if not FindDate('-',Calendar,PeriodType,false) then begin
          PKFirstRecInCurrSet := '';
          Error(Text003);
        end;

        case SetWanted of
          SetWanted::Initial:
            begin
              if (PeriodType = PeriodType::"Accounting Period") or (DateFilter <> '') then begin
                FindDate('-',Calendar,PeriodType,true);
              end else
                Calendar."Period Start" := 0D;
              FindDate('=><',Calendar,PeriodType,true);
            end;
          SetWanted::Previous:
            begin
              Calendar.SetPosition(PKFirstRecInCurrSet);
              FindDate('=',Calendar,PeriodType,true);
              Steps := PeriodFormMgt.NextDate(-MaximumSetLength,Calendar,PeriodType);
              if not (Steps in [-MaximumSetLength,0]) then
                Error(Text001);
            end;
          SetWanted::PreviousColumn:
            begin
              Calendar.SetPosition(PKFirstRecInCurrSet);
              FindDate('=',Calendar,PeriodType,true);
              Steps := PeriodFormMgt.NextDate(-1,Calendar,PeriodType);
              if not (Steps in [-1,0]) then
                Error(Text001);
            end;
          SetWanted::NextColumn:
            begin
              Calendar.SetPosition(PKFirstRecInCurrSet);
              FindDate('=',Calendar,PeriodType,true);
              if not (PeriodFormMgt.NextDate(1,Calendar,PeriodType) = 1) then begin
                Calendar.SetPosition(PKFirstRecInCurrSet);
                FindDate('=',Calendar,PeriodType,true);
              end;
            end;
          SetWanted::Same:
            begin
              Calendar.SetPosition(PKFirstRecInCurrSet);
              FindDate('=',Calendar,PeriodType,true)
            end;
          SetWanted::Next:
            begin
              Calendar.SetPosition(PKFirstRecInCurrSet);
              FindDate('=',Calendar,PeriodType,true);
              if not (PeriodFormMgt.NextDate(MaximumSetLength,Calendar,PeriodType) = MaximumSetLength) then begin
                Calendar.SetPosition(PKFirstRecInCurrSet);
                FindDate('=',Calendar,PeriodType,true);
              end;
            end;
        end;

        PKFirstRecInCurrSet := Calendar.GetPosition;

        repeat
          CurrSetLength := CurrSetLength + 1;
          if UseNameForCaption then
            CaptionSet[CurrSetLength] := Format(Calendar."Period Name")
          else
            CaptionSet[CurrSetLength] := PeriodFormMgt.CreatePeriodFormat(PeriodType,Calendar."Period Start");
          PeriodRecords[CurrSetLength].Copy(Calendar);
        until (CurrSetLength = MaximumSetLength) or (PeriodFormMgt.NextDate(1,Calendar,PeriodType) <> 1);

        if CurrSetLength = 1 then
          CaptionRange := CaptionSet[1]
        else
          CaptionRange := CaptionSet[1] + '..' + CaptionSet[CurrSetLength];
    end;

    local procedure FindDate(SearchString: Text[3];var Calendar: Record Date;PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";ErrorWhenNotFound: Boolean): Boolean
    var
        Found: Boolean;
        PeriodFormMgt: Codeunit PeriodFormManagement;
    begin
        Clear(PeriodFormMgt);
        Found := PeriodFormMgt.FindDate(SearchString,Calendar,PeriodType);
        if ErrorWhenNotFound and not Found then
          Error(Text002);
        exit(Found);
    end;

    procedure SetPeriodColumnSet(DateFilter: Text[1024];PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";Direction: Option Backward,Forward;var FirstColumn: Date;var LastColumn: Date;NoOfColumns: Integer)
    var
        Period: Record Date;
        PeriodFormMgt: Codeunit PeriodFormManagement;
        Steps: Integer;
        TmpFirstColumn: Date;
        TmpLastColumn: Date;
    begin
        Period.SetRange("Period Type",PeriodType);
        if DateFilter = '' then begin
          Period."Period Start" := WorkDate;
          if PeriodFormMgt.FindDate('<=',Period,PeriodType) then
            Steps := 1;
          PeriodFormMgt.NextDate(Steps,Period,PeriodType);
          DateFilter := '>=' + Format(Period."Period Start");
        end else begin
          Period.SetFilter("Period Start",DateFilter);
          Period.Find('-');
        end;

        if (Format(FirstColumn) = '') and (Format(LastColumn) = '') then begin
          FirstColumn := Period."Period Start";
          Period.Next(NoOfColumns - 1);
          LastColumn := Period."Period Start";
          exit;
        end;

        if Direction = Direction::Forward then begin
          Period.SetFilter("Period Start",DateFilter);
          if Period.Get(PeriodType,LastColumn) then
            Period.Next;
          TmpFirstColumn := Period."Period Start";
          Period.Next(NoOfColumns - 1);
          TmpLastColumn := Period."Period Start";
          if TmpFirstColumn <> LastColumn then begin
            FirstColumn := TmpFirstColumn;
            LastColumn := TmpLastColumn;
          end;
          exit;
        end;

        if Direction = Direction::Backward then begin
          if Period.Get(PeriodType,FirstColumn) then
            Period.Next(-1);
          TmpLastColumn := Period."Period Start";
          Period.Next(-NoOfColumns + 1);
          TmpFirstColumn := Period."Period Start";
          if TmpLastColumn <> FirstColumn then begin
            FirstColumn := TmpFirstColumn;
            LastColumn := TmpLastColumn;
          end;
        end;
    end;

    procedure SetDimColumnSet(DimensionCode: Code[20];DimFilter: Text[1024];SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;var PKFirstRecInCurrSet: Text[1024];var FirstColumn: Text[1024];var LastColumn: Text[1024];NoOfColumns: Integer)
    var
        DimVal: Record "Dimension Value";
        TmpFirstColumn: Text[1024];
        TmpLastColumn: Text[1024];
        TmpSteps: Integer;
    begin
        DimVal.SetRange("Dimension Code",DimensionCode);
        if DimFilter <> '' then
          DimVal.SetFilter(Code,DimFilter);

        case SetWanted of
          SetWanted::Initial:
            begin
              if DimVal.Find('-') then begin
                PKFirstRecInCurrSet := DimVal.GetPosition;
                FirstColumn := DimVal.Code;
                TmpSteps := DimVal.Next(NoOfColumns - 1);
                LastColumn := DimVal.Code;
              end;
            end;
          SetWanted::Same:
            begin
              if PKFirstRecInCurrSet <> '' then begin
                DimVal.SetPosition(PKFirstRecInCurrSet);
                DimVal.Find('=');
                FirstColumn := DimVal.Code;
                TmpSteps := DimVal.Next(NoOfColumns - 1);
                LastColumn := DimVal.Code;
              end;
            end;
          SetWanted::Next:
            begin
              if PKFirstRecInCurrSet <> '' then begin
                DimVal.SetPosition(PKFirstRecInCurrSet);
                DimVal.Find('=');
                if DimVal.Next(NoOfColumns) <> 0 then begin
                  PKFirstRecInCurrSet := DimVal.GetPosition;
                  TmpFirstColumn := DimVal.Code;
                  TmpSteps := DimVal.Next(NoOfColumns - 1);
                  TmpLastColumn := DimVal.Code;
                  if TmpFirstColumn <> LastColumn then begin
                    FirstColumn := TmpFirstColumn;
                    LastColumn := TmpLastColumn;
                  end;
                end else
                  SetDimColumnSet(DimensionCode,DimFilter,SetWanted::Same,PKFirstRecInCurrSet,FirstColumn,LastColumn,NoOfColumns);
              end;
            end;
          SetWanted::Previous:
            begin
              if PKFirstRecInCurrSet <> '' then begin
                DimVal.SetPosition(PKFirstRecInCurrSet);
                DimVal.Find('=');
                if DimVal.Next(-1) <> 0 then begin
                  TmpLastColumn := DimVal.Code;
                  TmpSteps := DimVal.Next(-NoOfColumns + 1);
                  PKFirstRecInCurrSet := DimVal.GetPosition;
                  TmpFirstColumn := DimVal.Code;
                  if TmpLastColumn <> FirstColumn then begin
                    FirstColumn := TmpFirstColumn;
                    LastColumn := TmpLastColumn;
                  end;
                end else
                  SetDimColumnSet(DimensionCode,DimFilter,SetWanted::Same,PKFirstRecInCurrSet,FirstColumn,LastColumn,NoOfColumns);
              end;
            end;
          SetWanted::NextColumn:
            begin
              if PKFirstRecInCurrSet <> '' then begin
                DimVal.SetPosition(PKFirstRecInCurrSet);
                DimVal.Find('=');
                if DimVal.Next <> 0 then begin
                  PKFirstRecInCurrSet := DimVal.GetPosition;
                  TmpFirstColumn := DimVal.Code;
                  TmpSteps := DimVal.Next(NoOfColumns - 1);
                  TmpLastColumn := DimVal.Code;
                  if TmpFirstColumn <> LastColumn then begin
                    FirstColumn := TmpFirstColumn;
                    LastColumn := TmpLastColumn;
                  end;
                end else
                  SetDimColumnSet(DimensionCode,DimFilter,SetWanted::Same,PKFirstRecInCurrSet,FirstColumn,LastColumn,NoOfColumns);
              end;
            end;
          SetWanted::PreviousColumn:
            begin
              if PKFirstRecInCurrSet <> '' then begin
                DimVal.SetPosition(PKFirstRecInCurrSet);
                DimVal.Find('=');
                if DimVal.Next(-1) <> 0 then begin
                  PKFirstRecInCurrSet := DimVal.GetPosition;
                  TmpFirstColumn := DimVal.Code;
                  TmpSteps := DimVal.Next(NoOfColumns - 1);
                  TmpLastColumn := DimVal.Code;
                  if TmpLastColumn <> FirstColumn then begin
                    FirstColumn := TmpFirstColumn;
                    LastColumn := TmpLastColumn;
                  end;
                end else
                  SetDimColumnSet(DimensionCode,DimFilter,SetWanted::Same,PKFirstRecInCurrSet,FirstColumn,LastColumn,NoOfColumns);
              end;
            end;
        end;

        if Abs(TmpSteps) <> NoOfColumns then
          NoOfColumns := Abs(TmpSteps);
    end;

    procedure DimToCaptions(var CaptionSet: array [32] of Text[1024];var MatrixRecords: array [32] of Record "Dimension Code Buffer";DimensionCode: Text[30];FirstColumn: Text[1024];LastColumn: Text[1024];var NumberOfColumns: Integer;ShowColumnName: Boolean;var CaptionRange: Text[1024];CopyTotaling: Boolean)
    var
        DimensionValue: Record "Dimension Value";
        i: Integer;
    begin
        DimensionValue.SetRange("Dimension Code",DimensionCode);
        DimensionValue.SetRange(Code,FirstColumn,LastColumn);
        i := 0;
        if DimensionValue.FindSet then
          repeat
            i := i + 1;
            MatrixRecords[i].Code := DimensionValue.Code;
            MatrixRecords[i].Name := DimensionValue.Name;
            if CopyTotaling then
              MatrixRecords[i].Totaling := DimensionValue.Totaling;
            if ShowColumnName then
              CaptionSet[i] := DimensionValue.Name
            else
              CaptionSet[i] := DimensionValue.Code
          until (i = ArrayLen(CaptionSet)) or (DimensionValue.Next = 0);

        NumberOfColumns := i;

        if NumberOfColumns = 1 then
          CaptionRange := CaptionSet[1]
        else
          CaptionRange := CaptionSet[1] + '..' + CaptionSet[NumberOfColumns];
    end;

    procedure FillPeriodColumns(PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";var MatrixColumnCaptions: array [32] of Text[1024];var MatrixRecords: array [32] of Record Date;FirstColumn: Date;LastColumn: Date;ShowColumnName: Boolean)
    var
        Period: Record Date;
        PeriodFormMgt: Codeunit PeriodFormManagement;
        i: Integer;
    begin
        Period.SetRange("Period Start",FirstColumn,LastColumn);
        Period.SetRange("Period Type",PeriodType);
        i := 1;
        if Period.Find('-') then
          repeat
            if ShowColumnName then
              MatrixColumnCaptions[i] := Format(Period."Period Name")
            else
              MatrixColumnCaptions[i] := PeriodFormMgt.CreatePeriodFormat(PeriodType,Period."Period Start");

            MatrixRecords[i].Copy(Period);
            i := i + 1;
          until (Period.Next = 0) or (i = ArrayLen(MatrixColumnCaptions));
    end;

    procedure CreateCaptionSet(var RecRef: RecordRef;SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;MaximumNoOfCaptions: Integer;CaptionFieldNo: Integer;var PrimaryKeyFirstCaptionInCurrSe: Text[1024];var CaptionSet: array [32] of Text[1024];var CaptionRange: Text[1024]): Integer
    var
        CurrentCaptionOrdinal: Integer;
    begin
        Clear(CaptionSet);
        CaptionRange := '';

        CurrentCaptionOrdinal := 0;

        case SetWanted of
          SetWanted::Initial:
            RecRef.Find('=><')
            ;
          SetWanted::Previous:
            begin
              RecRef.SetPosition(PrimaryKeyFirstCaptionInCurrSe);
              RecRef.Find('=');
              RecRef.Next(-MaximumNoOfCaptions);
            end;
          SetWanted::Same:
            begin
              RecRef.SetPosition(PrimaryKeyFirstCaptionInCurrSe);
              RecRef.Find('=');
            end;
          SetWanted::Next:
            begin
              RecRef.SetPosition(PrimaryKeyFirstCaptionInCurrSe);
              RecRef.Find('=');
              if not (RecRef.Next(MaximumNoOfCaptions) = MaximumNoOfCaptions) then begin
                RecRef.SetPosition(PrimaryKeyFirstCaptionInCurrSe);
                RecRef.Find('=')
              end;
            end;
          SetWanted::PreviousColumn:
            begin
              RecRef.SetPosition(PrimaryKeyFirstCaptionInCurrSe);
              RecRef.Find('=');
              RecRef.Next(-1);
            end;
          SetWanted::NextColumn:
            begin
              RecRef.SetPosition(PrimaryKeyFirstCaptionInCurrSe);
              RecRef.Find('=');
              if not (RecRef.Next = 1) then begin
                RecRef.SetPosition(PrimaryKeyFirstCaptionInCurrSe);
                RecRef.Find('=')
              end;
            end;
        end;

        PrimaryKeyFirstCaptionInCurrSe := RecRef.GetPosition;

        repeat
          CurrentCaptionOrdinal := CurrentCaptionOrdinal + 1;
          CaptionSet[CurrentCaptionOrdinal] := Format(RecRef.Field(CaptionFieldNo).Value);
        until (CurrentCaptionOrdinal = MaximumNoOfCaptions) or (RecRef.Next <> 1);

        if CurrentCaptionOrdinal = 1 then
          CaptionRange := CaptionSet[1]
        else
          CaptionRange := CaptionSet[1] + '..' + CaptionSet[CurrentCaptionOrdinal];
    end;

    procedure GenerateMatrixData(var RecRef: RecordRef;SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;MaximumSetLength: Integer;CaptionFieldNo: Integer;var PKFirstRecInCurrSet: Text[1024];var CaptionSet: array [32] of Text[1024];var CaptionRange: Text[1024];var CurrSetLength: Integer)
    var
        Steps: Integer;
    begin
        Clear(CaptionSet);
        CaptionRange := '';
        CurrSetLength := 0;

        if RecRef.IsEmpty then begin
          PKFirstRecInCurrSet := '';
          exit;
        end;

        case SetWanted of
          SetWanted::Initial:
            RecRef.FindFirst;
          SetWanted::Previous:
            begin
              RecRef.SetPosition(PKFirstRecInCurrSet);
              RecRef.Get(RecRef.RecordId);
              Steps := RecRef.Next(-MaximumSetLength);
              if not (Steps in [-MaximumSetLength,0]) then
                Error(Text001);
            end;
          SetWanted::Same:
            begin
              RecRef.SetPosition(PKFirstRecInCurrSet);
              RecRef.Get(RecRef.RecordId);
            end;
          SetWanted::Next:
            begin
              RecRef.SetPosition(PKFirstRecInCurrSet);
              RecRef.Get(RecRef.RecordId);
              if not (RecRef.Next(MaximumSetLength) = MaximumSetLength) then begin
                RecRef.SetPosition(PKFirstRecInCurrSet);
                RecRef.Get(RecRef.RecordId);
              end;
            end;
          SetWanted::PreviousColumn:
            begin
              RecRef.SetPosition(PKFirstRecInCurrSet);
              RecRef.Get(RecRef.RecordId);
              Steps := RecRef.Next(-1);
              if not (Steps in [-1,0]) then
                Error(Text001);
            end;
          SetWanted::NextColumn:
            begin
              RecRef.SetPosition(PKFirstRecInCurrSet);
              RecRef.Get(RecRef.RecordId);
              if not (RecRef.Next(1) = 1) then begin
                RecRef.SetPosition(PKFirstRecInCurrSet);
                RecRef.Get(RecRef.RecordId);
              end;
            end;
        end;

        PKFirstRecInCurrSet := RecRef.GetPosition;

        repeat
          CurrSetLength := CurrSetLength + 1;
          CaptionSet[CurrSetLength] := Format(RecRef.Field(CaptionFieldNo).Value);
        until (CurrSetLength = MaximumSetLength) or (RecRef.Next <> 1);

        if CurrSetLength = 1 then
          CaptionRange := CaptionSet[1]
        else
          CaptionRange := CaptionSet[1] + '..' + CaptionSet[CurrSetLength];
    end;

    procedure CreateTextAmount(Amount: Text[1024];DecimalPoint: Option Period,Comma) TextAmount: Text[1024]
    var
        FormattedAmount: Text[1024];
        Position: Integer;
        Decimals: Code[10];
    begin
        if DecimalPoint = DecimalPoint::Comma then begin
          Position := 0;
          FormattedAmount := Amount;
          Position := StrPos(FormattedAmount,',');
          if Position > 0 then begin
            Decimals := CopyStr(FormattedAmount,Position,StrLen(FormattedAmount));
            if StrLen(Decimals) > 3 then
              TextAmount := CopyStr(FormattedAmount,1,Position - 1) + CopyStr(Decimals,1,3);
            if StrLen(Decimals) <= 3 then
              TextAmount := CopyStr(FormattedAmount,1,Position - 1) + Decimals;
            if StrLen(Decimals) <= 2 then
              TextAmount := CopyStr(FormattedAmount,1,Position - 1) + Decimals + '0';
            if StrLen(Decimals) <= 1 then
              TextAmount := CopyStr(FormattedAmount,1,Position - 1) + '00';
          end else
            TextAmount := FormattedAmount + ',00';
        end else begin
          Position := 0;
          FormattedAmount := Amount;
          Position := StrPos(FormattedAmount,'.');
          if Position > 0 then begin
            Decimals := CopyStr(FormattedAmount,Position,StrLen(FormattedAmount));
            if StrLen(Decimals) > 3 then
              TextAmount := CopyStr(FormattedAmount,1,Position - 1) + CopyStr(Decimals,1,3);
            if StrLen(Decimals) <= 3 then
              TextAmount := CopyStr(FormattedAmount,1,Position - 1) + Decimals;
            if StrLen(Decimals) <= 2 then
              TextAmount := CopyStr(FormattedAmount,1,Position - 1) + Decimals + '0';
            if StrLen(Decimals) <= 1 then
              TextAmount := CopyStr(FormattedAmount,1,Position - 1) + '00';
          end else
            TextAmount := FormattedAmount + '.00';
        end;
    end;

    procedure SetIndentation(var TextString: Text[1024];Indentation: Integer)
    var
        Substr: Text[1024];
    begin
        Substr := PadStr(Substr,Indentation * 2,' ');
        TextString := Substr + TextString;
    end;
}

