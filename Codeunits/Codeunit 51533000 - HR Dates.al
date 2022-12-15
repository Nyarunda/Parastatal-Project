codeunit 51533000 "HR Dates"
{

    trigger OnRun()
    begin
    end;

    var
        dayOfWeek: Integer;
        weekNumber: Integer;
        year: Integer;
        weekends: Integer;
        NextDay: Date;
        TEXTDATE1: Label 'The Start date cannot be Greater then the end Date.';

    procedure DetermineAge(DateOfBirth: Date;DateOfJoin: Date) AgeString: Text[45]
    var
        dayB: Integer;
        monthB: Integer;
        yearB: Integer;
        dayJ: Integer;
        monthJ: Integer;
        yearJ: Integer;
        Year: Integer;
        Month: Integer;
        Day: Integer;
        monthsToBirth: Integer;
        D: Date;
        DateCat: Integer;
    begin
                  if ((DateOfBirth <> 0D) and (DateOfJoin <> 0D)) then begin
                    dayB:= Date2DMY(DateOfBirth,1);
                    monthB:= Date2DMY(DateOfBirth,2);
                    yearB:= Date2DMY(DateOfBirth,3);
                    dayJ:= Date2DMY(DateOfJoin,1);
                    monthJ:= Date2DMY(DateOfJoin,2);
                    yearJ:= Date2DMY(DateOfJoin,3);
                    Day:= 0; Month:= 0; Year:= 0;
                    DateCat := DateCategory(dayB,dayJ,monthB,monthJ,yearB,yearJ);
                    case (DateCat) of
                        1: begin
                             Year:= yearJ - yearB;
                             if monthJ >= monthB then
                                Month:= monthJ - monthB
                             else begin
                                Month:= (monthJ + 12) - monthB;
                                Year:= Year - 1;
                             end;

                             if (dayJ >= dayB) then
                                Day:= dayJ - dayB
                             else if (dayJ < dayB) then begin
                                Day:= (DetermineDaysInMonth(monthJ,yearJ) + dayJ) - dayB;
                                Month:= Month - 1;
                             end;

                                AgeString:= '%1  Years, %2  Months and #3## Days';
                                AgeString:= StrSubstNo(AgeString,Year,Month,Day);

                            end;

                        2,3,7:begin
                              if (monthJ <> monthB) then begin
                                   if monthJ >= monthB then
                                      Month:= monthJ - monthB
                                 //  ELSE ERROR('The wrong date category!');
                               end;

                             if (dayJ <> dayB) then begin
                              if (dayJ >= dayB) then
                                Day:= dayJ - dayB
                              else if (dayJ < dayB) then begin
                                Day:= (DetermineDaysInMonth(monthJ,yearJ) + dayJ) - dayB;
                                Month:= Month - 1;
                              end;
                             end;

                               AgeString:= '%1  Months %2 Days';
                               AgeString:= StrSubstNo(AgeString,Month,Day);
                              end;
                         4: begin
                               Year:= yearJ - yearB;
                               AgeString:='#1## Years';
                               AgeString:= StrSubstNo(AgeString,Year);
                            end;
                         5: begin
                             if (dayJ >= dayB) then
                                Day:= dayJ - dayB
                             else if (dayJ < dayB) then begin
                                Day:= (DetermineDaysInMonth(monthJ,yearJ) + dayJ) - dayB;
                                monthJ:= monthJ - 1;
                                Month:= (monthJ + 12) - monthB;
                                yearJ:= yearJ - 1;
                             end;

                             Year:= yearJ - yearB;
                                AgeString:= '%1  Years, %2 Months and #3## Days';
                                AgeString:= StrSubstNo(AgeString,Year,Month,Day);
                             end;
                         6: begin
                             if monthJ >= monthB then
                                Month:= monthJ - monthB
                             else begin
                                Month:= (monthJ + 12) - monthB;
                                yearJ:= yearJ - 1;
                             end;
                                Year:= yearJ - yearB;
                                AgeString:= '%1  Years and #2## Months';
                                AgeString:= StrSubstNo(AgeString,Year,Month);
                            end;
                        else AgeString:= '';
                        end;
                      end else Message('For Date Calculation Enter All Applicable Dates!');
                       exit;
    end;

    procedure DetermineDaysInMonth(Month: Integer;Year: Integer) DaysInMonth: Integer
    begin
                            case (Month) of
                                 1              :   DaysInMonth:=31;
                                 2              :   begin
                                                      if (LeapYear(Year)) then DaysInMonth:=29
                                                      else DaysInMonth:= 28;
                                                    end;
                                 3              :   DaysInMonth:=31;
                                 4              :   DaysInMonth:=30;
                                 5              :   DaysInMonth:=31;
                                 6              :   DaysInMonth:=30;
                                 7              :   DaysInMonth:=31;
                                 8              :   DaysInMonth:=31;
                                 9              :   DaysInMonth:= 30;
                                 10             :   DaysInMonth:= 31;
                                 11             :   DaysInMonth:= 30;
                                 12             :   DaysInMonth:= 31;
                                 else Message('Not valid date. The month must be between 1 and 12');
                            end;

                            exit;
    end;

    procedure DateCategory(BDay: Integer;EDay: Integer;BMonth: Integer;EMonth: Integer;BYear: Integer;EYear: Integer) Category: Integer
    begin
                             if ((EYear > BYear) and (EMonth <> BMonth) and (EDay <> BDay)) then Category:= 1
                             else if ((EYear = BYear) and (EMonth <> BMonth) and (EDay = BDay)) then Category:=2
                             else if ((EYear = BYear) and (EMonth = BMonth) and (EDay <> BDay)) then Category:=3
                             else if ((EYear > BYear) and (EMonth = BMonth) and (EDay = BDay)) then Category:=4
                             else if ((EYear > BYear) and (EMonth = BMonth) and (EDay <> BDay)) then Category:= 5
                             else if ((EYear > BYear) and (EMonth <> BMonth) and (EDay = BDay)) then Category:= 6
                             else if ((EYear = BYear) and (EMonth <> BMonth) and (EDay <> BDay)) then Category:=7
                             else if ((EYear = BYear) and (EMonth = BMonth) and (EDay = BDay)) then Category:=3
                             else if ((EYear < BYear)) then
                             Error(TEXTDATE1)
                             else begin
                                  Category:=0;
                                  //ERROR('The start date cannot be after the end date.');
                                  end;
                             exit;
    end;

    procedure LeapYear(Year: Integer) LY: Boolean
    var
        CenturyYear: Boolean;
        DivByFour: Boolean;
    begin
                           CenturyYear := Year mod 100 = 0;
                           DivByFour:= Year mod 4 = 0;
                           if ((not CenturyYear and DivByFour) or (Year mod 400 = 0)) then
                            LY:= true
                           else
                            LY:= false;
    end;

    procedure DetermineWeekends(DateStart: Date;DateEnd: Date) Weekends: Integer
    begin
                 Weekends:= 0;
                 while (DateStart <= DateEnd) do begin
                   dayOfWeek:= Date2DWY(DateStart,1);
                     if (dayOfWeek = 6) or (dayOfWeek = 7) then
                        Weekends:= Weekends + 1;
                   NextDay:= CalculateNextDay(DateStart);
                   DateStart:= NextDay;
                 end;
    end;

    procedure CalculateNextDay(Date: Date) NextDate: Date
    var
        today: Integer;
        month: Integer;
        year: Integer;
        nextDay: Integer;
        daysInMonth: Integer;
    begin
                    today:= Date2DMY(Date,1);
                    month:= Date2DMY(Date,2);
                    year:= Date2DMY(Date,3);
                    daysInMonth:= DetermineDaysInMonth(month,year);
                    nextDay:= today + 1;
                    if (nextDay > daysInMonth) then begin
                      nextDay:= 1;
                      month:= month + 1;
                      if (month > 12) then begin
                        month:= 1;
                        year:= year + 1;
                      end;
                    end;
                     NextDate:= DMY2Date(nextDay,month,year);
    end;

    procedure ConvertDate(nDate: Date) strDate: Text[30]
    var
        lDay: Integer;
        lMonth: Integer;
        lYear: Integer;
        strDay: Text[4];
        StrMonth: Text[20];
        strYear: Text[6];
    begin
        //this function converts the date to the format required by ksps
        lDay:=Date2DMY(nDate,1);
        lMonth:=Date2DMY(nDate,2);
        lYear:=Date2DMY(nDate,3);

        if lDay=1 then begin strDay:='1st' end;
        if lDay=2 then begin strDay:='2nd' end;
        if lDay=3 then begin strDay:='3rd' end;
        if lDay=4 then begin strDay:='4th' end;
        if lDay=5 then begin strDay:='5th' end;
        if lDay=6 then begin strDay:='6th' end;
        if lDay=7 then begin strDay:='7th' end;
        if lDay=8 then begin strDay:='8th' end;
        if lDay=9 then begin strDay:='9th' end;
        if lDay=10 then begin strDay:='10th' end;
        if lDay=11 then begin strDay:='11th' end;
        if lDay=12 then begin strDay:='12th' end;
        if lDay=13 then begin strDay:='13th' end;
        if lDay=14 then begin strDay:='14th' end;
        if lDay=15 then begin strDay:='15th' end;
        if lDay=16 then begin strDay:='16th' end;
        if lDay=17 then begin strDay:='17th' end;
        if lDay=18 then begin strDay:='18th' end;
        if lDay=19 then begin strDay:='19th' end;
        if lDay=20 then begin strDay:='20th' end;
        if lDay=21 then begin strDay:='21st' end;
        if lDay=22 then begin strDay:='22nd' end;
        if lDay=23 then begin strDay:='23rd' end;
        if lDay=24 then begin strDay:='24th' end;
        if lDay=25 then begin strDay:='25th' end;
        if lDay=26 then begin strDay:='26th' end;
        if lDay=27 then begin strDay:='27th' end;
        if lDay=28 then begin strDay:='28th' end;
        if lDay=29 then begin strDay:='29th' end;
        if lDay=30 then begin strDay:='30th' end;
        if lDay=31 then begin strDay:='31st' end;

        if lMonth=1 then begin StrMonth:=' January ' end;
        if lMonth=2 then begin StrMonth:=' February ' end;
        if lMonth=3 then begin StrMonth:=' March ' end;
        if lMonth=4 then begin StrMonth:=' April ' end;
        if lMonth=5 then begin StrMonth:=' May ' end;
        if lMonth=6 then begin StrMonth:=' June ' end;
        if lMonth=7 then begin StrMonth:=' July ' end;
        if lMonth=8 then begin StrMonth:=' August ' end;
        if lMonth=9 then begin StrMonth:=' September ' end;
        if lMonth=10 then begin StrMonth:=' October ' end;
        if lMonth=11 then begin StrMonth:=' November ' end;
        if lMonth=12 then begin StrMonth:=' December ' end;

        strYear:=Format(lYear);
        //return the date
        strDate:=strDay + StrMonth + strYear;
    end;
}

