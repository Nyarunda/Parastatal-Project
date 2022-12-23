page 51533505 "Evaluation Criteria List"
{
    PageType = List;
    SourceTable = "Evaluation Criterial Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    Caption = 'Quotation No.';
                }
                field(Description; Rec.Description)
                {
                }
                field("Procurement Method"; Rec."Procurement Method")
                {
                }
                field("Evaluation Category"; Rec."Evaluation Category")
                {
                }
                field(YesNo; Rec.YesNo)
                {
                    Caption = 'Evaluation Status';
                    Visible = false;
                }
                field("Evaluation Maximum Score"; Rec."Evaluation Maximum Score")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Evaluation Category" = Rec."Evaluation Category"::Technical then
            EvaluationMaxScore := true
        else
            EvaluationMaxScore := false
    end;

    var
        EvaluationMaxScore: Boolean;
}

