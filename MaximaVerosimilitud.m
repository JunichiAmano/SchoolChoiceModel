%% Pregunta 2: maxima verosimilitud

clear all
clc 
cd '/Users/catalinagomez/Documents/FEN/Econometr?a I ME/Tarea 4'

Dato=importdata('datos2.xlsx');

private=Dato.data.Hoja1(:,27);
chronic=Dato.data.Hoja1(:,28);
female=Dato.data.Hoja1(:,5);
income=Dato.data.Hoja1(:,4);
age=Dato.data.Hoja1(:,3);
docvis=Dato.data.Hoja1(:,2);
N=30124;
Y=docvis;
X=[private chronic female income];
tol=10^(-7);
K=5;

%MCO:

X1=[ones(N,1) X];

%% Iteracion
beta_mco=inv(X1'*X1)*(X1'*Y); 
beta_0=inv(X1'*X1)*(X1'*Y); 
iter=1000


for i=1:iter;
    
i
% Gradiente: 

aux1=X1'*Y;  %check

B=zeros(K,1);
for i=1:N;
   A=X1(i,:)'*exp(X1(i,:)*beta_0);
   B=B+A;
end

G=aux1- B;

% Hessiano:

D=zeros(K,K);
for i=1:N;
C= exp(X1(i,:)*beta_0)*X1(i,:)'*X1(i,:);
D= D+C;
end

H=-D;
%

beta=beta_0 + inv(-H)*G;


if  abs(beta-beta_0)<tol;
break;
end;

beta_0=beta;
end;


%Errores estandas
e=Y-X1*beta;
s2=(e'*e)/(N-K);
varbeta=s2*inv(X1'*X1);
e_estandarmv=sqrt(diag(varbeta));

u=Y-X1*beta_mco;
s2_mco=(u'*u)/(N-K);
varbeta_mco=s2_mco*inv(X1'*X1);
e_estandarmco=sqrt(diag(varbeta_mco));



 

