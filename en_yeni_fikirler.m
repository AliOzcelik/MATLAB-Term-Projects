clear
clc
exc = readtable('InputData.xlsx');
exc = sortrows(exc,"Day");
num_days = 5;
num_priority = 4;
num_rooms = 3;
final = cell(5,1); % final is the final schedule
daily_planning_horizon = Interval(0,480);
sch = Schedule(daily_planning_horizon,num_days,num_rooms,final);
tomorrow = [];
tomorrow2 = [];
tomorrow3 = [];
for i = 1:num_days
    today = zeros(num_rooms,481);
    tomorrow = [];
    tomorrow2 = [];
    tomorrow3 = [];
    day = exc(:,4);
    final2 = cell(num_rooms,15);
    exc2 = exc(day{:,:} == i,:); % exc2 is the table of patients belongs to that day
    starts = cell(height(exc2),2);
    ex = sortrows(exc2,"Priority");
    pr = ex(:,"Priority"); % pr is the table of patients' priority
    t = 1;
    k = 0;
    if table2array(ex(1,"Priority")) == 1
        k1 = 1;
        k = 1;
    elseif table2array(ex(1,"Priority")) == 0
        k1 = 0;
        k = 0;
    end
    while k <= 4
        
        if k1 == 0
            if k == 0
                starts2 = ex(pr{:,:} == k,:);
                starts3 = sortrows(starts2,"AvailableStart");
            else
                starts2 = ex(pr{:,:} == k,:);
                starts2 = sortrows(starts2,"AvailableStart");
                starts3 = [starts3;starts2];
            end

        elseif k1 == 1 
            if k == 1
                starts2 = ex(pr{:,:} == k,:);
                starts3 = sortrows(starts2,"AvailableStart");
            else
                starts2 = ex(pr{:,:} == k,:);
                starts2 = sortrows(starts2,"AvailableStart");
                starts3 = [starts3;starts2];
            end
        end
        k = k + 1;
    end
    if i == 1
        axe = starts3;
    end
    m = height(starts3);
    
        while t <= m
            j = 1;
            Id = table2array(starts3(t,"ID"));
            available_interval = Interval(table2array(starts3(t,"AvailableStart")),table2array(starts3(t,"AvailableFinish")));
            dur = table2array(starts3(t,"Duration"));
            the_patient = Patient(starts3(t,"Name"),starts3(t,"Surname"),starts3(t,"Priority"),starts3(t,"Day")); % patient object is created
            b = 0;
            while j <= num_rooms
                l = 1;
                while isempty(final2{j,l}) == 0 % l is the indx of the first empty place in the room
                    l = l + 1;
                end
                enes = available_interval.left;
                if available_interval.left == 0
                    enes = enes + 1;
                end
                while today(j,enes) == 1 % finds the index of the first empty place in the row
                    enes = enes + 1;
                end
                enes1 = enes;
                while today(j,enes) == 0
                    enes = enes + 1;
                    if enes == (enes1 + dur) || enes > 481
                        break
                    end
                end
                if (enes - enes1) >= dur
                    if enes1 >= available_interval.left && enes <= available_interval.right
                        sch_interval = Interval(enes1,enes);
                        the_operation = Operation(Id,the_patient,available_interval,sch_interval,dur,i);
                        final2{j,l} = {the_operation};
                        today(j,enes1:(enes-1)) = 1;
                        j = j +1;
                        b = 1;
                        break
                    end
                end
                
                j = j + 1;

            end
            if b == 0
                tomorrow(end+1) = Id;
                tomorrow2(end+1) = table2array(the_patient.priority);
                v = 1;
                while true
                    if Id == table2array(exc(v,"ID"))
                        break
                    end
                    v = v + 1;
                end
                exc(v,"Priority") = {0};
                exc(v,"Day") = {table2array(exc(v,"Day")) + 1};
                
            end
        t = t + 1;
        end
    starts4 = starts3;
    starts3 = {};
    final{i} = final2;
    
    sch = Schedule(daily_planning_horizon,num_days,num_rooms,final);
    disp(tomorrow)
    disp(tomorrow2)
end
