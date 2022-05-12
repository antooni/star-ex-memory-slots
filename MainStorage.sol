/*
  Copyright 2019-2021 StarkWare Industries Ltd.

  Licensed under the Apache License, Version 2.0 (the "License").
  You may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  https://www.starkware.co/open-source-license/

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions
  and limitations under the License.
*/
// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.11;

import "ProxyStorage.sol";
import "Common.sol";

/*
  Holds ALL the main contract state (storage) variables.
*/
contract MainStorage is ProxyStorage {
    uint256 internal constant LAYOUT_LENGTH = 2**64;

    address escapeVerifierAddress; // NOLINT: constable-states. // 4

    // Global dex-frozen flag.
    bool stateFrozen; // NOLINT: constable-states. // 5

    // Time when unFreeze can be successfully called (UNFREEZE_DELAY after freeze).
    uint256 unFreezeTime; // NOLINT: constable-states. // 6

    // Pending deposits.
    // A map STARK key => asset id => vault id => quantized amount.
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) pendingDeposits; // 7

    // Cancellation requests.
    // A map STARK key => asset id => vault id => request timestamp.
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) cancellationRequests; // 8

    // Pending withdrawals.
    // A map STARK key => asset id => quantized amount.
    mapping(uint256 => mapping(uint256 => uint256)) pendingWithdrawals; // 9

    // vault_id => escape used boolean.
    mapping(uint256 => bool) escapesUsed; //10

    // Number of escapes that were performed when frozen.
    uint256 escapesUsedCount; // NOLINT: constable-states. // 11

    // NOTE: fullWithdrawalRequests is deprecated, and replaced by forcedActionRequests.
    // NOLINTNEXTLINE naming-convention.
    mapping(uint256 => mapping(uint256 => uint256)) fullWithdrawalRequests_DEPRECATED; //12

    // State sequence number.
    uint256 sequenceNumber; // NOLINT: constable-states uninitialized-state. //13

    // Vaults Tree Root & Height.
    uint256 vaultRoot; // NOLINT: constable-states uninitialized-state. // 14
    uint256 vaultTreeHeight; // NOLINT: constable-states uninitialized-state. // 15

    // Order Tree Root & Height.
    uint256 orderRoot; // NOLINT: constable-states uninitialized-state. // 16
    uint256 orderTreeHeight; // NOLINT: constable-states uninitialized-state. // 17

    // True if and only if the address is allowed to add tokens.
    mapping(address => bool) tokenAdmins; // 18

    // This mapping is no longer in use, remains for backwards compatibility.
    mapping(address => bool) userAdmins_DEPRECATED; // NOLINT: naming-convention. //19

    // True if and only if the address is an operator (allowed to update state).
    mapping(address => bool) operators; // 20

    // Mapping of contract ID to asset data.
    mapping(uint256 => bytes) assetTypeToAssetInfo; // NOLINT: uninitialized-state. // 21

    // Mapping of registered contract IDs.
    mapping(uint256 => bool) registeredAssetType; // NOLINT: uninitialized-state. // 22

    // Mapping from contract ID to quantum.
    mapping(uint256 => uint256) assetTypeToQuantum; // NOLINT: uninitialized-state. // 23

    // This mapping is no longer in use, remains for backwards compatibility.
    mapping(address => uint256) starkKeys_DEPRECATED; // NOLINT: naming-convention. // 24

    // Mapping from STARK public key to the Ethereum public key of its owner.
    mapping(uint256 => address) ethKeys; // NOLINT: uninitialized-state. // 25

    // Timelocked state transition and availability verification chain.
    StarkExTypes.ApprovalChainData verifiersChain;
    StarkExTypes.ApprovalChainData availabilityVerifiersChain;

    // Batch id of last accepted proof.
    uint256 lastBatchId; // NOLINT: constable-states uninitialized-state. // 26

    // Mapping between sub-contract index to sub-contract address.
    mapping(uint256 => address) subContracts; // NOLINT: uninitialized-state. // 27

    mapping(uint256 => bool) permissiveAssetType_DEPRECATED; // NOLINT: naming-convention.
    // ---- END OF MAIN STORAGE AS DEPLOYED IN STARKEX2.0 ----

    // Onchain-data version configured for the system.
    uint256 onchainDataVersion; // NOLINT: constable-states uninitialized-state.

    // Counter of forced action request in block. The key is the block number.
    mapping(uint256 => uint256) forcedRequestsInBlock;

    // ForcedAction requests: actionHash => requestTime.
    mapping(bytes32 => uint256) forcedActionRequests;

    // Mapping for timelocked actions.
    // A actionKey => activation time.
    mapping(bytes32 => uint256) actionsTimeLock;

    // Append only list of requested forced action hashes.
    bytes32[] actionHashList;

    // Reserved storage space for Extensibility.
    // Every added MUST be added above the end gap, and the __endGap size must be reduced
    // accordingly.
    // NOLINTNEXTLINE: naming-convention.
    uint256[LAYOUT_LENGTH - 37] private __endGap; // __endGap complements layout to LAYOUT_LENGTH.
}
