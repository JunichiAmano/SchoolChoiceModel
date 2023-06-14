clc
clear

pkg load mapping

dlmread 'base_colegios.csv' ;
colegios = ans(2:end,:) ;
ans = colegios(:,7:8) ;
% ans(colegios(:,7:8) == 0) = NaN ;
colegios(:,7:8) = ans ;
colegios = colegios(:,1:end-2) ;


dlmread 'base_postulantes.csv' ;
postulantes = ans(2:end,:) ;
ans = postulantes(:,9) ;
postulantes = postulantes(:,1:end-2) ;
postulantes(:,7:end) = ans ;

bas = [repelem(colegios,rows(postulantes),1) repmat(postulantes,rows(colegios),1)] ;

y = bas(:,1) == bas(:,14) ;
dist = deg2km(distance(bas(:,5),bas(:,6),bas(:,12),bas(:,13)))' ;
simce = bas(:,7) + bas(:,8)/2 ;
cmm = bas(:,4).*bas(:,10) ;
chh = bas(:,3).*(bas(:,10)==0) ;

x = [dist simce bas(:,2) bas(:,11) cmm chh] ;

(x'*x)\(x'*y) % regresión pool
