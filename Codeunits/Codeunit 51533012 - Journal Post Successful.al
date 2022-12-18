codeunit 51533012 "Journal Post Successful"
{

    trigger OnRun()
    begin
    end;

    procedure PostedSuccessfully() Posted: Boolean
    var
        ValPost: Record "Value Posting";
    begin

          Posted:=false;
         ValPost.SetRange(ValPost.UserID,UserId);
         ValPost.SetRange(ValPost."Value Posting",1);
         if ValPost.Find('-') then
            Posted:=true;
    end;
}

