%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from poap.library import Poap
from pausable.library import PoapPausable
from roles.library import PoapRoles

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, symbol: felt, uri_len: felt, uri: felt*, admins_len: felt, admins: felt*
) {
    Poap.initialize(name, symbol, uri_len, uri, admins_len, admins);
    return ();
}

// VIEWS
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
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    address: felt
) {
    let owner = Poap.owner_of(tokenId);
    return (owner,);
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
    owner: felt, index: Uint256
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

@view
func paused{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let res = PoapPausable.paused();

    return (res,);
}

@external
func isEventMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eventId: felt, address: felt
) -> (res: felt) {
    let res = PoapRoles.is_event_minter(eventId, address);
    return (res,);
}

// CORE FUNCTIONALITIES
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

@external
func transferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256
) {
    Poap.transfer_from(from_, to, tokenId);
    return ();
}

@external
func mintToken{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    event_id: felt, to: felt
) {
    Poap.mint_token(event_id, to);
    return ();
}

@external
func mintTokenWithId{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    event_id: felt, token_id: Uint256, to: felt
) {
    Poap.mint_token_with_id(event_id, token_id, to);
    return ();
}

@external
func mintEventToManyUsers{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    event_id: felt, to_len: felt, to: felt*
) {
    Poap.mint_event_to_many_users(event_id, to_len, to, 0);
    return ();
}

@external
func mintUserToManyEvents{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    events_len: felt, events: felt*, to: felt
) {
    Poap.mint_user_to_many_events(events_len, events, to, 0);
    return ();
}

// PAUSABLE
@external
func pause{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    PoapPausable.pause();
    return ();
}

@external
func unpause{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    PoapPausable.unpause();
    return ();
}

// ROLES
@external
func addEventMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eventId: felt, account: felt
) {
    PoapRoles.add_event_minter(eventId, account);
    return ();
}

@external
func removeEventMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eventId: felt, account: felt
) {
    PoapRoles.remove_event_minter(eventId, account);
    return ();
}

@external
func renounceEventMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eventId: felt
) {
    PoapRoles.renounce_event_minter(eventId);
    return ();
}

@external
func renounceAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    PoapRoles.renounce_admin();
    return ();
}
