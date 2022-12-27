table 51533105 "prTransaction Codes"
{
    DataCaptionFields = "Transaction Name";
    DrillDownPageID = "Pr Payroll Transactions Codes";
    LookupPageID = "Pr Payroll Transactions Codes";

    fields
    {
        field(1;"Transaction Code";Code[50])
        {
            Description = 'Unique Trans line code';
        }
        field(3;"Transaction Name";Text[100])
        {
            Description = 'Description';
        }
        field(4;"Balance Type";Option)
        {
            Description = 'None,Increasing,Reducing';
            OptionMembers = "None",Increasing,Reducing;
        }
        field(5;"Transaction Type";Option)
        {
            Description = 'Income,Deduction';
            OptionMembers = Income,Deduction,Benefit;
        }
        field(6;Frequency;Option)
        {
            Description = 'Fixed,Varied';
            OptionMembers = "Fixed",Varied;
        }
        field(7;"Is Cash";Boolean)
        {
            Description = 'Does staff receive cash for this transaction';
        }
        field(8;Taxable;Boolean)
        {
            Description = 'Is it taxable or not';
        }
        field(9;"Is Formula";Boolean)
        {
            Description = 'Is the transaction based on a formula';
        }
        field(10;Formula;Text[200])
        {
            Description = '[Formula] If the above field is "Yes", give the formula';
        }
        field(16;"Amount Preference";Option)
        {
            Description = 'Either (Posted Amount), (Take Higher) or (Take Lower)';
            OptionMembers = "Posted Amount","Take Higher","Take Lower ";
        }
        field(18;"Special Transactions";Option)
        {
            Description = 'Represents all Special Transactions';
            OptionMembers = Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage;
        }
        field(21;"Deduct Premium";Boolean)
        {
            Description = '[Insurance] Should the Premium be treated as a payroll deduction?';
        }
        field(26;"Interest Rate";Decimal)
        {
            Description = '[Loan] If above is "Yes", give the interest rate';
        }
        field(28;"Repayment Method";Option)
        {
            Description = '[Loan] Reducing,Straight line';
            OptionMembers = Reducing,"Straight line",Amortized;
        }
        field(29;"Fringe Benefit";Boolean)
        {
            Description = '[Loan] should the loan be treated as a Fringe Benefit?';
        }
        field(30;"Employer Deduction";Boolean)
        {
            Description = 'Caters for Employer Deductions';
        }
        field(31;isHouseAllowance;Boolean)
        {
            Description = 'Flags if its house allowance - Dennis';
        }
        field(32;"Include Employer Deduction";Boolean)
        {
            Description = 'Is the transaction to include the employer deduction? - Dennis';
        }
        field(33;"Is Formula for employer";Text[200])
        {
            Description = '[Is Formula for employer] If the above field is "Yes", give the Formula for employer Dennis';
        }
        field(34;"Transaction Code old";Code[50])
        {
            Description = 'Old Unique Trans line code - Dennis';
        }
        field(35;"GL Account";Code[50])
        {
            Description = 'to post to GL account - Dennis';
            TableRelation = "G/L Account"."No.";
        }
        field(36;"GL Employee Account";Code[50])
        {
            Description = 'to post to GLemployee  account - Dennis';
        }
        field(37;"coop parameters";Option)
        {
            Caption = 'Other Categorization';
            Description = 'to be able to report the different coop contributions -Dennis';
            OptionMembers = "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,NSSF,Overtime;
        }
        field(38;"IsCoop/LnRep";Boolean)
        {
            Description = 'to be able to report the different coop contributions -Dennis';
        }
        field(39;"Deduct Mortgage";Boolean)
        {
        }
        field(40;Subledger;Option)
        {
            OptionMembers = " ",Customer,Vendor;
        }
        field(41;Welfare;Boolean)
        {
        }
        field(42;CustomerPostingGroup;Code[20])
        {
            TableRelation = "Customer Posting Group".Code;
        }
        field(200;"Tax Limit Amount";Decimal)
        {
        }
        field(201;"Tax Limit Percentage";Decimal)
        {
        }
        field(202;Pension;Boolean)
        {
        }
        field(203;"Non-Transactional";Boolean)
        {
        }
        field(210;"Previous Month Filter";Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "prPayroll Periods"."Date Opened";
        }
        field(211;"Current Month Filter";Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "prPayroll Periods"."Date Opened";
        }
        field(212;"Prev. Amount";Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE ("Payroll Period"=FIELD("Previous Month Filter"),
                                                                    "Transaction Code"=FIELD("Transaction Code"),
                                                                    "Employee Code"=FIELD("Employee Code Filter"),
                                                                    "Location/Division"=FIELD("Location/Division Filter"),
                                                                    Department=FIELD("Department Filter"),
                                                                    "Cost Centre"=FIELD("Cost Centre Filter"),
                                                                    "Salary Grade"=FIELD("Salary Grade Filter"),
                                                                    "Salary Notch"=FIELD("Salary Notch Filter")));
            FieldClass = FlowField;
        }
        field(213;"Curr. Amount";Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE ("Payroll Period"=FIELD("Current Month Filter"),
                                                                    "Transaction Code"=FIELD("Transaction Code"),
                                                                    "Employee Code"=FIELD("Employee Code Filter"),
                                                                    "Location/Division"=FIELD("Location/Division Filter"),
                                                                    Department=FIELD("Department Filter"),
                                                                    "Cost Centre"=FIELD("Cost Centre Filter"),
                                                                    "Salary Grade"=FIELD("Salary Grade Filter"),
                                                                    "Salary Notch"=FIELD("Salary Notch Filter")));
            FieldClass = FlowField;
        }
        field(214;"Gross Variation";Decimal)
        {
            CalcFormula = Sum("Monthly Reconcilliation".Difference WHERE (TransCode=FIELD("Transaction Code"),
                                                                          "Entry/Exit"=FIELD("Entry/Exit Filter"),
                                                                          "Location/Division"=FIELD("Location/Division Filter"),
                                                                          Department=FIELD("Department Filter"),
                                                                          "Cost Centre"=FIELD("Cost Centre Filter"),
                                                                          "Salary Grade"=FIELD("Salary Grade Filter"),
                                                                          "Salary Notch"=FIELD("Salary Notch Filter")));
            FieldClass = FlowField;
        }
        field(215;"Group Order";Integer)
        {
        }
        field(216;"Sub Group Order";Integer)
        {
        }
        field(217;"Entry/Exit Filter";Boolean)
        {
            FieldClass = FlowFilter;
        }
        field(218;"Leave Allowance";Boolean)
        {
        }
        field(219;"Transaction Category";Option)
        {
            OptionCaption = ' ,Housing,Transport,Other Allowances,SSF,Pension,Company Loan,Housing Deduction,Personal Loan,Inconvinience,Bonus Special,Other Deductions,Overtime,Entertainment,Leave,Utility,Other Co-deductions,Car Loan,Call Duty,Co-op,Lunch,Compassionate Loan,Tax Deductions,Lateness,BackPay';
            OptionMembers = " ",Housing,Transport,"Other Allowances",SSF,Pension,"Company Loan","Housing Deduction","Personal Loan",Inconvinience,"Bonus Special","Other Deductions",Overtime,Entertainment,Leave,Utility,"Other Co-deductions","Car Loan","Call Duty","Co-op",Lunch,"Compassionate Loan","Tax Deductions",Lateness,BackPay;
        }
        field(220;"Employee Code Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "HR-Employee"."No.";
        }
        field(221;"Overtime Type";Option)
        {
            OptionMembers = " ","Ordinary OT","Double OT","Triple OT";
        }
        field(222;"Transfer to";Code[20])
        {
            TableRelation = "prTransaction Codes"."Transaction Code";
        }
        field(223;"Location/Division Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('LOC/DIV'));
        }
        field(224;"Department Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('DEPARTMENT'));
        }
        field(225;"Cost Centre Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('COSTCENTRE'));
        }
        field(226;"Salary Grade Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Salary Grades"."Salary Grade";
        }
        field(227;"Salary Notch Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Salary Notch"."Salary Notch" WHERE ("Salary Grade"=FIELD("Salary Grade Filter"));
        }
        field(228;"Add to Relief";Boolean)
        {
        }
        field(229;"Sort Order";Integer)
        {
        }
        field(230;"Curr. Units";Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions"."No. Of Units" WHERE ("Payroll Period"=FIELD("Current Month Filter"),
                                                                            "Transaction Code"=FIELD("Transaction Code"),
                                                                            "Employee Code"=FIELD("Employee Code Filter"),
                                                                            "Location/Division"=FIELD("Location/Division Filter"),
                                                                            Department=FIELD("Department Filter"),
                                                                            "Cost Centre"=FIELD("Cost Centre Filter"),
                                                                            "Salary Grade"=FIELD("Salary Grade Filter"),
                                                                            "Salary Notch"=FIELD("Salary Notch Filter")));
            FieldClass = FlowField;
        }
        field(231;"Prorate Absence";Boolean)
        {
        }
        field(232;"Recon Items";Integer)
        {
            CalcFormula = Count("Monthly Reconcilliation" WHERE (TransCode=FIELD("Transaction Code")));
            FieldClass = FlowField;
        }
        field(233;"Annual Pay";Boolean)
        {
        }
        field(234;"Excl. from Proration";Boolean)
        {
        }
        field(235;"Fixed Amount";Decimal)
        {
        }
        field(236;"Excl. from Basic Pay";Boolean)
        {
        }
        field(237;"Other Transaction";Boolean)
        {
        }
        field(238;"Pre-Tax Deduction";Boolean)
        {
        }
        field(239;"Is Overtime Allowance";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Transaction Code")
        {
        }
        key(Key2;"Group Order","Sub Group Order")
        {
        }
        key(Key3;"Sort Order")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Transaction Code","Transaction Name")
        {
        }
    }
}

