page 51533126 "Salary Grades List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Salary Grades";

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                ShowCaption = false;
                field("Salary Grade"; Rec."Salary Grade")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Salary Amount"; Rec."Salary Amount")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

