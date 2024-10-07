namespace DeutschJozsa1Qubit {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;

    operation DeutschJozsaOracle(qubits : Qubit[], oracleType : Bool) : Unit {
        // Função que aplica o oráculo.
        // Se oracleType for "true", a função será balanceada.
        // Se oracleType for "false", a função será constante.

        if (oracleType) {
            // Oráculo balanceado (inverte para o estado |x = 1>)
            CNOT(qubits[0], qubits[1]);  // Aplicamos CNOT entre qubit de entrada e auxiliar
        } else {
            // Oráculo constante (não faz nada, identidade)
            () // Não faz nenhuma operação
        }
    }

    operation DeutschJozsaAlgorithm(oracleType : Bool) : Result {
        // Função principal do algoritmo Deutsch-Jozsa para 1 qubit de entrada

        use qubits = Qubit[2];  // Inicializamos 2 qubits: 1 de entrada + 1 auxiliar

        // Etapa 1: Inicializar o qubit auxiliar no estado |1>
        X(qubits[1]);  // Aplicamos X no qubit auxiliar para que ele comece no estado |1>

        // Etapa 2: Aplicar Hadamard em ambos os qubits
        ApplyToEach(H, qubits);  // Hadamard em todos os qubits

        // Etapa 3: Aplicar o Oráculo
        DeutschJozsaOracle(qubits, oracleType);

        // Etapa 4: Aplicar Hadamard novamente no primeiro qubit (qubit de entrada)
        H(qubits[0]);

        // Etapa 5: Medir o qubit de entrada
        let result = M(qubits[0]);  // Medição do qubit de entrada

        // Resetar os qubits
        ResetAll(qubits);

        // Retornar o resultado da medição
        return result;
    }

    @EntryPoint()
    operation RunDeutschJozsa() : Unit {
        // Testar a função com um oráculo balanceado e um constante

        Message("Resultado para a função balanceada:");
        let result = DeutschJozsaAlgorithm(true);  // Oráculo balanceado
        Message($"Medida: {result}");

        Message("Resultado para a função constante:");
        let result = DeutschJozsaAlgorithm(false);  // Oráculo constante
        Message($"Medida: {result}");
    }
}
