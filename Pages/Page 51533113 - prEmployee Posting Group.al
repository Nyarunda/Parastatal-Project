page 51533113 "prEmployee Posting Group"
{
    PageType = List;
    SourceTable = "prEmployee Posting Group";

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Salary Account"; Rec."Salary Account")
                {
                }
                field("Income Tax Account"; Rec."Income Tax Account")
                {
                }
                field("SSF Employer Account"; Rec."SSF Employer Account")
                {
                    Caption = 'SSF Employer Expense Account';
                }
                field("SSF Employee Account"; Rec."SSF Employee Account")
                {
                    Caption = 'SSF Total Payable Account';
                }
                field("Net Salary Payable"; Rec."Net Salary Payable")
                {
                }
                field("Payslip Report"; Rec."Payslip Report")
                {
                }
                field("Eligible for Overtime"; Rec."Eligible for Overtime")
                {
                }
                field("NHIF Employee Account"; Rec."NHIF Employee Account")
                {
                }
                field("Tax Relief"; Rec."Tax Relief")
                {
                }
                field("Tax Code"; Rec."Tax Code")
                {
                }
                field("Pension Employer Acc"; Rec."Pension Employer Acc")
                {
                }
                field("Pension Employee Acc"; Rec."Pension Employee Acc")
                {
                }
            }
        }
    }

    actions
    {
    }
}

