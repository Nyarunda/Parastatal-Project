table 51533137 "prEmployee Posting Group"
{
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "prEmployee Posting Group";
    LookupPageID = "prEmployee Posting Group";

    fields
    {
        field(1; "Code"; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Salary Account"; Code[100])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Income Tax Account"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(5; "SSF Employer Account"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(6; "SSF Employee Account"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Net Salary Payable"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Operating Overtime"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Tax Relief"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(10; "Employee Provident Fund Acc."; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(11; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "prPayroll Periods"."Date Opened";
        }
        field(12; "Pension Employer Acc"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(13; "Pension Employee Acc"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(14; "Earnings and deductions"; Code[50])
        {
        }
        field(15; "Staff Benevolent"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(16; SalaryExpenseAC; Code[100])
        {
            TableRelation = "G/L Account";
        }
        field(17; DirectorsFeeGL; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(18; StaffGratuity; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(19; "NHIF Employee Account"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(20; "Payroll Code"; Code[20])
        {
            TableRelation = "prPayroll Type";
        }
        field(21; "Payslip Report"; Integer)
        {
            TableRelation = Object.ID WHERE(Type = CONST(Report));
        }
        field(22; "Tax Code"; Code[20])
        {
            //TableRelation = "prTax Law".Code WHERE(Blocked = FILTER(false));
        }
        field(23; "Employment Tax Debit"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(24; "Employment Tax Credit"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(25; "Eligible for Overtime"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Earnings and deductions")
        {
        }
    }

    fieldgroups
    {
    }
}

