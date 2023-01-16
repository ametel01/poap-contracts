%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace Poap {
    func name() -> (res: felt) {
    }

    func symbol() -> (res: felt) {
    }

    func tokenEvent(token1_id: Uint256) -> (res: felt) {
    }

    func mintToken(event_id: felt, to: felt) {
    }

    func mintTokenWithId(event_id: felt, token_id: Uint256, to: felt) {
    }

    func mintEventToManyUsers(event_id: felt, to_len: felt, to: felt*) {
    }
}
