module multiplicador(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [3:0] A,
    input wire [3:0] B,
    output reg [7:0] resultado,
    output reg done
);

    // Estados
    parameter INIT = 2'b00;
    parameter MUL  = 2'b01;
    parameter DONE = 2'b10;

    reg [1:0] estado_actual, estado_siguiente;
    reg [3:0] multiplicando, multiplicador;
    reg [7:0] acumulador;

    // --------------------------
    // Lógica secuencial
    // --------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estado_actual <= INIT;
            acumulador <= 8'b0;
            resultado <= 8'b0;
            done <= 0;
        end else begin
            estado_actual <= estado_siguiente;
        end
    end

    // --------------------------
    // Lógica combinacional (próximo estado)
    // --------------------------
    always @(*) begin
        estado_siguiente = estado_actual;
        done = 0;

        case (estado_actual)
            INIT: begin
                if (start)
                    estado_siguiente = MUL;
            end

            MUL: begin
                if (multiplicador == 0)
                    estado_siguiente = DONE;
                else
                    estado_siguiente = MUL;
            end

            DONE: begin
                done = 1;
                estado_siguiente = INIT;
            end
        endcase
    end

    // --------------------------
    // Proceso de multiplicación secuencial
    // --------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            multiplicando <= 0;
            multiplicador <= 0;
            acumulador <= 0;
            resultado <= 0;
        end else begin
            case (estado_actual)
                INIT: begin
                    if (start) begin
                        multiplicando <= A;
                        multiplicador <= B;
                        acumulador <= 0;
                        resultado <= 0;
                    end
                end

                MUL: begin
                    // Solo opera si aún quedan bits por procesar
                    if (multiplicador != 0) begin
                        if (multiplicador[0] == 1'b1)
                            acumulador <= acumulador + multiplicando;
                        multiplicando <= multiplicando << 1;
                        multiplicador <= multiplicador >> 1;
                    end
                end

                DONE: begin
                    resultado <= acumulador;
                end
            endcase
        end
    end

endmodule
