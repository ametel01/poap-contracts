%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace Poap {
    func name() -> (res: felt) {
    }

    func symbol() -> (res: felt) {
    }

    func ownerOf(token_id: Uint256) -> (res: felt) {
    }

    func tokenEvent(token_id: Uint256) -> (res: felt) {
    }

    func tokenDetailsOfOwnerByIndex(owner: felt, index: Uint256) -> (
        tokenId: Uint256, eventId: felt
    ) {
    }

    func isEventMinter(event_id: felt, address: felt) -> (res: felt) {
    }

    func mintToken(event_id: felt, to: felt) {
    }

    func mintTokenWithId(event_id: felt, token_id: Uint256, to: felt) {
    }

    func mintEventToManyUsers(event_id: felt, to_len: felt, to: felt*) {
    }

    func mintUserToManyEvents(events_len: felt, events: felt*, to: felt) {
    }

    func paused() -> (res: felt) {
    }

    func pause() {
    }

    func unpause() {
    }

    func addAdmin(account: felt) {
    }

    func addEventMinter(eventId: felt, account: felt) {
    }

    func removeEventMinter(eventId: felt, account: felt) {
    }

    func renounceEventMinter(eventId: felt) {
    }

    func renounceAdmin() {
    }
}
