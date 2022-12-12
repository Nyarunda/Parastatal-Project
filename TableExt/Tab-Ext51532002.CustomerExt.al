tableextension 51532002 "Customer Ext" extends Customer
{
    fields
    {
        field(10000; "Account Type"; Enum "Account Type")
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
        }
    }
}
