table 51533114 "prEmployee Transactions"
{

    fields
    {
        field(1; "Employee Code"; Code[30])
        {
            TableRelation = "HR Employees"."No.";
        }
        field(2; "Transaction Code"; Code[30])
        {
            TableRelation = "prTransaction Codes"."Transaction Code";

            trigger OnValidate()
            begin
                objPeriod.Reset;
                objPeriod.SetRange(objPeriod.Closed, false);
                if objPeriod.Find('-') then begin
                    CurrentYr := objPeriod."Period Year";
                end;



                if Transcode.Get("Transaction Code") then begin
                    if Transcode."Leave Allowance" = true then begin
                        EmployeeTrans.Reset;
                        EmployeeTrans.SetRange(EmployeeTrans."Employee Code", "Employee Code");
                        EmployeeTrans.SetRange(EmployeeTrans."Transaction Code", "Transaction Code");
                        if EmployeeTrans.Find('-') then begin
                            repeat
                                if EmployeeTrans."Period Year" = CurrentYr then begin
                                    MonthName := Format(EmployeeTrans."Payroll Period", 0, '<Month Text>');
                                    //ERROR(MonthName);
                                    Error('Employee has already been paid leave allowance in the period of %1.- %2', EmployeeTrans."Payroll Period",
                                           EmployeeTrans."Employee Code");
                                end;
                            until EmployeeTrans.Next = 0;
                        end;
                    end;
                end;
            end;
        }
        field(3; "Transaction Name"; Text[100])
        {
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; Balance; Decimal)
        {

            trigger OnValidate()
            begin
                "#of Repayments" := 0;
                //IF (Balance > 0) AND ("#of Repayments" > 0) THEN
                //Amount:=Balance/"#of Repayments"
            end;
        }
        field(6; "Original Amount"; Decimal)
        {
        }
        field(7; "Period Month"; Integer)
        {
        }
        field(8; "Period Year"; Integer)
        {
        }
        field(9; "Payroll Period"; Date)
        {
            TableRelation = "prPayroll Periods"."Date Opened";
        }
        field(10; "#of Repayments"; Integer)
        {

            trigger OnValidate()
            begin
                if (Balance > 0) and ("#of Repayments" > 0) then
                    Amount := Balance / "#of Repayments"
            end;
        }
        field(11; Membership; Code[10])
        {
            TableRelation = "prInstitutional Membership"."Institution No";
        }
        field(12; "Reference No"; Text[100])
        {
        }
        field(13; integera; Integer)
        {
        }
        field(14; "Employer Amount"; Decimal)
        {
        }
        field(15; "Employer Balance"; Decimal)
        {
        }
        field(16; "Stop for Next Period"; Boolean)
        {
        }
        field(17; "Amortized Loan Total Repay Amt"; Decimal)
        {
        }
        field(18; "Start Date"; Date)
        {
        }
        field(19; "End Date"; Date)
        {
        }
        field(20; "Loan Number"; Code[10])
        {
        }
        field(21; "Payroll Code"; Code[20])
        {
            TableRelation = "prPayroll Type";
        }
        field(22; "No of Units"; Decimal)
        {

            trigger OnValidate()
            begin
                if Transcode.Get("Transaction Code") then begin
                    if (Transcode."Transaction Category" = Transcode."Transaction Category"::Overtime) or
                       (Transcode."Transaction Category" = Transcode."Transaction Category"::Entertainment) then begin
                        Amount := 0;
                        //Transcode.TESTFIELD(Transcode."Overtime Type");
                        if SalCard.Get("Employee Code") then begin
                            if SalaryNotches.Get(SalCard."Salary Grade", SalCard."Salary Notch") then begin
                                if Transcode."Overtime Type" = Transcode."Overtime Type"::"Double OT" then
                                    Amount := SalaryNotches."Hourly Rate" * 2 * "No of Units"
                                else
                                    if Transcode."Overtime Type" = Transcode."Overtime Type"::"Triple OT" then
                                        Amount := SalaryNotches."Hourly Rate" * 3 * "No of Units"
                                    else
                                        if Transcode."Overtime Type" = Transcode."Overtime Type"::"Ordinary OT" then
                                            Amount := SalaryNotches."Hourly Rate" * 1.5 * "No of Units";
                            end;
                        end;
                    end;
                end;
                if Transcode."Overtime Type" = Transcode."Overtime Type"::" " then
                    Amount := Transcode."Fixed Amount" * "No of Units";
            end;
        }
        field(23; Suspended; Boolean)
        {
        }
        field(24; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(38; "IsCoop/LnRep"; Boolean)
        {
            CalcFormula = Lookup("prTransaction Codes"."IsCoop/LnRep" WHERE("Transaction Code" = FIELD("Transaction Code")));
            Description = 'to be able to report the different coop contributions -Dennis';
            FieldClass = FlowField;
        }
        field(39; Currency; Code[10])
        {
            TableRelation = Currency;
        }
        field(40; "Amount LCY"; Decimal)
        {
        }
        field(41; Stopped; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period", "Reference No")
        {
            SumIndexFields = Amount;
        }
        key(Key2; "Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Transcode: Record "prTransaction Codes";
        EmployeeTrans: Record "prEmployee Transactions";
        MonthName: Text[100];
        SalCard: Record "prSalary Card";
        SalaryNotches: Record "Salary Notch";
        CurrentYr: Integer;
        objPeriod: Record "prPayroll Periods";
}

