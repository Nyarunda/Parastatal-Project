page 51533945 "Tender Committee List"
{
    CardPageID = "Tender Committe Activities";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Tender Committee Activities";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = false;
                ShowCaption = false;
                field("Code";Code)
                {
                }
                field("RFQ No.";"RFQ No.")
                {
                }
                field("RFQ Description";"RFQ Description")
                {
                }
                field(Date;Date)
                {
                }
                field(Venue;Venue)
                {
                }
                field(Costs;Costs)
                {
                }
                field("Employee Responsible";"Employee Name")
                {
                }
                field(Closed;Closed)
                {
                }
                field("Activity  Status>";"Activity Status")
                {
                    Caption = 'Activity  Status';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755004;"Tender Activities Factbox")
            {
                SubPageLink = Code=FIELD(Code);
            }
        }
    }

    actions
    {
    }
}

