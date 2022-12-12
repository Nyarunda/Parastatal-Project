table 51533313 "Travel Destination"
{

    fields
    {
        field(1;"Destination Code";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2;"Destination Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Destination Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Local",Foreign;
        }
        field(4;Currency;Code[10])
        {
            CalcFormula = Lookup("Destination Rate Entry".Currency WHERE ("Destination Code"=FIELD("Destination Code")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Destination Code")
        {
        }
    }

    fieldgroups
    {
    }
}

