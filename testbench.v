//incluimos los archivos de tester y  controlador
`include "cmos_cells.v" //archivo compuertas
`include "tester.v"
`include "sint_comp.v" //archivo sintetizado
                                        
//modulo del testbench
module controlador_tb;
  wire [7:0] Pin;
  wire Clk, Reset, Vehiculo, Termino, Cerrado, Abierto, Alarma, Bloqueo, enterPin;

  initial begin
	$dumpfile("resultados.vcd"); //generamos archivo de resultados
	$dumpvars(-1, U0);//analizamos todas las variables
	$monitor ("Clk=%b, Reset=%b, Pin=%b, Vehiculo=%b, Termino=%b, Cerrado=%b, Abierto=%b, Alarma=%b, Bloqueo=%b,  enterPin=%b",
  Clk, Reset, Pin, Vehiculo, Termino, Cerrado, Abierto, Alarma, Bloqueo, enterPin); //variables impresas en consola
  end

//modulo del controlador
  controlador U0 (
    .Clk (Clk), 
    .Reset (Reset), 
    .Pin (Pin), 
    .Vehiculo (Vehiculo), 
    .Termino (Termino), 
    .Cerrado (Cerrado), 
    .Abierto (Abierto), 
    .Alarma (Alarma), 
    .Bloqueo (Bloqueo),
    .enterPin (enterPin)
  );
  
  //modulo del tester
  probador P0 (
    .Clk (Clk), 
    .Reset (Reset), 
    .Pin (Pin), 
    .Vehiculo (Vehiculo), 
    .Termino (Termino), 
    .Cerrado (Cerrado), 
    .Abierto (Abierto), 
    .Alarma (Alarma), 
    .Bloqueo (Bloqueo),
    .enterPin (enterPin)
  );

endmodule
