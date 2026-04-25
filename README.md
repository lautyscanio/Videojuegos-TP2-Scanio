# Un cheto perdido en el conurbano
Este es un juego que armé en Godot 4. Se trata de un empresario de traje que se tiene que meter en la villa porque le robaron un peso y el tipo no lo va a dejar pasar asi nomas. Es un beat 'em up clásico: vas avanzando y tenes que ir matando a todos los que se te cruzan hasta que llegas a pelear con el boss final.

## De qué trata la historia
La cosa es asi: a este empresario le sacaron la unica moneda de un peso que tenia encima. El tipo, por puro orgullo y para recuperar su capital, se manda a lo mas profundo del barrio a buscar al **Gran Linyera**. En su busqueda tiene que enfrentar a todos los cirujas protectores del gran linyera. Al final, despues de una pelea epica, recupera su peso y se puede ir tranquilo de vuelta a la oficina con su moneda.

## Cómo se juega
* **Caminar y saltar:** Usás las flechas del teclado (⬅️ ➡️ y ⬆️ para saltar).
* **Pegar:** Con la tecla **Q** pegás un batazo.
* **Disparar:** Con la tecla **E** tirás botellas de Fernet.
* **Curaciones:** Cada que matas a un enemigo, depende que tan fuerte sea suelta una curacion diferente.

## De dónde saqué las cosas (Fuentes)
Use de base el tutorial de **The GameDev** (https://www.youtube.com/playlist?list=PLNNbuBNHHbNGtZjygmnJ2fBvp6JmDNkAm) aunque este a veces se me hacia muy complejo y saque cosas del tutorial de Santiagoblas (https://github.com/santiagoblas/bomberpirate/tree/main).

### El Personaje Principal (El Empresario)
* Mi archivo `jugador_principal.gd` y `movimiento.gd` me base mas que nada en el movment.gd del tutorial de santiagoblas aunque ademas tambien tome logica del video de playermovment del tutorial. de thegamedev
* Mi script de `salud.gd` me base en el video de getting hurt del tutorial, pero lo adapté para que me sirva tanto para el jugador como para actualizar la interfaz, ademas ignore cosas que no servian para mi juego.

### Los Enemigos (comunes y el Jefe)
* **Enemigos comunes:** Mi script `enemigo.gd` lo armé siguiendo el video de enemies del tutorial de youtube. Implemente la logica de slots para que no se amontonen los enemigos
* **El Boss Final (`boss.gd`):** Este lo hice yo modificando la base del enemigo comun. Hice que se aleje cuando le pegas, y programe que si le das un golpe se quede aturdido mas tiempo que si le pegas un tiro. Tambien le agregue que cada 5 de vida que le sacas, te tire un fernet en botella cortada al piso para curarte.

## Los dibujos (Assets)
* **Cosas Argentinas:** Son del pack Argentinian Assets Pack v1.0.
* **Personajes:** Al empresario y a los fisuras los arme con imagenes de los packs de CraftPix (las colecciones de Gangsters).
