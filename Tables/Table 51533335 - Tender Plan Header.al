table 51533335 "Tender Plan Header"
{

    fields
    {
        field(1;"No.";Code[20])
        {
            NotBlank = true;
        }
        field(3;"Workplan Code";Code[20])
        {
            Description = 'Workplan."Workplan Code"';
            TableRelation = Workplan;

            trigger OnValidate()
            begin
                  // IF "Workplan code" = '' THEN BEGIN

                   Workplan.Reset;
                   if Workplan.Get("Workplan Code") then
                   begin
                     "Workplan Description":=Workplan."Workplan Description";
                   end else
                   begin
                      Message('not found');
                   end;
                  // MODIFY
            end;
        }
        field(11;"Procurement Method";Code[20])
        {

            trigger OnValidate()
            begin
                /*TendStages.SETRANGE("Tender No.",No);
                IF TendStages.COUNT<1 THEN CreateLines ELSE
                UpdateLines;*/
                /*
                ProcStages.SETFILTER("Proc. Method No.","Proc. method number");
                
                TendStages.INIT;
                PrevStageDate:="Start Date";
                IF ProcStages.FIND('-') THEN REPEAT
                
                  TendStages."Tender No.":=No;
                  TendStages.Stage:=ProcStages.Stage;
                  TendStages."Planned duration":=ProcStages.Duration;
                  TendStages."Sorting No.":=ProcStages."Sorting No.";
                  TendStages."WorkPlan Code":="Workplan code";
                  TendStages."Planned start date":=PrevStageDate;
                  TendStages."Planned end date":=CALCDATE('+'+FORMAT(TendStages."Planned duration")+'D',TendStages."Planned start date");
                  PrevStageDate:=TendStages."Planned end date";
                  TendStages.INSERT(TRUE);
                UNTIL ProcStages.NEXT=0;
                */
                /*
                Procumethod.RESET;
                Procumethod.GET("Procurement Method");
                "Procurement Method Name":= Procumethod.Relationship;
                */

            end;
        }
        field(12;"Start Date";Date)
        {
        }
        field(13;"Workplan Description";Text[250])
        {
            Editable = false;
            TableRelation = "Workplan Entry"."Workplan Code";
        }
        field(14;"Procurement Method Name";Text[50])
        {
            Editable = false;
        }
        field(15;"No. Series";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TendStages.Reset;
        TendStages.SetRange(TendStages."Tender No.","No.");
        if TendStages.Find('-') then
        begin
            TendStages.DeleteAll(true);
        end;
    end;

    var
        ProcStages: Record "Procurement Method Stages";
        TendStages: Record "Tender Plan Lines";
        PrevStageDate: Date;
        Workplan: Record Workplan;
        Workplandet: Text[250];
        "RECTenderno.s": Record "Tender Plan Header";
        WorkPlanAct: Text[30];
}

