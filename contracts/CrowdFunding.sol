// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    //struct for data(data types) used for campaign.
    /**
    1.owner - the owner of the campaign
    2.title - the title of the campaign
    3.description - the description of the campaign
    4.target - the monetary target of the campaign
    5.deadline - the deadline of the campaign
    6.amountCollected - the amount of donations collected
    7.image - the logo or thumbnail for thecampaign
    8.donators- array of contributors
    9.donations- array of donation 
     */
    struct Campaign{
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }
    mapping(uint256 =>Campaign) public campaigns;
    //track the number of campaigns -Used to ID campaign
    uint256 public numberOfCampaigns =0;
    
    //Create the structure of all the functions used in the smart contract

    //createCampaign function- Creates a new campaign
    //returns the ID of the campaign
    function createCampaign(address _owner,string memory _title, string memory _description,uint256 _target,
    uint256 _deadline,string memory _image)public returns(uint256){
        Campaign storage campaign = campaigns[numberOfCampaigns];
    //Require that the date of campaign creation is for a future time.
        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");

    //Set struct variables to the createCampaign(parameters)
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        //Increment through the number of campaigns
        numberOfCampaigns++;

        //Return the index of the most recently created campaign
        return numberOfCampaigns -1;

    }
    //*******/
    
    //donateToCampaign - function to handle contract donations
    function donateToCampaign(uint256 _id)public payable{
        //The amount being donated
        uint256 amount = msg.value;
        //Takes the id of the campaign in campaigns array 
        //and stores it 
        Campaign storage campaign = campaigns[_id]; 
        //Push the address of indivdiual(s) that donated
        campaign.donators.push(msg.sender);
        //Push the amount being sent
        campaign.donations.push(amount);

        //Verifies if a transaction was sent successfully
        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if(sent){
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }
    //*******/

    //getDonators - function to retrieve individuals(data) that donate
    function getDonators(uint256 _id)view public returns(address[] memory,uint256[] memory){
        return(campaigns[_id].donators,campaigns[_id].donations);
    }
    //*******/

    //getCampaigns - returns all campaigns
    function getCampaigns()public view returns(Campaign[] memory){
    //Save the number of campaigns created to  allCampaigns variable
    Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

    for(uint i =0; i < numberOfCampaigns; i++){
        Campaign storage item = campaigns[i];
        allCampaigns[i] = item;
    }
    return allCampaigns;
    
    }
}