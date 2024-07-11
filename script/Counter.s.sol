// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import "forge-std/console.sol";


contract CounterScript is Script {
    Counter public counter;

    function setUp() public {}

    function run() public {
        
        vm.startBroadcast();
        address proxy = Upgrades.deployTransparentProxy(
            "Counter.sol",
            msg.sender,
            ""
        );
        counter = Counter(proxy);
        counter.increment();
        console.log(counter.number());

        Upgrades.upgradeProxy(proxy, "Counter.sol", "");

        counter = Counter(proxy);

        counter.increment();
        console.log(counter.number());

        vm.stopBroadcast();
    }
}
