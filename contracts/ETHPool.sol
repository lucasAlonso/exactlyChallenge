// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EfCoin.sol";

interface IEfCoin {
    function totalSupply() external view returns (uint256);

    function burn(address) external;

    function burnWithAmount(address, uint256) external;

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

    function withdrawWithAmount(uint256 _amount) public {
        IEfCoin token = IEfCoin(tokenAddress);
        uint256 _balance;
        _balance = token.balanceOf(msg.sender);
        require(_balance >= _amount);

        token.burnWithAmount(msg.sender, _amount);
        payable(msg.sender).transfer(_amount);
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

/* KEEPED ONLY FOR SHOW THE LEARNING PROCCESS

first time i tried to do an ERC20 and extend functions, but when i need to do some changes it was hard not to override some ERC20 FUNCTION
I then decide to make a simple, easy to audit token just with the small quant of function i needed

///////////////////////////////////////////
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
