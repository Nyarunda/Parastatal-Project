table 51533331 "Procurement Methods"
{

    fields
    {
        field(1;"Code";Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                // IF GenLedSet.GET(Code) THEN BEGIN
                //
                //  END;
            end;
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Invite/Advertise date";Date)
        {
        }
        field(4;"Invite/Advertise period";DateFormula)
        {
        }
        field(5;"Open tender period";Integer)
        {
        }
        field(6;"Evaluate tender period";Integer)
        {
        }
        field(7;"Committee period";Integer)
        {
        }
        field(8;"Notification period";Integer)
        {
        }
        field(9;"Contract period";Integer)
        {
        }
        field(11;"Planned Date";Date)
        {
        }
        field(12;"Planned Days";DateFormula)
        {
        }
        field(13;"Actual Days";DateFormula)
        {
        }
        field(14;"Document Type";Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Quotation Request,Open Tender,Restricted Tender,Low Value Procurement,Direct Procurement,Request For proposal';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request For proposal";
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GenLedSet: Record "General Ledger Setup";
}

