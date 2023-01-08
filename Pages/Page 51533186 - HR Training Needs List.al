page 51533186 "HR Training Needs List"
{
    CardPageID = "HR Training Needs Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SourceTable = "HR Training Needs";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = false;
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    Style = Ambiguous;
                    StyleExpr = TRUE;
                }
                field(Description; Rec.Description)
                {
                }
                field("Need Source"; Rec."Need Source")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                    StyleExpr = TRUE;
                }
                field("End Date"; Rec."End Date")
                {
                    StyleExpr = TRUE;
                }
                field(Costs; Rec.Costs)
                {
                    StyleExpr = TRUE;
                }
                field(Closed; Rec.Closed)
                {
                    Style = Ambiguous;
                    StyleExpr = TRUE;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755003; Outlook)
            {
            }
            systempart(Control1102755005; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

