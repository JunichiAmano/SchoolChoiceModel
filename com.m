clc
clear

pkg load mapping                                                                     % paquete de octave (matlab gratuito) para calcular distancias

dlmread 'base_colegios.csv' ;                                                        % importar base colegios
colegios = ans(2:end,:) ;                                                            % sacar fila con nombres de variables
ans = colegios(:,7:8) ;                                                              %
colegios(:,7:8) = ans ;                                                              %
colegios = colegios(:,1:end-2) ;                                                     % sacar columnas missing_prom


dlmread 'base_postulantes.csv' ;                                                     % importar base postulantes
postulantes = ans(2:end,:) ;                                                         % sacar fila con nombres
ans = postulantes(:,9) ;                                                             %
postulantes = postulantes(:,1:end-2) ;                                               %
postulantes(:,7:end) = ans ;                                                         % sacar columnas nivel y tipo de prioridad

bas = [repelem(colegios,rows(postulantes),1) repmat(postulantes,rows(colegios),1)] ; % juntar base como datos de panel

y = bas(:,1) == bas(:,14) ;                                                          % crear dummy 'y' de eleccion de colegios
dist = deg2km(distance(bas(:,5),bas(:,6),bas(:,12),bas(:,13)))' ;                    % calcular distancias entre hogares y colegios
simce = bas(:,7) + bas(:,8)/2 ;                                                      % calcular promedio simce matemáticas y simce lenguaje
%bas = bas((bas(:,4)==bas(:,3)|(bas(:,10)==bas(:,4)==1)|(bas(:,10)==0&bas(:,5)==1)),:) ;% eliminar opciones inviables (mujeres en colegios de hombres y hombres en colegios de mujeres)

%x = [dist simce bas(:,2) bas(:,11)] ;                                                % regresores: distancia; simce; copago; prioridad

%bi = (x'*x)\(x'*y)                                                                   % regresion preliminar para obtener betas de inicio

x = [simce dist bas(:,2)] ;
bi = (x'*x)\(x'*y) ;
tol = 10^(-6) ;

n = rows(postulantes) ;
J = rows(colegios) ;

x = permute(x, [1, 3 , 2]) ;
x = reshape(x, [n , J , length(x(1,1,:))]) ;

y = reshape(y, [n , J]) ;

bh = bi ;


for h = 1:100

bi = bh ;


  for l = 1:length(x(1,1,:))

    M = zeros(n, 1) ;
    for i = 1:n
        sum1 = 0;
        sum2 = 0;
        for k = 1:J
            sum1 = sum1 + x(i, k, l) * exp(x(i, k,:)*bi);
            sum2 = sum2 + exp( x(i, k, :)*bi);
        end
        M(i) = sum1 / (sum2);
    end

    G(l) = sum(sum(y.*(x(:,:,l) - repmat(M,1,length(x(1,:,l)))))) ;




    for ll = 1:length(x(1,1,:))
    M = zeros(n, 1);
    N = zeros(n, 1);

    for i = 1:n
        sum1_M = 0;
        sum2_M = 0;
        sum1_N = 0;
        sum2_N = 0;
        sum3_N = 0;
        for k = 1:J
            sum1_M = sum1_M + x(i, k,l)*x(i,k,ll) * exp(x(i, k,:)*bi );
            sum2_M = sum2_M + exp(x(i, k,:)*bi);
            sum1_N = sum1_N + x(i, k,l) * exp(x(i, k,:)*bi);
            sum3_N = sum3_N + x(i, k,ll) * exp(x(i, k,:)*bi);
            sum2_N = sum2_N + exp(x(i, k,:)*bi);
        end
        M(i) = sum1_M / (sum2_M);
        N(i) = sum1_N*sum3_N / (sum2_N)^2;
    end

    H = 0;
    for i = 1:n
        for j = 1:J
            H = H - y(i, j) * (M(i) - N(i)) ;
        end
    end
    HH(l,ll) = H ;
    end
  end

    bh = bi + (-HH)^(-1)*G'

    if abs(bh - bi) < tol
      break
    endif

    if H = 0 ;
      break
    endif

end


