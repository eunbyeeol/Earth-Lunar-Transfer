function [y,min_distance,T] = EorbitRK4(dt,y0,lunar_posATinj,lunar_SOI)

    mu_earth                    =   398600;
    y(:,1) = y0;
    i = 2;
    distance = sqrt(lunar_posATinj' * lunar_posATinj);
    min_distance = distance;

    while true
        % 1'st Order
        r1 = y(1:3,i-1);
        v1 = y(4:6,i-1);
        a1 = - mu_earth / sqrt( r1' * r1 ) ^ 3 * r1;
        % k1 = dt*[v1;a1];
    
        % 2'nd Order
        r2 = r1+0.5*v1*dt;
        v2 = v1+0.5*a1*dt;
        a2 = - mu_earth / sqrt( r2' * r2 ) ^ 3 * r2;
        % k2 = dt*[v2;a2];
    
        % 3'rd Order
        r3 = r1+0.5*v2*dt;
        v3 = v1+0.5*a2*dt;
        a3 = - mu_earth / sqrt( r3' * r3 ) ^ 3 * r3;
        % k3 = dt*[v3;a3];
    
        % 4'th Order
        r4 = r1+v3*dt;
        v4 = v1+a3*dt;
        a4 = - mu_earth / sqrt( r4' * r4 ) ^ 3 * r4;
        % k4 = dt*[v4;a4];
    
        % Sum Orders
        kk = 2*r2 + 4*r3 + (2*v3 + v4)*dt;
        y(:,i) = [kk ; 2*v2 + 4*v3 + (2*a3 + a4)*dt]/6;
        % y(:,i) = y(:,i-1) + [v1+2*v2+2*v3+v4;a1+2*a2+2*a3+a4]*dt/6;
        % y(:,i) = y(:,i-1) + (k1 + 2*k2 + 2*k3 + k4) / 6;
        % End RK4

        pre_distance = distance;

        vectorfromLunar = lunar_posATinj-kk/6;
        % vectorfromLunar = lunar_posATinj-y(1:3,i);
        distance = sqrt(vectorfromLunar' * vectorfromLunar)-lunar_SOI; 

            if distance < min_distance
                min_distance = distance;
            end
    
            if distance > pre_distance
                y = y(:,1:end-1);
                T = (i-2)*dt;
                break;
            end

        i = i+1;
    end

end