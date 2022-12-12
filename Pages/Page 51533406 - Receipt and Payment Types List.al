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
                field("Code";Code)
                {
                }
                field(Description;Description)
                {
                }
                field("Account Type";"Account Type")
                {
                }
                field(Type;Type)
                {
                }
                field("VAT Chargeable";"VAT Chargeable")
                {
                }
                field("VAT Deductible";"VAT Deductible")
                {
                }
                field("VAT Code";"VAT Code")
                {
                }
                field("Withholding Tax Chargeable";"Withholding Tax Chargeable")
                {
                }
                field("Withholding Tax Code";"Withholding Tax Code")
                {
                }
                field("Default Grouping";"Default Grouping")
                {
                }
                field("G/L Account";"G/L Account")
                {
                }
                field("Pending Voucher";"Pending Voucher")
                {
                }
                field("Bank Account";"Bank Account")
                {
                }
                field("Transation Remarks";"Transation Remarks")
                {
                }
                field("Direct Expense";"Direct Expense")
                {
                }
                field("Payment Reference";"Payment Reference")
                {
                }
                field(Blocked;Blocked)
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

