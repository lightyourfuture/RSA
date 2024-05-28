`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2024 04:53:08 AM
// Design Name: 
// Module Name: tb_main
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
`define WIDTH 256 // 定义参数WIDTH,值为256

module tb_main;
    reg [`WIDTH-1:0] p, q; // 定义寄存器p和q,表示两个素数
    reg clk, reset, reset1, encrypt_decrypt; // 定义寄存器,分别表示时钟信号,重置信号,重置模幂运算模块信号和加密/解密选择信号
    reg [`WIDTH-1:0] msg_in; // 定义寄存器msg_in,表示输入消息
    wire [`WIDTH-1:0] msg_out; // 定义线网msg_out,表示输出消息
    wire mod_exp_finish; // 定义线网mod_exp_finish,表示模幂运算完成信号
    
    // 实例化control模块
    control #(`WIDTH) uut (
        .p(p), // 输入随机素数p和q
        .q(q), // 输入随机素数p和q
        .clk(clk), // 系统全局时钟
        .reset(reset), // 重置反转模块的信号
        .reset1(reset1), // 重置模幂计算模块的信号
        .encrypt_decrypt(encrypt_decrypt), // 加密或解密选择信号,1为加密,0为解密
        .msg_in(msg_in), // 输入的消息或密文
        .msg_out(msg_out), // 输出的解密消息或加密密文
        .mod_exp_finish(mod_exp_finish)
    );
    defparam uut.WIDTH = `WIDTH; // 设置control模块的参数WIDTH为256
    // defparam 用于在实例化模块时设置参数值,以覆盖模块定义中的默认参数.
    // 初始块,用于设置初始条件和测试输入信号

    // 已经成功的测试用例:

    // 论文中的例子
    // p = 256'h67646582052b;
    // q = 256'h1b1aba396153c5af549;
    // msg_in = 256'h262d806a3e18f03ab37b2857e7e149;
    // msg_out = 256'h48656c6c6f20576f726c6421;

    // p与q为32位的例子
    // p = 256'hc1b3b749;
    // q = 256'hbdeca187;
    // msg_in = 256'h8baac7c7
    // msg_out = 256'h5218f60f534c5b39;

    // p与q为64位的例子
    // p = 256'he86cdd23a5acf5fb;
    // q = 256'hb148c27f7265c1e9;
    // msg_in = 256'h53ce5fc2b272267a
    // msg_out = 256'h32fcfcfccd35191dc5a4d4c2d26f24dd

    // 原本到128位就会出现错误,输入输出是有效值，但是加密解密的结果不一样
    
    // 现在已经修改整个项目,让所有WIDTH都是在256基础之上的,之前的模块内部定义的256,32,19,都被统一成了`WIDTH 

    initial begin
        // p = 256'h67646582052b;// 设置p的初始值
        // p = 256'hc1b3b749;
        p = 256'he86cdd23a5acf5fb;

        // q = 256'h1b1aba396153c5af549;// 设置q的初始值
        // q = 256'hbdeca187;
        q = 256'hb148c27f7265c1e9;

        clk = 0; // 初始化时钟信号为0
        reset = 0; reset1 = 0; // 初始化重置信号为0
        encrypt_decrypt = 0; // 设置加密/解密选择信号
        // msg_in = 256'h262d806a3e18f03ab37b2857e7e149; // 设置输入消息
        // msg_in = 256'hh8baac7c7;
        msg_in = 256'h53ce5fc2b272267a;

        #10 reset = 1; // 10个时间单位后,设置重置信号为1
        #10 reset = 0; // 10个时间单位后,设置重置信号为0
        #2980 $finish; // 2980个时间单位后,结束仿真
    end
    
    // 初始块,用于设置重置模幂运算模块信号
    initial begin 
        #1000 reset1 = 1; // 1000个时间单位后,设置reset1信号为1
        #10 reset1 = 0; // 10个时间单位后,设置reset1信号为0
    end
    
    // 总是块,用于生成时钟信号
    always #5 clk = ~clk; // 每5个时间单位,时钟信号翻转一次
    
    // 初始块,用于监视输出信号
    initial begin
        $monitor("At time %t, e = %d", $time, uut.e); // 每当时间发生变化时,输出当前时间和e的值
    end
endmodule

