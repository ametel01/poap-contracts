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
// @dev Gets the token name.
// @return felt string representing the token name.
@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let res = Poap.name();
    return (res,);
}

// @dev Gets the token symbol.
// @return felt string representing the token symbol.
@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let res = Poap.symbol();
    return (res,);
}

// @dev Gets the owner of a specific token ID.
// @parmam tokenId representing an unique identifier of the token.
// @return the address of the owner of the token.
@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    address: felt
) {
    let owner = Poap.owner_of(tokenId);
    return (owner,);
}

// @dev Gets the ID of the event a token is associated to.
// @parmam tokenId representing an unique identifier of the token.
// @return a felt representing the ID of the event.
@view
func tokenEvent{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (res: felt) {
    let res = Poap.token_event(tokenId);
    return (res,);
}

// @dev Gets the token ID at a given index of the tokens list of the requested owner.
// @param owner address owning the tokens list to be accessed.
// @param index uint256 representing the index to be accessed of the requested tokens list.
// @return uint256 token ID at the given index of the tokens list owned by the requested address.
@view
func tokenDetailsOfOwnerByIndex{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, index: Uint256
) -> (tokenId: Uint256, eventId: felt) {
    let (tokenId, eventId) = Poap.token_details_of_owner_by_index(owner, index);
    return (tokenId, eventId);
}

// @dev Gets the token uri.
// @return string representing the token uri.
@view
func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (uri_len: felt, uri: felt*) {
    let (uri_len, uri) = Poap.token_uri(tokenId);
    return (uri_len, uri);
}

// @dev Gets the state of the contract, if paused no mint or transfer will be allowed.
// @return a felt represting the status: 1 for TRUE, 0 for FALSE.
@view
func paused{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let res = PoapPausable.paused();

    return (res,);
}

// @dev Gets the permission level of an address on a specific event.
// @param eventId the unique Id of the event we are quering for.#
// @param address the address of the account we are quering for.
// @return a felt represting the status: 1 for TRUE, 0 for FALSE.
@view
func isEventMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eventId: felt, address: felt
) -> (res: felt) {
    let res = PoapRoles.is_event_minter(eventId, address);
    return (res,);
}

// CORE FUNCTIONALITIES

// @dev Sets the base URI, in the format of 1 felt for each character of the URI.
// @param base_token_uri_len the number of felts composing the URI.
// @param base_token_uri a pointer to the first felt composing the URI.
@external
func setBaseURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    base_token_uri_len: felt, base_token_uri: felt*
) {
    Poap.set_base_uri(base_token_uri_len, base_token_uri);
    return ();
}

// @dev Gives permission to to to transfer tokenId token to another account.
// The approval is cleared when the token is transferred.
// @param to the address that is approved to tranfer the token.
// @param tokenId the unique ID of the token approved for the tranfer.
@external
func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, tokenId: Uint256
) {
    Poap.approve(to, tokenId);
    return ();
}

// @dev Approve or remove operator as an operator for the caller.
// Operators can call transferFrom or safeTransferFrom for any token owned by the caller.
// @param to the address the change of approval refers to.
@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, approved: felt
) {
    Poap.set_approval_for_all(to, approved);
    return ();
}

// @dev Transfers tokenId token from from_ to to.
// The caller is responsible to confirm that to is capable of receiving NFTs or else they may be permanently lost.
// @param from_ the current owner of the token.
// @param to the address to which the token will be sent to.
// @param tokenId the unique ID of the token to be transferred.
@external
func transferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256
) {
    Poap.transfer_from(from_, to, tokenId);
    return ();
}

// @dev Function to mint tokens
// @param eventId EventId for the new token
// @param to The address that will receive the minted tokens.
@external
func mintToken{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eventId: felt, to: felt
) {
    Poap.mint_token(eventId, to);
    return ();
}

// @dev Function that transfers a token with a spefic ID.
// @param eventId the unique ID of the event.
// @param tokenId the unique ID of the token.
// @param to the address to which the token will be tranferred.
@external
func mintTokenWithId{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eventId: felt, tokenId: Uint256, to: felt
) {
    Poap.mint_token_with_id(eventId, tokenId, to);
    return ();
}

// @dev Function to mint tokens
// @param eventId EventId for the new token
// @param to The address that will receive the minted tokens.
@external
func mintEventToManyUsers{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    event_id: felt, to_len: felt, to: felt*
) {
    Poap.mint_event_to_many_users(event_id, to_len, to, 0);
    return ();
}

// @dev Function to mint tokens
// @param eventIds EventIds to assing to user
// @param to The address that will receive the minted tokens.
@external
func mintUserToManyEvents{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    events_len: felt, events: felt*, to: felt
) {
    Poap.mint_user_to_many_events(events_len, events, to, 0);
    return ();
}

// PAUSABLE

// @dev called by the owner to pause, triggers stopped state
@external
func pause{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    PoapPausable.pause();
    return ();
}

// @dev called by the owner to unpause, returns to normal state
@external
func unpause{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    PoapPausable.unpause();
    return ();
}

// ROLES

// @dev Gives admin permissions to an account.
// @param account the address of the account to be given admin permissions.
@external
func addAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) {
    PoapRoles.add_admin(account);
    return ();
}

// @dev Gives event minter permissions to a specific event to an account.
// @param eventId the unique ID of the event.
// @param account the address of the account to be given event minter permissions.
@external
func addEventMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eventId: felt, account: felt
) {
    PoapRoles.add_event_minter(eventId, account);
    return ();
}

// @dev Removes event minter permissions for a specific event to an account.
// @param eventId the unique ID of the event.
// @param account the address of the account to be given event minter permissions.
@external
func removeEventMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eventId: felt, account: felt
) {
    PoapRoles.remove_event_minter(eventId, account);
    return ();
}

// @dev Allows an event minter to renounce to minter permissions.
// @param eventId the unique ID of the event.
@external
func renounceEventMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eventId: felt
) {
    PoapRoles.renounce_event_minter(eventId);
    return ();
}

// @dev Allows an admin to renounce to admin permissions.
@external
func renounceAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    PoapRoles.renounce_admin();
    return ();
}
