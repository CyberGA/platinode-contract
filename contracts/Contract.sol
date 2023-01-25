// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract PlatinumFunding{

    struct Project {
        address owner;
        string title;
        string desc;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping (uint256 => Project) public projects;

    uint256 public numberOfProjects = 0;

    function createProject(address _owner, string memory _title, string memory _desc, 
    uint256 _target, uint256 _deadline, string memory _image) external returns (uint256)  {
        Project storage project = projects[numberOfProjects];

        // check if deadline is not in the future
        require(project.deadline < block.timestamp, "Invalid deadline");

        project.owner = _owner;
        project.title = _title;
        project.desc = _desc;
        project.target = _target;
        project.deadline = _deadline;
        project.amountCollected = 0;
        project.image = _image;

        numberOfProjects++;

        return numberOfProjects - 1;

    }

    function donateToProject(uint256 _id) external payable {
        uint256 amount = msg.value;
        Project storage project = projects[_id];

        // adds donator and the donation amount to the project started
        project.donators.push(msg.sender);
        project.donations.push(amount);

        (bool sent, ) = payable(project.owner).call{value: amount}("");

        if(sent) {
            project.amountCollected = project.amountCollected + amount;
        }

    }

    function getDonators(uint256 _id) external view returns(address[] memory, uint256[] memory) {
        return (projects[_id].donators, projects[_id].donations);
    }

    function getProjects() external view returns (Project[] memory) {
        Project[] memory allProjects = new Project[](numberOfProjects);

        for(uint i = 0; i < numberOfProjects; i++) {
            Project storage item = projects[i];

            allProjects[i] = item;
        }

        return allProjects;
    }
}