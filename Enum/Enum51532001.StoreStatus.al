enum 51532001 "Store Status"
{
    Extensible = true;
    
    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Released)
    {
        Caption = 'Released';
    }
    value(2; """Director Approval""")
    {
        Caption = '"Director Approval"';
    }
    value(3; """Budget Approval""")
    {
        Caption = '"Budget Approval"';
    }
    value(4; """FD Approval""")
    {
        Caption = '"FD Approval"';
    }
    value(5; """CEO Approval""")
    {
        Caption = '"CEO Approval"';
    }
    value(6; Approved)
    {
        Caption = 'Approved';
    }
    value(7; Closed)
    {
        Caption = 'Closed';
    }
}
