table 51533115 "prPeriod Transactions"
{
    DrillDownPageID = 39004022;
    LookupPageID = 39004022;

    fields
    {
        field(1;"Employee Code";Code[50])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(2;"Transaction Code";Text[30])
        {
            TableRelation = "prTransaction Codes"."Transaction Code";
        }
        field(3;"Group Text";Text[30])
        {
            Description = 'e.g Statutory, Deductions, Tax Calculation etc';
        }
        field(4;"Transaction Name";Text[200])
        {
        }
        field(5;Amount;Decimal)
        {
        }
        field(6;Balance;Decimal)
        {
        }
        field(7;"Original Amount";Decimal)
        {
        }
        field(8;"Group Order";Integer)
        {
        }
        field(9;"Sub Group Order";Integer)
        {
        }
        field(10;"Period Month";Integer)
        {
        }
        field(11;"Period Year";Integer)
        {
        }
        field(12;"Period Filter";Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "prPayroll Periods"."Date Opened";
        }
        field(13;"Payroll Period";Date)
        {
            TableRelation = "prPayroll Periods"."Date Opened";
        }
        field(14;Membership;Code[50])
        {
            TableRelation = "prInstitutional Membership"."Institution No";
        }
        field(15;"Reference No";Text[20])
        {
        }
        field(16;"Department Code";Code[20])
        {
        }
        field(17;Lumpsumitems;Boolean)
        {
        }
        field(18;TravelAllowance;Code[20])
        {
        }
        field(19;"GL Account";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(20;"Company Deduction";Boolean)
        {
            Description = 'Dennis- Added to filter out the company deductions esp: the Pensions';
        }
        field(21;"Emp Amount";Decimal)
        {
            Description = 'Dennis- Added to take care of the balances that need a combiantion btwn employee and employer';
        }
        field(22;"Emp Balance";Decimal)
        {
            Description = 'Dennis- Added to take care of the balances that need a combiantion btwn employee and employer';
        }
        field(23;"Journal Account Code";Code[20])
        {
        }
        field(24;"Journal Account Type";Option)
        {
            OptionMembers = " ","G/L Account",Customer,Vendor;
        }
        field(25;"Post As";Option)
        {
            OptionMembers = " ",Debit,Credit;
        }
        field(26;"Loan Number";Code[10])
        {
        }
        field(27;"coop parameters";Option)
        {
            Description = 'to be able to report the different coop contributions -Dennis';
            OptionMembers = "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,NSSF,Overtime;
        }
        field(28;"Payroll Code";Code[20])
        {
            TableRelation = "prPayroll Type";
        }
        field(29;"Payment Mode";Option)
        {
            Description = 'Bank Transfer,Cheque,Cash,SACCO';
            OptionMembers = " ","Bank Transfer",Cheque,Cash,SACCO;
        }
        field(30;"Location/Division";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('LOC/DIV'));
        }
        field(31;Department;Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('DEPARTMENT'));
        }
        field(32;"Cost Centre";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('COSTCENTRE'));
        }
        field(33;"Salary Grade";Code[20])
        {
            TableRelation = "Salary Grades"."Salary Grade";
        }
        field(34;"Salary Notch";Code[20])
        {
            TableRelation = "Salary Notch"."Salary Notch" WHERE ("Salary Grade"=FIELD("Salary Grade"));
        }
        field(35;"Payslip Order";Integer)
        {
        }
        field(36;"No. Of Units";Decimal)
        {
        }
        field(37;Currency;Code[10])
        {
            Description = 'This holds the currency the transaction was originally done in';
        }
        field(38;AmountFCY;Decimal)
        {
        }
        field(39003900;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(39003901;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(39003903;"Transaction Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Income,Deduction';
            OptionMembers = Income,Deduction,Benefit;
        }
    }

    keys
    {
        key(Key1;"Employee Code","Transaction Code","Period Month","Period Year",Membership,"Reference No")
        {
            SumIndexFields = Amount,"No. Of Units";
        }
        key(Key2;"Employee Code","Period Month","Period Year","Group Order","Sub Group Order","Payslip Order",Membership,"Reference No")
        {
            SumIndexFields = Amount,"No. Of Units";
        }
        key(Key3;"Group Order","Transaction Code","Period Month","Period Year",Membership,"Reference No","Department Code")
        {
            SumIndexFields = Amount,"No. Of Units";
        }
        key(Key4;Membership)
        {
        }
        key(Key5;"Transaction Code","Payroll Period",Membership,"Reference No")
        {
            SumIndexFields = Amount,"No. Of Units";
        }
        key(Key6;"Payroll Period","Group Order","Sub Group Order")
        {
            SumIndexFields = Amount,"No. Of Units";
        }
        key(Key7;"Employee Code","Department Code")
        {
            SumIndexFields = Amount,"No. Of Units";
        }
        key(Key8;"Transaction Code","Employee Code","Payroll Period","Location/Division",Department)
        {
            SumIndexFields = Amount,"No. Of Units";
        }
        key(Key9;"Payslip Order")
        {
        }
        key(Key10;"Transaction Code","Employee Code","Payroll Period","Reference No")
        {
        }
    }

    fieldgroups
    {
    }
}

