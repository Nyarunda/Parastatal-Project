page 51533009 "HR Jobs List"
{
    CardPageID = "HR Jobs Card";
    DelayedInsert = false;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Functions,Job,Administration';
    RefreshOnActivate = true;
    SourceTable = "HR Jobs";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("Job Description"; Rec."Job Description")
                {
                    Caption = 'Job Title';
                }
                field("No of Posts"; Rec."No of Posts")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Date Created"; Rec."Date Created")
                {
                    StyleExpr = TRUE;
                }
                field(Status; Rec.Status)
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
            }
        }
        area(factboxes)
        {
            part("<Page39003906>"; "HR Jobs Factbox")
            {
                SubPageLink = "Job ID" = FIELD("Job ID");
            }
            systempart(Control1102755004; Outlook)
            {
            }
        }
    }

    actions
    {
    }
}

