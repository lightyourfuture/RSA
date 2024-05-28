`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2024 04:43:43 AM
// Design Name: 
// Module Name: mod_exp
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
// 设置仿真时间单位为纳秒(ns),时间精度为皮秒(ps)

`define UPDATE 2'd1 // 定义状态常量UPDATE,值为1
`define HOLD 2'd2 // 定义状态常量HOLD,值为2

/* 使用右到左二进制指数运算(Bruce Schneier算法)计算 a^b mod n */
module mod_exp #(parameter WIDTH = 256) (
    input [WIDTH*2-1:0] base, // 基数,这里表示 (a)
    input [WIDTH*2-1:0] modulo, // 模数,这里表示 (n)
    input [WIDTH*2-1:0] exponent, // 指数,这里表示基数的幂 (b)
    input clk, // 系统时钟
    input reset, // 重置信号
    output finish, // 操作完成指示信号
    output [WIDTH*2-1:0] result // 结果输出
    );
    
    // parameter WIDTH = 32; // 参数WIDTH,定义输入输出信号的位宽
    // 实际上被覆盖了,因为defparam m.WIDTH = WIDTH; // 将参数WIDTH传递给模幂模块, WIDTH的值为256
        
    reg [WIDTH*2-1:0] base_reg, modulo_reg, exponent_reg, result_reg; // 寄存器变量,保存中间计算结果
    reg [1:0] state; // 寄存器变量,保存当前状态
    
    wire [WIDTH*2-1:0] result_mul_base = result_reg * base_reg; // 计算中间结果 result * base
    wire [WIDTH*2-1:0] result_next; // 保存结果的下一状态
    wire [WIDTH*2-1:0] base_squared = base_reg * base_reg; // 计算 base 的平方
    wire [WIDTH*2-1:0] base_next; // 保存 base 的下一状态
    wire [WIDTH*2-1:0] exponent_next = exponent_reg >> 1; // 指数右移一位,相当于除以2
    
    assign finish = (state == `HOLD) ? 1'b1 : 1'b0; // 根据状态决定操作是否完成
    assign result = result_reg; // 将结果寄存器的值赋给输出 result
    
    // // 调用模运算模块,计算 base 的平方模 modulo
    // mod #(.WIDTH(WIDTH * 2)) base_squared_mod(base_squared, modulo_reg, base_next, ); 
    // // defparam base_squared_mod.WIDTH = WIDTH * 2; 

    // // 调用模运算模块,计算 base 的平方模 modulo
    // mod #(.WIDTH(WIDTH * 2)) base_squared_mod (
    //     .a(base_squared),
    //     .n(modulo_reg),
    //     .R(base_next),
    //     .Q()
    // );

        // 调用模运算模块,计算 base 的平方模 modulo
    mod #(WIDTH * 2) base_squared_mod (
        .a(base_squared),
        .n(modulo_reg),
        .R(base_next),
        .Q()
    );
    
    // // 调用模运算模块,计算 result * base 模 modulo
    // mod #(.WIDTH(256)) result_mul_base_mod(result_mul_base, modulo_reg, result_next, );
    // defparam result_mul_base_mod.WIDTH = WIDTH * 2;

    //  // 调用模运算模块,计算 result * base 模 modulo
    // mod #(.WIDTH(WIDTH * 2)) result_mul_base_mod (
    //     .a(result_mul_base),
    //     .n(modulo_reg),
    //     .R(result_next),
    //     .Q()
    // );

        // 调用模运算模块,计算 result * base 模 modulo
    mod #(WIDTH * 2) result_mul_base_mod (
        .a(result_mul_base),
        .n(modulo_reg),
        .R(result_next),
        .Q()
    );


    
    // 时钟正边沿触发的always块,用于状态机控制
    always @(posedge clk) begin
        if (reset) begin // 如果重置信号为高
            base_reg <= base; // 初始化 base_reg
            modulo_reg <= modulo; // 初始化 modulo_reg
            exponent_reg <= exponent; // 初始化 exponent_reg
            result_reg <= 32'd1; // 初始化 result_reg 为 1
            state <= `UPDATE; // 设置状态为 UPDATE
        end
        else case (state)
            `UPDATE: begin // 在 UPDATE 状态
                if (exponent_reg != 64'd0) begin // 如果指数不为 0
                    if (exponent_reg[0]) // 如果指数最低位为 1
                        result_reg <= result_next; // 更新 result_reg 为 result_next
                    base_reg <= base_next; // 更新 base_reg 为 base_next
                    exponent_reg <= exponent_next; // 更新 exponent_reg 为 exponent_next
                    state <= `UPDATE; // 继续保持 UPDATE 状态
                end
                else state <= `HOLD; // 否则切换到 HOLD 状态
            end
            
            `HOLD: begin
                // 在 HOLD 状态,表示操作完成,保持不变
            end
        endcase
    end
endmodule
