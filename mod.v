`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2024 04:44:24 AM
// Design Name: 
// Module Name: mod
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module mod #(parameter WIDTH = 256) (
    input [WIDTH-1:0] a, // 输入,被除数
    input [WIDTH-1:0] n, // 输入,除数
    output [WIDTH-1:0] R, // 输出,余数
    output [WIDTH-1:0] Q // 输出,商
    );
   
//    parameter WIDTH = 19; // 参数WIDTH,定义输入输出信号的位宽
   // 实际上被覆盖了,因为defparam x_mod_y.WIDTH = WIDTH * 2; // 传递参数WIDTH*2给除法器模块, WIDTH的值为256
   reg [WIDTH-1:0] A, N; // 寄存器变量,保存中间计算结果
   reg [WIDTH:0] p; // 寄存器变量,保存中间计算结果,位宽比WIDTH多一位
   integer i; // 整型变量,用于循环计数
   
   // always块,用于在a或n发生变化时进行运算
   always @ (a or n) begin
       A = a; // 初始化A为输入a
       N = n; // 初始化N为输入n
       p = 0; // 初始化p为0
       
       // 逐位计算除法
       for (i = 0; i < WIDTH; i = i + 1) begin
           p = {p[WIDTH-2:0], A[WIDTH-1]}; // 左移p并将A的最高位移入p的最低位
           A[WIDTH-1:1] = A[WIDTH-2:0]; // 左移A
           p = p - N; // p减去N
           
           if (p[WIDTH-1] == 1) begin // 如果p的最高位为1,表示p小于0
                A[0] = 1'b0; // A的最低位设为0
                p = p + N; // p加回N
           end else begin
                A[0] = 1'b1; // 否则A的最低位设为1
           end
       end
   end    
   
   assign R = p; // 将余数p赋值给输出R
   assign Q = A; // 将商A赋值给输出Q
endmodule

