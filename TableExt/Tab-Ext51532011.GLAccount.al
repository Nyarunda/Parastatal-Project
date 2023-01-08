tableextension 51532011 "G/L Account Ext" extends "G/L Account"
{
    fields
    {
        field(1300; "Budget Control Account"; Code[20])
        {
            Caption = 'Budget Control Account';
            DataClassification = ToBeClassified;
        }
        field(1301; "Expense Code"; Code[20])
        {
            Caption = 'Expense Code';
            DataClassification = ToBeClassified;
        }
        field(1302; "Budget Controlled"; Boolean)
        {
            Caption = 'Budget Controlled';
            DataClassification = ToBeClassified;
        }

    }
}
