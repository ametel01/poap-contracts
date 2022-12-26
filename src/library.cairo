%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from openzeppelin.token.erc721.library import ERC721
from ERC721_metadata import ERC721_metadata

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
        let res = Poap_name.read();
        return name;
    }

    // @dev Gets the token symbol
    // @return string representing the token symbol
    func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> felt {
        let res = Poap_symbol.read();
        return res;
    }

    func token_event{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> felt {
        let res = Poap_tokenEvent.read(token_id);
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
    func token_URI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        tokenId: Uint256
    ) -> (uri_len: felt, token_uri: felt*) {
        let (uri_len, uri) = ERC721_metadata.baseTokenURI(tokenId);
        return (uri_len, uri);
    }

    func set_base_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        base_token_uri_len: felt, base_token_uri: felt*
    ) {
        ERC721_metadata.setBaseTokenURI(base_token_uri_len, base_token_uri);
        return ();
    }
}
