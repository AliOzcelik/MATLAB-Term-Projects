clear
clc
exc = readtable('InputData.xlsx');
exc = sortrows(exc,"Day");
names = exc(:,2);
surnames = exc(:,3);
day = exc(:,4);
duration = exc(:,5);
available_start = exc(:,6);
available_finish = exc(:,7);
priority = exc(:,8);
schedule = cell(3,3); % fist index is number of rooms, third index is number of days
num_days = 5;
num_priority = 4;
num_rooms = 3;
final = cell(5,1);
d = cell(5,1);
asd = cell(5,1);
daily_planning_horizon = Interval(0,480);
sch = Schedule(daily_planning_horizon,num_days,num_rooms,final);
previous_intervals = [];
for i = 1:num_days
    tomorrow = cell(5,20);
    final2 = cell(3,10);
    exc2 = exc(day{:,:} == i,:); % exc2 is the table of patients belongs to that day
    pr = exc2(:,"Priority"); % pr is the table of patients' priority
    sch = Schedule(daily_planning_horizon,num_days,num_rooms,final); % schedule object is created
    
    for x = 0:num_priority
    ex = exc2(pr{:,:} == x,:);
    m = height(ex);
    starts = cell(height(ex),2);
    j = 1;
    while j <= m
        available_interval = Interval(table2array(ex(j,"AvailableStart")),table2array(ex(j,"AvailableFinish")));
        dur = table2array(ex(j,"Duration"));
        Id = table2array(ex(j,"ID"));
        max_start = available_interval.right - dur;
        starts{j,1} = Id;
        starts{j,2} = max_start;
        j = j + 1;
    end
    starts = sortrows(starts,2);
    t = 1;
    c = 1; a = 1;
    l1 = 1; l2 = 1; l3 = 1;
    while t <= m
        
        Id_2 = starts{t,1};
        w = 1;
        while true
            Id = table2array(ex(w,"ID")); % w is the index number of the required patient
            if Id_2 == Id
                break
            else
                w = w + 1;
            end
        end
        max_start_2 = starts{t,2};
        available_interval = Interval(table2array(ex(w,"AvailableStart")),table2array(ex(w,"AvailableFinish")));
        dur = table2array(ex(w,"Duration"));
        the_patient = Patient(ex(w,"Name"),ex(w,"Surname"),ex(w,"Priority"),ex(w,"Day")); % patient object is created
        v = 1;
        while true
            if table2array(ex(w,"ID")) == table2array(exc(v,"ID"))
                break
            else
                v = v + 1;
            end
        end
        k1 = 0; k2 = 0; k3 = 0;
        if c == 1
                while isempty(final2{1,l1}) == 0
                    l1 = l1 + 1;
                end
                % fprintf('l1 = %d\n',l1)
                if k1 <= available_interval.left
                    sch_interval = Interval(available_interval.left, available_interval.left + dur);
                    k1 = sch_interval.right;
                    the_operation = Operation(Id,the_patient,available_interval,sch_interval,dur,i);
                    final2{1,l1} = {the_operation};
               else
                    if (k1 + dur) < available_interval.right
                        sch_interval = Interval(k1, k1+dur);
                        k1 = sch_interval.right;
                        the_operation = Operation(Id,the_patient,available_interval,sch_interval,dur,i);
                        final2{1,l1} = {the_operation};                    
                    else
                        if i ~= 5
                        tomorrow{a} = Id;
                        a = a + 1;
                        disp(exc(v,:))
                        exc(v,"Priority") = {0};
                        exc(v,"Day") = {table2array(ex(w,"Day")) + 1};
                        disp(exc(v,:))
                        end
                    end
                end
            elseif c == 2
                while isempty(final2{2,l2}) == 0
                    l2 = l2 + 1;
                end
                % fprintf('l2 = %d\n',l2)
                if k2 <= available_interval.left
                    sch_interval = Interval(available_interval.left, available_interval.left + dur);
                    k2 = sch_interval.right;
                    the_operation = Operation(Id,the_patient,available_interval,sch_interval,dur,i);
                    final2{2,l2} = {the_operation};                    
                else
                    if (k2 + dur) < available_interval.right
                        sch_interval = Interval(k2, k2+dur);
                        k2 = sch_interval.right;
                        the_operation = Operation(Id,the_patient,available_interval,sch_interval,dur,i);
                        final2{2,l2} = {the_operation};
                    else
                        if i ~= 5
                        tomorrow{a} = Id;
                        a = a + 1;
                        disp(exc(v,:))
                        exc(v,"Priority") = {0};
                        exc(v,"Day") = {table2array(ex(w,"Day")) + 1};
                        disp(exc(v,:))
                        end
                    end
                end 
        else 
                while isempty(final2{3,l3}) == 0
                    l3 = l3 + 1;
                end
                % fprintf('l3 = %d\n',l3)
                
                if k3 <= available_interval.left
                    sch_interval = Interval(available_interval.left, available_interval.left + dur);
                    k3 = sch_interval.right;
                    the_operation = Operation(Id,the_patient,available_interval,sch_interval,dur,i);
                    final2{3,l3} = {the_operation};
                else
                    if (k3 + dur) < available_interval.right
                        sch_interval = Interval(k3, k3+dur);
                        k3 = sch_interval.right;
                        the_operation = Operation(Id,the_patient,available_interval,sch_interval,dur,i);
                        final2{3,l3} = {the_operation};
                        
                    else
                        if i ~= 5
                        tomorrow{a} = Id;
                        a = a + 1;
                        disp(exc(v,:))
                        exc(v,"Priority") = {0};
                        exc(v,"Day") = {table2array(ex(w,"Day")) + 1};
                        disp(exc(v,:))
                        end
                    end    
                end

        end
        % fprintf('c = %d\n',c);
            c = c + 1;
            if rem(c,4) == 0
                c = 1;
            end
        % sch_interval = Interval(available_interval.left,available_interval.left + dur);
        the_operation = Operation(Id,the_patient,available_interval,sch_interval,dur,i);
        
        % k = sch_interval.right;
        t = t + 1;
    end

    end
    b = 0;
for s = 1:3    
while true
        f = 1;
        while true
            if isempty(final2{s,f}{1,1}) == 0
                break
            else
                if final2{s,f}{1,1}.scheduledInterval.left > final2{s,f+1}{1,1}.scheduledInterval.left
                    temp = final2{s,f};
                    final2{s,f} = final2{s,f+1};
                    final2{s,f+1} = temp;
                    b = 1;
                end

            end
            f = f + 1;
        end
    
    
    if b == 0
        break
    end
end
end
    final{i} = final2;
end