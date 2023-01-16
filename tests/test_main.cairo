%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from tests.setup import deploy, Addresses, NAME, SYMBOL
from tests.interface import Poap

@external
func test_views{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    let addresses = deploy();

    let (name) = Poap.name(addresses.poap);
    assert name = NAME;

    let (symbol) = Poap.symbol(addresses.poap);
    assert symbol = SYMBOL;

    let event_id = 1;
    let token_id = Uint256(1, 0);
    %{ stop_prank_callable = start_prank(ids.addresses.admin1, ids.addresses.poap) %}
    Poap.mintToken(addresses.poap, event_id, addresses.admin2);

    let (owner) = Poap.ownerOf(addresses.poap, token_id);
    assert owner = addresses.admin2;

    let (event) = Poap.tokenEvent(addresses.poap, token_id);
    assert event = event_id;

    return ();
}

@external
func test_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let addresses = deploy();

    let event_id = 1;
    let token1_id = Uint256(1, 0);
    let token2_id = Uint256(2, 0);
    let token3_id = Uint256(3, 0);

    %{ stop_prank_callable = start_prank(ids.addresses.admin1, ids.addresses.poap) %}
    Poap.mintToken(addresses.poap, event_id, addresses.admin2);
    let (owner) = Poap.ownerOf(addresses.poap, token1_id);
    assert owner = addresses.admin2;
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.addresses.admin2, ids.addresses.poap) %}
    Poap.mintToken(addresses.poap, event_id, addresses.admin1);
    let (owner) = Poap.ownerOf(addresses.poap, token2_id);
    assert owner = addresses.admin1;
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.addresses.admin3, ids.addresses.poap) %}
    Poap.mintToken(addresses.poap, event_id, addresses.admin1);
    let (owner) = Poap.ownerOf(addresses.poap, token3_id);
    assert owner = addresses.admin1;
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
    let token2_id = Uint256(99, 0);

    %{ stop_prank_callable = start_prank(ids.addresses.admin1, ids.addresses.poap) %}
    Poap.mintTokenWithId(addresses.poap, event_id, token1_id, addresses.admin2);
    let (owner) = Poap.ownerOf(addresses.poap, token1_id);
    assert owner = addresses.admin2;

    Poap.mintTokenWithId(addresses.poap, event_id, token2_id, addresses.admin2);
    let (owner) = Poap.ownerOf(addresses.poap, token2_id);
    assert owner = addresses.admin2;

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

    let (owner) = Poap.ownerOf(addresses.poap, Uint256(1, 0));
    assert owner = users[0];

    let (owner) = Poap.ownerOf(addresses.poap, Uint256(2, 0));
    assert owner = users[1];

    let (owner) = Poap.ownerOf(addresses.poap, Uint256(3, 0));
    assert owner = users[2];

    let (owner) = Poap.ownerOf(addresses.poap, Uint256(4, 0));
    assert owner = users[3];

    let (owner) = Poap.ownerOf(addresses.poap, Uint256(5, 0));
    assert owner = users[4];

    return ();
}

@external
func test_mint_user_to_many_events{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;
    let addresses = deploy();

    local events: felt* = new (1, 2, 3, 4, 5);
    %{ stop_prank_callable = start_prank(ids.addresses.admin1, ids.addresses.poap) %}
    Poap.mintUserToManyEvents(addresses.poap, 5, events, addresses.user);

    let (token_id, event_id) = Poap.tokenDetailsOfOwnerByIndex(
        addresses.poap, addresses.user, Uint256(0, 0)
    );
    assert token_id = Uint256(1, 0);
    assert event_id = 1;

    let (token_id, event_id) = Poap.tokenDetailsOfOwnerByIndex(
        addresses.poap, addresses.user, Uint256(1, 0)
    );
    assert token_id = Uint256(2, 0);
    assert event_id = 2;

    let (token_id, event_id) = Poap.tokenDetailsOfOwnerByIndex(
        addresses.poap, addresses.user, Uint256(2, 0)
    );
    assert token_id = Uint256(3, 0);
    assert event_id = 3;

    let (token_id, event_id) = Poap.tokenDetailsOfOwnerByIndex(
        addresses.poap, addresses.user, Uint256(3, 0)
    );
    assert token_id = Uint256(4, 0);
    assert event_id = 4;

    let (token_id, event_id) = Poap.tokenDetailsOfOwnerByIndex(
        addresses.poap, addresses.user, Uint256(4, 0)
    );
    assert token_id = Uint256(5, 0);
    assert event_id = 5;

    return ();
}

@external
func test_pause_unpause{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let addresses = deploy();

    let event_id = 1;
    Poap.pause(addresses.poap);
    let (is_paused) = Poap.paused(addresses.poap);
    assert is_paused = TRUE;

    %{ expect_revert(error_message="Poap requires to not be paused") %}
    Poap.mintToken(addresses.poap, event_id, addresses.user);

    Poap.unpause(addresses.poap);
    let (is_paused) = Poap.paused(addresses.poap);
    assert is_paused = FALSE;
    Poap.mintToken(addresses.poap, event_id, addresses.user);

    return ();
}

@external
func test_add_remove_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let addresses = deploy();

    let event_id = 1;
    let (caller) = get_caller_address();
    %{ print(f"caller address: {ids.caller}") %}
    Poap.addEventMinter(addresses.poap, event_id, addresses.minter);
    let (is_minter) = Poap.isEventMinter(addresses.poap, event_id, addresses.minter);
    assert is_minter = TRUE;

    %{
        stop_prank_callable = start_prank(ids.addresses.user, ids.addresses.poap)
        expect_revert(error_message="Message sender is not admim")
    %}
    Poap.removeEventMinter(addresses.poap, event_id, addresses.minter);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.addresses.admin1, ids.addresses.poap) %}
    Poap.removeEventMinter(addresses.poap, event_id, addresses.minter);
    let (is_minter) = Poap.isEventMinter(addresses.poap, event_id, addresses.minter);
    assert is_minter = FALSE;

    %{
        stop_prank_callable = start_prank(ids.addresses.user, ids.addresses.poap)
        expect_revert(error_message="Message sender is not admim")
    %}
    Poap.removeEventMinter(addresses.poap, event_id, addresses.minter);

    return ();
}

@external
func test_renounce_admin_and_minter{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    let addresses = deploy();
    let event_id = 1;

    Poap.addEventMinter(addresses.poap, event_id, addresses.minter);
    let (is_minter) = Poap.isEventMinter(addresses.poap, event_id, addresses.minter);
    assert is_minter = TRUE;

    let (is_minter) = Poap.isEventMinter(addresses.poap, event_id, addresses.minter);
    assert is_minter = TRUE;

    %{ stop_prank_callable = start_prank(ids.addresses.minter, ids.addresses.poap) %}
    Poap.renounceEventMinter(addresses.poap, event_id);
    let (is_minter) = Poap.isEventMinter(addresses.poap, event_id, addresses.minter);
    assert is_minter = FALSE;
    %{ stop_prank_callable() %}

    let (is_minter) = Poap.isEventMinter(addresses.poap, event_id, addresses.admin3);
    assert is_minter = TRUE;
    %{ stop_prank_callable = start_prank(ids.addresses.admin3, ids.addresses.poap) %}
    Poap.renounceAdmin(addresses.poap);

    let (is_minter) = Poap.isEventMinter(addresses.poap, event_id, addresses.admin3);
    assert is_minter = FALSE;

    return ();
}
