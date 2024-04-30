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
parameter medio_T = 5;


  initial begin
    Clk = 0;
    Reset = 0;
    Vehiculo = 0;
    Termino = 0;
    enterPin = 0;
    Pin=Pin_0;
    
    #5 Reset = 1; //5. reseteamos la máquina
    #20 Reset = 0; //15.
    //*Prueba 1: funcionamiento normal*
    #5 Vehiculo = 1; //llega vehiculo
    #15 {enterPin,Pin}  = 9'b100000000+Pin_correcto;
    #10 enterPin = 0;
    #20 {Vehiculo, Termino} = 2'b01; //si la señal de vehiculo se apaga, es logico de que la que termino de entrar tambien se encienda al mismo tiempo
    #10 Termino = 0; //se apaga termino, dura sòlo un ciclo de relog
    //volvemos al estado cerrado
    //*Prueba 2: ingreso de pin incorrecto 3 o más veces*
    #15 Vehiculo = 1; //llega vehiculo
    #5 {enterPin,Pin}  = 9'b111111111; //introduce pin incorrecto
    #10 enterPin = 0;
    #10 {enterPin,Pin}  = 9'b111111111; //introduce pin incorrecto por segunda vez
    #10 enterPin = 0;
    #10 enterPin = 1; //introduce pin incorrecto por tercera vez
    #10 enterPin = 0;
    #10 enterPin = 1;
    #10 enterPin = 0; //introduce pin incorrecto por cuarta vez
    #10 {enterPin,Pin}  = 9'b100000000+Pin_correcto;
    #10 enterPin = 0;
    #10 {Vehiculo, Termino} = 2'b01; //si la señal de vehiculo se apaga, es logico de que la que termino de entrar tambien se encienda al mismo tiempo
    #10 Termino = 0; //se apaga termino, dura sòlo un ciclo de relog
     //volvemos al estado cerrado
    //Prueba 3: *ingreso de pin incorrecto menos de 3 veces* 
    #10 Vehiculo = 1; //llega nuevo vehiculo
    #10 {enterPin,Pin}  = 9'b111111111; //introduce pin incorrecto sòlo una vez
    #10 enterPin = 0;
    #10 {enterPin,Pin}  = 9'b100000000+Pin_correcto;
    #10 enterPin = 0;
    //Prueba 4: *Alarma de bloqueo*
    #10 {Vehiculo, Termino} = 2'b11; //si la señal de vehiculo se enciende al mismo tiempo que la señal termino, vamos al estado bloqueo
    #10 Termino = 0; //se apaga termino, dura sòlo un ciclo de relog
    #10 {enterPin,Pin}  = 9'b111111111; //introduce pin incorrecto
    #10 enterPin = 0; 
    #10 {enterPin,Pin}  = 9'b100000000+Pin_correcto;
    #10 enterPin = 0; //se vuelve a abrir la compuerta
    #10 {Vehiculo, Termino} = 2'b01; //ya entro el vehiculo
    //Prueba 5: *Botón enter*
    #10 Vehiculo = 1; //llega vehiculo
    #10 Pin = Pin_0;//pin incorrecto
    #20 Pin = Pin_correcto;//pin correcto
    #20 enterPin = 1;
    #10 enterPin = 0;//vamos al estado abierto
    #10 {Vehiculo, Termino} = 2'b11; //bloqueamos la compuerta
    #10 Termino = 0;
    #10 Pin = Pin_0;//pin incorrecto
    #20 Pin = Pin_correcto;//pin correcto
    #20 enterPin = 1;
    #10 enterPin = 0;
    //Prueba 6: *Reset*
    #10 {Vehiculo, Termino} = 2'b11; //bloqueamos la compuerta
    #10 {Vehiculo, Termino} = 2'b00;
    #20 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b111100000000+Pin_correcto;
    #10 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b0;
    //estamos en el estado cerrado
    #20 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b111100000000+Pin_correcto;
    #10 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b0;
    //volvemos a abrir la compuerta
    #10 Vehiculo = 1;
    #10 {enterPin,Pin}  = 9'b100000000+Pin_correcto;
    #10 enterPin = 0;
    #20 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b111100000000+Pin_correcto;
    #10 {Reset,Vehiculo,Termino,enterPin,Pin}=12'b0;
    #40 $finish;
  end

  always begin
    #medio_T Clk = !Clk;
  end

endmodule
