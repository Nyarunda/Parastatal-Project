page 51533103 "prBank Structure"
{
    PageType = List;
    SourceTable = "prBank Structure";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("Bank Code"; Rec."Bank Code")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Branch Name"; Rec."Branch Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

