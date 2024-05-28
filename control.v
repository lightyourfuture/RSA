`timescale 1ns / 1ps
// 设定仿真的时间单位为纳秒(ns),时间精度为皮秒(ps)
`define WIDTH 256

module control #(parameter WIDTH = 256) (
    input [WIDTH-1:0] p,q, // 输入随机素数p和q
    input clk, // 系统全局时钟
    input reset, // 重置反转模块的信号
    input reset1, // 重置模幂计算模块的信号
    input encrypt_decrypt, // 加密或解密选择信号,1为加密,0为解密
    input [WIDTH-1:0] msg_in, // 输入的消息或密文
    output [WIDTH*2-1:0] msg_out, // 输出的解密消息或加密密文
    output mod_exp_finish // 模幂计算模块完成信号的输出
    );
    
    // parameter WIDTH = 32; // 定义输入端口的大小
    // 默认定义会在tb_main.v中被覆盖,因为defparam uut.WIDTH = `WIDTH, WIDTH的值为256

    wire inverter_finish; // 反转器完成信号
    wire [WIDTH*2-1:0] e, d; // e为公钥指数,d为私钥指数
    wire [WIDTH*2-1:0] exponent = encrypt_decrypt ? e : d; // 根据加密解密选择使用公钥或私钥
    wire [WIDTH*2-1:0] modulo = p * q; // 计算模n,n为p和q的乘积
    wire mod_exp_reset = 1'b0; // 模幂重置信号,固定为0

    reg [WIDTH*2-1:0] exp_reg, msg_reg; // 定义寄存器以保存指数和消息
    reg [WIDTH*2-1:0] mod_reg; // 定义寄存器以保存模

    always @(posedge clk) begin // 在时钟的上升沿
         exp_reg <= exponent; // 将指数存入寄存器
         mod_reg <= modulo; // 将模存入寄存器
         msg_reg <= msg_in; // 将输入消息存入寄存器
    end
    
//     inverter i(p, q, clk, reset, inverter_finish, e, d); // 反转模块实例化
//     defparam i.WIDTH = WIDTH; // 将参数WIDTH传递给反转模块
//     // mod_exp m(msg_reg, mod_reg, exp_reg, clk, reset1, mod_exp_end, msg_out); // 模幂模块实例化
//     // defparam m.WIDTH = WIDTH; // 将参数WIDTH传递给模幂模块
    
//     mod_exp #(.WIDTH(256)) mod_exp_instance (
//     .base(base),
//     .modulo(modulo),
//     .exponent(exponent),
//     .clk(clk),
//     .reset(reset),
//     .finish(finish),
//     .result(result)
// );
    
    inverter #(WIDTH) i(p, q, clk, reset, inverter_finish, e, d); // 反转模块实例化
    mod_exp #(WIDTH) m(msg_reg, mod_reg, exp_reg, clk, reset1, mod_exp_finish, msg_out); // 模幂模块实例化

endmodule
