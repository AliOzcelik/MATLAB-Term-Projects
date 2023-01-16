%Case
clear
clc
N =  20; % input("Enter a grid size: ");
people = 240; % input("Enter a people number: ");
infection_numbers = (people / 20);
my_grid = zeros(N,N);    
M = 120; % input("Enter iterations number: ");
vac_iso_row = [];
vac_iso_col = [];
vac_iso_bound_row = [];
vac_iso_bound_col = [];
vac_iso_times = [];
vac_inf_row = [];
vac_inf_col = [];
vac_inf_times = [];
total_vac_dead = 0;
total_vac_dead_arr = [];
isolated_row = [];
isolated_col = [];
iso_bound_row = [];
iso_bound_col = [];
healthy_row = [];
healthy_col = [];
infected_row = [];
infected_col = [];
immunity_row = [];
immunity_col = [];
dead_number = 0;
vaccinated_row = [];
vaccinated_col = [];
vaccinated = 0;
p = 0.5;
qs = 0.8;
ts = 20;
tv = ts;
rs = 0.05;
iso_iteration = 30;
new_infected_array = [];
total_infected_array = [];
total_infected = 0;
total_dead = [];
new_healed_array = [];
total_healed_array = [];
total_healed = 0;
deads = [];
% an array built to hold how many iterations each isolated is isolated
iso_times = [];
inf_times = [];
for k = 1:people-infection_numbers

    healthy_row(k) = ceil(N*rand());
    healthy_col(k) = ceil(N*rand());
    if k == 1
        my_grid(healthy_row(1),healthy_col(1)) = 1;
        continue
    else
       for j = 1:k-1     
            while (healthy_row(k) == healthy_row(j)) && (healthy_col(k) == healthy_col(j))
                healthy_row(k) = ceil(N*rand());
                healthy_col(k) = ceil(N*rand());
            end
       end
    end
    my_grid(healthy_row(k),healthy_col(k)) = 1;
end
i = 1;
while i <= (infection_numbers/2)
    while true
    infected_row(i) = ceil(N*rand());
    infected_col(i) = ceil(N*rand());
    
        if my_grid(infected_row(i),infected_col(i)) == 0
            if i == 1
                my_grid(infected_row(1),infected_col(1)) = 2;
                break
            else
               for j = 1:i-1     
                    while (infected_row(i) == infected_row(j)) && (infected_col(i) == infected_col(j))
                        infected_row(i) = ceil(N*rand());
                        infected_col(i) = ceil(N*rand());
                    end
               end
               for j = 1:length(healthy_col)
                   while (infected_row(i) == healthy_row(j)) && (infected_col(i) == healthy_col(j))
                        infected_row(i) = ceil(N*rand());
                        infected_col(i) = ceil(N*rand());
                   end
               end
               my_grid(infected_row(i),infected_col(i)) = 2;
               break
            end
            
        else
            continue
        end
        
    end
    i = i + 1;
end
i = 1;
while i <= (infection_numbers/2)
    while true
    a = ceil(N*rand());
    b = ceil(N*rand());
    isolated_row(i) = a;
    isolated_col(i) = b;
    iso_bound_row(i) = a;
    iso_bound_col(i) = b;
        if my_grid(isolated_row(i),isolated_col(i)) == 0
            if i == 1
                my_grid(isolated_row(1),isolated_col(1)) = 3;
                break
            else
               for j = 1:i-1     
                    while (isolated_row(i) == isolated_row(j)) && (isolated_col(i) == isolated_col(j))
                        a = ceil(N*rand());
                        b = ceil(N*rand());
                        isolated_row(i) = a;
                        isolated_col(i) = b;
                        iso_bound_row(i) = a;
                        iso_bound_col(i) = b;
                    end
               end
               for j = 1:length(healthy_col)
                   while (isolated_row(i) == healthy_row(j)) && (isolated_col(i) == healthy_col(j))
                        a = ceil(N*rand());
                        b = ceil(N*rand());
                        isolated_row(i) = a;
                        isolated_col(i) = b;
                        iso_bound_row(i) = a;
                        iso_bound_col(i) = b;
                   end
               end
               for j = 1:length(infected_col)
                   while (isolated_row(i) == infected_row(j)) && (isolated_col(i) == infected_col(j))
                        a = ceil(N*rand());
                        b = ceil(N*rand());
                        isolated_row(i) = a;
                        isolated_col(i) = b;
                        iso_bound_row(i) = a;
                        iso_bound_col(i) = b;
                   end
               end
               my_grid(isolated_row(i),isolated_col(i)) = 3;
               break
            end
        else
            continue
        end
    end
    i = i + 1;
end

disp(my_grid);
for t = 1:M
vac_dead = 0;
newly_infected = 0;
newly_healed = 0;
newly_dead = 0;
infection_numbers = length(infected_col) + length(isolated_col);
if t >= ts % vaccination starts
b = people - infection_numbers;
rate = (1/(2 * (tv - 19)));
rate2 = rate * b;
k = 1;
while k <= rate2 % vaccinating healthy people
    if length(healthy_col) > k
        vaccinated_col(end+1) = healthy_col(k);
        vaccinated_row(end+1) = healthy_row(k);
        healthy_row(k) = [];
        healthy_col(k) = [];
        k = k + 1;
    else
        break
    end
end
end
tv = tv + 1;
x = 1;
while x <= length(vaccinated_col) % movement of the vaccinated
    my_grid(vaccinated_row(x),vaccinated_col(x)) = 0;
    [vaccinated_row(x),vaccinated_col(x)] = HealthyMovement(vaccinated_row(x),vaccinated_col(x),N);
    if (my_grid(vaccinated_row(x),vaccinated_col(x)) == 2) || (my_grid(vaccinated_row(x),vaccinated_col(x)) == 3)
        c = rand();
        if c < rs
            newly_infected = newly_infected + 1;
        if rand < qs
            vac_iso_col(end+1) = vaccinated_col(x);
            vac_iso_row(end+1) = vaccinated_row(x);
            vac_iso_bound_row(end+1) = vaccinated_row(x);
            vac_iso_bound_col(end+1) = vaccinated_col(x);
            vaccinated_row(x) = [];
            vaccinated_col(x) = [];
            x = x - 1;
        else
            vac_inf_row(end+1) = vaccinated_row(x);
            vac_inf_col(end+1) = vaccinated_col(x);
            vaccinated_row(x) = [];
            vaccinated_col(x) = [];
            x = x - 1;
        end
        end
    else
        my_grid(vaccinated_row(x),vaccinated_col(x)) = 1;
    end
    x = x + 1;
end
j = 1;
while j <= length(healthy_col)
    my_grid(healthy_row(j),healthy_col(j)) = 0;
    [healthy_row(j),healthy_col(j)] = HealthyMovement(healthy_row(j),healthy_col(j),N);
    if my_grid(healthy_row(j),healthy_col(j)) == 2 || (my_grid(healthy_row(j),healthy_col(j)) == 3)
        if rand < p
            newly_infected = newly_infected + 1;
        if rand < qs        %isolation check
            isolation = true;
            my_grid(healthy_row(j),healthy_col(j)) = 3;
            isolated_row(end+1) = healthy_row(j);
            isolated_col(end+1) = healthy_col(j);
            iso_bound_row(end+1) = healthy_row(j);
            iso_bound_col(end+1) = healthy_col(j);
            healthy_row(j) = [];
            healthy_col(j) = [];
            j = j - 1;
        else
            isolation = false;
            infected_row(end+1) = healthy_row(j);
            infected_col(end+1) = healthy_col(j);
            my_grid(healthy_row(j),healthy_col(j)) = 2;
            healthy_row(j) = [];
            healthy_col(j) = [];
        end
        end
    
    elseif my_grid(healthy_row(j),healthy_col(j)) == 0 
        my_grid(healthy_row(j),healthy_col(j)) = 1;
    end
    
    j = j + 1;
end
i = 1;
while i <= length(infected_col)
    my_grid(infected_row(i),infected_col(i)) = 0;
    [infected_row(i),infected_col(i)] = InfectedMovement(infected_row(i),infected_col(i),N);
    if my_grid(infected_row(i),infected_col(i)) == 1
        if length(healthy_col) > 0
        b = 1;
        num = 0;
        num3 = 0;
        while b <= length(healthy_col)
            if (infected_col(i) == healthy_col(b)) && (infected_row(i) == healthy_row(b))
                num = b;
                % num is the index of the healthy person coincide with an
                % infected
                break
            end
            b = b + 1;
        end
        
        if num ~= 0 % coincided person is not immuned, but just an healthy person
         a = rand();
         if rand < p % infection check
             newly_infected = newly_infected + 1;
         if a < qs        %isolation check
            isolation = true;
            my_grid(infected_row(i),infected_col(i)) = 3;
            isolated_row(end+1) = healthy_row(num);
            isolated_col(end+1) = healthy_col(num);
            iso_bound_row(end+1) = healthy_row(num);
            iso_bound_col(end+1) = healthy_col(num);
            healthy_row(num) = [];
            healthy_col(num) = [];
        else
            infected_row(end+1) = healthy_row(num);
            infected_col(end+1) = healthy_col(num);
            healthy_row(num) = [];
            healthy_col(num) = [];
            isolation = false;
         end
         end
        
        else % person doesn't belong to healthy, either vaccinated or immuned
            b = 1;
            if length(vaccinated_row) > 0
            while b <= length(vaccinated_col)
                if (infected_col(i) == vaccinated_col(b)) && (infected_row(i) == vaccinated_row(b))
                    num3 = b;
                    % num3 is the index of the vaccinated person coincide with an
                    % infected
                    break
                end
                b = b + 1;
            end
            end
            if num3 ~= 0 % person is vaccinated but not immuned
                c = rand();
                if rand < rs
                    newly_infected = newly_infected + 1;
                if c < qs % person will be isolated
                    vac_iso_row(end+1) = vaccinated_row(num3);
                    vac_iso_col(end+1) = vaccinated_col(num3);
                    vac_iso_bound_row(end+1) = vaccinated_row(num3);
                    vac_iso_bound_col(end+1) = vaccinated_col(num3);
                    vaccinated_row(num3) = [];
                    vaccinated_col(num3) = [];
                else 
                    vac_inf_row(end+1) = vaccinated_row(num3);
                    vac_inf_col(end+1) = vaccinated_col(num3);
                    vaccinated_row(num3) = [];
                    vaccinated_col(num3) = [];
                end
                end
            end
        end        
        end
    else
        my_grid(infected_row(i),infected_col(i)) = 2;
    end
    
    i = i + 1;
end
% a loop to check the infection times

veli = 1;
while veli <= length(infected_col) % infecteds will be healed or dead
       
    if veli > length(inf_times)        
        inf_times(end+1) = 1;
    else
        inf_times(veli) = inf_times(veli) + 1;
    end
        if inf_times(veli) == iso_iteration
                w = rand();
                if w < q
                    immunity_col(end+1) = infected_col(veli);
                    immunity_row(end+1) = infected_row(veli);
                    my_grid(infected_row(veli),infected_col(veli)) = 1;
                    inf_times(veli) = [];
                    infected_row(veli) = [];
                    infected_col(veli) = [];
                    newly_healed = newly_healed + 1;
                else
                    my_grid(infected_row(veli),infected_col(veli)) = 0;
                    inf_times(veli) = [];
                    infected_row(veli) = [];
                    infected_col(veli) = [];
                    dead_number = dead_number + 1;
                    newly_dead = newly_dead + 1;
                end
                veli = veli - 1;
        end
        veli = veli + 1;
end
l = 1;
q = 0.95; % healing probability
while l <= length(isolated_row)
    my_grid(isolated_row(l),isolated_col(l)) = 0;
    [isolated_row(l),isolated_col(l)] = IsolatedMovement(isolated_row(l),isolated_col(l),iso_bound_row(l),iso_bound_col(l),N);
    if (isolated_row(l) < 1)
        isolated_row(l) = 1;
    elseif isolated_col(l) < 1
        isolated_col(l) = 1;
    elseif isolated_row(l) > 20
        isolated_row(l) = 20;
    elseif isolated_col(l) > 20
        isolated_col(l) = 20;
    end
    my_grid(isolated_row(l),isolated_col(l)) = 3;
    l = l + 1;
end
ali = 1;
    % a loop to check the isolation times
    while ali <= length(isolated_col)
        if ali > length(iso_times)
            iso_times(ali) = 1;
        else
            iso_times(ali) = iso_times(ali) + 1;
        
            if iso_times(ali) == iso_iteration
                iso_times(ali) = [];
                w = rand();
                if w < 0.95
                    immunity_col(end+1) = isolated_col(ali);
                    immunity_row(end+1) = isolated_row(ali);
                    my_grid(isolated_row(ali),isolated_col(ali)) = 1;
                    isolated_row(ali) = [];
                    isolated_col(ali) = [];
                    iso_bound_col(ali) = [];
                    iso_bound_row(ali) = [];
                    newly_healed = newly_healed + 1;
                else
                    my_grid(isolated_row(ali),isolated_col(ali)) = 0;
                    isolated_row(ali) = [];
                    isolated_col(ali) = [];
                    iso_bound_col(ali) = [];
                    iso_bound_row(ali) = [];
                    dead_number = dead_number + 1;
                    newly_dead = newly_dead + 1;
                end
                ali = ali - 1;
            end
        end

        ali = ali + 1;
    end
e = 1;
i = 1;
while i <= length(vac_inf_col)
    my_grid(vac_inf_row(i),vac_inf_col(i)) = 0;
    [vac_inf_row(i),vac_inf_col(i)] = InfectedMovement(vac_inf_row(i),vac_inf_col(i),N);
    if my_grid(vac_inf_row(i),vac_inf_col(i)) == 1
        if length(healthy_col) > 0
        b = 1;
        num = 0;
        num3 = 0;
        while b <= length(healthy_col)
            if (vac_inf_col(i) == healthy_col(b)) && (vac_inf_row(i) == healthy_row(b))
                num = b;
                % num is the index of the healthy person coincide with an
                % infected
                break
            end
            b = b + 1;
        end
        
        if num ~= 0 % coincided person is not immuned, but just an healthy person
         a = rand();
         if rand < p % infection check
             newly_infected = newly_infected + 1;
         if a < qs        %isolation check
            isolation = true;
            my_grid(vac_inf_row(i),vac_inf_col(i)) = 3;
            isolated_row(end+1) = healthy_row(num);
            isolated_col(end+1) = healthy_col(num);
            iso_bound_row(end+1) = healthy_row(num);
            iso_bound_col(end+1) = healthy_col(num);
            healthy_row(num) = [];
            healthy_col(num) = [];
        else
            infected_row(end+1) = healthy_row(num);
            infected_col(end+1) = healthy_col(num);
            healthy_row(num) = [];
            healthy_col(num) = [];
            isolation = false;
         end
         end
        
        else % person doesn't belong to healthy, either vaccinated or immuned
            b = 1;
            if length(vaccinated_row) > 0
            while b <= length(vaccinated_col)
                if (vac_inf_col(i) == vaccinated_col(b)) && (vac_inf_row(i) == vaccinated_row(b))
                    num3 = b;
                    % num3 is the index of the vaccinated person coincide with an
                    % infected
                    break
                end
                b = b + 1;
            end
            end
            if num3 ~= 0 % person is vaccinated but not immuned
                c = rand();
                if rand < rs
                    newly_infected = newly_infected + 1;
                if c < qs % person will be isolated
                    vac_iso_row(end+1) = vaccinated_row(num3);
                    vac_iso_col(end+1) = vaccinated_col(num3);
                    vac_iso_bound_row(end+1) = vaccinated_row(num3);
                    vac_iso_bound_col(end+1) = vaccinated_col(num3);
                    vaccinated_row(num3) = [];
                    vaccinated_col(num3) = [];
                else 
                    vac_inf_row(end+1) = vaccinated_row(num3);
                    vac_inf_col(end+1) = vaccinated_col(num3);
                    vaccinated_row(num3) = [];
                    vaccinated_col(num3) = [];
                end
                end
            end
        end        
        end
    else
        my_grid(vac_inf_row(i),vac_inf_col(i)) = 2;
    end
    
    i = i + 1;
end
veli = 1;
while veli <= length(vac_inf_col) % infecteds will be healed or dead
       
    if veli > length(vac_inf_times)        
        vac_inf_times(end+1) = 1;
    else
        vac_inf_times(veli) = vac_inf_times(veli) + 1;
    end
        if vac_inf_times(veli) == iso_iteration
                w = rand();
                if w < q
                    immunity_col(end+1) = vac_inf_col(veli);
                    immunity_row(end+1) = vac_inf_row(veli);
                    my_grid(vac_inf_row(veli),vac_inf_col(veli)) = 1;
                    vac_inf_times(veli) = [];
                    vac_inf_row(veli) = [];
                    vac_inf_col(veli) = [];
                    newly_healed = newly_healed + 1;
                else
                    my_grid(vac_inf_row(veli),vac_inf_col(veli)) = 0;
                    vac_inf_times(veli) = [];
                    vac_inf_row(veli) = [];
                    vac_inf_col(veli) = [];
                    dead_number = dead_number + 1;
                    newly_dead = newly_dead + 1;
                    vac_dead = vac_dead + 1;
                end
                veli = veli - 1;
        end
        veli = veli + 1;
end

v = 1;
while v <= length(vac_iso_col)
    my_grid(vac_iso_row(v),vac_iso_col(v)) = 0;
    [vac_iso_row(v),vac_iso_col(v)] = IsolatedMovement(vac_iso_row(v),vac_iso_col(v),vac_iso_bound_row(v),vac_iso_bound_col(v),N);
    if (vac_iso_row(v) < 1)
        vac_iso_row(v) = 1;
    elseif vac_iso_col(v) < 1
        vac_iso_col(v) = 1;
    elseif vac_iso_row(v) > 20
        vac_iso_row(v) = 20;
    elseif vac_iso_col(v) > 20
        vac_iso_col(v) = 20;
    end
    my_grid(vac_iso_row(v),vac_iso_col(v)) = 3;
    v = v + 1;
end

ali2 = 1;
while ali2 <= length(vac_iso_col) % checking if first vaccinated then isolated will die or not
    if ali2 > length(vac_iso_times)
        vac_iso_times(ali2) = 1;
    else
        vac_iso_times(ali2) = vac_iso_times(ali2) + 1;
    end
        if vac_iso_times(ali2) == iso_iteration
            vac_iso_times(ali2) = [];
            c = rand();
            if c < q
                immunity_row(end+1) = vac_iso_row(ali2);
                immunity_col(end+1) = vac_iso_col(ali2);
                my_grid(vac_iso_row(ali2),vac_iso_col(ali2)) = 1;
                vac_iso_col(ali2) = [];
                vac_iso_row(ali2) = [];
                newly_healed = newly_healed + 1;
            else
                vac_iso_col(ali2) = [];
                vac_iso_row(ali2) = [];
                vac_dead = vac_dead + 1;
                dead_number = dead_number + 1;
                newly_dead = newly_dead + 1;
            end
            ali2 = ali2 - 1;
        end
    ali2 = ali2 + 1;
end

while e <= length(immunity_row)
    my_grid(immunity_row(e),immunity_col(e)) = 0;
    [immunity_row(e),immunity_col(e)] = HealthyMovement(immunity_row(e),immunity_col(e),N);
    my_grid(immunity_row(e),immunity_col(e)) = 1;
    e = e + 1;
end

disp(my_grid)
total_infected = total_infected + newly_infected;
total_healed = total_healed + newly_healed;
new_infected_array(end+1) = newly_infected;
total_infected_array(end+1) = total_infected;
new_healed_array(end+1) = newly_healed;
deads(end+1) = newly_dead;
total_dead(end+1) = dead_number;
total_vac_dead = total_vac_dead + vac_dead;
total_vac_dead_arr(end+1) = total_vac_dead;
end
subplot(3,3,1),plot(1:120,new_infected_array),title("New Infected"),subplot(3,3,2),plot(1:120,total_infected_array),title("Total Infected"),subplot(3,3,3),plot(1:120,new_healed_array),title("New Healed"),subplot(3,3,4),plot(1:120,deads),title('deads in each iteration'),subplot(3,3,5),plot(1:120,total_dead),title('Total Dead'),subplot(3,3,6),plot(1:120,total_vac_dead_arr),title('Total vaccinated but dead')
