page 51533140 "Pr Payroll Transactions Codes"
{
    CardPageID = "prTransaction Code";
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "prTransaction Codes";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Code"; Rec."Transaction Code")
                {
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                }
                field("Balance Type"; Rec."Balance Type")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field(Frequency; Rec.Frequency)
                {
                }
                field("Is Cash"; Rec."Is Cash")
                {
                }
                field(Taxable; Rec.Taxable)
                {
                }
                field("Is Formula"; Rec."Is Formula")
                {
                }
                field(Formula; Rec.Formula)
                {
                }
                field("Amount Preference"; Rec."Amount Preference")
                {
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                }
                field("GL Account"; Rec."GL Account")
                {
                }
            }
        }
    }

    actions
    {
    }
}

