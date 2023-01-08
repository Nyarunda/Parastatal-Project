page 51533191 "HR Training Application Lines"
{
    AutoSplitKey = false;
    Caption = 'HR Training Participants';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "HR Training App Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field("Job ID"; Rec."Job ID")
                {
                    Editable = false;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Editable = false;
                }
                field(Objectives; Rec.Objectives)
                {
                }
                field("Provided attendance evidence?"; Rec."Provided attendance evidence?")
                {
                }
                field(Attended; Rec.Attended)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Suggest Participants")
                {
                    Caption = 'Suggest Participants';

                    trigger OnAction()
                    begin
                        HRTrainingAppHeader.Reset;
                        HRTrainingAppHeader.SetRange(HRTrainingAppHeader."Application No", Rec."Application No.");
                        if HRTrainingAppHeader.Find('-') then begin
                            //HRTrainingAppHeader.TESTFIELD(HRTrainingAppHeader.Status,HRTrainingAppHeader.Status::Approved);
                        end;



                        Rec.Reset;
                        Rec.SetFilter("Application No.", Rec."Application No.");
                        //REPORT.Run(REPORT::Report39003932,true,true,Rec);
                    end;
                }
            }
        }
    }

    var
        HREmployees: Record "HR Employees";
        HRTrainingAppHeader: Record "HR Training App Header";
        HRTrainingAppLines: Record "HR Training App Lines";
}

