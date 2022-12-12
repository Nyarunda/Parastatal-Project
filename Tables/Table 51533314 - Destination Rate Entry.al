table 51533314 "Destination Rate Entry"
{

    fields
    {
        field(1;"Advance Code";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Receipts and Payment Types".Code WHERE (Type=FILTER(Imprest|Perdiem));
        }
        field(2;"Destination Code";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Travel Destination"."Destination Code";

            trigger OnValidate()
            begin
                "objTravel Destination".Reset;
                "objTravel Destination".SetRange("objTravel Destination"."Destination Code","Destination Code");
                if "objTravel Destination".Find('-') then begin
                 "Destination Name":="objTravel Destination"."Destination Name";
                 "Destination Type":="objTravel Destination"."Destination Type";
                end;
            end;
        }
        field(3;Currency;Code[10])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
            TableRelation = Currency;
        }
        field(4;"Destination Type";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionMembers = "local",Foreign;
        }
        field(5;"Daily Rate (Amount)";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Employee Job Group";Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            NotBlank = true;
            TableRelation = "Employee Statistics Group".Code;
        }
        field(7;"Destination Name";Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Advance Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        "objTravel Destination": Record "Travel Destination";
}

