%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from tests.setup import deploy, Addresses, NAME, SYMBOL
from tests.interface import Poap

@external
func test_views{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    let addresses = deploy();

    let (name) = Poap.name(addresses.poap);
    assert name = NAME;

    let (symbol) = Poap.symbol(addresses.poap);
    assert symbol = SYMBOL;

    return ();
}

@external
func test_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let addresses = deploy();

    let event_id = 1;
    %{ stop_prank_callable = start_prank(ids.addresses.admin1, ids.addresses.poap) %}
    Poap.mintToken(addresses.poap, event_id, addresses.admin2);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.addresses.admin2, ids.addresses.poap) %}
    Poap.mintToken(addresses.poap, event_id, addresses.admin1);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.addresses.admin3, ids.addresses.poap) %}
    Poap.mintToken(addresses.poap, event_id, addresses.admin1);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.addresses.user, ids.addresses.poap) %}
    %{ expect_revert(error_message="Account is not minter or admin") %}
    Poap.mintToken(addresses.poap, event_id, addresses.admin1);
    %{ stop_prank_callable() %}

    return ();
}

@external
func test_mint_token_with_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let addresses = deploy();

    let event_id = 1;
    let token1_id = Uint256(1, 0);
    let token2_id = Uint256(2, 0);

    %{ stop_prank_callable = start_prank(ids.addresses.admin1, ids.addresses.poap) %}
    Poap.mintTokenWithId(addresses.poap, event_id, token1_id, addresses.admin2);
    Poap.mintTokenWithId(addresses.poap, event_id, token2_id, addresses.admin2);

    %{ expect_revert(error_message="ERC721: token already minted") %}
    Poap.mintTokenWithId(addresses.poap, event_id, token1_id, addresses.user);
    %{ stop_prank_callable() %}

    return ();
}

@external
func test_mint_event_to_many{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let addresses = deploy();

    let event_id = 1;
    local users: felt* = new (
        addresses.admin1, addresses.admin2, addresses.admin3, addresses.minter, addresses.user
    );

    %{ stop_prank_callable = start_prank(ids.addresses.admin1, ids.addresses.poap) %}
    Poap.mintEventToManyUsers(addresses.poap, event_id, 5, users);

    return ();
}
