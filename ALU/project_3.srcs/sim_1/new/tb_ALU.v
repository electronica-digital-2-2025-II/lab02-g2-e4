`timescale 1ns / 1ps

module tb_ALU();

    // Entradas
    reg clk;
    reg rst;
    reg start;
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] opcode;

    // Salidas
    wire [7:0] resultado;
    wire overflow;
    wire zero;
    wire done;

    // Instancia del DUT
    ALU uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A),
        .B(B),
        .opcode(opcode),
        .resultado(resultado),
        .overflow(overflow),
        .zero(zero),
        .done(done)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // periodo 10 ns
    end

    // Estímulos
    initial begin
        // Inicialización
        rst = 1; start = 0; A = 0; B = 0; opcode = 3'b000;
        #30;
        rst = 0;

        // --- Prueba 1: Suma ---
        A = 4'b0101;  // 5
        B = 4'b0011;  // 3
        opcode = 3'b000; // SUMA
        #30;

        // --- Prueba 2: Resta ---
        A = 4'b0110;  // 6
        B = 4'b0011;  // 3
        opcode = 3'b001; // RESTA
        #30;

        // --- Prueba 3: Multiplicación ---
        A = 4'b0101;  // 5
        B = 4'b0010;  // 2
        opcode = 3'b010; // MULTIPLICACIÓN

        // Enciende el start para iniciar la operación
        start = 1;
        #10;
        start = 0;

        // Espera hasta que done se active
        wait(done);
        #20; // tiempo extra para observar el resultado

        // Reinicia después de terminar
        rst = 1;
        #10;
        rst = 0;

        // --- Prueba 4: Corrimiento con overflow ---
        A = 4'b1111; // 15
        B = 4'b0101; // desplaza 5 bits -> debe activar overflow
        opcode = 3'b100; // SHIFT LEFT
        #30;

        // --- Prueba 5: Compuerta NAND ---
        A = 4'b1100; // 12
        B = 4'b1010; // 10
        opcode = 3'b011; // NAND
        #30;

        // --- Fin ---
        $display("✅ Fin de simulación");
        $finish;
    end

    // Monitoreo
    initial begin
        $monitor("t=%0dns | opcode=%b | A=%d | B=%d | resultado=%d | overflow=%b | zero=%b | done=%b | start=%b | rst=%b",
                 $time, opcode, A, B, resultado, overflow, zero, done, start, rst);
    end

endmodule
