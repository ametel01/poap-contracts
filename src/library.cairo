%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from openzeppelin.token.erc721.library import ERC721

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
func Poap_lastId() -> (res: felt) {
}

// EventId for each token
@storage_var
func Poap_tokenEvent(tokenId: felt) -> (res: felt) {
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
    func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> felt {
        let res = Poap_symbol.read();
        return res;
    }
}
