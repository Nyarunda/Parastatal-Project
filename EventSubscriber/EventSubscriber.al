codeunit 51532002 EventSubscriber
{
    [IntegrationEvent(true, false)]
    procedure OnDrillDownUserID(var UserName: Code[70])
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::EventSubscriber, 'OnDrillDownUserID', '', false, false)]
    procedure OnDrillDownUserIDLookupUser(var UserName: Code[70])
    var
        SID: Guid;
    begin
        LookupUser(UserName, SID);
    end;

    local procedure LookupUser(var UserName: Code[70]; var SID: Guid)
    var
        User: Record User;
    begin
        User.Reset();
        User.SetCurrentKey("User Name");
        User."User Name" := UserName;
        if User.Find('=><') then;

        if Page.RunModal(Page::Users, User) = Action::LookupOK then begin
            UserName := User."User Name";
            SID := User."User Security ID";
        end;
    end;


}
