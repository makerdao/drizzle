// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.6.12;

import "ds-test/test.sol";

import { Drizzle     } from "./Drizzle.sol";
import { DrizzleView,
         VatLike,
         JugLike } from "./DrizzleView.sol";

interface Hevm {
    function warp(uint256) external;
}

contract DrizzleViewTest is DSTest {

    //Mainnet
    address constant public ILK_REGISTRY = 0x5a464C28D19848f44199D003BeF5ecc87d090F87;
    address constant public VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant public JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant public POT = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;

    Drizzle     drizzle;
    DrizzleView drizzleView;
    Hevm        hevm;
    // CHEAT_CODE = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D
    bytes20 constant CHEAT_CODE =
        bytes20(uint160(uint256(keccak256('hevm cheat code'))));

    function setUp() public {
        hevm = Hevm(address(CHEAT_CODE));
        drizzle = new Drizzle();
        drizzleView = new DrizzleView();
    }

    function testDrizzleViewDoesNotRevert() public {
        drizzleView.undripped();
        drizzleView.undripped(2400);
        assertEq(uint(1),uint(1));
    }

    function testDrizzle() public {
        bytes32[] memory _ilks = drizzleView.undripped(1);
        assertTrue(_ilks.length > 1);

        drizzle.drizzle(_ilks);
        _ilks = drizzleView.undripped(1);
        assertEq(_ilks.length, 0);

        hevm.warp(block.timestamp + 24 hours);

        _ilks = drizzleView.undripped(25 hours);
        assertEq(_ilks.length, 0);

        _ilks = drizzleView.undripped();
        assertTrue(_ilks.length > 1);

        drizzle.drizzle(_ilks);
        _ilks = drizzleView.undripped(1);
        assertEq(_ilks.length, 0);

        hevm.warp(block.timestamp + 24 hours);
        _ilks = drizzleView.undripped(25 hours);
        assertEq(_ilks.length, 0);
        _ilks = drizzleView.undripped(23 hours);
        assertTrue(_ilks.length > 1);
    }

    function testDrizzleArray() public {
        bytes32[] memory _ilks = drizzleView.undripped(100);
        assertTrue(_ilks.length > 1);

        for (uint256 i = 0; i < _ilks.length; i++) {
            (uint256 _duty, uint256 _rho) = JugLike(JUG).ilks(_ilks[i]);
            (uint256 _Art,,,,) = VatLike(VAT).ilks(_ilks[i]);
            assertTrue(_duty > 1000000000000000000000000000);
            assertTrue(_rho < block.timestamp - 100);
            assertTrue(_Art > 0);
        }
    }
}
