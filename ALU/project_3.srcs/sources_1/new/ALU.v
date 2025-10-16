module ALU (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [3:0] A,
    input wire [3:0] B,
    input wire [2:0] opcode,     // Código de operación
    output reg [7:0] resultado,  // Salida general (hasta 8 bits)
    output reg overflow,
    output reg zero,
    output wire done             // Señal del multiplicador
);

    // Códigos de operación
    localparam OP_SUM   = 3'b000;
    localparam OP_REST  = 3'b001;
    localparam OP_MUL   = 3'b010;
    localparam OP_NAND  = 3'b011;
    localparam OP_SHIFT = 3'b100;

    // Señales internas
    wire [3:0] sum_res;
    wire [3:0] rest_res;
    wire [7:0] mul_res;
    wire sum_co, rest_bo, mul_done;

    // --- Instancias de módulos básicos ---
    sum4b U_SUM (
        .A(A),
        .B(B),
        .Ci(1'b0),
        .S(sum_res),
        .Co(sum_co)
    );

    rest4b U_REST (
        .A(A),
        .B(B),
        .Bi(1'b0),
        .D(rest_res),
        .Bo(rest_bo)
    );

    multiplicador U_MUL (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A),
        .B(B),
        .resultado(mul_res),
        .done(mul_done)
    );

    assign done = mul_done;

    // --- Lógica combinacional principal ---
    always @(*) begin
        resultado = 8'b0;
        overflow = 1'b0;

        case (opcode)
            OP_SUM: begin
                resultado = {4'b0000, sum_res};
                overflow = sum_co;  // Overflow si hay carry out
            end

            OP_REST: begin
                resultado = {4'b0000, rest_res};
                overflow = rest_bo; // Borrow como overflow
            end

            OP_MUL: begin
                resultado = mul_res;
                overflow = 1'b0; // El multiplicador maneja bits altos
            end

            OP_NAND: begin
                resultado = {4'b0000, ~(A & B)};
                overflow = 1'b0;
            end

            OP_SHIFT: begin
                // Corrimiento lógico a la izquierda
                resultado = {4'b0000, (A << B[1:0])};

                // Overflow si se pierden bits del MSB al desplazarse
                case (B[1:0])
                    2'b00: overflow = 1'b0;                           // Sin desplazamiento
                    2'b01: overflow = A[3];                           // Si se pierde bit 3
                    2'b10: overflow = |A[3:2];                        // Si se pierden bits 2 o 3
                    2'b11: overflow = |A[3:1];                        // Si se pierden bits 1, 2 o 3
                    default: overflow = 1'b0;
                endcase
            end

            default: begin
                resultado = 8'b0;
                overflow = 1'b0;
            end
        endcase
    end

    // --- Detección de resultado cero ---
    always @(*) begin
        zero = (resultado == 8'b0);
    end

endmodule
