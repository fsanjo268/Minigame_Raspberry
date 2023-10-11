#Configuracion codigos
PIN_CAR_GREEN=2
PIN_CAR_AMBER=1
PIN_CAR_RED=0
PIN_PED_GREEN=4
PIN_PED_RED=3
PIN_BUTTON=8
#valor del pin ganador
pid=0
#Configuracion tienpos
DELAY_CAR_AMBER=1
DELAY_CAR_RED=1
DELAY_CAR_GREEN=1
DELAY_PED_RED=3
DELAY_PED_GREEN=1
DELAY_FLASH=0.5
#Funcion configuracion pines GPIO
configurar_pines(){
gpio mode $PIN_CAR_GREEN out
gpio mode $PIN_CAR_AMBER out
gpio mode $PIN_CAR_RED out
gpio mode $PIN_PED_GREEN out
gpio mode $PIN_PED_RED out
gpio mode $PIN_BUTTON in
gpio mode $PIN_BUTTON up

}
#Funcion estado inicial semaforo
iniciar_semaforos(){
gpio write $PIN_CAR_GREEN 0
gpio write $PIN_CAR_AMBER 0
gpio write $PIN_CAR_RED 0
gpio write $PIN_PED_GREEN 0
gpio write $PIN_PED_RED 0
}

#Funcion cambiar el estado de los semaforos
cambiar_semaforos(){
while true; do
gpio write $PIN_CAR_RED 1

/bin/sleep $DELAY_FLASH

gpio write $PIN_CAR_RED 0
gpio write $PIN_CAR_AMBER 1

/bin/sleep $DELAY_FLASH

gpio write $PIN_CAR_AMBER 0
gpio write $PIN_CAR_GREEN 1

/bin/sleep $DELAY_FLASH

gpio write $PIN_CAR_GREEN 0

gpio write $PIN_PED_RED 1

/bin/sleep $DELAY_FLASH

gpio write $PIN_PED_RED 0
gpio write $PIN_PED_GREEN 1

/bin/sleep $DELAY_FLASH

gpio write $PIN_PED_GREEN 0
gpio write $PIN_PED_RED 1

/bin/sleep $DELAY_FLASH

gpio write $PIN_PED_RED 0
gpio write $PIN_CAR_GREEN 1

/bin/sleep $DELAY_FLASH

gpio write $PIN_CAR_GREEN 0
gpio write $PIN_CAR_AMBER 1

/bin/sleep $DELAY_FLASH

gpio write $PIN_CAR_AMBER 0
gpio write $PIN_CAR_RED 1
done
}

configurar_pines

iniciar_semaforos
cambiar_semaforos &
pid=$!
while true; do
	if [[ $(gpio read $PIN_BUTTON) -eq 0 && $(gpio read $PIN_CAR_GREEN) -ne 1 ]]; then
		/bin/sleep 0.1
		echo $pid
		/bin/kill $pid
		exit
	fi
done
