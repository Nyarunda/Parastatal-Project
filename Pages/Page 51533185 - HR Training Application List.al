page 51533185 "HR Training Application List"
{
    CardPageID = "HR Training Application Header";
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HR Training App Header";
    SourceTableView = WHERE(Status = FILTER(<> Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No"; Rec."Application No")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Application Date"; Rec."Application Date")
                {
                }
                field("Course Title"; Rec."Course Title")
                {
                }
                field("Course Description"; Rec."Course Description")
                {
                }
                field("No. of Participants"; Rec."No. of Participants")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field(Status; Rec.Status)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control17; Outlook)
            {
            }
            systempart(Control18; Notes)
            {
            }
            systempart(Control19; Links)
            {
            }
        }
    }

    actions
    {
    }
}

