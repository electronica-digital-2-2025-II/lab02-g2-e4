module rest1b(
    input A,       // Minuendo
    input B,       // Sustraendo
    input Bi,      // Borrow in
    output D,      // Diferencia
    output Bo      // Borrow out
);

wire xor1;
wire notA;
wire term1, term2, term3;

assign xor1 = A ^ B;
assign D = xor1 ^ Bi;        // Diferencia
assign notA = ~A;

assign term1 = notA & B;
assign term2 = B & Bi;
assign term3 = notA & Bi;

assign Bo = term1 | term2 | term3;  // Borrow out

endmodule
