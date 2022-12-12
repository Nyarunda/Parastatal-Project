table 51533347 Tender
{
    DrillDownPageID = 39005781;
    LookupPageID = 39005781;

    fields
    {
        field(1;"Tender ID";Code[20])
        {
            NotBlank = true;
        }
        field(2;Description;Text[250])
        {
            NotBlank = true;
        }
        field(3;"Date Created";Date)
        {
            Editable = true;
        }
        field(4;"Created By";Code[20])
        {
            Editable = true;
        }
        field(5;"Tender Type";Option)
        {
            OptionCaption = 'General,Pharmaceutical,Food Supplies,Services';
            OptionMembers = General,Pharmaceutical,"Food Supplies",Services;
        }
        field(6;Open;Boolean)
        {
        }
        field(7;Category;Option)
        {
            OptionCaption = 'Services and Consumables,Specialised Medical Equipment';
            OptionMembers = "Services and Consumables","Specialised Medical Equipment";
        }
        field(8;"Valid From";Date)
        {
        }
        field(9;"Valid To";Date)
        {
        }
        field(10;"Tender Opening Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Tender ID")
        {
        }
        key(Key2;Category)
        {
        }
        key(Key3;"Tender Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('You cannot delete data from this table');
    end;

    trigger OnInsert()
    begin
        "Date Created":=Today;
        "Created By":=UserId;
    end;
}

