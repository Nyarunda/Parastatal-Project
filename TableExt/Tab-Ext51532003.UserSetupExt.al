tableextension 51532003 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(6000; "Staff Travel Account"; Code[20])
        {
            Caption = 'Staff Travel Account';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(6001; "Allow Send Email Proc Officer"; Boolean)
        {
            Caption = 'Allow Send Email Proc Officer';
            DataClassification = ToBeClassified;
        }
    }
}
