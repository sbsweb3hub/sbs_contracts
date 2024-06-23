// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProjectManagerPrice {
    address public orderingAddr;
    address public votingAddr;
    address public tokensMainForProjectAddr;

    struct CreatePrice {
        uint256 tokenSupply; // минтится в процессе
        uint256 maxTokenSupply; // устанавливается при создании, включает все сегменты
        uint256 minTokenSale; // устанавливается при создании, сколько нужно продать первично
        uint256 price;
        uint256 publicSale; // сколько хотят продать монет
        bool isProjectAlive; // прошел ли проект голосование либо полностью завершен
        bool isPrijectGetAllTokens; // получил ли проект все свои токены после завершения работы
        uint256 fundsForProject; // общее кол-во средств для проекта
    }

    event ProjectCreatedPrice(CreatePrice project);

    uint32 public projectIdPrice = 1;

    mapping(uint32 => CreatePrice) getProjectPrice;

    function setUsingAddrsForPrice(address _orderingAddr, address _votingAddr, address _tokensMainForProjectAddr)
        internal
    {
        orderingAddr = _orderingAddr;
        votingAddr = _votingAddr;
        tokensMainForProjectAddr = _tokensMainForProjectAddr;
    }

    function projectsViewPrice(uint32 projectId)
        public
        view
        returns (uint256, uint256, uint256, uint256, uint256, bool, bool, uint256)
    {
        CreatePrice memory project = getProjectPrice[projectId];
        return (
            project.tokenSupply,
            project.maxTokenSupply,
            project.minTokenSale,
            project.price,
            project.publicSale,
            project.isProjectAlive,
            project.isPrijectGetAllTokens,
            project.fundsForProject
        );
    }

    function createProjectPrice(uint256 _maxTokenSupply, uint256 _minTokenSale, uint256 _price, uint256 _publicSale)
        internal
        returns (uint32)
    {
        CreatePrice memory project = CreatePrice({
            tokenSupply: 0,
            maxTokenSupply: _maxTokenSupply,
            minTokenSale: _minTokenSale,
            price: _price,
            publicSale: _publicSale,
            isProjectAlive: true,
            isPrijectGetAllTokens: false,
            fundsForProject: 0
        });
        //тут можно добавить пересылку токенов проекта на адрес контракта, если эти токены уже есть у проекта
        getProjectPrice[projectIdPrice] = project;
        projectIdPrice++;
        emit ProjectCreatedPrice(project);
        return projectIdPrice - 1;
    }

    function orderPrice(uint32 _projectIdPrice, uint256 _tokenSupply, uint256 _fundsForProject) external {
        require(msg.sender == orderingAddr, "Not allowed");
        getProjectPrice[_projectIdPrice].tokenSupply = _tokenSupply;
        getProjectPrice[_projectIdPrice].fundsForProject = _fundsForProject;
    }

    function closeProject(uint32 _projectIdPrice) external {
        require(msg.sender == votingAddr, "Not allowed");
        getProjectPrice[_projectIdPrice].isProjectAlive = false;
    }

    function setGettingAllTokens(uint32 _projectIdPrice) external {
        require(msg.sender == tokensMainForProjectAddr, "Not allowed");
        getProjectPrice[_projectIdPrice].isPrijectGetAllTokens = true;
    }
}
