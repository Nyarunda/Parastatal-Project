tableextension 51532004 "G/L Budget Name Ext" extends "G/L Budget Name"
{
    fields
    {
        field(20; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = ToBeClassified;
        }
        field(20; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = ToBeClassified;
        }
    }
}
