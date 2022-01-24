pragma solidity ^0.8.0;

import "./StableCoin.sol";
import "./CoderCoin.sol";

contract YieldFarm{
    
    // global state variables
    //public visibility gives access outside smart contract
    //statically typed string to denote which datatype the varibales store
    address public owner;
    string public yieldFarmName = "Bored Coder's Club";

    //Datatype are smart contract type
    //we are grabbing the smart contract address of StableCoin and CoderCoin 
    StableCoin public stablecoin;
    CoderCoin public codercoin;

    //mapping data structure to keep track of investor address => _amount of stablecoins
    mapping (address=>uint256) public stakedAmount;

    //mapping to keep track if investor has stakedAmount
    mapping(address=>bool) public hasStaked;

    //mapping to track current staking status
    mapping(address=>bool)public isStaking;

    //dynamic array to keep track of address of all the stakers
    address[] public stakers;

    constructor(StableCoin _stablecoin,CoderCoin _codercoin) public {

        //_stablecoin,_codercoin local varibales
        stablecoin = _stablecoin;
        codercoin=_codercoin;
        owner = msg.sender;

    }

    //modofier
    modifier hasEnoughStakingBalance {
        require(_amount > 0 ,"not enough balance");
        _;
    }
    // stake StableCoin
    function stakeStableCoin(uint256 _amount) public hasEnoughStakingBalance {

        //transferFrom() is a function in StableCoin smart contract that allows 
        //another smart contract to transfer fund on their behalf
        //msg is global variable
        //msg.sender refers to the address of the smart contract which is calling this function i.e the investor
        //address(this) refers to the address of this smart contract
        stablecoin.transferFrom(msg.sender,address(this),_amount);

        //updating staking balance
        stakedAmount[msg.sender] += _amount;

        //only one time registering of stakers address in array
        if (!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }

        //updating staking status of investors
        isStaking[msg.sender]=true;
        hasStaked[msg.sender]= true;

    }

    //issuing yield in CoderCoin
    function issueCoderCoin() public {

        //only ownerof the smart contract can issue codercoin
        require(msg.sender == owner,"admin only");

        //looping the list of all stakers of StableCoin
        for (uint8 x=0 ; x <stakers.length ; x++) {

            //getting the addresses for issuing yield
            address yieldRecipient = stakers[x];

            //we are getting how much stable coin has been stakedAmount
            uint256 stakingamountOfRecipient = stakedAmount[msg.sender];

            //yield of CoderCoin
            if(stakingamountOfRecipient > 0){
                codercoin.transfer(yieldRecipient,stakingamountOfRecipient);
                 }
             }
    }


    // unstaking StableCoin
    function withdrawStableCoin() public {
        uint256 stakingamountOfRecipient = stakedAmount[msg.sender];

        require(stakingamountOfRecipient > 0 ; "not enough balance");


        //trnasferring back stablecoins to the investor
        stablecoin.transfer(msg.sender,stakingamountOfRecipient);

        //after withdrwawing
        isStaking[msg.sender] = false;

        //investor withdrawn all the stablecoins
        stakedAmount[msg.sender] = 0;


    }
    

}
