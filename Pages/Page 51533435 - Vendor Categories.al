page 51533435 "Vendor Categories"
{
    PageType = List;
    SourceTable = "Vendor Categories";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                }
                field("Code"; Rec.Code)
                {
                }
            }
        }
    }

    actions
    {
    }
}

