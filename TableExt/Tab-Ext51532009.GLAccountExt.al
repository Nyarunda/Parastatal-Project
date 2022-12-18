tableextension 51532009 "G/L Account Ext" extends "G/L Account"
{
    fields
    {
        field(51532000; "Expense Code"; Code[20])
        {
            Caption = 'Expense Code';
            DataClassification = ToBeClassified;
        }
    }
}
