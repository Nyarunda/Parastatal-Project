table 51533305 "Tariff Codes"
{
    DrillDownPageID = "Tariff Codes";
    LookupPageID = "Tariff Codes";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Percentage; Decimal)
        {
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No.";
        }
        field(5; Type; Option)
        {
            OptionMembers = " ","W/Tax",VAT,Excise,Others,Retention;
        }
        field(12; "Account Type"; Enum "Account Type")
        {
            Caption = 'Account Type';

            trigger OnValidate()
            var
                PayLines: Record "Payment Line";
            begin
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PaymentLine.Reset;
        PaymentLine.SetRange(PaymentLine."VAT Code", Code);
        if PaymentLine.Find('-') then
            Error('You cannot delete the %1 Code its already used', Type);

        PaymentLine.Reset;
        PaymentLine.SetRange(PaymentLine."Withholding Tax Code", Code);
        if PaymentLine.Find('-') then
            Error('You cannot delete the %1 Code its already used', Type);
    end;

    var
        PaymentLine: Record "Payment Line";
}

