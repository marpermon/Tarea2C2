/*Paulette Pérez Monge- Carnet B95916
Tarea 1 - Digitales 2
Controlador para parqueo 
Maquina Mealy */

module controlador(
	Clk, Reset, Pin, Vehiculo, Termino,	Cerrado, Abierto, Alarma, Bloqueo, enterPin
);

input Clk, Reset, Vehiculo, Termino, enterPin;
input [7:0] Pin;
output reg Alarma, Cerrado, Abierto, Bloqueo;


/// hasta aqui bien
//reg C_Cerrada, C_Abierta, Bloquear_P;
//reg Verificar_Pin; //Verifica si el pin es correcto

reg [2:0] state;
reg [2:0] nxt_state;//mal
reg [1:0] count0; 
reg [1:0] nxt_count0;
wire pin_ok; //la salida de un assign siempre es un wire   
wire count3;

// Asignación de estados
//parametros para usarlos como variables
//intenta cambiar 0 por ?
parameter C_Cerrada = 3'b001; //Compuerta cerrada
parameter C_Abierta = 3'b010; //Compuerta abierta
parameter C_Bloqueada = 3'b100; //Bloquear

parameter Pin_correcto = 8'b00010000;


//Memoria de estados
always @(posedge Clk) begin
  if (Reset) begin
    state  <= C_Cerrada; // si hay un reset empezamos con la puerta cerrada
    count0 <= 2'b0; //y con el contador en 0
  end else begin
    state  <= nxt_state;  //sino, vamos al proximo estado en memoria
    count0 <= nxt_count0;  
  end
end 
assign pin_ok=(Pin==Pin_correcto);
assign count3=(count0>=3);

//logica combinacional
always @(*) begin
  //por defecto
  nxt_state = state;  
  nxt_count0 = count0;
  /*Cerrado=1'b1; //arreglo de error en sìntesis
  Abierto=1'b0;
  Alarma=1'b0;
  Bloqueo=1'b0;*/

  case (state)
    C_Cerrada: begin //si empezamos con la compuerta cerrada
        Cerrado=1'b1; //output
        Abierto=1'b0;
        Alarma=1'b0;
        Bloqueo=1'b0;
        case ({Vehiculo, enterPin, pin_ok, Termino, count3})
          5'b110?0: begin
              nxt_state = C_Cerrada;
              nxt_count0 = count0+1;
            end
          5'b110?1: begin
              nxt_state = C_Cerrada;
              Alarma=1'b1;
            end
          /*5'b????1: begin
              nxt_state = C_Cerrada;
              Alarma=1'b1;
            end*/
          5'b0????: nxt_state = C_Cerrada;
          5'b10???: nxt_state = C_Cerrada;
          5'b111??: nxt_state = C_Abierta;
    
        endcase
      end

    3'b010: 	begin
      Cerrado=1'b0; //output
      Abierto=1'b1;
      Alarma=1'b0;
      Bloqueo=1'b0;
      nxt_count0 = 2'b00; //cuando se abre la puerta se limpia el contador*
      case ({Vehiculo, enterPin, pin_ok, Termino, count3})
          5'b1??1?: begin
              nxt_state = C_Bloqueada;
              Cerrado=1'b1;
            end
          5'b???0?: nxt_state = C_Abierta;
          5'b0??1?: begin
              nxt_state = C_Cerrada;
              Cerrado=1'b1;
            end

      endcase
      end

    3'b100: begin
      Cerrado=1'b0; //output
      Abierto=1'b0;
      Alarma=1'b1;
      Bloqueo=1'b1; 
      case ({Vehiculo, enterPin, pin_ok, Termino, count3})
          5'b?11??: nxt_state= C_Abierta;
          5'b?0???: nxt_state = C_Bloqueada;
          5'b?10??: nxt_state = C_Bloqueada;
          
      endcase
    end
    default nxt_state = state;
  endcase  
end

endmodule
