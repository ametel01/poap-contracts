%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from library import Poap

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let res = Poap.name();
    return (res,);
}

@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let res = Poap.symbol();
    return (res,);
}

@view
func tokenEvent{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (res: felt) {
    let res = Poap.token_event(tokenId);
    return (res,);
}

@view
func tokenDetailsOfOwnerByIndex{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, index: felt
) -> (tokenId: Uint256, eventId: felt) {
    let (tokenId, eventId) = Poap.token_details_of_owner_by_index(owner, index);
    return (tokenId, eventId);
}

@view
func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (uri_len: felt, uri: felt*) {
    let (uri_len, uri) = Poap.token_uri(tokenId);
    return (uri_len, uri);
}

@external
func setBaseURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    base_token_uri_len: felt, base_token_uri: felt*
) {
    Poap.set_base_uri(base_token_uri_len, base_token_uri);
    return ();
}

@external
func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, tokenId: Uint256
) {
    Poap.approve(to, tokenId);
    return ();
}

@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, approved: felt
) {
    Poap.set_approval_for_all(to, approved);
    return ();
}
