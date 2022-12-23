page 51533913 "Tender Committee List"
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
                field("Code"; Rec.Code)
                {
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                }
                field("RFQ Description"; Rec."RFQ Description")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Venue; Rec.Venue)
                {
                }
                field(Costs; Rec.Costs)
                {
                }
                field("Employee Responsible"; Rec."Employee Name")
                {
                }
                field(Closed; Rec.Closed)
                {
                }
                field("Activity  Status>"; Rec."Activity Status")
                {
                    Caption = 'Activity  Status';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755004; "Tender Activities Factbox")
            {
                SubPageLink = Code = FIELD(Code);
            }
        }
    }

    actions
    {
    }
}

