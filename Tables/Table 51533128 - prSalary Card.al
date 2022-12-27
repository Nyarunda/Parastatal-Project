table 51533128 "prSalary Card"
{

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            TableRelation = "HR Employees"."No.";
        }
        field(2; "Basic Pay"; Decimal)
        {

            trigger OnValidate()
            begin
                if Employee.Get("Employee Code") then begin
                    //"Dimension 1 Code" := Employee."Dimension 3 Code";
                    //"Dimension 2 Code" := Employee."Dimension 1 Code";
                    "Dimension 3 Code" := Employee."Cost Center Code";
                    "Salary Grade" := Employee."Salary Grade";
                    "Salary Notch" := Employee."Salary Notch/Step";
                end;
            end;
        }
        field(3; "Payment Mode"; Option)
        {
            Description = 'Bank Transfer,Cheque,Cash,SACCO';
            OptionMembers = " ","Bank Transfer",Cheque,Cash,FOSA;
        }
        field(4; Currency; Code[10])
        {
            TableRelation = Currency.Code;
        }
        field(5; "Pays SSF"; Boolean)
        {
        }
        field(6; "Pays PF"; Boolean)
        {
        }
        field(7; "Pays PAYE"; Boolean)
        {
        }
        field(8; "Payslip Message"; Text[100])
        {
        }
        field(9; "Cumm BasicPay"; Decimal)
        {
            CalcFormula = Sum("prEmployee P9 Info"."Basic Pay" WHERE("Employee Code" = FIELD("Employee Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Cumm GrossPay"; Decimal)
        {
            CalcFormula = Sum("prEmployee P9 Info"."Gross Pay" WHERE("Employee Code" = FIELD("Employee Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Cumm NetPay"; Decimal)
        {
            CalcFormula = Sum("prEmployee P9 Info"."Net Pay" WHERE("Employee Code" = FIELD("Employee Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Cumm Allowances"; Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE("Group Order" = FILTER(3),
                                                                    "Employee Code" = FIELD("Employee Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Cumm Deductions"; Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE("Group Order" = FILTER(8),
                                                                    "Sub Group Order" = FILTER(0 | 1),
                                                                    "Employee Code" = FIELD("Employee Code"),
                                                                    "Transaction Code" = FILTER(<> 'Total Deductions')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Suspend Pay"; Boolean)
        {
        }
        field(15; "Suspension Date"; Date)
        {
        }
        field(16; "Suspension Reasons"; Text[200])
        {
        }
        field(17; "Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "prPayroll Periods"."Date Opened";
        }
        field(18; Exists; Boolean)
        {
        }
        field(19; "Cumm PAYE"; Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE("Transaction Code" = FILTER('PAYE'),
                                                                    "Employee Code" = FIELD("Employee Code")));
            FieldClass = FlowField;
        }
        field(20; "Cumm NSSF"; Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE("Transaction Code" = FILTER('NSSF'),
                                                                    "Employee Code" = FIELD("Employee Code")));
            FieldClass = FlowField;
        }
        field(21; "Cumm Pension"; Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE("Transaction Code" = FILTER('0007'),
                                                                    "Employee Code" = FIELD("Employee Code")));
            FieldClass = FlowField;
        }
        field(22; "Cumm HELB"; Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE("Employee Code" = FIELD("Employee Code"),
                                                                    "Transaction Code" = FILTER('320')));
            FieldClass = FlowField;
        }
        field(23; "Cumm NHIF"; Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE("Employee Code" = FIELD("Employee Code"),
                                                                    "Transaction Code" = FILTER('NHIF')));
            FieldClass = FlowField;
        }
        field(24; "Bank Account Number"; Code[50])
        {
        }
        field(25; "Bank Branch"; Code[50])
        {
        }
        field(26; "Employee's Bank"; Code[50])
        {
        }
        field(27; "Posting Group"; Code[20])
        {
            CalcFormula = Lookup("HR Employees"."Posting Group" WHERE("No." = FIELD("Employee Code")));
            FieldClass = FlowField;
            NotBlank = false;
        }
        field(28; "Cumm Employer Pension"; Decimal)
        {
            CalcFormula = Sum("prEmployer Deductions".Amount WHERE("Employee Code" = FIELD("Employee Code"),
                                                                    "Transaction Code" = CONST('0007')));
            FieldClass = FlowField;
        }
        field(29; "Dimension 1 Code"; Code[20])
        {
        }
        field(30; "Dimension 2 Code"; Code[20])
        {
        }
        field(31; "Dimension 3 Code"; Code[20])
        {
        }
        field(32; "Salary Grade"; Code[20])
        {
            TableRelation = "Salary Grades"."Salary Grade";
        }
        field(33; "Salary Notch"; Code[20])
        {
            TableRelation = "Salary Notch"."Salary Notch" WHERE("Salary Grade" = FIELD("Salary Grade"));
        }
        field(34; "Pension House Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "prInstitutional Membership"."Institution No" WHERE("Group No" = CONST('PENSION'));
        }
        field(35; "Days Absent"; Decimal)
        {
        }
        field(36; "Cumm NHF"; Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE("Employee Code" = FIELD("Employee Code"),
                                                                    "Transaction Code" = FILTER('NHF')));
            FieldClass = FlowField;
        }
        field(323; "Payroll Type"; Option)
        {
            CalcFormula = Lookup("HR Employees"."Payroll Type" WHERE("No." = FIELD("Employee Code")));
            FieldClass = FlowField;
            OptionCaption = 'General,Directors';
            OptionMembers = General,Directors;
        }
        field(330; "Does Not Pay PAYE On Basic"; Boolean)
        {
            Description = 'pays paye on transactions only';
        }
        field(331; Location; Code[20])
        {
        }
        field(332; "Social Security Scheme"; Option)
        {
            OptionMembers = " ",New,Old;
        }
        field(333; "De-Activate Personal Relief?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(334; "Location/Division"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(335; Department; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(336; "Cost Centre"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
    }

    keys
    {
        key(Key1; "Employee Code")
        {
            SumIndexFields = "Basic Pay";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //ERROR('Delete not allowed');
    end;

    var
        Employee: Record "HR Employees";
}

