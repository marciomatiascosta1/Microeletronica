// Avaliação parcial 1 - parte 2
// Marcio Antonio Matias Costa
// Matrícula: 202470039
// x igual 9 e y igual 3

//    Rua 1 permanece VERDE por 9 segundos
//    Rua 2 permanece VERDE por 3 segundos
//    A transição por AMARELO deve durar 2 segundos em qualquer dos casos que ocorrer ligação desta luz.
//    Para os pedestres permanece VERDE por 5s após pedido (porta “pedestre” em nível alto)



module sinaleira2(
    input  clk,
    input  reset,
    input  pedestre,
    output rua_1_vermelho,
    output rua_1_amarelo,
    output rua_1_verde,
    output rua_2_vermelho,
    output rua_2_amarelo,
    output rua_2_verde,
    output pedestre_1_vermelho,
    output pedestre_2_verde
);

    typedef enum logic [3:0] {
        Inicio,
        RUA1_VERDE,
        RUA1_AMARELO,
        RUA2_VERDE,
        RUA2_AMARELO,
        PEDESTRE_VERDE
    } state_t;

    etapa_ff, estado_atual, prox_estado;
    logic [3:0] timer;

    // Lógica de temporização
    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            timer <= 0;
        else if (estado_atual != prox_estado) 
            timer <= 0; // Reinicia o contador ao mudar de estado
        else 
            timer <= timer + 1;
    end

    // Máquina de estados
    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            estado_atual <= INICIO;
        else 
            estado_atual <= prox_estado;
    end

    always_comb begin
        // Valores padrão
        next_state = estado_atual;
        rua_1_vermelho = 1;
        rua_1_amarelo = 0;
        rua_1_verde = 0;
        rua_2_vermelho = 1;
        rua_2_amarelo = 0;
        rua_2_verde = 0;
        pedestre_1_vermelho = 1;
        pedestre_2_verde = 0;

        case (estado_atual)
            INICIO: begin
                prox_estado = RUA1_VERDE;
            end

            RUA1_VERDE: begin
                rua_1_verde = 1;
                rua_2_vermelho = 1;
                if (timer == 9) 
                    prox_estado = RUA1_AMARELO;
            end

            RUA1_AMARELO: begin
                rua_1_amarelo = 1;
                rua_2_vermelho = 1;
                if (timer == 2) 
                    prox_estado = RUA2_VERDE;
            end

            RUA2_VERDE: begin
                rua_2_verde = 1;
                rua_1_vermelho = 1;
                if (timer == 3) 
                    prox_estado = RUA2_AMARELO;
            end

            RUA2_AMARELO: begin
                rua_2_amarelo = 1;
                rua_1_vermelho = 1;
                if (timer == 2) 
                    prox_estado = (pedestre) ? PEDESTRE_VERDE : RUA1_VERDE;
            end

            PEDESTRE_VERDE: begin
                pedestre_2_verde = 1;
                pedestre_1_vermelho = 0;
                rua_1_vermelho = 1;
                rua_2_vermelho = 1;
                if (timer == 5) 
                    next_state = RUA1_VERDE;
            end
        endcase
    end
endmodule












endmodule
