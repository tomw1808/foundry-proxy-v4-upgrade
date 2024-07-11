// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

import {Upgrades} from "openzeppelin-foundry-upgrades/LegacyUpgrades.sol";
import {ProxyAdmin} from "openzeppelin-contracts-4/proxy/transparent/ProxyAdmin.sol";
import {TransparentUpgradeableProxy} from "openzeppelin-contracts-4/proxy/transparent/TransparentUpgradeableProxy.sol";
import "forge-std/console.sol";

/**
start anvil in the background

then run:

forge script ./script/ErrorProxyContracts4.sol --rpc-url http://localhost:8545 --broadcast --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --unlocked --chain-id 137 -vvvv --force 

*/
contract CounterScript is Script {

    function setUp() public {}

    function run() public {
        
        vm.startBroadcast();
        ProxyAdmin proxyAdmin = new ProxyAdmin();
        Counter counter = new Counter();
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(address(counter), address(proxyAdmin), "");

        counter = Counter(address(proxy));
        counter.increment();
        console.log(counter.number());

        Upgrades.upgradeProxy(address(proxy), "Counter.sol", "");

        counter = Counter(address(proxy));

        counter.increment();
        console.log(counter.number());

        vm.stopBroadcast();
    }
}
