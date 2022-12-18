tableextension 51532008 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(600; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = '';
            DataClassification = ToBeClassified;
        }
        field(1400; "Remittance Type"; Enum "Tax Calculation Type")
        {
            Caption = '';
            DataClassification = ToBeClassified;
        }
    }
}
