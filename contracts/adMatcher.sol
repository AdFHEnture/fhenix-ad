// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;

import "@fhenixprotocol/contracts/FHE.sol";
import {Permissioned, Permission} from "@fhenixprotocol/contracts/access/Permissioned.sol";

contract AdMatcher is Permissioned {
    bool[][] public adMatrix;
    mapping(address => ebool[]) public userVectors;
    address public owner;

    constructor() {
        owner = msg.sender;

        adMatrix.push([true, false, false, false, false, false, false, false, false, false]);
        adMatrix.push([false, false, false, false, false, false, false, false, false, false]);
        adMatrix.push([false, false, false, false, false, false, false, false, false, false]);
        adMatrix.push([true, true, true, true, true, true, true, true, true, true]);
        adMatrix.push([false, false, false, false, false, false, false, false, false, false]);
        adMatrix.push([false, false, true, false, true, true, false, true, false, true]);
        adMatrix.push([true, false, true, false, true, true, false, true, false, true]);
        adMatrix.push([true, true, true, true, true, true, true, true, true, true]);
    }

    function addUserVector(bool[] calldata userVector) public {
        ebool[] memory encryptedUserVector = new ebool[](userVector.length);
        for (uint256 i = 0; i < userVector.length; i++) {
            encryptedUserVector[i] = FHE.asEbool(userVector[i]);
        }
        userVectors[msg.sender] = encryptedUserVector;
    }

    function addAd(bool[] calldata ad) public {
        adMatrix.push(ad);
    }

    function findBestAdFromSenderAddress(Permission memory permission) public view onlySender(permission) returns (uint256) {
        euint8 [] memory encryptedScores = findBestAdMemory(userVectors[msg.sender]);

        uint8[] memory scores = new uint8[](encryptedScores.length);
        for (uint256 i = 0; i < encryptedScores.length; i++) {
            scores[i] = FHE.decrypt(encryptedScores[i]);
        }

        uint256 bestAdIndex = 0;
        uint256 bestScore = 0;
        for (uint256 i = 0; i < scores.length; i++) {
            if (scores[i] > bestScore) {
                bestScore = scores[i];
                bestAdIndex = i;
            }
        }

        return bestAdIndex;
    }

    function findBestAdMemory(ebool[] memory encryptedUserVector) private view returns (euint8[] memory) {
        euint8[] memory encryptedScores = new euint8[](adMatrix.length);

        for (uint256 i = 0; i < adMatrix.length; i++) {
            euint8 sum = FHE.asEuint8(0);
            for (uint256 j = 0; j < encryptedUserVector.length; j++) {
                if(adMatrix[i][j]) {
                    sum = sum + FHE.asEuint8(encryptedUserVector[j]);
                }
            }
            encryptedScores[i] = sum;
        }

        return encryptedScores;

    }

    function findBestAd(inEbool[] calldata encryptedUserVector) private view returns (euint8[] memory) {
        euint8[] memory encryptedScores = new euint8[](adMatrix.length);

        for (uint256 i = 0; i < adMatrix.length; i++) {
            euint8 sum = FHE.asEuint8(0);
            for (uint256 j = 0; j < encryptedUserVector.length; j++) {
                if(adMatrix[i][j]) {
                    sum = sum + FHE.asEuint8(FHE.asEbool(encryptedUserVector[j]));
                }
            }
            encryptedScores[i] = sum;
        }

        return encryptedScores;

    }

    function findBestAdPermitSealedFromSenderAddress(Permission memory permission) 
        public view onlySender(permission) returns (uint256) {
        euint8 [] memory encryptedScores = findBestAdMemory(userVectors[msg.sender]);

        uint8[] memory scores = new uint8[](encryptedScores.length);
        for (uint256 i = 0; i < encryptedScores.length; i++) {
            scores[i] = FHE.decrypt(encryptedScores[i]);
        }

        uint256 bestAdIndex = 0;
        uint256 bestScore = 0;
        for (uint256 i = 0; i < scores.length; i++) {
            if (scores[i] > bestScore) {
                bestScore = scores[i];
                bestAdIndex = i;
            }
        }

        return bestAdIndex;
    }

    function findBestAdPermitSealed(inEbool[] calldata encryptedUserVector, Permission memory permission) 
        public view onlySender(permission) returns (uint256) {
        euint8 [] memory encryptedScores = findBestAd(encryptedUserVector);

        uint8[] memory scores = new uint8[](encryptedScores.length);
        for (uint256 i = 0; i < encryptedScores.length; i++) {
            scores[i] = FHE.decrypt(encryptedScores[i]);
        }

        uint256 bestAdIndex = 0;
        uint256 bestScore = 0;
        for (uint256 i = 0; i < scores.length; i++) {
            if (scores[i] > bestScore) {
                bestScore = scores[i];
                bestAdIndex = i;
            }
        }

        return bestAdIndex;
    }
}
