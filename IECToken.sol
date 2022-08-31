// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IEC is ERC20, Ownable {


    constructor() ERC20("IEC", "iec") {
    }

    /*
     *  tokenPrice has been initialised to 1 ether
    */
    
    uint public tokenPrice =1 ether;

  
    error AmountCannotBeZero();
    error OwnerCannotBuyIECToken();
    error PleaseSendExactPrice();

    event TokenMinted (address mintedBy, uint amount);
    event TokenBought (address buyer, uint price);
    event TokenPriceUpdate(address priceUpdatedBy, uint price);

    
    /*
     * @dev mint is used to mint the IEC contract
     *
     *
     * Requirements:
     * this function can only be called by owner of contract
     * minted amount can not be equall to zero
     * emits a (TokenMinted) event
     * 
     */
    function mint(address to, uint256 amount) public onlyOwner {
        if(amount<=0) {
         revert AmountCannotBeZero();
        } 
        _mint(to, amount);
        emit TokenMinted(msg.sender,amount);
    }


    /*
     * @dev buyIEC is used to buy the IEC token
     *
     *
     * Requirements:
     * this function can not be called by owner of contract
     * msg.value must be equall to price of token
     * emits a (TokenBought) event
     * is a payable function
     */

    function buyIEC( ) public payable {
        if(msg.sender == owner()){
            revert  OwnerCannotBuyIECToken();
        }
        if(msg.value !=tokenPrice){
            revert PleaseSendExactPrice();
        }

        _transfer(owner(),msg.sender,1);
        payable(owner()).transfer(msg.value);
        emit TokenBought(msg.sender, msg.value);
    }

    /*
     * @dev updateIECTokenPrice is used to mint the IEC Token
     *
     *
     * Requirements:
     * this function can only be called by owner of contract
     * minted amount can not be equall to zero
     * emits a (TokenPriceUpdate) event
     * 
     */
    function updateIECTokenPrice(uint _tokenPrice) public onlyOwner{
        if(_tokenPrice<=0) {
         revert AmountCannotBeZero();
        } 
        tokenPrice=_tokenPrice;
        emit  TokenPriceUpdate(msg.sender , _tokenPrice);
    }
}
