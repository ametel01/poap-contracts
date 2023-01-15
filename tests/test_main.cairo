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
