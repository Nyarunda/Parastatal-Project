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
                field("Job ID";"Job ID")
                {
                    Importance = Promoted;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Job Description";"Job Description")
                {
                    Caption = 'Job Title';
                }
                field("No of Posts";"No of Posts")
                {
                }
                field("Responsibility Center";"Responsibility Center")
                {
                }
                field("Date Created";"Date Created")
                {
                    StyleExpr = TRUE;
                }
                field(Status;Status)
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
            }
        }
        area(factboxes)
        {
            part("<Page39003906>";"HR Jobs Factbox")
            {
                SubPageLink = "Job ID"=FIELD("Job ID");
            }
            systempart(Control1102755004;Outlook)
            {
            }
        }
    }

    actions
    {
    }
}

