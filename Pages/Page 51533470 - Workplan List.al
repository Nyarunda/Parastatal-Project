page 51533470 "Workplan List"
{
    CardPageID = "Workplan Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = Workplan;
    SourceTableView = WHERE("Last Year" = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                ShowCaption = false;
                field("Workplan Code"; Rec."Workplan Code")
                {
                }
                field("Workplan Description"; Rec."Workplan Description")
                {
                    Caption = 'Workplan Description';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000002; Outlook)
            {
            }
            systempart(Control1000000000; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Visible = false;
                action("Workplan Activities")
                {
                    Caption = 'Workplan Activities';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page WorkplanActivities;
                    RunPageLink = "Workplan Code" = FIELD("Workplan Code");
                    RunPageMode = Edit;
                }
                action(Print)
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin

                        Rec.Reset;
                        Rec.SetFilter("Workplan Code", Rec."Workplan Code");
                        //REPORT.Run(REPORT::"W/P Report",true,true,Rec);
                        Rec.Reset;
                    end;
                }
            }
        }
    }
}

