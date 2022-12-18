page 51533921 "Tender Activity Participants"
{
    AutoSplitKey = false;
    Caption = 'Activity Participants';
    DelayedInsert = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = "Tender Committee Members";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("Document No."; Rec."Document No.")
                {
                    Enabled = false;
                }
                field(Notified; Rec.Notified)
                {
                    Enabled = false;
                }
                field(Participant; Rec.Participant)
                {
                }
                field("Partipant Name"; Rec."Partipant Name")
                {
                    Enabled = false;
                }
                field("User ID"; Rec."User ID")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("Participant Email"; Rec."Participant Email")
                {
                    Enabled = false;
                }
                field("Email Message"; Rec."Email Message")
                {
                }
                field("Attendance Confimed"; Rec."Attendance Confimed")
                {
                    Visible = false;
                }
                field("RFQ No"; Rec."RFQ No")
                {
                }
                field(Roles; Rec.Roles)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        TendComm.Reset;
        TendComm.SetRange(TendComm.Code, Rec."Document No.");
        if TendComm.Find('-') then begin
            Rec."Email Message" := TendComm."Email Message";
            TendComm.Modify;
        end;

        EvalComm.Reset;
        EvalComm.SetRange(EvalComm.Code, Rec."Document No.");
        if EvalComm.Find('-') then begin
            Rec."Email Message" := EvalComm."Email Message";
            EvalComm.Modify;
        end;


        InsComm.Reset;
        InsComm.SetRange(InsComm.Code, Rec."Document No.");
        if InsComm.Find('-') then begin
            Rec."Email Message" := InsComm."Email Message";
            InsComm.Modify;
        end;

        /**
                DispComm.Reset;
                DispComm.SetRange(DispComm.Code, Rec."Document No.");
                if DispComm.Find('-') then begin
                    Rec."Email Message" := DispComm."Email Message";
                    DispComm.Modify;
                end;
                **/
    end;

    var
        TendComm: Record "Tender Committee Activities";
        EvalComm: Record "Evaluation Committee Activity";
        InsComm: Record "Inspection Committee Activity";
    //DispComm: Record "Disposal Committee Activity";
}

