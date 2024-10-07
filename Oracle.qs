namespace DeutschJozsaAlgorithm {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;

    operation DeutschJozsaOracle(qubits : Qubit[], oracleType : Bool) : Unit {
        // Função que aplica o oráculo.
        // Se oracleType for "true", a função será balanceada.
        // Se oracleType for "false", a função será constante.

        if (oracleType) {
            // Oráculo balanceado (marcando o estado |11>)
            CNOT(qubits[0], qubits[2]);
            CNOT(qubits[1], qubits[2]);
        } else {
            // Oráculo constante (não faz nada, identidade)
            () // Não faz nenhuma operação
        }
    }

    operation DeutschJozsaAlgorithm(oracleType : Bool) : (Result, Result) {
        // Função principal do algoritmo Deutsch-Jozsa para 2 qubits de entrada

        use qubits = Qubit[3];  // Inicializamos 3 qubits: 2 de entrada + 1 auxiliar

        // Etapa 1: Inicializar o qubit auxiliar no estado |1>
        X(qubits[2]);  // Aplicamos X no qubit auxiliar

        // Etapa 2: Aplicar Hadamard em todos os qubits
        ApplyToEachA(H, qubits);  // Hadamard em todos os qubits

        // Etapa 3: Aplicar o Oráculo
        DeutschJozsaOracle(qubits, oracleType);

        // Etapa 4: Aplicar Hadamard novamente nos dois primeiros qubits
        ApplyToEachA(H, qubits[0..1]);

        // Etapa 5: Medir os dois primeiros qubits
        let result1 = M(qubits[0]);  // Medição do primeiro qubit
        let result2 = M(qubits[1]);  // Medição do segundo qubit

        // Etapa 6: Resetar os qubits
        ResetAll(qubits);

        // Retornar os resultados das medições
        return (result1, result2);
    }

    @EntryPoint()
    operation RunDeutschJozsa() : Unit {
        // Testar a função com um oráculo balanceado e um constante

        Message("Resultado para a função balanceada:");
        let (result1, result2) = DeutschJozsaAlgorithm(true);  // Oráculo balanceado
        Message($"Medidas: {result1}, {result2}");

        Message("Resultado para a função constante:");
        let (result1, result2) = DeutschJozsaAlgorithm(false);  // Oráculo constante
        Message($"Medidas: {result1}, {result2}");
    }
}
