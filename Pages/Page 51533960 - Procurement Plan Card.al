page 51533916 "Procurement Plan Card"
{
    Caption = 'Procurement Plan Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "Procurement Plan";
    SourceTableView = WHERE("Last Year" = FILTER(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field("Budget Dimension 1 Code"; Rec."Budget Dimension 1 Code")
                {
                }
                field("Budget Dimension 2 Code"; Rec."Budget Dimension 2 Code")
                {
                }
                field("Budget Dimension 3 Code"; Rec."Budget Dimension 3 Code")
                {
                }
                field("Budget Dimension 4 Code"; Rec."Budget Dimension 4 Code")
                {
                }
                field("Source of Funds"; Rec."Source of Funds")
                {
                }
                field(Quarter; Rec.Quarter)
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Last Year"; Rec."Last Year")
                {
                }
            }
        }
    }

    actions
    {
    }
}

