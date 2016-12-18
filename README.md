# Snakasm

Integrantes y grupo.

Rayniel Ramos Gonzalez C212

Describir todo lo que se realizó en el proyecto, dejando claro cuáles fueron las características que se implementaron.

Implemente las funcionalidades basicas, ademas de la funcionalidad de deficultades, la cual es accesible en el segundo menu, en dependencia de la dificultad escogida sera la velocidad de la serpiente y ademas el tiempo en el que se pierde puntos, se halla comido o no una fruta, pense en hacer esta pequena modificacion a la parte del tiempo porque me parecio que agregaba mas complejidad que disminuir los puntos si no se ha comido una fruta, no obstante esto se puede hacer sin modificar demasiado el codigo, o sea en la parte de dificultad implemente la parte relacionada con la velocidad de la serpiente y el tiempo, los dos son implementaciones adicionales. Implemente tambien los niveles fijos, tengo cuatro, ademas de un nivel aleatorio. Hice tambien la pantalla de bienvenida utilizando el ascii art, y la alta puntuacion, un score board que lleva entre juego y juego las cuatro puntuaciones mas altas obtenidas. Agregue sonido ademas, tres sonidos distintos, uno al arrancar el juego, otro para comenzar a jugar y otro a la hora de perder.

Para la parte del video disene una funcion que pinta un caracter en la pantalla en la fila, columna que se le pase, pinta un caracter con un background, foreground y el caracter que se le diga (ninguna de las funciones que disene, en ningun modulo del proyecto verifica que se le esten pasando argumentos validos, eso es responsabilidad de quien las vaya a usar, o sea, mia), luego sobre esta funcion disene funciones que pinta lineas verticales, horizontales y diagonales, que tienen como base llamar a la funcion que pone un caracter, estas funciones las utilize principalmente para el ascii art, despues se me ocurrio hacer el ascii art utilizando strings, pero solo despues que ya habia implementado este metodo que es un tanto complicado, asi que decidi dejarlo tal cual, tembien hice una funcion que se encarga de escribir en la pantalla un texto, la funcion que pinta un tablero en la pantalla, la que te dibuja un numero en la pantalla. Estas son las funciones mas importantes con las que trabajo en el video.

En el modulo de tools hice una sencilla funcion para hallar el minimo de un array y otro que agrega a un array un numero en la posicion del menor elemento siempre y cuando este numero sea mayor que el menor elemento.

En el modulo de textos estan todos los textos de juego, decidi separarlos puesto que ocupaban muchas lineas de codigo que no ayudaban con la legibilidad en otros modulos, ahi solo se le pasa el texto a la funcion encargada de pintarlo en la pantalla.

En el modulo de sonido estan  las funciones que se encargan de encender el speaker y apagarlo asi como los tres sonidos que implemente, y la funcion encargada de poner el sonido dado una frecunecia.

En el modulo de los mapas estan separados en funciones los niveles, cada funcion crea en memoria un mapa distinto.

En el modulo del keyboard estan las funciones que trabajan con el menu, son las encargadas de retornar la opcion del menu que se utilizo, y de trbajar con el puntero de los menus.

En el modulo de la logica puse las funciones que se encargan de poner en una matriz en la memoria un valor en una fila, columna, ademas de las funciones que hacen en una matriz en memoria, lineas horizontales y verticales. Hice una funcion 'booleana' para saber si dada una fila, columna se encuentra dentro de los limites de una matriz, otra que me permite saber si ademas de estar dentro de los limites la fila, columna que le paso esta ocupada, implmente la funcion que se encarga de disminuir en uno todos los numeros entre 0 y 254, esta es crucial para mover la serpiente, tambien en el modulo esta la funcion que busca el mayor valor entre 0 y 254, esta la utilizo para saber en donde esta la cabeza de la serpiente que es la que vamos a mover, en el modulo esta tambien la funcion que se encarga de mover la cabeza a una nueva posicion y de mover la serpiente en dependencia si se comio una fruta o no, estan las funciones que se encargan de mover hacia las cuatro direcciones y la funcion que se encarga de poner una fruta random, esta la funcion que incrementa la puntuacion y la que la decrementa, y ademas la funcion que mueve sola la serpiente si esta no ha sido movida por las teclas.

En el game esta la funcion que reinicializa todas las variables para volver a empezar el juego y la funcion del game over.

Para 'bindear' las teclas y cambiar entre las diferentes partes del juego uso un sistema de 'paginas', en dependencia de la pagina en la que estemos se ejecutara una parte del programa dentro del gameloop y se 'bindearan' las teclas que sean necesarias en esa parte.

Para más información acerca de la orientación del proyecto ir a [ORIENTACIÓN.md](ORIENTACIÓN.md)
