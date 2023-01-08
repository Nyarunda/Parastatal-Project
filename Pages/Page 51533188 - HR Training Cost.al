page 51533188 "HR Training Cost"
{
    PageType = List;
    SourceTable = "HR Training Cost";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cost Item"; Rec."Cost Item")
                {
                }
                field("Cost Item Description"; Rec."Cost Item Description")
                {
                    Editable = false;
                }
                field(Cost; Rec.Cost)
                {
                }
            }
        }
    }

    actions
    {
    }
}

