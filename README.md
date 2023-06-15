# SchoolChoiceModel
Tarea de Econometría que busca estimar un modelo de elección de colegios. Queremos estimar los efectos que tienen variables de interés para los hogares en su elección de los colegios a postular como primera preferencia. Para eso tenemos una muestra de 42 establecimientos y al rededor de 1000 estudiantes

El procedimiento es el siguiente:

Contamos con $\{i\}_{i=1}^n$ estudiantes y $\{j\}_{j=1}^J$ colegios. Cada estudiante tiene una utilidad latente $U_{i,j}$ que está en función de una serie de variables de interés $X_{i,j}$ que competen al estudiante y el colegio. Para entender la idea principal $x_{i,j}$ será la **distancia que existe entre los colegios**. Podemos esperar que mientras más distancia haya entre un colegio y el hogar de un estudiante menor será su utilidad de estudiar allí. Así $U_{i,j}=\beta x_{i,j}+\varepsilon_j$ (más adelante incluiremos más variables). 

De estas utilidades latentes $Y_{a,b} = \begin{matrix} 1 & U_{a,b}=\max\{U_{a,j}\} \\ 0 & \text{en otro caso}\end{matrix}$. Es decir, la variable $Y_{i,j}$ será $1$ si la utilidad latente que tiene un estudiante $i$ de asistir a un $j$ colegios es la mayor entre todos los colegios, sino será $0$. Estamos proponiendo que los alumnos ponen como primera preferencia aquel colegio que les genera más utilidad.

El modelo Logit nos dice que si asumimos $\varepsilon_j$ i.i.d. entonces la probabilidad de que seleccione un establecimiento $j$ es $P_{i,j}(x)=\frac{e^{\beta x_{i,j}}}{\sum_{k=1}^Je^{\beta x_{i,k}}}$. Es decir $P(Y_{i,j}=1)=\frac{e^{\beta x_{i,j}}}{\sum_{k=1}^Je^{\beta x_{i,k}}}$. Con ello, la función de probabilidad cumulativa conjunta y a la vez, función de log verosimilitud, será $$\ell_n(\theta)=\sum_{i=1}^n\sum_{j=1}^JY_{i,j}\ln(\frac{e^{\beta x_{i,j}}}{1+\sum_{k=1}^Je^{\beta x_{i,k}}})$$

Para buscar computacionalmente el valor que buscamos el algortimo de N-R nos comienza calculando nivel de 
