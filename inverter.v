`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2024 04:43:04 AM
// Design Name: 
// Module Name: inverter
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

`define UPDATING 3'd1 // 定义状态常量UPDATING,值为1
`define CHECK 3'd2 // 定义状态常量CHECK,值为2
`define HOLDING 3'd3 // 定义状态常量HOLDING,值为3

/* 使用扩展欧几里得算法计算解密密钥'd'和加密密钥'e'
   公式为:d * e = 1 mod (phi)
*/

module inverter #(parameter WIDTH = 256) (
    input [WIDTH-1:0] p, // 输入素数1
    input [WIDTH-1:0] q, // 输入素数2
    input clk, // 系统时钟
    input reset, // 重置信号
    output finish, // 操作完成指示
    output [WIDTH*2-1:0] e, // 加密密钥
    output [WIDTH*2-1:0] d // 解密密钥
    );

    // parameter WIDTH = 32; // 参数WIDTH,定义输入输出信号的位宽

    reg [WIDTH*2-1:0] totient_reg, a, b, y, y_prev; // 寄存器变量,保存中间计算结果
    reg [2:0] state; // 寄存器变量,保存当前状态
    reg [WIDTH-1:0] e_reg; // 寄存器变量,保存加密密钥

    wire [WIDTH*2-1:0] totient = (p-1) * (q-1); // 计算totient (phi) = (p-1)*(q-1)
    wire [WIDTH*2-1:0] quotient, b_next; // 计算中间变量
    wire [WIDTH*2-1:0] y_next = y_prev - quotient * y; // 计算中间变量
    wire [WIDTH-1:0] e_plus3 = e_reg + 2; // 计算中间变量,e加2
    assign finish = (state == `HOLDING) ? 1'b1 : 1'b0; // 根据状态决定操作是否完成
    assign e = e_reg; // 输出加密密钥
    assign d = y_prev; // 输出解密密钥

    // // 调用除法器模块
    // mod #(.WIDTH(256)) x_mod_y(a, b, b_next, quotient); // 除法器模块实例化
    // defparam x_mod_y.WIDTH = WIDTH * 2; // 传递参数WIDTH*2给除法器模块
        // 调用除法器模块
    mod #(WIDTH * 2) x_mod_y(a, b, b_next, quotient); // 除法器模块实例化

    // 时钟正边沿触发的always块,用于状态机控制
    always @(posedge clk) begin
        if (reset) begin // 如果重置信号为高
            totient_reg <= totient; // 初始化totient寄存器
            a <= totient; // 初始化a
            b <= 3; // 初始化b
            e_reg <= 3; // 初始化e
            y <= 1; // 初始化y
            y_prev <= 0; // 初始化y_prev
            state = `UPDATING; // 设置状态为UPDATING
        end

        // 状态机
        case (state)
            `UPDATING: begin // 在UPDATING状态
                if (b != 64'd0) begin // 如果b不等于0
                    a <= b; // 更新a
                    b <= b_next; // 更新b
                    y <= y_next; // 更新y
                    y_prev <= y; // 更新y_prev
                    state <= `UPDATING; // 继续保持UPDATING状态
                end else
                    state <= `CHECK; // 否则切换到CHECK状态
            end
            `CHECK: begin // 在CHECK状态
                if (a == 64'd1 && y_prev[WIDTH*2-1] == 1'b0) // 如果a等于1且y_prev的最高位为0
                    state = `HOLDING; // 切换到HOLDING状态
                else begin
                    a <= totient_reg; // 否则重新初始化a
                    b <= e_plus3; // 更新b
                    e_reg <= e_plus3; // 更新e_reg
                    y <= 1; // 重新初始化y
                    y_prev = 0; // 重新初始化y_prev
                    state <= `UPDATING; // 切换到UPDATING状态
                end
            end
            `HOLDING: begin // 在HOLDING状态
                // 在此状态保持不变,表示操作完成
            end
        endcase
    end

endmodule

