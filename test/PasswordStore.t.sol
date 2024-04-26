//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {PasswordStore} from "../src/PasswordStore.sol";
import {DeployPasswordStore} from "../script/DeployPasswordStore.s.sol";
contract PasswordTest is Test {
    PasswordStore public passwordStore;
    DeployPasswordStore public deployPassword;
    address public owner;

    function setUp() external {
        deployPassword = new DeployPasswordStore();
        passwordStore = deployPassword.run();
        owner = msg.sender;
    }

    function test_owner_can_set_password() public {
        vm.startPrank(owner);
        string memory newPassword = "1234";
        passwordStore.setPassword(newPassword);
        string memory actuallyPassword = passwordStore.getPassword();
        assertEq(actuallyPassword, newPassword);
    }

    function test_non_owner_set_password_reverts() public {
        vm.prank(address(1));
        string memory newPassword = "1234";
        vm.expectRevert(PasswordStore.PasswordStore__NotOwner.selector);
        passwordStore.setPassword(newPassword);
    }

    function test_non_owner_can_reading_password() public {
         vm.startPrank(address(1));
         vm.expectRevert(PasswordStore.PasswordStore__NotOwner.selector);
         passwordStore.getPassword();
    }

    function test_non_owner_can_call_setPassword(address randomAddress) public {
        vm.assume(randomAddress != owner);
        string memory expectPassword = "myNewPassword";
        vm.prank(randomAddress);
        passwordStore.setPassword(expectPassword);

        vm.prank(owner);
        string memory actualPassword = passwordStore.getPassword();
        assertEq(actualPassword, expectPassword);
    }
}