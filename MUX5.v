`timescale 1ns / 1ns
module Mux5(
    input control,
    input[4:0] in0,
    input[4:0] in1,
    output[4:0] out
);
// 5线多路选择器
    assign out=control?in1:in0;
endmodule
