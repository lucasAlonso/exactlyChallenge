// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./EfCoin.sol";

interface IEfCoin {
    function totalSupply() external view returns (uint256);

    function burn(address) external;

    function balanceOf(address account) external view returns (uint256);

    function mint(address to, uint256 amount) external;

    function rebase(uint256) external;

    function efcoinPerEth() external view returns (uint256);
}

contract ETHPool is Ownable {
    address public tokenAddress;
    address public teamAddress;

    constructor(address _token) {
        require(_token != address(0), "token invalido");
        tokenAddress = _token;
        teamAddress = msg.sender;
    }

    function withdraw() public {
        IEfCoin token = IEfCoin(tokenAddress);
        uint256 _balance;
        _balance = token.balanceOf(msg.sender);
        token.burn(msg.sender);
        payable(msg.sender).transfer(_balance);
    }

    receive() external payable {
        if (msg.sender == teamAddress) {
            IEfCoin token = IEfCoin(tokenAddress);
            token.rebase(msg.value);
        } else {
            IEfCoin token = IEfCoin(tokenAddress);
            token.mint(msg.sender, msg.value);
        }
    }
}

/* 
contract ETHPool is ERC20, Ownable {
    address public tokenAddress;
    address public teamAddress;

    constructor(address _token) ERC20("exactCOIN", "EFC") {
        require(_token != address(0), "token invalido");
        tokenAddress = _token;
        teamAddress = msg.sender;
    }

    function withdraw(uint256 _amount) public {
        EfCoin token = EfCoin(tokenAddress);
        uint256 _balance;
        uint256 _gonsPerEcoin;
        _balance = token.balanceOf(msg.sender);
        require(_balance >= _amount);
        _gonsPerEcoin = token.gonsPerECoin();
        token.burnGons(msg.sender, 2* 10**18);
        payable(msg.sender).transfer(_amount);
    }

    receive() external payable {
        if (msg.sender == teamAddress) {
            EfCoin token = EfCoin(tokenAddress);
            token.rebase(msg.value);
        } else {
            EfCoin token = EfCoin(tokenAddress);
            token.mint(msg.sender, msg.value);
        }
    }
}
 */
