page 51533585 WorkplanActivities
{
    PageType = List;
    SourceTable = "Workplan Activities";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Workplan Code";"Workplan Code")
                {
                }
                field("Activity Code";"Activity Code")
                {
                    Caption = 'Activity Code';
                }
                field("Source Of Funds";"Source Of Funds")
                {
                }
                field("Entry Type";"Entry Type")
                {
                }
                field(Budget;Budget)
                {
                    TableRelation = "G/L Budget Name";
                }
                field("Account Type";"Account Type")
                {

                    trigger OnValidate()
                    begin
                        //UpdateControls;
                    end;
                }
                field(Type;Type)
                {
                    Caption = 'Type';
                }
                field("No.";"No.")
                {
                }
                field(Description;Description)
                {
                }
                field("Activity Description";"Activity Description")
                {
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    Caption = 'Department Code';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    Caption = 'Division Code';
                }
                field(Period;Period)
                {
                }
                field("Proc. Method No.";"Proc. Method No.")
                {
                }
                field(Quantity;Quantity)
                {
                }
                field("Unit of Cost";"Unit of Cost")
                {
                    Caption = ' Cost Per Unit';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                }
                field("Amount to Transfer";"Amount to Transfer")
                {

                    trigger OnValidate()
                    begin
                        "Amount to Transfer" := Quantity * "Unit of Cost";
                    end;
                }
                field("Date to Transfer";"Date to Transfer")
                {
                }
                field("Procurement Category";"Procurement Category")
                {
                    Caption = 'Category';
                }
                field("Budgeted Amount";"Budgeted Amount")
                {
                    Editable = false;
                }
                field("Uploaded to Procurement Workpl";"Uploaded to Procurement Workpl")
                {
                    Editable = false;
                    Visible = true;
                }
                field("Converted to Budget";"Converted to Budget")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                }
                field("Include In Procurement Plan";"Include In Procurement Plan")
                {
                }
                field(Status;Status)
                {
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        "Document Date":=Today;
    end;
}

