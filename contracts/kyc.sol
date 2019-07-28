pragma solidity ^0.5.9;

contract kyc {

    address admin;

    /*
    Struct for a customer
     */
    struct Customer {
        string userName;
        string customerData;
        uint32 rating;
        uint32 upvotes;
        address firstBank;
        string password;
    }

    /*
    Struct for a Bank
     */
    struct Bank {
        string bankName;
        address ethAddress;
        uint32 rating;
        uint32 kycCount;
        string regNumber;
        bool isAllowed;
    }

    //Customer Map 
    mapping(string => Customer) customers;
    string[] customerNames;

    //Banks
    mapping(address => Bank) banks;
    address[] bankAddresses;

    
    // KycRequest Mapping. Used to track all the requests initiated by the bank for customer
    mapping(address => mapping(string => uint256)) kycRequestMapping;

    constructor() public {
        admin = msg.sender;
    }

    /**
    * Admin/Blockchain Interface
    * */

    // Add Bank
    function addBank(string calldata _bankName, address _ethAddress, string calldata _regNumber) external adminOnly returns (bool) {
        require(banks[_ethAddress].ethAddress == address(0), "This bank is already registered!");
        banks[_ethAddress].bankName = _bankName;
        banks[_ethAddress].ethAddress = _ethAddress;
        banks[_ethAddress].regNumber = _regNumber;
        banks[_ethAddress].isAllowed = true;
        bankAddresses.push(_ethAddress);
        return true;
    }

    // Remove Bank
    function removeBank(address _ethAddress) external adminOnly returns (bool) {
        require(banks[_ethAddress].ethAddress != address(0), "Bank is not registered!");
        delete banks[_ethAddress];
        return true;
    }

    // Get Bank Name
    // Can be called by Customer and Admin
    function getBankName(address _ethAddress) external view returns (string memory) {
        require(banks[_ethAddress].ethAddress != address(0), "Bank is not registered!");
        return banks[_ethAddress].bankName;
    }

    // Get Bank Rating
    // Can be called by Customer and Admin
    function getBankRating(address _ethAddress) external view returns (uint32) {
        require(banks[_ethAddress].ethAddress != address(0), "Bank is not registered!");
        return banks[_ethAddress].rating;
    }

    // Enable bank for KYC
    function enableBankForKyc(address _ethAddress) external adminOnly returns (bool) {
        require(banks[_ethAddress].ethAddress != address(0), "Bank is not registered!");
        banks[_ethAddress].isAllowed = true;
        return true;
    }

    // Diable bank for KYC
    function disableBankForKyc(address _ethAddress) external adminOnly returns (bool) {
        require(banks[_ethAddress].ethAddress != address(0), "Bank is not registered!");
        banks[_ethAddress].isAllowed = false;
        return true;
    }

    /**
    * Customer/Blockchain Interface
    * */
    function setCustomerPassword(string calldata _userName, string calldata _password) external returns (bool) {
        require(bytes(customers[_userName].userName).length != 0, "Customer not found!");
        customers[_userName].password = _password;
        return true;
    }

    function viewCustomerData(string calldata _userName) external view returns (string memory) {
        require(bytes(customers[_userName].userName).length != 0, "Customer not found!");
        return customers[_userName].customerData;
    }

    function getCustomerRating(string calldata _userName) external view returns (uint32) {
        require(bytes(customers[_userName].userName).length != 0, "Customer not found!");
        return customers[_userName].rating;
    }


    /****
    * Bank/Blockchain Interface
    **/


    /**
     * Modifier to check if the message caller is an admin
     */
    modifier adminOnly {
        require(msg.sender == admin);
        _;
    }


}