%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.uint256 import Uint256, uint256_add
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.token.erc721.enuerable import ERC721Enumerable
from erc721.library import ERC721_metadata
from pausable.library import PoapPausable
from roles.library import PoapRoles

@event
func EventToken(event_id: felt, token_id: Uint256) {
}

// token name
@storage_var
func Poap_name() -> (res: felt) {
}

// token symbol
@storage_var
func Poap_symbol() -> (res: felt) {
}

// token URI
@storage_var
func Poap_baseURI() -> (res: felt) {
}

// Last Used id (used to generate new ids)
@storage_var
func Poap_lastId() -> (token_id: Uint256) {
}

// EventId for each token
@storage_var
func Poap_tokenEvent(token_id: Uint256) -> (event_id: felt) {
}

@storage_var
func Poap_token_of_owner_by_index(token_index: felt, owner: felt) -> (token_id: Uint256) {
}

namespace Poap {
    // @dev Gets the token name
    // @return string representing the token name
    func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> felt {
        let (res) = Poap_name.read();
        return res;
    }

    // @dev Gets the token symbol
    // @return string representing the token symbol
    func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> felt {
        let (res) = Poap_symbol.read();
        return res;
    }

    func token_event{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> felt {
        let (res) = Poap_tokenEvent.read(token_id);
        return res;
    }

    // @dev Gets the token ID at a given index of the tokens list of the requested owner
    // @param owner address owning the tokens list to be accessed
    // @param index uint256 representing the index to be accessed of the requested tokens list
    // @return uint256 token ID at the given index of the tokens list owned by the requested address
    func token_details_of_owner_by_index{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(owner: felt, index: felt) -> (token_id: Uint256, event_id: felt) {
        let (token_id) = Poap_token_of_owner_by_index.read(owner, index);
        let (event_id) = Poap_tokenEvent.read(token_id);
        return (token_id, event_id);
    }

    // @dev Gets the token uri
    // @return string representing the token uri
    func token_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (uri_len: felt, token_uri: felt*) {
        let (uri_len, uri) = ERC721_metadata.tokenURI(token_id);
        return (uri_len, uri);
    }

    func set_base_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        base_token_uri_len: felt, base_token_uri: felt*
    ) {
        PoapRoles.only_admin();
        PoapPausable.when_not_paused();
        ERC721_metadata.setBaseTokenURI(base_token_uri_len, base_token_uri);
        return ();
    }

    func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to: felt, token_id: Uint256
    ) {
        PoapPausable.when_not_paused();
        ERC721.approve(to, token_id);
        return ();
    }

    func set_approval_for_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to: felt, approved: felt
    ) {
        PoapPausable.when_not_paused();
        ERC721.set_approval_for_all(to, approved);
        return ();
    }

    func transfer_from{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        from_: felt, to: felt, token_id: Uint256
    ) {
        PoapPausable.when_not_paused();
        ERC721.transfer_from(from_, to, token_id);
        return ();
    }

    // @dev Function to mint tokens
    // @param eventId EventId for the new token
    // @param to The address that will receive the minted tokens.
    // @return A boolean that indicates if the operation was successful.
    func mint_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        event_id: felt, to: felt
    ) {
        PoapRoles.only_event_minter();
        PoapPausable.when_not_paused();
        let last_id = Poap_lastId.read();
        let current_id = uint256_add(last_id, Uint256(1, 0));
        return _mint_token(event_id, current_id, to);
    }
    func mint_token_with_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        event_id: felt, token_id: Uint256, to: felt
    ) {
        PoapRoles.only_event_minter();
        PoapPausable.when_not_paused();
        return _mint_token(event_id, token_id, to);
    }

    // @dev Function to mint tokens
    // @param eventId EventId for the new token
    // @param to The address that will receive the minted tokens.
    // @return A boolean that indicates if the operation was successful.
    func mint_event_to_many_users{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        event_id: felt, to_len: felt, to: felt*, i: felt
    ) -> felt {
        PoapRoles.only_event_minter();
        PoapPausable.when_not_paused();
        if (i == to_len) {
            return (TRUE);
        }
        let last_id = Poap_lastId.read();
        let current_id = uint256_add(last_id, Uint256(1, 0));
        mint_token(event_id, current_id, to + i);
        Poap_lastId.write(current_id);
        return mint_event_to_many_users(event_id, to_len, to, i + 1);
    }

    // @dev Function to mint tokens
    // @param eventIds EventIds to assing to user
    // @param to The address that will receive the minted tokens.
    // @return A boolean that indicates if the operation was successful.
    func mint_user_to_many_events{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        events_len: felt, events: felt*, to: felt, i: felt
    ) -> felt {
        PoapRoles.only_admin();
        PoapPausable.when_not_paused();
        if (i == events_len) {
            return TRUE;
        }
        let last_id = Poap_lastId.read();
        let current_id = uint256_add(last_id, Uint256(1, 0));
        mint_token_with_id(events + i, current_id, to);
        Poap_lastId.write(current_id);
        return mint_user_to_many_events(events_len, events, to, i + 1);
    }

    // @dev Burns a specific ERC721 token.
    // @param tokenId uint256 id of the ERC721 token to be burned.
    func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(token_id: Uint256) {
        ERC721._burn(token_id);
        return ();
    }
}

func _mint_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    event_id: felt, token_id: Uint256, to: felt
) -> felt {
    ERC721._mint(to, token_id);
    Poap_tokenEvent.write(token_id, event_id);
    EventToken.emit(event_id, token_id);
    return TRUE;
}
