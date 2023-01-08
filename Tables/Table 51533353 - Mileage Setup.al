table 51533353 "Mileage Setup"
{

    fields
    {
        field(1; "Engine Capacity"; Code[10])
        {
        }
        field(2; "Rate per km"; Decimal)
        {
        }
        field(3; "Fuel type"; Option)
        {
            OptionMembers = Petrol,Diesel;
        }
    }

    keys
    {
        key(Key1; "Engine Capacity")
        {
        }
    }

    fieldgroups
    {
    }
}

