page 51533297 "HR Bank Accounts List"
{
    PageType = List;
    SourceTable = "HR Employee Bank Accounts";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                }
                field("Bank  Code"; Rec."Bank  Code")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Branch Name"; Rec."Branch Name")
                {
                }
                field("A/C  Number"; Rec."A/C  Number")
                {
                }
                field("Percentage to Transfer"; Rec."Percentage to Transfer")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control10; Outlook)
            {
            }
            systempart(Control11; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

