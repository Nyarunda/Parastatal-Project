page 51533406 "Receipt and Payment Types List"
{
    CardPageID = "Payment Types";
    Editable = true;
    PageType = List;
    SourceTable = "Receipts and Payment Types";

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
                field("Account Type"; Rec."Account Type")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("VAT Chargeable"; Rec."VAT Chargeable")
                {
                }
                field("VAT Deductible"; Rec."VAT Deductible")
                {
                }
                field("VAT Code"; Rec."VAT Code")
                {
                }
                field("Withholding Tax Chargeable"; Rec."Withholding Tax Chargeable")
                {
                }
                field("Withholding Tax Code"; Rec."Withholding Tax Code")
                {
                }
                field("Default Grouping"; Rec."Default Grouping")
                {
                }
                field("G/L Account"; Rec."G/L Account")
                {
                }
                field("Pending Voucher"; Rec."Pending Voucher")
                {
                }
                field("Bank Account"; Rec."Bank Account")
                {
                }
                field("Transation Remarks"; Rec."Transation Remarks")
                {
                }
                field("Direct Expense"; Rec."Direct Expense")
                {
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

