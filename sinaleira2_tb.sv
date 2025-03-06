// Testbench

`timescale 1ns/10ps

module tb_sinaleira2();
    logic clk, reset, pedestre;
    logic rua_1_vermelho, rua_1_amarelo, rua_1_verde;
    logic rua_2_vermelho, rua_2_amarelo, rua_2_verde;
    logic pedestre_1_vermelho, pedestre_2_verde;

    // Instância do módulo
    sinaleira2 uut (
        .clk(clk),
        .reset(reset),
        .pedestre(pedestre),
        .rua_1_vermelho(rua_1_vermelho),
        .rua_1_amarelo(rua_1_amarelo),
        .rua_1_verde(rua_1_verde),
        .rua_2_vermelho(rua_2_vermelho),
        .rua_2_amarelo(rua_2_amarelo),
        .rua_2_verde(rua_2_verde),
        .pedestre_1_vermelho(pedestre_1_vermelho),
        .pedestre_2_verde(pedestre_2_verde)
    );

    // Geração de clock
    always #5 clk = ~clk;

    // Teste
    initial begin
          $display("Comecou o teste");
          $dumpfile("test.vcd");
          $dumpvars(0,tb); 
	  $timeformat(-9, 2, " ns", 20);
	  #10ns;
	     
        // Inicializações
        clk = 0;
        reset = 1;
        pedestre = 0;
        #10;
        reset = 0;

        // Teste normal sem pedestre
        #100;

        // Teste com pedestre acionando
        pedestre = 1;
        #10;
        pedestre = 0;

        // Teste adicional
        #100;

        // Finaliza
        $finish;
    end
endmodule

