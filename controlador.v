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

//logica combinacional
always @(*) begin
  //por defecto
  nxt_state = state;  
  nxt_count0 = count0;
  Cerrado=1'b1; //arreglo de error en sìntesis
  Abierto=1'b0;
  Alarma=1'b0;
  Bloqueo=1'b0;

  case (state)
    3'b001: begin //si empezamos con la compuerta cerrada
        Cerrado=1'b1; //output
        Abierto=1'b0;
        Alarma=1'b0;
        Bloqueo=1'b0;
        if (Vehiculo) begin
          if (enterPin) begin
            if (Pin==Pin_correcto) begin
              nxt_state = C_Abierta; //si hay v y el pin es correcto
              nxt_count0 = 2'b00; //Cuando se ingresa la clave correcta se debe limpiar el contador de intentos incorrectos
            end
                
            else begin
              if (count0<3) begin
                  nxt_state = C_Cerrada; //si hay v pero el pin es incorrecto y el contador es menor a 2
                  nxt_count0 = count0+1;
                end
              else begin
                  nxt_state = C_Cerrada; //si hay v pero el pin es incorrecto y el contador es 2, significa que este el el tercer fallo
                  Alarma=1'b1; //output
                  //no sumamos mas porque no es necesario
                end 
              end   
            end
          else begin
            if (count0>=3) Alarma=1'b1;
          end
          //si no se ha dado enter, no hacer nada, porque no se ha ingresado nada
          //a menos que el contador sea 3, ahí encendemos la alarma
        end
        //no hay else porque si no hay v, la compuerta sigue cerrada
      end

    3'b010: 	begin
      Cerrado=1'b0; //output
      Abierto=1'b1;
      Alarma=1'b0;
      Bloqueo=1'b0;
      nxt_count0 = 2'b00; //cuando se abre la puerta se limpia el contador*
      if (Termino)
        begin
          Abierto=1'b0; 
          Cerrado=1'b1; //cerramos la puerta  
          begin
            if(Vehiculo) nxt_state = C_Bloqueada;//si termino de entrar y hay vehiculo AL MISMO TIEMPO
            else nxt_state = C_Cerrada;//si termino de entrar y no hay vehiculo
          end
        end
        // no hay else porque si no ha terminado de entrar, la compuerta sigue abierta
    end

    3'b100: begin
      Cerrado=1'b0; //output
      Abierto=1'b0;
      Alarma=1'b1;
      Bloqueo=1'b1; 
      if (enterPin) begin
        if (Pin==Pin_correcto) begin 
          nxt_state = C_Abierta; //si el pin es correcto se abre la puerta
          nxt_count0 = 2'b00; 
        end
      end  
      // no hay else porque, si el pin no es correcto, sigue bloqueada
    end
    default nxt_state = state;
  endcase  
end

endmodule
