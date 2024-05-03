module probador (
  Clk, Reset,
	Pin, Vehiculo, Termino, enterPin,
	Cerrado, Abierto, Alarma, Bloqueo
  );

output reg Clk, Reset, Vehiculo, Termino, enterPin;
output reg [7:0] Pin;
input Alarma, Cerrado, Abierto, Bloqueo;

parameter Pin_correcto = 8'b00010000;
parameter Pin_0 = 8'b0;
parameter medio_T = 20;


  initial begin
    Clk = 0;
    Reset = 0;
    Vehiculo = 0;
    Termino = 0;
    enterPin = 0;
    Pin=Pin_0;
    
    #20 Reset = 1; //5. reseteamos la máquina
    #40 Reset = 0; //15.
    //*Prueba 1: funcionamiento normal*
    #20 Vehiculo = 1; //llega vehiculo
    #60 {enterPin,Pin}  = 9'b100000000+Pin_correcto;
    #40 enterPin = 0;
    #80 {Vehiculo, Termino} = 2'b01; //si la señal de vehiculo se apaga, es logico de que la que termino de entrar tambien se encienda al mismo tiempo
    #40 Termino = 0; //se apaga termino, dura sòlo un ciclo de relog
    //volvemos al estado cerrado
    //*Prueba 2: ingreso de pin incorrecto 3 o más veces*
    #60 Vehiculo = 1; //llega vehiculo
    #20 {enterPin,Pin}  = 9'b111111111; //introduce pin incorrecto
    #40 enterPin = 0;
    #40 {enterPin,Pin}  = 9'b111111111; //introduce pin incorrecto por segunda vez
    #40 enterPin = 0;
    #40 enterPin = 1; //introduce pin incorrecto por tercera vez
    #40 enterPin = 0;
    #40 enterPin = 1;
    #40 enterPin = 0; //introduce pin incorrecto por cuarta vez
    #40 {enterPin,Pin}  = 9'b100000000+Pin_correcto;
    #40 enterPin = 0;
    #40 {Vehiculo, Termino} = 2'b01; //si la señal de vehiculo se apaga, es logico de que la que termino de entrar tambien se encienda al mismo tiempo
    #40 Termino = 0; //se apaga termino, dura sòlo un ciclo de relog
     //volvemos al estado cerrado
    //Prueba 3: *ingreso de pin incorrecto menos de 3 veces* 
    #40 Vehiculo = 1; //llega nuevo vehiculo
    #40 {enterPin,Pin}  = 9'b111111111; //introduce pin incorrecto sòlo una vez
    #40 enterPin = 0;
    #40 {enterPin,Pin}  = 9'b100000000+Pin_correcto;
    #40 enterPin = 0;
    //Prueba 4: *Alarma de bloqueo*
    #40 {Vehiculo, Termino} = 2'b11; //si la señal de vehiculo se enciende al mismo tiempo que la señal termino, vamos al estado bloqueo
    #40 Termino = 0; //se apaga termino, dura sòlo un ciclo de relog
    #40 {enterPin,Pin}  = 9'b111111111; //introduce pin incorrecto
    #40 enterPin = 0; 
    #40 {enterPin,Pin}  = 9'b100000000+Pin_correcto;
    #40 enterPin = 0; //se vuelve a abrir la compuerta
    #40 {Vehiculo, Termino} = 2'b01; //ya entro el vehiculo
    //Prueba 5: *Botón enter*
    #40 Vehiculo = 1; //llega vehiculo
    #40 Pin = Pin_0;//pin incorrecto
    #80 Pin = Pin_correcto;//pin correcto
    #80 enterPin = 1;
    #40 enterPin = 0;//vamos al estado abierto
    #40 {Vehiculo, Termino} = 2'b11; //bloqueamos la compuerta
    #40 Termino = 0;
    #40 Pin = Pin_0;//pin incorrecto
    #80 Pin = Pin_correcto;//pin correcto
    #80 enterPin = 1;
    #40 enterPin = 0;
    //Prueba 6: *Reset*
    #40 {Vehiculo, Termino} = 2'b11; //bloqueamos la compuerta
    #40 {Vehiculo, Termino} = 2'b00;
    #80 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b111100000000+Pin_correcto;
    #40 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b0;
    //estamos en el estado cerrado
    #80 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b111100000000+Pin_correcto;
    #40 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b0;
    //volvemos a abrir la compuerta
    #40 Vehiculo = 1;
    #40 {enterPin,Pin}  = 9'b100000000+Pin_correcto;
    #40 enterPin = 0;
    #80 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b111100000000+Pin_correcto;
    #40 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b0;
    #160 $finish;
  end

  always begin
    #medio_T Clk = !Clk;
  end

endmodule
