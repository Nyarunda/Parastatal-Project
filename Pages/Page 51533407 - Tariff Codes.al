page 51533407 "Tariff Codes"
{
    PageType = List;
    SourceTable = "Tariff Codes";

    layout
    {
        area(content)
        {
            repeater(Control1102758000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Percentage; Rec.Percentage)
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Account No."; Rec."Account No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

