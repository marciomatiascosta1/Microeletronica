
module codificador_decodifcador;

    // Sinais para o codificador
    logic clk;
    logic reset;
    logic [7:0] A;
    logic [3:0] D;
    logic sync;
    logic cod_o;

    // Sinais para o decodificador
    logic dec_reset;
    logic [7:0] A_dec;
    logic cod_i;
    logic [3:0] D_dec;
    logic dv;

    // Instância do codificador
    codificador_pt2262 cod_inst (
        .clk(clk),
        .reset(reset),
        .A(A),
        .D(D),
        .sync(sync),
        .cod_o(cod_o)
    );

    // Instância do decodificador
    decodificador_pt2272 dec_inst (
        .clk(clk),
        .reset(dec_reset),
        .A(A_dec),
        .cod_i(cod_i),
        .D(D_dec),
        .dv(dv)
    );

    // Clock generator
    always #5 clk = ~clk; // Gera clock com período de 10 ns

    // Testbench
    initial begin
        // Inicialização
        clk = 0;
        reset = 1;
        dec_reset = 1;
        A = 8'b0;
        D = 4'b0;
        A_dec = 8'b0;
        cod_i = 0;

        // Espera o reset ser processado
        #20;
        reset = 0;
        dec_reset = 0;

        // Caso 1: Transmissão válida
        A = 8'b11001010;  // Endereço
        D = 4'b1010;      // Dados
        A_dec = 8'b11001010; // Endereço esperado no decodificador

        // Espera a codificação e simula a transmissão serial
        @(posedge sync);  // Espera pelo SYNC do codificador
        repeat (12) begin
            cod_i = cod_o; // Transmite bit a bit
            @(posedge clk); // Avança o clock
        end

        // Verifica o resultado
        if (dv && D_dec == D)
            $display("[PASS] Caso 1: Transmissão válida - Dados corretos");
        else
            $display("[FAIL] Caso 1: Transmissão válida - Dados incorretos");

        // Caso 2: Transmissão com endereço inválido
        A = 8'b11001010;  // Endereço
        D = 4'b1111;      // Dados
        A_dec = 8'b10101010; // Endereço incorreto no decodificador

        // Espera a codificação e simula a transmissão serial
        @(posedge sync);  // Espera pelo SYNC do codificador
        repeat (12) begin
            cod_i = cod_o; // Transmite bit a bit
            @(posedge clk); // Avança o clock
        end

        // Verifica o resultado
        if (!dv)
            $display("[PASS] Caso 2: Transmissão inválida - Dados rejeitados corretamente");
        else
            $display("[FAIL] Caso 2: Transmissão inválida - Dados aceitos incorretamente");

        // Caso 3: Transmissão com dado inválido
        A = 8'b10101010;  // Endereço
        D = 4'b0000;      // Dados inválidos (exemplo)
        A_dec = 8'b10101010; // Endereço esperado no decodificador

        // Espera a codificação e simula a transmissão serial
        @(posedge sync);  // Espera pelo SYNC do codificador
        repeat (12) begin
            cod_i = cod_o; // Transmite bit a bit
            @(posedge clk); // Avança o clock
        end

        // Verifica o resultado
        if (!dv)
            $display("[PASS] Caso 3: Dado inválido - Dados rejeitados corretamente");
        else
            $display("[FAIL] Caso 3: Dado inválido - Dados aceitos incorretamente");

        // Fim da simulação
        $finish;
    end

endmodule

