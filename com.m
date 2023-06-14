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
bas = bas((bas(:,4)==bas(:,3)|(bas(:,10)==bas(:,4)==1)|(bas(:,10)==0&bas(:,5)==1)),:) ;% eliminar opciones inviables (mujeres en colegios de hombres y hombres en colegios de mujeres)

x = [dist simce bas(:,2) bas(:,11)] ;                                                % regresores: distancia; simce; copago; prioridad

(x'*x)\(x'*y)                                                                        % regresion preliminar para obtener betas de inicio
