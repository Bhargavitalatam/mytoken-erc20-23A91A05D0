// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {

    // 🔐 Owner
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner allowed");
        _;
    }

    // 🔹 Token metadata
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;

    // 🔹 Total supply
    uint256 public totalSupply;

    // 🔹 Balances & allowances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // 🔹 ERC-20 Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 🔹 Constructor
    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply;
        balanceOf[msg.sender] = _initialSupply;
        emit Transfer(address(0), msg.sender, _initialSupply);
    }

    // 🔹 Transfer tokens
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Transfer to zero address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // 🔹 Approve allowance
    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0), "Approve to zero address");

        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // 🔹 Transfer using allowance
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_from != address(0), "Transfer from zero address");
        require(_to != address(0), "Transfer to zero address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    // 🔹 Mint tokens (owner only)
    function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
        require(_to != address(0), "Mint to zero address");

        totalSupply += _amount;
        balanceOf[_to] += _amount;

        emit Transfer(address(0), _to, _amount);
        return true;
    }

    // 🔹 Burn tokens
    function burn(uint256 _amount) public returns (bool) {
        require(balanceOf[msg.sender] >= _amount, "Not enough balance");

        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;

        emit Transfer(msg.sender, address(0), _amount);
        return true;
    }
}
