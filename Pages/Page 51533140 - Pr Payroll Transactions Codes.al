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
                field("Transaction Code";"Transaction Code")
                {
                }
                field("Transaction Name";"Transaction Name")
                {
                }
                field("Balance Type";"Balance Type")
                {
                }
                field("Transaction Type";"Transaction Type")
                {
                }
                field(Frequency;Frequency)
                {
                }
                field("Is Cash";"Is Cash")
                {
                }
                field(Taxable;Taxable)
                {
                }
                field("Is Formula";"Is Formula")
                {
                }
                field(Formula;Formula)
                {
                }
                field("Amount Preference";"Amount Preference")
                {
                }
                field("Interest Rate";"Interest Rate")
                {
                }
                field("GL Account";"GL Account")
                {
                }
            }
        }
    }

    actions
    {
    }
}

