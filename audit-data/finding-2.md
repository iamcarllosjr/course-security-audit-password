### [h-1] ``PasswordStore::setPassword`` está faltando controle de acesso. Qualquer pessoa pode chamar esta função.

### Likelihood & Impact : 
- Impact : HIGH
- Likelihood : HIGH
- Severity : HIGH

**Description :**

O contrato diz que a função `setPassword` deveria ser chamada apenas pelo proprietário do contracto, mas nela não há nenhuma verificação de controle de acesso, no que resulta ser chamada por qualquer pessoa que não seja o proprietário deste contrato.

**Impact :**

Qulquer pessoa que não seja o proprietário do contrato poderá chamar a função `setPassword`e alterar a senha.

Em `PasswordStore::setPassword` não existe uma verificação para permitir que apenas o proprietário deste contrato possa
chamar esta função.

```javascript
@>  // @audit Nesta função não há uma verificação de controle de acesso :
    function setPassword(string memory newPassword) external {
        s_password = newPassword;
        emit SetNetPassword();
    }
```

**Proof of Concept :**

Testando vários endereços chamando a função `setPassword`. Adicione este código em seu arquivo de testes.

```javascript
   function test_non_owner_can_call_setPassword(address randomAddress) public {
        vm.assume(randomAddress != owner);
        string memory expectPassword = "myNewPassword";
        vm.prank(randomAddress); //Usando endereços aleatórios para chamar a função setPassword
        passwordStore.setPassword(expectPassword);

        vm.prank(owner);
        string memory actualPassword = passwordStore.getPassword();
        assertEq(actualPassword, expectPassword);
    }
```

**Recommended Mitigation :**

Recomendo adicionar um tipo de verificação, onde reverta a transação caso o chamador não seja o proprietário do contrato.

Mitigação recomendada :

```javascript 
    function setPassword(string memory newPassword) external {
        if(msg.sender != s_owner){
            revert PasswordStore__NotOwner();
        }

        s_password = newPassword;
        emit SetNetPassword();
    }
```