`timescale 1ns / 1ps

module sumador (
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire [3:0] sw_A,
    input  wire [3:0] sw_B,
    output reg  [4:0] leds,
    output reg        done_led
);

    // Estados de la FSM
    typedef enum reg [1:0] {
        INIT   = 2'b00,
        SUM    = 2'b01,
        FINISH = 2'b10
    } estado_t;

    estado_t estado_actual, estado_siguiente;
    reg [4:0] resultado_temp;

    // Registro de estado
    always @(posedge clk or posedge reset) begin
        if (reset)
            estado_actual <= INIT;
        else
            estado_actual <= estado_siguiente;
    end

    // Transición de estados
    always @(*) begin
        case (estado_actual)
            INIT:   estado_siguiente = start ? SUM : INIT;
            SUM:    estado_siguiente = FINISH;
            FINISH: estado_siguiente = start ? FINISH : INIT;
            default: estado_siguiente = INIT;
        endcase
    end

    // Lógica de salida y operaciones
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            resultado_temp <= 5'd0;
            leds      <= 5'd0;
            done_led  <= 1'b0;
        end else begin
            case (estado_actual)
                INIT: begin
                    done_led <= 1'b0;
                end
                SUM: begin
                    resultado_temp <= sw_A + sw_B;  // Operación
                end
                FINISH: begin
                    leds     <= resultado_temp;
                    done_led <= 1'b1;
                end
            endcase
        end
    end

endmodule
