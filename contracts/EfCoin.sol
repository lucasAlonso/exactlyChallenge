// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EfCoin is Ownable {
    uint256 private _totalEthDeposited;
    uint256 private _totalEfCoin;
    uint256 private _efcoinPerEth;

    constructor() {
        _efcoinPerEth = 1 * 10**28;
        _totalEfCoin = 0;
        _totalEthDeposited = 0;
    }

    mapping(address => uint256) private _efcoinBalances;

    function balanceOf(address who) public view returns (uint256) {
        return ((_efcoinBalances[who] * 10**28) / _efcoinPerEth);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        uint256 _efcoinAmount;
        _efcoinAmount = (amount * _efcoinPerEth) / 10**28;
        _efcoinBalances[to] += _efcoinAmount;
        _totalEfCoin = _totalEfCoin + _efcoinAmount;
        _totalEthDeposited = _totalEthDeposited + amount;
    }

    function burn(address who) public onlyOwner {
        _totalEthDeposited = _totalEthDeposited - balanceOf(who);
        _totalEfCoin -= _efcoinBalances[who];
        _efcoinBalances[who] = 0;
    }

    function burnWithAmount(address who, uint256 _amountOfEth)
        public
        onlyOwner
    {
        uint256 balanceEfCoin = _efcoinBalances[who];
        uint256 amountOfEfCoin = (_amountOfEth * _efcoinPerEth) / 10**28;
        _totalEthDeposited -= _amountOfEth;
        _totalEfCoin -= amountOfEfCoin;
        _efcoinBalances[who] -= amountOfEfCoin;
    }

    function rebase(uint256 supplyDelta) public onlyOwner {
        require(supplyDelta != 0);

        _totalEthDeposited = _totalEthDeposited + supplyDelta;
        _efcoinPerEth = (10**28 * _totalEfCoin) / _totalEthDeposited;
    }

    function totalSupply() public view returns (uint256) {
        return _totalEthDeposited;
    }

    function efcoinPerEth() public view returns (uint256) {
        return _efcoinPerEth;
    }
}

/* 
 KEEPED ONLY FOR SHOW THE LEARNING PROCCESS

first time i tried to do an ERC20 and extend functions, but when i need to do some changes it was hard not to override some ERC20 FUNCTION
I then decide to make a simple, easy to audit token just with the small quant of function i needed

///////////////////////////////////////////


pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EfCoin is ERC20, ERC20Burnable, Pausable, Ownable {
    uint256 private _totalEthDeposited;
    uint256 private _totalEfCoin;
    uint256 private _efcoinPerEth;

    constructor() ERC20("exactCoin", "EFC") {
        _mint(msg.sender, 0);
        _efcoinPerEth = 1 * 10**28;
        _totalEfCoin = 0;
        _totalEthDeposited = 0;
    }

    mapping(address => uint256) private _efcoinBalances;

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function balanceOf(address who) public view override returns (uint256) {
        return ((_efcoinBalances[who] * 10**28) / _efcoinPerEth);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        uint256 _newAmount;
        _newAmount = (amount * _efcoinPerEth) / 10**28;
        _efcoinBalances[to] += _newAmount;
        _totalEfCoin = _totalEfCoin + _newAmount;
        _totalEthDeposited = _totalEthDeposited + amount;
    }

    function burnGons(address who, uint256 _amount) public onlyOwner {
        uint256 amountOfGons = _amount * _efcoinPerEth;
        _efcoinBalances[who] -= _amount;
    }

    //haCER EL BURN!!!!
    function rebase(uint256 supplyDelta) public onlyOwner {
        require(supplyDelta != 0);
        _totalEthDeposited = _totalEthDeposited + supplyDelta;
        _efcoinPerEth = (10**28 * _totalEfCoin) / _totalEthDeposited;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalEthDeposited;
    }

    function gonsPerECoin() public view returns (uint256) {
        return _efcoinPerEth;
    }
} */
