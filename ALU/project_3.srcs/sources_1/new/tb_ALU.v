`timescale 1ns / 1ps
//====================================================
// Testbench: tb_ALU
// Descripción: Prueba de la ALU de 4 bits
//====================================================

module tb_ALU;

    // Señales de entrada
    reg clk;
    reg reset;
    reg start;
    reg [2:0] sel;
    reg [3:0] A;
    reg [3:0] B;
    reg dir;

    // Salidas
    wire [7:0] leds;
    wire done_led;
    wire zero;
    wire overflow;

    // Instancia del módulo ALU
    ALU uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .sel(sel),
        .A(A),
        .B(B),
        .dir(dir),
        .leds(leds),
        .done_led(done_led),
        .zero(zero),
        .overflow(overflow)
    );

    // Generador de reloj
    always #5 clk = ~clk;  // Periodo de 10 ns

    // Proceso de simulación
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        start = 0;
        sel = 3'b000;
        A = 4'd0;
        B = 4'd0;
        dir = 1'b0;

        // Liberar reset
        #10 reset = 0;

        // ===============================
        // 1️⃣ PRUEBA SUMA
        // ===============================
        A = 4'd7; B = 4'd5; sel = 3'b000;
        start = 1; #10; start = 0;
        wait(done_led);
        #10;
        $display("Suma: %d + %d = %d (leds = %b)", A, B, leds[3:0], leds[3:0]);

        // ===============================
        // 2️⃣ PRUEBA RESTA
        // ===============================
        A = 4'd9; B = 4'd3; sel = 3'b001;
        start = 1; #10; start = 0;
        wait(done_led);
        #10;
        $display("Resta: %d - %d = %d (leds = %b)", A, B, leds[3:0], leds[3:0]);

        // ===============================
        // 3️⃣ PRUEBA MULTIPLICACIÓN
        // ===============================
        A = 4'd3; B = 4'd5; sel = 3'b010;
        start = 1; #10; start = 0;
        wait(done_led);
        #10;
        $display("Multiplicacion: %d * %d = %d (leds = %b)", A, B, leds, leds);

        // ===============================
        // 4️⃣ PRUEBA CORRIMIENTO IZQUIERDA
        // ===============================
        A = 4'b0101; dir = 1'b0; sel = 3'b011;
        start = 1; #10; start = 0;
        wait(done_led);
        #10;
        $display("Corrimiento izq: %b << 1 = %b", A, leds[3:0]);

        // ===============================
        // 5️⃣ PRUEBA CORRIMIENTO DERECHA
        // ===============================
        A = 4'b1001; dir = 1'b1; sel = 3'b011;
        start = 1; #10; start = 0;
        wait(done_led);
        #10;
        $display("Corrimiento der: %b >> 1 = %b", A, leds[3:0]);

        // ===============================
        // 6️⃣ PRUEBA NAND
        // ===============================
        A = 4'b1010; B = 4'b1100; sel = 3'b100;
        start = 1; #10; start = 0;
        wait(done_led);
        #10;
        $display("NAND: ~(A & B) = ~( %b & %b ) = %b", A, B, leds[3:0]);

        // ===============================
        // FIN DE SIMULACIÓN
        // ===============================
        #20;
        $display("Simulación completada.");
        $stop;
    end

endmodule
