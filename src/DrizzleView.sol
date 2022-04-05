// SPDX-License-Identifier: AGPL-3.0-or-later

/// DrizzleView.sol -- Get array of undripped ilks.

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity ^0.6.12;

interface Chainlog {
    function getAddress(bytes32) external returns (address);
}

interface IlkRegistry {
    function list() external view returns (bytes32[] memory);
}

interface VatLike {
    function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);
}

interface JugLike {
    function ilks(bytes32) external view returns (uint256 duty, uint256 rho);
}

contract DrizzleView {

    Chainlog    private constant  _chl = Chainlog(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);
    uint256     private constant  _min = 1000000000000000000000000000; // 0% jug duty rate

    IlkRegistry private immutable _reg;
    VatLike     private immutable _vat;
    JugLike     private immutable _jug;

    constructor() public {
        _reg = IlkRegistry(_chl.getAddress("ILK_REGISTRY"));
        _vat = VatLike(_chl.getAddress("MCD_VAT"));
        _jug = JugLike(_chl.getAddress("MCD_JUG"));
    }

    function _sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }

    function _undripped(uint256 sec) internal view returns (bytes32[] memory) {
        bytes32[] memory _ilks = _reg.list();
        bytes32[] memory buf = new bytes32[](_ilks.length);
        uint256 count;

        for (uint256 i = 0; i < _ilks.length; i++) {
            (uint256 _duty, uint256 _rho) = _jug.ilks(_ilks[i]);
            (uint256 _Art,,,,) = _vat.ilks(_ilks[i]);

            // Rate must be gt 0%
            // Must not have been poked more recently than sec ago
            // Outstanding debt must be gt 0
            if (_duty > _min && _rho <= _sub(block.timestamp, sec) && _Art > 0) {
                buf[count] = _ilks[i];
                count++;
            }
        }

        bytes32[] memory ilks = new bytes32[](count);

        for (uint256 i = 0; i < count; i++) {
            ilks[i] = buf[i];
        }

        return ilks;
    }

    // Default to 1 day ago.
    function undripped() external view returns (bytes32[] memory ilks) {
        return _undripped(24 hours);
    }

    // Return the array of ilks that were last poked more than sec ago
    function undripped(uint256 sec) external view returns (bytes32[] memory ilks) {
        return _undripped(sec);
    }
}
