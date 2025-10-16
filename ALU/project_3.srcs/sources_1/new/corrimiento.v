//====================================================
// Módulo: corrimiento
// Descripción: Corrimiento lógico de 4 bits (izquierda o derecha)
//====================================================

module corrimiento (
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire [3:0] A,       // Dato de entrada
    input  wire       dir,     // Dirección: 0 = izquierda, 1 = derecha
    output reg  [3:0] leds,    // Resultado
    output reg        done_led // Bandera de finalización
);

    // Estados
    localparam [1:0] INIT   = 2'b00;
    localparam [1:0] SHIFT  = 2'b01;
    localparam [1:0] FINISH = 2'b10;

    reg [1:0] estado_actual, estado_siguiente;
    reg [3:0] temp;

    // Registro de estado
    always @(posedge clk or posedge reset) begin
        if (reset)
            estado_actual <= INIT;
        else
            estado_actual <= estado_siguiente;
    end

    // Lógica de transición de estados
    always @(*) begin
        estado_siguiente = estado_actual;
        case (estado_actual)
            INIT:   estado_siguiente = start ? SHIFT : INIT;
            SHIFT:  estado_siguiente = FINISH;
            FINISH: estado_siguiente = start ? FINISH : INIT;
            default: estado_siguiente = INIT;
        endcase
    end

    // Salidas y registros internos
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            temp      <= 4'd0;
            leds      <= 4'd0;
            done_led  <= 1'b0;
        end else begin
            case (estado_actual)
                INIT: begin
                    done_led <= 1'b0;
                    if (start)
                        temp <= A;
                end

                SHIFT: begin
                    if (dir == 1'b0)
                        temp <= temp << 1; // Corrimiento a la izquierda
                    else
                        temp <= temp >> 1; // Corrimiento a la derecha
                end

                FINISH: begin
                    leds     <= temp;
                    done_led <= 1'b1;
                end
            endcase
        end
    end

endmodule
