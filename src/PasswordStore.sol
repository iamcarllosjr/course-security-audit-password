// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/*
 * @author not-so-secure-dev
 * @title PasswordStore
 * @notice This contract allows you to store a private password that others won't be able to see. 
 * You can update your password at any time.
 */
contract PasswordStore {

    address private s_owner;
    // @audit - s_password não é totalmente privada. Qualquer pessoa pode ler isso.
    string private s_password;

    error PasswordStore__NotOwner();
    
    event SetNetPassword();

    constructor() {
        s_owner = msg.sender;
    }

    /*
     * @notice This function allows only the owner to set a new password.
     * @param newPassword The new password to set.
     */
    // @audit - Qualquer outro usuário pode chamar essa esta função. Falta controle de acesso para esta fução
    function setPassword(string memory newPassword) external {
        //add check owner (acess control)
        // if(msg.sender != s_owner){
        //     revert PasswordStore__NotOwner();
        // }

        s_password = newPassword;
        emit SetNetPassword();
    }

    /*
     * @notice This allows only the owner to retrieve the password.
     */
    function getPassword() external view returns (string memory) {
        if (msg.sender != s_owner) {
            revert PasswordStore__NotOwner();
        }
        return s_password;
    }
}
