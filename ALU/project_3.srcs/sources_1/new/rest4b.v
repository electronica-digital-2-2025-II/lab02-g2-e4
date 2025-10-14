module rest4b(
    input [3:0] A,     // Minuendo
    input [3:0] B,     // Sustraendo
    input Bi,          // Borrow de entrada (generalmente 0)
    output [3:0] D,    // Diferencia
    output Bo          // Borrow de salida final
);

wire b1, b2, b3; // Borrows intermedios

// Bit 0 (LSB)
rest1b r0 (
    .A(A[0]),
    .B(B[0]),
    .Bi(Bi),
    .D(D[0]),
    .Bo(b1)
);

// Bit 1
rest1b r1 (
    .A(A[1]),
    .B(B[1]),
    .Bi(b1),
    .D(D[1]),
    .Bo(b2)
);

// Bit 2
rest1b r2 (
    .A(A[2]),
    .B(B[2]),
    .Bi(b2),
    .D(D[2]),
    .Bo(b3)
);

// Bit 3 (MSB)
rest1b r3 (
    .A(A[3]),
    .B(B[3]),
    .Bi(b3),
    .D(D[3]),
    .Bo(Bo)
);

endmodule
