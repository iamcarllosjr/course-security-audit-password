### [H-1] Dados armazenados na blockchain é visivel para todos, mesmo declarados como "private". Qualquer pessoa pode ver suas senhas.

### Likelihood & Impact : 
- Impact : HIGH
- Likelihood : HIGH
- Severity : HIGH

**Description :**

Todos os dados armazenados na blockchain são visíveis para qualquer pessoa e podem ser lidos diretamente. A variavel `PasswordStore::s_password` destina-se a ser uma varialbe privada e acessada apenas por meio da função `PasswordStore::getPassword`, que deve ser chamada apenas pelo proprietário do contrato. 


**Impact :**

Qualquer pessoa pode ver o que está guardado na variavel `s_password`, o que o torna "Publica" quando se trata de Blockchain.

Mostrarei um desses métodos de leitura de quaisquer dados fora da cadeia abaixo.

**Proof of Concept :**

- Implante o contrato na rede de teste local com o anvil.
1. `anvil --fork-url [https://polygon-amoy.g.alchemy.com/v2/](https://polygon-amoy.g.alchemy.com/v2/z8ACTX_3pculA8aJ4beqWaIEgGnYjqVj)API_KEY`

2. `forge script script/DeployPasswordStore.s.sol:DeployPasswordStore --rpc-url [http://127.0.0.1:8545](http://127.0.0.1:8545/) —broadcast —private-key (chave privada que o anvil gera)`

- Verifique o slot da variável “privada” : `forge inspect PasswordStore storage`

- No terminal, irá te mostrar o armazenamento do contrato, como nomes de variáveis e seu slot.

- Comando para ler o valor do slot passando o address do contrato e o número do slot : `cast storage 0x5FbDB2315678afecb367f032d93F642f64180aa3 1 --rpc-url [http://127.0.0.1:8545](http://127.0.0.1:8545/)`

- Em seguida, você verá a representação em bytes do valor da variável.

- Converta para string : `cast parse-bytes32-string 0x0000000000000000000000000000000000000000000000000000000000000000`

- cast parse não funcionou, usei o `cast tas`

**Recommended Mitigation :**

Devido a isso, a arquitetura geral do contrato deve ser repensada. Pode-se criptografar a senha fora da blockchain e armazenar a senha criptografada on-chain. Isso exigiria que o usuário se lembrasse de outra senha fora da cadeia para descriptografar a senha. No entanto, você provavelmente também desejaria remover a função de visualização, pois não permitiria que o usuário enviasse acidentalmente uma transação com a senha que descriptografa sua senha.